#pragma once
#include <array>
#include <filesystem>
#include <map>
#include <string>
#include <optional>

namespace nr {
struct LayoutState {
    std::array<double,2> position{},scale{1,1},rotation{},anchor{},size{};
    std::array<int,3> color{255,255,255};
    int opacity=255,z=0;
    double globalZ=0;
    std::optional<std::string> text;
    std::optional<std::array<bool,2>> flip;
    bool visible=true;
    bool operator==(const LayoutState&) const = default;
};
using LayoutStates=std::map<std::string,LayoutState>;
// Strict, transactional parsing; no scene mutation occurs in this module.
LayoutStates readLayout(const std::filesystem::path& file);
void writeLayoutAtomic(const std::filesystem::path& file,const LayoutStates& states);
}
