-----------------------------------------------------------------------------------------------
-- EL PASE DE TEMPORADA (Fury, sistema 15, 30-sep-2026; docs/systems/pase_temporada.md).
--
-- Temporadas de 30 dias que rotan solas. Dos caminos de premios por nivel (Gratis y Premium);
-- el Premium se desbloquea por temporada con Monedas premium (objeto 3436). Los niveles suben
-- con puntos de pase que dan las misiones diarias y semanales (el servidor las cuenta solo).
--
-- Entrada: icono de la ciudad «Pase de temporada» (Home.lua, activity_type 29160, nivel 10+).
--
-- Ventana hecha SOLO con maquetas y arte del paquete (como Suscripciones y Cronicas):
--   ventana: activity/wonderful/sm_limited_time_equip_box_help.csb (Text_title,
--            ListView_xsbx_rule, Button_closed); filas ccui.Layout/ccui.Text; premios con
--            ResourcesIconCell; boton images/ui/button/btn_1.png; «?» button_wenhao.png y la
--            ventana de reglas utils/common_popup_rule.csb; confirmar: ConfirmTip; premio
--            cobrado: DrawRareReward tipo 7 (el cofre de una tecla);
--   icono de la ciudad: activity/icon/activity_shizishou.csb con zc_icon_fury_pass.png.
-- Textos: `_fury_season_pass_text` de TipStringInfo.lua (12 idiomas).
--
-- PROTOCOLO (comandos PROPIOS, fury_legacy_season_pass.erl):
--   C2S 29160 fury_season_pass_view    rol
--   C2S 29161 fury_season_pass_claim   rol, nivel (0 = todo lo que se pueda)
--   C2S 29162 fury_season_pass_unlock  rol
--   S2C 29169 temporada, dias que quedan, puntos, puntos por nivel, nivel, tope, premium (0/1),
--             precio, monedas que tiene, n misiones (id, periodo 1/2, texto, progreso, objetivo,
--             puntos, hecha) y n niveles (nivel, premio gratis, estado, premio premium, estado;
--             premio «tipo,molde,cantidad|...» o «0»; estado 0 no, 1 se puede, 2 cobrado).
-- El servidor manda: aqui solo se dice QUE nivel cobrar.
-----------------------------------------------------------------------------------------------
FurySeasonPass = class("FurySeasonPassClass", Window)

local VIEW_CODE, CLAIM_CODE, UNLOCK_CODE, PARSER_CODE = 29160, 29161, 29162, 29169
local COIN_MOULD = 3396 -- NARUTO: las Monedas premium de Naruto (Fury 3436)
local MAX_ROWS = 12

local function text(i)
	return _fury_season_pass_text ~= nil and _fury_season_pass_text[i] or ""
end

local function pass_command(key)
	return function(str)
		local item = protocol_command[key]
		return str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
	end
end

local function parse_fury_season_pass(interpreter, datas, pos, strDatas, list, count)
	local v = { tasks = {}, levels = {} }
	for _, k in ipairs({ "season", "left", "points", "per", "level", "max", "premium", "price",
		"balance" }) do
		v[k] = tonumber(npos(list)) or 0
	end
	local n = tonumber(npos(list)) or 0
	for i = 1, n do
		local t = {}
		for _, k in ipairs({ "id", "period", "text", "progress", "target", "points", "done" }) do
			t[k] = tonumber(npos(list)) or 0
		end
		v.tasks[#v.tasks + 1] = t
	end
	n = tonumber(npos(list)) or 0
	for i = 1, n do
		local l = {}
		l.level = tonumber(npos(list)) or 0
		l.free = tostring(npos(list) or "0")
		l.fstate = tonumber(npos(list)) or 0
		l.prem = tostring(npos(list) or "0")
		l.pstate = tonumber(npos(list)) or 0
		v.levels[#v.levels + 1] = l
	end
	_ED.fury_season_pass = v
end

-- Da de alta (o vuelve a dar) los tres comandos y el bloque. Idempotente.
function FurySeasonPass_ensureProtocol()
	for _, c in ipairs({ { "fury_season_pass_view", VIEW_CODE },
		{ "fury_season_pass_claim", CLAIM_CODE }, { "fury_season_pass_unlock", UNLOCK_CODE } }) do
		protocol_command[c[1]] = protocol_command[c[1]] or
			{ code = c[2], command = c[1], command_fun = pass_command(c[1]), param_list = "" }
	end
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER_CODE, parser = "parse_fury_season_pass",
		parser_fun = parse_fury_season_pass })
