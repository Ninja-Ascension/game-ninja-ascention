-----------------------------------------------------------------------------------------------
-- EL PASE DE ENERGIA SEMANAL (Fury, sistema 17, 30-sep-2026; docs/systems/pase_energia.md).
--
-- Una fila mas en la tienda de suscripciones (FurySubscriptionShop.lua la pinta
-- al final de su lista con FuryEnergyPass_createRow). Misma maqueta que las filas
-- de paquete: activity/wonderful/sm_limited_time_equip_box_help_list_2.csb,
-- ResourcesIconCell y el boton images/ui/button/btn_1.png. Textos:
-- `_fury_energy_pass_text` (TipStringInfo.lua, 12 idiomas) y los de la tienda
-- (`_fury_subscription_text` 3 «%d dias», 4 «Comprar», 5 «Activa: quedan %d
-- dias», 7 «sin saldo», 8 «¿Comprar %s por %d?», 12 «Precio: %d»).
--
-- EL PROTOCOLO: tres comandos PROPIOS, dados de alta aqui como los de la tienda.
--   C2S 29180 fury_energy_pass_view    rol
--   C2S 29181 fury_energy_pass_buy     rol
--   C2S 29182 fury_energy_pass_refill  rol
--   S2C 29189 saldo, precio, dias, bonus diario, estado (0 comprar, 1 activo),
--             dias que quedan, recarga gratis de hoy libre (1/0).
-- El aguante llega en el S2C 29 de siempre (parse_add_food): la barra superior
-- lo lee en su onUpdate (UserTopInfoA.lua:149-160), asi que se repinta sola.
-- El servidor manda (energy_pass.erl): precio, bonus y recarga salen de la base.
-----------------------------------------------------------------------------------------------
local VIEW_CODE, BUY_CODE, REFILL_CODE, PARSER_CODE = 29180, 29181, 29182, 29189
local CAPSULE_MOULD = 248 -- icono de adorno: la capsula de aguante mediana
local FOOD_TYPE = 12      -- ResourcesIconCell: 12 = aguante (resources_icon_cell.lua:35-46)
local CODES = {
	fury_energy_pass_view = VIEW_CODE,
	fury_energy_pass_buy = BUY_CODE,
	fury_energy_pass_refill = REFILL_CODE,
}

local function text(i)
	return _fury_energy_pass_text ~= nil and _fury_energy_pass_text[i] or ""
end

local function shopText(i)
	return _fury_subscription_text ~= nil and _fury_subscription_text[i] or ""
end

local function pass_command(key)
	return function(str)
		local item = protocol_command[key]
		return str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
	end
end

local function parse_fury_energy_pass(interpreter, datas, pos, strDatas, list, count)
	local p = {}
	p.balance = tonumber(npos(list)) or 0
	p.price = tonumber(npos(list)) or 0
	p.days = tonumber(npos(list)) or 0
	p.bonus = tonumber(npos(list)) or 0
	p.state = tonumber(npos(list)) or 0
	p.left = tonumber(npos(list)) or 0
	p.refill = tonumber(npos(list)) or 0
	_ED.fury_energy_pass = p
end

-- Da de alta (o vuelve a dar) los tres comandos y el bloque. Idempotente.
local function ensureProtocol()
	for name, code in pairs(CODES) do
		if protocol_command[name] == nil then
			protocol_command[name] = { code = code, command = name,
				command_fun = pass_command(name), param_list = "" }
		end
	end
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER_CODE, parser = "parse_fury_energy_pass",
		parser_fun = parse_fury_energy_pass })
end

