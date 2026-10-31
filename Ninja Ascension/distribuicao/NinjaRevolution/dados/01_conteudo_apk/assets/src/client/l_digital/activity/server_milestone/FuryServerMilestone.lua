-----------------------------------------------------------------------------------------------
-- LOS HITOS DEL SERVIDOR (Fury, sistema 19, 30-sep-2026; docs/systems/hitos_servidor.md).
--
-- Metas COLECTIVAS de cada servidor por temporada (un mes): invocaciones, combates de arena,
-- diamantes recargados y poder. Al llegar a un tramo, el servidor manda el premio por correo a
-- TODOS sus jugadores (carta tipo 2000). Esta ventana solo ENSENA el progreso: no hay boton de
-- cobrar.
--
-- Entrada: icono de la ciudad «Hitos del servidor» (Home.lua, activity_type 29200).
--
-- Ventana hecha SOLO con maquetas y arte del paquete (como Cronicas y Suscripciones):
--   ventana: activity/wonderful/sm_limited_time_equip_box_help.csb (Text_title,
--            ListView_xsbx_rule, Button_closed); filas ccui.Layout/ccui.Text;
--   barra:   images/ui/pragress/pj_jindutiao_bg.png + pj_jindutiao_bg_loading.png;
--   premios: ResourcesIconCell; «?»: images/ui/button/icon_wenhao.png y la ventana de reglas
--            utils/common_popup_rule.csb (Text_tittle, Text_1, Button_close);
--   icono de la ciudad: activity/icon/activity_shizishou.csb con zc_icon_fury_hitos.png.
-- Textos: `_fury_server_milestone_text` de TipStringInfo.lua (12 idiomas).
--
-- PROTOCOLO (comando PROPIO, fury_legacy_server_milestone.erl), por el transporte de siempre:
--   C2S 29200 fury_server_milestone_view  rol
--   S2C 29209 servidor, temporada (AAAAMM), segundos que quedan, n metricas y por metrica:
--             codigo (1 invocaciones, 2 arena, 3 diamantes recargados, 4 poder), valor, n tramos
--             y por tramo: id, meta, alcanzado (0/1), premio «tipo,molde,cantidad|...».
-- El servidor manda: los contadores, los tramos y los premios salen de su base.
-----------------------------------------------------------------------------------------------
FuryServerMilestone = class("FuryServerMilestoneClass", Window)

local VIEW_CODE, PARSER_CODE = 29200, 29209
local BAR_BG = "images/ui/pragress/pj_jindutiao_bg.png"
local BAR_FILL = "images/ui/pragress/pj_jindutiao_bg_loading.png"

local function text(i)
	return _fury_server_milestone_text ~= nil and tostring(_fury_server_milestone_text[i] or "") or ""
end

local function milestone_command(key)
	return function(str)
		local item = protocol_command[key]
		return str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
	end
end

local function parse_fury_server_milestone(interpreter, datas, pos, strDatas, list, count)
	local v = { metrics = {} }
	v.server = tonumber(npos(list)) or 0
	v.season = tonumber(npos(list)) or 0
	v.left = tonumber(npos(list)) or 0
	v.received_at = os.time()
	local n = tonumber(npos(list)) or 0
	for i = 1, n do
		local m = { tiers = {} }
		m.metric = tonumber(npos(list)) or 0
		m.value = tonumber(npos(list)) or 0
		local k = tonumber(npos(list)) or 0
		for j = 1, k do
			local t = {}
			t.id = tonumber(npos(list)) or 0
			t.target = tonumber(npos(list)) or 0
			t.reached = (tonumber(npos(list)) or 0) == 1
			t.reward = tostring(npos(list) or "")
			m.tiers[#m.tiers + 1] = t
		end
		v.metrics[#v.metrics + 1] = m
	end
	_ED.fury_server_milestone = v
end

-- Da de alta (o vuelve a dar) el comando y el bloque. Idempotente.
function FuryServerMilestone_ensureProtocol()
	protocol_command.fury_server_milestone_view = protocol_command.fury_server_milestone_view or
		{ code = VIEW_CODE, command = "fury_server_milestone_view",
		  command_fun = milestone_command("fury_server_milestone_view"), param_list = "" }
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER_CODE, parser = "parse_fury_server_milestone",
		parser_fun = parse_fury_server_milestone })
