-----------------------------------------------------------------------------------------------
-- EL BANNER ESPECIAL SR (Fury, sistema C, 29-sep-2026; docs/systems/banner_sr.md).
--
-- Encargo de Victor: ruleta como la de Dragon Treasure donde el jugador ELIGE
-- un SR de la lista de la semana y las casillas de fragmentos le dan
-- fragmentos de ESE SR; el resto, relleno barato. Mismo coste que Dragon
-- Treasure. El cliente original no trae esta pantalla: es Lua nuevo montado
-- SOLO con maquetas y arte del paquete (12 idiomas):
--   ventana:  activity/wonderful/rare_treasure.csb (la de Dragon Treasure,
--             TreasureWindow.lua) con el fondo tenido de morado, titulo propio,
--             el boton de refresco convertido en «Elegir SR», la tienda y los
--             puntos ocultos y el panel de raras con los fragmentos del SR;
--   elegir:   activity/wonderful/sm_limited_time_equip_box_help.csb (lista con
--             la ficha del heroe, ResourcesIconCell tipo 13, y btn_1.png);
--   reglas:   utils/common_popup_rule.csb;
--   icono:    activity/icon/activity_shizishou.csb con
--             images/ui/text/sm_hd/zc_icon_fury_banner_sr.png
--             (tools/banner_sr_icono.py).
-- Los textos: `_fury_banner_sr_text` de TipStringInfo.lua (12 idiomas).
--
-- EL PROTOCOLO: tres comandos PROPIOS (numeros reservados 29040-29049), dados
-- de alta aqui en `protocol_command` / `protocol_parse` cada vez que se usan:
--   C2S 29040 fury_banner_sr_view    rol
--   C2S 29041 fury_banner_sr_choose  rol, molde del SR
--   C2S 29042 fury_banner_sr_draw    rol, 0 (una) | 1 (diez)
--   S2C 29045 la ventana: SR elegido (0 ninguno), gratis que quedan, tope de
--             gratis, gemas por tirada, ficha, segundos hasta la lista nueva,
--             N + N SR, M + M casillas «hueco,sr,tipo,molde,cantidad», K + K
--             huecos de la ultima tirada.
-- El servidor manda (banner_sr.erl): valida la eleccion contra la lista de la
-- semana, sortea, cobra y entrega. El evento es el tipo 29040 del bloque 85.
-----------------------------------------------------------------------------------------------
FuryBannerSR = class("FuryBannerSRClass", Window)

local TYPE = 29040
local VIEW_CODE, CHOOSE_CODE, DRAW_CODE, PARSER_CODE = 29040, 29041, 29042, 29045

local function text(i)
	return _fury_banner_sr_text ~= nil and _fury_banner_sr_text[i] or ""
end

local function banner_command(key)
	return function(str)
		local item = protocol_command[key]
		str = str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
		if item.param_list ~= nil and item.param_list ~= "" then
			str = str .. "\r\n" .. item.param_list
		end
		return str
	end
end

