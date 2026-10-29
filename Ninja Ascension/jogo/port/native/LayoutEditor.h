#pragma once
#include "axmol.h"
#include "LayoutOverrides.h"
#include "base/RefPtr.h"
#include <functional>

namespace nr {
class LayoutEditor {
public:
    LayoutEditor(std::filesystem::path local,std::filesystem::path defaults,std::function<void(const std::string&)> log);
    void bindTree(ax::Node* node,const std::string& id);
    void bindNode(ax::Node* node,const std::string& id);
    void replaceTree(ax::Node* node,const std::string& id);
    void loadInitial();
    void save();
    void reload();
    void restore();
    void draw();
    void smokeWrite();
    void smokeRead();
    std::function<void()> playAudio,togglePreview;
    std::function<bool()> previewPaused;
private:
    struct Entry {ax::Node* node;LayoutState baseline;ax::RefPtr<ax::Node> keepAlive;ax::Node* originalParent;};
    std::map<std::string,Entry> nodes;
    LayoutStates saved;
    std::filesystem::path localFile,defaultFile;
    std::function<void(const std::string&)> log;
    std::string message="Ajustes ainda nao salvos";
    bool messageIsError=false,announced=false;
    int frames=0;
    LayoutStates capture() const;
    void apply(const LayoutStates& states,bool reset);
    void restoreNodes();
    void status(const std::string& text,bool error=false);
    void action(const std::function<void()>& f);
};
}