end

-- «tipo,molde,cantidad|...» -> { {tipo, cantidad, molde}, ... } (el orden de ResourcesIconCell).
function FuryServerMilestone_rewards(str)
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

-- Las reglas (textos 11..15), una por linea.
function FuryServerMilestone_rules()
	local lines = {}
	for i = 11, 15 do
		lines[#lines + 1] = text(i)
	end
	return table.concat(lines, "\n")
end

local function redraw()
	local window = fwin:find("FuryServerMilestoneClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
end

local function requestView()
	FuryServerMilestone_ensureProtocol()
	local function callback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			redraw()
		end
	end
	protocol_command.fury_server_milestone_view.param_list = ""
	NetworkManager:register(VIEW_CODE, nil, nil, nil, nil, callback, false, nil)
end

function FuryServerMilestone_open()
	if fwin:find("FuryServerMilestoneClass") ~= nil then
		return
	end
	app.load("client.cells.utils.resources_icon_cell")
	_ED.fury_server_milestone = nil
	fwin:open(FuryServerMilestone:new():init(), fwin._ui)
	requestView()
end

local fury_server_milestone_open_terminal = {
	_name = "fury_server_milestone_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		FuryServerMilestone_open()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_server_milestone_close_terminal = {
	_name = "fury_server_milestone_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FuryServerMilestoneClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_server_milestone_help_terminal = {
	_name = "fury_server_milestone_help",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("FuryServerMilestoneRulesClass") == nil then
			fwin:open(FuryServerMilestoneRules:new():init(), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_server_milestone_rules_close_terminal = {
	_name = "fury_server_milestone_rules_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FuryServerMilestoneRulesClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fury_server_milestone_open_terminal)
state_machine.add(fury_server_milestone_close_terminal)
state_machine.add(fury_server_milestone_help_terminal)
state_machine.add(fury_server_milestone_rules_close_terminal)
state_machine.init()

function FuryServerMilestone:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryServerMilestone:init()
	self:setTouchEnabled(true)
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fury_server_milestone_close",
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
		terminal_name = "fury_server_milestone_help",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self:onUpdateDraw()
	return self
end

local function label(parent, str, fontName, size, x, y, color, maxWidth, anchorX)
	local t = ccui.Text:create(str, fontName, size)
	t:setAnchorPoint(cc.p(anchorX or 0, 0.5))
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

-- Lo que le queda a la temporada, con el formato del texto 16 (dias, horas, minutos).
local function remaining(v)
	local s = math.max(0, v.left - (os.time() - (v.received_at or os.time())))
	local days = math.floor(s / 86400)
	local h = math.floor((s % 86400) / 3600)
	local m = math.floor((s % 3600) / 60)
	return string.format(text(16), days, h, m)
end

function FuryServerMilestone:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local fontName = ccui.Helper:seekWidgetByName(root, "Text_title"):getFontName()
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	listView:removeAllItems()
	local v = _ED.fury_server_milestone
	if v == nil then
		return
	end
	local width = listView:getContentSize().width

	local head = row(width, 50)
	label(head, string.format(text(2), remaining(v)), fontName, 22, 20, 25,
		cc.c3b(255, 220, 90), width - 40)
	listView:addChild(head)

	for _, m in ipairs(v.metrics) do
		listView:addChild(self:createMetric(m, fontName, width))
		for _, t in ipairs(m.tiers) do
			listView:addChild(self:createTier(t, fontName, width))
		end
	end
	listView:requestRefreshView()
end

-- Cabecera de una meta: nombre y barra hasta el siguiente tramo (llena si ya estan todos).
function FuryServerMilestone:createMetric(m, fontName, width)
	local r = row(width, 90)
	label(r, text(2 + m.metric), fontName, 24, 20, 68, cc.c3b(255, 220, 90), width - 40)
	local goal = nil
	for _, t in ipairs(m.tiers) do
		if not t.reached then
			goal = t.target
			break
		end
	end
	if goal == nil and #m.tiers > 0 then
		goal = m.tiers[#m.tiers].target
	end
	local bg = ccui.ImageView:create(BAR_BG)
	local barWidth = math.min(width - 40, bg:getContentSize().width)
	bg:setScaleX(barWidth / bg:getContentSize().width)
	bg:setAnchorPoint(cc.p(0, 0.5))
	bg:setPosition(cc.p(20, 30))
	r:addChild(bg)
	local bar = ccui.LoadingBar:create(BAR_FILL)
	bar:setScaleX(barWidth / bar:getContentSize().width)
	bar:setAnchorPoint(cc.p(0, 0.5))
	bar:setPosition(cc.p(20, 30))
	local pct = 100
	if goal ~= nil and goal > 0 then
		pct = math.min(100, math.floor(m.value * 100 / goal))
	end
	bar:setPercent(pct)
	r:addChild(bar)
	local caption = label(r, tostring(m.value) .. (goal ~= nil and (" / " .. goal) or ""),
		fontName, 18, 20 + barWidth / 2, 30, nil, barWidth - 20, 0.5)
	caption:enableOutline(cc.c4b(0, 0, 0, 255), 2)
	return r
end

-- Un tramo: meta, premios y si ya se alcanzo (entonces ya llego por correo a todos).
function FuryServerMilestone:createTier(t, fontName, width)
	local green, grey = cc.c3b(80, 230, 80), cc.c3b(200, 200, 200)
	-- Premios de TODOS los tramos a la vista y bien grandes, alcanzados o no (Victor, 30-sep:
	-- a 0,55 casi no se leian las cantidades).
	local r = row(width, 110)
	label(r, string.format(text(8), tostring(t.target)), fontName, 22, 30, 70,
		t.reached and green or grey, 200)
	label(r, t.reached and text(7) or text(9), fontName, 18, 30, 38,
		t.reached and green or grey, 200)
	local x = 250
	for _, rw in ipairs(FuryServerMilestone_rewards(t.reward)) do
		local cell = ResourcesIconCell:createCell()
		cell:init(rw[1], rw[2], rw[3], nil, nil, true, true, 1)
		cell:setScale(0.8)
		cell:setPosition(cc.p(x, 8))
		r:addChild(cell)
		x = x + 100
	end
	return r
end

function FuryServerMilestone:onExit()
end

-----------------------------------------------------------------------------------------------
-- La ventana de reglas (el «?»): utils/common_popup_rule.csb con los textos 10..15.
-----------------------------------------------------------------------------------------------
FuryServerMilestoneRules = class("FuryServerMilestoneRulesClass", Window)

function FuryServerMilestoneRules:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryServerMilestoneRules:init()
	self:setTouchEnabled(true)
	local csbNode = csb.createNode("utils/common_popup_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	local title = ccui.Helper:seekWidgetByName(root, "Text_tittle")
	if title ~= nil then
		title:setString(text(10))
	end
	local body = ccui.Helper:seekWidgetByName(root, "Text_1")
	if body ~= nil then
		body:setString(FuryServerMilestone_rules())
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "fury_server_milestone_rules_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	return self
end

function FuryServerMilestoneRules:onExit()
end

-----------------------------------------------------------------------------------------------
-- EL ICONO DE LA CIUDAD (Home.lua; activity_type 29200, sin fila en activity_sorting_mould:
-- va al final).
-----------------------------------------------------------------------------------------------
FuryServerMilestoneCell = class("FuryServerMilestoneCellClass", Window)

function FuryServerMilestoneCell:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryServerMilestoneCell:init()
	local csbCell = csb.createNode("activity/icon/activity_shizishou.csb")
	local root = csbCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	self:setContentSize(root:getContentSize())

	local button = ccui.Helper:seekWidgetByName(root, "Button_act_but")
	local art = "images/ui/text/sm_hd/zc_icon_fury_hitos.png"
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
		terminal_name = "fury_server_milestone_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
end

function FuryServerMilestoneCell:createCell()
	local cell = FuryServerMilestoneCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function FuryServerMilestoneCell:onExit()
end