local function parse_fury_banner_sr(interpreter, datas, pos, strDatas, list, count)
	local b = { heroes = {}, board = {}, hits = {} }
	b.chosen = tonumber(npos(list)) or 0
	b.free = tonumber(npos(list)) or 0
	b.maxFree = tonumber(npos(list)) or 0
	b.gems = tonumber(npos(list)) or 0
	b.prop = tonumber(npos(list)) or 0
	b.weekLeft = tonumber(npos(list)) or 0
	b.receivedAt = os.time()
	local n = tonumber(npos(list)) or 0
	for i = 1, n do
		b.heroes[#b.heroes + 1] = tonumber(npos(list)) or 0
	end
	local m = tonumber(npos(list)) or 0
	for i = 1, m do
		local f = {}
		for field in string.gmatch(npos(list) or "", "[^,]+") do
			f[#f + 1] = tonumber(field) or 0
		end
		if #f >= 5 then
			b.board[#b.board + 1] = { slot = f[1], sr = f[2] == 1, type = f[3], mould = f[4], count = f[5] }
		end
	end
	local k = tonumber(npos(list)) or 0
	for i = 1, k do
		b.hits[#b.hits + 1] = tonumber(npos(list)) or 0
	end
	-- El registro de premios destacados (30-sep): L y por cada uno nombre (escapado) y
	-- «tipo,molde,cantidad». Un servidor que no lo mande deja la lista vacia.
	b.log = {}
	local l = tonumber(npos(list)) or 0
	for i = 1, l do
		local name = tostring(npos(list) or "")
		name = name:gsub("&nbsp;", " "):gsub("&#13;", ""):gsub("&#10;", " "):gsub("&amp;", "&")
		local f = {}
		for field in string.gmatch(npos(list) or "", "[^,]+") do
			f[#f + 1] = tonumber(field) or 0
		end
		if #f >= 3 then
			b.log[#b.log + 1] = { name = name, type = f[1], mould = f[2], count = f[3] }
		end
	end
	_ED.fury_banner_sr = b
end

-- Da de alta (o vuelve a dar) los tres comandos y el bloque. Idempotente.
function FuryBannerSR_ensureProtocol()
	protocol_command.fury_banner_sr_view = protocol_command.fury_banner_sr_view or
		{ code = VIEW_CODE, command = "fury_banner_sr_view",
		  command_fun = banner_command("fury_banner_sr_view"), param_list = "" }
	protocol_command.fury_banner_sr_choose = protocol_command.fury_banner_sr_choose or
		{ code = CHOOSE_CODE, command = "fury_banner_sr_choose",
		  command_fun = banner_command("fury_banner_sr_choose"), param_list = "" }
	protocol_command.fury_banner_sr_draw = protocol_command.fury_banner_sr_draw or
		{ code = DRAW_CODE, command = "fury_banner_sr_draw",
		  command_fun = banner_command("fury_banner_sr_draw"), param_list = "" }
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER_CODE, parser = "parse_fury_banner_sr",
		parser_fun = parse_fury_banner_sr })
end

local function itemName(kind, mould)
	local ok, info = pcall(getItemNameAndQuality, { kind, mould, 1 })
	if ok and info ~= nil and info[1] ~= nil then
		return tostring(info[1])
	end
	return ""
end

local function fitWidth(label, width)
	local w = label:getVirtualRendererSize().width
	if w > width then
		label:setScale(width / w)
	end
end

local function formatTime(seconds)
	seconds = math.max(0, math.floor(seconds))
	local d = math.floor(seconds / 86400)
	local h = math.floor(seconds % 86400 / 3600)
	local m = math.floor(seconds % 3600 / 60)
	local s = seconds % 60
	local t = string.format("%02d:%02d:%02d", h, m, s)
	if d > 0 then
		t = d .. (_string_piece_info ~= nil and _string_piece_info[231] or "d") .. t
	end
	return t
end

local function refreshWindows()
	local window = fwin:find("FuryBannerSRClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
	local picker = fwin:find("FuryBannerSRPickClass")
	if picker ~= nil then
		picker:onUpdateDraw()
	end
end

local function seek(root, name)
	return ccui.Helper:seekWidgetByName(root, name)
end

-- Busca por nombre en TODO el arbol (seekWidgetByName no entra en los nodos de un .csb
-- incrustado, como el titulo «Tesoro de Dragón», Image_5_0_pr2).
local function seekDeep(node, name)
	if node == nil then
		return nil
	end
	if node:getName() == name then
		return node
	end
	for _, child in ipairs(node:getChildren()) do
		local found = seekDeep(child, name)
		if found ~= nil then
			return found
		end
	end
	return nil
end

local function hide(root, name)
	local w = seek(root, name) or seekDeep(root, name)
	if w ~= nil then
		w:setVisible(false)
	end
end

-----------------------------------------------------------------------------------------------
-- Los terminales
-----------------------------------------------------------------------------------------------
local fury_banner_sr_open_terminal = {
	_name = "fury_banner_sr_open",
	_init = function (terminal) end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		FuryBannerSR_ensureProtocol()
		local function callback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if fwin:find("FuryBannerSRClass") == nil then
					fwin:open(FuryBannerSR:new():init(), fwin._view)
				end
			end
		end
		protocol_command.fury_banner_sr_view.param_list = ""
		NetworkManager:register(VIEW_CODE, nil, nil, nil, nil, callback, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_banner_sr_close_terminal = {
	_name = "fury_banner_sr_close",
	_init = function (terminal) end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("FuryBannerSRPickClass") then
			fwin:close(fwin:find("FuryBannerSRPickClass"))
		end
		if fwin:find("FuryBannerSRClass") then
			fwin:close(fwin:find("FuryBannerSRClass"))
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- Tirar: sin SR elegido no se manda nada; se avisa y se abre la lista.
local fury_banner_sr_draw_terminal = {
	_name = "fury_banner_sr_draw",
	_init = function (terminal) end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local b = _ED.fury_banner_sr
		local window = fwin:find("FuryBannerSRClass")
		if b == nil or window == nil then
			return true
		end
		if b.chosen == 0 then
			TipDlg.drawTextDailog(text(4))
			state_machine.excute("fury_banner_sr_pick_open", 0, nil)
			return true
		end
		local _type = params._datas._type
		state_machine.lock("fury_banner_sr_draw", 0, "")
		FuryBannerSR_ensureProtocol()
		local function callback(response)
			local w = fwin:find("FuryBannerSRClass")
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 and w ~= nil then
				w.Image_treasure_xy:setVisible(true)
				w:onUpdateDraw()
				if _type == 0 then
					w:playOneRound()
				else
					w:playTenRound()
				end
			else
				state_machine.unlock("fury_banner_sr_draw", 0, "")
				if w ~= nil then
					w:onUpdateDraw()
				end
			end
		end
		protocol_command.fury_banner_sr_draw.param_list = tostring(_type)
		NetworkManager:register(DRAW_CODE, nil, nil, nil, nil, callback, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- La flecha del registro lo abre (8 lineas) o lo cierra (1), como en Dragon Treasure.
local fury_banner_sr_log_toggle_terminal = {
	_name = "fury_banner_sr_log_toggle",
	_init = function (terminal) end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local w = fwin:find("FuryBannerSRClass")
		if w ~= nil then
			w.logBig = not w.logBig
			w:sizeLog()
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- Tocar la pantalla durante la animacion la corta y enseña el premio.
local fury_banner_sr_anim_stop_terminal = {
	_name = "fury_banner_sr_anim_stop",
	_init = function (terminal) end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local w = fwin:find("FuryBannerSRClass")
		if w ~= nil then
			w:finishRound()
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_banner_sr_pick_open_terminal = {
	_name = "fury_banner_sr_pick_open",
	_init = function (terminal) end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("FuryBannerSRPickClass") == nil then
			fwin:open(FuryBannerSRPick:new():init(), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_banner_sr_pick_close_terminal = {
	_name = "fury_banner_sr_pick_close",
	_init = function (terminal) end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("FuryBannerSRPickClass") then
			fwin:close(fwin:find("FuryBannerSRPickClass"))
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- Elegir: el servidor comprueba que el SR esta en la lista de la semana.
local fury_banner_sr_choose_terminal = {
	_name = "fury_banner_sr_choose",
	_init = function (terminal) end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local ship = params._datas.ship
		if ship == nil then
			return true
		end
		FuryBannerSR_ensureProtocol()
		local function callback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if fwin:find("FuryBannerSRPickClass") then
					fwin:close(fwin:find("FuryBannerSRPickClass"))
				end
			end
			refreshWindows()
		end
		protocol_command.fury_banner_sr_choose.param_list = tostring(ship)
		NetworkManager:register(CHOOSE_CODE, nil, nil, nil, nil, callback, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_banner_sr_rules_open_terminal = {
	_name = "fury_banner_sr_rules_open",
	_init = function (terminal) end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("FuryBannerSRRulesClass") == nil then
			fwin:open(FuryBannerSRRules:new():init(), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_banner_sr_rules_close_terminal = {
	_name = "fury_banner_sr_rules_close",
	_init = function (terminal) end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("FuryBannerSRRulesClass") then
			fwin:close(fwin:find("FuryBannerSRRulesClass"))
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fury_banner_sr_open_terminal)
state_machine.add(fury_banner_sr_close_terminal)
state_machine.add(fury_banner_sr_draw_terminal)
state_machine.add(fury_banner_sr_anim_stop_terminal)
state_machine.add(fury_banner_sr_log_toggle_terminal)
state_machine.add(fury_banner_sr_pick_open_terminal)
state_machine.add(fury_banner_sr_pick_close_terminal)
state_machine.add(fury_banner_sr_choose_terminal)
state_machine.add(fury_banner_sr_rules_open_terminal)
state_machine.add(fury_banner_sr_rules_close_terminal)
state_machine.init()

-----------------------------------------------------------------------------------------------
-- La ventana (rare_treasure.csb)
-----------------------------------------------------------------------------------------------
function FuryBannerSR:ctor()
	self.super:ctor()
	self.roots = {}
	self.lightList = {}
	self.lastBeginRound = 1
	self.clock = 1
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.reward.DrawRareReward")
end

function FuryBannerSR:init()
	local csbNode = csb.createNode("activity/wonderful/rare_treasure.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- OTRA APARIENCIA: el fondo tenido de morado.
	local fondo = seek(root, "Image_13")
	if fondo ~= nil then
		fondo:setColor(cc.c3b(205, 150, 255))
	end

	-- El titulo «Tesoro de Dragón» (hy_title.png) es el Image_5_0 hijo DIRECTO de root; hay otro
	-- Image_5_0 mas abajo y seekWidgetByName podia devolver ese (visto 30-sep: seguia saliendo).
	local furyTitleArt = root:getChildByName("Image_5_0")
	if furyTitleArt ~= nil then
		furyTitleArt:setVisible(false)
	end
	-- Lo de Dragon Treasure que aqui no existe: tienda, puntos, refresco.
	for _, name in ipairs({ "Button_rare_treasure_shop", "Text_integral_n", "Text_integral_t",
			"Image_20", "Text_darw_one_integral", "Text_darw_ten_integral", "Text_refresh_free",
			"Text_refresh_gem", "Image_gem", "Text_refresh_time_n", "Text_refresh_time",
			"Image_19", "Image_red",
			-- El titulo «Tesoro de Dragón» es arte (hy_title.png): encima se montaba «Estandarte SR»
			-- (visto 30-sep). Se oculta y el rotulo del pie hace de titulo.
			}) do
		hide(root, name)
	end
	for i = 1, 4 do
		local t = seek(root, "Text_rare_num_t_" .. i)
		if t ~= nil then
			t:setString("")
		end
		local n = seek(root, "Text_rare_num_" .. i)
		if n ~= nil then
			n:setString("")
		end
	end

	-- El titulo y la cuenta atras de la lista, en el rotulo del pie.
	local tip = seek(root, "Text_tip_p")
	if tip ~= nil then
		tip:setString(text(1))
		tip:setFontSize(34)
		tip:enableOutline(cc.c4b(90, 20, 90, 255), 3)
		tip:setColor(cc.c3b(255, 220, 90))
		tip:setVisible(true)
		self.weekLabel = ccui.Text:create("", tip:getFontName(), 18)
		local x, y = tip:getPosition()
		self.weekLabel:setPosition(cc.p(x, y - 64))
		tip:getParent():addChild(self.weekLabel)
	end

	-- El boton de refresco pasa a ser «Elegir SR».
	local chooseButton = seek(root, "Button_refresh_reward")
	if chooseButton ~= nil then
		local label = chooseButton:getChildByName("Text_1")
		if label ~= nil then
			label:setString(text(2))
			label:setPositionX(chooseButton:getContentSize().width / 2)
			fitWidth(label, chooseButton:getContentSize().width - 10)
		end
		fwin:addTouchEventListener(chooseButton, nil,
		{ terminal_name = "fury_banner_sr_pick_open", terminal_state = 0, isPressedActionEnabled = true }, nil, 0)
	end

	fwin:addTouchEventListener(seek(root, "Button_adventure_back"), nil,
	{ terminal_name = "fury_banner_sr_close", terminal_state = 0, isPressedActionEnabled = true }, nil, 0)
	fwin:addTouchEventListener(seek(root, "Button_darw_one"), nil,
	{ terminal_name = "fury_banner_sr_draw", terminal_state = 0, _type = 0, isPressedActionEnabled = true }, nil, 0)
	fwin:addTouchEventListener(seek(root, "Button_darw_ten"), nil,
	{ terminal_name = "fury_banner_sr_draw", terminal_state = 0, _type = 1, isPressedActionEnabled = true }, nil, 0)
	fwin:addTouchEventListener(seek(root, "Button_rare_treasure_shop_0"), nil,
	{ terminal_name = "fury_banner_sr_rules_open", terminal_state = 0, isPressedActionEnabled = true }, nil, 0)

	self.Image_treasure_xy = seek(root, "Image_treasure_xy")
	self.Image_treasure_xy:setVisible(false)
	self.Image_treasure_xy:setTouchEnabled(true)
	fwin:addTouchEventListener(self.Image_treasure_xy, nil,
	{ terminal_name = "fury_banner_sr_anim_stop", terminal_state = 0, isPressedActionEnabled = false }, nil, 0)

	self.Text_rare_time = seek(root, "Text_rare_time")
	self:buildLog(root)
	self:buildLights()
	self:onUpdateDraw()
	-- Sin SR elegido, la lista se abre sola.
	if _ED.fury_banner_sr ~= nil and _ED.fury_banner_sr.chosen == 0 then
		state_machine.excute("fury_banner_sr_pick_open", 0, nil)
	end
	return self
end

local function hideAnimation(anima)
	anima._invoke = nil
	anima:setVisible(false)
end

-- Las dieciseis luces de la ruleta (una por casilla, en orden de hueco).
function FuryBannerSR:buildLights()
	local root = self.roots[1]
	self.lightList = {}
	for i = 1, 16 do
		local panel = seek(root, "Panel_light_effect_" .. i)
		local animation = sp.spine("images/ui/effice/effect_jlmba/effect_jlmba.json",
			"images/ui/effice/effect_jlmba/effect_jlmba.atlas", 1, 0, "animation1", false, nil)
		animation.animationNameList = { "animation1", "animation2", "animation3" }
		sp.initArmature(animation, false)
		-- initArmature deja `_invoke = deleteEffect`: al acabar su primera pasada la luz se
		-- borraba sola y la tirada reventaba en clearRound («invalid cobj», pantalla bloqueada,
		-- visto 30-sep). TreasureWindow pone el mismo _invoke que aqui.
		animation._invoke = hideAnimation
		animation:setPosition(cc.p(panel:getContentSize().width / 2, panel:getContentSize().height / 2))
		panel:addChild(animation)
		animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
		animation:setVisible(false)
		panel.animation = animation
		panel.index = i
		panel:setVisible(true)
		self.lightList[i] = panel
	end
end

function FuryBannerSR:onUpdateDraw()
	local root = self.roots[1]
	local b = _ED.fury_banner_sr
	if root == nil or b == nil then
		return
	end
	self:drawBoard(b)
	self:drawRare(b)
	self:drawCosts(b)
	self:drawLog(b)
end

-----------------------------------------------------------------------------------------------
-- El registro de premios destacados (Victor, 30-sep): la seccion de Dragon Treasure
-- (Panel_get_infor_show + rare_treasure_infor_show.csb), con las ultimas casillas de fragmentos
-- SR que sacaron los jugadores del servidor; vacio, una linea que lo dice.
-----------------------------------------------------------------------------------------------
function FuryBannerSR:buildLog(root)
	local panel = seek(root, "Panel_get_infor_show")
	if panel == nil then
		return
	end
	local node = csb.createNode("activity/wonderful/rare_treasure_infor_show.csb")
	local logRoot = node:getChildByName("root")
	panel:addChild(node)
	panel:setVisible(true)
	self.logList = seek(logRoot, "ListView_get_infor")
	self.logBg = seek(logRoot, "Image_30_0_0")
	self.logArrow = seek(logRoot, "Button_get_infor_arrow")
	if self.logList == nil or self.logBg == nil or self.logArrow == nil then
		self.logList = nil
		return
	end
	self.logList:setTouchEnabled(true)
	self.logHeight = self.logList:getContentSize().height
	self.logBig = false
	fwin:addTouchEventListener(self.logArrow, nil,
	{ terminal_name = "fury_banner_sr_log_toggle", terminal_state = 0, isPressedActionEnabled = true }, nil, 0)
	self:sizeLog()
end

function FuryBannerSR:sizeLog()
	if self.logList == nil then
		return
	end
	local lines = self.logBig and 8 or 1
	local h = self.logHeight * lines
	self.logBg:setContentSize(cc.size(self.logBg:getContentSize().width, h + 10))
	self.logList:setContentSize(cc.size(self.logList:getContentSize().width, h))
	self.logArrow:runAction(cc.RotateTo:create(0.1, self.logBig and 180 or 0))
	local top = self.logBg:getPositionY() + self.logBg:getContentSize().height
	self.logArrow:setPositionY(top - self.logArrow:getContentSize().height / 2)
	self.logList:requestRefreshView()
	self.logList:jumpToTop()
end

function FuryBannerSR:drawLog(b)
	local list = self.logList
	if list == nil then
		return
	end
	list:removeAllItems()
	local width = list:getContentSize().width
	local function line(str, color)
		local t = ccui.Text:create(str, "", 18)
		t:setColor(color)
		local w = t:getVirtualRendererSize().width
		if w > width - 10 then
			t:setScale((width - 10) / w)
		end
		local item = ccui.Layout:create()
		item:setContentSize(cc.size(width, math.max(self.logHeight, 22)))
		t:setAnchorPoint(cc.p(0, 0.5))
		t:setPosition(cc.p(5, item:getContentSize().height / 2))
		item:addChild(t)
		list:pushBackCustomItem(item)
	end
	if #(b.log or {}) == 0 then
		line(text(16), cc.c3b(189, 206, 224))
	end
	for _, e in ipairs(b.log or {}) do
		line(string.format(text(15), e.name, itemName(e.type, e.mould), e.count), cc.c3b(255, 220, 90))
	end
	list:requestRefreshView()
	list:jumpToTop()
end

function FuryBannerSR:drawBoard(b)
	local root = self.roots[1]
	for _, c in ipairs(b.board) do
		local panel = seek(root, "Panel_treasure_icon_" .. c.slot)
		if panel ~= nil then
			-- Solo se quita lo que pinto esta funcion: removeAllChildren se llevaba tambien la luz
			-- de la ruleta (Panel_light_effect_N cuelga de la casilla) y la tirada reventaba en
			-- clearRound con «invalid cobj», dejando la pantalla bloqueada (visto 30-sep).
			if panel._fury_cell ~= nil then
				panel._fury_cell:removeFromParent(true)
				panel._fury_cell = nil
			end
			if c.sr and c.mould == 0 then
				-- Sin SR elegido: un «?» que abre la lista.
				local ask = ccui.Button:create("images/ui/button/icon_wenhao.png", "images/ui/button/icon_wenhao.png")
				ask:setPosition(cc.p(panel:getContentSize().width / 2, panel:getContentSize().height / 2))
				panel:addChild(ask)
				panel._fury_cell = ask
				fwin:addTouchEventListener(ask, nil,
				{ terminal_name = "fury_banner_sr_pick_open", terminal_state = 0, isPressedActionEnabled = true }, nil, 0)
			else
				local cell = ResourcesIconCell:createCell()
				cell:init(c.type, c.count, c.mould, nil, nil, true, true, 1)
				panel:addChild(cell)
				panel._fury_cell = cell
				-- Brillan las casillas raras: las del SR y la de 2 monedas premium (3396,
				-- migracion 2031).
				if c.sr or (c.type == 6 and c.mould == 3396) then
					local glow = sp.spine("images/ui/effice/effect_xiyou/effect_xiyou.json",
						"images/ui/effice/effect_xiyou/effect_xiyou.atlas", 1, 0, "animation", false, nil)
					glow.animationNameList = { "animation" }
					sp.initArmature(glow, false)
					glow._invoke = hideAnimation
					glow:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
					glow:setPosition(cc.p(cell:getContentSize().width / 2, cell:getContentSize().height / 2))
					cell:addChild(glow)
				end
			end
		end
	end
end

-- El panel de la derecha: el nombre del SR elegido y sus cuatro premios de
-- fragmentos, de mayor a menor. Sin SR elegido, vacio.
function FuryBannerSR:drawRare(b)
	local root = self.roots[1]
	local sr = {}
	for _, c in ipairs(b.board) do
		if c.sr then
			sr[#sr + 1] = c
		end
	end
	table.sort(sr, function(x, y) return x.count > y.count end)
	for i = 1, 4 do
		local panel = seek(root, "Panel_rare_props_icon_" .. i)
		local name = seek(root, "Text_rare_name_" .. i)
		if panel ~= nil then
			panel:removeAllChildren(true)
		end
		if name ~= nil then
			name:setString("")
		end
		local c = sr[i]
		if c ~= nil and panel ~= nil and b.chosen > 0 then
			local cell = ResourcesIconCell:createCell()
			cell:init(c.type, c.count, c.mould, nil, nil, true, true, 1)
			panel:addChild(cell)
			if name ~= nil then
				name:setString(itemName(c.type, c.mould))
				fitWidth(name, 140)
			end
		end
	end
	local header = seek(root, "Text_2")
	if header ~= nil then
		header:setScale(1)
		if b.chosen > 0 then
			header:setString(itemName(13, b.chosen))
		else
			header:setString(text(3))
		end
		fitWidth(header, 150)
	end
end

-- Los costes, igual que TreasureWindow:onUpdateDraw (gratis, ficha o gemas).
function FuryBannerSR:drawCosts(b)
	local root = self.roots[1]
	local num = tonumber(b.prop > 0 and getPropAllCountByMouldId(b.prop) or 0) or 0
	seek(root, "Text_darw_free_time_n"):setString(b.free .. "/" .. b.maxFree)
	seek(root, "Image_red_1"):setVisible(b.free > 0)
	local free = b.free > 0
	seek(root, "Image_free_one"):setVisible(free)
	seek(root, "Image_10"):setVisible(not free)
	local oneN = seek(root, "Text_darw_one_gem_n")
	oneN:setVisible(not free)
	seek(root, "Image_darw_one_gem"):setVisible(not free and num < 1)
	seek(root, "Image_darw_one_props"):setVisible(not free and num >= 1)
	if num >= 1 then
		oneN:setString(num .. "/" .. 1)
	else
		oneN:setString(tostring(b.gems))
	end
	local tenN = seek(root, "Text_darw_ten_gem_n")
	seek(root, "Image_darw_ten_gem"):setVisible(num < 10)
	seek(root, "Image_darw_ten_props"):setVisible(num >= 10)
	if num >= 10 then
		tenN:setString(num .. "/" .. 10)
	else
		tenN:setString(tostring(b.gems * 10))
	end
	local gem = seek(root, "Text_gem_n")
	if gem ~= nil then
		local gold = tonumber(_ED.user_info.user_gold) or 0
		if gold > 1000000 then
			gem:setString(math.floor(gold / 1000) .. string_equiprety_name[40])
		else
			gem:setString(tostring(gold))
		end
	end
end

function FuryBannerSR:onUpdate(dt)
	self.clock = self.clock + dt
	if self.clock < 1 then
		return
	end
	self.clock = 0
	local b = _ED.fury_banner_sr
	if self.weekLabel ~= nil and b ~= nil then
		self.weekLabel:setString(string.format(text(8), formatTime(b.weekLeft - (os.time() - b.receivedAt))))
	end
	local activity = _ED.active_activity ~= nil and _ED.active_activity[TYPE] or nil
	if self.Text_rare_time ~= nil and activity ~= nil and activity.end_time ~= nil then
		local left = (tonumber(activity.end_time) or 0) / 1000 - (os.time() + (_ED.time_add_or_sub or 0))
		self.Text_rare_time:setString(left < 0 and _string_piece_info[305] or formatTime(left))
	end
end

-- LA ANIMACION, la de TreasureWindow (playOneRound/playTenRound/playRound)
-- con el hueco de la casilla como indice directo de la luz.
function FuryBannerSR:clearRound()
	for _, item in ipairs(self.lightList) do
		item.animation:setVisible(false)
		item.animation._invoke = nil
		item:stopAllActions()
	end
end

function FuryBannerSR:finishRound()
	self:clearRound()
	self.Image_treasure_xy:setVisible(false)
	if self.rewardPending then
		self.rewardPending = false
		local getRewardWnd = DrawRareReward:new()
		getRewardWnd:init(7)
		fwin:open(getRewardWnd, fwin._ui)
	end
	state_machine.unlock("fury_banner_sr_draw", 0, "")
end

function FuryBannerSR:playOneRound()
	local b = _ED.fury_banner_sr
	self:clearRound()
	self.rewardPending = true
	local total = #self.lightList
	local rewardIndex = b.hits[1] or 1
	local num = total * 2 + rewardIndex
	local allTime = 0
	for i = self.lastBeginRound, num do
		local index = i % total == 0 and total or i % total
		local curNode = self.lightList[index]
		local time = ((i > self.lastBeginRound and i <= self.lastBeginRound + 4) or i >= num - 4) and 0.2 or 0.05
		allTime = allTime + time
		curNode:runAction(cc.Sequence:create(cc.DelayTime:create(allTime), cc.CallFunc:create(function ()
			curNode.animation:setVisible(true)
			if i == num then
				self.lastBeginRound = rewardIndex
				curNode.animation._invoke = function(anim1)
					anim1._invoke = nil
					self:finishRound()
				end
				csb.animationChangeToAction(curNode.animation, 2, 2, false)
			else
				curNode.animation._invoke = function(anima)
					anima:setVisible(false)
					anima._invoke = nil
				end
				csb.animationChangeToAction(curNode.animation, 1, 1, false)
			end
		end)))
	end
end

function FuryBannerSR:playTenRound()
	local b = _ED.fury_banner_sr
	self:clearRound()
	self.rewardPending = true
	-- Vueltas: cada vuelta enciende casillas distintas en orden, como el 148.
	local allRoundIds = { {} }
	local count = 1
	for _, v in ipairs(b.hits) do
		if table.containValue(allRoundIds[count], v) then
			table.sort(allRoundIds[count], function(x, y) return x < y end)
			count = count + 1
			allRoundIds[count] = {}
		end
		table.insert(allRoundIds[count], v)
	end
	table.insert(allRoundIds, 1, {})
	self.allRoundIds = allRoundIds
	self.lastBeginRound = b.hits[#b.hits] or 1
	self:playRound(1, 1)
end

function FuryBannerSR:playRound(round, index)
	local total = #self.lightList
	local curNode = self.lightList[index]
	local curRound = self.allRoundIds[round]
	local isHit = table.containValue(curRound, index)
	local isLast = round == #self.allRoundIds and index == curRound[#curRound]
	curNode.animation:setVisible(true)
	if isHit then
		curNode.animation._invoke = function(anim1)
			anim1._invoke = nil
			anim1:setVisible(false)
			if isLast then
				self:finishRound()
			end
		end
		csb.animationChangeToAction(curNode.animation, 2, 2, false)
	else
		curNode.animation._invoke = function(anima)
			anima._invoke = nil
			anima:setVisible(false)
		end
		csb.animationChangeToAction(curNode.animation, 1, 1, false)
	end
	if not isLast then
		curNode:runAction(cc.Sequence:create(cc.DelayTime:create(isHit and 1 or 0.01), cc.CallFunc:create(function ()
			if index < total then
				self:playRound(round, index + 1)
			elseif round < #self.allRoundIds then
				self:playRound(round + 1, 1)
			end
		end)))
	end
end

function FuryBannerSR:onExit()
	state_machine.unlock("fury_banner_sr_draw", 0, "")
end

-----------------------------------------------------------------------------------------------
-- Elegir el SR (sm_limited_time_equip_box_help.csb)
-----------------------------------------------------------------------------------------------
FuryBannerSRPick = class("FuryBannerSRPickClass", Window)

function FuryBannerSRPick:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryBannerSRPick:init()
	self:setTouchEnabled(true)
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)
	seek(root, "Text_title"):setString(text(5))
	fwin:addTouchEventListener(seek(root, "Button_closed"), nil,
	{ terminal_name = "fury_banner_sr_pick_close", terminal_state = 0, touch_black = true }, nil, 3)
	self:onUpdateDraw()
	return self
end

function FuryBannerSRPick:onUpdateDraw()
	local root = self.roots[1]
	local b = _ED.fury_banner_sr
	if root == nil or b == nil then
		return
	end
	local listView = seek(root, "ListView_xsbx_rule")
	local fontName = seek(root, "Text_title"):getFontName()
	listView:removeAllItems()
	local width = listView:getContentSize().width
	for _, ship in ipairs(b.heroes) do
		local row = ccui.Layout:create()
		row:setContentSize(cc.size(width, 110))
		local icon = ResourcesIconCell:createCell()
		icon:init(13, 1, ship, nil, nil, true, false, 1)
		icon:setScale(0.75)
		icon:setPosition(cc.p(10, 10))
		row:addChild(icon)
		local name = ccui.Text:create(itemName(13, ship), fontName, 24)
		name:setAnchorPoint(cc.p(0, 0.5))
		name:setPosition(cc.p(110, 55))
		row:addChild(name)
		fitWidth(name, width - 280)
		local button = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
		button:setTitleFontName(fontName)
		button:setTitleFontSize(22)
		button:setTitleColor(cc.c3b(90, 45, 10))
		button:setPosition(cc.p(width - 80, 55))
		row:addChild(button)
		if ship == b.chosen then
			button:setTitleText(text(6))
			fwin:fitButtonTitle(button)
			button:setBright(false)
			button:setTouchEnabled(false)
		else
			button:setTitleText(text(7))
			fwin:fitButtonTitle(button)
			fwin:addTouchEventListener(button, nil,
			{ terminal_name = "fury_banner_sr_choose", terminal_state = 0, isPressedActionEnabled = true, ship = ship }, nil, 0)
		end
		listView:addChild(row)
	end
	listView:requestRefreshView()
end

function FuryBannerSRPick:onExit()
end

-----------------------------------------------------------------------------------------------
-- Las reglas (utils/common_popup_rule.csb, textos 10..14)
-----------------------------------------------------------------------------------------------
FuryBannerSRRules = class("FuryBannerSRRulesClass", Window)

function FuryBannerSRRules:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryBannerSRRules:init()
	self:setTouchEnabled(true)
	local csbNode = csb.createNode("utils/common_popup_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	local title = seek(root, "Text_tittle")
	if title ~= nil then
		title:setString(text(9))
	end
	local body = seek(root, "Text_1")
	if body ~= nil then
		local lines = {}
		for i = 10, 14 do
			lines[#lines + 1] = text(i)
		end
		body:setString(table.concat(lines, "\n"))
	end
	fwin:addTouchEventListener(seek(root, "Button_close"), nil,
	{ terminal_name = "fury_banner_sr_rules_close", terminal_state = 0, isPressedActionEnabled = true }, nil, 0)
	return self
end

function FuryBannerSRRules:onExit()
end

-----------------------------------------------------------------------------------------------
-- EL ICONO DE LA CIUDAD (Home.lua; solo con el evento 29040 anunciado).
-----------------------------------------------------------------------------------------------
FuryBannerSRCell = class("FuryBannerSRCellClass", Window)

function FuryBannerSRCell:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryBannerSRCell:init()
	local csbCell = csb.createNode("activity/icon/activity_shizishou.csb")
	local root = csbCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	self:setContentSize(root:getContentSize())
	local button = seek(root, "Button_act_but")
	local art = "images/ui/text/sm_hd/zc_icon_fury_banner_sr.png"
	button:loadTextures(art, art, art)
	local label = fwin:furyCityIconCaption(root)
	if label ~= nil then
		label:setString(text(1))
		label:setVisible(true)
		fitWidth(label, 74)
	end
	fwin:furyCityIconLabel(label)
	local timer = seek(root, "Text_login_gift_p")
	if timer ~= nil then
		timer:setString("")
	end
	fwin:addTouchEventListener(button, nil,
	{ terminal_name = "fury_banner_sr_open", terminal_state = 0, isPressedActionEnabled = true }, nil, 0)
end

function FuryBannerSRCell:createCell()
	local cell = FuryBannerSRCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function FuryBannerSRCell:onExit()
end
