-----------------------------------------------------------------------------------------------
-- EL RANKING DE PROGRESO (S1, sugerencia de un jugador; 5-oct-2026; docs/systems/ranking_progreso.md).
--
-- Una SEPTIMA pestana en «Ranking List» (SmRankingMainInterface, system/sm_ranking.csb) que abre esta
-- ventana: el top del SERVIDOR del jugador en Nivel, Historia, Elite y Pesadilla (la etapa mas alta,
-- «capitulo-etapa») y las METAS: cada 10 niveles y cada capitulo terminado de las tres dificultades,
-- 20 de la moneda premium cada una, que se cobran UNA vez (boton «Cobrar», «Cobrar todo» y punto rojo
-- en la pestana y en «Metas»).
--
-- Hecha SOLO con maquetas y arte del paquete (como Hitos del servidor y el Pase de temporada):
--   ventana: activity/wonderful/sm_limited_time_equip_box_help.csb (Text_title, ListView_xsbx_rule,
--            Button_closed); filas ccui.Layout/ccui.Text; pestanas images/ui/button/button_tab_1.png;
--   pestana del ranking: phn_btn_tab_7_1/2.png (la 2 «Stage Stars» sin rotulo, ver
--            tools/ranking_progreso/pestana_vacia.py) con el rotulo del idioma encima;
--   premio: ResourcesIconCell; punto rojo: images/ui/bar/tips.png; cobrar: DrawRareReward tipo 7.
-- Textos: `_fury_progress_rank_text` de TipStringInfo.lua (13 idiomas).
--
-- PROTOCOLO (comandos PROPIOS, fury_legacy_progress_rank.erl), por el transporte de siempre:
--   C2S 29210 fury_progress_rank_view   rol, categoria (1 nivel, 2 historia, 3 elite, 4 pesadilla)
--   C2S 29211 fury_progress_rank_claim  rol, meta (0 = todas), categoria
--   S2C 29219 categoria, mi puesto (0 = sin puesto), mi valor, mi rotulo, n filas y por fila: puesto,
--             rol, nombre, nivel, VIP, valor, rotulo; n metas y por meta: id, categoria, objetivo,
--             estado (0 sin alcanzar, 1 cobrable, 2 cobrada), premio «tipo,molde,cantidad»; cobrables.
-- El servidor manda: los valores, los puestos, las metas y el premio salen de su base.
-----------------------------------------------------------------------------------------------
FuryProgressRank = class("FuryProgressRankClass", Window)

local VIEW_CODE, CLAIM_CODE, PARSER_CODE = 29210, 29211, 29219
local TAB_NORMAL = "images/ui/text/PHB_res/phn_btn_tab_7_2.png"
local TAB_PRESSED = "images/ui/text/PHB_res/phn_btn_tab_7_1.png"
local SUB_TAB = "images/ui/button/button_tab_1.png"
local RED_DOT = "images/ui/bar/tips.png"
local GOALS_PAGE = 5

local function text(i)
	return _fury_progress_rank_text ~= nil and tostring(_fury_progress_rank_text[i] or "") or ""
end

local function sub_command(key)
	return function(str)
		local item = protocol_command[key]
		return str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
	end
end

local function unescape(s)
	s = string.gsub(tostring(s or ""), "&nbsp;", " ")
	s = string.gsub(s, "&#13;", "")
	s = string.gsub(s, "&#10;", " ")
	return (string.gsub(s, "&amp;", "&"))
end

