-- Boot-mapping experiment (23 October 2026). Analysis tooling only: executes the
-- ORIGINAL boot chain in the real global environment, one pcall'd stage at a
-- time, printing BOOT_MAP_* markers the automated suite can collect. Never fatal
-- for the probe: every failure is recorded and swallowed, and no new game
-- content is introduced here -- every module loaded below ships in the APK.
-- Gate: only runs when NR_PROBE_BOOT_MAP is set (local_battle.lua hook).
local files = cc.FileUtils:getInstance()

local function rep(step, ok, extra)
    print(("BOOT_MAP_STEP\t%s\t%s\t%s"):format(step, ok and "OK" or "FAIL", tostring(extra or "")))
end

-- Engine-agnostic loader: FileUtils read, loadstring, execute in _G, return the
-- chunk result (mirrors what require would return for a normal module file).
local function load_by_file(name)
    local path = name:gsub("%.", "/") .. ".lua"
    local src = files:getStringFromFile(path)
    assert(src and #src > 0, "file empty/missing: " .. path)
    local chunk = assert(loadstring(src, "@" .. path))
    return chunk()
end

local function tryload(step, chunk)
    local ok, err = xpcall(chunk, debug.traceback)
    rep(step, ok, err)
    if not ok then
        local log=io.open(files:getWritablePath()..'boot-errors.log','a')
        if log then log:write(tostring(step)..'\n'..tostring(err)..'\n');log:close() end
    end
    return ok
end

print("BOOT_MAP_BEGIN", _VERSION, jit and jit.version, tostring(package.path:sub(1, 120)))

-- Stage 0: environment sanity that the original boot assumes. Also caches the
-- workspace root (derived from where configs/app.config really lives) so stage 6
-- can restore the probe search paths after app.init() replaces them.
local probeRoot
tryload("0.arch", function()
    local abs = files:fullPathForFilename("configs/app.config")
    probeRoot = abs:match("^(.*)/01_conteudo_apk/assets/res/configs/app%.config$")
    assert(probeRoot and #probeRoot > 0, "cannot derive workspace root from app.config")
    local cfg = cc.dms_load("configs/app.config")
    assert(cfg:find('"version"'), "app.config unreadable")
    print("BOOT_MAP_INFO", "root=" .. probeRoot, "platform=" ..
        tostring(cc.Application:getInstance():getTargetPlatform()) ..
        " PLATFORM_OS_WINDOWS=" .. tostring(cc.PLATFORM_OS_WINDOWS))
end)

-- Stage 0b: the original app.init() rewrites FileUtils search paths with
-- entries relative to the original game folder (res/src next to the exe), which
-- breaks the native require for every module loaded AFTER it. Install ONE
-- absolute-root searcher at position 2 so require keeps working regardless of
-- the search-path state. Content is read only from the original APK layout.
if not package.__nr_boot_searcher then
    assert(probeRoot and #probeRoot > 0, "stage 0 did not run")
    table.insert(package.loaders, 2, function(name)
        local path = name:gsub("%.", "/") .. ".lua"
        local bases = {
            probeRoot .. "/01_conteudo_apk/assets/src/",
            probeRoot .. "/port/lua/",
            probeRoot .. "/01_conteudo_apk/assets/res/",
        }
        for _, base in ipairs(bases) do
            local src = files:getStringFromFile(base .. path)
            if src and #src > 0 then
                return function()
                    local chunk = assert(loadstring(src, "@" .. base .. path))
                    return chunk()
                end
            end
        end
        return ("\n\tno file '%s' under original roots"):format(path)
    end)
    package.__nr_boot_searcher = true
    rep("0b.searcher_installed", true, "absolute-root searcher at loaders[2]")
end
local okjson, modjson = pcall(require, "cocos.cocos2d.json")
rep("0b.require_after_searcher", okjson, modjson)
if okjson then json = json or modjson end

-- Stage 0c: explicit shims for native bindings of the ORIGINAL engine that do
-- not exist in Axmol. The map refuses to fake behavior: any USE raises loudly,
-- and every stub is listed here so the real decision (native bind vs stub vs
-- drop) stays visible to the project.
tryload("0c.engine_gap_shims", function()
    local notes = {}
    -- 1) Director method rename: axmol exports getRenderView where the original
    --    engine exposed getOpenGLView (exact same operation, view object held by
    --    the probe window).
    if cc.Director and cc.Director.getRenderView and not cc.Director.getOpenGLView then
        cc.Director.getOpenGLView = cc.Director.getRenderView
        notes[#notes+1] = "Director.getOpenGLView->getRenderView"
    end
    -- 2) PVR premultiply flag is not exported by axmol lua bindings. The visuals
    --    here are PNG/COCOSTUDIO, so the flag is recorded as a no-op; any future
    --    PVR asset work must re-evaluate this shim (M2 visual parity item).
    if cc.Image and not cc.Image.setPVRImagesHavePremultipliedAlpha then
        cc.Image.setPVRImagesHavePremultipliedAlpha = function()
            print("BOOT_MAP_SHIM_USED Image.setPVRImagesHavePremultipliedAlpha (no-op)")
        end
        notes[#notes+1] = "Image.setPVRImagesHavePremultipliedAlpha->no-op"
    end
    -- 3) FPS/stats overlay toggle is not exported; cosmetic only, config still
    --    honored for the animation interval in the lines that follow it.
    if cc.Director and not cc.Director.setDisplayStats then
        cc.Director.setDisplayStats = function()
            print("BOOT_MAP_SHIM_USED Director.setDisplayStats (no-op)")
        end
        notes[#notes+1] = "Director.setDisplayStats->no-op"
    end
    -- 4) CBlowFish native binding of the original engine (crypto for network
    --    traffic). Key storage alone is harmless offline; any real use fails
    --    loudly so the offline map never fakes protocol behavior.
    if cc.CBlowFish == nil then
        cc.CBlowFish = {
            new = function(_, _key)
                return {
                    setKey = function() end,
                    Encrypt = function() error("CBlowFish:Encrypt is a missing original-engine binding; offline map refuses to fake crypto", 2) end,
                    Decrypt = function() error("CBlowFish:Decrypt is a missing original-engine binding; offline map refuses to fake crypto", 2) end,
                }
            end,
        }
        notes[#notes+1] = "cc.CBlowFish stubbed (use fails loudly)"
    end
    -- 5) socketevent shipped inside the ORIGINAL engine (libjts.so): opening the
    --    module ITSELF opens a TCP socket to the game server. Offline policy:
    --    an inert connection that NEVER succeeds, registering callbacks that
    --    never fire. No traffic is sent, no fake server responses. Unknown API
    --    surface fails loudly so the map exposes anything the game really needs.
    if package.preload["socketevent"] == nil then
        package.preload["socketevent"] = function()
            local known = { tcp = "tcp", udp = "udp" }
            local function unknown(name)
                error("socketevent." .. tostring(name) .. " is a missing original-engine binding; offline map exposes no network behavior", 2)
            end
            local socketPrototype
            socketPrototype = {
                on = function() end,           -- handlers stored nowhere: never fire
                close = function() end,
                setopt = function() end,       -- options are meaningless when the
                                               -- connection never opens
                connect = function() print("BOOT_MAP_SHIM_USED socketevent connect (offline: never connects)") end,
                sendmessage = function() print("BOOT_MAP_SHIM_USED socketevent sendmessage (offline drop)") end,
                send = function() print("BOOT_MAP_SHIM_USED socketevent send (offline drop)") end,
            }
            local module = {
                tcp = function(_, _key)
                    local sock = setmetatable({}, {
                        __index = function(_, key)
                            if socketPrototype[key] then return socketPrototype[key] end
                            return function() unknown("tcp." .. tostring(key)) end
                        end,
                    })
                    return sock
                end,
                udp = function() return setmetatable({}, { __index = function(_, key)
                    return function() unknown("udp." .. tostring(key)) end
                end }) end,
            }
            return setmetatable(module, {
                __index = function(_, key)
                    if known[key] then return module[key] end
                    return function() unknown(key) end
                end,
            })
        end
        notes[#notes+1] = "socketevent stubbed (inert offline, unknown API fails loudly)"
    end
    -- 6) cc.GLProgramCache does not exist in Axmol (programs live in
    --    backend::ProgramManager). cacher.lua only calls destroyInstance(); other
    --    callers fetch programs to gray widgets. Returning nil from getGLProgram
    --    is honest: Axmol has no GLProgram object to hand out, and using it will
    --    fail visibly instead of pretending the effect applied.
    if cc.GLProgramCache == nil then
        cc.GLProgramCache = {
            getInstance = function() return { getGLProgram = function() return nil end } end,
            destroyInstance = function() end,
        }
        notes[#notes+1] = "cc.GLProgramCache inert (getGLProgram returns nil)"
    end
    -- 7) ccexp.AudioEngine (audio modules of the ORIGINAL engine): absent in
    --    Axmol's Lua bindings, and AudioUtil.lua:226 indexes it on EVERY
    --    fwin:open (window sound) — the thrown error aborted the rest of the
    --    open chain (observed live: windows half-opened, console spammed).
    --    Honest no-op: play2d returns -1 (AudioUtil treats id<0 as "not
    --    played" and dedups), the rest are silent no-ops. No sound on the
    --    desktop stage; the game logic runs unchanged.
    ccexp = ccexp or {}
    if ccexp.AudioEngine == nil then
        ccexp.AudioEngine = {
            play2d = function() return -1 end,
            preload = function() end,
            stop = function() end,
            stopAll = function() end,
            pause = function() end,
            pauseAll = function() end,
            resume = function() end,
            resumeAll = function() end,
            uncache = function() end,
            uncacheAll = function() end,
        }
        notes[#notes+1] = "ccexp.AudioEngine inert (AudioUtil window sound no-op)"
    end
    -- 7b) cc.SimpleAudioEngine (audio of the ORIGINAL engine): also absent in
    --     Axmol's bindings. AudioUtil.playBgm dereferences it WITHOUT the nil
    --     guard (AudioUtil.lua:69) — unlike stopAllEffects (82). The throw
    --     aborted Login:onEnterTransitionFinish (login.lua:1492), so the rest
    --     of that function never ran: the login state-machine terminals were
    --     never added and GAME START did nothing (observed live as
    --     "LUA ERROR ... SimpleAudioEngine (a nil value)" in the record_crash
    --     payload). Honest no-op: no background music on the desktop stage;
    --     the game logic runs unchanged.
    cc = cc or {}
    if cc.SimpleAudioEngine == nil then
        cc.SimpleAudioEngine = {
            getInstance = function()
                return {
                    stopMusic = function() end,
                    playMusic = function() end,
                    pauseMusic = function() end,
                    resumeMusic = function() end,
                    rewindMusic = function() end,
                    setMusicVolume = function() end,
                    getMusicVolume = function() return 0 end,
                    isMusicPlaying = function() return false end,
                    stopEffect = function() end,
                    stopAllEffects = function() end,
                    playEffect = function() return -1 end,
                    preloadEffect = function() end,
                    unloadEffect = function() end,
                    pauseEffect = function() end,
                    resumeEffect = function() end,
                    setEffectsVolume = function() end,
                    getEffectsVolume = function() return 0 end,
                    setBackgroundMusicVolume = function() end,
                    willPlayBackgroundMusic = function() return false end,
                }
            end,
        }
        notes[#notes+1] = "cc.SimpleAudioEngine inert (AudioUtil.playBgm crash)"
    end
    -- 7b-2) sp.SkeletonRenderer: o arcabouco do spine no Axmol nao expoe
    --     SkeletonRenderer com esta API. FightLoadingCell:onInit testa
    --     `if nil ~= sp.SkeletonRenderer.clear then` — o teste de guarda esta
    --     ERRADO: indexa sp.SkeletonRenderer antes de verificar se ele existe
    --     (FightLoading.lua:128). Como sp existe mas SkeletonRenderer nao, o
    --     erro derrubava LoginLoading:init e a tela ficava PRETA logo depois
    --     do GAME START (observado ao vivo). Stub inerte: clear() nao faz
    --     nada, que e exatamente o efeito pretendido (limpar cache do spine).
    sp = sp or {}
    if sp.SkeletonRenderer == nil then
        sp.SkeletonRenderer = {}
        sp.SkeletonRenderer.clear = function() end
        notes[#notes+1] = "sp.SkeletonRenderer.clear inert (FightLoading black screen)"
    end
    -- 7b-3) Bridge the original Lua calls to the pinned native Spine 2.1
    -- renderer. Modern Axmol Spine stays disabled; invisible nodes are no
    -- longer accepted as a successful skeleton creation.
    if type(cc.nrSpineCreate) == 'function' then
        require('native_spine').armar()
    end
    assert(sp.SkeletonAnimation,'Native Spine bridge missing: rebuild the executable')
    notes[#notes+1] = 'sp.SkeletonAnimation native Spine 2.1 renderer'
    -- Cocos 3.5 ListView names used by the recovered client. Axmol moved
    -- this work into the normal layout invalidation/flush path.
    if ccui.ListView.refreshView == nil then
        ccui.ListView.refreshView = function(self)
            self:requestDoLayout()
            self:forceDoLayout()
        end
    end
    if ccui.ListView.requestRefreshView == nil then
        ccui.ListView.requestRefreshView = function(self)
            self:requestDoLayout()
        end
    end
    -- 7c) Nomes de widget que o acervo procura e o layout NAO tem.
    --     login.lua:1554 busca "Button_gonggao", mas o login.csb (todos os
    --     idiomas) guarda "Button_gonggao_pr1" (variante _pr1). O nil
    --     derrubava Login:onEnterTransitionFinish na linha 1555 e o resto
    --     da funcao NUNCA rodava: os terminais da maquina de estados do
    --     login (state_machine.add em 1206-1218) nao eram registrados e o
    --     GAME START nao fazia nada. Alias explicito, so para leitura:
    --     o layout original nao e editado.
    --     ccui pode ainda nao existir neste passo; a funcao fica guardada
    --     em package.__nr_alias_widgets_armar e e chamada de novo depois,
    --     quando as classes de UI estao carregadas.
    local function armarAliasDeWidgets()
        if package.__nr_alias_widgets then return true end
        if ccui == nil or ccui.Helper == nil then return false end
        package.__nr_alias_widgets = true
        local ALIAS = {
            ["Button_gonggao"] = "Button_gonggao_pr1",
            -- ReconnectView.lua:363 busca "Panel_5322", mas o
            -- utils/timeout_connection.csb guarda "Panel_5322_pr2" (mesmo
            -- padrao de sufixo de actionTag do Cocos Studio). Sem o alias o
            -- seek devolvia nil e o onEnterTransitionFinish morria em
            -- ReconnectView.lua:382 ("attempt to index local 'Panel_5322'"),
            -- ou seja: quando o jogo tentava MOSTRAR o erro de conexao, a
            -- propria janela de erro quebrava e o jogador ficava sem
            -- mensagem nenhuma — so a tela parada.
            ["Panel_5322"] = "Panel_5322_pr2",
            ["Panel_battle_hand"] = "Panel_battle_hand_pr2",
            ["Button_htj_tg"] = "Button_htj_tg_pr1",
            ["Panel_hetijiguangx"] = "Panel_hetijiguangx_pr1",
            ["Panel_4"] = "Panel_4_pr2",
            ["Panel_hetiji_1"] = "Panel_hetiji_1_pr1",
            ["Panel_hetiji_2"] = "Panel_hetiji_2_pr1",
            ["Panel_right"] = "Panel_right_pr1",
            ["Panel_2"] = "Panel_2_pr2",
        }
        local seekOriginal = ccui.Helper.seekWidgetByName
        -- Desce a árvore inteira procurando o nome, aceitando também o
        -- SUFIXO DE TAG do Cocos Studio.
        --
        -- Por que isto é necessário (medido, não suposto):
        --   * o layout grava "Label_server_name*11" (nome + '*actionTag'),
        --     mas o acervo procura "Label_server_name";
        --   * e o nó devolvido por getChildByName("root") NÃO é o container
        --     dos widgets do login: no login.json decodificado o nó "root"
        --     está no nível 7 de aninhamento e os widgets do painel
        --     (Label_server_name, Button_play, Panel_login...) estão no
        --     nível 15. getChildByName só olha filhos DIRETOS, então a busca
        --     do acervo nunca os encontraria — nem com o nome certo.
        -- Aqui descemos por todos os descendentes, o que resolve os dois
        -- problemas de uma vez, sem editar o layout original.
        local function filhos(node)
            local ok, kids = pcall(function() return node:getChildren() end)
            if not ok or kids == nil then return nil end
            -- No Axmol getChildren() vem como tabela iterável por ipairs
            -- (ver ResourceProbe.cpp:47-52); :size() NÃO está nos bindings.
            return kids
        end
        local function igualA(nome, alvo)
            if nome == alvo then return true end
            -- O layout grava o nome do widget com DOIS sufixos opcionais:
            --   * a actionTag do Cocos Studio       "...*12"
            --   * o marcador de variante/plataforma "_xxxx" ("_pr1","_pu1",
            --     "_su0","_xl1","_xr1","_bg1","_sr0",...)
            -- e eles aparecem em ORDENS diferentes:
            --   "Label_server_name*11"    (só tag)
            --   "Label_2p_name*12_pr1"    (tag e variante)
            --   "Panel_shenshou_pr1"      (só variante)
            --   "ListView_1_su0"          (só variante)
            -- O acervo SEMPRE procura o núcleo, sem nenhum dos dois.
            --
            -- MEDIDO, não suposto. Casos reais que isso destrava:
            --   FightUI.lua:1428  'Label_2p_name'     <- "Label_2p_name*12_pr1"
            --                    (crash que abria addTigerGateFightUI)
            --   RoleDialogue.lua:1300 'ListView_1'    <- "ListView_1_su0"
            --   RoleDialogue.lua:1302 'Panel_big_head_1'
            --                                         <- "Panel_big_head_1_pu1"
            -- Sem os dois últimos a caixa de fala nunca recebia texto e
            -- nenhum retrato era colocado (sintoma "Text Label" + retratos
            -- repetidos).
            --
            -- A versão anterior tirava "%*%d+$" ANCORADO NO FIM e devolvia nil
            -- quando a variante vinha DEPOIS da tag — por isso o lado 1 dos
            -- labels casava e o lado 2 não.
            --
            -- A regra é determinística e só encontra nó que JÁ EXISTE no
            -- layout: tira *tag e o marcador _xxN (2 letras + dígito, que é o
            -- formato do Cocos Studio) em qualquer ordem, e compara o núcleo.
            local nucleo = nome
            for _ = 1, 4 do
                local antes = nucleo
                nucleo = nucleo:gsub("%*%d+$", "")
                nucleo = nucleo:gsub("_[A-Za-z][A-Za-z]%d+$", "")
                if nucleo == antes then break end
            end
            return nucleo == alvo
        end
        local function descer(node, alvo, profundidade)
            if node == nil or profundidade > 12 then return nil end
            local kids = filhos(node)
            if kids == nil then return nil end
            for _, c in ipairs(kids) do
                local okn, nome = pcall(function() return c:getName() end)
                if okn and nome ~= nil and igualA(tostring(nome), alvo) then
                    return c
                end
            end
            for _, c in ipairs(kids) do
                local r = descer(c, alvo, profundidade + 1)
                if r ~= nil then return r end
            end
            return nil
        end

        -- Busca por NÚCLEO, para os casos em que o layout só tem a variante.
        --
        -- Existe porque 123 núcleos do acervo são AMBÍGUOS dentro do próprio
        -- arquivo (medido em todos os 1644 .csb): por exemplo
        -- fortune_bag_reward.csb tem "_di1" e "_di2" para o mesmo núcleo.
        -- Escolher "o primeiro que casar" seria arbitrário e poderia devolver
        -- o widget errado.
        --
        -- Ordem determinística:
        --   1. nome exatamente igual ao procurado;
        --   2. variante cujo sufixo é só actionTag (*N);
        --   3. variante de plataforma da família _prN (a mais comum: 1854 usos);
        --   4. qualquer outra variante, em ordem alfabética (estável).
        -- Nada é inventado: os candidatos vêm da árvore já carregada.
        local function qualidadeDoNome(nome, alvo)
            if nome == alvo then return 0 end
            local soTag = nome:gsub("%*%d+$", "") == alvo
            if soTag then return 1 end
            local soPr = nome:match("^" .. alvo:gsub("%p", "%%%0") .. "_pr%d+$")
            if soPr then return 2 end
            return 3
        end
        local function descerPorNucleo(node, alvo, profundidade, melhor)
            if node == nil or profundidade > 12 then return melhor end
            local kids = filhos(node)
            if kids == nil then return melhor end
            for _, c in ipairs(kids) do
                local okn, nome = pcall(function() return c:getName() end)
                if okn and nome ~= nil then
                    nome = tostring(nome)
                    if igualA(nome, alvo) then
                        local q = qualidadeDoNome(nome, alvo)
                        if melhor == nil or q < melhor.q
                            or (q == melhor.q and nome < melhor.nome) then
                            melhor = { no = c, q = q, nome = nome }
                        end
                    end
                end
            end
            for _, c in ipairs(kids) do
                melhor = descerPorNucleo(c, alvo, profundidade + 1, melhor)
            end
            return melhor
        end
        ccui.Helper.seekWidgetByName = function(a, b, c)
            local self, root, nome
            if c ~= nil then
                self, root, nome = a, b, c
            else
                self, root, nome = ccui.Helper, a, b
            end
            if root == nil or nome == nil then return nil end
            -- Nome de tipo errado (numero, table, boolean) NAO pode chegar ao
            -- nativo: ele responde "invalid arguments in
            -- lua_ax_ui_Helper_seekWidgetByName" e derruba o quadro que estava
            -- montando a janela. O acervo faz isso por um `or` que nunca e falso
            -- (Menu.lua:181-182: `~= nil or ~= ""`), entao o valor nil ou
            -- nao-string chega aqui mesmo quando o campo nao existe.
            -- Devolver nil e exatamente o que os chamadores testam
            -- (`if terminal.animation_panel ~= nil`, Menu.lua:185), entao a
            -- janela segue por esse ramo em vez de estourar.
            if type(nome) ~= "string" then return nil end
            if type(root) ~= "userdata" and type(root) ~= "table" then return nil end
            local achado = seekOriginal(self, root, nome)
            if achado ~= nil then return achado end
            local alternativo = ALIAS[nome]
            if alternativo ~= nil then
                achado = seekOriginal(self, root, alternativo)
                if achado ~= nil then return achado end
            end
            -- descer() casa pelo núcleo na ordem da árvore; descerPorNucleo()
            -- é determinístico quando o núcleo é ambíguo. Os dois devolvem o
            -- MESMO nó quando só existe uma variante, e nesse caso o custo
            -- extra é nulo. Preferimos o determinístico.
            local melhor = descerPorNucleo(root, nome, 0, nil)
            if melhor ~= nil then return melhor.no end
            achado = descer(root, nome, 0)
            if achado ~= nil then return achado end
            if alternativo ~= nil then
                melhor = descerPorNucleo(root, alternativo, 0, nil)
                if melhor ~= nil then return melhor.no end
                achado = descer(root, alternativo, 0)
                if achado ~= nil then return achado end
            end
            -- Não achou: registra uma vez por nome. É o que permite descobrir
            -- QUAL nó está sendo passado (o layout tem o widget, então o
            -- problema é o root errado, não o nome).
            if package.__nr_widget_falta == nil then package.__nr_widget_falta = {} end            if not package.__nr_widget_falta[nome] then
                package.__nr_widget_falta[nome] = true
                local tipo = "?"
                if root ~= nil then
                    local ok, t = pcall(function() return root:getDescription() end)
                    tipo = (ok and t) or ("classe=" .. tostring(root))
                end
                print("BOOT_MAP_WIDGET_FALTA '" .. tostring(nome) .. "' root=" .. tostring(tipo))
                -- Primeira falha: despeja o que o nó RAIZ realmente tem.
                -- Se a lista vier vazia, o csb não montou a árvore (loader);
                -- se vier com nomes, o nome procurado é que diverge.
                if root ~= nil and not package.__nr_dump_filhos then
                    package.__nr_dump_filhos = true
                    print("BOOT_MAP_DUMP inicio root=" .. tostring(root))
                    -- getChildren() no Axmol expõe a lista como tabela Lua
                    -- iterável por ipairs (é assim que ResourceProbe.cpp:47-52
                    -- percorre). NÃO usar kids:size(): esse método não está
                    -- nos bindings e devolvia erro — foi o que me fez concluir
                    -- erradamente "árvore vazia" numa rodada anterior.
                    local ok, filhos = pcall(function() return root:getChildren() end)
                    print("BOOT_MAP_DUMP ok=" .. tostring(ok) .. " tipo=" .. type(filhos))
                    local nomes, n = {}, 0
                    if ok and filhos ~= nil then
                        for _, c in ipairs(filhos) do
                            n = n + 1
                            local nm = "?"
                            pcall(function() nm = tostring(c:getName()) end)
                            nomes[#nomes + 1] = nm
                        end
                    end
                    local cnt = -1
                    pcall(function() cnt = root:getChildrenCount() end)
                    local meu = "?"
                    pcall(function() meu = tostring(root:getName()) end)
                    print("BOOT_MAP_DUMP ipairs=" .. n .. " getChildrenCount=" .. tostring(cnt)
                        .. " rootName='" .. meu .. "'"
                        .. " nomes=" .. table.concat(nomes, ","))
                end
            end
            return nil
        end
        print("BOOT_MAP_SHIM_USED ccui.Helper.seekWidgetByName alias "
            .. "Button_gonggao->Button_gonggao_pr1, Panel_5322->Panel_5322_pr2")
        return true
    end
    package.__nr_alias_widgets_armar = armarAliasDeWidgets
    if armarAliasDeWidgets() then
        notes[#notes+1] = "seekWidgetByName alias Button_gonggao->_pr1, "
            .. "Panel_5322->Panel_5322_pr2"
    else
        notes[#notes+1] = "seekWidgetByName alias pendente (ccui ainda nao existe)"
    end
    rep("0c.engine_gap_shims", true, table.concat(notes, "; "))
end)

-- Stage 1: cocos.init in one shot; on failure, decompose into its own require
-- list so the report names the exact first broken framework file.
local initLoaded = tryload("1.cocos_init", function() return require("cocos.init") end)
if initLoaded then
    rep("1.cocos_init_detail", true, "framework requires inside cocos/init.lua succeeded")
else
    local init = files:getStringFromFile("cocos/init.lua")
    for name in init:gmatch('require%s+"([^"]+)"') do
        tryload("1b." .. name, function() return load_by_file(name) end)
    end
end

-- Stage 2: the app framework itself (frameworks/app.lua, 520 lines).
local appLoaded = tryload("2.app_lua", function() return require("frameworks.app") end)

-- Stage 3: app.create() runs the full original app.init(): app.config JSON,
-- aeslua/blowfish/utils/audio, support libs, network modules and
-- NetworkAdaptor.init(), lua_bridge, state_machine, notification_center,
-- fwin/window windows system and the UserDefault version stamp.
local appReady = false
if appLoaded then
    appReady = tryload("3.app_create", function() app.create() end)
end

-- Stage 4: the launcher terminal (original client/launch.lua body).
if appReady then
    tryload("4.client_launch", function() app.load("client.launch") end)

    -- Stage 3b: OFFLINE SEND FENCE (adapter; NetworkAdaptor global exists now).
    -- The original engine encrypted every HTTP packet with native bindings
    -- (cc.DBytes/cc.deflateMemory/blowfish) that do not exist in Axmol, so
    -- NetworkAdaptor.send THROWS from the scheduler every frame and the queue
    -- never drains (the visible symptom: repeating __G__TRACKBACK__ spam). The
    -- original pump ALREADY understands a failed request: dataState ERROR makes
    -- updateRequestQueue show NetworkView's own network-error dialog and drop
    -- the request (NetworkManager.lua 287-292). The fence marks requests the
    -- original way instead of throwing: no network faked, no response invented.
    -- Endereco do servidor do jogo. Padrao: este computador. Para jogar num
    -- servidor remoto, port/resources/servidor.txt contem uma linha como
    -- http://181.215.236.218:18080/iniServer (sem esse arquivo, nada muda).
    if not package.__nr_servidor_url then
        local LOCAL = "http://127.0.0.1:18080/iniServer"
        local escolhido
        package.__nr_servidor_url = function()
            if escolhido then return escolhido end
            escolhido = LOCAL
            local ok, texto = pcall(function()
                -- Absolute first: relative search paths depend on the
                -- working directory the exe was started from.
                if probeRoot then
                    local arquivo = io.open(probeRoot .. "/port/resources/servidor.txt", "r")
                    if arquivo then local t = arquivo:read("*a"); arquivo:close(); return t end
                end
                local fu = cc.FileUtils:getInstance()
                if not fu:isFileExist("servidor.txt") then return nil end
                return fu:getStringFromFile("servidor.txt")
            end)
            local linha = ok and type(texto) == "string" and texto:match("^%s*(%S+)") or nil
            if linha then
                if linha:match("^https?://[%w%.%-]+:?%d*/iniServer$") then
                    escolhido = linha
                else
                    print("HOST_SERVIDOR servidor.txt invalido, usando " .. LOCAL .. ": " .. linha)
                end
            end
            print("HOST_SERVIDOR " .. escolhido)
            return escolhido
        end
        package.__nr_servidor_base = function()
            local url = package.__nr_servidor_url():lower()
            return url:match("^(https?://[^/]+/)")
        end
    end

    tryload("3b.offline_send_fence", function()
        if package.__nr_send_fence then return end
        assert(type(NetworkAdaptor) == "table" and NetworkAdaptor.send ~= nil,
            "NetworkAdaptor global missing after app.create")
        if NetworkAdaptor.__nr_offline_fence then
            package.__nr_send_fence = true
            rep("3b.offline_send_fence", true, "already installed")
            return
        end
        local originalSend = NetworkAdaptor.send
        -- SÓ LOOPBACK. O app.config original traz nas linhas 27-28 o host
        -- real do jogo (http://104.251.218.95:18080/iniServer). O redireciono
        -- do stage 3b2 troca app.configJson.url, mas qualquer pedido que
        -- monte a URL por outro caminho mandaria nome/conta do jogador para
        -- a internet. Aqui todo pedido passa por NetworkAdaptor.send: se a
        -- URL não for 127.0.0.1/localhost, ele é RECUSADO (dataState ERROR,
        -- que o pump original já sabe tratar) e o console mostra qual comando
        -- tentou sair.
        -- Alem do loopback, so o servidor configurado em servidor.txt.
        local base = package.__nr_servidor_base and package.__nr_servidor_base() or nil
        local function urlPermitida(url)
            if type(url) ~= "string" then return true end
            url = url:lower()
            if base and url:sub(1, #base) == base then return true end
            return url:find("^http://127%.0%.0%.1[:/]") ~= nil
                or url:find("^http://localhost[:/]") ~= nil
        end
        NetworkAdaptor.send = function(data)
            if data ~= nil and not urlPermitida(data.url) then
                print("HOST_NET_GUARD bloqueado: " .. tostring(data.command)
                    .. " -> " .. tostring(data.url))
                if data.error_code == nil or data.error_code >= 0 then
                    data.error_code = -6
                end
                data.error_string = "local-only: request refused outside 127.0.0.1"
                data.dataState = NetworkAdaptor.dataState.ERROR
                return
            end
            if cc == nil or cc.DBytes == nil or cc.deflateMemory == nil then
                if data.error_code == nil or data.error_code >= 0 then
                    data.error_code = -5
                end
                data.error_string = "offline: native packet bindings missing (cc.DBytes/cc.deflateMemory)"
                data.dataState = NetworkAdaptor.dataState.ERROR
                return
            end
            return originalSend(data)
        end
        NetworkAdaptor.__nr_offline_fence = true
        package.__nr_send_fence = true
        rep("3b.offline_send_fence", true, "failed sends reach the pump's ERROR path (dialog->drop)")
    end)

    -- Stage 3b2: LOCAL SERVER URL REDIRECT (adapter; Fase 2, user-approved
    -- single permission). The archived config still points to the dead 2017
    -- host. The approved local stage server replaces it; every request the
    -- game itself makes keeps its original protocol/encryption. The previous
    -- value is printed for the report. No original file is edited.
    tryload("3b2.url_redirect", function()
        if package.__nr_url_redirect then return end
        local antes = tostring(app.configJson.url)
        local antesAnuncio = tostring(app.configJson.urlForAnnounce)
        app.configJson.url = package.__nr_servidor_url()
        -- O anúncio do sistema usa uma chave SEPARADA (app.config linha 28:
        -- urlForAnnounce) e é pedido em login.lua:2017 com comando 66.
        -- Redirecionar só app.configJson.url deixava este pedido ir para o
        -- host real (104.251.218.95) — ou seja, o cliente mandava dados para
        -- a internet. As duas chaves apontam para o servidor local.
        app.configJson.urlForAnnounce = package.__nr_servidor_url()
        package.__nr_url_redirect = true
        rep("3b2.url_redirect", true, "url " .. antes .. " -> " .. tostring(app.configJson.url))
        rep("3b2.url_redirect", true, "urlForAnnounce " .. antesAnuncio .. " -> "
            .. tostring(app.configJson.urlForAnnounce))
    end)

    -- Stage 3b2b: DOMAIN REWRITE GUARD. ProtocolCommander.replaceDomainName()
    -- (ProtocolCommander.lua:2289-2324) reescreve app.configJson.url e
    -- urlForAnnounce trocando "j7game.com"/"jar-world3000.com" pelo domínio do
    -- projeto. Ele roda no fim do próprio chunk, então já executou; mas se
    -- qualquer recarga reexecutar, os valores voltam a apontar para fora.
    -- Aqui as duas chaves são reafirmadas DEPOIS de qualquer carregamento do
    -- ProtocolCommander (ver stage 3c).
    tryload("3b2b.reassert_local_urls", function()
        local function reafirmar()
            if app.configJson == nil then return end
            local local_url = package.__nr_servidor_url()
            if app.configJson.url ~= local_url then
                rep("3b2b.reassert_local_urls", true,
                    "url reafirmado de " .. tostring(app.configJson.url) .. " para " .. local_url)
                app.configJson.url = local_url
            end
            if app.configJson.urlForAnnounce ~= local_url then
                rep("3b2b.reassert_local_urls", true,
                    "urlForAnnounce reafirmado de "
                    .. tostring(app.configJson.urlForAnnounce) .. " para " .. local_url)
                app.configJson.urlForAnnounce = local_url
            end
        end
        package.__nr_reassert_urls = reafirmar
        rep("3b2b.reassert_local_urls", true, "pronto")
    end)

    -- Stage 3b3: LOCAL SDK (adapter, Fase 2). On Windows the archive's
    -- handlePlatformRequest returns early (ThirdpartySupporter.lua:2183-2187)
    -- and the t4-quick callbacks never arrive, so m_sdk_init_success /
    -- m_sdk_login_success stay false and the START click dies silently in
    -- login.lua:433-439. The adapter replays the two branch effects. It does
    -- NOT create a guest: m_sUin only gets a value after a real account
    -- authenticates (S2C 327 from port/server/local_server.py).
    tryload("3b3.local_sdk_guest", function()
        if package.__nr_local_sdk_guest_stage then return end
        package.__nr_local_sdk_guest_stage = true
        local sdk = require("local_sdk_guest")
        sdk.armar()
        rep("3b3.local_sdk_guest", true, "adapter armed (flag local_sdk_adapter gates it)")
    end)

    -- Stage 3b3b: session key (?s=<userLoginToken>) on every HTTP request, so
    -- a server in public mode can tell players apart. Body unchanged.
    tryload("3b3b.session_url", function()
        local session = require("session_url")
        session.arm()
        rep("3b3b.session_url", true, "armed; installed=" .. tostring(NetworkAdaptor ~= nil and NetworkAdaptor.__nr_session_url == true))
    end)

    -- Stage 3b4: ACCOUNT UI (adapter). The archive's account window
    -- (AccountSysManager, register_prompt_1.csb: Entrar / Criar conta) opens
    -- from login.lua:1727-1774, but AccountSysFloatingWindow's
    -- onEnterTransitionFinish calls getOpenGLView():getFrameSize(), which
    -- Axmol's RenderView does not expose -> whole block dies. This adapter
    -- completes the view shim and opens the ORIGINAL window once its
    -- prerequisites are satisfied. No UI is re-created here.
    tryload("3b4.account_ui", function()
        if package.__nr_account_ui_stage then return end
        package.__nr_account_ui_stage = true
        local conta = require("account_ui")
        conta.armar()
        rep("3b4.account_ui", true, "adapter armed (opens the original account window)")
    end)

    -- Stage 3c: NETWORK VIEWS registration — verbatim replay of the logo
    -- terminal's _init body (logo.lua:28-41, ACTIVE original lines). On a
    -- normal install this runs from the state machine; without it the
    -- NetworkView registry stays empty and the original pump's error UI
    -- (NetworkManager.lua:287-291 -> NetworkView:networkErrorViewDisplay)
    -- silently no-ops, so offline failures are invisible.
    tryload("3c.network_views", function()
        app.load("client.protocol.ProtocolCommander")
        -- replaceDomainName() roda no fim do chunk e troca url/urlForAnnounce
        -- por domínios da internet: reafirma o servidor local em seguida.
        if package.__nr_reassert_urls ~= nil then
            package.__nr_reassert_urls()
        end
        app.load("client.loader.EnvironmentDatas")
        NetworkProtocol.protocol_commands = protocol_command
        NetworkProtocol.protocol_parses = protocol_parse
        NetworkManager:registerUrl(app.configJson.url, app.configJson.wsurl)
        app.load("client.network.ConnectingView")
        app.load("client.network.ReconnectView")
        app.load("client.network.NetworkErrorDialog")
        app.load("client.network.ProtocolErrorDialog")
        NetworkView:register(ConnectingView:new(), nil, NetworkErrorDialog:new(), ProtocolErrorDialog:new())
        NetworkManager:registerKeepAlive(protocol_command.keep_alive.code, 180*2)
    end)

    -- Stage 3d: NETWORK VIEW TRACE (adapter diagnostics only). Wraps the
    -- original display functions so each call prints whether it ran and
    -- whether the registered view exists at that moment. This marks where
    -- the offline wall stops: display never called (send/pump never got
    -- there), called with a nil view (registration), or the open failed.
    -- No original line is altered — only indirection added at runtime.
    tryload("3d.network_view_trace", function()
        if package.__nr_netview_trace then return end
        local origConnecting = NetworkView.connectingViewDisplay
        local origError = NetworkView.networkErrorViewDisplay
        local origReconnect = NetworkView.reconnectViewDisplay
        local origProtocol = NetworkView.protocolErrorViewDisplay
        NetworkView.connectingViewDisplay = function(self, request)
            print('HOST_NETVIEW connectingViewDisplay view='..tostring(self._connectingView ~= nil))
            return origConnecting(self, request)
        end
        NetworkView.networkErrorViewDisplay = function(self, request)
            print('HOST_NETVIEW networkErrorViewDisplay view='..tostring(self._networkErrorView ~= nil))
            return origError(self, request)
        end
        NetworkView.reconnectViewDisplay = function(self, request)
            print('HOST_NETVIEW reconnectViewDisplay view='..tostring(self._reconnectView ~= nil))
            return origReconnect(self, request)
        end
        NetworkView.protocolErrorViewDisplay = function(self, request)
            print('HOST_NETVIEW protocolErrorViewDisplay view='..tostring(self._protocolErrorView ~= nil))
            return origProtocol(self, request)
        end
        package.__nr_netview_trace = true
    end)

    -- Stage 5: load-only of the first real window. The window is NOT opened
    -- here: opening it needs the probe scene redesigned as a host (M2 work).
    tryload("5.logo_load_only", function()
        local logo = app.load("client.login.logo")
        assert(logo ~= nil, "client.login.logo returned nil")
    end)

    -- Stage 5b: the ORIGINAL Android boot loads the loader module before any
    -- window opens; the login ctor calls its global addErrorInfor (login.lua:178
    -- expects it). Load the ORIGINAL module — no stub, no reimplementation.
    tryload("5b.loader_globals", function()
        app.load("client.loader.LocalDatas")
        -- A lista FLAT que este build usa pede "data/x.txt" para arquivos
        -- que moram em "data/mould/x.txt": o motor avisa "No file found"
        -- e a tabela fica vazia. O adaptador corrige só o caminho.
        require("data_paths").armar()
    end)
end

-- Stage 6: app.init() rebuilt the search paths with entries relative to the game
-- folder (which does not exist next to this exe). Restore the probe paths plus
-- the engine's precompiled shader cards directory (axslc): setSearchPaths
-- replaces the whole list and renders would abort on an empty shader source.
tryload("6.restore_probe_paths", function()
    assert(probeRoot, "stage 0 did not run")
    require('engine_shader_paths').install(probeRoot)
    files:setSearchPaths({
        probeRoot .. "/port/lua",
        probeRoot .. "/port/resources",
        probeRoot .. "/01_conteudo_apk/assets/res",
        probeRoot .. "/01_conteudo_apk/assets/src",
        probeRoot .. "/build/windows-probe-native/runtime/axslc",
    })
    -- Adaptacoes que existiam no disco e nunca eram ligadas (ver o cabecalho
-- de port/lua/instalar_adaptacoes.lua: era a causa do centro vazio do PVE).
require('instalar_adaptacoes').armar()
require('battle_lifecycle').armar()
    -- Um retrato por vez no di�logo: o acervo n�o esconde o lado inativo
    -- (a sa�da do retrato est� comentada em RoleDialogueLeftRoleWidget.lua:87).
    require('dialogo_retratos').armar()
    -- O evento de fim do n�mero flutuante chama-se 'close', n�o 'over'
    -- (FightRole.lua:4481 espera 'over' e a remo��o nunca acontecia).
    require('numeros_flutuantes').armar()
    -- o ramo l_naruto de localData_attack_logic nao carrega as tabelas de
    -- batalha; sem elas o portao do TAP (FightRole.lua:7285) nunca abre.
    require('tabelas_de_batalha').armar()
    -- o enum de animacao vai ate 41, mas os esqueletos tem <=17 animacoes;
    -- o indice tem de ser resolvido pela posicao real do nome no esqueleto.
    require('indices_de_animacao').armar()
    require('language_assets_local').install(probeRoot)
    require('open_server_time').armar()
    require('open_server_time').instalarNoLogin()
-- A Home estoura em onUpdate (:5261) enquanto os campos de tempo nao
-- existem; garante antes de cada quadro dela.
require('open_server_time').armarHome()
    require('painel_de_dano').armar()
-- O painel de niveis do PVE nascia visivel com os numeros padrao do CSB.
require('painel_de_niveis_pve').armar()
    require('diag_vez_e_numeros').armar()
-- Lista NINJA: o catalogo de nao possuidos exige fragmentos e some com a
-- conta vazia (HeroListView.lua:1196). Restaura a listagem pelos criterios
-- originais do acervo, sem conceder nada.
require('desktop_layout').install()
require('catalogo_ninjas').instalar()
    -- app.setSearchPaths rebuilds paths on logo/login language changes. Its
    -- source is app.searchPaths, cached before our stage-6 restoration.
    -- Retain engine shaders there as well, and restore after every such call.
    local shaderPath=probeRoot.."/build/windows-probe-native/runtime/axslc"
    if type(app)=='table' and type(app.searchPaths)=='table' then
        local found=false
        for _,p in ipairs(app.searchPaths) do if p==shaderPath then found=true end end
        if not found then app.searchPaths[#app.searchPaths+1]=shaderPath end
        if not package.__nr_shader_paths then
            package.__nr_shader_paths=true
            local original=app.setSearchPaths
            app.setSearchPaths=function(...)
                local result=original(...)
                files:addSearchPath(shaderPath)
                assert(files:isFileExist('positionColorLengthTexture_vs'),'Engine vertex shader lost')
                assert(files:isFileExist('positionColorLengthTexture_fs'),'Engine fragment shader lost')
                return result
            end
        end
    end
end)

if os.getenv('NR_PROBE_RENDER_TEST')=='1' then
    local passed=tryload('6b.render_contract',function()
        assert(type(cc.nrSpineCreate)=='function','Native Spine bridge absent')
        local list=ccui.ListView:create()
        list:setContentSize(cc.size(300,80))
        list:setDirection(ccui.ScrollViewDir.horizontal)
        for i=1,3 do
            local item=ccui.Layout:create()
            item:setContentSize(cc.size(60,40))
            list:pushBackCustomItem(item)
        end
        list:setItemsMargin(10)
        list:requestRefreshView()
        list:refreshView()
        assert(#list:getItems()==3,'ListView refresh lost battle portraits')
        assert(list:getItem(1):getPositionX()>list:getItem(0):getPositionX(),
            'Legacy ListView refresh did not lay out battle portraits')
        assert(type(app.setSearchPaths)=='function','Language search-path API missing')
        local language=next(app.configJson.MultiLanguage)
        assert(language,'No original language configured')
        assert(app.setSearchPaths(language)==true,'Language search-path update failed')
        assert(files:isFileExist('positionColorLengthTexture_vs'),'Vertex shader lost after language update')
        assert(files:isFileExist('positionColorLengthTexture_fs'),'Fragment shader lost after language update')
        for _,layout in ipairs({'formation/line_up.csb','utils/teaching.csb'}) do
            assert(csb.createNode(layout),'Original layout failed: '..layout)
        end
        local hand=csb.createNode('battle/battle_hand_control.csb'):getChildByName('root')
        assert(ccui.Helper:seekWidgetByName(hand,'Panel_battle_hand'),
            'Battle QTE hand panel alias missing')
        assert(ccui.Helper:seekWidgetByName(hand,'Panel_bishashanghai'),
            'Battle total damage container missing')
        local hud=csb.createNode('battle/battle_UI.csb'):getChildByName('root')
        assert(ccui.Helper:seekWidgetByName(hud,'Button_htj_tg'),'Battle combined skill button missing')
        assert(ccui.Helper:seekWidgetByName(hud,'Panel_hetijiguangx'),'Battle combined skill panel missing')
        for _,name in ipairs({'Panel_hetiji_1','Panel_hetiji_2'}) do
            assert(ccui.Helper:seekWidgetByName(hud,name),'Battle combined skill slot missing: '..name)
        end
        for _,suffix in ipairs({'','_0'}) do
            local path='battle/injury_settlement_batter'..suffix..'.csb'
            local node=csb.createNode(path)
            assert(ccui.Helper:seekWidgetByName(node:getChildByName('root'),'Panel_4'),
                'Combo counter panel missing: '..path)
            local timeline=csb.createTimeline(path)
            assert(timeline:IsAnimationInfoExists('combo_damage_move_xs'),
                'Combo exit animation missing: '..path)
        end
        local skill=csb.createNode('battle/battle_super_skill_head.csb'):getChildByName('root')
        assert(ccui.Helper:seekWidgetByName(skill,'Panel_right'),'Enemy skill closeup panel missing')
        local ready=csb.createNode('battle/battle_ready.csb'):getChildByName('root')
        assert(ccui.Helper:seekWidgetByName(ready,'Panel_2'),'Next wave transition panel missing')
        -- Diagnostico avulso (NR_PROBE_PROVA=1): roda port/lua/prova_callback.lua
        -- sem entrar no contrato, para investigar uma falha sem alterar o teste.
        if os.getenv('NR_PROBE_PROVA')=='1' then require('prova_callback').run() end
        if os.getenv('NR_PROBE_PROVA_EFEITOS')=='1' then require('prova_efeitos').run() end
        if os.getenv('NR_PROBE_DIAG_HURT')=='1' then require('diag_hurt').run() end
        require('animacao_contract').run()
        require('animacao_viva_contract').run()
        require('animacao_fim_contract').run()
        require('painel_contract').run()
        require('open_server_time_contract').run()
        require('pve_contrato').run()
        require('seek_contrato').run()
        require('pve_mapa_contrato').run()
        require('painel_de_niveis_contract').run()
        require('richtext_contrato').run()
        require('pve_ready_contrato').run()
        require('tabelas_contract').run()
        require('tap_contract').run()
        require('numeros_contract').run()
        require('tutorial_contract').run()
        require('label_contract').run()
        require('dialogo_contract').run()
        require('dialogo_retrato_contract').run()
        print('NATIVE_RENDER_CONTRACT_PASSED language paths and original battle/tutorial layouts')
    end)
    assert(passed,'Render contract failed')
end

-- Diagnostico SOMENTE LEITURA da tela atual (pilha de janelas, estado dos
-- carregadores, MenuClass/RoleDialogueClass). Desligado no lancador normal:
-- so armazena quando NR_DIAG_TELA=1, para validar a conta salva sem alterar
-- nenhum comportamento do jogo. Ver cabecalho de port/lua/diag_tela.lua.
-- Teste do hook de dialogos (roda o roteiro e encerra o processo).
-- Teste do loader em tutorial (ver loader_tutorial.lua).
if os.getenv('NR_TESTE_LOADER_TUTORIAL')=='1' then
    require('teste_loader_tutorial')
end

-- Teste do mega_info (ver mega_info_seguro.lua).
if os.getenv('NR_TESTE_MEGA_INFO')=='1' then
    require('teste_mega_info')
end

-- Teste da rede de seguranca do carregamento (ver garantir_begin_load.lua).
if os.getenv('NR_TESTE_BEGIN_LOAD')=='1' then
    require('teste_begin_load')
end

-- Liga a entrada automatica na conta salva (ver ligar_login_automatico.lua).
-- Ajusta a conta salva no cliente (ver ajustar_conta_local.lua).
if os.getenv('NR_AJUSTAR_CONTA')=='1' then
    if not tryload('6a.conta', function()
        require('ajustar_conta_local')
    end) then
        local f = io.open(cc.FileUtils:getInstance():getWritablePath()..'ajustar-conta.log','w')
        if f then f:write('FALHA: nao carregou') f:flush() f:close() end
        os.exit(1)
    end
end

-- Limpa a conta salva no cliente (ver limpar_conta_local.lua).
if os.getenv('NR_LIMPAR_CONTA')=='1' then
    if not tryload('6a.limpa', function()
        require('limpar_conta_local')
    end) then
        local f = io.open(cc.FileUtils:getInstance():getWritablePath()..'limpar-conta.log','w')
        if f then f:write('FALHA: nao carregou') f:flush() f:close() end
        os.exit(1)
    end
end

if os.getenv('NR_LOGIN_AUTOMATICO')=='1' then
    if not tryload('6a.login_auto', function()
        require('ligar_login_automatico')
    end) then
        local f = io.open(cc.FileUtils:getInstance():getWritablePath()..'ligar-login-auto.log','w')
        if f then f:write('FALHA: nao carregou\n') f:close() end
        os.exit(1)
    end
end

if os.getenv('NR_TESTE_DIALOGOS')=='1' then
    if not tryload('6b.teste_dialogos', function()
        require('teste_esconder_dialogos')
    end) then
        local f = io.open(cc.FileUtils:getInstance():getWritablePath()..'dialogos-teste.log','w')
        if f then f:write('FALHA: roteiro nao carregou\n') f:close() end
        os.exit(1)
    end
end

if os.getenv('NR_DIAG_TELA')=='1' then
    tryload('6c.diag_tela', function()
        require('diag_tela').armar()
    end)
end

if os.getenv("NR_PROBE_LOADING_DIAGNOSTICS") == "1" then
    tryload("7.loading_diagnostics", function()
        require("loading_diagnostics").armar()
    end)
end

print("BOOT_MAP_END")
return 1
