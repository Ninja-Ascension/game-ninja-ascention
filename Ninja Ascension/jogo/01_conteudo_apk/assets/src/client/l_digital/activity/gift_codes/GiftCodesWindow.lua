-----------------------------------------------------------------------------------------------
-- LOS CODIGOS DE REGALO (punto 7.26, 24-sep-2026).
--
-- La ventana que abre el icono «Codigos» de la ciudad (GiftCodesCell.lua) y
-- que se abre sola la primera vez de cada dia de juego con codigos nuevos.
--
-- LOS DATOS LOS MANDA EL SERVIDOR en el S2C 342, que el cliente ya sabe leer:
-- `parse_activity_request_address` (ProtocolParser.lua:1739-1742) guarda sus
-- dos tokens en `_ED.activity_request_address` y `_ED.game_request_address`,
-- y ningun otro fichero del cliente los lee. El servidor (`cdkey:showcase_token/2`)
-- los rellena asi:
--   token 1: «CODIGO:clase:caduca:canjeado:premio» separadas por «;»
--            (clase 0 = no caduca, 1 = diario, 2 = diario de HOY; caduca en
--            segundos UNIX; premio «tipo,molde,cantidad|...»), o "0" si no hay;
--   token 2: el dia de juego de hoy.
--
-- MAQUETAS REUTILIZADAS (ninguna nueva):
--   ventana: activity/wonderful/sm_limited_time_equip_box_help.csb
--            (Text_title, ListView_xsbx_rule, Button_closed; en los 12 idiomas);
--   fila:    activity/wonderful/sm_limited_time_equip_box_help_list_2.csb
--            (Text_ranking, Text_kehuode, ListView_ranking_reward_2).
--
-- COPIAR: el cliente no tiene puente al portapapeles (el nativo no atiende el
-- 4015 CC_COPY_PASTE_TEXT_START: solo lo declara, ThirdpartySupporter.smali;
-- no hay ClipboardManager en todo smali/). Lo que SI hay es el cuadro de texto
-- nativo de Android (Cocos2dxEditBoxDialog, cocos2d-x 3.5): cada codigo lleva
-- encima un ccui.EditBox transparente; al TOCARLO (no al mantener) se abre el
-- dialogo con un EditText que tiene el codigo, y ahi «mantener pulsado ->
-- Copiar» es el de cualquier EditText. Ese EditText sale en una barra ENCIMA
-- DEL TECLADO y el dialogo la deja INVISIBLE hasta que el teclado aparece
-- (Cocos2dxEditBoxDialog.smali:345, la enciende SoftKeyboardUtil): sin teclado
-- en pantalla (LDPlayer con teclado fisico) solo se ve la pantalla oscurecida.
-- El boton «Canjear» abre el canje de Ajustes con el codigo ya escrito.
--
-- El EditBox NO guarda el codigo en reposo: el motor pinta su texto con su
-- propia etiqueta (setFontSize no la cambia si no hay nombre de fuente) y salia
-- el codigo DOS veces. Se le pone al empezar («began», que en la 3.5 llega
-- ANTES de abrir el dialogo: el mismo truco que draw:addEditBoxEx,
-- display.lua:777) y se vacia al cerrar.
-----------------------------------------------------------------------------------------------
GiftCodesWindow = class("GiftCodesWindowClass", Window)

