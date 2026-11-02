-----------------------------------------------------------------------------------------------
-- PROHIBIDORES (Fury, sistema I, 29-sep-2026; docs/systems/prohibidores.md).
--
-- Encargo de Victor: «un nuevo sistema prohibidor que da atributos extras a los heroes pero ahi
-- mismo se invocan con diamantes»; 68 diamantes 1 tirada, 680 diez. Modelo de «禁器» de
-- Dimension Trek: cada prohibidor ACTIVADO da sus atributos a TODOS los heroes (global).
--
-- Ventana nueva hecha SOLO con maquetas y arte que ya trae el cliente (como la tienda de
-- suscripciones): activity/wonderful/sm_limited_time_equip_box_help.csb (titulo, lista, X),
-- fila activity/wonderful/sm_limited_time_equip_box_help_list_2.csb, ResourcesIconCell,
-- boton images/ui/button/btn_1.png, «?» images/ui/button/icon_wenhao.png, reglas
-- utils/common_popup_rule.csb y ConfirmTip. Textos: `_fury_prohibitor_text` (TipStringInfo, 12
-- idiomas). Iconos y nombres: prop_mould 3570-3579.
--
-- ABRIR: app.load("client.l_digital.prohibitor.FuryProhibitor") y
--        state_machine.excute("fury_prohibitor_open", 0, nil)   (o FuryProhibitor_open()).
--
-- PROTOCOLO (comandos PROPIOS por el marco del heroe, fury_legacy_hero_extra.erl; el sobre de
-- texto de siempre; servidor fury_legacy_prohibitor.erl / prohibitor.erl, que manda en todo).
-- El heroe viaja porque el marco lo pide, pero no cambia nada (el bono es global):
--   C2S 29100 fury_prohibitor_view     rol, heroe
--   C2S 29102 fury_prohibitor_summon   rol, heroe, tiradas (1 o 10)
--   C2S 29103 fury_prohibitor_upgrade  rol, heroe, prohibidor (activar o +1 estrella)
--   C2S 29104 fury_prohibitor_convert  rol, heroe, prohibidor, copias
--   S2C 29105 la ventana; S2C 29106 lo que salio al invocar.
-----------------------------------------------------------------------------------------------
FuryProhibitor = class("FuryProhibitorClass", Window)

local VIEW_CODE, SUMMON_CODE, UPGRADE_CODE, CONVERT_CODE = 29100, 29102, 29103, 29104
local VIEW_PARSER, SUMMON_PARSER = 29105, 29106
-- El heroe de la ficha desde la que se abrio (el marco exige uno positivo).
local heroId = "1"
local QUALITY_COLOR = {
	[1] = cc.c3b(90, 170, 255), [2] = cc.c3b(200, 110, 255),
	[3] = cc.c3b(255, 170, 40), [4] = cc.c3b(255, 70, 70),
}

local function text(i)
	return _fury_prohibitor_text ~= nil and _fury_prohibitor_text[i] or ""
end

local function command(key)
	return function(str)
		local item = protocol_command[key]
		str = str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id .. "\r\n" .. heroId
		if item.param_list ~= "" then
			str = str .. "\r\n" .. item.param_list
		end
		return str
	end
end

local function num(list)
	return tonumber(npos(list)) or 0
end

