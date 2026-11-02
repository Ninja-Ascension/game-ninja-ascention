-----------------------------------------------------------------------------------------------
-- LA TIENDA DE SUSCRIPCIONES (Fury, 29-sep-2026; docs/systems/suscripciones.md).
--
-- Cambio de Victor: «suscripciones va a ser como una TIENDA: ahi veran los
-- articulos, NO desde la bolsa». El cliente original no trae ninguna pantalla
-- de suscripcion: esta es Lua nuevo montado SOLO con maquetas y arte que ya
-- vienen en el paquete (en los 12 idiomas):
--   icono de la ciudad: activity/icon/activity_shizishou.csb (la maqueta del
--            icono «Codigos», GiftCodesCell.lua) con el dibujo nuevo
--            zc_icon_fury_subs.png (boleto morado 8302 + moneda 8303 sobre la
--            franja en blanco de zc_icon_28.png);
--   ventana: activity/wonderful/sm_limited_time_equip_box_help.csb
--            (Text_title, ListView_xsbx_rule, Button_closed), la de los codigos;
--   fila:    activity/wonderful/sm_limited_time_equip_box_help_list_2.csb
--            (Text_ranking, Text_kehuode, ListView_ranking_reward_2);
--   fichas:  ResourcesIconCell (icono + cantidad), boton images/ui/button/btn_1.png;
--   ayuda:   boton images/ui/button/icon_wenhao.png («?») y la ventana de
--            reglas utils/common_popup_rule.csb (Text_tittle, Text_1, Button_close);
--   confirmar: ConfirmTip (shortcut_open_function_dailog_cancel_and_ok).
-- Los textos: `_fury_subscription_text` de TipStringInfo.lua (12 idiomas).
--
-- EL PROTOCOLO: dos comandos PROPIOS por el transporte de siempre (el sobre de
-- texto por HTTP). Se dan de alta aqui, en las tablas del propio cliente
-- (`protocol_command` y `protocol_parse`), cada vez que se van a usar: si el
-- juego recarga el protocolo (volver a entrar) las tablas son nuevas.
--   C2S 29001 fury_subscription_view  rol
--   C2S 29002 fury_subscription_buy   rol, paquete
--   S2C 29101 la tienda: saldo, bonus VIP %, n, y por paquete: id, molde del
--             objeto (nombre/icono), dias, precio, estado (0 comprar, 1 activa,
--             2 comprada esta semana), dias que quedan, premios del dia ya con
--             el VIP («tipo,molde,cantidad|...»).
-- El servidor manda (fury_legacy_subscription.erl / subscription.erl): precio,
-- cantidades y estado salen de la base; el cliente solo dice QUE paquete.
-----------------------------------------------------------------------------------------------
FurySubscriptionShop = class("FurySubscriptionShopClass", Window)

local VIEW_CODE, BUY_CODE, PARSER_CODE = 29001, 29002, 29101
local COIN_MOULD = 3396 -- NARUTO: las Monedas premium de Naruto (Fury 3436)
-- La regla 7 (cada recarga da monedas premium) solo se enseña cuando el
-- servidor la cumpla: pendiente de la autorizacion de fury_payment.
FurySubscriptionShop_SHOW_TOPUP_RULE = true

local function text(i)
	return _fury_subscription_text ~= nil and _fury_subscription_text[i] or ""
end

local function sub_command(key)
	return function(str)
		local item = protocol_command[key]
		str = str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
		return str
	end
end

local function parse_fury_subscription(interpreter, datas, pos, strDatas, list, count)
	local shop = { packages = {} }
	shop.balance = tonumber(npos(list)) or 0
	shop.bonus = tonumber(npos(list)) or 0
	local n = tonumber(npos(list)) or 0
	for i = 1, n do
		local p = {}
		p.id = tonumber(npos(list)) or 0
		p.mould = tonumber(npos(list)) or 0
		p.days = tonumber(npos(list)) or 0
		p.price = tonumber(npos(list)) or 0
		p.state = tonumber(npos(list)) or 0
		p.left = tonumber(npos(list)) or 0
		p.rewards = npos(list) or ""
		shop.packages[#shop.packages + 1] = p
	end
	_ED.fury_subscription = shop
end

-- Da de alta (o vuelve a dar) los dos comandos y el bloque. Idempotente.
function FurySubscriptionShop_ensureProtocol()
	protocol_command.fury_subscription_view = protocol_command.fury_subscription_view or
		{ code = VIEW_CODE, command = "fury_subscription_view",
		  command_fun = sub_command("fury_subscription_view"), param_list = "" }
	protocol_command.fury_subscription_buy = protocol_command.fury_subscription_buy or
		{ code = BUY_CODE, command = "fury_subscription_buy",
		  command_fun = sub_command("fury_subscription_buy"), param_list = "" }
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER_CODE, parser = "parse_fury_subscription",
		parser_fun = parse_fury_subscription })
