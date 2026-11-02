-----------------------------------------------------------------------------------------------
-- LAS CRONICAS (Fury, sistema G, 29-sep-2026; docs/systems/cronicas.md).
--
-- Como el «Ninja Treasure» de Dimension Trek: la CRONICA GLOBAL da vida, ataque y defensa a
-- TODOS los guerreros y la CRONICA DE CADA GUERRERO solo a ese guerrero. Se suben con
-- «Paginas de cronica» (objeto 3530, icono props_8400.png).
--
-- Entradas:
--   * icono de la ciudad «Cronicas» (Home.lua, activity_type 29080): la ventana entera
--     (global + todos los guerreros);
--   * boton «Cronicas» del marco del heroe (FuryHeroExtras.lua, terminal fury_chronicle_open
--     con { ship = ... }): la global + la de ESE guerrero;
--   * desde cualquier sitio: FuryChronicle_open(shipId o nil).
--
-- Ventana hecha SOLO con maquetas y arte del paquete (como Suscripciones y el Rango):
--   ventana: activity/wonderful/sm_limited_time_equip_box_help.csb (Text_title,
--            ListView_xsbx_rule, Button_closed); filas ccui.Layout/ccui.Text;
--   boton:   images/ui/button/btn_1.png; «?»: images/ui/button/icon_wenhao.png y la ventana
--            de reglas utils/common_popup_rule.csb (Text_tittle, Text_1, Button_close);
--   icono de la ciudad: activity/icon/activity_shizishou.csb con zc_icon_fury_chron.png.
-- Textos: `_fury_chronicle_text` de TipStringInfo.lua (12 idiomas).
--
-- PROTOCOLO (comandos PROPIOS, fury_legacy_chronicle.erl), por el transporte de siempre:
--   C2S 29080 fury_chronicle_view  rol
--   C2S 29081 fury_chronicle_up    rol, cronica (0 = la global, si no el id del guerrero)
--   S2C 29089 molde de las paginas, paginas que tiene, la pista global y n + la pista de
--             cada guerrero. Pista: id, [guerrero: su molde], nivel, tope, coste del
--             siguiente (0 = tope), vida/ataque/defensa de ahora y del siguiente.
--   La respuesta lleva ademas el S2C 32 de las paginas (pone al dia la mochila) y, al subir,
--   el guerrero recalculado (S2C 44/181/128) y lo gastado (S2C 37).
-- El servidor manda: coste, tope y atributos salen de su tabla; aqui solo se dice QUE cronica.
-----------------------------------------------------------------------------------------------
FuryChronicle = class("FuryChronicleClass", Window)

local VIEW_CODE, UP_CODE, PARSER_CODE = 29080, 29081, 29089
local ICON = "images/ui/props/props_8400.png"

local function text(i)
	return _fury_chronicle_text ~= nil and _fury_chronicle_text[i] or ""
end

local function chronicle_command(key)
	return function(str)
		local item = protocol_command[key]
		return str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
	end
end

local function parse_track(list, isHero)
	local t = {}
	t.id = tonumber(npos(list)) or 0
	if isHero then
		t.mould = tonumber(npos(list)) or 0
	end
	for _, k in ipairs({ "level", "max", "cost", "hp", "atk", "def", "nhp", "natk", "ndef" }) do
		t[k] = tonumber(npos(list)) or 0
	end
	return t
end

local function parse_fury_chronicle(interpreter, datas, pos, strDatas, list, count)
	local v = { heroes = {} }
	v.item = tonumber(npos(list)) or 0
	v.owned = tonumber(npos(list)) or 0
	v.global = parse_track(list, false)
	local n = tonumber(npos(list)) or 0
	for i = 1, n do
		v.heroes[#v.heroes + 1] = parse_track(list, true)
	end
	_ED.fury_chronicle = v
end

-- Da de alta (o vuelve a dar) los dos comandos y el bloque. Idempotente.
function FuryChronicle_ensureProtocol()
	protocol_command.fury_chronicle_view = protocol_command.fury_chronicle_view or
		{ code = VIEW_CODE, command = "fury_chronicle_view",
		  command_fun = chronicle_command("fury_chronicle_view"), param_list = "" }
	protocol_command.fury_chronicle_up = protocol_command.fury_chronicle_up or
		{ code = UP_CODE, command = "fury_chronicle_up",
		  command_fun = chronicle_command("fury_chronicle_up"), param_list = "" }
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER_CODE, parser = "parse_fury_chronicle",
		parser_fun = parse_fury_chronicle })