end

-- «tipo,molde,cantidad|...» -> {{tipo, cantidad, molde}, ...}; «0» o basura -> {}.
local function rewards(str)
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

local function redraw()
	local window = fwin:find("FurySeasonPassClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
end

local function request(code, key, params, onOk)
	FurySeasonPass_ensureProtocol()
	local function callback(response)
		-- Un rechazo (-74/-26001/-26006) ya lo pinta el cliente con su error_code.
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if onOk ~= nil then
				onOk()
			end
			redraw()
		elseif code ~= VIEW_CODE then
			request(VIEW_CODE, "fury_season_pass_view", "", nil)
		end
	end
	protocol_command[key].param_list = params
	NetworkManager:register(code, nil, nil, nil, nil, callback, false, nil)
end

local function requestClaim(level)
	request(CLAIM_CODE, "fury_season_pass_claim", tostring(level), function()
		local getRewardWnd = DrawRareReward:new()
		getRewardWnd:init(7)
		fwin:open(getRewardWnd, fwin._ui)
	end)
end

function FurySeasonPass_open()
	if fwin:find("FurySeasonPassClass") ~= nil then
		return
	end
	_ED.fury_season_pass = nil
	fwin:open(FurySeasonPass:new():init(), fwin._ui)
	request(VIEW_CODE, "fury_season_pass_view", "", nil)
end

local function terminal(name, invoke)
	state_machine.add({
		_name = name,
		_init = function (terminal)
		end,
		_inited = false,
		_instance = self,
		_state = 0,
		_invoke = invoke,
		_terminal = nil,
		_terminals = nil
	})
end

terminal("fury_season_pass_open", function(terminal, instance, params)
	FurySeasonPass_open()
	return true
end)

terminal("fury_season_pass_close", function(terminal, instance, params)
	fwin:close(fwin:find("FurySeasonPassClass"))
	return true
end)

-- «Cobrar» de una fila (su nivel) o «Cobrar todo» (nivel 0).
terminal("fury_season_pass_claim", function(terminal, instance, params)
	local level = params ~= nil and params._datas ~= nil and params._datas.level or nil
	if level ~= nil then
		requestClaim(level)
	end
	return true
end)

-- «Desbloquear Premium»: comprueba el saldo que dijo el servidor y pide confirmacion.
terminal("fury_season_pass_unlock", function(terminal, instance, params)
	local v = _ED.fury_season_pass
	if v == nil or v.premium == 1 then
		return true
	end
	if v.balance < v.price then
		TipDlg.drawTextDailog(text(9))
		return true
	end
	state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, {
		terminal_name = "fury_season_pass_unlock_confirmed",
		terminal_state = 0,
		_msg = string.format(text(8), v.price),
		_datas = {},
	})
	return true
end)

terminal("fury_season_pass_unlock_confirmed", function(terminal, instance, params)
	if params ~= nil and params.status == 1 then
		request(UNLOCK_CODE, "fury_season_pass_unlock", "", function()
			TipDlg.drawTextDailog(text(10))
		end)
	end
	return true
end)

terminal("fury_season_pass_help", function(terminal, instance, params)
	if fwin:find("FurySeasonPassRulesClass") == nil then
		fwin:open(FurySeasonPassRules:new():init(), fwin._ui)
	end
	return true
end)

terminal("fury_season_pass_rules_close", function(terminal, instance, params)
	fwin:close(fwin:find("FurySeasonPassRulesClass"))
	return true
end)

state_machine.init()

function FurySeasonPass:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.utils.ConfirmTip")
	app.load("client.reward.DrawRareReward")
end

function FurySeasonPass:init()
	self:setTouchEnabled(true)
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fury_season_pass_close",
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
		terminal_name = "fury_season_pass_help",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self:onUpdateDraw()
	return self
