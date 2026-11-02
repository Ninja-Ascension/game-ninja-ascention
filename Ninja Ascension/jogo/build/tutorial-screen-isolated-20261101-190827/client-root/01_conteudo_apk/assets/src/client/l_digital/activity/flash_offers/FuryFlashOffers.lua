-----------------------------------------------------------------------------------------------
-- LAS OFERTAS RELAMPAGO (Fury, sistema 16, 30-sep-2026; docs/systems/ofertas_relampago.md).
--
-- Varias veces al dia salen unos pocos paquetes con DESCUENTO durante unas horas, pagados
-- con monedas premium (objeto 3436): precio tachado, precio rebajado, tope por jugador y
-- cuenta atras. Los paquetes, la ventana, el precio y el tope los decide el servidor
-- (flash_offers.erl); el cliente solo dice QUE hueco compra y cuantos lleva segun su
-- pantalla (asi un reenvio no cobra dos veces).
--
-- Montada SOLO con maquetas y arte que ya trae el paquete (las de la tienda de
-- suscripciones, FurySubscriptionShop.lua):
--   ventana: activity/wonderful/sm_limited_time_equip_box_help.csb (Text_title,
--            ListView_xsbx_rule, Button_closed);
--   fila:    activity/wonderful/sm_limited_time_equip_box_help_list_2.csb (Text_ranking,
--            Text_kehuode, ListView_ranking_reward_2) + ResourcesIconCell + btn_1.png;
--   ayuda:   button_wenhao.png y utils/common_popup_rule.csb;
--   confirmar: ConfirmTip (shortcut_open_function_dailog_cancel_and_ok);
--   icono de la ciudad: activity/icon/activity_shizishou.csb con zc_icon_fury_flash.png
--            (tools/ofertas_relampago/icono.py).
-- Textos: `_fury_flash_offers_text` de TipStringInfo.lua (12 idiomas).
--
-- EL PROTOCOLO: dos comandos PROPIOS por el sobre de texto de siempre.
--   C2S 29170 fury_flash_offers_view  rol
--   C2S 29171 fury_flash_offers_buy   rol, periodo, hueco, comprados
--   S2C 29179 saldo, abierta (1/0), periodo, segundos, n, y por oferta: hueco,
--             premio «tipo,molde,cantidad|...», tachado, precio, tope, comprados.
-----------------------------------------------------------------------------------------------
FuryFlashOffers = class("FuryFlashOffersClass", Window)

local VIEW_CODE, BUY_CODE, PARSER_CODE = 29170, 29171, 29179
local COIN_MOULD = 3396 -- NARUTO: las Monedas premium de Naruto (Fury 3436)

local function text(i)
	return _fury_flash_offers_text ~= nil and tostring(_fury_flash_offers_text[i] or "") or ""
end

local function sub_command(key)
	return function(str)
		local item = protocol_command[key]
		str = str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
		return str
	end
end

local function parse_fury_flash_offers(interpreter, datas, pos, strDatas, list, count)
	local shop = { offers = {} }
	shop.balance = tonumber(npos(list)) or 0
	shop.open = (tonumber(npos(list)) or 0) == 1
	shop.period = tonumber(npos(list)) or 0
	shop.seconds = tonumber(npos(list)) or 0
	shop.received = os.time()
	local n = tonumber(npos(list)) or 0
	for i = 1, n do
		local o = {}
		o.slot = tonumber(npos(list)) or 0
		o.gain = npos(list) or ""
		o.list_price = tonumber(npos(list)) or 0
		o.price = tonumber(npos(list)) or 0
		o.limit = tonumber(npos(list)) or 0
		o.bought = tonumber(npos(list)) or 0
		shop.offers[#shop.offers + 1] = o
	end
	_ED.fury_flash_offers = shop
end

-- Da de alta (o vuelve a dar) los dos comandos y el bloque. Idempotente.
function FuryFlashOffers_ensureProtocol()
	protocol_command.fury_flash_offers_view = protocol_command.fury_flash_offers_view or
		{ code = VIEW_CODE, command = "fury_flash_offers_view",
		  command_fun = sub_command("fury_flash_offers_view"), param_list = "" }
	protocol_command.fury_flash_offers_buy = protocol_command.fury_flash_offers_buy or
		{ code = BUY_CODE, command = "fury_flash_offers_buy",
		  command_fun = sub_command("fury_flash_offers_buy"), param_list = "" }
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER_CODE, parser = "parse_fury_flash_offers",
		parser_fun = parse_fury_flash_offers })
end

-- «tipo,molde,cantidad|...» -> {{tipo, cantidad, molde}, ...}
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

