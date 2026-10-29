-----------------------------------------------------------------------------------------------
-- INVITA A UN AMIGO (Fury, sistema 18, 30-sep-2026; docs/systems/invita_amigo.md).
--
-- Lua nuevo montado SOLO con maquetas y arte que ya trae el paquete (12 idiomas):
--   icono de la ciudad: activity/icon/activity_shizishou.csb (la de «Codigos» y
--            «Suscripciones») con el dibujo nuevo zc_icon_fury_invite.png (dos
--            caras de home/head_7 y head_8 + un «+»; tools/invita_amigo/icono.py);
--   ventana: activity/wonderful/sm_limited_time_equip_box_help.csb (la de los codigos);
--   filas de tramo: activity/wonderful/sm_limited_time_equip_box_help_list_2.csb +
--            ResourcesIconCell; boton images/ui/button/btn_1.png;
--   copiar/teclear: ccui.EditBox (el cuadro nativo de Android, como en «Codigos»);
--   ayuda: «?» images/ui/button/icon_wenhao.png + utils/common_popup_rule.csb.
-- Textos: `_fury_invite_text` de TipStringInfo.lua (12 idiomas).
--
-- EL PROTOCOLO: dos comandos PROPIOS por el transporte de siempre, dados de alta
-- en las tablas del propio cliente cada vez que se usan.
--   C2S 29190 fury_invite_view  rol
--   C2S 29191 fury_invite_bind  rol, codigo
--   S2C 29195 la ventana: resultado (0 vista, 1 vinculado, 2 no existe, 3 propio,
--             4 ya tiene invitador, 5 ya no es nuevo), mi codigo, puede introducir,
--             segundos que le quedan, tiene invitador, su nombre, tope, premiados,
--             n tramos (nivel, premio invitador, premio invitado), n invitados
--             (nombre, nivel, tramo pagado, premia al invitador).
-- El servidor decide todo (invite_friend.erl); el cliente solo manda el codigo.
-----------------------------------------------------------------------------------------------
FuryInviteFriend = class("FuryInviteFriendClass", Window)

local VIEW_CODE, BIND_CODE, PARSER_CODE = 29190, 29191, 29195

local function text(i)
	return _fury_invite_text ~= nil and _fury_invite_text[i] or ""
end

local function sub_command(key)
	return function(str)
		local item = protocol_command[key]
		str = str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
		return str
	end
end

-- El bloque 29195. Publica para la prueba de tests/cliente_invita_amigo.
function parse_fury_invite(interpreter, datas, pos, strDatas, list, count)
	local v = { tiers = {}, invitees = {} }
	v.result = tonumber(npos(list)) or 0
	v.code = npos(list) or ""
	v.canBind = tonumber(npos(list)) == 1
	v.bindLeft = tonumber(npos(list)) or 0
	v.bound = tonumber(npos(list)) == 1
	v.boundName = npos(list) or ""
	v.limit = tonumber(npos(list)) or 0
	v.rewarded = tonumber(npos(list)) or 0
	local n = tonumber(npos(list)) or 0
	for i = 1, n do
		local t = {}
		t.level = tonumber(npos(list)) or 0
		t.inviter = npos(list) or ""
		t.invitee = npos(list) or ""
		v.tiers[#v.tiers + 1] = t
	end
	n = tonumber(npos(list)) or 0
	for i = 1, n do
		local f = {}
		f.name = npos(list) or ""
		f.level = tonumber(npos(list)) or 0
		f.paid = tonumber(npos(list)) or 0
		f.rewarded = tonumber(npos(list)) == 1
		v.invitees[#v.invitees + 1] = f
	end
	_ED.fury_invite = v
end

-- Da de alta (o vuelve a dar) los dos comandos y el bloque. Idempotente.
function FuryInviteFriend_ensureProtocol()
	protocol_command.fury_invite_view = protocol_command.fury_invite_view or
		{ code = VIEW_CODE, command = "fury_invite_view",
		  command_fun = sub_command("fury_invite_view"), param_list = "" }
	protocol_command.fury_invite_bind = protocol_command.fury_invite_bind or
		{ code = BIND_CODE, command = "fury_invite_bind",
		  command_fun = sub_command("fury_invite_bind"), param_list = "" }
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER_CODE, parser = "parse_fury_invite",
		parser_fun = parse_fury_invite })
