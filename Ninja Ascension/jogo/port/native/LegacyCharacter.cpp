#include "LegacyCharacter.h"
#include "2d/AutoPolygon.h"
#include "ImGui/imgui.h"
#include <spine/spine.h>
#include <spine/extension.h>
#include <algorithm>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <stdexcept>
#include "rapidjson/document.h"
#include "lua-bindings/manual/LuaBasicConversions.h"
#include "lua-bindings/manual/LuaEngine.h"

extern "C" {
char* _spUtil_readFile(const char* path,int* length) {
    auto bytes=ax::FileUtils::getInstance()->getDataFromFile(path);
    if(bytes.isNull() || bytes.getSize()>INT_MAX)return nullptr;
    auto result=static_cast<char*>(malloc(bytes.getSize()+1));
    if(!result)return nullptr;
    memcpy(result,bytes.getBytes(),bytes.getSize());result[bytes.getSize()]=0;
    *length=static_cast<int>(bytes.getSize());return result;
}
void _spAtlasPage_createTexture(spAtlasPage* page,const char* path) {
    auto texture=ax::Director::getInstance()->getTextureCache()->addImage(path);
    if(!texture)return;
    texture->retain();page->rendererObject=texture;
    page->width=texture->getPixelsWide();page->height=texture->getPixelsHigh();
}
void _spAtlasPage_disposeTexture(spAtlasPage* page) {
    if(auto texture=static_cast<ax::Texture2D*>(page->rendererObject))texture->release();
}
}
namespace nr {
struct LegacyCharacter::State {
    spAtlas* atlas{};
    spSkeletonData* data{};
    spSkeleton* skeleton{};
    std::vector<ax::RefPtr<ax::Sprite>> sprites;
    int animation=0;
    float time=0,speed=1;
    bool paused=false;
    bool loop=true;
    spAnimationStateData* mixing{};
    spAnimationState* player{};
    struct Event {int type,track,loops,intValue;float floatValue;std::string animation,name,text;};
    std::vector<Event> events;
    ~State(){if(player)spAnimationState_dispose(player);if(mixing)spAnimationStateData_dispose(mixing);if(skeleton)spSkeleton_dispose(skeleton);if(data)spSkeletonData_dispose(data);if(atlas)spAtlas_dispose(atlas);}
};
LegacyCharacter::LegacyCharacter():state(std::make_unique<State>()){}
LegacyCharacter::~LegacyCharacter()=default;
LegacyCharacter* LegacyCharacter::create(const std::string& base,const std::string& atlasFile,float dataScale) {
    auto node=std::make_unique<LegacyCharacter>();
    if(!node->init())throw std::runtime_error("Character node initialization failed");
    auto& s=*node->state;
    auto files=ax::FileUtils::getInstance();
    s.atlas=spAtlas_createFromFile(files->fullPathForFilename(atlasFile.empty()?base+".atlas":atlasFile).c_str(),nullptr);
    if(!s.atlas)throw std::runtime_error("Legacy character atlas failed");
    for(auto page=s.atlas->pages;page;page=page->next)
        if(!page->rendererObject)throw std::runtime_error("Legacy character atlas page missing");
    auto reader=spSkeletonJson_create(s.atlas);
    reader->scale=dataScale;
    s.data=spSkeletonJson_readSkeletonDataFile(reader,files->fullPathForFilename(base+".json").c_str());
    std::string error=reader->error?reader->error:"";spSkeletonJson_dispose(reader);
    // Malformed legacy parser output is unsafe to dispose. Original validated input only.
    if(!error.empty()){s.data=nullptr;throw std::runtime_error("Spine 2.1: "+error);}
    if(!s.data || !s.data->animationsCount)throw std::runtime_error("Character has no animations");
    // Some recovered effects use Spine 3.x's `blend` spelling, while the
    // pinned 2.1 reader only understands the older `additive` boolean.
    // Restore additive slots from the asset, without changing its pixels.
    rapidjson::Document source;
    auto json=files->getStringFromFile(base+".json");
    source.Parse(json.c_str());
    if(!source.HasParseError() && source.IsObject() && source.HasMember("slots") && source["slots"].IsArray()) {
        for(const auto& slot:source["slots"].GetArray()) {
            if(!slot.IsObject() || !slot.HasMember("name") || !slot["name"].IsString()
                || !slot.HasMember("blend") || !slot["blend"].IsString())continue;
            if(std::strcmp(slot["blend"].GetString(),"additive")!=0)continue;
            auto data=spSkeletonData_findSlot(s.data,slot["name"].GetString());
            if(data)data->additiveBlending=1;
        }
    }
    s.skeleton=spSkeleton_create(s.data);
    for(int i=0;i<s.data->animationsCount;++i)
        if(std::string(s.data->animations[i]->name)=="00_daiji")s.animation=i;
    for(int i=0;i<s.skeleton->slotsCount;++i){
        auto sprite=ax::Sprite::create();sprite->setAnchorPoint(ax::Vec2::ZERO);
        node->addChild(sprite,i);s.sprites.emplace_back(sprite);
    }
    node->scheduleUpdate();node->update(0);node->autorelease();return node.release();
}
void LegacyCharacter::update(float dt) {
    ax::RefPtr<LegacyCharacter> keepAlive(this);
    auto& s=*state;
    if(!s.paused)s.time+=dt*s.speed;
    // AnimationState preserves discrete attachment/flip keys between frames.
    // Resetting its slots each tick would undo keys that are not fired again.
    if(!s.player)spSkeleton_setToSetupPose(s.skeleton);
    // Each frame is evaluated from setup pose, so discrete attachment/flip keys
    // must be applied from the start as well (lastTime=-1).
    if(s.player){spAnimationState_update(s.player,s.paused?0:dt*s.speed);spAnimationState_apply(s.player,s.skeleton);}
    else spAnimation_apply(s.data->animations[s.animation],s.skeleton,-1,s.time,s.loop,nullptr,nullptr);
    spSkeleton_updateWorldTransform(s.skeleton);
    for(int i=0;i<s.skeleton->slotsCount;++i){
        auto sprite=s.sprites[i];auto slot=s.skeleton->drawOrder[i];auto a=slot->attachment;
        sprite->setVisible(false);if(!a)continue;
        std::vector<float> xy;float* uv=nullptr;int* indices=nullptr;int count=0;
        int quadIndices[]={0,1,2,2,3,0};spAtlasRegion* region=nullptr;
        float r=1,g=1,b=1,alpha=1;
        if(a->type==SP_ATTACHMENT_REGION){
            auto v=reinterpret_cast<spRegionAttachment*>(a);xy.resize(8);
            spRegionAttachment_computeWorldVertices(v,slot->bone,xy.data());
            uv=v->uvs;indices=quadIndices;count=6;region=static_cast<spAtlasRegion*>(v->rendererObject);
            r=v->r;g=v->g;b=v->b;alpha=v->a;
        }else if(a->type==SP_ATTACHMENT_MESH){
            auto v=reinterpret_cast<spMeshAttachment*>(a);xy.resize(v->verticesCount);
            spMeshAttachment_computeWorldVertices(v,slot,xy.data());
            uv=v->uvs;indices=v->triangles;count=v->trianglesCount;region=static_cast<spAtlasRegion*>(v->rendererObject);
            r=v->r;g=v->g;b=v->b;alpha=v->a;
        }else if(a->type==SP_ATTACHMENT_SKINNED_MESH){
            auto v=reinterpret_cast<spSkinnedMeshAttachment*>(a);xy.resize(v->uvsCount);
            spSkinnedMeshAttachment_computeWorldVertices(v,slot,xy.data());
            uv=v->uvs;indices=v->triangles;count=v->trianglesCount;region=static_cast<spAtlasRegion*>(v->rendererObject);
            r=v->r;g=v->g;b=v->b;alpha=v->a;
        }else continue; // Bounding boxes are deliberately non-rendering.
        auto texture=static_cast<ax::Texture2D*>(region->page->rendererObject);
        bool pma=texture->hasPremultipliedAlpha();
        alpha*=slot->a*s.skeleton->a;
        auto channel=[](float v){return static_cast<uint8_t>(std::clamp(v,0.f,1.f)*255);};
        ax::Color4B color(channel(r*slot->r*s.skeleton->r*(pma?alpha:1)),
                          channel(g*slot->g*s.skeleton->g*(pma?alpha:1)),
                          channel(b*slot->b*s.skeleton->b*(pma?alpha:1)),channel(alpha));
        std::vector<ax::V3F_C4B_T2F> verts(xy.size()/2);
        std::vector<unsigned short> triangles(count);
        for(size_t j=0;j<verts.size();++j){
            if(!std::isfinite(xy[j*2])||!std::isfinite(xy[j*2+1]))throw std::runtime_error("Nonfinite character mesh");
            verts[j].vertices=ax::Vec3(xy[j*2],xy[j*2+1],0);verts[j].colors=color;
            verts[j].texCoords=ax::Tex2F(uv[j*2],uv[j*2+1]);
        }
        for(int j=0;j<count;++j){if(indices[j]<0 || indices[j]>=verts.size())throw std::runtime_error("Character mesh index out of range");triangles[j]=static_cast<unsigned short>(indices[j]);}
        ax::TrianglesCommand::Triangles mesh(verts.data(),triangles.data(),static_cast<unsigned>(verts.size()),count);
        ax::PolygonInfo polygon;polygon.setTriangles(mesh);polygon.setRect(ax::Rect(-2048,-2048,4096,4096));
        sprite->setTexture(texture);sprite->setPolygonInfo(polygon);
        auto blend=pma?ax::BlendFunc::ALPHA_PREMULTIPLIED:ax::BlendFunc::ALPHA_NON_PREMULTIPLIED;
        if(slot->data->additiveBlending)blend.dst=ax::backend::BlendFactor::ONE;
        sprite->setBlendFunc(blend);sprite->setVisible(true);
    }
    if(s.player&&!s.events.empty()){
        auto pending=std::move(s.events);s.events.clear();
        auto l=ax::LuaEngine::getInstance()->getLuaStack()->getLuaState();
        for(const auto& e:pending){
            int top=lua_gettop(l);lua_getglobal(l,"__nrSpineDispatch");
            if(std::getenv("NR_SPINE_TRACE"))
                AXLOGI("SPINE_DISPATCH type={} anim={} dispatchIsFunction={}",
                    e.type,e.animation.c_str(),lua_isfunction(l,-1));
            if(lua_isfunction(l,-1)){
                object_to_luaval<ax::Node>(l,"ax.Node",this);lua_pushinteger(l,e.type);lua_newtable(l);
                auto str=[&](const char* key,const std::string& value){lua_pushlstring(l,value.data(),value.size());lua_setfield(l,-2,key);};
                str("animation",e.animation);lua_pushinteger(l,e.track);lua_setfield(l,-2,"trackIndex");
                lua_pushinteger(l,e.loops);lua_setfield(l,-2,"loopCount");
                lua_newtable(l);str("name",e.name);str("stringValue",e.text);
                lua_pushinteger(l,e.intValue);lua_setfield(l,-2,"intValue");lua_pushnumber(l,e.floatValue);lua_setfield(l,-2,"floatValue");
                lua_setfield(l,-2,"eventData");
                if(lua_pcall(l,3,0,0)!=0)AXLOGE("Legacy Spine callback: {}",lua_tostring(l,-1));
            }
            lua_settop(l,top);
        }
    }
}
void LegacyCharacter::registerLua(lua_State* l){
    lua_getglobal(l,"ax");
    lua_pushcfunction(l,[](lua_State* l)->int{
        auto node=static_cast<ax::Node*>(tolua_tousertype(l,1,nullptr));
        if(!node)return luaL_error(l,"Expected node for frame lifetime guard");
        // Lua may close this window in Node::update. Keep it alive until
        // the frame pool drains, after Node::update has visited components.
        node->retain();node->autorelease();return 0;
    });lua_setfield(l,-2,"nrKeepAliveFrame");
    lua_pushcfunction(l,[](lua_State* l)->int{
        const char* json=luaL_checkstring(l,1);const char* atlas=luaL_checkstring(l,2);
        std::string base=json;if(base.size()>5&&base.substr(base.size()-5)==".json")base.resize(base.size()-5);
        try{
            auto node=LegacyCharacter::create(base,atlas,static_cast<float>(luaL_optnumber(l,3,1)));
            auto& s=*node->state;s.mixing=spAnimationStateData_create(s.data);s.player=spAnimationState_create(s.mixing);
            s.player->rendererObject=&s;
            s.player->listener=[](spAnimationState* p,int track,spEventType type,spEvent* event,int loops){
                auto s=static_cast<State*>(p->rendererObject);
                if(std::getenv("NR_SPINE_TRACE")){
                    auto e=spAnimationState_getCurrent(p,track);
                    AXLOGI("SPINE_EVENT type={} track={} loops={} anim={}",
                        static_cast<int>(type),track,loops,
                        (e&&e->animation)?e->animation->name:"?");
                }
                auto entry=spAnimationState_getCurrent(p,track);
                // Repassa o valor NATIVO do Spine 2.1 (SP_ANIMATION_*), sem
                // traduzir para os nomes do Cocos2d-x 3.x. O enum deste
                // runtime e:
                //   SP_ANIMATION_START=0, SP_ANIMATION_END=1,
                //   SP_ANIMATION_COMPLETE=2, SP_ANIMATION_EVENT=3
                // (spine-2.1.25/spine-c/include/spine/AnimationState.h:42-44).
                // Traduzir aqui criava um descompasso silencioso com o Lua:
                // o handler era registrado em ANIMATION_COMPLETE=3 (valor do
                // Cocos 3.x) enquanto o despacho chegava com 2, e o callback
                // de fim de onda nunca era encontrado.
                int mapped=static_cast<int>(type);
                s->events.push_back({mapped,track,loops,event?event->intValue:0,event?event->floatValue:0,
                    entry&&entry->animation?entry->animation->name:"",event?event->data->name:"",event&&event->stringValue?event->stringValue:""});
            };
            object_to_luaval<ax::Node>(l,"ax.Node",node);return 1;
        }catch(const std::exception& e){lua_pushnil(l);lua_pushstring(l,e.what());return 2;}
    });lua_setfield(l,-2,"nrSpineCreate");
    lua_pushcfunction(l,[](lua_State* l)->int{
        auto base=static_cast<ax::Node*>(tolua_tousertype(l,1,nullptr));
        auto node=dynamic_cast<LegacyCharacter*>(base);
        if(!node||!node->state->player)return luaL_error(l,"Expected native Spine 2.1 node");
        auto& s=*node->state;std::string cmd=luaL_checkstring(l,2);
        if(cmd=="play"||cmd=="queue"){
            int track=static_cast<int>(luaL_checkinteger(l,3));const char* name=luaL_checkstring(l,4);
            if(track<0||track>31)return luaL_error(l,"Invalid Spine track");
            auto animation=spSkeletonData_findAnimation(s.data,name);if(!animation)return luaL_error(l,"Missing animation: %s",name);
            if(cmd=="play")spAnimationState_setAnimation(s.player,track,animation,lua_toboolean(l,5));
            else spAnimationState_addAnimation(s.player,track,animation,lua_toboolean(l,5),static_cast<float>(luaL_optnumber(l,6,0)));
            lua_pushnumber(l,animation->duration);return 1;
        }
        if(cmd=="speed"){s.speed=static_cast<float>(luaL_checknumber(l,3));return 0;}
        if(cmd=="setup"){spSkeleton_setToSetupPose(s.skeleton);return 0;}
        if(cmd=="skin"){
            const char* name=luaL_checkstring(l,3);if(!spSkeleton_setSkinByName(s.skeleton,name))return luaL_error(l,"Missing skin: %s",name);
            spSkeleton_setSlotsToSetupPose(s.skeleton);return 0;
        }
        if(cmd=="mix"){
            const char* from=luaL_checkstring(l,3);const char* to=luaL_checkstring(l,4);
            if(!spSkeletonData_findAnimation(s.data,from)||!spSkeletonData_findAnimation(s.data,to))return luaL_error(l,"Mix animation missing");
            spAnimationStateData_setMixByName(s.mixing,from,to,static_cast<float>(luaL_checknumber(l,5)));return 0;
        }
        if(cmd=="duration"){
            auto a=spSkeletonData_findAnimation(s.data,luaL_checkstring(l,3));if(!a)return luaL_error(l,"Animation missing");lua_pushnumber(l,a->duration);return 1;
        }
        if(cmd=="names"){
            lua_newtable(l);for(int i=0;i<s.data->animationsCount;++i){lua_pushstring(l,s.data->animations[i]->name);lua_rawseti(l,-2,i+1);}return 1;
        }
        if(cmd=="clear"){spAnimationState_clearTracks(s.player);return 0;}
        if(cmd=="advance"){node->update(static_cast<float>(luaL_checknumber(l,3)));return 0;}
        if(cmd=="geometry"){
            unsigned vertices=0;for(const auto& sprite:s.sprites)if(sprite->isVisible())vertices+=sprite->getPolygonInfo().triangles.vertCount;
            lua_pushinteger(l,vertices);return 1;
        }
        if(cmd=="additiveSlots"){
            int count=0;
            for(int i=0;i<s.skeleton->slotsCount;++i) {
                auto slot=s.skeleton->drawOrder[i];
                if(slot->data->additiveBlending) {
                    ++count;
                    if(s.sprites[i]->isVisible() && s.sprites[i]->getBlendFunc().dst!=ax::backend::BlendFactor::ONE)
                        return luaL_error(l,"Additive effect rendered with normal alpha blend");
                }
            }
            lua_pushinteger(l,count);return 1;
        }
        return luaL_error(l,"Unsupported native Spine command: %s",cmd.c_str());
    });lua_setfield(l,-2,"nrSpineCommand");lua_pop(l,1);
}
void LegacyCharacter::drawControls(){
    auto& s=*state;ImGui::Begin("Personagem original - Spine 2.1");
    if(ImGui::BeginCombo("Animacao",s.data->animations[s.animation]->name)){
        for(int i=0;i<s.data->animationsCount;++i)if(ImGui::Selectable(s.data->animations[i]->name,i==s.animation)){s.animation=i;s.time=0;}
        ImGui::EndCombo();
    }
    ImGui::Checkbox("Pausar personagem",&s.paused);
    if(ImGui::Button("Reiniciar personagem"))s.time=0;
    ImGui::SliderFloat("Velocidade",&s.speed,0.1f,2.f);
    ImGui::Text("%d animacoes | %.2f s",s.data->animationsCount,s.time);ImGui::End();
}
void LegacyCharacter::play(const std::string& name,bool loop){
    auto& s=*state;
    for(int i=0;i<s.data->animationsCount;++i)if(name==s.data->animations[i]->name){
        s.animation=i;s.time=0;s.paused=false;s.speed=1;s.loop=loop;update(0);return;
    }
    throw std::runtime_error("Missing battle animation: "+name);
}
void LegacyCharacter::verifyAnimations(){
    auto& s=*state;int old=s.animation;float time=s.time;bool paused=s.paused;s.paused=true;
    bool geometrySeen=false,movementSeen=false;double first=0;bool firstSet=false;
    for(int a=0;a<s.data->animationsCount;++a){s.animation=a;
        for(int f=0;f<=120;++f){
            s.time=s.data->animations[a]->duration*f/120.f;update(0);
            double signature=0;
            for(auto sprite:s.sprites)if(sprite->isVisible()){
                const auto& mesh=sprite->getPolygonInfo().triangles;
                geometrySeen=geometrySeen||mesh.indexCount>0;
                for(unsigned j=0;j<mesh.vertCount;++j)
                    signature+=mesh.verts[j].vertices.x*(j+1)+mesh.verts[j].vertices.y*(j+3);
            }
            if(!firstSet){first=signature;firstSet=true;}
            else if(std::abs(signature-first)>0.01)movementSeen=true;
        }
    }
    s.animation=old;s.time=time;s.paused=paused;update(0);
    if(!geometrySeen||!movementSeen)throw std::runtime_error("Character preview has no animated geometry");
}
}