-- Segundos que le quedan al reloj que mando el servidor.
local function secondsLeft(shop)
	return math.max(0, shop.seconds - (os.time() - shop.received))
end

local function clock(s)
	return string.format("%02d:%02d:%02d", math.floor(s / 3600), math.floor(s % 3600 / 60), s % 60)
end

-- El nombre de la fila: el del primer objeto del paquete («Paquete relampago» si es
-- un recurso, que no tiene fila en prop_mould).
local function offerName(o)
	local r = rewards(o.gain)[1]
	if r ~= nil and r[1] == 6 then
		local ok, info = pcall(getItemNameAndQuality, { 6, r[3], 1 })
		if ok and info ~= nil and info[1] ~= nil and tostring(info[1]) ~= "" then
			return tostring(info[1])
		end
	end
	return text(15)
end

local function fitWidth(label, width)
	local w = label:getVirtualRendererSize().width
	if w > width then
		label:setScale(width / w)
	end
end

local function redraw()
	local window = fwin:find("FuryFlashOffersClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
end

local function requestView()
	FuryFlashOffers_ensureProtocol()
	local function callback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			redraw()
		end
	end
	protocol_command.fury_flash_offers_view.param_list = ""
	NetworkManager:register(VIEW_CODE, nil, nil, nil, nil, callback, false, nil)
end

local function requestBuy(o)
	FuryFlashOffers_ensureProtocol()
	local shop = _ED.fury_flash_offers
	local function callback(response)
		-- Un rechazo (-74/-26037/-26038) ya lo pinta el cliente con su error_code;
		-- en los dos casos se repinta con lo que diga el servidor.
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			TipDlg.drawTextDailog(text(10))
			redraw()
		else
			requestView()
		end
	end
	protocol_command.fury_flash_offers_buy.param_list = shop.period .. "\r\n" .. o.slot .. "\r\n" .. o.bought
	NetworkManager:register(BUY_CODE, nil, nil, nil, nil, callback, false, nil)
end

local function terminal(name, fn)
	state_machine.add({
		_name = name,
		_init = function (terminal) end,
		_inited = false,
		_instance = nil,
		_state = 0,
		_invoke = function(terminal, instance, params)
			fn(params)
			return true
		end,
		_terminal = nil,
		_terminals = nil
	})
end

terminal("fury_flash_offers_open", function(params)
	if fwin:find("FuryFlashOffersClass") == nil then
		_ED.fury_flash_offers = nil
		fwin:open(FuryFlashOffers:new():init(), fwin._ui)
		requestView()
	end
end)

terminal("fury_flash_offers_close", function(params)
	fwin:close(fwin:find("FuryFlashOffersClass"))
end)

-- «Comprar»: saldo segun el servidor y confirmacion.
terminal("fury_flash_offers_buy", function(params)
	local o = params._datas.offer
	local shop = _ED.fury_flash_offers
	if shop == nil or o == nil then
		return
	end
	if shop.balance < o.price then
		TipDlg.drawTextDailog(text(8))
		return
	end
	state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, {
		terminal_name = "fury_flash_offers_buy_confirmed",
		terminal_state = 0,
		_msg = string.format(text(9), offerName(o), o.price),
		_datas = { offer = o },
	})
end)

terminal("fury_flash_offers_buy_confirmed", function(params)
	if params ~= nil and params.status == 1 and params._datas ~= nil then
		requestBuy(params._datas.offer)
	end
end)

terminal("fury_flash_offers_help", function(params)
	if fwin:find("FuryFlashOffersRulesClass") == nil then
		fwin:open(FuryFlashOffersRules:new():init(), fwin._ui)
	end
end)

terminal("fury_flash_offers_rules_close", function(params)
	fwin:close(fwin:find("FuryFlashOffersRulesClass"))
end)

state_machine.init()

function FuryFlashOffers:ctor()
	self.super:ctor()
	self.roots = {}
	self.timerLabel = nil
	self.refreshed = false
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.utils.ConfirmTip")
end

function FuryFlashOffers:init()
	self:setTouchEnabled(true)
	self:onInit()
	return self
end

function FuryFlashOffers:onInit()
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{ terminal_name = "fury_flash_offers_close", terminal_state = 0, touch_black = true }, nil, 3)

	local title = ccui.Helper:seekWidgetByName(root, "Text_title")
	title:setString(text(1))
	local help = ccui.Button:create("images/ui/button/icon_wenhao.png",
		"images/ui/button/icon_wenhao.png")
	local tx, ty = title:getPosition()
	local tw = title:getContentSize().width * title:getScaleX()
	help:setPosition(cc.p(tx + tw * (1 - title:getAnchorPoint().x) + 40, ty))
	title:getParent():addChild(help)
	fwin:addTouchEventListener(help, nil,
	{ terminal_name = "fury_flash_offers_help", terminal_state = 0, isPressedActionEnabled = true }, nil, 0)

	-- La cuenta atras: un tic por segundo; al llegar a cero se pide la ventana nueva.
	local scheduler = cc.Director:getInstance():getScheduler()
	self.tick = scheduler:scheduleScriptFunc(function() self:onTick() end, 1, false)

	self:onUpdateDraw()
