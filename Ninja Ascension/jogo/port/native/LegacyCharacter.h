#pragma once
#include "axmol.h"
#include <memory>
#include <string>
#include <vector>
struct lua_State;
namespace nr {
// Isolated adapter for unchanged, pinned Spine 2.1 runtime; no modern Spine bindings.
class LegacyCharacter : public ax::Node {
    struct State;
    std::unique_ptr<State> state;
public:
    LegacyCharacter();
    ~LegacyCharacter() override;
    static LegacyCharacter* create(const std::string& base,const std::string& atlasFile="",float dataScale=1);
    void update(float dt) override;
    void drawControls();
    void verifyAnimations();
    void play(const std::string& animation,bool loop=true);
    static void registerLua(lua_State* lua);
};
}