end

-- Lo que teclea el jugador: mayusculas y solo letras/numeros. nil si no mide 6.
function FuryInviteFriend_cleanCode(str)
	local code = string.upper((string.gsub(str or "", "[^%w]", "")))
	if #code ~= 6 then
		return nil
	end
	return code
end

-- «tipo,molde,cantidad|...» -> {{tipo, cantidad, molde}, ...}
function FuryInviteFriend_rewards(str)
	local list = {}
	for group in string.gmatch(str or "", "[^|]+") do
		local f = {}
		for field in string.gmatch(group, "[^,]+") do
			f[#f + 1] = tonumber(field)
		end
		if #f == 3 and f[1] ~= nil and f[2] ~= nil and f[3] ~= nil then
			list[#list + 1] = { f[1], f[3], f[2] }
		end
	end
	return list
end

-- Segundos -> «2d 5h» (texto 28).
function FuryInviteFriend_timeLeft(seconds)
	seconds = math.max(0, tonumber(seconds) or 0)
	return string.format(text(28), math.floor(seconds / 86400), math.floor(seconds % 86400 / 3600))
end

-- El aviso de lo que paso al introducir un codigo (nil = solo se miro).
function FuryInviteFriend_resultText(result)
	local map = { [1] = 17, [2] = 18, [3] = 19, [4] = 20, [5] = 21 }
	return map[result] ~= nil and text(map[result]) or nil
end

-- Las reglas del «?»: 24..27, una por linea (la 27 lleva el tope).
function FuryInviteFriend_rules(limit)
	return table.concat({ text(24), text(25), text(26), string.format(text(27), tonumber(limit) or 0) }, "\n")
end

-- El EditBox de copiar: el codigo solo mientras el dialogo nativo esta abierto;
-- en reposo vacio (si no, el motor lo pinta encima de la etiqueta).
function FuryInviteFriend_copyHandler(code)
	return function(eventName, sender)
		if eventName == "began" then
			sender:setText(code)
		elseif eventName == "ended" or eventName == "return" then
			sender:setText("")
		end
	end
end

local function fitWidth(label, width)
	local w = label:getVirtualRendererSize().width
	if w > width then
		label:setScale(width / w)
	end
end

local function redraw()
	local window = fwin:find("FuryInviteFriendClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
end

local function requestView()
	FuryInviteFriend_ensureProtocol()
	local function callback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			redraw()
		end
	end
	protocol_command.fury_invite_view.param_list = ""
	NetworkManager:register(VIEW_CODE, nil, nil, nil, nil, callback, false, nil)
end

local function requestBind(code)
	FuryInviteFriend_ensureProtocol()
	local function callback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			local msg = _ED.fury_invite ~= nil and FuryInviteFriend_resultText(_ED.fury_invite.result) or nil
			if msg ~= nil then
				TipDlg.drawTextDailog(msg)
			end
			redraw()
		end
	end
	protocol_command.fury_invite_bind.param_list = code
	NetworkManager:register(BIND_CODE, nil, nil, nil, nil, callback, false, nil)
end

local fury_invite_open_terminal = {
	_name = "fury_invite_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("FuryInviteFriendClass") == nil then
			_ED.fury_invite = nil
			fwin:open(FuryInviteFriend:new():init(), fwin._ui)
			requestView()
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_invite_close_terminal = {
	_name = "fury_invite_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FuryInviteFriendClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- «Confirmar»: el codigo del cuadro, limpio; si no mide 6 no se manda nada.
local fury_invite_bind_terminal = {
	_name = "fury_invite_bind",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local window = fwin:find("FuryInviteFriendClass")
		local edit = window ~= nil and window.codeInput or nil
		local code = edit ~= nil and FuryInviteFriend_cleanCode(edit:getText()) or nil
		if code == nil then
			TipDlg.drawTextDailog(text(22))
			return true
		end
		requestBind(code)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_invite_help_terminal = {
	_name = "fury_invite_help",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("FuryInviteRulesClass") == nil then
			fwin:open(FuryInviteRules:new():init(), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_invite_rules_close_terminal = {
	_name = "fury_invite_rules_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FuryInviteRulesClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fury_invite_open_terminal)
state_machine.add(fury_invite_close_terminal)
state_machine.add(fury_invite_bind_terminal)
state_machine.add(fury_invite_help_terminal)
state_machine.add(fury_invite_rules_close_terminal)
state_machine.init()

function FuryInviteFriend:ctor()
	self.super:ctor()
	self.roots = {}
	self.codeInput = nil
	app.load("client.cells.utils.resources_icon_cell")
end

function FuryInviteFriend:init()
	self:setTouchEnabled(true)
	self:onInit()
	return self
end

function FuryInviteFriend:onInit()
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fury_invite_close",
		terminal_state = 0,
		touch_black = true,
	}, nil, 3)

	local title = ccui.Helper:seekWidgetByName(root, "Text_title")
	title:setString(text(1))
	local help = ccui.Button:create("images/ui/button/icon_wenhao.png",
		"images/ui/button/icon_wenhao.png")
	local tx, ty = title:getPosition()
	local tw = title:getContentSize().width * title:getScaleX()
	help:setPosition(cc.p(tx + tw * (1 - title:getAnchorPoint().x) + 40, ty))
	title:getParent():addChild(help)
	fwin:addTouchEventListener(help, nil,
	{
		terminal_name = "fury_invite_help",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self:onUpdateDraw()
end

local function label(parent, str, fontName, size, x, y, color, width)
	local l = ccui.Text:create(str, fontName, size)
	l:setAnchorPoint(cc.p(0, 0.5))
	l:setPosition(cc.p(x, y))
	if color ~= nil then
		l:setColor(color)
	end
	parent:addChild(l)
	if width ~= nil then
		fitWidth(l, width)
	end
	return l
end

function FuryInviteFriend:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local title = ccui.Helper:seekWidgetByName(root, "Text_title")
	local fontName = title:getFontName()
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	listView:removeAllItems()
	self:clearFloatingEdits()
	self.codeInput = nil
	local v = _ED.fury_invite
	if v == nil then
		return
	end
	local width = listView:getContentSize().width
	listView:addChild(self:createMyCodeRow(v, fontName, width))
	listView:addChild(self:createStepsRow(v, fontName, width))
	listView:addChild(self:createEnterRow(v, fontName, width))
	for _, t in ipairs(v.tiers) do
		listView:addChild(self:createTierRow(string.format(text(10), t.level), t.inviter, fontName))
		listView:addChild(self:createTierRow(string.format(text(11), t.level), t.invitee, fontName))
	end
	listView:addChild(self:createInviteesTitle(v, fontName, width))
	for _, f in ipairs(v.invitees) do
		listView:addChild(self:createInviteeRow(f, fontName, width))
	end
	listView:requestRefreshView()
	self:placeFloatingEdits(listView)
end

-- LAS CAJAS DE TEXTO VAN FUERA DE LA LISTA (1-oct, Victor: «no deja escribir el codigo
-- del amigo»). Un ccui.EditBox hijo de una fila de ListView no se pinta ni abre el
-- teclado en este motor (visto en LDPlayer: ni el marcador sale); el de «Codigos»
-- funciona porque cuelga de la raiz. Cada fila deja un hueco (`anchor`) y aqui se crea
-- el EditBox en la raiz, encima del hueco, y se recoloca al desplazar la lista; si el
-- hueco sale de la parte visible, se oculta.
function FuryInviteFriend:clearFloatingEdits()
	for _, f in ipairs(self.floatingEdits or {}) do
		if f.edit ~= nil then
			f.edit:removeFromParent(true)
		end
	end
	self.floatingEdits = {}
	self.pendingEdits = {}
end

function FuryInviteFriend:addFloatingEdit(anchor, setup)
	self.pendingEdits = self.pendingEdits or {}
	table.insert(self.pendingEdits, { anchor = anchor, setup = setup })
end

function FuryInviteFriend:placeFloatingEdits(listView)
	local root = self.roots[1]
	local pending = self.pendingEdits or {}
	self.pendingEdits = {}
	self.floatingEdits = self.floatingEdits or {}
	for _, p in ipairs(pending) do
		local size = p.anchor:getContentSize()
		local edit = ccui.EditBox:create(cc.size(size.width, size.height), "effect/effice_1500.png")
		edit:setAnchorPoint(cc.p(0, 0))
		p.setup(edit)
		root:addChild(edit, 50)
		table.insert(self.floatingEdits, { edit = edit, anchor = p.anchor })
	end
	local window = self
	local function follow()
		window:followFloatingEdits(listView)
	end
	if not self.floatingListening then
		self.floatingListening = true
		listView:addScrollViewEventListener(function() follow() end)
	end
	-- La lista coloca sus filas en el siguiente fotograma: se sigue entonces y al momento.
	follow()
	root:runAction(cc.Sequence:create(cc.DelayTime:create(0.05), cc.CallFunc:create(follow)))
end

function FuryInviteFriend:followFloatingEdits(listView)
	local root = self.roots[1]
	if root == nil or listView == nil then
		return
	end
	local lp = listView:convertToWorldSpace(cc.p(0, 0))
	local ls = listView:getContentSize()
	for _, f in ipairs(self.floatingEdits or {}) do
		local wp = f.anchor:convertToWorldSpace(cc.p(0, 0))
		local s = f.anchor:getContentSize()
		local visible = wp.y >= lp.y - 2 and wp.y + s.height <= lp.y + ls.height + 2
		f.edit:setPosition(root:convertToNodeSpace(wp))
		f.edit:setVisible(visible)
	end
end

-- «Mi codigo: ABC234» con el EditBox de copiar encima, y los premiados.
function FuryInviteFriend:createMyCodeRow(v, fontName, width)
	local row = ccui.Layout:create()
	row:setContentSize(cc.size(width, 140))
	label(row, string.format(text(2), v.code), fontName, 32, 20, 104, cc.c3b(255, 220, 90), width - 40)
	local copyAnchor = ccui.Layout:create()
	copyAnchor:setContentSize(cc.size(math.min(width - 40, 420), 56))
	copyAnchor:setPosition(cc.p(20, 76))
	row:addChild(copyAnchor)
	self:addFloatingEdit(copyAnchor, function(edit)
		edit:setMaxLength(6)
		edit:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_ALL_CHARACTERS)
		edit:registerScriptEditBoxHandler(FuryInviteFriend_copyHandler(v.code))
	end)
	label(row, text(3), fontName, 18, 20, 64, cc.c3b(200, 200, 200), width - 40)
	label(row, string.format(text(4), v.rewarded, v.limit), fontName, 22, 20, 26, nil, width - 40)
	return row
end

-- Cabecera de la seccion «Introducir codigo de invitacion» con los tres pasos, para que el
-- jugador nuevo sepa que hacer (Victor, 30-sep: «no entiendo como el nuevo introduce el codigo»).
function FuryInviteFriend:createStepsRow(v, fontName, width)
	local row = ccui.Layout:create()
	row:setContentSize(cc.size(width, 150))
	row:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	row:setBackGroundColor(cc.c3b(20, 20, 45))
	row:setBackGroundColorOpacity(120)
	label(row, text(29), fontName, 26, 20, 128, cc.c3b(255, 220, 90), width - 40)
	for k = 1, 3 do
		label(row, text(29 + k), fontName, 18, 20, 128 - k * 34, cc.c3b(230, 230, 230), width - 40)
	end
	return row
end

-- «Introducir codigo»: el cuadro y «Confirmar» si aun puede; si no, por que no.
function FuryInviteFriend:createEnterRow(v, fontName, width)
	local row = ccui.Layout:create()
	row:setContentSize(cc.size(width, 120))
	row:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	row:setBackGroundColor(cc.c3b(20, 20, 45))
	row:setBackGroundColorOpacity(120)
	if v.bound then
		label(row, string.format(text(8), v.boundName), fontName, 24, 20, 60, cc.c3b(80, 230, 80), width - 40)
	elseif v.canBind then
		local box = ccui.Layout:create()
		box:setContentSize(cc.size(280, 54))
		box:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
		box:setBackGroundColor(cc.c3b(0, 0, 0))
		box:setBackGroundColorOpacity(200)
		box:setPosition(cc.p(20, 50))
		row:addChild(box)
		local shown = label(box, "", fontName, 26, 12, 27, cc.c3b(255, 255, 255), 256)
		local window = self
		self:addFloatingEdit(box, function(edit)
			edit:setMaxLength(8)
			edit:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_ALL_CHARACTERS)
			edit:setFontColor(cc.c3b(255, 255, 255))
			edit:setPlaceHolder(text(5))
			edit:setPlaceholderFontColor(cc.c3b(150, 150, 150))
			window.codeInput = edit
			-- En reposo el motor no pinta el texto del EditBox flotante (visto en
			-- LDPlayer): se ensena en una etiqueta dentro del cuadro.
			edit:registerScriptEditBoxHandler(function(eventName, sender)
				if eventName == "changed" or eventName == "ended" or eventName == "return" then
					shown:setString(sender:getText())
				end
			end)
		end)
		local button = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
		button:setTitleText(text(6))
		button:setTitleFontName(fontName)
		button:setTitleFontSize(22)
		button:setTitleColor(cc.c3b(90, 45, 10))
		fwin:fitButtonTitle(button)
		button:setPosition(cc.p(math.max(400, width - 90), 77))
		row:addChild(button)
		fwin:addTouchEventListener(button, nil,
		{
			terminal_name = "fury_invite_bind",
			terminal_state = 0,
			isPressedActionEnabled = true,
		}, nil, 0)
		label(row, string.format(text(7), FuryInviteFriend_timeLeft(v.bindLeft)), fontName, 18, 20, 22, cc.c3b(200, 200, 200), width - 40)
	else
		-- Ya no puede: aviso bien visible, en rojo claro.
		local l = label(row, text(9), fontName, 20, 20, 60, cc.c3b(255, 130, 110))
		-- En varias lineas dentro del recuadro (en una sola se salia por la izquierda).
		l:ignoreContentAdaptWithSize(false)
		l:setContentSize(cc.size(width - 40, 100))
		l:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
		l:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	end
	return row
end

-- Un tramo: «Nv. 20: premio del que invita» y sus fichas.
function FuryInviteFriend:createTierRow(caption, rewardText, fontName)
	local csbRow = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help_list_2.csb")
	local root = csbRow:getChildByName("root")
	root:removeFromParent(false)
	local size = root:getContentSize()
	local textX, textWidth = 20, 230
	local name = ccui.Helper:seekWidgetByName(root, "Text_ranking")
	name:setString(caption)
	name:setAnchorPoint(cc.p(0, 0.5))
	name:setPosition(cc.p(textX, size.height / 2))
	fitWidth(name, textWidth)
	local status = ccui.Helper:seekWidgetByName(root, "Text_kehuode")
	status:setString("")
	local rewards = fwin:furyRowRewardList(root)
	rewards:removeAllItems()
	rewards:setPositionX(textX + textWidth + 10)
	for _, r in ipairs(FuryInviteFriend_rewards(rewardText)) do
		local cell = ResourcesIconCell:createCell()
		cell:init(r[1], r[2], r[3], nil, nil, true, true, 1)
		cell:setScale(0.7)
		cell:setPosition(cc.p(0, 18))
		local slot = ccui.Layout:create()
		slot:setContentSize(cc.size(80, 120))
		slot:addChild(cell)
		rewards:addChild(slot)
	end
	rewards:requestRefreshView()
	local row = ccui.Layout:create()
	row:setContentSize(size)
	row:addChild(root)
	return row
end

function FuryInviteFriend:createInviteesTitle(v, fontName, width)
	local empty = #v.invitees == 0
	local row = ccui.Layout:create()
	row:setContentSize(cc.size(width, empty and 90 or 50))
	label(row, text(12), fontName, 26, 20, empty and 64 or 25, cc.c3b(255, 220, 90), width - 40)
	if empty then
		label(row, text(13), fontName, 20, 20, 22, cc.c3b(200, 200, 200), width - 40)
	end
	return row
end

-- «Nombre - Nv. 35» y a la derecha lo cobrado (o que no premia al invitador).
function FuryInviteFriend:createInviteeRow(f, fontName, width)
	local row = ccui.Layout:create()
	row:setContentSize(cc.size(width, 44))
	label(row, string.format(text(14), f.name, f.level), fontName, 22, 20, 22, nil, width / 2 - 30)
	if f.rewarded then
		label(row, string.format(text(15), f.paid), fontName, 18, width / 2, 22, cc.c3b(80, 230, 80), width / 2 - 20)
	else
		label(row, text(16), fontName, 18, width / 2, 22, cc.c3b(160, 160, 160), width / 2 - 20)
	end
	return row
end

function FuryInviteFriend:onExit()
end

-----------------------------------------------------------------------------------------------
-- Las reglas (el «?»): utils/common_popup_rule.csb con `_fury_invite_text` 24..27.
-----------------------------------------------------------------------------------------------
FuryInviteRules = class("FuryInviteRulesClass", Window)

function FuryInviteRules:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryInviteRules:init()
	self:setTouchEnabled(true)
	local csbNode = csb.createNode("utils/common_popup_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	local title = ccui.Helper:seekWidgetByName(root, "Text_tittle")
	if title ~= nil then
		title:setString(text(23))
	end
	local body = ccui.Helper:seekWidgetByName(root, "Text_1")
	if body ~= nil then
		body:setString(FuryInviteFriend_rules(_ED.fury_invite ~= nil and _ED.fury_invite.limit or 20))
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "fury_invite_rules_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	return self
end

function FuryInviteRules:onExit()
end

-----------------------------------------------------------------------------------------------
-- EL ICONO DE LA CIUDAD (Home.lua; desde el nivel 5 como «Codigos»; activity_type 29190,
-- sin fila en activity_sorting_mould: va al final).
-----------------------------------------------------------------------------------------------
FuryInviteFriendCell = class("FuryInviteFriendCellClass", Window)

function FuryInviteFriendCell:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryInviteFriendCell:init()
	local csbCell = csb.createNode("activity/icon/activity_shizishou.csb")
	local root = csbCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	self:setContentSize(root:getContentSize())

	local button = ccui.Helper:seekWidgetByName(root, "Button_act_but")
	local art = "images/ui/text/sm_hd/zc_icon_fury_invite.png"
	button:loadTextures(art, art, art)
	local caption = fwin:furyCityIconCaption(root)
	if caption ~= nil then
		caption:setString(text(1))
		caption:setVisible(true)
		fitWidth(caption, 74)
	end
	fwin:furyCityIconLabel(caption)
	local timer = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
	if timer ~= nil then
		timer:setString("")
	end
	fwin:addTouchEventListener(button, nil,
	{
		terminal_name = "fury_invite_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
end

function FuryInviteFriendCell:createCell()
	local cell = FuryInviteFriendCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function FuryInviteFriendCell:onExit()
end