end

function FuryFlashOffers:onTick()
	local shop = _ED.fury_flash_offers
	if shop == nil or self.timerLabel == nil then
		return
	end
	local left = secondsLeft(shop)
	self.timerLabel:setString(string.format(text(shop.open and 3 or 4), clock(left)))
	if left == 0 and shop.seconds > 0 and not self.refreshed then
		self.refreshed = true
		requestView()
	end
end

function FuryFlashOffers:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local title = ccui.Helper:seekWidgetByName(root, "Text_title")
	local fontName = title:getFontName()
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	listView:removeAllItems()
	self.timerLabel = nil
	local shop = _ED.fury_flash_offers
	if shop == nil then
		return
	end
	self.refreshed = false
	listView:addChild(self:createHeaderRow(shop, fontName, listView:getContentSize().width))
	for _, o in ipairs(shop.offers) do
		listView:addChild(self:createOfferRow(o, fontName))
	end
	listView:requestRefreshView()
	self:onTick()
end

-- Saldo de monedas premium y la cuenta atras (o «No hay ofertas ahora»).
function FuryFlashOffers:createHeaderRow(shop, fontName, width)
	local height = 110
	local row = ccui.Layout:create()
	row:setContentSize(cc.size(width, height))

	local coin = ResourcesIconCell:createCell()
	coin:init(6, shop.balance, COIN_MOULD, nil, nil, true, true, 1)
	coin:setScale(0.6)
	coin:setPosition(cc.p(20, 18))
	row:addChild(coin)

	local balance = ccui.Text:create(string.format(text(2), shop.balance), fontName, 24)
	balance:setAnchorPoint(cc.p(0, 0.5))
	balance:setPosition(cc.p(100, 72))
	balance:setColor(cc.c3b(255, 220, 90))
	row:addChild(balance)

	local timer = ccui.Text:create("", fontName, 22)
	timer:setAnchorPoint(cc.p(0, 0.5))
	timer:setPosition(cc.p(100, 36))
	if shop.open then
		timer:setColor(cc.c3b(255, 120, 80))
	else
		timer:setColor(cc.c3b(200, 200, 200))
	end
	row:addChild(timer)
	self.timerLabel = timer

	if not shop.open or #shop.offers == 0 then
		local none = ccui.Text:create(text(14), fontName, 22)
		none:setAnchorPoint(cc.p(1, 0.5))
		none:setPosition(cc.p(width - 20, height / 2))
		row:addChild(none)
	end
	return row
end

