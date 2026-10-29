#include "LayoutEditor.h"
#include "ImGui/imgui.h"
#include "cocostudio/ComExtensionData.h"
#include <stdexcept>
#include <sstream>
#include <iomanip>
#include <cctype>

namespace nr {
namespace {
LayoutState state(ax::Node* n) {
    LayoutState s;auto p=n->getPosition();s.position={p.x,p.y};s.scale={n->getScaleX(),n->getScaleY()};
    s.rotation={n->getRotationSkewX(),n->getRotationSkewY()};auto a=n->getAnchorPoint();s.anchor={a.x,a.y};auto sz=n->getContentSize();s.size={sz.width,sz.height};
    s.z=n->getLocalZOrder();s.globalZ=n->getGlobalZOrder();s.visible=n->isVisible();auto c=n->getColor();s.color={c.r,c.g,c.b};s.opacity=n->getOpacity();
    if(auto label=dynamic_cast<ax::LabelProtocol*>(n))s.text=std::string(label->getString());
    if(auto sprite=dynamic_cast<ax::Sprite*>(n))s.flip=std::array<bool,2>{sprite->isFlippedX(),sprite->isFlippedY()};
    return s;
}
void setState(ax::Node* n,const LayoutState& s) {
    if(s.text)if(auto label=dynamic_cast<ax::LabelProtocol*>(n))label->setString(*s.text);
    if(s.flip)if(auto sprite=dynamic_cast<ax::Sprite*>(n)){sprite->setFlippedX((*s.flip)[0]);sprite->setFlippedY((*s.flip)[1]);}
    n->setPosition(ax::Vec2(static_cast<float>(s.position[0]),static_cast<float>(s.position[1])));
    n->setScaleX(static_cast<float>(s.scale[0]));n->setScaleY(static_cast<float>(s.scale[1]));
    n->setRotationSkewX(static_cast<float>(s.rotation[0]));n->setRotationSkewY(static_cast<float>(s.rotation[1]));
    n->setAnchorPoint(ax::Vec2(static_cast<float>(s.anchor[0]),static_cast<float>(s.anchor[1])));
    n->setContentSize(ax::Size(static_cast<float>(s.size[0]),static_cast<float>(s.size[1])));
    n->setLocalZOrder(s.z);n->setGlobalZOrder(static_cast<float>(s.globalZ));n->setVisible(s.visible);n->setColor(ax::Color3B(static_cast<uint8_t>(s.color[0]),static_cast<uint8_t>(s.color[1]),static_cast<uint8_t>(s.color[2])));n->setOpacity(static_cast<uint8_t>(s.opacity));
}
std::string segment(ax::Node* n) {
    std::ostringstream out;
    for(unsigned char c:n->getName()) {if(std::isalnum(c)||c=='_'||c=='-')out<<c;else out<<'%'<<std::hex<<std::setw(2)<<std::setfill('0')<<unsigned(c)<<std::dec;}
    auto data=dynamic_cast<cocostudio::ComExtensionData*>(n->getComponent(cocostudio::ComExtensionData::COMPONENT_NAME));
    out<<"@"<<n->getTag();if(data)out<<":"<<data->getActionTag();return out.str();
}
bool within(const std::string& key,const std::string& prefix){return key==prefix||key.starts_with(prefix+"/");}
void check(bool ok,const char* message){if(!ok)throw std::runtime_error(message);}
}
LayoutEditor::LayoutEditor(std::filesystem::path local,std::filesystem::path defaults,std::function<void(const std::string&)> logger):localFile(std::move(local)),defaultFile(std::move(defaults)),log(std::move(logger)){}
void LayoutEditor::status(const std::string& text,bool error) {message=text;messageIsError=error;log(std::string(error?"LAYOUT_ERROR ":"LAYOUT ")+text);}
void LayoutEditor::action(const std::function<void()>& f){try{f();}catch(const std::exception& e){status(e.what(),true);}}
void LayoutEditor::bindNode(ax::Node* node,const std::string& id){if(!nodes.emplace(id,Entry{node,state(node),node,node->getParent()}).second)throw std::runtime_error("Duplicate editable ID: "+id);}
void LayoutEditor::bindTree(ax::Node* node,const std::string& id) {
    bindNode(node,id);std::map<std::string,int> counts;for(auto c:node->getChildren())++counts[segment(c)];
    for(auto c:node->getChildren()) {auto key=segment(c);if(counts[key]!=1){log("LAYOUT_SKIP ambiguous sibling: "+id+"/"+key);continue;}bindTree(c,id+"/"+key);}
}
LayoutStates LayoutEditor::capture() const {
    LayoutStates values;auto root=nodes.at("probe.scene").node;
    for(const auto& [id,entry]:nodes) {
        auto top=entry.node;while(top->getParent())top=top->getParent();
        if(top!=root)throw std::runtime_error("No removido da cena: "+id+". Use Restaurar iniciais ou Recarregar; exclusoes nao sao salvas.");
        values.emplace(id,state(entry.node));
    }
    return values;
}
void LayoutEditor::restoreNodes(){for(const auto& [id,entry]:nodes) {
    if(entry.originalParent&&entry.node->getParent()!=entry.originalParent){entry.node->removeFromParent();entry.originalParent->addChild(entry.node,entry.baseline.z);}
    setState(entry.node,entry.baseline);
}}
void LayoutEditor::apply(const LayoutStates& values,bool reset) {
    // Validate the entire ID set before changing any node; invalid reloads are non-destructive.
    for(const auto& [id,s]:values) {
        if(!nodes.contains(id))throw std::runtime_error("Unknown editable node: "+id);
        if(s.text&&!dynamic_cast<ax::LabelProtocol*>(nodes.at(id).node))throw std::runtime_error("Node does not support text: "+id);
        if(s.flip&&!dynamic_cast<ax::Sprite*>(nodes.at(id).node))throw std::runtime_error("Node does not support sprite flip: "+id);
    }
    if(reset)restoreNodes();for(const auto& [id,s]:values)setState(nodes.at(id).node,s);
}
void LayoutEditor::loadInitial(){saved=capture();action([this]{reload();});}
void LayoutEditor::reload() {
    auto path=std::filesystem::exists(localFile)?localFile:defaultFile;
    auto values=readLayout(path);apply(values,true);saved=capture();status("Carregado: "+path.string());
}
void LayoutEditor::save(){auto values=capture();writeLayoutAtomic(localFile,values);saved=values;status("Salvo: "+localFile.string());}
void LayoutEditor::restore(){restoreNodes();status("Valores iniciais restaurados em memoria; use Salvar para manter.");}
void LayoutEditor::replaceTree(ax::Node* node,const std::string& id) {
    LayoutStates old;for(const auto& [key,entry]:nodes)if(within(key,id))old.emplace(key,state(entry.node));
    for(auto i=nodes.begin();i!=nodes.end();)if(within(i->first,id))i=nodes.erase(i);else ++i;
    bindTree(node,id);
    for(const auto& [key,value]:old)if(nodes.contains(key))setState(nodes.at(key).node,value);else log("LAYOUT_SKIP recreated node missing: "+key);
}
void LayoutEditor::draw() {
    auto origin=ImGui::GetMainViewport()->WorkPos;
    if(++frames<10){ImGui::SetWindowPos("Inspector",ImVec2(origin.x+10,origin.y+10),ImGuiCond_Once);ImGui::SetWindowSize("Inspector",ImVec2(560,420),ImGuiCond_Once);}
    ImGui::SetNextWindowPos(ImVec2(origin.x+590,origin.y+10),ImGuiCond_FirstUseEver);
    ImGui::SetNextWindowSize(ImVec2(350,280),ImGuiCond_FirstUseEver);
    if(ImGui::Begin("Ajustes do layout")) {
        if(!announced){log("LAYOUT_EDITOR_PANEL_READY nodes="+std::to_string(nodes.size()));announced=true;}
        auto path=localFile.string();ImGui::TextWrapped("Arquivo local: %s",path.c_str());
        try {ImGui::TextUnformatted(capture()==saved?"Sem alteracoes pendentes":"Alteracoes nao salvas");}
        catch(const std::exception& e){ImGui::TextWrapped("%s",e.what());}
        if(ImGui::Button("Salvar ajustes"))action([this]{save();});ImGui::SameLine();
        if(ImGui::Button("Recarregar"))action([this]{reload();});
        if(ImGui::Button("Restaurar iniciais"))action([this]{restore();});
        ImGui::Separator();
        if(ImGui::Button("Tocar som (A)"))action([this]{if(playAudio)playAudio();});ImGui::SameLine();
        if(ImGui::Button(previewPaused&&previewPaused()?"Continuar preview":"Pausar preview"))action([this]{if(togglePreview)togglePreview();});
        ImGui::TextWrapped("Salva %zu nos registrados: UI, logo, fonte, atlas, texto e raiz. Assets originais preservados.",nodes.size());
        if(messageIsError)ImGui::PushStyleColor(ImGuiCol_Text,ImVec4(1,0.35f,0.25f,1));
        ImGui::TextWrapped("%s",message.c_str());if(messageIsError)ImGui::PopStyleColor();
    }
    ImGui::End();
}
void LayoutEditor::smokeWrite() {
    auto baseline=capture();auto* statusNode=nodes.at("probe.status").node;
    statusNode->setPosition(ax::Vec2(123,91));dynamic_cast<ax::LabelProtocol*>(statusNode)->setString("Layout persistente");
    dynamic_cast<ax::Sprite*>(nodes.at("probe.atlas_preview").node)->setFlippedX(true);
    nodes.at("probe.logo").node->setPosition(ax::Vec2(7,9));save();auto expected=capture();
    restore();check(capture()==baseline,"Restore did not recover original baseline");
    reload();check(capture()==expected,"Reload did not recover saved layout");
    auto bad=expected;bad.emplace("probe.missing-node",LayoutState{});bool rejected=false;
    try{apply(bad,true);}catch(const std::exception&){rejected=true;}
    check(rejected&&capture()==expected,"Unknown ID was accepted or partially mutated scene");
    nodes.at("probe.atlas_preview").node->removeFromParentAndCleanup(true);bool deletedRejected=false;
    try{save();}catch(const std::exception&){deletedRejected=true;}
    check(deletedRejected&&readLayout(localFile)==expected,"Deleted node save damaged profile");
    restore();reload();check(capture()==expected,"Deleted node not recovered by restore/reload");
    log("LAYOUT_SMOKE_WRITE_PASSED: save, restore, reload, unknown-ID transaction, deleted-node recovery");
}
void LayoutEditor::smokeRead() {
    auto p=nodes.at("probe.status").node->getPosition();check(p.x==123&&p.y==91,"Layout did not persist across process restart");
    auto logo=nodes.at("probe.logo").node->getPosition();check(logo.x==7&&logo.y==9,"Logo overrides lost on load/recreation");
    check(dynamic_cast<ax::LabelProtocol*>(nodes.at("probe.status").node)->getString()=="Layout persistente","Label text lost after restart");
    check(dynamic_cast<ax::Sprite*>(nodes.at("probe.atlas_preview").node)->isFlippedX(),"Sprite flip lost after restart");
    log("LAYOUT_SMOKE_READ_PASSED: position restored across process restart");
}
}