local function parse_fury_prohibitor(interpreter, datas, pos, strDatas, list, count)
	local v = { rates = {}, rows = {} }
	v.tickets, v.essence, v.cost_one, v.cost_ten = num(list), num(list), num(list), num(list)
	v.hp, v.atk, v.def = num(list), num(list), num(list)
	for i = 1, num(list) do
		v.rates[#v.rates + 1] = { quality = num(list), weight = num(list) }
	end
	for i = 1, num(list) do
		local r = {}
		r.id, r.quality, r.star, r.max_star, r.copies = num(list), num(list), num(list), num(list), num(list)
		r.hp, r.atk, r.def, r.next_cost, r.essence = num(list), num(list), num(list), num(list), num(list)
		v.rows[#v.rows + 1] = r
	end
	_ED.fury_prohibitor = v
end

local function parse_fury_prohibitor_gained(interpreter, datas, pos, strDatas, list, count)
	local ids = {}
	for i = 1, num(list) do
		ids[#ids + 1] = num(list)
	end
	_ED.fury_prohibitor_gained = ids
end

-- Da de alta (o vuelve a dar) los cuatro comandos y los dos bloques. Idempotente.
function FuryProhibitor_ensureProtocol()
	for name, code in pairs({ fury_prohibitor_view = VIEW_CODE, fury_prohibitor_summon = SUMMON_CODE,
			fury_prohibitor_upgrade = UPGRADE_CODE, fury_prohibitor_convert = CONVERT_CODE }) do
		protocol_command[name] = protocol_command[name] or
			{ code = code, command = name, command_fun = command(name), param_list = "" }
	end
	local have = {}
	for _, v in pairs(protocol_parse) do
		have[v.code] = true
	end
	if not have[VIEW_PARSER] then
		table.insert(protocol_parse, { code = VIEW_PARSER, parser = "parse_fury_prohibitor",
			parser_fun = parse_fury_prohibitor })
	end
	if not have[SUMMON_PARSER] then
		table.insert(protocol_parse, { code = SUMMON_PARSER, parser = "parse_fury_prohibitor_gained",
			parser_fun = parse_fury_prohibitor_gained })
	end
end

local function itemName(id)
	local ok, info = pcall(getItemNameAndQuality, { 6, id, 1 })
	if ok and info ~= nil and info[1] ~= nil then
		return tostring(info[1])
	end
	return ""
end

local function redraw()
	local window = fwin:find("FuryProhibitorClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
end

-- Todas contestan con la ventana entera; un rechazo lo pinta el cliente con su error_code
-- (-16 abre la recarga, -74 «no tienes suficientes») y se vuelve a pedir la vista.
local function send(key, code, params, onOk)
	FuryProhibitor_ensureProtocol()
	local function callback(response)
		if key == "fury_prohibitor_upgrade" then
			-- Ya se leyeron los S2C 44/181 de TODOS los heroes (bono global, 30-sep): se
			-- vuelven a encender los avisos por heroe del 44 (ver el terminal de mejorar).
			_ED.changeHeroStart = false
		end
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if onOk ~= nil then
				onOk()
			end
			redraw()
			-- Cartel de «+N poder» como los demas sistemas (si el total subio).
			if smFightingChange ~= nil then
				pcall(smFightingChange)
			end
		elseif key ~= "fury_prohibitor_view" then
			send("fury_prohibitor_view", VIEW_CODE, "", nil)
		end
	end
	protocol_command[key].param_list = params
	NetworkManager:register(code, nil, nil, nil, nil, callback, false, nil)
end

function FuryProhibitor_open()
	if fwin:find("FuryProhibitorClass") == nil then
		_ED.changeHeroStart = false
		_ED.fury_prohibitor = nil
		fwin:open(FuryProhibitor:new():init(), fwin._ui)
		send("fury_prohibitor_view", VIEW_CODE, "", nil)
	end
end

local function terminal(name, invoke)
	state_machine.add({
		_name = name,
		_init = function(terminal) end,
		_inited = false,
		_instance = self,
		_state = 0,
		_invoke = function(terminal, instance, params)
			invoke(params)
			return true
		end,
		_terminal = nil,
		_terminals = nil
	})
end

terminal("fury_prohibitor_open", function(params)
	local ship = params ~= nil and params.ship or nil
	if ship ~= nil and tonumber(ship.ship_id) ~= nil and tonumber(ship.ship_id) > 0 then
		heroId = tostring(ship.ship_id)
	end
	FuryProhibitor_open()
end)
terminal("fury_prohibitor_close", function(params) fwin:close(fwin:find("FuryProhibitorClass")) end)
terminal("fury_prohibitor_summon", function(params)
	local n = params._datas.count
	send("fury_prohibitor_summon", SUMMON_CODE, tostring(n), function()
		-- La ventana de premio con iconos y nombres (el servidor manda el S2C 171 tipo 7 con lo
		-- que salio), como las demas invocaciones (Victor, 30-sep).
		if #(_ED.fury_prohibitor_gained or {}) > 0 then
			app.load("client.reward.DrawRareReward")
			local getRewardWnd = DrawRareReward:new()
			getRewardWnd:init(7)
			fwin:open(getRewardWnd, fwin._ui)
		end
	end)
end)
terminal("fury_prohibitor_upgrade", function(params)
	-- Activar o subir estrella cambia los atributos de TODOS los heroes: el servidor manda el
	-- S2C 44 y el 181 de cada uno (y el 128). Con la coleccion entera (>100 heroes) los avisos
	-- por heroe del 44 congelaban la pantalla (cronica global, 30-sep); `changeHeroStart` los
	-- salta, como hace la formacion al cambiar de heroe (FormationTigerGate.lua:700).
	_ED.changeHeroStart = true
	send("fury_prohibitor_upgrade", UPGRADE_CODE, tostring(params._datas.id), function()
		-- La ficha abierta se repinta con los atributos y el CR nuevos.
		local tab = fwin:find("SmRoleStrengthenTabClass")
		if tab ~= nil then
			state_machine.excute("sm_role_strengthen_tab_update_ship_info", 0, { tab.ship_id or heroId })
		end
	end)
end)
terminal("fury_prohibitor_convert", function(params)
	local r = params._datas.row
	state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, {
		terminal_name = "fury_prohibitor_convert_confirmed",
		terminal_state = 0,
		_msg = string.format(text(21), r.copies, r.copies * r.essence),
		_datas = { id = r.id, copies = r.copies },
	})
end)
terminal("fury_prohibitor_convert_confirmed", function(params)
	if params ~= nil and params.status == 1 and params._datas ~= nil then
		send("fury_prohibitor_convert", CONVERT_CODE,
			params._datas.id .. "\r\n" .. params._datas.copies, nil)
	end
end)
terminal("fury_prohibitor_help", function(params)
	if fwin:find("FuryProhibitorRulesClass") == nil then
		fwin:open(FuryProhibitorRules:new():init(), fwin._ui)
	end
end)
terminal("fury_prohibitor_rules_close", function(params)
	fwin:close(fwin:find("FuryProhibitorRulesClass"))
end)
state_machine.init()

function FuryProhibitor:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.utils.ConfirmTip")
end

function FuryProhibitor:init()
	self:setTouchEnabled(true)
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
		{ terminal_name = "fury_prohibitor_close", terminal_state = 0, touch_black = true }, nil, 3)
	local title = ccui.Helper:seekWidgetByName(root, "Text_title")
	title:setString(text(1))
	local help = ccui.Button:create("images/ui/button/icon_wenhao.png", "images/ui/button/icon_wenhao.png")
	local tx, ty = title:getPosition()
	local tw = title:getContentSize().width * title:getScaleX()
	help:setPosition(cc.p(tx + tw * (1 - title:getAnchorPoint().x) + 40, ty))
	title:getParent():addChild(help)
	fwin:addTouchEventListener(help, nil,
		{ terminal_name = "fury_prohibitor_help", terminal_state = 0, isPressedActionEnabled = true }, nil, 0)
	self:onUpdateDraw()
	return self
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
		local w = l:getVirtualRendererSize().width
		if w > width then
			l:setScale(width / w)
		end
	end
	return l
end

local function button(parent, str, fontName, x, y, terminalName, datas, enabled)
	local b = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
	b:setTitleText(str)
	b:setTitleFontName(fontName)
	b:setTitleFontSize(18)
	b:setTitleColor(cc.c3b(90, 45, 10))
	fwin:fitButtonTitle(b)
	b:setPosition(cc.p(x, y))
	parent:addChild(b)
	if enabled then
		local conf = { terminal_name = terminalName, terminal_state = 0, isPressedActionEnabled = true }
		for k, v in pairs(datas or {}) do
			conf[k] = v
		end
		fwin:addTouchEventListener(b, nil, conf, nil, 0)
	else
		b:setBright(false)
		b:setTouchEnabled(false)
	end
	return b
end

function FuryProhibitor:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local fontName = ccui.Helper:seekWidgetByName(root, "Text_title"):getFontName()
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	listView:removeAllItems()
	local v = _ED.fury_prohibitor
	if v == nil then
		return
	end
	listView:addChild(self:createHeader(v, fontName, listView:getContentSize().width))
	for _, r in ipairs(v.rows) do
		listView:addChild(self:createRow(r, fontName))
	end
	listView:requestRefreshView()
end

-- Billetes y esencia, el total que suman a TODOS los heroes y los dos botones de invocar.
function FuryProhibitor:createHeader(v, fontName, width)
	local row = ccui.Layout:create()
	row:setContentSize(cc.size(width, 150))
	label(row, string.format(text(5), v.tickets, v.essence), fontName, 22, 20, 128, cc.c3b(255, 220, 90), width - 40)
	label(row, string.format(text(6), v.hp, v.atk, v.def), fontName, 20, 20, 94, cc.c3b(80, 230, 80), width - 40)
	for i, n in ipairs({ 1, 10 }) do
		local price = v.tickets >= n and string.format(text(4), n)
			or string.format(text(3), n == 1 and v.cost_one or v.cost_ten)
		local x = width / 2 + (i == 1 and -130 or 130)
		button(row, string.format(text(2), n), fontName, x, 50, "fury_prohibitor_summon",
			{ count = n }, true)
		local p = label(row, price, fontName, 18, x, 14, cc.c3b(255, 255, 255))
		p:setAnchorPoint(cc.p(0.5, 0.5))
	end
	return row
end

function FuryProhibitor:createRow(r, fontName)
	local csbRow = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help_list_2.csb")
	local root = csbRow:getChildByName("root")
	root:removeFromParent(false)
	local size = root:getContentSize()
	local icon = ResourcesIconCell:createCell()
	icon:init(6, r.copies, r.id, nil, nil, true, true, 1)
	icon:setScale(0.7)
	icon:setPosition(cc.p(14, 20))
	root:addChild(icon)

	local textX, textWidth = 100, 250
	local name = ccui.Helper:seekWidgetByName(root, "Text_ranking")
	name:setString(itemName(r.id) .. " (" .. text(21 + r.quality) .. ")")
	name:setAnchorPoint(cc.p(0, 0.5))
	name:setPosition(cc.p(textX, 90))
	name:setColor(QUALITY_COLOR[r.quality] or cc.c3b(255, 255, 255))
	local w = name:getVirtualRendererSize().width
	if w > textWidth then
		name:setScale(textWidth / w)
	end
	local status = fwin:furyRowStatus(root)
	status:setFontSize(18)
	status:setAnchorPoint(cc.p(0, 0.5))
	status:setPosition(cc.p(textX, 60))
	if r.star < 0 then
		status:setString(text(7) .. "   " .. string.format(text(9), r.copies))
		status:setColor(cc.c3b(160, 160, 160))
	else
		status:setString(string.format(text(8), r.star, r.max_star) .. "   " .. string.format(text(9), r.copies))
		status:setColor(cc.c3b(255, 220, 90))
	end
	label(root, string.format(text(26), r.hp, r.atk, r.def), fontName, 18, textX, 30, cc.c3b(80, 230, 80), textWidth)
	local rewards = ccui.Helper:seekWidgetByName(root, "ListView_ranking_reward_2")
	if rewards ~= nil then
		rewards:setVisible(false)
	end

	-- Activar (gasta 1 copia) / Mejorar (esencia) / tope; y convertir los repetidos.
	local bx = size.width - 80
	if r.star < 0 then
		button(root, text(10), fontName, bx, size.height / 2 + 30, "fury_prohibitor_upgrade",
			{ id = r.id }, r.copies > 0)
	elseif r.star >= r.max_star then
		button(root, text(13), fontName, bx, size.height / 2 + 30, nil, nil, false)
	else
		local ess = _ED.fury_prohibitor ~= nil and _ED.fury_prohibitor.essence or 0
		button(root, string.format(text(11), r.next_cost), fontName, bx, size.height / 2 + 30,
			"fury_prohibitor_upgrade", { id = r.id }, ess >= r.next_cost)
	end
	button(root, text(12), fontName, bx, size.height / 2 - 30, "fury_prohibitor_convert",
		{ row = r }, r.star >= 0 and r.copies > 0)

	local row = ccui.Layout:create()
	row:setContentSize(size)
	row:addChild(root)
	return row
end

function FuryProhibitor:onExit()
end

-----------------------------------------------------------------------------------------------
-- Las reglas (el «?»), con las probabilidades que manda el servidor.
-----------------------------------------------------------------------------------------------
FuryProhibitorRules = class("FuryProhibitorRulesClass", Window)

function FuryProhibitor_rules()
	local lines = { text(15), text(16) }
	local v = _ED.fury_prohibitor
	local total = 0
	for _, q in ipairs(v ~= nil and v.rates or {}) do
		total = total + q.weight
	end
	for _, q in ipairs(v ~= nil and v.rates or {}) do
		if total > 0 then
			lines[#lines + 1] = string.format("   %s: %.2f%%", text(21 + q.quality), q.weight * 100 / total)
		end
	end
	lines[#lines + 1] = text(17)
	lines[#lines + 1] = text(18)
	lines[#lines + 1] = text(19)
	return table.concat(lines, "\n")
end

function FuryProhibitorRules:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryProhibitorRules:init()
	self:setTouchEnabled(true)
	local csbNode = csb.createNode("utils/common_popup_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	local title = ccui.Helper:seekWidgetByName(root, "Text_tittle")
	if title ~= nil then
		title:setString(text(14))
	end
	local body = ccui.Helper:seekWidgetByName(root, "Text_1")
	if body ~= nil then
		body:setString(FuryProhibitor_rules())
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
		{ terminal_name = "fury_prohibitor_rules_close", terminal_state = 0, isPressedActionEnabled = true }, nil, 0)
	return self
end

function FuryProhibitorRules:onExit()
end
