-----------------------------------------------------------------------------------------------
-- LAS POCIONES DEL HEROE (Fury, sistema K, 29-sep-2026; docs/systems/pociones.md).
--
-- Como partner_potion de Dimension Trek: el guerrero se toma una pocion de la
-- mochila, se gasta y le da VIDA/ATQ/DEF mientras dura (horas). Una por tipo;
-- otra del mismo tipo sustituye a la activa. El cliente original no trae
-- pantalla: esta es Lua nuevo montado SOLO con maquetas y arte del paquete
-- (las mismas que la tienda de suscripciones):
--   ventana: activity/wonderful/sm_limited_time_equip_box_help.csb
--            (Text_title, ListView_xsbx_rule, Button_closed);
--   fila:    activity/wonderful/sm_limited_time_equip_box_help_list_2.csb
--            (Text_ranking, Text_kehuode, ListView_ranking_reward_2);
--   fichas:  ResourcesIconCell, boton images/ui/button/btn_1.png, «?»
--            images/ui/button/icon_wenhao.png, reglas utils/common_popup_rule.csb,
--            confirmar ConfirmTip.
-- Textos: `_fury_potion_text` de TipStringInfo.lua (12 idiomas).
--
-- SE ABRE CON: FuryHeroPotion_open(ship_id)   (el heroe, id de instancia), o con el
-- terminal "fury_hero_potion_open" { ship = _ED.user_ship[id] }, que es lo que llama
-- el boton del marco del heroe (FuryHeroExtras.BUTTONS, sistema E).
--
-- EL PROTOCOLO: dos comandos PROPIOS por el transporte de siempre, dados de
-- alta aqui en las tablas del propio cliente cada vez que se van a usar.
--   C2S 29120 fury_potion_view  rol, heroe
--   C2S 29121 fury_potion_use   rol, heroe, molde
--   S2C 29122 heroe, n, y por pocion: molde, tipo, segundos, vida, ataque,
--             defensa, cuantas tiene; n activas y por cada una: tipo, molde,
--             segundos que le quedan (los cuenta el servidor).
-- El servidor manda (fury_legacy_hero_potion.erl / hero_potion.erl).
-----------------------------------------------------------------------------------------------
FuryHeroPotion = class("FuryHeroPotionClass", Window)

local VIEW_CODE, USE_CODE, PARSER_CODE = 29120, 29121, 29122

local function text(i)
	return _fury_potion_text ~= nil and _fury_potion_text[i] or ""
end

local function potion_command(key)
	return function(str)
		local item = protocol_command[key]
		str = str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
		return str
	end
end

local function parse_fury_potion(interpreter, datas, pos, strDatas, list, count)
	local view = { catalog = {}, active = {} }
	view.hero = tonumber(npos(list)) or 0
	local n = tonumber(npos(list)) or 0
	for i = 1, n do
		local p = {}
		p.mould = tonumber(npos(list)) or 0
		p.kind = tonumber(npos(list)) or 0
		p.seconds = tonumber(npos(list)) or 0
		p.health = tonumber(npos(list)) or 0
		p.courage = tonumber(npos(list)) or 0
		p.intellect = tonumber(npos(list)) or 0
		p.owned = tonumber(npos(list)) or 0
		view.catalog[#view.catalog + 1] = p
	end
	local m = tonumber(npos(list)) or 0
	for i = 1, m do
		local a = {}
		a.kind = tonumber(npos(list)) or 0
		a.mould = tonumber(npos(list)) or 0
		a.remaining = tonumber(npos(list)) or 0
		view.active[#view.active + 1] = a
	end
	_ED.fury_hero_potion = view
end

-- Da de alta (o vuelve a dar) los dos comandos y el bloque. Idempotente.
function FuryHeroPotion_ensureProtocol()
	protocol_command.fury_potion_view = protocol_command.fury_potion_view or
		{ code = VIEW_CODE, command = "fury_potion_view",
		  command_fun = potion_command("fury_potion_view"), param_list = "" }
	protocol_command.fury_potion_use = protocol_command.fury_potion_use or
		{ code = USE_CODE, command = "fury_potion_use",
		  command_fun = potion_command("fury_potion_use"), param_list = "" }
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER_CODE, parser = "parse_fury_potion",
		parser_fun = parse_fury_potion })
end

-- «5h 12m» con el formato del idioma (texto 20).
function FuryHeroPotion_time(seconds)
	seconds = math.max(0, math.floor(tonumber(seconds) or 0))
	return string.format(text(20), math.floor(seconds / 3600), math.floor((seconds % 3600) / 60))
end

