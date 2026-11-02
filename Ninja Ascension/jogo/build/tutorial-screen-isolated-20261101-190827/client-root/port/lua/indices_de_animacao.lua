-- port/lua/indices_de_animacao.lua — RESOLVE O ÍNDICE DE ANIMAÇÃO PELO NOME.
--
-- CAUSA (medida, não suposta):
--   client/battle/fight/FightEnum.lua:231 define _enum_animation_l_frame_index
--   com 42 posições (0..41), incluindo
--       animation_new_skill_13_jueji = 38   -- 绝技, a habilidade especial
--       animation_new_skill_31_ji1   = 28
--   Mas os esqueletos de personagem do acervo têm NO MÁXIMO 17 animações
--   (medido nos 202 spirte_*.json: 147 com 15, 25 com 17, 3 com 13, 2 com 16).
--
--   O nome de cada animação carrega o NÚMERO do enum, não a posição:
--       posição 0..11  -> 00_daiji ... 11_xialuo   (número == posição)
--       posição 12     -> 13_jueji                 (número 13 != posição 12)
--       posição 13..16 -> 28_ddsiwang, 29_daodi, 30_dingdian, 31_xia
--   Em um esqueleto de 15 animações, 13_jueji está na posição 10.
--   Logo: o número do enum NÃO é a posição, e a posição muda por esqueleto.
--
--   display.lua:427 faz  _self.animationNameList[actionIndex + 1].
--   Com actionIndex = 38 o nome é nil e o binding nativo estoura:
--       native_spine.lua:32: bad argument #4 to 'nrSpineCommand'
--         (string expected, got nil)
--   (sessão 29, 23:45:15 — a primeira exceção antes do travamento)
--
--   No jogo: o ataque pede animation_new_skill_13_jueji=38, o play estoura,
--   a animação não termina, o evento de fim nunca chega, o ataque não conclui
--   e o tutorial não libera o próximo passo — a onda 1 trava.
--
-- CORREÇÃO:
--   embrulha sp.SkeletonAnimation.create e dá a cada nó um playWithIndex que
--   traduz o índice do enum para a POSIÇÃO REAL do nome naquele esqueleto.
--   Se o esqueleto não tem a animação pedida, usa o standby (que existe em
--   todos) em vez de um índice inválido. Nada é inventado e nenhum ataque é
--   cancelado: a animação que o acervo pediu toca, no índice correto.
local M = {}

local function nota(t) print("HOST_ANIM " .. t) end

local function numeroDoNome(nome)
    return tostring(nome):match("^(%d+)_")
end

-- Ação do enum -> número que aparece no nome dentro do esqueleto.
-- Derivado dos nomes do enum (FightEnum.lua:232-275) e dos nomes medidos
-- nos esqueletos. Só entram os que existem dos dois lados.
local NUMERO_DA_ACAO = {
    animation_standby               = "00",
    animation_move                  = "01",
    animation_move_back             = "02",
    animation_onrush                = "01",
    animation_skill_began           = "00",
    animation_normal_be_attaked     = "03",
    animation_normal_conversely     = "04",
    animation_vertical_floated      = "07",
    animation_diagonal_floated      = "08",
    animation_miss_action           = "09",
    animation_dizziness             = "05",
    animation_conversely            = "11",
    animation_death                 = "06",
    animation_conversely_get_up     = "11",
    animation_skill_attacking       = "07",
    animation_power_skill_attacking = "08",
    animation_fit_skill_attacking   = "10",
    animation_new_skill_13_jueji    = "13",
    animation_new_skill_29_daodi    = "29",
    animation_new_skill_30_dingdian = "30",
    animation_new_skill_31_xia      = "31",
}

-- Índice do enum -> nome da ação (para quando só se tem o número).
-- Construído SOB DEMANDA: a enumeração só existe depois que o acervo carrega
-- client.battle.fight.FightEnum, que é posterior ao boot do port. Construir
-- uma vez no armar() deixava o mapa vazio e o índice 38 caía no standby
-- (medido: "indice 38 -> posicao 0 (00_daiji)", quando o certo é 13_jueji).
local ACAO_DO_INDICE = nil

local function acaoDoIndice(indice)
    if ACAO_DO_INDICE == nil then
        ACAO_DO_INDICE = {}
        local enum = rawget(_G, "_enum_animation_l_frame_index")
        if type(enum) == "table" then
            for acao, valor in pairs(enum) do
                if type(valor) == "number" and NUMERO_DA_ACAO[acao] ~= nil then
                    ACAO_DO_INDICE[valor] = acao
                end
            end
        end
    end
    return ACAO_DO_INDICE[indice]
end

local function posicaoDoNumero(lista, numero)
    for i, nome in ipairs(lista) do
        if numeroDoNome(nome) == numero then return i - 1 end
    end
    return nil
end

