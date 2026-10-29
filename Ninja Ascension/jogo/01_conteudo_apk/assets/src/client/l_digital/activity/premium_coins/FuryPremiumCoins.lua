-----------------------------------------------------------------------------------------------
-- EL EVENTO «MONEDAS PREMIUM» (Fury, 30-sep-2026; docs/systems/evento_monedas_premium.md).
--
-- Tipo PROPIO 29150 del bloque 85 (el «Super pack» 179 sigue rotando como siempre).
-- Ventana: la del 179, ActivitySuperPack (sm_value_packag.csb), abierta con el tipo
-- 29150: el servidor manda sus tramos (umbral,99), «alcanzadas,cobradas» por fila y
-- el cobro es el C2S 35 de siempre. Titulo y reglas: `_fury_premium_event_text`.
-- Icono de la ciudad: la maqueta con rotulo activity/icon/activity_shizishou.csb (la de
-- Codigos/Suscripciones) con el dibujo zc_icon_fury_premium.png.
-----------------------------------------------------------------------------------------------
FuryPremiumCoinsCell = class("FuryPremiumCoinsCellClass", Window)

local TYPE = 29150

local fury_premium_coins_open_terminal = {
	_name = "fury_premium_coins_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if _ED.active_activity[TYPE] ~= nil then
			app.load("client.activity.wonderful.ActivitySuperPack")
			state_machine.excute("activity_super_pack_window_open", 0, TYPE)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(fury_premium_coins_open_terminal)
state_machine.init()

function FuryPremiumCoinsCell:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryPremiumCoinsCell:init()
	local csbCell = csb.createNode("activity/icon/activity_shizishou.csb")
	local root = csbCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	self:setContentSize(root:getContentSize())
	local button = ccui.Helper:seekWidgetByName(root, "Button_act_but")
	local art = "images/ui/text/sm_hd/zc_icon_fury_premium.png"
	button:loadTextures(art, art, art)
	local label = fwin:furyCityIconCaption(root)
	if label ~= nil then
		label:setString(_fury_premium_event_text ~= nil and tostring(_fury_premium_event_text[1]) or "")
		label:setVisible(true)
		local w = label:getVirtualRendererSize().width
		if w > 74 then
			label:setScale(74 / w)
		end
	end
	fwin:furyCityIconLabel(label)
	local timer = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
	if timer ~= nil then
		timer:setString("")
	end
	fwin:addTouchEventListener(button, nil,
	{ terminal_name = "fury_premium_coins_open", terminal_state = 0, isPressedActionEnabled = true }, nil, 0)
end

function FuryPremiumCoinsCell:createCell()
	local cell = FuryPremiumCoinsCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function FuryPremiumCoinsCell:onExit()
end