end

local GOLD, GREEN, GREY = cc.c3b(255, 220, 90), cc.c3b(80, 230, 80), cc.c3b(170, 170, 170)

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

local function button(parent, str, fontName, x, y, enabled, datas, terminalName)
	local b = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
	b:setTitleText(str)
	b:setTitleFontName(fontName)
	b:setTitleFontSize(20)
	b:setTitleColor(cc.c3b(90, 45, 10))
	fwin:fitButtonTitle(b)
	b:setPosition(cc.p(x, y))
	parent:addChild(b)
	if enabled then
		local params = { terminal_name = terminalName, terminal_state = 0,
			isPressedActionEnabled = true }
		for k, v in pairs(datas or {}) do
			params[k] = v
		end
		fwin:addTouchEventListener(b, nil, params, nil, 0)
	else
		b:setBright(false)
		b:setTouchEnabled(false)
	end
	return b
end

local function icon(parent, typ, count, mould, x, y, scale, dim)
	local cell = ResourcesIconCell:createCell()
	cell:init(typ, count, mould, nil, nil, true, true, 1)
	cell:setScale(scale)
	cell:setPosition(cc.p(x, y))
	if dim then
		cell:setCascadeOpacityEnabled(true)
		cell:setOpacity(110)
	end
	parent:addChild(cell)
end

-- Una fila ya no hace falta: su gratis cobrado (o vacio) y, con premium, su premium tambien.
local function rowDone(v, l)
	local freeDone = l.fstate == 2 or l.free == "0"
	local premDone = v.premium ~= 1 or l.pstate == 2 or l.prem == "0"
	return freeDone and premDone
end