end

-- Las reglas (textos 14..18), una por linea.
function FuryChronicle_rules()
	local lines = {}
	for i = 14, 18 do
		lines[#lines + 1] = text(i)
	end
	return table.concat(lines, "\n")
end

local function redraw()
	local window = fwin:find("FuryChronicleClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
end

local function requestView()
	FuryChronicle_ensureProtocol()
	local function callback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			redraw()
		end
	end
	protocol_command.fury_chronicle_view.param_list = ""
	NetworkManager:register(VIEW_CODE, nil, nil, nil, nil, callback, false, nil)
end

local function requestUp(id)
	FuryChronicle_ensureProtocol()
	local function callback(response)
		-- Un rechazo (-74/-34089/-58) ya lo pinta el cliente con su error_code.
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			TipDlg.drawTextDailog(text(12))
			redraw()
			-- El cartel de «+N poder» de los demas sistemas (el S2C 128 ya trajo el total).
			if smFightingChange ~= nil then
				pcall(smFightingChange)
			end
			-- La ficha del guerrero ya tiene el guerrero nuevo (S2C 44): se repinta su CR.
			local tab = fwin:find("SmRoleStrengthenTabClass")
			if tab ~= nil and tab.ship_id ~= nil then
				state_machine.excute("sm_role_strengthen_tab_update_ship_info", 0, { tab.ship_id })
			end
		else
			requestView()
		end
	end
	protocol_command.fury_chronicle_up.param_list = tostring(id)
	NetworkManager:register(UP_CODE, nil, nil, nil, nil, callback, false, nil)
end

-- Abre la ventana. `shipId` nil = todas las cronicas; si no, la global y la de ese guerrero.
function FuryChronicle_open(shipId)
	if fwin:find("FuryChronicleClass") ~= nil then
		return
	end
	_ED.fury_chronicle = nil
	fwin:open(FuryChronicle:new():init(shipId), fwin._ui)
	requestView()
end

local fury_chronicle_open_terminal = {
	_name = "fury_chronicle_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local ship = params ~= nil and params.ship or nil
		FuryChronicle_open(ship ~= nil and ship.ship_id or nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_chronicle_close_terminal = {
	_name = "fury_chronicle_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FuryChronicleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- «Subir»: comprueba las paginas que dijo el servidor y pide la subida.
local fury_chronicle_up_terminal = {
	_name = "fury_chronicle_up",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local v = _ED.fury_chronicle
		local t = params ~= nil and params._datas ~= nil and params._datas.track or nil
		if v == nil or t == nil or t.cost <= 0 then
			return true
		end
		if v.owned < t.cost then
			TipDlg.drawTextDailog(text(11))
			return true
		end
		requestUp(t.id)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_chronicle_help_terminal = {
	_name = "fury_chronicle_help",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("FuryChronicleRulesClass") == nil then
			fwin:open(FuryChronicleRules:new():init(), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_chronicle_rules_close_terminal = {
	_name = "fury_chronicle_rules_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FuryChronicleRulesClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fury_chronicle_open_terminal)
state_machine.add(fury_chronicle_close_terminal)
state_machine.add(fury_chronicle_up_terminal)
state_machine.add(fury_chronicle_help_terminal)
state_machine.add(fury_chronicle_rules_close_terminal)
state_machine.init()

function FuryChronicle:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryChronicle:init(shipId)
	self.ship_id = shipId ~= nil and tonumber(shipId) or nil
	self:setTouchEnabled(true)
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fury_chronicle_close",
		terminal_state = 0,
		touch_black = true,
	}, nil, 3)

	-- El «?» junto al titulo.
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
		terminal_name = "fury_chronicle_help",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self:onUpdateDraw()
	return self
end

local function label(parent, str, fontName, size, x, y, color, maxWidth)
	local t = ccui.Text:create(str, fontName, size)
	t:setAnchorPoint(cc.p(0, 0.5))
	t:setPosition(cc.p(x, y))
	if color ~= nil then
		t:setColor(color)
	end
	if maxWidth ~= nil then
		local w = t:getVirtualRendererSize().width
		if w > maxWidth then
			t:setScale(maxWidth / w)
		end
	end
	parent:addChild(t)
	return t
end

local function row(width, height)
	local r = ccui.Layout:create()
	r:setContentSize(cc.size(width, height))
	return r
end

local function heroName(mould)
	local ok, info = pcall(getItemNameAndQuality, { 13, mould, 1 })
	if ok and info ~= nil and info[1] ~= nil then
		return tostring(info[1])
	end
	return ""
end

local function pagesIcon(parent, x, y, side)
	local img = ccui.ImageView:create(ICON)
	img:setScale(side / math.max(img:getContentSize().width, 1))
	img:setPosition(cc.p(x, y))
	parent:addChild(img)
end

function FuryChronicle:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local fontName = ccui.Helper:seekWidgetByName(root, "Text_title"):getFontName()
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	listView:removeAllItems()
	local v = _ED.fury_chronicle
	if v == nil then
		return
	end
	local width = listView:getContentSize().width

	-- Cabecera: las paginas que tiene.
	local head = row(width, 70)
	pagesIcon(head, 40, 35, 56)
	label(head, string.format(text(2), v.owned), fontName, 24, 80, 35, cc.c3b(255, 220, 90))
	listView:addChild(head)

	listView:addChild(self:createTrack(v, v.global, text(3), text(4), fontName, width))
	-- Sin guerrero (entrada de Crecimiento): solo los de la formacion. Con toda la coleccion
	-- (>100 filas) la ventana tardaba en abrir; la cronica de cualquier otro guerrero esta en su
	-- ficha (Mejoras > Cronicas).
	local placed = {}
	for i = 2, 7 do
		if _ED.formetion ~= nil and _ED.formetion[i] ~= nil then
			placed[tonumber(_ED.formetion[i]) or -1] = true
		end
	end
	for _, t in ipairs(v.heroes) do
		if (self.ship_id == nil and placed[tonumber(t.id)]) or t.id == self.ship_id then
			listView:addChild(self:createTrack(v, t, heroName(t.mould), text(5), fontName, width))
		end
	end
	listView:requestRefreshView()
end

-- Una cronica: nombre, nivel, atributos de ahora y del siguiente, coste y «Subir».
function FuryChronicle:createTrack(v, t, name, subtitle, fontName, width)
	local gold, green, grey, red = cc.c3b(255, 220, 90), cc.c3b(80, 230, 80),
		cc.c3b(170, 170, 170), cc.c3b(255, 80, 80)
	local maxed = t.cost <= 0
	local r = row(width, 160)
	local textWidth = width - 230
	label(r, name, fontName, 24, 20, 140, gold, textWidth)
	label(r, subtitle, fontName, 18, 20, 112, grey, textWidth)
	label(r, string.format(text(6), t.level, t.max), fontName, 20, 20, 84, nil, textWidth)
	label(r, string.format(text(7), t.hp, t.atk, t.def), fontName, 20, 20, 56, nil, textWidth)
	if maxed then
		label(r, text(10), fontName, 20, 20, 28, grey, textWidth)
	else
		label(r, string.format(text(8), t.nhp, t.natk, t.ndef), fontName, 20, 20, 28, green,
			textWidth)
		pagesIcon(r, width - 190, 110, 44)
		label(r, v.owned .. "/" .. t.cost, fontName, 20, width - 160, 110,
			v.owned >= t.cost and green or red)
	end
	local button = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
	button:setTitleText(maxed and text(10) or text(9))
	button:setTitleFontName(fontName)
	button:setTitleFontSize(20)
	button:setTitleColor(cc.c3b(90, 45, 10))
	fwin:fitButtonTitle(button)
	button:setPosition(cc.p(width - 90, 50))
	r:addChild(button)
	if maxed then
		button:setBright(false)
		button:setTouchEnabled(false)
	else
		fwin:addTouchEventListener(button, nil,
		{
			terminal_name = "fury_chronicle_up",
			terminal_state = 0,
			isPressedActionEnabled = true,
			track = t,
		}, nil, 0)
	end
	return r
end

function FuryChronicle:onExit()
end

-----------------------------------------------------------------------------------------------
-- La ventana de reglas (el «?»): utils/common_popup_rule.csb con los textos 14..18.
-----------------------------------------------------------------------------------------------
FuryChronicleRules = class("FuryChronicleRulesClass", Window)

function FuryChronicleRules:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryChronicleRules:init()
	self:setTouchEnabled(true)
	local csbNode = csb.createNode("utils/common_popup_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	local title = ccui.Helper:seekWidgetByName(root, "Text_tittle")
	if title ~= nil then
		title:setString(text(13))
	end
	local body = ccui.Helper:seekWidgetByName(root, "Text_1")
	if body ~= nil then
		body:setString(FuryChronicle_rules())
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "fury_chronicle_rules_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	return self
end

function FuryChronicleRules:onExit()
end

-----------------------------------------------------------------------------------------------
-- EL ICONO DE LA CIUDAD (Home.lua; activity_type 29080, sin fila en activity_sorting_mould:
-- va al final).
-----------------------------------------------------------------------------------------------
FuryChronicleCell = class("FuryChronicleCellClass", Window)

function FuryChronicleCell:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryChronicleCell:init()
	local csbCell = csb.createNode("activity/icon/activity_shizishou.csb")
	local root = csbCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	self:setContentSize(root:getContentSize())

	local button = ccui.Helper:seekWidgetByName(root, "Button_act_but")
	local art = "images/ui/text/sm_hd/zc_icon_fury_chron.png"
	button:loadTextures(art, art, art)
	local caption = fwin:furyCityIconCaption(root)
	if caption ~= nil then
		caption:setString(text(1))
		caption:setVisible(true)
		local w = caption:getVirtualRendererSize().width
		if w > 74 then
			caption:setScale(74 / w)
		end
	end
	fwin:furyCityIconLabel(caption)
	local timer = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
	if timer ~= nil then
		timer:setString("")
	end
	fwin:addTouchEventListener(button, nil,
	{
		terminal_name = "fury_chronicle_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
end

function FuryChronicleCell:createCell()
	local cell = FuryChronicleCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function FuryChronicleCell:onExit()
end

-----------------------------------------------------------------------------------------------
-- LA ENTRADA EN «CRECIMIENTO» (SmCultivateWindow, 30-sep-2026: Victor la quiere ahi y no en la
-- ciudad). Una carta mas al final de ScrollView_yc, clonada de la ultima visible, con el dibujo
-- images/ui/text/TF_res/fury_cultivate_chronicle.png (la carta «Stay tuned» con el libro 8400
-- y la franja del nombre vacia) y el nombre pintado encima (12 idiomas).
-----------------------------------------------------------------------------------------------
function FuryChronicle_addCultivateCard(root)
	local scroll = ccui.Helper:seekWidgetByName(root, "ScrollView_yc")
	if scroll == nil or scroll:getChildByName("Image_fury_chronicle") ~= nil then
		return
	end
	local visible = {}
	for _, v in pairs(scroll:getChildren()) do
		if v:isVisible() then
			visible[#visible + 1] = v
		end
	end
	if #visible == 0 then
		return
	end
	table.sort(visible, function(a, b) return a:getPositionX() < b:getPositionX() end)
	local last = visible[#visible]
	local first = visible[1]
	local firstX = first:getPositionX()
	local card = last:clone()
	card:setName("Image_fury_chronicle")
	card:loadTexture("images/ui/text/TF_res/fury_cultivate_chronicle.png")
	for _, child in pairs(card:getChildren()) do
		child:setVisible(false)
	end
	-- Victor, 30-sep: la Cronica es la PRIMERA y NINGUNA otra se quita: todas se corren un hueco
	-- a la derecha y la lista se alarga (la version anterior la ponia ENCIMA de Talento).
	local step = #visible > 1 and (visible[2]:getPositionX() - firstX) or last:getContentSize().width
	for i = 1, #visible do
		visible[i]:setPositionX(visible[i]:getPositionX() + step)
	end
	card:setPositionX(firstX)
	scroll:addChild(card)
	local size = card:getContentSize()
	local title = ccui.Text:create(text(1), "fonts/FZYiHei-M20S.ttf", 44)
	title:setTextColor(cc.c4b(255, 214, 64, 255))
	title:enableOutline(cc.c4b(70, 25, 0, 255), 3)
	title:setPosition(cc.p(size.width / 2, size.height * 0.165))
	local w = title:getVirtualRendererSize().width
	if w > size.width - 90 then
		title:setScale((size.width - 90) / w)
	end
	card:addChild(title)
	card:setTouchEnabled(true)
	card:addTouchEventListener(function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if (tonumber(_ED.user_info and _ED.user_info.user_grade) or 0) < 25 then
				TipDlg.drawTextDailog(string.format(_new_interface_text[144], 25))
				return
			end
			FuryChronicle_open(nil)
		end
	end)
	local inner = scroll:getInnerContainerSize()
	local need = last:getPositionX() + size.width * (1 - last:getAnchorPoint().x) + 40
	if need > inner.width then
		scroll:setInnerContainerSize(cc.size(need, inner.height))
	end
end
