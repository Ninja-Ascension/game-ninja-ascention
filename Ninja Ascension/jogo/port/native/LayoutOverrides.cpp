#include "LayoutOverrides.h"
#include "rapidjson/document.h"
#include "rapidjson/prettywriter.h"
#include "rapidjson/stringbuffer.h"
#include <cmath>
#include <fstream>
#include <set>
#include <stdexcept>
#include <windows.h>

namespace nr {
namespace {
using Value=rapidjson::Value;
void require(bool ok,const std::string& message) {if(!ok)throw std::runtime_error(message);}
void keys(const Value& obj,const std::set<std::string>& allowed,const std::set<std::string>& optional={}) {
    require(obj.IsObject(),"Expected JSON object");std::set<std::string> seen;
    for(auto i=obj.MemberBegin();i!=obj.MemberEnd();++i) {
        std::string key(i->name.GetString(),i->name.GetStringLength());
        require(allowed.contains(key)||optional.contains(key),"Unknown property: "+key);
        require(seen.insert(key).second,"Duplicate property: "+key);
    }
    for(const auto& key:allowed)require(seen.contains(key),"Missing layout property: "+key);
}
const Value& member(const Value& obj,const char* name) {require(obj.HasMember(name),std::string("Missing ")+name);return obj[name];}
std::array<double,2> pair(const Value& obj,const char* name) {
    const auto& v=member(obj,name);require(v.IsArray()&&v.Size()==2,std::string("Expected two numbers: ")+name);
    std::array<double,2> r;
    for(int i=0;i<2;++i){require(v[i].IsNumber(),std::string("Invalid number: ")+name);r[i]=v[i].GetDouble();require(std::isfinite(r[i])&&std::abs(r[i])<=1e7,"Layout number out of range");}
    return r;
}
void validate(const LayoutState& s) {
    for(auto p:{s.position,s.scale,s.rotation,s.anchor,s.size})for(double x:p)require(std::isfinite(x)&&std::abs(x)<=1e7,"Layout number out of range");
    require(s.size[0]>=0&&s.size[1]>=0,"Negative content size");
    require(s.opacity>=0&&s.opacity<=255,"Opacity out of range");
    for(auto c:s.color)require(c>=0&&c<=255,"Color out of range");
    require(std::isfinite(s.globalZ)&&std::abs(s.globalZ)<=1e7,"Global Z out of range");
    if(s.text)require(s.text->size()<=65536&&s.text->find('\0')==std::string::npos,"Invalid label text");
}
void validId(const std::string& id) {require(id.starts_with("probe.")&&id.size()<=2048&&id.find('\0')==std::string::npos,"Invalid node ID");}
}
LayoutStates readLayout(const std::filesystem::path& file) {
    auto bytes=std::filesystem::file_size(file);require(bytes<=4*1024*1024,"Layout file exceeds 4 MiB");
    std::ifstream in(file,std::ios::binary);require(bool(in),"Cannot read layout file");
    std::string text((std::istreambuf_iterator<char>(in)),{});
    require(!in.bad(),"Layout read failed");rapidjson::Document doc;
    doc.Parse<rapidjson::kParseValidateEncodingFlag>(text.data(),text.size());require(!doc.HasParseError(),"Invalid layout JSON at offset "+std::to_string(doc.GetErrorOffset()));
    keys(doc,{"schema","scene","nodes"});
    require(doc["schema"].IsInt()&&doc["schema"].GetInt()==1,"Unsupported layout schema");
    require(doc["scene"].IsString()&&std::string(doc["scene"].GetString(),doc["scene"].GetStringLength())=="resource_probe","Wrong layout scene");
    const auto& nodes=doc["nodes"];require(nodes.IsObject(),"nodes must be an object");require(nodes.MemberCount()<=10000,"Too many layout nodes");
    LayoutStates result;
    for(auto i=nodes.MemberBegin();i!=nodes.MemberEnd();++i) {
        std::string id(i->name.GetString(),i->name.GetStringLength());validId(id);const auto& v=i->value;
        keys(v,{"position","scale","rotationSkew","anchor","contentSize","visible","localZOrder","color","opacity"},{"globalZOrder","text","flip"});
        LayoutState s;s.position=pair(v,"position");s.scale=pair(v,"scale");s.rotation=pair(v,"rotationSkew");s.anchor=pair(v,"anchor");s.size=pair(v,"contentSize");
        require(v["visible"].IsBool(),"visible must be boolean");s.visible=v["visible"].GetBool();
        require(v["localZOrder"].IsInt()&&v["opacity"].IsInt(),"Invalid integer property");s.z=v["localZOrder"].GetInt();s.opacity=v["opacity"].GetInt();
        const auto& col=v["color"];require(col.IsArray()&&col.Size()==3,"Invalid RGB color");
        for(int c=0;c<3;++c){require(col[c].IsInt(),"Invalid RGB component");s.color[c]=col[c].GetInt();}
        if(v.HasMember("globalZOrder")){require(v["globalZOrder"].IsNumber(),"Invalid global Z");s.globalZ=v["globalZOrder"].GetDouble();}
        if(v.HasMember("text")){require(v["text"].IsString(),"Invalid label text");s.text=std::string(v["text"].GetString(),v["text"].GetStringLength());}
        if(v.HasMember("flip")){const auto& f=v["flip"];require(f.IsArray()&&f.Size()==2&&f[0].IsBool()&&f[1].IsBool(),"Invalid sprite flip");s.flip=std::array<bool,2>{f[0].GetBool(),f[1].GetBool()};}
        validate(s);require(result.emplace(id,s).second,"Duplicate node ID: "+id);
    }
    return result;
}
void writeLayoutAtomic(const std::filesystem::path& file,const LayoutStates& states) {
    require(states.size()<=10000,"Too many layout nodes");
    rapidjson::StringBuffer buffer;rapidjson::PrettyWriter<rapidjson::StringBuffer> w(buffer);
    w.StartObject();w.Key("schema");w.Int(1);w.Key("scene");w.String("resource_probe");w.Key("nodes");w.StartObject();
    for(const auto& [id,s]:states) {
        validId(id);validate(s);w.Key(id.data(),static_cast<rapidjson::SizeType>(id.size()));w.StartObject();
        auto pair=[&](const char* key,const std::array<double,2>& a){w.Key(key);w.StartArray();w.Double(a[0]);w.Double(a[1]);w.EndArray();};
        pair("position",s.position);pair("scale",s.scale);pair("rotationSkew",s.rotation);pair("anchor",s.anchor);pair("contentSize",s.size);
        w.Key("visible");w.Bool(s.visible);w.Key("localZOrder");w.Int(s.z);w.Key("globalZOrder");w.Double(s.globalZ);w.Key("color");w.StartArray();for(int c:s.color)w.Int(c);w.EndArray();w.Key("opacity");w.Int(s.opacity);
        if(s.text){w.Key("text");w.String(s.text->data(),static_cast<rapidjson::SizeType>(s.text->size()));}
        if(s.flip){w.Key("flip");w.StartArray();w.Bool((*s.flip)[0]);w.Bool((*s.flip)[1]);w.EndArray();}
        w.EndObject();
    }
    w.EndObject();w.EndObject();require(buffer.GetSize()<=4*1024*1024,"Serialized layout exceeds 4 MiB");
    if(!file.parent_path().empty())std::filesystem::create_directories(file.parent_path());
    auto temp=file;temp+=L".tmp-"+std::to_wstring(GetCurrentProcessId())+L"-"+std::to_wstring(GetTickCount64());
    HANDLE h=CreateFileW(temp.c_str(),GENERIC_WRITE,0,nullptr,CREATE_NEW,FILE_ATTRIBUTE_NORMAL,nullptr);
    require(h!=INVALID_HANDLE_VALUE,"Cannot create temporary layout file (Windows error "+std::to_string(GetLastError())+")");
    DWORD written=0;bool ok=WriteFile(h,buffer.GetString(),static_cast<DWORD>(buffer.GetSize()),&written,nullptr)&&written==buffer.GetSize();
    if(ok)ok=FlushFileBuffers(h)!=0;
    DWORD error=ok?ERROR_SUCCESS:GetLastError();CloseHandle(h);
    if(ok&&!MoveFileExW(temp.c_str(),file.c_str(),MOVEFILE_REPLACE_EXISTING|MOVEFILE_WRITE_THROUGH)){ok=false;error=GetLastError();}
    if(!ok){DeleteFileW(temp.c_str());throw std::runtime_error("Atomic layout save failed (Windows error "+std::to_string(error)+")");}
}
}