-- Traduz um índice do enum para a posição real no esqueleto.
-- Devolve nil quando não há como representar (não se inventa).
function M.traduzir(lista, actionIndex, acao)
    if type(lista) ~= "table" or #lista == 0 then return nil end

    -- 1) resolve pelo nome da ação, quando conhecido
    if acao == nil and type(actionIndex) == "number" then
        acao = acaoDoIndice(actionIndex)
    end
    if acao ~= nil and NUMERO_DA_ACAO[acao] ~= nil then
        local real = posicaoDoNumero(lista, NUMERO_DA_ACAO[acao])
        if real ~= nil then return real end
        -- A known semantic action absent from this skeleton must not select
        -- an unrelated animation merely because its numeric index fits.
        return posicaoDoNumero(lista, NUMERO_DA_ACAO.animation_standby)
    end

    -- 2) o índice já é válido neste esqueleto: mantém
    if type(actionIndex) == "number" and actionIndex >= 0
        and actionIndex < #lista then
        return actionIndex
    end

    -- 3) fora do intervalo e sem nome conhecido: standby (existe sempre)
    local standby = posicaoDoNumero(lista, NUMERO_DA_ACAO.animation_standby)
    return standby
end

function M.armar()
    if package.__nr_anim then return end
    if type(sp) ~= "table" or type(sp.SkeletonAnimation) ~= "table" then
        return false
    end
    package.__nr_anim = true

    -- O acervo instala playWithIndex em sp.initArmature (display.lua:403-436),
    -- DEPOIS de sp.SkeletonAnimation.create. Embrulhar só o create não adianta
    -- (medido: o playWithIndex do initArmature substituía o nosso e o crash
    -- continuava em native_spine.lua:32). Por isso o embrulho é no próprio
    -- initArmature, que é o ponto onde o método nasce.
    local initOriginal = sp.initArmature
    if type(initOriginal) ~= "function" then return false end

    sp.initArmature = function(no, loop)
        local r = initOriginal(no, loop)
        if no == nil then return r end
        -- FightRole replaces animationNameList with the generic character
        -- list before initArmature. Resolve against the asset actually loaded.
        if cc and type(cc.nrSpineCommand)=='function' then
            local actual=cc.nrSpineCommand(no,'names')
            if type(actual)=='table' and posicaoDoNumero(actual,'00')~=nil then
                no.animationNameList=actual
            end
        end
        local lista = no.animationNameList
        if type(lista) ~= "table" or #lista == 0 then return r end
        no.getAnimationDuration=function(self,actionIndex)
            local real=M.traduzir(lista,actionIndex,acaoDoIndice(actionIndex))
            assert(real~=nil,'Animation duration: unsupported index '..tostring(actionIndex))
            return math.ceil(self:getAnimationDurationEx(lista[real+1])*30)
        end

        local playOriginal = no.playWithIndex
        if type(playOriginal) ~= "function" then return r end
        local avisou = false
        no.playWithIndex = function(self, actionIndex)
            local acao = acaoDoIndice(actionIndex)
            local real = M.traduzir(lista, actionIndex, acao)
            if real == nil then
                nota("esqueleto sem standby nem ação para índice "
                    .. tostring(actionIndex) .. "; ação ignorada")
                return
            end
            if real ~= actionIndex and not avisou then
                avisou = true
                nota(string.format("indice %s -> posicao %d (%s)",
                    tostring(actionIndex), real, tostring(lista[real + 1])))
            end
            -- display.lua calls the movement callback synchronously on play.
            -- That same callback is registered for ANIMATION_COMPLETE and can
            -- advance combat before the first animation frame has run.
            local completion=self.changeActionCallfunc
            local setAnimation=self.setAnimation
            local number=numeroDoNome(lista[real+1])
            local finite=number=='07' or number=='08' or number=='09'
                or number=='10' or number=='13'
            local role=self._self
            local startsCombat=finite and role and role.armature==self
                and role.current_fight_data~=nil and self._actionIndex==actionIndex
                and self._nextAction==actionIndex and self._changing~=true
            -- Direct combat play starts effects and selects its next state;
            -- this is distinct from an ordinary animation completion handler.
            if not startsCombat then self.changeActionCallfunc=nil end
            if finite then
                self.setAnimation=function(node,track,name,loop)
                    return setAnimation(node,track,name,false)
                end
            end
            local result={pcall(playOriginal,self,real)}
            self.setAnimation=setAnimation
            self.changeActionCallfunc=completion
            if not result[1] then error(result[2],0) end
            return unpack(result,2)
        end
        return r
    end
    return true
end

-- Exposto para o contrato conferir a regra sem tocar em nós reais.
M.NUMERO_DA_ACAO = NUMERO_DA_ACAO
M.numeroDoNome = numeroDoNome
M.posicaoDoNumero = posicaoDoNumero
M.acaoDoIndice = acaoDoIndice

return M