function FurySeasonPass:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local fontName = ccui.Helper:seekWidgetByName(root, "Text_title"):getFontName()
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	listView:removeAllItems()
	local v = _ED.fury_season_pass
	if v == nil then
		return
	end
	local width = listView:getContentSize().width

	listView:addChild(self:createHeader(v, fontName, width))
	for _, period in ipairs({ 1, 2 }) do
		local head = row(width, 40)
		label(head, text(period == 1 and 11 or 12), fontName, 22, 20, 20, GOLD)
		listView:addChild(head)
		for _, t in ipairs(v.tasks) do
			if t.period == period then
				listView:addChild(self:createTask(t, fontName, width))
			end
		end
	end
	local head = row(width, 40)
	label(head, text(13), fontName, 22, 20, 20, GOLD)
	listView:addChild(head)
	local shown, last = 0, nil
	for _, l in ipairs(v.levels) do
		if shown < MAX_ROWS and not rowDone(v, l) then
			listView:addChild(self:createLevel(v, l, fontName, width))
			shown = shown + 1
			last = l.level
		end
	end
	-- El gran premio del final siempre a la vista.
	local final = v.levels[#v.levels]
	if final ~= nil and last ~= final.level then
		listView:addChild(self:createLevel(v, final, fontName, width))
	end
	listView:requestRefreshView()
end

-- Temporada, dias, nivel y puntos, el premium y «Cobrar todo».
function FurySeasonPass:createHeader(v, fontName, width)
	local r = row(width, 160)
	local textWidth = width - 220
	label(r, string.format(text(2), v.season) .. "   " .. string.format(text(3), v.left),
		fontName, 24, 20, 138, GOLD, textWidth)
	label(r, string.format(text(4), v.level, v.max), fontName, 22, 20, 104, nil, textWidth)
	if v.level >= v.max then
		label(r, text(23), fontName, 20, 20, 74, GREEN, textWidth)
	else
		label(r, string.format(text(5), v.points - v.level * v.per, v.per), fontName, 20, 20, 74,
			nil, textWidth)
	end
	icon(r, 6, v.balance, COIN_MOULD, 16, 2, 0.45, false)
	label(r, string.format(text(22), v.balance), fontName, 20, 72, 28, GOLD, textWidth - 60)

	local canClaim = false
	for _, l in ipairs(v.levels) do
		if l.fstate == 1 or l.pstate == 1 then
			canClaim = true
		end
	end
	button(r, text(17), fontName, width - 90, 40, canClaim, { level = 0 },
		"fury_season_pass_claim")
	if v.premium == 1 then
		label(r, text(6), fontName, 20, width - 90, 110, GREEN, 170, 0.5)
	else
		button(r, text(7), fontName, width - 90, 110, true, nil, "fury_season_pass_unlock")
	end
	return r
end

function FurySeasonPass:createTask(t, fontName, width)
	local r = row(width, 44)
	label(r, text(t.text), fontName, 20, 40, 22, nil, width - 300)
	label(r, t.progress .. "/" .. t.target, fontName, 20, width - 190, 22,
		t.done == 1 and GREEN or nil, 90, 0.5)
	if t.done == 1 then
		label(r, text(21), fontName, 20, width - 80, 22, GREEN, 120, 0.5)
	else
		label(r, string.format(text(20), t.points), fontName, 20, width - 80, 22, GOLD, 120, 0.5)
	end
	return r
end

-- Un nivel: sus dos caminos con sus premios y un «Cobrar» para los dos.
function FurySeasonPass:createLevel(v, l, fontName, width)
	local r = row(width, 120)
	label(r, string.format(text(4), l.level, v.max), fontName, 20, 16, 60,
		l.level <= v.level and GOLD or GREY, 80)
	local x = 105
	for _, track in ipairs({
		{ name = text(14), reward = l.free, state = l.fstate, locked = false },
		{ name = text(15), reward = l.prem, state = l.pstate, locked = v.premium ~= 1 } }) do
		local color = track.state == 1 and GOLD or (track.state == 2 and GREEN or GREY)
		label(r, track.name, fontName, 16, x, 108, color, 150)
		local ix = x
		for _, rw in ipairs(rewards(track.reward)) do
			icon(r, rw[1], rw[2], rw[3], ix, 8, 0.6, track.state == 2 or track.locked)
			ix = ix + 66
		end
		x = x + 160
	end
	local claimable = l.fstate == 1 or l.pstate == 1
	button(r, rowDone(v, l) and text(18) or text(16), fontName, width - 80, 60, claimable,
		{ level = l.level }, "fury_season_pass_claim")
	return r
end

function FurySeasonPass:onExit()
end

-----------------------------------------------------------------------------------------------
-- La ventana de reglas (el «?»): utils/common_popup_rule.csb con los textos 25..30.
-----------------------------------------------------------------------------------------------
FurySeasonPassRules = class("FurySeasonPassRulesClass", Window)

function FurySeasonPassRules:ctor()
	self.super:ctor()
	self.roots = {}
end

function FurySeasonPassRules:init()
	self:setTouchEnabled(true)
	local csbNode = csb.createNode("utils/common_popup_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	local title = ccui.Helper:seekWidgetByName(root, "Text_tittle")
	if title ~= nil then
		title:setString(text(24))
	end
	local body = ccui.Helper:seekWidgetByName(root, "Text_1")
	if body ~= nil then
		local lines = {}
		for i = 25, 30 do
			lines[#lines + 1] = text(i)
		end
		body:setString(table.concat(lines, "\n"))
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "fury_season_pass_rules_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	return self
end

function FurySeasonPassRules:onExit()
end

-----------------------------------------------------------------------------------------------
-- EL ICONO DE LA CIUDAD (Home.lua; activity_type 29160, sin fila en activity_sorting_mould:
-- va al final).
-----------------------------------------------------------------------------------------------
FurySeasonPassCell = class("FurySeasonPassCellClass", Window)

function FurySeasonPassCell:ctor()
	self.super:ctor()
	self.roots = {}
end

function FurySeasonPassCell:init()
	local csbCell = csb.createNode("activity/icon/activity_shizishou.csb")
	local root = csbCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	self:setContentSize(root:getContentSize())

	local b = ccui.Helper:seekWidgetByName(root, "Button_act_but")
	local art = "images/ui/text/sm_hd/zc_icon_fury_pass.png"
	b:loadTextures(art, art, art)
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
	fwin:addTouchEventListener(b, nil,
	{
		terminal_name = "fury_season_pass_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
end

function FurySeasonPassCell:createCell()
	local cell = FurySeasonPassCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function FurySeasonPassCell:onExit()
end