end

-- «tipo,molde,cantidad|...» -> {{tipo, cantidad, molde}, ...}
function FurySubscriptionShop_rewards(str)
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

-- El texto de ayuda: las reglas 13..18 (y la 19 cuando toque), una por linea.
function FurySubscriptionShop_rules()
	local lines = {}
	local last = FurySubscriptionShop_SHOW_TOPUP_RULE and 19 or 18
	for i = 13, last do
		lines[#lines + 1] = text(i)
	end
	if FuryEnergyPass_rules ~= nil then
		lines[#lines + 1] = FuryEnergyPass_rules()
	end
	return table.concat(lines, "\n")
end

local function fitWidth(label, width)
	local w = label:getVirtualRendererSize().width
	if w > width then
		label:setScale(width / w)
	end
end

-- Paquetes 3-5 (migracion 1826): sus objetos 3397-3399 son filas de relleno de prop_mould, asi
-- que el nombre sale de _fury_subscription_text[18 + id] y el icono de un objeto real.
-- NARUTO: los moldes de Naruto (Fury 1539 -> 1000 fragmento universal avanzado, 3480 -> 3440 insignia).
-- El 5 (Suprema) pintaba el cofre de SELECCION 2877 (Fury 2697), que Victor quito de las tiendas
-- (30-sep): ahora el boleto nuevo de la Suscripcion Premium (3395, props_8302, iconos_objetos_nuevos.md).
local EXTRA_ICON = { [3] = 1000, [4] = 3440, [5] = 3395 }
local function packageIcon(p)
	return EXTRA_ICON[p.id] or p.mould
end

-- Victor, 30-sep: todo articulo ensena su DESCRIPCION con un toque. Los paquetes 3-5 y el pase de
-- energia llevan el dibujo de OTRO objeto, asi que su toque no abre la ficha de ese objeto: abre
-- la descripcion del PAQUETE en la ventana de reglas (titulo + texto). Zona invisible encima del
-- icono que no se traga el arrastre de la lista.
function FurySubscriptionShop_infoOnTap(icon, title, body)
	local hit = ccui.Layout:create()
	hit:setContentSize(icon:getContentSize())
	hit:setPosition(cc.p(icon:getPositionX(), icon:getPositionY()))
	hit:setTouchEnabled(true)
	hit:setSwallowTouches(false)
	hit:addTouchEventListener(function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local b = sender:getTouchBeganPosition()
			local e = sender:getTouchEndPosition()
			if math.abs(b.x - e.x) < 20 and math.abs(b.y - e.y) < 20
				and fwin:find("FurySubscriptionRulesClass") == nil then
				fwin:open(FurySubscriptionRules:new():init(title, body), fwin._ui)
			end
		end
	end)
	icon:getParent():addChild(hit)
end

-- «2. Recibes...» -> «Recibes...» (las reglas llevan su numero delante).
function FurySubscriptionShop_stripNumber(s)
	return (string.gsub(tostring(s or ""), "^%d+%.%s*", ""))
end

-- «Precio: N» con el texto de la tienda (lo usa tambien el pase de energia).
function FurySubscriptionShop_priceText(price)
	return string.format(text(12), tonumber(price) or 0)
end

-- La descripcion de un paquete: como llegan los premios, los premios de cada dia y el precio.
local function packageDescription(p)
	local lines = { FurySubscriptionShop_stripNumber(text(14)) }
	for _, r in ipairs(FurySubscriptionShop_rewards(p.rewards)) do
		local ok, info = pcall(getItemNameAndQuality, { r[1], r[3], r[2] })
		if ok and info ~= nil and info[1] ~= nil and tostring(info[1]) ~= "" then
			lines[#lines + 1] = "- " .. tostring(info[1]) .. " x" .. tostring(r[2])
		end
	end
	lines[#lines + 1] = FurySubscriptionShop_priceText(p.price)
	return table.concat(lines, "\n")
end

local function packageName(p)
	if p.id >= 3 and _fury_subscription_text ~= nil and _fury_subscription_text[18 + p.id] ~= nil then
		return tostring(_fury_subscription_text[18 + p.id])
	end
	local ok, info = pcall(getItemNameAndQuality, { 6, p.mould, 1 })
	if ok and info ~= nil and info[1] ~= nil then
		return tostring(info[1])
	end
	return ""
end

local function requestView(node)
	FurySubscriptionShop_ensureProtocol()
	local function callback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			local window = fwin:find("FurySubscriptionShopClass")
			if window ~= nil then
				window:onUpdateDraw()
			end
			if FuryEnergyPass_requestView ~= nil then
				FuryEnergyPass_requestView()
			end
		end
	end
	protocol_command.fury_subscription_view.param_list = ""
	NetworkManager:register(VIEW_CODE, nil, nil, nil, node, callback, false, nil)
end

local function requestBuy(packageId)
	FurySubscriptionShop_ensureProtocol()
	local function callback(response)
		-- Un rechazo (-609/-610/-74) ya lo pinta el cliente con su error_code;
		-- en los dos casos se repinta con lo que diga el servidor.
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			TipDlg.drawTextDailog(text(20))
			local window = fwin:find("FurySubscriptionShopClass")
			if window ~= nil then
				window:onUpdateDraw()
			end
		else
			requestView(nil)
		end
	end
	protocol_command.fury_subscription_buy.param_list = tostring(packageId)
	NetworkManager:register(BUY_CODE, nil, nil, nil, nil, callback, false, nil)
end

local fury_subscription_shop_open_terminal = {
	_name = "fury_subscription_shop_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("FurySubscriptionShopClass") == nil then
			_ED.fury_subscription = nil
			fwin:open(FurySubscriptionShop:new():init(), fwin._ui)
			requestView(nil)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_subscription_shop_close_terminal = {
	_name = "fury_subscription_shop_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FurySubscriptionShopClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- «Comprar»: comprueba el saldo que dijo el servidor y pide confirmacion.
local fury_subscription_shop_buy_terminal = {
	_name = "fury_subscription_shop_buy",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local p = params._datas.package
		local shop = _ED.fury_subscription
		if shop == nil or p == nil then
			return true
		end
		if shop.balance < p.price then
			TipDlg.drawTextDailog(text(7))
			return true
		end
		state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, {
			terminal_name = "fury_subscription_shop_buy_confirmed",
			terminal_state = 0,
			_msg = string.format(text(8), packageName(p), p.price),
			_datas = { package_id = p.id },
		})
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_subscription_shop_buy_confirmed_terminal = {
	_name = "fury_subscription_shop_buy_confirmed",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if params ~= nil and params.status == 1 and params._datas ~= nil then
			requestBuy(params._datas.package_id)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_subscription_shop_help_terminal = {
	_name = "fury_subscription_shop_help",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("FurySubscriptionRulesClass") == nil then
			fwin:open(FurySubscriptionRules:new():init(), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_subscription_rules_close_terminal = {
	_name = "fury_subscription_rules_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FurySubscriptionRulesClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- «Tienda Premium»: la pestaña del evento 70 en «Events», solo si el servidor
-- la anuncia (Tienda Premium permanente desde la migracion 1790,
-- docs/systems/tienda_premium.md).
local fury_subscription_shop_premium_terminal = {
	_name = "fury_subscription_shop_premium",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if _ED.active_activity ~= nil and _ED.active_activity[70] ~= nil then
			fwin:close(fwin:find("FurySubscriptionShopClass"))
			state_machine.excute("activity_window_open", 0,
				{ "client.activity.ActivityVarietyShopTwo", "VarietyShopTwo" })
			-- La ventana de eventos se monta despues de abrirse: el salto a la
			-- pestaña que pide activity_window_open llega antes y se pierde (se
			-- quedaba en «Contactanos», visto 30-sep). Se repite un momento despues.
			local scheduler = cc.Director:getInstance():getScheduler()
			local handle = nil
			handle = scheduler:scheduleScriptFunc(function()
				scheduler:unscheduleScriptEntry(handle)
				if fwin:find("ActivityWindowClass") ~= nil then
					state_machine.excute("activity_window_change_to_page", 0, "VarietyShopTwo")
				end
			end, 0.6, false)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fury_subscription_shop_open_terminal)
state_machine.add(fury_subscription_shop_close_terminal)
state_machine.add(fury_subscription_shop_buy_terminal)
state_machine.add(fury_subscription_shop_buy_confirmed_terminal)
state_machine.add(fury_subscription_shop_help_terminal)
state_machine.add(fury_subscription_rules_close_terminal)
state_machine.add(fury_subscription_shop_premium_terminal)
state_machine.init()

function FurySubscriptionShop:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.utils.ConfirmTip")
	-- Fury: el pase de energia, una fila mas de esta tienda (FuryEnergyPass.lua).
	app.load("client.l_digital.activity.subscription.FuryEnergyPass")
end

function FurySubscriptionShop:init()
	self:setTouchEnabled(true)
	self:onInit()
	return self
end

function FurySubscriptionShop:onInit()
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fury_subscription_shop_close",
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
		terminal_name = "fury_subscription_shop_help",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self:onUpdateDraw()
end

function FurySubscriptionShop:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local title = ccui.Helper:seekWidgetByName(root, "Text_title")
	local fontName = title:getFontName()
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	listView:removeAllItems()
	local shop = _ED.fury_subscription
	if shop == nil then
		return
	end
	local width = listView:getContentSize().width
	listView:addChild(self:createHeaderRow(shop, fontName, width))
	for _, p in ipairs(shop.packages) do
		listView:addChild(self:createPackageRow(p, fontName))
	end
	local energyRow = FuryEnergyPass_createRow ~= nil and FuryEnergyPass_createRow(fontName) or nil
	if energyRow ~= nil then
		listView:addChild(energyRow)
	end
	listView:requestRefreshView()
end

-- Saldo de monedas premium (con su icono) y el bonus VIP de los premios.
function FurySubscriptionShop:createHeaderRow(shop, fontName, width)
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

	local bonus = ccui.Text:create(string.format(text(11), shop.bonus), fontName, 20)
	bonus:setAnchorPoint(cc.p(0, 0.5))
	bonus:setPosition(cc.p(100, 36))
	row:addChild(bonus)

	if _ED.active_activity ~= nil and _ED.active_activity[70] ~= nil then
		local button = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
		button:setTitleText(text(9))
		button:setTitleFontName(fontName)
		button:setTitleFontSize(20)
		button:setTitleColor(cc.c3b(90, 45, 10))
		fwin:fitButtonTitle(button)
		button:setPosition(cc.p(width - 80, height / 2))
		row:addChild(button)
		fwin:addTouchEventListener(button, nil,
		{
			terminal_name = "fury_subscription_shop_premium",
			terminal_state = 0,
			isPressedActionEnabled = true,
		}, nil, 0)
	end
	return row
end

function FurySubscriptionShop:createPackageRow(p, fontName)
	local csbRow = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help_list_2.csb")
	local root = csbRow:getChildByName("root")
	root:removeFromParent(false)
	local size = root:getContentSize()

	-- El icono del paquete (el objeto 3434/3435 de la tabla, solo de adorno).
	-- 1-2: la ficha de su objeto (3434/3435) ya describe el paquete. 3-5: dibujo de otro objeto y
	-- el toque abre la descripcion del paquete.
	local own = EXTRA_ICON[p.id] == nil
	local icon = ResourcesIconCell:createCell()
	icon:init(6, 1, packageIcon(p), nil, nil, own, false, 1)
	icon:setScale(0.7)
	icon:setPosition(cc.p(14, 20))
	root:addChild(icon)
	if not own then
		FurySubscriptionShop_infoOnTap(icon,
			packageName(p) .. " - " .. string.format(text(3), p.days), packageDescription(p))
	end

	local textX, textWidth = 100, 170
	local name = ccui.Helper:seekWidgetByName(root, "Text_ranking")
	name:setString(packageName(p) .. " - " .. string.format(text(3), p.days))
	name:setAnchorPoint(cc.p(0, 0.5))
	name:setPosition(cc.p(textX, 84))
	fitWidth(name, textWidth)

	local status = fwin:furyRowStatus(root)
	status:setFontSize(20)
	status:setAnchorPoint(cc.p(0, 0.5))
	status:setPosition(cc.p(textX, 36))
	if p.state == 1 then
		status:setString(string.format(text(5), p.left))
		status:setColor(cc.c3b(80, 230, 80))
	elseif p.state == 2 then
		status:setString(text(6))
		status:setColor(cc.c3b(160, 160, 160))
	else
		status:setString(string.format(text(12), p.price))
		status:setColor(cc.c3b(255, 220, 90))
	end
	fitWidth(status, textWidth)

	-- Los premios de CADA DIA para este jugador (ya con su VIP).
	local rewards = fwin:furyRowRewardList(root)
	rewards:removeAllItems()
	rewards:setPositionX(textX + textWidth + 10)
	-- Que quepan todos antes del boton «Comprar» (con 5 premios el quinto quedaba debajo).
	local list = FurySubscriptionShop_rewards(p.rewards)
	local room = size.width - 150 - (textX + textWidth + 10)
	local slotW = math.min(80, math.floor(room / math.max(1, #list)))
	for _, r in ipairs(list) do
		local cell = ResourcesIconCell:createCell()
		cell:init(r[1], r[2], r[3], nil, nil, true, true, 1)
		cell:setScale(0.7 * slotW / 80)
		cell:setPosition(cc.p(0, 18))
		local slot = ccui.Layout:create()
		slot:setContentSize(cc.size(slotW, 120))
		slot:addChild(cell)
		rewards:addChild(slot)
	end
	rewards:requestRefreshView()

	local button = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
	button:setTitleText(text(4))
	button:setTitleFontName(fontName)
	button:setTitleFontSize(22)
	button:setTitleColor(cc.c3b(90, 45, 10))
	button:setPosition(cc.p(size.width - 70, size.height / 2))
	fwin:fitButtonTitle(button)
	root:addChild(button)
	if p.state == 0 then
		fwin:addTouchEventListener(button, nil,
		{
			terminal_name = "fury_subscription_shop_buy",
			terminal_state = 0,
			isPressedActionEnabled = true,
			package = p,
		}, nil, 0)
	else
		button:setBright(false)
		button:setTouchEnabled(false)
	end

	local row = ccui.Layout:create()
	row:setContentSize(size)
	row:addChild(root)
	return row
end

function FurySubscriptionShop:onExit()
end

-----------------------------------------------------------------------------------------------
-- La ventana de reglas (el «?»): utils/common_popup_rule.csb con el texto de
-- `_fury_subscription_text` 13..18.
-----------------------------------------------------------------------------------------------
FurySubscriptionRules = class("FurySubscriptionRulesClass", Window)

function FurySubscriptionRules:ctor()
	self.super:ctor()
	self.roots = {}
end

-- Sin argumentos, las reglas; con titulo y texto, la descripcion de un paquete.
function FurySubscriptionRules:init(titleText, bodyText)
	self:setTouchEnabled(true)
	local csbNode = csb.createNode("utils/common_popup_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	local title = ccui.Helper:seekWidgetByName(root, "Text_tittle")
	if title ~= nil then
		title:setString(titleText or text(10))
	end
	local body = ccui.Helper:seekWidgetByName(root, "Text_1")
	if body ~= nil then
		body:setString(bodyText or FurySubscriptionShop_rules())
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "fury_subscription_rules_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	return self
end

function FurySubscriptionRules:onExit()
end

-----------------------------------------------------------------------------------------------
-- EL ICONO DE LA CIUDAD (Home.lua, junto al de «Codigos»; activity_type 20009,
-- sin fila en activity_sorting_mould: va al final).
-----------------------------------------------------------------------------------------------
FurySubscriptionCell = class("FurySubscriptionCellClass", Window)

function FurySubscriptionCell:ctor()
	self.super:ctor()
	self.roots = {}
end

function FurySubscriptionCell:init()
	local csbCell = csb.createNode("activity/icon/activity_shizishou.csb")
	local root = csbCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	self:setContentSize(root:getContentSize())

	local button = ccui.Helper:seekWidgetByName(root, "Button_act_but")
	local art = "images/ui/text/sm_hd/zc_icon_fury_subs.png"
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
	{
		terminal_name = "fury_subscription_shop_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
end

function FurySubscriptionCell:createCell()
	local cell = FurySubscriptionCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function FurySubscriptionCell:onExit()
end