-- «ATQ +500  VIDA +2500» (solo lo que no es cero).
function FuryHeroPotion_attrs(p)
	local parts = {}
	if (p.courage or 0) > 0 then parts[#parts + 1] = string.format(text(7), p.courage) end
	if (p.health or 0) > 0 then parts[#parts + 1] = string.format(text(8), p.health) end
	if (p.intellect or 0) > 0 then parts[#parts + 1] = string.format(text(9), p.intellect) end
	return table.concat(parts, "  ")
end

local function itemName(mould)
	local ok, info = pcall(getItemNameAndQuality, { 6, mould, 1 })
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

local function repaint()
	local window = fwin:find("FuryHeroPotionClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
end

local function requestView(heroId)
	FuryHeroPotion_ensureProtocol()
	local function callback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			repaint()
		end
	end
	protocol_command.fury_potion_view.param_list = tostring(heroId)
	NetworkManager:register(VIEW_CODE, nil, nil, nil, nil, callback, false, nil)
end

local function requestUse(heroId, mould)
	FuryHeroPotion_ensureProtocol()
	local function callback(response)
		-- Un rechazo (-74, -58...) ya lo pinta el cliente con su error_code.
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			TipDlg.drawTextDailog(text(12))
			repaint()
			-- El servidor manda el heroe recalculado (S2C 44/181/128): repintar la ficha.
			state_machine.excute("sm_role_strengthen_tab_update_ship_info", 0, { heroId })
			if smFightingChange ~= nil then
				pcall(smFightingChange)
			end
		else
			requestView(heroId)
		end
	end
	protocol_command.fury_potion_use.param_list = tostring(heroId) .. "\r\n" .. tostring(mould)
	NetworkManager:register(USE_CODE, nil, nil, nil, nil, callback, false, nil)
end

-- La entrada unica: abre la ventana de pociones de ese heroe.
function FuryHeroPotion_open(heroId)
	heroId = tonumber(heroId)
	if heroId == nil or heroId <= 0 then
		return
	end
	if fwin:find("FuryHeroPotionClass") == nil then
		_ED.fury_hero_potion = nil
		fwin:open(FuryHeroPotion:new():init(heroId), fwin._ui)
	end
	requestView(heroId)
end

local function terminal(name, fn)
	state_machine.add({
		_name = name,
		_init = function (terminal) end,
		_inited = false,
		_instance = self,
		_state = 0,
		_invoke = function(terminal, instance, params)
			fn(params)
			return true
		end,
		_terminal = nil,
		_terminals = nil
	})
end

-- El boton del marco del heroe (FuryHeroExtras.BUTTONS).
terminal("fury_hero_potion_open", function(params)
	local ship = params ~= nil and params.ship or nil
	if ship ~= nil then
		FuryHeroPotion_open(ship.ship_id)
	end
end)

terminal("fury_hero_potion_close", function(params)
	fwin:close(fwin:find("FuryHeroPotionClass"))
end)

-- «Usar»: sin ninguna, aviso; si ya hay una del mismo tipo, confirmar la sustitucion.
terminal("fury_hero_potion_use", function(params)
	local view = _ED.fury_hero_potion
	local p = params._datas.potion
	if view == nil or p == nil then
		return
	end
	if p.owned <= 0 then
		TipDlg.drawTextDailog(text(11))
		return
	end
	for _, a in ipairs(view.active) do
		if a.kind == p.kind then
			state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, {
				terminal_name = "fury_hero_potion_use_confirmed",
				terminal_state = 0,
				_msg = text(10),
				_datas = { hero = view.hero, mould = p.mould },
			})
			return
		end
	end
	requestUse(view.hero, p.mould)
end)

terminal("fury_hero_potion_use_confirmed", function(params)
	if params ~= nil and params.status == 1 and params._datas ~= nil then
		requestUse(params._datas.hero, params._datas.mould)
	end
end)

terminal("fury_hero_potion_help", function(params)
	if fwin:find("FuryHeroPotionRulesClass") == nil then
		fwin:open(FuryHeroPotionRules:new():init(), fwin._ui)
	end
end)

terminal("fury_hero_potion_rules_close", function(params)
	fwin:close(fwin:find("FuryHeroPotionRulesClass"))
end)

state_machine.init()

function FuryHeroPotion:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.utils.ConfirmTip")
end

function FuryHeroPotion:init(heroId)
	self.heroId = heroId
	self:setTouchEnabled(true)
	self:onInit()
	return self
end

function FuryHeroPotion:onInit()
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fury_hero_potion_close",
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
		terminal_name = "fury_hero_potion_help",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self:onUpdateDraw()
end

function FuryHeroPotion:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local title = ccui.Helper:seekWidgetByName(root, "Text_title")
	local fontName = title:getFontName()
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	listView:removeAllItems()
	local view = _ED.fury_hero_potion
	if view == nil or view.hero ~= self.heroId then
		return
	end
	listView:addChild(self:createActiveRow(view, fontName, listView:getContentSize().width))
	for _, p in ipairs(view.catalog) do
		listView:addChild(self:createPotionRow(p, fontName))
	end
	listView:requestRefreshView()
end

-- Lo que el heroe lleva puesto: una linea por pocion activa (el tiempo, el
-- que dijo el servidor al abrir o al usar; no corre en pantalla).
function FuryHeroPotion:createActiveRow(view, fontName, width)
	local lines = { text(2) }
	local byMould = {}
	for _, p in ipairs(view.catalog) do
		byMould[p.mould] = p
	end
	if #view.active == 0 then
		lines[#lines + 1] = text(3)
	end
	for _, a in ipairs(view.active) do
		local p = byMould[a.mould] or {}
		lines[#lines + 1] = itemName(a.mould) .. "  " .. FuryHeroPotion_attrs(p) .. "  "
			.. string.format(text(6), FuryHeroPotion_time(a.remaining))
	end
	local height = 36 * #lines + 16
	local row = ccui.Layout:create()
	row:setContentSize(cc.size(width, height))
	for i, line in ipairs(lines) do
		local label = ccui.Text:create(line, fontName, 22)
		label:setAnchorPoint(cc.p(0, 0.5))
		label:setPosition(cc.p(20, height - 8 - 36 * (i - 0.5)))
		if i == 1 then
			label:setColor(cc.c3b(255, 220, 90))
		elseif #view.active > 0 then
			label:setColor(cc.c3b(80, 230, 80))
		end
		row:addChild(label)
		fitWidth(label, width - 40)
	end
	return row
end

function FuryHeroPotion:createPotionRow(p, fontName)
	local csbRow = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help_list_2.csb")
	local root = csbRow:getChildByName("root")
	root:removeFromParent(false)
	local size = root:getContentSize()

	local icon = ResourcesIconCell:createCell()
	icon:init(6, p.owned, p.mould, nil, nil, true, true, 1)
	icon:setScale(0.7)
	icon:setPosition(cc.p(14, 20))
	root:addChild(icon)

	local textX = 100
	local textWidth = math.max(200, size.width - textX - 150)
	local name = ccui.Helper:seekWidgetByName(root, "Text_ranking")
	name:setString(itemName(p.mould))
	name:setAnchorPoint(cc.p(0, 0.5))
	name:setPosition(cc.p(textX, 84))
	fitWidth(name, textWidth)

	local detail = fwin:furyRowStatus(root)
	detail:setFontSize(20)
	detail:setAnchorPoint(cc.p(0, 0.5))
	detail:setPosition(cc.p(textX, 36))
	detail:setString(FuryHeroPotion_attrs(p) .. "  " .. string.format(text(21), FuryHeroPotion_time(p.seconds))
		.. "  " .. string.format(text(5), p.owned))
	detail:setColor(cc.c3b(255, 220, 90))
	fitWidth(detail, textWidth)

	local rewards = ccui.Helper:seekWidgetByName(root, "ListView_ranking_reward_2")
	if rewards ~= nil then
		rewards:setVisible(false)
	end

	local button = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
	button:setTitleText(text(4))
	button:setTitleFontName(fontName)
	button:setTitleFontSize(22)
	button:setTitleColor(cc.c3b(90, 45, 10))
	fwin:fitButtonTitle(button)
	button:setPosition(cc.p(size.width - 70, size.height / 2))
	root:addChild(button)
	-- Sin ninguna el boton sale apagado pero responde: avisa de la Tienda Premium.
	fwin:addTouchEventListener(button, nil,
	{
		terminal_name = "fury_hero_potion_use",
		terminal_state = 0,
		isPressedActionEnabled = true,
		potion = p,
	}, nil, 0)
	if p.owned <= 0 then
		button:setBright(false)
	end

	local row = ccui.Layout:create()
	row:setContentSize(size)
	row:addChild(root)
	return row
end

function FuryHeroPotion:onExit()
end

-----------------------------------------------------------------------------------------------
-- La ventana de reglas (el «?»): utils/common_popup_rule.csb con `_fury_potion_text` 14..19.
-----------------------------------------------------------------------------------------------
FuryHeroPotionRules = class("FuryHeroPotionRulesClass", Window)

function FuryHeroPotionRules:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryHeroPotionRules:init()
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
		local lines = {}
		for i = 14, 19 do
			lines[#lines + 1] = text(i)
		end
		body:setString(table.concat(lines, "\n"))
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "fury_hero_potion_rules_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	return self
end

function FuryHeroPotionRules:onExit()
end
