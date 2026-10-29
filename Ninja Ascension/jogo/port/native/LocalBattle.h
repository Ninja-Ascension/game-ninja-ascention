#pragma once
#include "axmol.h"
#include "LegacyCharacter.h"
#include <functional>
#include <string>
#include <vector>
#include <array>
struct lua_State;
namespace nr {
class LocalBattle : public ax::Node {
public:
    struct Snapshot {
        std::string phase,actor;
        int turn{},heroHp{},heroMax{},enemyHp{},enemyMax{},damage{};
    };
private:
    // Etapa-3 slice 2: playback rows sampled from the ORIGINAL simulator per
    // rountdFight step (sandbox NRBattle.roundSamples): per seat hp + dead flag.
    struct PlayRow{int round{};int wave{};int step{};int hp0[6]{},hp1[6]{};bool d0[6]{},d1[6]{};int seat0{-1},seat1{-1};};
    struct StepSkill{int step{};int camp{};int seat{};std::string kind;std::string name;};
    std::vector<PlayRow> playback;
    size_t playbackIndex=0;float playbackRemaining=0;bool playbackActive=false;
    ax::RefPtr<LegacyCharacter> cast0[6],cast1[6]; // full-cast pool (per occupied seat)
    std::vector<std::array<int,2>> pairList;std::vector<std::string> pairLabels;int pairSelected=-1;
    void startPlayback();
    void applyPair(size_t index);
    void spawnDelta(ax::Node* anchor,float delta); // floating real hp-delta number
    void loadStepSkills(); // per-step skill events from live counters
    void spawnSkillTag(ax::Node* anchor,const std::string& kind,const std::string& name);
    std::vector<StepSkill> stepSkills;
    void updateRosterLabels(int wave); // real per-seat identity tags from data
    ax::RefPtr<ax::Label> roster0[6],roster1[6];
    int rosterWaveShown=-1;
    lua_State* lua{};
    Snapshot state;
    ax::RefPtr<LegacyCharacter> hero,enemy;
    ax::RefPtr<ax::DrawNode> bars;
    ax::RefPtr<ax::Label> hpLabel,resultLabel;
    float remaining=0;
    bool active=false;
    std::string error;
    std::function<void(const std::string&)> log;
    Snapshot dispatch(const char* action);
    void action(const char* action);
    void refresh();
    void loadPlayback(const std::string& csv);
    void playbackRefresh(const PlayRow& row);
    void playbackAdvance();
public:
    static LocalBattle* create(lua_State* lua,std::function<void(const std::string&)> log);
    std::function<void(bool)> onModeChanged;
    void drawControls();
    void update(float dt) override;
    bool isActive()const{return active;}
    void setActive(bool value);
    void smokeTest();
    // Plain-launch data load: original report pipeline + pairs + samples.
    // Called once on normal startup (outside the automation smoke) so the
    // "Luta original" combo and replay are available by double-clicking.
    void prepareOriginalBattle();
    // Automates-only: opens the visual turn-1 state (no assertions) so a frame
    // can be captured while the battle is active; leave with setActive(false).
    void enterForCapture();
};
}