-- «CODIGO:clase:caduca:canjeado:premio;...» -> lista de entradas. Descarta todo
-- lo que no tenga cinco campos (el centinela "0", nil, basura) y los codigos que
-- no midan 10 (la pantalla del canje no los aceptaria: SmPlayerSystemSetCDKey.lua:46).
function GiftCodesWindow_parse(text)
	local list = {}
	if type(text) ~= "string" then
		return list
	end
	for entry in string.gmatch(text, "[^;]+") do
		local f = {}
		for field in string.gmatch(entry, "[^:]+") do
			f[#f + 1] = field
		end
		if #f == 5 and string.len(f[1]) == 10 then
			list[#list + 1] = {
				code = f[1],
				kind = tonumber(f[2]) or 0,
				expires = tonumber(f[3]) or 0,
				used = f[4] == "1",
				reward = f[5],
			}
		end
	end
	return list
end

-- «tipo,molde,cantidad|...» -> {{tipo, cantidad, molde}, ...}
function GiftCodesWindow_rewards(text)
	local list = {}
	for group in string.gmatch(text or "", "[^|]+") do
		local f = {}
		for field in string.gmatch(group, "[^,]+") do
			f[#f + 1] = tonumber(field)
		end
		if #f == 3 and f[1] ~= nil and f[2] ~= nil and f[3] ~= nil then
			list[#list + 1] = {f[1], f[3], f[2]}
		end
	end
	return list
end

-- ¿Hay que abrirla sola? Solo si trae codigos de HOY (clase 2) y este dia aun
-- no se enseno. `seen` es lo guardado en el aparato para esta cuenta y servidor.
function GiftCodesWindow_shouldPopup(text, day, seen)
	if day == nil or tostring(day) == "" or tostring(day) == tostring(seen) then
		return false
	end
	for _, v in ipairs(GiftCodesWindow_parse(text)) do
		if v.kind == 2 then
			return true
		end
	end
	return false
end

-- Victor 26-sep: al abrir el juego, una vez por arranque (`shown` es un global
-- que vive lo que el proceso), si el personaje pasa del nivel 6 y hay algun
-- codigo que ensenar.
function GiftCodesWindow_shouldPopupAtStart(text, level, shown)
	if shown == true or (tonumber(level) or 0) <= 6 then
		return false
	end
	return #GiftCodesWindow_parse(text) > 0
end

-- Encoge una etiqueta para que no pase de `width` (el ancla no se toca).
function GiftCodesWindow_fitWidth(label, width)
	local w = label:getVirtualRendererSize().width
	if w > width then
		label:setScale(width / w)
	end
end

-- El manejador del EditBox de copiar: el codigo solo mientras el dialogo esta
-- abierto; en reposo vacio (si no, el motor lo pinta encima de la etiqueta).
function GiftCodesWindow_copyHandler(code)
	return function(eventName, sender)
		if eventName == "began" then
			sender:setText(code)
		elseif eventName == "ended" or eventName == "return" then
			sender:setText("")
		end
	end
end

-- El texto de estado de una fila. `now` en segundos del servidor.
function GiftCodesWindow_status(v, now)
	local tips = tipStringInfo_gift_codes
	if v.used then
		return tips[6]
	end
	local text = tips[2]
	if v.expires > 0 then
		local left = v.expires - now
		if left >= 86400 then
			text = string.format(tips[3], math.floor(left / 86400))
		else
			text = string.format(tips[4], math.max(1, math.ceil(left / 3600)))
		end
	end
	if v.kind == 2 then
		text = tips[5] .. " " .. text
	end
	return text
end

local gift_codes_window_open_terminal = {
	_name = "gift_codes_window_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("GiftCodesWindowClass") == nil then
			fwin:open(GiftCodesWindow:new():init(), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local gift_codes_window_close_terminal = {
	_name = "gift_codes_window_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("GiftCodesWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- «Canjear»: abre el canje de Ajustes (SmPlayerSystemSetCDKey) con el codigo ya
-- escrito. El canje lo hace esa pantalla, con su C2S 63 de siempre.
local gift_codes_window_redeem_terminal = {
	_name = "gift_codes_window_redeem",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local code = params._datas.code
		fwin:close(fwin:find("GiftCodesWindowClass"))
		app.load("client.l_digital.player.SmPlayerSystemSetCDKey")
		state_machine.excute("sm_player_system_set_cdkey_page_open", 0, "")
		fwin:addService({
			callback = function(code)
				local window = fwin:find("SmPlayerSystemSetCDKeyClass")
				if window == nil or window.roots == nil or window.roots[1] == nil then
					return
				end
				local field = ccui.Helper:seekWidgetByName(window.roots[1], "TextField_name")
				if field ~= nil then
					field:setString(code)
					if field.editBox ~= nil then
						field.editBox:setText(code)
					end
				end
			end,
			delay = 0.2,
			params = code
		})
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(gift_codes_window_open_terminal)
state_machine.add(gift_codes_window_close_terminal)
state_machine.add(gift_codes_window_redeem_terminal)
state_machine.init()

function GiftCodesWindow:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
end

function GiftCodesWindow:init()
	self:setTouchEnabled(true)
	self:onInit()
	return self
end

function GiftCodesWindow:onInit()
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "gift_codes_window_close",
		terminal_state = 0,
		touch_black = true,
	}, nil, 3)

	self:onUpdateDraw()
end

function GiftCodesWindow:onUpdateDraw()
	local root = self.roots[1]
	local tips = tipStringInfo_gift_codes
	local title = ccui.Helper:seekWidgetByName(root, "Text_title")
	title:setString(tips[1])
	local fontName = title:getFontName()

	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	listView:removeAllItems()
	local width = listView:getContentSize().width

	local entries = GiftCodesWindow_parse(_ED.activity_request_address)
	local now = os.time() + (tonumber(_ED.time_add_or_sub) or 0)
	local shown = 0

	listView:addChild(self:createTextRow(tips[7], fontName, width))
	for _, v in ipairs(entries) do
		if v.expires == 0 or v.expires > now then
			listView:addChild(self:createCodeRow(v, now, fontName))
			shown = shown + 1
		end
	end
	if shown == 0 then
		listView:addChild(self:createTextRow(tips[8], fontName, width))
	end
	listView:requestRefreshView()
end

-- Una linea de texto a lo ancho de la lista (el aviso de como copiar).
function GiftCodesWindow:createTextRow(text, fontName, width)
	local label = ccui.Text:create(text, fontName, 22)
	label:ignoreContentAdaptWithSize(false)
	label:setTextAreaSize(cc.size(width - 20, 0))
	label:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	local height = label:getVirtualRendererSize().height + 16
	label:setContentSize(cc.size(width - 20, height))
	label:setAnchorPoint(cc.p(0.5, 0.5))
	label:setPosition(cc.p(width / 2, height / 2))
	local row = ccui.Layout:create()
	row:setContentSize(cc.size(width, height))
	row:addChild(label)
	return row
end

function GiftCodesWindow:createCodeRow(v, now, fontName)
	local tips = tipStringInfo_gift_codes
	local csbRow = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help_list_2.csb")
	local root = csbRow:getChildByName("root")
	root:removeFromParent(false)
	local size = root:getContentSize()

	-- los premios empiezan en x = 250: codigo y estado caben en 220
	local textWidth = 220
	local codeText = ccui.Helper:seekWidgetByName(root, "Text_ranking")
	codeText:setString(v.code)
	codeText:setPosition(cc.p(30, 78))
	GiftCodesWindow_fitWidth(codeText, textWidth)

	local status = ccui.Helper:seekWidgetByName(root, "Text_kehuode")
	status:setString(GiftCodesWindow_status(v, now))
	status:setFontSize(20)
	status:setPosition(cc.p(30, 36))
	GiftCodesWindow_fitWidth(status, textWidth)
	if v.used then
		status:setColor(cc.c3b(160, 160, 160))
	elseif v.kind == 2 then
		status:setColor(cc.c3b(80, 230, 80))
	end

	-- COPIAR: el EditBox transparente encima del codigo, VACIO en reposo.
	-- Sin contrasena (con ella Android no deja copiar).
	local edit = ccui.EditBox:create(cc.size(textWidth, 64), "effect/effice_1500.png")
	edit:setAnchorPoint(cc.p(0, 0.5))
	edit:setPosition(cc.p(20, 78))
	edit:setMaxLength(10)
	edit:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_ALL_CHARACTERS)
	edit:registerScriptEditBoxHandler(GiftCodesWindow_copyHandler(v.code))
	root:addChild(edit)

	-- Los premios, a 0.75 para que quepan los cuatro de los diarios.
	local rewards = ccui.Helper:seekWidgetByName(root, "ListView_ranking_reward_2")
	rewards:removeAllItems()
	-- El ancla X de la lista NO es 0 en todas las maquetas: en la de Naruto
	-- es 0.5 y la lista quedaba centrada en 250, tapando el codigo. Se
	-- fija a la izquierda conservando la Y.
	rewards:setAnchorPoint(cc.p(0, rewards:getAnchorPoint().y))
	rewards:setPositionX(250)
	for _, r in ipairs(GiftCodesWindow_rewards(v.reward)) do
		local cell = ResourcesIconCell:createCell()
		cell:init(r[1], r[2], r[3], nil, nil, true, true, 1)
		cell:setScale(0.75)
		cell:setPosition(cc.p(0, 15))
		local slot = ccui.Layout:create()
		slot:setContentSize(cc.size(90, 120))
		slot:addChild(cell)
		rewards:addChild(slot)
	end
	rewards:requestRefreshView()

	-- «Canjear»: abre el canje con el codigo ya escrito.
	if not v.used then
		local button = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
		button:setTitleText(tips[9])
		button:setTitleFontName(fontName)
		button:setTitleFontSize(22)
		button:setTitleColor(cc.c3b(90, 45, 10))
		button:setPosition(cc.p(size.width - 70, size.height / 2))
		root:addChild(button)
		fwin:addTouchEventListener(button, nil,
		{
			terminal_name = "gift_codes_window_redeem",
			terminal_state = 0,
			isPressedActionEnabled = true,
			code = v.code,
		}, nil, 0)
	end

	local row = ccui.Layout:create()
	row:setContentSize(size)
	row:addChild(root)
	return row
end

function GiftCodesWindow:onExit()
end
