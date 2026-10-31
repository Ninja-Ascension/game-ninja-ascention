-- ----------------------------------------------------------------------------------------------------
-- 13-oct-2026: «?» de reglas para las ventanas que no tienen ninguno (7-Day Party, canje 177).
-- Mismo mecanismo que el «?» de la carrera 143 (ActivityLimitRank.lua): images/ui/button/icon_wenhao.png
-- a la izquierda del boton de cerrar + utils/common_popup_rule.csb.
-- Texto: `_fury_help_text` de TipStringInfo.lua ([1] titulo; [2] 7-Day Party; [3] canje 177).
--   FuryHelpPopup.attach(closeButton, indice)
-- ----------------------------------------------------------------------------------------------------
FuryHelpPopup = class("FuryHelpPopupClass", Window)

local FURY_HELP_IMAGE = "images/ui/button/icon_wenhao.png"

local function fury_help_text(i)
    return _fury_help_text ~= nil and _fury_help_text[i] or ""
end

local fury_help_popup_open_terminal = {
    _name = "fury_help_popup_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("FuryHelpPopupClass") == nil then
            fwin:open(FuryHelpPopup:new():init(params._datas.help_index), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local fury_help_popup_close_terminal = {
    _name = "fury_help_popup_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("FuryHelpPopupClass") then
            fwin:close(fwin:find("FuryHelpPopupClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fury_help_popup_open_terminal)
state_machine.add(fury_help_popup_close_terminal)
state_machine.init()

function FuryHelpPopup:ctor()
    self.super:ctor()
    self.roots = {}
end

function FuryHelpPopup:init(index)
    self:setTouchEnabled(true)
    local csbNode = csb.createNode("utils/common_popup_rule.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)
    local title = ccui.Helper:seekWidgetByName(root, "Text_tittle")
    if title ~= nil and fury_help_text(1) ~= "" then
        title:setString(fury_help_text(1))
    end
    local body = ccui.Helper:seekWidgetByName(root, "Text_1")
    if body ~= nil then
        body:setString(fury_help_text(index))
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
    {
        terminal_name = "fury_help_popup_close",
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil, 0)
    return self
end

function FuryHelpPopup:onExit()
end

-- Pone el «?» a la izquierda de `closeButton` (8 px de aire). Sin boton o sin texto no hace nada.
function FuryHelpPopup.attach(closeButton, index)
    if closeButton == nil or fury_help_text(index) == "" then
        return nil
    end
    local help = ccui.Button:create(FURY_HELP_IMAGE, FURY_HELP_IMAGE)
    local closeSize = closeButton:getContentSize()
    local closeAnchor = closeButton:getAnchorPoint()
    help:setPosition(cc.p(closeButton:getPositionX() - closeSize.width * closeAnchor.x - help:getContentSize().width / 2 - 8,
        closeButton:getPositionY() + closeSize.height * (0.5 - closeAnchor.y)))
    closeButton:getParent():addChild(help)
    fwin:addTouchEventListener(help, nil,
    {
        terminal_name = "fury_help_popup_open",
        terminal_state = 0,
        help_index = index,
        isPressedActionEnabled = true
    },
    nil, 0)
    return help
end