function FuryFlashOffers:createOfferRow(o, fontName)
	local csbRow = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help_list_2.csb")
	local root = csbRow:getChildByName("root")
	root:removeFromParent(false)
	local size = root:getContentSize()
	local textX, textWidth = 20, 250

	local name = ccui.Helper:seekWidgetByName(root, "Text_ranking")
	name:setString(offerName(o))
	name:setAnchorPoint(cc.p(0, 0.5))
	name:setPosition(cc.p(textX, 90))
	fitWidth(name, textWidth)

	-- Precio tachado (gris, con raya roja), precio rebajado con su moneda y el descuento.
	local status = fwin:furyRowStatus(root)
	status:setFontSize(20)
	status:setAnchorPoint(cc.p(0, 0.5))
	status:setPosition(cc.p(textX, 56))
	status:setString(tostring(o.list_price))
	status:setColor(cc.c3b(160, 160, 160))
	local sw = status:getVirtualRendererSize().width
	local strike = cc.LayerColor:create(cc.c4b(230, 50, 50, 255), sw + 6, 2)
	strike:setPosition(cc.p(textX - 3, 55))
	root:addChild(strike)

	local price = ccui.Text:create(tostring(o.price), fontName, 24)
	price:setAnchorPoint(cc.p(0, 0.5))
	price:setPosition(cc.p(textX + sw + 14, 56))
	price:setColor(cc.c3b(255, 220, 90))
	price:enableOutline(cc.c4b(60, 30, 0, 255), 2) -- se lee sobre el papel claro de Naruto (1-oct)
	root:addChild(price)
	local px = textX + sw + 20 + price:getVirtualRendererSize().width

	local coin = ccui.ImageView:create("images/ui/props/props_8303.png")
	coin:setScale(0.35)
	coin:setPosition(cc.p(px + 14, 56))
	root:addChild(coin)

	if o.list_price > o.price then
		local pct = math.floor((o.list_price - o.price) * 100 / o.list_price + 0.5)
		local off = ccui.Text:create(string.format("-%d%%", pct), fontName, 20)
		off:setAnchorPoint(cc.p(0, 0.5))
		off:setPosition(cc.p(px + 36, 56))
		off:setColor(cc.c3b(255, 90, 60))
		root:addChild(off)
	end

	local left = ccui.Text:create(string.format(text(7), math.max(0, o.limit - o.bought), o.limit), fontName, 18)
	left:setAnchorPoint(cc.p(0, 0.5))
	left:setPosition(cc.p(textX, 22))
	left:enableOutline(cc.c4b(60, 30, 0, 255), 2)
	root:addChild(left)

	local list = fwin:furyRowRewardList(root)
	list:removeAllItems()
	list:setPositionX(textX + textWidth + 10)
	for _, r in ipairs(rewards(o.gain)) do
		local cell = ResourcesIconCell:createCell()
		cell:init(r[1], r[2], r[3], nil, nil, true, true, 1)
		cell:setScale(0.7)
		cell:setPosition(cc.p(0, 18))
		local slot = ccui.Layout:create()
		slot:setContentSize(cc.size(80, 120))
		slot:addChild(cell)
		list:addChild(slot)
	end
	list:requestRefreshView()

	local soldOut = o.bought >= o.limit
	local button = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
	if soldOut then
		button:setTitleText(text(6))
	else
		button:setTitleText(text(5))
	end
	button:setTitleFontName(fontName)
	button:setTitleFontSize(22)
	button:setTitleColor(cc.c3b(90, 45, 10))
	button:setPosition(cc.p(size.width - 70, size.height / 2))
	fwin:fitButtonTitle(button)
	root:addChild(button)
	if soldOut then
		button:setBright(false)
		button:setTouchEnabled(false)
	else
		fwin:addTouchEventListener(button, nil,
		{ terminal_name = "fury_flash_offers_buy", terminal_state = 0,
		  isPressedActionEnabled = true, offer = o }, nil, 0)
	end

	local row = ccui.Layout:create()
	row:setContentSize(size)
	row:addChild(root)
	return row
end

function FuryFlashOffers:onExit()
	if self.tick ~= nil then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.tick)
		self.tick = nil
	end
	self.timerLabel = nil
end

-----------------------------------------------------------------------------------------------
-- La ventana de reglas (el «?»): utils/common_popup_rule.csb con los textos 12 y 13.
-----------------------------------------------------------------------------------------------
FuryFlashOffersRules = class("FuryFlashOffersRulesClass", Window)

function FuryFlashOffersRules:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryFlashOffersRules:init()
	self:setTouchEnabled(true)
	local csbNode = csb.createNode("utils/common_popup_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	local title = ccui.Helper:seekWidgetByName(root, "Text_tittle")
	if title ~= nil then
		title:setString(text(11))
	end
	local body = ccui.Helper:seekWidgetByName(root, "Text_1")
	if body ~= nil then
		body:setString(text(12) .. "\n" .. text(13))
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{ terminal_name = "fury_flash_offers_rules_close", terminal_state = 0, isPressedActionEnabled = true }, nil, 0)
	return self
end

function FuryFlashOffersRules:onExit()
end

-----------------------------------------------------------------------------------------------
-- EL ICONO DE LA CIUDAD (Home.lua; activity_type 29170, sin fila en activity_sorting_mould).
-----------------------------------------------------------------------------------------------
FuryFlashOffersCell = class("FuryFlashOffersCellClass", Window)

function FuryFlashOffersCell:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryFlashOffersCell:init()
	local csbCell = csb.createNode("activity/icon/activity_shizishou.csb")
	local root = csbCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	self:setContentSize(root:getContentSize())
	local button = ccui.Helper:seekWidgetByName(root, "Button_act_but")
	local art = "images/ui/text/sm_hd/zc_icon_fury_flash.png"
	button:loadTextures(art, art, art)
	local label = fwin:furyCityIconCaption(root)
	if label ~= nil then
		label:setString(text(1))
		label:setVisible(true)
		fitWidth(label, 74)
	end
	fwin:furyCityIconLabel(label)
	local timer = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
	if timer ~= nil then
		timer:setString("")
	end
	fwin:addTouchEventListener(button, nil,
	{ terminal_name = "fury_flash_offers_open", terminal_state = 0, isPressedActionEnabled = true }, nil, 0)
end

function FuryFlashOffersCell:createCell()
	local cell = FuryFlashOffersCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function FuryFlashOffersCell:onExit()
end
