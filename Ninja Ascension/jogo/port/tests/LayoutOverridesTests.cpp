#include "LayoutOverrides.h"
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <limits>
static void check(bool b,const char* message){if(!b)throw std::runtime_error(message);}
template<class F> void rejects(F f){bool failed=false;try{f();}catch(const std::exception&){failed=true;}check(failed,"Expected rejection");}
int main(int argc,char** argv) {
    try {
        check(argc==2,"Pass a new test directory");std::filesystem::path dir=argv[1];
        check(!std::filesystem::exists(dir),"Test directory must not already exist");std::filesystem::create_directories(dir);
        auto file=dir/"layout.json";nr::LayoutState s;s.position={123,91};s.scale={-1,0.5};s.size={200,60};s.z=-5;s.opacity=128;s.visible=false;
        s.text="Layout persistente";s.flip=std::array<bool,2>{true,false};s.globalZ=2.5;
        nr::LayoutStates expected{{"probe.status",s}};nr::writeLayoutAtomic(file,expected);check(nr::readLayout(file)==expected,"Round trip failed");
        s.position={44,55};expected["probe.status"]=s;nr::writeLayoutAtomic(file,expected);check(nr::readLayout(file)==expected,"Atomic replacement failed");
        auto invalid=expected;invalid.begin()->second.scale[0]=std::numeric_limits<double>::infinity();rejects([&]{nr::writeLayoutAtomic(file,invalid);});check(nr::readLayout(file)==expected,"Failed save damaged old data");
        auto bad=dir/"bad.json";auto put=[&](const std::string& text){std::ofstream out(bad);out<<text;};
        put("{");rejects([&]{nr::readLayout(bad);});
        put(R"({"schema":2,"scene":"resource_probe","nodes":{}})");rejects([&]{nr::readLayout(bad);});
        put(R"({"schema":1,"scene":"wrong","nodes":{}})");rejects([&]{nr::readLayout(bad);});
        put(R"({"schema":1,"schema":1,"scene":"resource_probe","nodes":{}})");rejects([&]{nr::readLayout(bad);});
        std::ifstream in(file);std::string text((std::istreambuf_iterator<char>(in)),{});auto pos=text.find("\"visible\": false");check(pos!=std::string::npos,"Missing visible");text.replace(pos,16,"\"visible\": 12345");put(text);rejects([&]{nr::readLayout(bad);});
        // A directory target forces replacement failure; the previous data and directory must survive.
        auto blocked=dir/"blocked";std::filesystem::create_directory(blocked);rejects([&]{nr::writeLayoutAtomic(blocked,expected);});check(std::filesystem::is_directory(blocked),"Failed save altered target directory");
        std::cout<<"LAYOUT_STORE_TESTS_PASSED: roundtrip, replacement, nonfinite, malformed, schema, scene, duplicate, type, IO failure\n";return 0;
    } catch(const std::exception& e){std::cerr<<e.what()<<"\n";return 1;}
}