-- El bloque 29219 a partir de una funcion que da el token siguiente (npos en el juego).
function FuryProgressRank_parse(nextToken)
	local function num() return tonumber(nextToken()) or 0 end
	local v = { rows = {}, goals = {} }
	v.category = num()
	v.my_rank = num()
	v.my_value = num()
	v.my_label = tostring(nextToken() or "0")
	for i = 1, num() do
		local r = {}
		r.rank = num()
		r.role_id = tostring(nextToken() or "0")
		r.name = unescape(nextToken())
		r.level = num()
		r.vip = num()
		r.value = num()
		r.label = tostring(nextToken() or "0")
		v.rows[#v.rows + 1] = r
	end
	for i = 1, num() do
		local g = {}
		g.id = num()
		g.category = num()
		g.target = num()
		g.state = num()
		g.reward = tostring(nextToken() or "")
		v.goals[#v.goals + 1] = g
	end
	v.claimable = num()
	return v
end

local function parse_fury_progress_rank(interpreter, datas, pos, strDatas, list, count)
	_ED.fury_progress_rank = FuryProgressRank_parse(function() return npos(list) end)
end

-- Da de alta (o vuelve a dar) los dos comandos y el bloque. Idempotente.
function FuryProgressRank_ensureProtocol()
	for _, c in ipairs({ { "fury_progress_rank_view", VIEW_CODE }, { "fury_progress_rank_claim", CLAIM_CODE } }) do
		protocol_command[c[1]] = protocol_command[c[1]] or
			{ code = c[2], command = c[1], command_fun = sub_command(c[1]), param_list = "" }
	end
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER_CODE, parser = "parse_fury_progress_rank",
		parser_fun = parse_fury_progress_rank })
end

-- «tipo,molde,cantidad|...» -> {{tipo, cantidad, molde}, ...} (el orden de ResourcesIconCell).
function FuryProgressRank_rewards(str)
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

