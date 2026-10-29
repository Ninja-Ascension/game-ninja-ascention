// Isolated M1 diagnostic. Never launches recovered main.lua or online services.
#include "axmol.h"
#include "audio/AudioEngine.h"
#include "cocostudio/CocoStudio.h"
#include "lua-bindings/manual/LuaEngine.h"
#include "lua-bindings/manual/lua_module_register.h"
#include "Inspector/Inspector.h"
#include "ImGui/imgui.h"
#include "ImGui/ImGuiPresenter.h"
#include "LayoutEditor.h"
#include "LegacyCharacter.h"
#include "LocalBattle.h"
#include "protocol/NinjaProtoNatives.h"
#include "base/Utils.h"
#include <filesystem>
#include <fstream>
#include <stdexcept>
#include <cstdlib>
#include <iostream>
#include <memory>

#if defined(_WIN32)
#include <Windows.h>
#include <DbgHelp.h>
#pragma comment(lib, "Dbghelp.lib")
#endif

using namespace ax;
namespace {

// Relatorio de falha nativa.
//
// Motivo medido: depois de battle_result_start o processo FECHAVA sem que o
// servidor registrasse qualquer record_crash — ou seja, sem excecao Lua. Um
// encerramento assim so pode vir de falha nativa (acesso invalido, stack
// overflow, abort). Sem um handler instalado, o Windows fecha o processo em
// silencio e perdemos o unico dado que localizaria o defeito.
//
// Aqui instalamos um filtro que, ao capturar a falha, grava em
// build/probe-writable/falha-nativa.txt o codigo da excecao, os simbolos
// carregados e a PILHA de chamadas com nomes de funcao e linhas. Nada e
// alterado no comportamento do jogo quando nao ha falha.
#if defined(_WIN32)
LONG WINAPI nrGravarFalhaNativa(EXCEPTION_POINTERS* info)
{
    static bool jaGravou = false;
    if (jaGravou) return EXCEPTION_EXECUTE_HANDLER;
    jaGravou = true;

    HANDLE processo = GetCurrentProcess();
    SymSetOptions(SYMOPT_LOAD_LINES | SYMOPT_UNDNAME | SYMOPT_DEFERRED_LOADS);
    SymInitialize(processo, nullptr, TRUE);

    std::ofstream out("build/probe-writable/falha-nativa.txt",
                      std::ios::out | std::ios::trunc);
    if (!out.is_open())
        out.open("../../../../probe-writable/falha-nativa.txt",
                 std::ios::out | std::ios::trunc);
    if (!out.is_open())
        return EXCEPTION_EXECUTE_HANDLER;

    const EXCEPTION_RECORD* ex = (info != nullptr) ? info->ExceptionRecord : nullptr;
    out << "codigo=0x" << std::hex
        << (ex != nullptr ? static_cast<unsigned long>(ex->ExceptionCode) : 0ul)
        << std::dec << "\n";
    if (ex != nullptr)
    {
        out << "endereco=0x" << std::hex
            << reinterpret_cast<uintptr_t>(ex->ExceptionAddress)
            << std::dec << "\n";
    }
    out << "pilha:\n";

    CONTEXT contexto = {};
    if (info != nullptr) contexto = *info->ContextRecord;

    STACKFRAME64 quadro = {};
    DWORD tipoMaquina = IMAGE_FILE_MACHINE_AMD64;
#if defined(_M_IX86)
    tipoMaquina = IMAGE_FILE_MACHINE_I386;
    quadro.AddrPC.Offset = contexto.Eip;
    quadro.AddrStack.Offset = contexto.Esp;
    quadro.AddrFrame.Offset = contexto.Ebp;
#else
    quadro.AddrPC.Offset = contexto.Rip;
    quadro.AddrStack.Offset = contexto.Rsp;
    quadro.AddrFrame.Offset = contexto.Rbp;
#endif
    quadro.AddrPC.Mode = AddrModeFlat;
    quadro.AddrStack.Mode = AddrModeFlat;
    quadro.AddrFrame.Mode = AddrModeFlat;

    HANDLE thread = GetCurrentThread();
    for (int i = 0; i < 64; ++i)
    {
        if (!StackWalk64(tipoMaquina, processo, thread, &quadro, &contexto,
                         nullptr, SymFunctionTableAccess64, SymGetModuleBase64,
                         nullptr))
            break;
        if (quadro.AddrPC.Offset == 0) break;

        out << "  [" << i << "] 0x" << std::hex << quadro.AddrPC.Offset << std::dec;
        // module+offset survives ASLR, so a report from another PC can be
        // resolved against the PDB kept on the build machine.
        DWORD64 baseModulo = SymGetModuleBase64(processo, quadro.AddrPC.Offset);
        if (baseModulo != 0)
        {
            char modulo[MAX_PATH] = {};
            GetModuleFileNameA(reinterpret_cast<HMODULE>(baseModulo), modulo, MAX_PATH);
            const char* nome = strrchr(modulo, '\\');
            out << " " << (nome ? nome + 1 : modulo) << "+0x" << std::hex
                << (quadro.AddrPC.Offset - baseModulo) << std::dec;
        }

        char buffer[sizeof(SYMBOL_INFO) + MAX_SYM_NAME] = {};
        auto* simbolo = reinterpret_cast<SYMBOL_INFO*>(buffer);
        simbolo->SizeOfStruct = sizeof(SYMBOL_INFO);
        simbolo->MaxNameLen = MAX_SYM_NAME;
        DWORD64 deslocamento = 0;
        if (SymFromAddr(processo, quadro.AddrPC.Offset, &deslocamento, simbolo))
        {
            out << " " << simbolo->Name;
            IMAGEHLP_LINE64 linha = {};
            linha.SizeOfStruct = sizeof(IMAGEHLP_LINE64);
            DWORD coluna = 0;
            if (SymGetLineFromAddr64(processo, quadro.AddrPC.Offset, &coluna, &linha))
                out << " (" << linha.FileName << ":" << linha.LineNumber << ")";
        }
        out << "\n";
    }
    out.flush();
    out.close();
    return EXCEPTION_EXECUTE_HANDLER;
}

// Filtro de termino: grava tambem quando o processo chama exit/abort.
void nrInstalarFiltrosDeFalha()
{
    SetUnhandledExceptionFilter(nrGravarFalhaNativa);
}
#else
void nrInstalarFiltrosDeFalha() {}
#endif

// Shared by the automation host case and the plain-launch button (Etapa 6).
// Runs 1s after the fwin scene swap: fires the logo's own lifecycle builder
// if the engine never did, then schedules the ORIGINAL Windows transition to
// the login window (logo.lua:69-70; the path is deactivated in the recovered
// source by an 'and false' at logo.lua:48). Offline steps land on the send
// fence. Analysis markers only — no original file is reinterpreted here.
constexpr char REAL_CHAIN_CHECK_LUA[] = R"(
nrgate = nrgate or {}
local function census(tag)
  -- The login window opened into fwin._view, NOT the screen layer — every
  -- window container must be scanned or live censuses look empty while the
  -- game is running normally.
  local names={}
  local function scan(node)
    if node==nil then return end
    -- fwin containers are LUA TABLES shaped {_layer=<node>, _z=n} (fwin.lua:14)
    -- — the real node is one level down. Recurse tables into their _layer/
    -- _view members; anything else with getChildren is scanned as a node.
    if type(node)=='table' then
      scan(node._layer)
      scan(node._view)
      return
    end
    local okKids,kids=pcall(function() return node:getChildren() end)
    if not (okKids and kids~=nil) then return end
    for _,c in ipairs(kids) do
      local ok,nm=pcall(function() return c.__cname end)
      names[#names+1]=tostring(ok and nm or 'obj')
    end
  end
  -- fwin._list is the CANONICAL registry of live windows (fwin.lua:415);
  -- windows open via fwin:push(win, win._view or passedLayer), so the
  -- effective container is the WINDOW'S own choice — scan every one.
  if type(fwin._list)=='table' then
    for _,w in pairs(fwin._list) do
      local ok,nm=pcall(function() return w.__cname end)
      names[#names+1]=tostring(ok and nm or 'win')
    end
  end
  local containers={'_background','_frameview','_view','_dview','_viewdialog',
                    '_taskbar','_ui','_windows','_dialog','_notification',
                    '_screen','_system','_display_log'}
  for _,name in ipairs(containers) do scan(fwin[name]) end
  print('HOST_WINDOW_CENSUS '..tag..' '..table.concat(names,','))
end
local logoWin = fwin:find('LogoClass')
if logoWin ~= nil then
  local n = 0; pcall(function() n = logoWin:getChildrenCount() end)
  if n == 0 then
    local ok, err = pcall(function() logoWin:onEnterTransitionFinish() end)
    print('HOST_LOGO_LIFECYCLE fired='..tostring(ok)..' err='..tostring(err))
  end
  n = 0; pcall(function() n = logoWin:getChildrenCount() end)
  print('HOST_LOGO_RECHECK logo_children='..tostring(n))
else
  -- The logo's own timeline frame events may self-exit the window (the
  -- original logo.lua exit paths). The login transition below must NOT
  -- depend on the logo still existing.
  print('HOST_LOGO_RECHECK logo=self-exited')
end
if fwin:find('LoginClass') == nil and not nrgate.login then
  -- Repeating rechecks must NOT stack login schedules: one gate, one open.
  nrgate.login = true
  local sched = cc.Director:getInstance():getScheduler()
  local entryId = nil
  local openLogin = function()
    if fwin:find('LoginClass') ~= nil then return end
    print('HOST_LOGIN_OPEN_BEGIN')
    local okOpen, errOpen = xpcall(function()
      -- Faithful replay of the DEAD Windows branch (logo.lua:48-70; the
      -- 'and false' at 48 deactivates it in the recovered source): the four
      -- active lines are fwin:reset(); app.load("client.login.AssetsManager");
      -- app.load("client.login.login"); fwin:open(Login:new(), fwin._view).
      -- Without fwin:reset() the logo window stays ON TOP and the login
      -- opens underneath — the screen appears stuck on the splash art.
      fwin:reset()
      app.load('client.login.AssetsManager')
      app.load('client.login.login')
      fwin:open(Login:new(), fwin._view)
    end, debug.traceback)
    if not okOpen then
      -- Loud: the visible blink is this path failing before the window fully
      -- builds (the guard stays nil and the 4s schedule would retry forever).
      print('HOST_LOGIN_OPEN_FAILED ' .. tostring(errOpen))
      if entryId ~= nil then
        pcall(function() sched:unscheduleScriptEntry(entryId) end)
        entryId = nil
      end
      return
    end
    print('HOST_LOGIN_OPENED login='..tostring(fwin:find('LoginClass') ~= nil))
    if entryId ~= nil then
      pcall(function() sched:unscheduleScriptEntry(entryId) end)
      entryId = nil
    end
  end
  local okSched = pcall(function()
    entryId = sched:scheduleScriptFunc(openLogin, 4.0, false)
  end)
  if not okSched then
    print('HOST_LOGIN_SCHEDULER_UNAVAILABLE opening immediately')
    openLogin()
  else
    print('HOST_LOGIN_SCHEDULED delay=4.0 (logo waitTime=3) retry=once-per-fail-then-stop')
  end
  -- Watch the living window stack: logo -> login -> (server list/loading).
  -- Repeats every 8s; each print names the currently open window classes.
  -- Gated: one watcher total, no matter how many times this script runs.
  if not nrgate.census then
    nrgate.census = true
    pcall(function()
      sched:scheduleScriptFunc(function() census('live') end, 8.0, false)
    end)
  end
  -- Fase 2 self-test: the real protocol round-trip against the approved
  -- local server (127.0.0.1:18080) using the game's own native bindings:
  -- command text -> cc.deflateMemory -> CBlowFish wrapper -> XHR send_d ->
  -- server reply -> decrypt -> inflate -> printable answer. If the local
  -- server is not running, the same print shows status=0 (informational).
  -- No click is simulated and no game state is touched.
  if not nrgate.xhr then
    nrgate.xhr = true
    local ok, err = pcall(function()
      local req = cc.DBytes:new('0\r\nnew_get_server_list\r\nselftest-ver\r\nlocal,pc,probe\r\npkg,0.0')
      cc.deflateMemory(req)
      local bf = cc.CBlowFish:new('K(7a!ykjTD&DAp0!')
      bf:Encrypt(req)
      local x = cc.XMLHttpRequest:new()
      x:open('POST', 'http://127.0.0.1:18080/iniServer')
      x:registerScriptHandler(function()
        local rd = cc.DBytes:new('0')
        x:data(rd)
        if x.status == 0 then
          print('HOST_XHR_PROTOCOL_TEST status=0 (server local nao esta ligado)')
        else
          bf:Decrypt(rd)
          cc.inflateMemory(rd)
          print('HOST_XHR_PROTOCOL_TEST status='..tostring(x.status)..' resp='..rd:getBytes())
        end
      end)
      x:send_d(req)
    end)
    if not ok then print('HOST_XHR_PROTOCOL_TEST luaerror: '..tostring(err)) end
  end
end
census('swapped')
)";
// TEST-MODE ONLY: proves the archive's OWN S2C parsers (vali_register 57,
// login_init 3) consume the local server's live answers with exact token
// alignment. Transport rides the game's native bindings (cc.DBytes +
// deflateMemory + CBlowFish + XMLHttpRequest). NetworkProtocol.sequence
// and lock are saved/restored; no window is opened or clicked.
constexpr char PARSE_CHAIN_TEST_LUA[] = R"(
if not nrgate.parsechain then
  nrgate.parsechain = true
  local ok, errpc = pcall(function()
    local psched = cc.Director:getInstance():getScheduler()
    local st = { step = 'idle', body = nil, fail = nil, n = 0, status = nil }
    local savedSeq = NetworkProtocol.sequence
    local savedLock = NetworkProtocol.lock
    local function makeList(text)
      local lines = lua_string_split_line(text, "\r\n")
      local list = lua_string_splits(lines, " ")
      list.pos = 1
      return list
    end
    local function sendCmd(texto)
      local req = cc.DBytes:new(texto)
      cc.deflateMemory(req)
      local bf = cc.CBlowFish:new('K(7a!ykjTD&DAp0!')
      bf:Encrypt(req)
      local x = cc.XMLHttpRequest:new()
      x:open('POST', 'http://127.0.0.1:18080/iniServer')
      x:registerScriptHandler(function()
        if x.readyState == 4 then
          local rd = cc.DBytes:new('0')
          x:data(rd)
          if x.status == 0 then
            st.body = nil
            st.fail = 'status=0 (servidor local desligado)'
          else
            bf:Decrypt(rd)
            cc.inflateMemory(rd)
            st.body = rd:getBytes()
            st.status = x.status
          end
        end
      end)
      x:send_d(req)
    end
    local function terminar(msg)
      NetworkProtocol.sequence = savedSeq
      NetworkProtocol.lock = savedLock
      print('HOST_PARSE_CHAIN '..msg..' (seq/lock restaurados)')
    end
    local pollId
    pollId = psched:scheduleScriptFunc(function()
      st.n = st.n + 1
      if st.n > 300 then terminar('TIMEOUT step='..st.step) return end
      if st.step == 'idle' then
        st.fail = nil; st.body = nil
        sendCmd('499\r\nnew_get_server_list\r\nprobe-ver\r\nop,pc,probe\r\npkg,0.0')
        st.step = 'list_wait'
      elseif st.step == 'list_wait' then
        if st.fail ~= nil then terminar('lista '..st.fail) return end
        if st.body ~= nil then
          local okp, errp = pcall(function()
            local l = makeList(st.body)
            l.pos = 5
            NetworkProtocol.find_parser(58).parser_fun(nil,nil,nil,nil,l,nil)
            local resto = #l - l.pos + 1
            print('HOST_PARSE_CHAIN lista58 ok selecionado='..tostring(_ED.selected_server)..' resto='..tostring(resto))
          end)
          if not okp then terminar('lista parser error: '..tostring(errp)) return end
          st.body = nil
          st.step = 'vali'
        end
      elseif st.step == 'vali' then
        sendCmd('500\r\nvali_register\r\nlocal_probe\r\n1\r\nop\r\n')
        st.step = 'vali_wait'
      elseif st.step == 'vali_wait' then
        if st.fail ~= nil then terminar('vali '..st.fail) return end
        if st.body ~= nil then
          local okp, errp = pcall(function()
            local l = makeList(st.body)
            l.pos = 5
            NetworkProtocol.find_parser(57).parser_fun(nil,nil,nil,nil,l,nil)
            local resto = #l - l.pos + 1
            print('HOST_PARSE_CHAIN vali57 ok user='..tostring(_ED.default_user)..' resto='..tostring(resto))
          end)
          if not okp then terminar('vali parser error: '..tostring(errp)) return end
          st.body = nil
          st.step = 'login'
        end
      elseif st.step == 'login' then
        sendCmd('501\r\nlogin_init\r\nprobe\r\nconvidado_local\r\n1\r\npwd\r\napp\r\n1')
        st.step = 'login_wait'
      elseif st.step == 'login_wait' then
        if st.fail ~= nil then terminar('login '..st.fail) return end
        if st.body ~= nil then
          local okp, errp = pcall(function()
            local l = makeList(st.body)
            l.pos = 5
            NetworkProtocol.find_parser(3).parser_fun(nil,nil,nil,nil,l,nil)
            local resto = #l - l.pos + 1
            print('HOST_PARSE_CHAIN login3 ok nome='..tostring(_ED.user_info.user_name)..
                  ' nivel='..tostring(_ED.user_info.user_grade)..' resto='..tostring(resto))
          end)
          st.step = 'done'
          if not okp then terminar('login parser error: '..tostring(errp)) return end
          terminar('ok status='..tostring(st.status))
        end
      end
    end, 0.3, false)
  end)
  if not ok then print('HOST_PARSE_CHAIN luaerror: '..tostring(errpc)) end
end
)";
std::ofstream logFile;
int testExitCode=0;void report(const std::string& message) {
    logFile << message << std::endl;
    std::cerr << message << std::endl;
    OutputDebugStringA((message + "\n").c_str());
}
class Probe : public Application {
    Scene* scene{};
    Node* timelineNode{};
    nr::LegacyCharacter* character{};
    ax::RefPtr<nr::LocalBattle> battle;
    std::vector<std::pair<ax::RefPtr<Node>,bool>> previewVisibility;
    ax::RefPtr<cocostudio::timeline::ActionTimeline> timelineAction;
    std::unique_ptr<nr::LayoutEditor> layoutEditor;
    bool paused=true;
    bool shotPending{false};
    int audioRequests=0;
    bool audioReady{};
    std::string audioPath;
    void playAudio() {
        if (!audioReady) throw std::runtime_error("Audio backend unavailable");
        AudioEngine::stopAll();
        auto id = AudioEngine::play2d(audioPath, false, 0.4f);
        if (id == AudioEngine::INVALID_AUDIO_ID) throw std::runtime_error("AudioEngine rejected original MP3");
        ++audioRequests;
        report("AUDIO_REQUEST_ACCEPTED (audible playback still requires manual verification)");
    }
    void restartTimeline() {
        ax::RefPtr<Node> old(timelineNode);
        auto next=CSLoader::createNode("cocostudio/login/logo.csb");
        if (!next) throw std::runtime_error("Original timeline node load failed");
        next->setName("probe.logo");
        scene->addChild(next, 1);
        auto action = CSLoader::createTimeline("cocostudio/login/logo.csb");
        if (!action) throw std::runtime_error("Original timeline load failed");
        next->runAction(action);
        action->gotoFrameAndPlay(0, true);
        if(paused)action->pause();
        // Capture/rebind editable values while the old subtree is still alive.
        if(layoutEditor)layoutEditor->replaceTree(next,"probe.logo");
        timelineNode=next;timelineAction=action;
        if(old)old->removeFromParent();
        if(layoutEditor){auto inspector=ax::extension::Inspector::getInstance();inspector->close();inspector->openForScene(scene);}
        report(paused?"TIMELINE_READY paused for editing":"TIMELINE_STARTED");
    }
    void togglePreview() {
        if(timelineNode->getNumberOfRunningActions()==0)restartTimeline();
        paused=!paused;
        if(paused){timelineAction->pause();AudioEngine::pauseAll();}
        else{timelineAction->resume();AudioEngine::resumeAll();}
        report(paused?"PREVIEW_PAUSED (Inspector remains active)":"PREVIEW_RESUMED");
    }
public:
    void initGfxContextAttrs() override {
        GfxContextAttrs attributes={8,8,8,8,24,8,0};
        RenderView::setGfxContextAttrs(attributes);
    }
    bool applicationDidFinishLaunching() override {
        try {
            // Project policy (user requirement): NOTHING is stored on the C:
            // drive. All probe writes (diagnostic log, UserDefault, crash
            // reports, the original game's writable-path traffic) live inside
            // the workspace under build/probe-writable (gitignored) and can be
            // redirected with NR_PROBE_WRITABLE for special runs.
            const char* gameRootOverride = std::getenv("NR_GAME_ROOT");
            const std::string root = (gameRootOverride && *gameRootOverride)
                ? std::filesystem::path(gameRootOverride).generic_string() : NR_ROOT;
            const char* writableOverride = std::getenv("NR_PROBE_WRITABLE");
            std::filesystem::path writable = (writableOverride && *writableOverride)
                ? std::filesystem::path(writableOverride)
                : std::filesystem::path(root)/"build"/"probe-writable";
            std::filesystem::create_directories(writable);
            logFile.open(writable/"resource-probe.log", std::ios::trunc);
            if (!logFile) throw std::runtime_error("Cannot open diagnostic log");
            auto files = FileUtils::getInstance();
            files->setWritablePath(writable.generic_string()+"/");
            // Overrides precede the original set: copies under port/resources shadow
            // files inside assets/res (for example port/resources/images/...).
            files->setSearchPaths({root+"/port/lua",root+"/port/resources",root+"/01_conteudo_apk/assets/res",
                                  root+"/01_conteudo_apk/assets/src"});
            // The engine's precompiled shader cards (axslc) are searched under the
            // app root. setSearchPaths replaces the search list wholesale and the
            // original app.init also does that, so the axslc directory must be
            // re-asserted here and again after any Lua boot that rewrites paths
            // (see port/lua/boot_map.lua stage 6).
            files->addSearchPath(root+"/build/windows-probe-native/runtime/axslc");
            auto director = Director::getInstance();
            auto view = RenderViewImpl::createWithRect("NinjaAscension", Rect(0,0,960,640), 1.0f, true);
            view->setWindowSizeLimits(640, 426);
            director->setRenderView(view);
            view->setDesignResolutionSize(960,640,ResolutionPolicy::FIXED_HEIGHT);
            director->setAnimationInterval(1.0/60.0);
            auto engine = LuaEngine::getInstance();
            ScriptEngineManager::getInstance()->setScriptEngine(engine);
            lua_module_register(engine->getLuaStack()->getLuaState());
            // PURE GAME DEFAULT: the probe scaffolding (layout editor, character
            // preview, battle shell, inspector, panels, keys, audio test) only
            // exists when NR_PROBE_PROBE_UI=1 or NR_PROBE_TEST_MODE is set.
            const bool probeShellWanted=((std::getenv("NR_PROBE_PROBE_UI")!=nullptr)||(std::getenv("NR_PROBE_TEST_MODE")!=nullptr));
            if (engine->executeScriptFile("compatibility.lua") != 1)
                throw std::runtime_error("Lua compatibility contract failed; see engine traceback");
            // The exploratory battle loader can run boot_map immediately.
            // Register natives BEFORE it chooses any compatibility fallback.
            nrproto::registerAll(engine->getLuaStack()->getLuaState());
            nr::LegacyCharacter::registerLua(engine->getLuaStack()->getLuaState());
            if (probeShellWanted && engine->executeScriptFile("local_battle.lua") != 1)
                throw std::runtime_error("Offline battle Lua boot failed; see engine traceback");
            // Fase 1b: natives de protocolo reconstruídos do libjts.so
            // (cc.DBytes/cc.CBlowFish[mod-0 swap]/deflateMemory/inflateMemory
            //  + cc.XMLHttpRequest HTTP real). Registrado APÓS compatibility.lua
            // porque o adaptador faz cc = ax (a tabela nova recebe os natives).
            if(std::getenv("NR_PROBE_TEST_MODE")){
                const char* bridgeTest=R"lua(
local ok,err=xpcall(function()
 require('native_spine').armar()
 local node=sp.SkeletonAnimation:create('sprite/spirte_102101.json','sprite/spirte_102101.atlas',1)
 local completes=0
 node:registerSpineEventHandler(function(e)
   assert(e.skeletonAnimation==node);completes=completes+1
 end,sp.EventType.ANIMATION_COMPLETE)
 node:setAnimation(0,'07_pugong',false)
 cc.nrSpineCommand(node,'advance',0.1)
 assert(cc.nrSpineCommand(node,'geometry')>0,'Native bridge produced no geometry')
 local duration=node:getAnimationDurationEx('07_pugong')
 cc.nrSpineCommand(node,'advance',duration+0.1)
 assert(completes>0,'Native completion callback missing')
 node:unregisterSpineEventHandler(sp.EventType.ANIMATION_COMPLETE)
 node:clearTracks()
 print('NATIVE_SPINE_BRIDGE_PASSED geometry and completion callback')
end,debug.traceback)
if not ok then error(err) end
return 1
)lua";
                if(engine->executeString(bridgeTest)!=1)throw std::runtime_error("Native Spine bridge test failed");
            }
            {
                // self-test C++ vs golds (mode-0: "01234567" -> "45670123")
                nrproto::GameBlowfish bf;
                bf.setKey((const uint8_t*)nrproto::kArchiveKey, 16);
                uint8_t blk[8];
                memcpy(blk, "01234567", 8);
                bf.encrypt(blk, 8, 0);
                const uint8_t gold[8] = {'4','5','6','7','0','1','2','3'};
                report(std::string("HOST_PROTO_NATIVES registered; mode0 ") +
                       (memcmp(blk, gold, 8) == 0 ? "OK" : "MISMATCH"));
                auto c = nrproto::deflateZlib((const uint8_t*)"0123456789abcdef", 16);
                auto r = c.empty() ? std::vector<uint8_t>{}
                                   : nrproto::inflateZlib(c.data(), c.size());
                report(std::string("HOST_PROTO_DEFLATE c=") + std::to_string(c.size()) +
                       " roundtrip " + (r.size() == 16 && memcmp(r.data(), "0123456789abcdef", 16) == 0
                                            ? "OK" : "MISMATCH"));
                const std::string repeated(131072, '0');
                auto dense=nrproto::deflateZlib(reinterpret_cast<const uint8_t*>(repeated.data()),repeated.size());
                auto expanded=nrproto::inflateZlib(dense.data(),dense.size());
                if(expanded.size()!=repeated.size() || memcmp(expanded.data(),repeated.data(),repeated.size())!=0)
                    throw std::runtime_error("High-compression response regression");
                if(!nrproto::inflateZlib(dense.data(),dense.size()/2).empty())
                    throw std::runtime_error("Truncated response accepted");
                dense.resize(dense.size()+8,0);
                expanded=nrproto::inflateZlib(dense.data(),dense.size());
                if(expanded.size()!=repeated.size())throw std::runtime_error("Padded response rejected");
                report("HOST_PROTO_EXPANSION_PASSED: 128KiB repeated response, padding and truncation");
            }
            scene = Scene::create();
            if(!probeShellWanted){
                // GL warm-up (host requirement): the original app.init hits the
                // shader cache on its first C++ create() calls (app.lua:402).
                // A cold context inside the first presenter tick fails
                // "Shader compile failed" (ANGLE/D3D11 state during ImGui
                // frame compilation). The probe shell used to warm these by
                // constructing the CSB/font/atlas primitives BEFORE the loop;
                // replay exactly that, but nothing is added to the scene — all
                // temporaries are autoreleased.
                CSLoader::createNode("cocostudio/login/login.csb");
                Label::createWithBMFont("fonts/arena_fighting.fnt","1234");
                Sprite::create("sprite/spirte_102101.png");
                // Shared boot bodies (original chain, presenter-tick scheduling —
                // the only timing that behaved in every run).
                auto bootRealChain=[this](){
                    try{
                        int rb=ax::LuaEngine::getInstance()->executeScriptFile("boot_map.lua");
                        report(rb==1?"REAL_CHAIN_BOOT_OK":"REAL_CHAIN_BOOT_FAILED ret="+std::to_string(rb));
                    }catch(const std::exception& e){
                        report(std::string("REAL_CHAIN_BOOT_ERROR: ")+e.what());
                    }
                };
                auto logoRealChain=[this](){
                    try{
                        int r=ax::LuaEngine::getInstance()->executeScriptFile("host_logo.lua");
                        report(r==1?"HOST_LOGO_SCRIPT_OK":"HOST_LOGO_SCRIPT_FAILED ret="+std::to_string(r));
                    }catch(const std::exception& e){
                        report(std::string("HOST_LOGO_SCRIPT_ERROR: ")+e.what());
                    }
                };
                // An EMPTY scene merely hosts the engine until the ORIGINAL fwin
                // scene takes over. Nothing else is created in this mode.
                ax::extension::ImGuiPresenter::getInstance()->addRenderLoop("#realscreen",[this,engine,bootRealChain,logoRealChain]{
                    static int tick=0;
                    static bool logoDone=false;
                    static bool checkDone=false;
                    ++tick;
                    if(tick==1)bootRealChain();
                    else if(tick>=3&&!logoDone){logoDone=true;logoRealChain();}
                    else if(tick>=4&&!checkDone){
                        checkDone=true;
                        try {
                            int rr=ax::LuaEngine::getInstance()->executeString(REAL_CHAIN_CHECK_LUA);
                            report("REAL_CHAIN_CHECK ret="+std::to_string(rr));
                        } catch(const std::exception& e) {
                            report(std::string("HOST_LOGO_CHECK_ERROR: ")+e.what());
                        }
                        // Diagnóstico opt-in: parsers reais do acervo contra as
                        // respostas vivas do servidor local (sequência/lock
                        // restaurados no fim; JAMAIS roda no padrão do usuário).
                        if (std::getenv("NR_PROBE_PARSE_CHAIN")!=nullptr) {
                            try {
                                ax::LuaEngine::getInstance()->executeString(PARSE_CHAIN_TEST_LUA);
                            } catch(const std::exception& e) {
                                report(std::string("HOST_PARSE_CHAIN_CXX_ERROR: ")+e.what());
                            }
                        }
                    }
                },scene);
                report("REAL_CHAIN_AUTO_ARMED mode=pure-game boot@tick1 logo@tick3 check@tick4");
                if (const char* startupShot=std::getenv("NR_PROBE_STARTUP_SHOT")) {
                    std::string target=startupShot;
                    director->getScheduler()->schedule([this,target](float){
                        ax::LuaEngine::getInstance()->executeString(R"lua(
                            local out=assert(io.open(cc.FileUtils:getInstance():getWritablePath()..'startup-state.txt','w'))
                            out:write('scene='..tostring(fwin and fwin._scene==cc.Director:getInstance():getRunningScene())..'\n')
                            for _,win in pairs(fwin and fwin._list or {}) do
                                out:write(tostring(win.__cname)..' visible='..tostring(win:isVisible())..' children='..tostring(win:getChildrenCount())..'\n')
                            end
                            out:close()
                        )lua");
                        ax::utils::captureScreen([target](ax::RefPtr<ax::Image> image){
                            if(image)image->saveToFile(target);
                            Director::getInstance()->end();
                        });
                    },this,0.f,0,6.f,false,"startup-regression-capture");
                }
                report("RESOURCE_PROBE_STARTED; pure game mode (probe shell behind NR_PROBE_PROBE_UI/NR_PROBE_TEST_MODE)");
                return true;
            }
            scene->setName("probe.scene");
            auto layout = CSLoader::createNode("cocostudio/login/login.csb");
            if (!layout) throw std::runtime_error("Original login CSB returned null");
            scene->addChild(layout);
            layout->setName("probe.login");
            report("CSB_NODE_CREATED (visual fidelity not certified)");
            // First override validation (23 Oct 2026): the byte-identical copy of
            // images/ui/login/fb_icon.png under port/resources must shadow the copy
            // inside the original asset set (search paths place it first).
            report("OVERRIDE_RESOLVE images/ui/login/fb_icon.png -> "+
                   files->fullPathForFilename("images/ui/login/fb_icon.png"));
            restartTimeline();
            auto font = Label::createWithBMFont("fonts/arena_fighting.fnt", "1234567890");
            if (!font) throw std::runtime_error("Original BMFont load failed");
            font->setPosition(Vec2(180,600));scene->addChild(font,90);
            font->setName("probe.font");
            auto atlasPage = Sprite::create("sprite/spirte_102101.png");
            if (!atlasPage) throw std::runtime_error("Character atlas page texture load failed");
            // Atlas texture only, explicitly not a substitute for working skeletal animation.
            atlasPage->setScale(0.15f);atlasPage->setPosition(Vec2(850,150));scene->addChild(atlasPage,80);
            atlasPage->setName("probe.atlas_preview");
            character=nr::LegacyCharacter::create("sprite/spirte_102101");
            character->setName("probe.character");character->setPosition(Vec2(700,180));
            character->setScale(0.65f);scene->addChild(character,85);
            character->verifyAnimations();
            report("SPINE21_ANIMATIONS_VERIFIED original character sampled across all animations");
            auto status = Label::createWithSystemFont(
                "Spine 2.1 character preview | Layout editor\nA: audio | Space: logo pause | R: restart logo", "Arial",16);
            status->setPosition(Vec2(480,40));scene->addChild(status,100);
            status->setName("probe.status");
            audioReady=AudioEngine::lazyInit();audioPath="music/background/background_1.mp3";
            if (!audioReady) report("BLOCKED: AudioEngine::lazyInit failed");
            auto keyboard=EventListenerKeyboard::create();
            keyboard->onKeyPressed=[this](EventKeyboard::KeyCode key,Event*) {
                try {
                    if(ImGui::GetCurrentContext() && ImGui::GetIO().WantCaptureKeyboard) return;
                    if(battle&&battle->isActive())return;
                    if(key==EventKeyboard::KeyCode::KEY_A) playAudio();
                    if(key==EventKeyboard::KeyCode::KEY_R) restartTimeline();
                    if(key==EventKeyboard::KeyCode::KEY_SPACE) togglePreview();
                } catch(const std::exception& e) {report(std::string("INPUT_ERROR: ")+e.what());}
            };
            scene->getEventDispatcher()->addEventListenerWithSceneGraphPriority(keyboard,scene);
            // No global mouse-to-audio binding: Inspector clicks cannot request audio.
            auto localLayout=writable/"layout_overrides.json";
            if(auto custom=_wgetenv(L"NR_PROBE_LAYOUT_FILE"))localLayout=custom;
            layoutEditor=std::make_unique<nr::LayoutEditor>(localLayout,std::filesystem::path(root)/"port/data/layout_overrides.json",report);
            layoutEditor->bindNode(scene,"probe.scene");
            layoutEditor->bindTree(layout,"probe.login");
            layoutEditor->bindTree(timelineNode,"probe.logo");
            layoutEditor->bindNode(font,"probe.font");
            layoutEditor->bindNode(atlasPage,"probe.atlas_preview");
            layoutEditor->bindNode(status,"probe.status");
            layoutEditor->bindNode(character,"probe.character");
            layoutEditor->loadInitial();
            layoutEditor->playAudio=[this]{playAudio();};
            layoutEditor->togglePreview=[this]{togglePreview();};
            layoutEditor->previewPaused=[this]{return paused;};
            auto inspector = ax::extension::Inspector::getInstance();
            inspector->setFontPath("fonts/FZYiHei.ttf");
            inspector->openForScene(scene);
            battle=nr::LocalBattle::create(engine->getLuaStack()->getLuaState(),report);
            scene->addChild(battle.get(),500);
            // Plain-launch data load: original pairs + playback samples. Fail
            // soft (logged): the window stays usable, the combo simply won't
            // fill until the data problem is fixed.
            try{battle->prepareOriginalBattle();}
            catch(const std::exception& e){report(std::string("LOCAL_BATTLE_PREPARE_FAILED ")+e.what());}
            battle->onModeChanged=[this](bool active){
                auto inspector=ax::extension::Inspector::getInstance();
                if(active){
                    previewVisibility.clear();
                    for(auto id:{"probe.login","probe.logo","probe.font","probe.atlas_preview","probe.status","probe.character"})
                        if(auto node=scene->getChildByName(id)){previewVisibility.emplace_back(ax::RefPtr<Node>(node),node->isVisible());node->setVisible(false);}
                    inspector->close();AudioEngine::pauseAll();
                }else{
                    for(auto& entry:previewVisibility)entry.first->setVisible(entry.second);
                    previewVisibility.clear();inspector->openForScene(scene);
                }
            };
            ax::extension::ImGuiPresenter::getInstance()->addRenderLoop("#save",[this]{if(!battle->isActive())layoutEditor->draw();},scene);
            ax::extension::ImGuiPresenter::getInstance()->addRenderLoop("#character",[this]{if(!battle->isActive())character->drawControls();},scene);
            ax::extension::ImGuiPresenter::getInstance()->addRenderLoop("#battle",[this]{battle->drawControls();},scene);
            if(!std::getenv("NR_PROBE_TEST_MODE")) {
                // Legacy probe shell (NR_PROBE_PROBE_UI=1): editor/character/
                // battle panels plus the click button that starts the original
                // chain. The PURE GAME default never reaches here (early return
                // right after scene creation). Overlays close after the fwin
                // swap so the game is not buried under ImGui windows.
                auto bootRealChain=[this](){
                    try{
                        int rb=ax::LuaEngine::getInstance()->executeScriptFile("boot_map.lua");
                        report(rb==1?"REAL_CHAIN_BOOT_OK":"REAL_CHAIN_BOOT_FAILED ret="+std::to_string(rb));
                    }catch(const std::exception& e){
                        report(std::string("REAL_CHAIN_BOOT_ERROR: ")+e.what());
                    }
                };
                auto logoRealChain=[this](){
                    try{
                        int r=ax::LuaEngine::getInstance()->executeScriptFile("host_logo.lua");
                        report(r==1?"HOST_LOGO_SCRIPT_OK":"HOST_LOGO_SCRIPT_FAILED ret="+std::to_string(r));
                        report("PROBE_UI_CLOSE_ARMED delay=2.5s");
                        Director::getInstance()->getScheduler()->schedule([this](float){
                            try{
                                auto pres=ax::extension::ImGuiPresenter::getInstance();
                                pres->removeRenderLoop("#save");
                                pres->removeRenderLoop("#character");
                                pres->removeRenderLoop("#battle");
                                if(ax::extension::Inspector::getInstance())
                                    ax::extension::Inspector::getInstance()->close();
                                report("PROBE_UI_CLOSED default=game overlays=0");
                            }catch(const std::exception& e){
                                report(std::string("PROBE_UI_CLOSE_ERROR: ")+e.what());
                            }
                        }, this, 0.f, 0, 2.5f, false, "probe-ui-close");
                    }catch(const std::exception& e){
                        report(std::string("HOST_LOGO_SCRIPT_ERROR: ")+e.what());
                    }
                };
                ax::extension::ImGuiPresenter::getInstance()->addRenderLoop("#realscreen",[this,bootRealChain,logoRealChain]{
                    static bool started=false;
                    if(ImGui::Begin("Telas reais (boot original)",nullptr,ImGuiWindowFlags_AlwaysAutoResize)){
                        ImGui::TextWrapped("Executa a cadeia ORIGINAL (logo -> login) nesta mesma janela. Falhas aparecem aqui e no log.");
                        if(!started&&ImGui::Button("Iniciar cadeia real (logo)")){
                            started=true;
                            bootRealChain();
                            logoRealChain();
                        }
                        if(started)ImGui::TextDisabled("Cadeia iniciada. Para voltar ao probe, feche e reabra o executavel.");
                    }
                    ImGui::End();
                },scene);
            }
            report("INSPECTOR_ATTACHED font=fonts/FZYiHei.ttf");
            scene->scheduleOnce([](float) {
                if(!ImGui::GetCurrentContext()) {report("INSPECTOR_FRAME_CHECK FAILED: no ImGui context");return;}
                const auto& io=ImGui::GetIO();
                report("INSPECTOR_FRAME_CHECK windows="+std::to_string(io.MetricsRenderWindows)+
                       " vertices="+std::to_string(io.MetricsRenderVertices));
            },2.0f,"inspector-frame-check");
            if(auto mode=std::getenv("NR_PROBE_TEST_MODE")) {
                std::string test=mode;
                if(test!="write"&&test!="read"&&test!="battle"&&test!="host")throw std::runtime_error("Unknown probe test mode");
                scene->scheduleOnce([this,test](float) {
                    auto endTest=[](){Director::getInstance()->end();};
                    try {
                        if(test=="host") {
                            // Milestone: the original fwin scene takes over. The
                            // probe scene stops ticking after the swap, so the
                            // capture chain must ride on the DIRECTOR scheduler.
                            try {
                                int r=ax::LuaEngine::getInstance()->executeScriptFile("host_logo.lua");
                                report(r==1?"HOST_LOGO_SCRIPT_OK":"HOST_LOGO_SCRIPT_FAILED ret="+std::to_string(r));
                            } catch(const std::exception& e) {
                                report(std::string("HOST_LOGO_SCRIPT_ERROR: ")+e.what());
                            }
                            // replaceScene commits at frame end; the in-frame
                            // check inside host_logo.lua is a false negative by
                            // construction. Re-check once the swap has landed.
                            Director::getInstance()->getScheduler()->schedule([this](float dt){
                                try {
                                    // FileUtils search paths get rewritten during
                                    // logo window init — executeString avoids them.
                                    ax::LuaEngine::getInstance()->executeString(REAL_CHAIN_CHECK_LUA);
                                    // TEST MODE ONLY: archive parsers vs live local
                                    // server answers (protocol alignment evidence).
                                    ax::LuaEngine::getInstance()->executeString(PARSE_CHAIN_TEST_LUA);
                                } catch(const std::exception& e) {
                                    report(std::string("HOST_LOGO_CHECK_ERROR: ")+e.what());
                                }
                            }, this, 1.0f, false, "probe-host-recheck");
                            const char* shotDir=std::getenv("NR_PROBE_SHOT");
                            auto endAfterCapture=[this,endTest](bool ok) {
                                Director::getInstance()->getScheduler()->unschedule("probe-host-deadline",this);
                                if(!ok) testExitCode=3;
                                endTest();
                            };
                            if(shotDir) {
                                std::string dir=shotDir;
                                shotPending=true;
                                Director::getInstance()->getScheduler()->schedule([this,dir,endAfterCapture](float dt) {
                                    try {
                                        ax::utils::captureScreen([this,dir,endAfterCapture](ax::RefPtr<ax::Image> img) {
                                            if(img&&img->saveToFile(dir+"/logo-host-shot.png"))
                                                report("PROBE_SHOT_SAVED "+dir+"/logo-host-shot.png");
                                            else report("PROBE_SHOT_SAVE_FAILED logo-host-shot.png");
                                            endAfterCapture(img != nullptr);
                                        });
                                    } catch(const std::exception& e) {
                                        report(std::string("PROBE_SHOT_CAPTURE_FAILED: ")+e.what());
                                        endAfterCapture(false);
                                    }
                                }, this, 1.5f, false, "probe-host-capture");
                                Director::getInstance()->getScheduler()->schedule([this,endAfterCapture](float dt) {
                                    report("PROBE_SHOT_TIMEOUT");
                                    endAfterCapture(false);
                                }, this, 7.5f, false, "probe-host-deadline");
                            } else endTest();
                            return;
                        }
                        int before=audioRequests;
                        EventMouse click(EventMouse::MouseEventType::MOUSE_DOWN);click.setMouseInfo(25,25,EventMouse::MouseButton::BUTTON_LEFT);
                        scene->getEventDispatcher()->dispatchEvent(&click);
                        if(audioRequests!=before)throw std::runtime_error("Mouse event leaked into audio");
                        report("MOUSE_AUDIO_REGRESSION_PASSED");
                        if(test=="battle")battle->smokeTest();
                        else if(test=="write")layoutEditor->smokeWrite();
                        else {layoutEditor->smokeRead();timelineNode->removeFromParentAndCleanup(true);togglePreview();togglePreview();restartTimeline();layoutEditor->smokeRead();}
                    } catch(const std::exception& e){testExitCode=2;report(std::string("LAYOUT_SMOKE_FAILED: ")+e.what());endTest();return;}
                    const char* shotDir=std::getenv("NR_PROBE_SHOT");
                    if(!shotDir){endTest();return;}
                    const std::string shotDirectory=std::string(shotDir);
                    // Schedules one capture: arms the 6 s deadline, grabs the next
                    // rendered frame, saves it (exit 3 when evidence is missing) and
                    // hands control to done() for chaining.
                    auto grabShot=[this](std::string path,std::function<void()> done) {
                        shotPending=true;
                        scene->scheduleOnce([this](float) {
                            if(!shotPending)return;
                            shotPending=false;
                            testExitCode=3;report("PROBE_SHOT_TIMEOUT");
                            Director::getInstance()->end();
                        },6.0f,"probe-shot-deadline");
                        try {
                            ax::utils::captureScreen([this,path=std::move(path),done=std::move(done)](ax::RefPtr<ax::Image> img) {
                                if(!shotPending)return;
                                shotPending=false;
                                if(img&&img->saveToFile(path)) report("PROBE_SHOT_SAVED "+path);
                                else {testExitCode=3;report("PROBE_SHOT_SAVE_FAILED "+path);}
                                done();
                            });
                        } catch(const std::exception& e) {
                            if(!shotPending)return;
                            shotPending=false;
                            testExitCode=3;report(std::string("PROBE_SHOT_CAPTURE_FAILED: ")+e.what());
                            Director::getInstance()->end();
                        }
                    };
                    auto endRun=[endTest](){endTest();};
                    if(test=="battle") {
                        // Evidence of the live battle scene: enter turn 1, let frames
                        // render, capture, hand the editor back, then take the
                        // post-smoke shot and finish.
                        battle->enterForCapture();
                        scene->scheduleOnce([this,shotDirectory,grabShot,endRun](float) {
                            grabShot(shotDirectory+"/battle-active-shot.png",[this,shotDirectory,grabShot,endRun]() {
                                battle->setActive(false);
                                scene->scheduleOnce([shotDirectory,grabShot,endRun](float) {
                                    grabShot(shotDirectory+"/battle-shot.png",endRun);
                                },0.4f,"probe-shot");
                            });
                        },1.0f,"probe-battle-scene");
                        return;
                    }
                    grabShot(shotDirectory+"/"+test+"-shot.png",endRun);
                },1.0f,"layout-smoke");
            }
            director->runWithScene(scene);
            report("RESOURCE_PROBE_STARTED; offline battle available; original full gameplay parity pending");
            return true;
        } catch(const std::exception& e) {
            report(std::string("BOOT_FAILED: ")+e.what());
            if(!std::getenv("NR_PROBE_NO_DIALOG"))
                MessageBoxA(nullptr,e.what(),"Ninja resource probe failure",MB_OK|MB_ICONERROR);
            return false;
        }
    }

    void applicationDidEnterBackground() override {Director::getInstance()->stopAnimation();AudioEngine::pauseAll();}
    void applicationWillEnterForeground() override {Director::getInstance()->startAnimation();if(!paused) AudioEngine::resumeAll();}
    void applicationWillQuit() override {
        ax::extension::ImGuiPresenter::getInstance()->removeRenderLoop("#save");
        ax::extension::ImGuiPresenter::getInstance()->removeRenderLoop("#character");
        ax::extension::ImGuiPresenter::getInstance()->removeRenderLoop("#battle");
        ax::extension::Inspector::destroyInstance();
        layoutEditor.reset();
        AudioEngine::end();
        report("PROBE_EXIT");
    }
};
}
int main() {
    // Unbuffered console: when stdout is redirected to a file (DIAGNOSTICO.cmd)
    // an early crash otherwise loses every buffered line.
    setvbuf(stdout,nullptr,_IONBF,0);setvbuf(stderr,nullptr,_IONBF,0);
    SetErrorMode(SEM_FAILCRITICALERRORS|SEM_NOGPFAULTERRORBOX);nrInstalarFiltrosDeFalha();Probe app;int result=Application::getInstance()->run();return testExitCode?testExitCode:result;}