local function redraw()
	local window = fwin:find("FurySubscriptionShopClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
end

local function send(code, okText)
	ensureProtocol()
	local function callback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if okText ~= nil then
				TipDlg.drawTextDailog(okText)
			end
			redraw()
		elseif code ~= VIEW_CODE then
			-- El rechazo ya lo pinta el cliente con su error_code; se repinta
			-- con lo que diga el servidor.
			send(VIEW_CODE, nil)
		end
	end
	NetworkManager:register(code, nil, nil, nil, nil, callback, false, nil)
end

-- La tienda lo llama al recibir su propia vista. Si el pase esta apagado el
-- servidor no manda el 29189 y la fila no sale.
function FuryEnergyPass_requestView()
	_ED.fury_energy_pass = nil
	send(VIEW_CODE, nil)
end

-- Las reglas 8 y 9 para la ventana «?» de la tienda.
function FuryEnergyPass_rules()
	local p = _ED.fury_energy_pass
	local days = p ~= nil and p.days or 7
	local bonus = p ~= nil and p.bonus or 0
	return string.format(text(6), days) .. "\n" .. string.format(text(7), bonus)
end

local fury_energy_pass_buy_terminal = {
	_name = "fury_energy_pass_buy",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local p = _ED.fury_energy_pass
		if p == nil then
			return true
		end
		if p.balance < p.price then
			TipDlg.drawTextDailog(shopText(7))
			return true
		end
		state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, {
			terminal_name = "fury_energy_pass_buy_confirmed",
			terminal_state = 0,
			_msg = string.format(shopText(8), text(1), p.price),
			_datas = {},
		})
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_energy_pass_buy_confirmed_terminal = {
	_name = "fury_energy_pass_buy_confirmed",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if params ~= nil and params.status == 1 then
			send(BUY_CODE, text(5))
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_energy_pass_refill_terminal = {
	_name = "fury_energy_pass_refill",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		send(REFILL_CODE, text(4))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fury_energy_pass_buy_terminal)
state_machine.add(fury_energy_pass_buy_confirmed_terminal)
state_machine.add(fury_energy_pass_refill_terminal)
state_machine.init()

local function fitWidth(label, width)
	local w = label:getVirtualRendererSize().width
	if w > width then
		label:setScale(width / w)
	end
end

-- La fila del pase (nil si el servidor aun no la ha mandado).
function FuryEnergyPass_createRow(fontName)
	local p = _ED.fury_energy_pass
	if p == nil then
		return nil
	end
	local csbRow = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help_list_2.csb")
	local root = csbRow:getChildByName("root")
	root:removeFromParent(false)
	local size = root:getContentSize()

	-- El dibujo es la capsula; el toque abre la descripcion del PASE (nombre, dias, lo que da cada
	-- dia y el precio), no la ficha de la capsula (Victor, 30-sep).
	local icon = ResourcesIconCell:createCell()
	icon:init(6, 1, CAPSULE_MOULD, nil, nil, false, false, 1)
	icon:setScale(0.7)
	icon:setPosition(cc.p(14, 20))
	root:addChild(icon)
	if FurySubscriptionShop_infoOnTap ~= nil then
		FurySubscriptionShop_infoOnTap(icon, text(1) .. " - " .. string.format(shopText(3), p.days),
			text(2) .. "\n"
			.. FurySubscriptionShop_stripNumber(string.format(text(6), p.days)) .. "\n"
			.. FurySubscriptionShop_stripNumber(string.format(text(7), p.bonus)) .. "\n"
			.. FurySubscriptionShop_priceText(p.price))
	end

	local textX, textWidth = 100, 170
	local name = ccui.Helper:seekWidgetByName(root, "Text_ranking")
	name:setString(text(1) .. " - " .. string.format(shopText(3), p.days))
	name:setAnchorPoint(cc.p(0, 0.5))
	name:setPosition(cc.p(textX, 84))
	fitWidth(name, textWidth)

	local status = fwin:furyRowStatus(root)
	status:setFontSize(20)
	status:setAnchorPoint(cc.p(0, 0.5))
	status:setPosition(cc.p(textX, 36))
	if p.state == 1 then
		status:setString(string.format(shopText(5), p.left))
		status:setColor(cc.c3b(80, 230, 80))
	else
		status:setString(string.format(shopText(12), p.price))
		status:setColor(cc.c3b(255, 220, 90))
	end
	fitWidth(status, textWidth)

	-- Lo que da: el aguante de cada dia y el rotulo con la recarga gratis.
	local rewards = fwin:furyRowRewardList(root)
	rewards:removeAllItems()
	rewards:setPositionX(textX + textWidth + 10)
	local cell = ResourcesIconCell:createCell()
	cell:init(FOOD_TYPE, p.bonus, -1, nil, nil, true, true, 1)
	cell:setScale(0.7)
	cell:setPosition(cc.p(0, 18))
	local slot = ccui.Layout:create()
	slot:setContentSize(cc.size(80, 120))
	slot:addChild(cell)
	rewards:addChild(slot)
	local desc = ccui.Text:create(text(2), fontName, 18)
	desc:setAnchorPoint(cc.p(0, 0.5))
	desc:setPosition(cc.p(0, 60))
	fitWidth(desc, 150)
	local descSlot = ccui.Layout:create()
	descSlot:setContentSize(cc.size(150, 120))
	descSlot:addChild(desc)
	rewards:addChild(descSlot)
	rewards:requestRefreshView()

	-- Sin pase: «Comprar». Con pase: «Recarga gratis» (apagado si ya se uso hoy).
	local button = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
	button:setTitleText(p.state == 1 and text(3) or shopText(4))
	button:setTitleFontName(fontName)
	button:setTitleFontSize(22)
	button:setTitleColor(cc.c3b(90, 45, 10))
	button:setPosition(cc.p(size.width - 70, size.height / 2))
	fwin:fitButtonTitle(button)
	root:addChild(button)
	local terminal = nil
	if p.state == 0 then
		terminal = "fury_energy_pass_buy"
	elseif p.refill == 1 then
		terminal = "fury_energy_pass_refill"
	end
	if terminal ~= nil then
		fwin:addTouchEventListener(button, nil,
		{
			terminal_name = terminal,
			terminal_state = 0,
			isPressedActionEnabled = true,
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
