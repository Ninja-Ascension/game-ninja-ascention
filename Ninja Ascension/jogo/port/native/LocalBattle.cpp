#include "LocalBattle.h"
#include "ImGui/imgui.h"
extern "C" {
#include "lua.h"
#include "lauxlib.h"
}
#include <stdexcept>
#include <algorithm>
#include <memory>

namespace nr {
namespace {
struct StackGuard{lua_State* l;int top;explicit StackGuard(lua_State* l):l(l),top(lua_gettop(l)){}~StackGuard(){lua_settop(l,top);}};
void call(lua_State* l,const char* method,int arguments){
    if(lua_pcall(l,arguments,1,0)!=0){const char* text=lua_tostring(l,-1);throw std::runtime_error(std::string("Local battle ")+method+": "+(text?text:"Lua error"));}
}
void method(lua_State* l,const char* name){
    lua_getglobal(l,"NRBattle");lua_getfield(l,-1,name);lua_remove(l,-2);
    if(!lua_isfunction(l,-1))throw std::runtime_error("Offline Lua API missing");
}
// CSV helper shared by the sample/pair loaders (splits on a delimiter).
std::string cell(const std::string& value,size_t& pos){
    size_t comma=value.find(',',pos);if(comma==std::string::npos)comma=value.size();
    std::string out=value.substr(pos,comma-pos);pos=comma+1;return out;
}
}
LocalBattle::Snapshot LocalBattle::dispatch(const char* command){
    StackGuard guard(lua);method(lua,"dispatch");lua_pushstring(lua,command);call(lua,command,1);
    if(!lua_istable(lua,-1))throw std::runtime_error("Invalid battle snapshot");
    auto integer=[&](const char* key){lua_getfield(lua,-1,key);if(!lua_isnumber(lua,-1))throw std::runtime_error("Invalid numeric battle field");int n=static_cast<int>(lua_tointeger(lua,-1));lua_pop(lua,1);return n;};
    auto string=[&](const char* key){lua_getfield(lua,-1,key);auto p=lua_tostring(lua,-1);if(!p)throw std::runtime_error("Invalid battle string field");std::string s=p;lua_pop(lua,1);return s;};
    Snapshot result;result.phase=string("phase");result.actor=string("actor");
    result.turn=integer("turn");result.heroHp=integer("heroHp");result.heroMax=integer("heroMax");
    result.enemyHp=integer("enemyHp");result.enemyMax=integer("enemyMax");result.damage=integer("damage");return result;
}
LocalBattle* LocalBattle::create(lua_State* lua,std::function<void(const std::string&)> log){
    auto node=std::make_unique<LocalBattle>();if(!node->init())throw std::runtime_error("Battle node initialization failed");
    node->lua=lua;node->log=std::move(log);node->setName("battle.local");
    auto bg=ax::Sprite::create("map/battle/battle_1_1/battle_1_1_01.png");
    if(!bg)throw std::runtime_error("Battle background missing");
    bg->setAnchorPoint(ax::Vec2::ZERO);bg->setScaleX(960/bg->getContentSize().width);bg->setScaleY(640/bg->getContentSize().height);node->addChild(bg);
    node->hero=LegacyCharacter::create("sprite/spirte_102101");node->hero->setName("battle.hero");
    node->hero->setPosition(260,180);node->hero->setScale(0.8f);node->addChild(node->hero.get(),2);
    node->enemy=LegacyCharacter::create("sprite/spirte_102101");node->enemy->setName("battle.enemy");
    node->enemy->setPosition(700,180);node->enemy->setScaleX(-0.8f);node->enemy->setScaleY(0.8f);node->addChild(node->enemy.get(),2);
    node->bars=ax::DrawNode::create();node->addChild(node->bars.get(),5);
    node->hpLabel=ax::Label::createWithSystemFont("","Arial",22);node->hpLabel->setPosition(480,604);node->addChild(node->hpLabel.get(),6);
    node->resultLabel=ax::Label::createWithSystemFont("","Arial",38);node->resultLabel->setPosition(480,390);node->addChild(node->resultLabel.get(),6);
    node->state=node->dispatch("snapshot");node->refresh();node->setVisible(false);node->scheduleUpdate();node->autorelease();return node.release();
}
void LocalBattle::refresh(){
    bars->clear();
    bars->drawSolidRect(ax::Vec2(40,560),ax::Vec2(400,578),ax::Color4F(0.15f,0.15f,0.15f,1));
    bars->drawSolidRect(ax::Vec2(560,560),ax::Vec2(920,578),ax::Color4F(0.15f,0.15f,0.15f,1));
    bars->drawSolidRect(ax::Vec2(40,560),ax::Vec2(40+360.f*state.heroHp/state.heroMax,578),ax::Color4F(0.1f,0.8f,0.2f,1));
    bars->drawSolidRect(ax::Vec2(560,560),ax::Vec2(560+360.f*state.enemyHp/state.enemyMax,578),ax::Color4F(0.9f,0.2f,0.1f,1));
    hpLabel->setString("Heroi "+std::to_string(state.heroHp)+" / "+std::to_string(state.heroMax)+"             Adversario "+std::to_string(state.enemyHp)+" / "+std::to_string(state.enemyMax));
    resultLabel->setString(state.phase=="victory"?"VITORIA":state.phase=="defeat"?"DERROTA":state.phase=="ready"?"Batalha local de treino":"");
}
void LocalBattle::action(const char* command){
    state=dispatch(command);remaining=0;
    if(state.phase=="player_hit"){
        hero->play("07_pugong",false);enemy->play("03_beiji",false);remaining=0.85f;
    }else if(state.phase=="enemy_hit"){
        enemy->play("07_pugong",false);hero->play("03_beiji",false);remaining=0.85f;
    }else if(state.phase=="guard"){
        hero->play("00_daiji");enemy->play("00_daiji");remaining=0.35f;
    }else if(state.phase=="victory"){
        hero->play("00_daiji");enemy->play("06_siwang",false);
    }else if(state.phase=="defeat"){
        hero->play("06_siwang",false);enemy->play("00_daiji");
    }else{hero->play("00_daiji");enemy->play("00_daiji");}
    refresh();log("LOCAL_BATTLE phase="+state.phase+" turn="+std::to_string(state.turn)+" hp="+std::to_string(state.heroHp)+","+std::to_string(state.enemyHp)+" damage="+std::to_string(state.damage));
}
void LocalBattle::setActive(bool value){
    if(value==active)return;
    active=value;setVisible(value);remaining=0;
    playbackActive=false;playbackIndex=0;
    for(int i=0;i<6;i++){if(cast0[i])cast0[i]->setVisible(false);if(cast1[i])cast1[i]->setVisible(false);}
    if(value){error.clear();action("restart");hero->setVisible(true);enemy->setVisible(true);}
    if(onModeChanged)onModeChanged(value);
}
void LocalBattle::update(float dt){
    if(playbackActive){
        if(playbackRemaining<=0)return;
        playbackRemaining-=dt;
        if(playbackRemaining<=0&&playbackIndex<playback.size()&&playbackIndex>0){
            try{playbackAdvance();}catch(const std::exception& e){playbackActive=false;error=e.what();log(error);}
        }
        return;
    }
    if(!active||!error.empty()||remaining<=0)return;
    remaining-=dt;if(remaining<=0){try{action("advance");}catch(const std::exception& e){error=e.what();log(error);}}
}
void LocalBattle::drawControls(){
    if(!active){
        ImGui::SetNextWindowPos(ImVec2(580,455),ImGuiCond_FirstUseEver);
        ImGui::Begin("Batalha local");ImGui::TextUnformatted("Treino offline - ataque comum original");
        if(ImGui::Button("Abrir batalha local"))setActive(true);ImGui::End();return;
    }
    ImGui::SetNextWindowPos(ImVec2(20,485),ImGuiCond_Appearing);
    ImGui::SetNextWindowSize(ImVec2(920,135),ImGuiCond_Appearing);
    ImGui::Begin("Controles da batalha");
    try{
        ImGui::Text("Turno %d | %s",state.turn,state.phase=="player"?"Sua vez":"");
        if(state.phase=="ready"){if(ImGui::Button("Iniciar"))action("start");}
        if(state.phase=="player"){
            if(ImGui::Button("Atacar"))action("attack");ImGui::SameLine();
            if(state.phase=="player"&&ImGui::Button("Defender"))action("guard");
        }
        if(state.phase=="player_hit"||state.phase=="enemy_hit")ImGui::Text("%s causou %d de dano",state.actor=="hero"?"Heroi":"Adversario",state.damage);
        if(state.phase=="victory"||state.phase=="defeat")if(ImGui::Button("Jogar novamente"))action("restart");
        if(!pairList.empty()){
            if(pairSelected<0)pairSelected=0;
            if(ImGui::BeginCombo("Luta original",pairLabels[pairSelected].c_str())){
                for(int i=0;i<(int)pairLabels.size();i++){
                    bool selected=i==pairSelected;
                    if(ImGui::Selectable(pairLabels[i].c_str(),selected)){
                        pairSelected=i;
                        try{applyPair((size_t)i);}catch(const std::exception& e){error=e.what();log(error);}
                    }
                    if(selected)ImGui::SetItemDefaultFocus();
                }
                ImGui::EndCombo();
            }
        }
        if(!playback.empty()&&!playbackActive){
            if(ImGui::Button("Reproduzir combate original (simulador)"))startPlayback();
            ImGui::SameLine();ImGui::TextUnformatted("repasse do estado real do simulador");
        }
        if(playbackActive)ImGui::TextUnformatted("Repassando combate original... (edit. pausa automatica)");
        if(ImGui::Button("Voltar ao editor"))setActive(false);
    }catch(const std::exception& e){error=e.what();log(error);}
    if(!error.empty())ImGui::TextWrapped("Erro: %s",error.c_str());
    ImGui::End();
}
void LocalBattle::prepareOriginalBattle(){
    if(!pairList.empty())return; // idempotent: report pipeline loads exactly once
    {StackGuard guard(lua); // original offline simulator: full report pipeline
     lua_getglobal(lua,"NRBattle");lua_getfield(lua,-1,"reportTest");lua_remove(lua,-2);
     if(lua_isfunction(lua,-1)){
         call(lua,"reportTest",0);
         size_t len=0;const char* txt=lua_tolstring(lua,-1,&len);
         if(!txt)throw std::runtime_error("Battle report test returned no summary");
         log(std::string("LOCAL_BATTLE_REPORT_PASSED ")+txt);
     } else log("LOCAL_BATTLE_REPORT_SKIPPED env off");
    }
    {StackGuard guard(lua); // slice-2: REAL event histogram of the captured frames
     lua_getglobal(lua,"NRBattle");lua_getfield(lua,-1,"frameDigest");lua_remove(lua,-2);
     if(lua_isfunction(lua,-1)){
         call(lua,"frameDigest",0);
         size_t len=0;const char* txt=lua_tolstring(lua,-1,&len);
         if(txt)log(std::string("LOCAL_BATTLE_REPORT_FRAMES ")+std::string(txt,len>520?520:len));
     }
    }
    {StackGuard guard(lua); // slice-2: per-step simulator samples -> playback rows
     lua_getglobal(lua,"NRBattle");lua_getfield(lua,-1,"roundSamples");lua_remove(lua,-2);
     if(lua_isfunction(lua,-1)){
         call(lua,"roundSamples",0);
         size_t len=0;const char* txt=lua_tolstring(lua,-1,&len);
         if(txt&&len>0){
             loadPlayback(std::string(txt,len));
             log("LOCAL_BATTLE_PLAYBACK_LOADED rows="+std::to_string(playback.size()));
         }
     }
    }
    {StackGuard guard(lua); // cut 3: ORIGINAL pair inventory for the UI list
     lua_getglobal(lua,"NRBattle");lua_getfield(lua,-1,"battlePairs");lua_remove(lua,-2);
     if(lua_isfunction(lua,-1)){
         lua_pushinteger(lua,24);call(lua,"battlePairs",1);
         size_t len=0;const char* txt=lua_tolstring(lua,-1,&len);
         if(txt&&len>0){
             std::string csv(txt,len);size_t p=0;int lineNo=0;
             while(p<csv.size()){
                 size_t nl=csv.find('\n',p);if(nl==std::string::npos)nl=csv.size();
                 std::string rowText=csv.substr(p,nl-p);p=nl+1;
                 if(lineNo++==0)continue;
                 size_t q=0;
                 std::string id=cell(rowText,q),eve=cell(rowText,q),seats=cell(rowText,q);
                 if(id.empty())continue;
                 std::array<int,2> values{std::atoi(id.c_str()),std::atoi(eve.c_str())};
                 pairList.push_back(values);
                 pairLabels.push_back("Ataque=formacao "+eve+" ("+seats+" navio(s)) vs NPC "+id);
             }
             log("LOCAL_BATTLE_PAIRS count="+std::to_string(pairList.size()));
         }
     }
    }
}
void LocalBattle::smokeTest(){
    {StackGuard guard(lua);method(lua,"selfTest");call(lua,"selfTest",0);if(!lua_toboolean(lua,-1))throw std::runtime_error("Battle Lua self-test failed");}
    prepareOriginalBattle();
    setActive(true);action("start");
    int steps=0;
    while(state.phase!="victory"){
        if(++steps>100)throw std::runtime_error("Native victory did not terminate");
        if(state.phase=="player")action("attack");else update(1.f);
    }
    if(state.enemyHp!=0||state.heroHp<=0)throw std::runtime_error("Invalid native victory");
    action("restart");action("start");steps=0;
    while(state.phase!="defeat"){
        if(++steps>150)throw std::runtime_error("Native defeat did not terminate");
        if(state.phase=="player")action("guard");else update(1.f);
    }
    if(state.heroHp!=0)throw std::runtime_error("Invalid native defeat");
    action("restart");setActive(false);log("LOCAL_BATTLE_SMOKE_PASSED: original damage, victory, defeat, restart, editor return");
}
void LocalBattle::enterForCapture(){
    setActive(true);
    if(!playback.empty()){
        startPlayback();
        log("LOCAL_BATTLE_PLAYBACK_START rows="+std::to_string(playback.size()));
    }else{
        action("start");
    }
}
void LocalBattle::startPlayback(){
    // Etapa-3 slice 3: full-cast pool — one character per OCCUPIED seat of the
    // ORIGINAL formation data (first row = initial simulator state).
    for(int i=0;i<6;i++){
        for(int c=0;c<2;c++){
            const PlayRow& row=playback[0];
            int hp=c==0?row.hp0[i]:row.hp1[i];
            ax::RefPtr<LegacyCharacter>& slot=(c==0?cast0[i]:cast1[i]);
            if(hp>0&&slot==nullptr){
                slot=LegacyCharacter::create("sprite/spirte_102101");
                float x=c==0?260.f:700.f,y=330.f-56.f*i;
                slot->setPosition(x,y);slot->setScale(0.8f);slot->setScaleX(c==0?0.8f:-0.8f);
                addChild(slot.get(),2+(c==0?0:1));
                slot->play("00_daiji");
            }
            if(slot!=nullptr)slot->setVisible(true);
        }
    }
    // toy pair hides while the original cast is on stage
    hero->setVisible(false);enemy->setVisible(false);
    playbackActive=true;playbackIndex=1;playbackRemaining=0.4f;
    playbackRefresh(playback[0]);
    try{updateRosterLabels(1);rosterWaveShown=1;}
    catch(const std::exception& e){log(std::string("LOCAL_BATTLE_ROSTER_FAILED ")+e.what());}
}

void LocalBattle::applyPair(size_t index){
    if(index>=pairList.size())throw std::runtime_error("Par fora da lista");
    StackGuard guard(lua);
    lua_getglobal(lua,"NRBattle");lua_getfield(lua,-1,"setPair");lua_remove(lua,-2);
    if(!lua_isfunction(lua,-1))throw std::runtime_error("setPair indisponivel");
    lua_pushinteger(lua,pairList[index][0]);lua_pushinteger(lua,pairList[index][1]);
    call(lua,"setPair",2);
    size_t len=0;const char* txt=lua_tolstring(lua,-1,&len);
    log("LOCAL_BATTLE_PAIR_SET "+std::string(txt?txt:"",len));
    lua_getglobal(lua,"NRBattle");lua_getfield(lua,-1,"roundSamples");lua_remove(lua,-2);
    call(lua,"roundSamples",0);
    size_t l2=0;const char* t2=lua_tolstring(lua,-1,&l2);
    if(!t2||l2==0)throw std::runtime_error("roundSamples vazio para o novo par");
    for(int i=0;i<6;i++){
        if(cast0[i])cast0[i]->setVisible(false);
        if(cast1[i])cast1[i]->setVisible(false);
    }
    hero->setVisible(true);enemy->setVisible(true);
    playbackActive=false;playbackIndex=0;
    loadPlayback(std::string(t2,l2));
    if(active)startPlayback();
    log("LOCAL_BATTLE_PAIR_PLAYBACK rows="+std::to_string(playback.size()));
}
void LocalBattle::loadPlayback(const std::string& csv){
    playback.clear();playbackIndex=0;playbackActive=false;
    try{loadStepSkills();}catch(const std::exception& e){stepSkills.clear();log(std::string("LOCAL_BATTLE_SKILLS_FAILED ")+e.what());}
    size_t pos=0,line=0;
    while(pos<csv.size()){
        size_t nl=csv.find('\n',pos);if(nl==std::string::npos)nl=csv.size();
        std::string rowText=csv.substr(pos,nl-pos);pos=nl+1;
        if(line++==0)continue; // header
        size_t p=0;
        std::string round=cell(rowText,p);
        if(round.empty())continue;
        PlayRow r;r.round=std::atoi(round.c_str());
        std::string wave=cell(rowText,p);r.wave=std::atoi(wave.c_str());
        r.step=std::atoi(cell(rowText,p).c_str());
        std::string camps[2]{cell(rowText,p),cell(rowText,p)};
        for(int c=0;c<2;c++){
            size_t q=0;
            for(int i=0;i<6;i++){
                size_t bar=camps[c].find('|',q);if(bar==std::string::npos)bar=camps[c].size();
                std::string tok=camps[c].substr(q,bar-q);q=bar+1;
                int hp=0;bool dead=false;
                if(!tok.empty()){
                    if(tok.back()=='D'){dead=true;hp=std::atoi(tok.substr(0,tok.size()-1).c_str());}
                    else{hp=std::atoi(tok.c_str());}
                }
                if(c==0){r.hp0[i]=hp;r.d0[i]=dead;if(hp>0&&r.seat0<0)r.seat0=i;}else{r.hp1[i]=hp;r.d1[i]=dead;if(hp>0&&r.seat1<0)r.seat1=i;}
            }
        }
        playback.push_back(r);
    }
}
void LocalBattle::playbackRefresh(const PlayRow& row){
    bars->clear();
    int seat0=row.seat0>=0?row.seat0:0,seat1=row.seat1>=0?row.seat1:0;
    int hero=row.hp0[seat0],enemy=row.hp1[seat1];
    bars->drawSolidRect(ax::Vec2(40,560),ax::Vec2(400,578),ax::Color4F(0.15f,0.15f,0.15f,1));
    bars->drawSolidRect(ax::Vec2(560,560),ax::Vec2(920,578),ax::Color4F(0.15f,0.15f,0.15f,1));
    float scale=1.25f*(float)(hero>enemy?hero:enemy);if(scale<1.f)scale=1.f;
    bars->drawSolidRect(ax::Vec2(40,560),ax::Vec2(40+360.f*hero/scale,578),ax::Color4F(0.1f,0.8f,0.2f,1));
    bars->drawSolidRect(ax::Vec2(560,560),ax::Vec2(560+360.f*enemy/scale,578),ax::Color4F(0.9f,0.2f,0.1f,1));
    hpLabel->setString("Rodada "+std::to_string(row.round)+(row.wave>1?" (onda "+std::to_string(row.wave)+")":"")+"   Heroi("+std::to_string(hero)+")   Adversario("+std::to_string(enemy)+")");
    resultLabel->setString("Combate original (repasse do simulador)");
}
void LocalBattle::spawnDelta(ax::Node* anchor,float delta){
    if(delta==0)return;
    int value=static_cast<int>(delta<0?-delta:delta);
    auto label=ax::Label::createWithSystemFont((delta>0?"+":"-")+std::to_string(value),"Arial",26);
    ax::Vec2 pos=anchor->getPosition();
    label->setPosition(pos.x,pos.y+70);
    label->setColor(delta>0?ax::Color3B(80,220,90):ax::Color3B(255,70,60));
    addChild(label,9);
    label->runAction(ax::Spawn::create({
        ax::MoveBy::create(0.9f,ax::Vec2(0,46)),
        ax::FadeOut::create(0.9f)}));
    label->runAction(ax::Sequence::create({
        ax::DelayTime::create(0.95f),ax::RemoveSelf::create()}));
}
void LocalBattle::updateRosterLabels(int wave){
    StackGuard guard(lua);
    lua_getglobal(lua,"NRBattle");lua_getfield(lua,-1,"seatRoster");lua_remove(lua,-2);
    if(!lua_isfunction(lua,-1))throw std::runtime_error("seatRoster indisponivel");
    lua_pushinteger(lua,wave);call(lua,"seatRoster",1);
    size_t len=0;const char* txt=lua_tolstring(lua,-1,&len);
    if(!txt)throw std::runtime_error("seatRoster sem dados");
    std::string csv(txt,len);size_t p=0;int lineNo=0;
    std::string names[2][6]={};
    while(p<csv.size()){
        size_t nl=csv.find('\n',p);if(nl==std::string::npos)nl=csv.size();
        std::string rowText=csv.substr(p,nl-p);p=nl+1;
        if(lineNo++==0)continue;
        size_t q=0;
        int camp=std::atoi(cell(rowText,q).c_str());
        int seat=std::atoi(cell(rowText,q).c_str());
        std::string ship=cell(rowText,q);
        std::string nm=cell(rowText,q);
        if(seat>=1&&seat<=6&&(camp==0||camp==1))names[camp][seat-1]=nm+" #"+ship;
    }
    for(int c=0;c<2;c++)for(int s=0;s<6;s++){
        auto& slot=(c==0?cast0:cast1)[s];
        auto& label=(c==0?roster0:roster1)[s];
        if(!slot){
            if(label){label->removeFromParent();label=nullptr;}
            continue;
        }
        if(!label){
            label=ax::Label::createWithSystemFont("","Arial",16);
            label->setColor({190,220,255});
            addChild(label,8);
        }
        label->setString(names[c][s].empty()?" ":names[c][s]);
        ax::Vec2 pos=slot->getPosition();
        label->setPosition(pos.x,pos.y+150);
        label->setVisible(true);
    }
    log("LOCAL_BATTLE_ROSTER wave="+std::to_string(wave));
}
void LocalBattle::loadStepSkills(){
    stepSkills.clear();
    StackGuard guard(lua);
    lua_getglobal(lua,"NRBattle");lua_getfield(lua,-1,"skillSamples");lua_remove(lua,-2);
    if(!lua_isfunction(lua,-1))throw std::runtime_error("skillSamples indisponivel");
    call(lua,"skillSamples",0);
    size_t len=0;const char* txt=lua_tolstring(lua,-1,&len);
    if(!txt)throw std::runtime_error("skillSamples sem dados");
    std::string csv(txt,len);size_t p=0;int lineNo=0;
    while(p<csv.size()){
        size_t nl=csv.find('\n',p);if(nl==std::string::npos)nl=csv.size();
        std::string rowText=csv.substr(p,nl-p);p=nl+1;
        if(lineNo++==0)continue;
        size_t q=0;
        StepSkill e;
        e.step=std::atoi(cell(rowText,q).c_str());
        e.camp=std::atoi(cell(rowText,q).c_str());
        e.seat=std::atoi(cell(rowText,q).c_str());
        e.kind=cell(rowText,q);
        (void)cell(rowText,q); // skill id (kept original; label shows the name)
        e.name=cell(rowText,q);
        if(e.step>=1&&(e.camp==0||e.camp==1)&&e.seat>=1&&e.seat<=6)stepSkills.push_back(e);
    }
    log("LOCAL_BATTLE_SKILLS events="+std::to_string(stepSkills.size()));
}
void LocalBattle::spawnSkillTag(ax::Node* anchor,const std::string& kind,const std::string& name){
    std::string text=name.empty()?"SP-":name;
    auto label=ax::Label::createWithSystemFont(text,"Arial",18);
    ax::Vec2 pos=anchor->getPosition();
    label->setPosition(pos.x,pos.y+112);
    // normal: warm yellow; small: orange; anger/power: violet; unclassified: blue
    label->setColor(kind=="normal"?ax::Color3B(255,220,90):
                    kind=="small"?ax::Color3B(255,170,70):
                    kind=="power"?ax::Color3B(198,132,255):ax::Color3B(120,200,255));
    addChild(label,10);
    label->runAction(ax::Spawn::create({
        ax::MoveBy::create(1.1f,ax::Vec2(0,60)),
        ax::FadeOut::create(1.1f)}));
    label->runAction(ax::Sequence::create({
        ax::DelayTime::create(1.15f),ax::RemoveSelf::create()}));
}
void LocalBattle::playbackAdvance(){
    const PlayRow& row=playback[playbackIndex];
    const PlayRow& prev=playback[playbackIndex-1];
    // Full cast: every occupied seat animates from its OWN real delta. The
    // attacking side is inferred as the camp that did NOT lose HP this step.
    int loss0=0,loss1=0;
    for(int i=0;i<6;i++){
        loss0+=(prev.hp0[i]>row.hp0[i])||(row.d0[i]&&!prev.d0[i])?1:0;
        loss1+=(prev.hp1[i]>row.hp1[i])||(row.d1[i]&&!prev.d1[i])?1:0;
    }
    int attackerCamp=loss0>0&&loss1==0?1:loss1>0&&loss0==0?0:-1;
    if(row.wave>prev.wave&&rosterWaveShown!=row.wave){
        try{updateRosterLabels(row.wave);rosterWaveShown=row.wave;}
        catch(const std::exception& e){log(std::string("LOCAL_BATTLE_ROSTER_FAILED ")+e.what());}
    }
    for(int c=0;c<2;c++){
        for(int i=0;i<6;i++){
            ax::RefPtr<LegacyCharacter>& slot=(c==0?cast0[i]:cast1[i]);
            if(slot==nullptr)continue;
            int oldHp=c==0?prev.hp0[i]:prev.hp1[i],newHp=c==0?row.hp0[i]:row.hp1[i];
            bool oldDead=c==0?prev.d0[i]:prev.d1[i],newDead=c==0?row.d0[i]:row.d1[i];
            if(newDead&&!oldDead){slot->play("06_siwang",false);spawnDelta(slot.get(),static_cast<float>(newHp-oldHp));continue;}
            if(newDead){continue;} // morto permanece no chão
            else if(newHp<oldHp){
                if(attackerCamp>=0&&c==attackerCamp)slot->play("07_pugong",false);
                else slot->play("03_beiji",false);
                spawnDelta(slot.get(),static_cast<float>(newHp-oldHp));
            }else if(attackerCamp==c){slot->play("07_pugong",false);}
            else if(newHp>oldHp||prev.hp1[i]<0){slot->play("00_daiji");spawnDelta(slot.get(),static_cast<float>(newHp-oldHp));}
        }
    }
    for(const auto& e:stepSkills){
        if(e.step!=row.step)continue;
        auto& slot=(e.camp==0?cast0:cast1)[e.seat-1];
        if(slot)spawnSkillTag(slot.get(),e.kind,e.name);
    }
    playbackRefresh(row);
    log("LOCAL_BATTLE_PLAYBACK step round="+std::to_string(row.round)+
        " attacker="+(attackerCamp==0?"camp0":attackerCamp==1?"camp1":"?")+
        " hp0="+std::to_string(row.hp0[row.seat0>=0?row.seat0:0])+
        " hp1="+std::to_string(row.hp1[row.seat1>=0?row.seat1:0]));
    ++playbackIndex;
    if(playbackIndex>=playback.size()){
        playbackActive=false;
        int hero=0,enemy=0;
        for(int i=0;i<6;i++){const PlayRow& r=playback.back();hero+=r.hp0[i];enemy+=r.hp1[i];}
        resultLabel->setString(enemy<=0?"VITORIA (original)":hero<=0?"DERROTA (original)":"FIM (original)");
        log("LOCAL_BATTLE_PLAYBACK_DONE rows="+std::to_string(playback.size()));
    }else playbackRemaining=0.55f;
}
}