-- Las metas en el orden de la pantalla: primero las que se pueden cobrar, luego las pendientes y al
-- final las cobradas; dentro de cada grupo, el orden del servidor.
function FuryProgressRank_sortedGoals(goals)
	local order = { [1] = 1, [0] = 2, [2] = 3 }
	local list = {}
	for i, g in ipairs(goals or {}) do
		list[#list + 1] = { g = g, i = i }
	end
	table.sort(list, function(a, b)
		local ka, kb = order[a.g.state] or 4, order[b.g.state] or 4
		if ka ~= kb then
			return ka < kb
		end
		return a.i < b.i
	end)
	local out = {}
	for _, e in ipairs(list) do
		out[#out + 1] = e.g
	end
	return out
end

-- Donde va cada pestana del Ranking List: `xs` de las visibles (sin la nueva), `first` y `last` los
-- centros de la 1 y la 6 del .csb, `width` el ancho de una. Devuelve {x...} para las visibles mas la
-- nueva, y la escala. Si caben en los seis huecos, la nueva ocupa el siguiente sin tocar nada.
function FuryProgressRank_tabLayout(count, first, last, width)
	local step = (last - first) / 5
	if count + 1 <= 6 then
		local xs = {}
		for i = 1, count + 1 do
			xs[i] = first + (i - 1) * step
		end
		return xs, 1
	end
	local n = count + 1
	local left, right = first - width / 2, last + width / 2
	local slot = (right - left) / n
	-- El mismo solape que traen las del .csb (separadas 146 con 152 de ancho).
	local scale = math.min(1, slot / step)
	local xs = {}
	for i = 1, n do
		xs[i] = left + slot * (i - 0.5)
	end
	return xs, scale
end

local function redraw()
	local window = fwin:find("FuryProgressRankClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
	FuryProgressRank_refreshDot()
end

local function request(code, key, params, onOk)
	FuryProgressRank_ensureProtocol()
	local function callback(response)
		-- Un rechazo (-26001/-26006) ya lo pinta el cliente con su error_code.
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if onOk ~= nil then
				onOk()
			end
			redraw()
		end
	end
	protocol_command[key].param_list = params
	NetworkManager:register(code, nil, nil, nil, nil, callback, false, nil)
end

local function requestView(category)
	request(VIEW_CODE, "fury_progress_rank_view", tostring(category), nil)
end

function FuryProgressRank_open(category)
	if fwin:find("FuryProgressRankClass") ~= nil then
		return
	end
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.reward.DrawRareReward")
	fwin:open(FuryProgressRank:new():init(category or 1), fwin._ui)
	requestView(category or 1)
end

-- LA PESTANA DEL RANKING LIST. La llama SmRankingMainInterface:onInit despues de decidir si se ve la
-- pestana 6 (Batalla de reyes). Con seis visibles las siete se reparten el ancho de las seis.
function FuryProgressRank_addTab(root)
	if root == nil then
		return
	end
	local first = ccui.Helper:seekWidgetByName(root, "Button_rank_tab_1")
	local six = ccui.Helper:seekWidgetByName(root, "Button_rank_tab_6")
	if first == nil or six == nil or six:getParent() == nil then
		return
	end
	local visible = {}
	for i = 1, 6 do
		local b = ccui.Helper:seekWidgetByName(root, "Button_rank_tab_" .. i)
		if b ~= nil and b:isVisible() then
			visible[#visible + 1] = b
		end
	end
	local tab = ccui.Button:create(TAB_NORMAL, TAB_PRESSED)
	tab:setName("Button_rank_tab_fury_progress")
	tab:setTitleText(text(1))
	tab:setTitleFontName(ccui.Helper:seekWidgetByName(root, "Button_chakan"):getTitleFontName())
	tab:setTitleFontSize(22)
	tab:setTitleColor(cc.c3b(235, 235, 235))
	local label = tab:getTitleRenderer()
	if label ~= nil and label.enableOutline ~= nil then
		label:enableOutline(cc.c4b(30, 30, 30, 255), 2)
	end
	fwin:fitButtonTitle(tab)
	six:getParent():addChild(tab)
	local xs, scale = FuryProgressRank_tabLayout(#visible, first:getPositionX(), six:getPositionX(),
		six:getContentSize().width)
	visible[#visible + 1] = tab
	for i, b in ipairs(visible) do
		b:setScale(scale)
		b:setPosition(cc.p(xs[i], six:getPositionY()))
	end
	local dot = ccui.ImageView:create(RED_DOT)
	dot:setName("fury_progress_dot")
	dot:setPosition(cc.p(tab:getContentSize().width - 18, tab:getContentSize().height - 10))
	dot:setVisible(false)
	tab:addChild(dot)
	fwin:addTouchEventListener(tab, nil, { terminal_name = "fury_progress_rank_open", terminal_state = 0,
		isPressedActionEnabled = true }, nil, 0)
	-- El punto rojo: una vista de la pestana de nivel al abrir el ranking.
	requestView(1)
end

-- El punto rojo de la pestana del Ranking List y el de «Metas»: hay metas cobrables.
function FuryProgressRank_refreshDot()
	local v = _ED.fury_progress_rank
	local on = v ~= nil and (v.claimable or 0) > 0
	local main = fwin:find("SmRankingMainInterfaceClass")
	if main ~= nil and main.roots ~= nil and main.roots[1] ~= nil then
		local tab = ccui.Helper:seekWidgetByName(main.roots[1], "Button_rank_tab_fury_progress")
		if tab ~= nil and tolua.isnull(tab) == false then
			local dot = tab:getChildByName("fury_progress_dot")
			if dot ~= nil then
				dot:setVisible(on)
			end
		end
	end
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

terminal("fury_progress_rank_open", function(terminal, instance, params)
	FuryProgressRank_open(1)
	return true
end)

terminal("fury_progress_rank_close", function(terminal, instance, params)
	fwin:close(fwin:find("FuryProgressRankClass"))
	FuryProgressRank_refreshDot()
	return true
end)

-- Las cinco pestanas de la ventana: 1-4 piden su lista; 5 (Metas) usa lo que ya llego.
terminal("fury_progress_rank_page", function(terminal, instance, params)
	local page = params ~= nil and params._datas ~= nil and params._datas.page or nil
	local window = fwin:find("FuryProgressRankClass")
	if page == nil or window == nil then
		return true
	end
	window.page = page
	if page ~= GOALS_PAGE then
		window.category = page
		requestView(page)
	end
	window:onUpdateDraw()
	return true
end)

-- «Cobrar» de una meta (su id) o «Cobrar todo» (0).
terminal("fury_progress_rank_claim", function(terminal, instance, params)
	local goal = params ~= nil and params._datas ~= nil and params._datas.goal or nil
	local window = fwin:find("FuryProgressRankClass")
	if goal == nil then
		return true
	end
	local category = window ~= nil and window.category or 1
	request(CLAIM_CODE, "fury_progress_rank_claim", tostring(goal) .. "\r\n" .. tostring(category), function()
		local getRewardWnd = DrawRareReward:new()
		getRewardWnd:init(7)
		fwin:open(getRewardWnd, fwin._ui)
	end)
	return true
end)

state_machine.init()

function FuryProgressRank:ctor()
	self.super:ctor()
	self.roots = {}
	self.page = 1
	self.category = 1
	self.tabs = {}
end

function FuryProgressRank:init(category)
	self.page = category
	self.category = category
	self:setTouchEnabled(true)
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)
	-- Naruto: el marco de esta maqueta (images/ui/slots/jt_paper2_bg.png) es negro al 80 % y dejaba ver
	-- la lista de Poder del Ranking List. Fondo negro opaco detras del marco, dentro de su borde
	-- amarillo (9 px; las esquinas del scale9 no se estiran). En los otros juegos el marco ya es opaco.
	local paper = ccui.Helper:seekWidgetByName(root, "Image_xsbx_rule_1_1")
	if paper ~= nil then
		local ps, pa = paper:getContentSize(), paper:getAnchorPoint()
		local back = cc.LayerColor:create(cc.c4b(0, 0, 0, 255), ps.width - 18, ps.height - 18)
		back:setPosition(cc.p(paper:getPositionX() - ps.width * pa.x + 9, paper:getPositionY() - ps.height * pa.y + 9))
		paper:getParent():addChild(back, paper:getLocalZOrder() - 1)
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fury_progress_rank_close",
		terminal_state = 0,
		touch_black = true,
	}, nil, 3)
	local title = ccui.Helper:seekWidgetByName(root, "Text_title")
	title:setString(text(2))
	-- La lista encoge 58 por arriba para dejar la fila de pestanas.
	local list = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	local size = list:getContentSize()
	local anchor = list:getAnchorPoint()
	local left = list:getPositionX() - size.width * anchor.x
	local top = list:getPositionY() + size.height * (1 - anchor.y)
	local bottom = top - size.height
	list:setContentSize(cc.size(size.width, size.height - 58))
	list:setPositionY(bottom + (size.height - 58) * anchor.y)
	local fontName = title:getFontName()
	local names = { text(3), text(4), text(5), text(6), text(7) }
	local step = size.width / #names
	for i, name in ipairs(names) do
		local b = ccui.Button:create(SUB_TAB, SUB_TAB)
		b:setTitleText(name)
		b:setTitleFontName(fontName)
		b:setTitleFontSize(20)
		b:setTitleColor(cc.c3b(255, 255, 255))
		fwin:fitButtonTitle(b)
		local w = b:getContentSize().width
		if w > step - 6 then
			b:setScale((step - 6) / w)
		end
		b:setPosition(cc.p(left + step * (i - 0.5), top - 29))
		list:getParent():addChild(b)
		fwin:addTouchEventListener(b, nil, { terminal_name = "fury_progress_rank_page", terminal_state = 0,
			page = i, isPressedActionEnabled = true }, nil, 0)
		if i == GOALS_PAGE then
			local dot = ccui.ImageView:create(RED_DOT)
			dot:setPosition(cc.p(w - 12, b:getContentSize().height - 8))
			dot:setVisible(false)
			b:addChild(dot)
			self.goalsDot = dot
		end
		self.tabs[i] = b
	end
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

local function button(parent, str, fontName, x, y, enabled, datas)
	local b = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
	b:setTitleText(str)
	b:setTitleFontName(fontName)
	b:setTitleFontSize(20)
	b:setTitleColor(cc.c3b(90, 45, 10))
	fwin:fitButtonTitle(b)
	b:setPosition(cc.p(x, y))
	parent:addChild(b)
	if enabled then
		local params = { terminal_name = "fury_progress_rank_claim", terminal_state = 0,
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

-- El valor de una fila: «Nv. 57» o «Etapa 12-5».
local function valueText(category, labelText)
	if category == 1 then
		return string.format(text(10), labelText)
	end
	return string.format(text(11), labelText)
end

function FuryProgressRank:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local v = _ED.fury_progress_rank
	for i, b in ipairs(self.tabs) do
		b:setColor(i == self.page and cc.c3b(255, 255, 255) or cc.c3b(150, 150, 150))
	end
	if self.goalsDot ~= nil then
		self.goalsDot:setVisible(v ~= nil and (v.claimable or 0) > 0)
	end
	local fontName = ccui.Helper:seekWidgetByName(root, "Text_title"):getFontName()
	local list = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	list:removeAllItems()
	if v == nil then
		return
	end
	local width = list:getContentSize().width
	if self.page == GOALS_PAGE then
		self:drawGoals(list, v, fontName, width)
	elseif v.category == self.page then
		self:drawRanking(list, v, fontName, width)
	end
	list:requestRefreshView()
	list:jumpToTop()
end

function FuryProgressRank:drawRanking(list, v, fontName, width)
	local yellow, white, green = cc.c3b(255, 220, 90), cc.c3b(255, 255, 255), cc.c3b(80, 230, 80)
	local head = row(width, 50)
	local mine = v.my_rank > 0 and string.format(text(8), tostring(v.my_rank)) or text(9)
	label(head, mine, fontName, 22, 20, 25, yellow, width / 2 - 30)
	label(head, valueText(v.category, v.my_label), fontName, 22, width - 20, 25, yellow, width / 2 - 30, 1)
	list:addChild(head)
	local note = row(width, 30)
	label(note, text(12), fontName, 16, 20, 15, cc.c3b(190, 190, 190), width - 40)
	list:addChild(note)
	if #v.rows == 0 then
		local r = row(width, 40)
		label(r, text(21), fontName, 20, 20, 20, cc.c3b(200, 200, 200), width - 40)
		list:addChild(r)
		return
	end
	local me = tostring(_ED.user_info.user_id)
	for _, f in ipairs(v.rows) do
		local color = white
		if f.role_id == me then
			color = green
		elseif f.rank <= 3 then
			color = yellow
		end
		local r = row(width, 40)
		label(r, tostring(f.rank) .. ".", fontName, 20, 20, 20, color, 60)
		label(r, f.name, fontName, 20, 90, 20, color, width * 0.45)
		if v.category ~= 1 then
			label(r, string.format(text(10), tostring(f.level)), fontName, 18, width * 0.6, 20,
				cc.c3b(190, 190, 190), width * 0.15)
		end
		label(r, valueText(v.category, f.label), fontName, 20, width - 20, 20, color, width * 0.22, 1)
		list:addChild(r)
	end
end

local GOAL_TEXT = { 13, 14, 15, 16 }

function FuryProgressRank:drawGoals(list, v, fontName, width)
	local head = row(width, 60)
	label(head, text(22), fontName, 18, 20, 30, cc.c3b(255, 220, 90), width - 220)
	button(head, text(20), fontName, width - 90, 30, (v.claimable or 0) > 0, { goal = 0 })
	list:addChild(head)
	local green, grey, white = cc.c3b(80, 230, 80), cc.c3b(170, 170, 170), cc.c3b(255, 255, 255)
	for _, g in ipairs(FuryProgressRank_sortedGoals(v.goals)) do
		local r = row(width, 84)
		local color = g.state == 1 and green or (g.state == 2 and grey or white)
		label(r, string.format(text(GOAL_TEXT[g.category] or 13), g.target), fontName, 20, 20, 42, color,
			width - 330)
		local x = width - 260
		for _, rw in ipairs(FuryProgressRank_rewards(g.reward)) do
			local cell = ResourcesIconCell:createCell()
			cell:init(rw[1], rw[2], rw[3], nil, nil, true, true, 1)
			local cs = cell:getContentSize()
			local sc = (cs.height ~= nil and cs.height > 0) and 64 / cs.height or 0.6
			cell:setScale(sc)
			cell:setPosition(cc.p(x, 10))
			r:addChild(cell)
			x = x + 72
		end
		local str = g.state == 1 and text(17) or (g.state == 2 and text(18) or text(19))
		button(r, str, fontName, width - 90, 42, g.state == 1, { goal = g.id })
		list:addChild(r)
	end
end

function FuryProgressRank:onExit()
end
