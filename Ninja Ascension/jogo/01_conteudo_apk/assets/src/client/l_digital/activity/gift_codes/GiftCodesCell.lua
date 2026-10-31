-----------------------------------------------------------------------------------------------
-- EL ICONO «CODIGOS» DE LA CIUDAD (punto 7.26, 24-sep-2026).
--
-- Lo pone Home:onUpdateDrawEx (activity_type 20008, sin fila en
-- activity_sorting_mould: va al final). Abre GiftCodesWindow.
--
-- MAQUETA REUTILIZADA: activity/icon/activity_shizishou.csb, el icono del 84
-- (狮子兽), que esta variante NO pone nunca en la ciudad (Home.lua no crea
-- ACTIVITY_HOME_SHIZISHOW). Su dibujo, zc_icon_28.png, trae la franja del
-- rotulo EN BLANCO y el rotulo es texto de fuente (Text_login_gift_p_0), asi
-- que «Codigos» sale en los 12 idiomas desde TipStringInfo sin tocar imagenes.
-- OJO: en la maqueta ese texto es el aviso «Collect» del 84 y viene OCULTO
-- (visible = 0 en la base y en los 11 .csb de idioma): hay que encenderlo.
-- La fuente (FZYiHei-M20S) trae todas las letras de los 12 rotulos.
--
-- NARUTO (26-sep-2026): el paquete de Naruto no trae activity_shizishou.csb.
-- Se monto clonando activity_denglusongli.csb (icono de la ciudad de Naruto,
-- rotulo QUEMADO en el PNG y sin Text): apunta a zc_icon_98.png, el cofre de
-- zc_icon_22 con «Codes» quemado (tools/gen_rotulo_icono_naruto.py). Aqui no
-- hay Text_login_gift_p_0, asi que la rama del rotulo de abajo no corre.
--
-- Y LA VENTANA DEL DIA: la primera vez que la ciudad se pinta en un dia de juego
-- con codigos NUEVOS (clase 2 del S2C 342), se abre sola. El dia visto se guarda
-- por cuenta y servidor (writeKey), y nunca durante el tutorial.
-----------------------------------------------------------------------------------------------
GiftCodesCell = class("GiftCodesCellClass", Window)

local gift_codes_cell_open_terminal = {
	_name = "gift_codes_cell_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		state_machine.excute("gift_codes_window_open", 0, "")
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(gift_codes_cell_open_terminal)
state_machine.init()

function GiftCodesCell:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.l_digital.activity.gift_codes.GiftCodesWindow")
end

function GiftCodesCell:init()
	local csbCell = csb.createNode("activity/icon/activity_shizishou.csb")
	local root = csbCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	self:setContentSize(root:getContentSize())

	-- zc_icon_28.png sin la franja azul del rotulo (pedido de Victor, 30-sep).
	local art = "images/ui/text/sm_hd/zc_icon_fury_codes.png"
	ccui.Helper:seekWidgetByName(root, "Button_act_but"):loadTextures(art, art, art)
	local label = fwin:furyCityIconCaption(root)
	if label ~= nil then
		label:setString(tipStringInfo_gift_codes[1])
		label:setVisible(true)
		-- la franja azul mide 78 de los 80 del dibujo
		GiftCodesWindow_fitWidth(label, 74)
	end
	fwin:furyCityIconLabel(label)
	local timer = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
	if timer ~= nil then
		timer:setString("")
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_act_but"), nil,
	{
		terminal_name = "gift_codes_cell_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self:popupOncePerDay()
end

function GiftCodesCell:popupOncePerDay()
	-- Victor 26-sep: la ventana se abre sola al ABRIR el juego (una vez por
	-- arranque, no una vez al dia) si el personaje pasa del nivel 6.
	if not GiftCodesWindow_shouldPopupAtStart(_ED.activity_request_address,
			_ED.user_info and _ED.user_info.user_grade, _gift_codes_popup_at_start_done) then
		return
	end
	fwin:addService({
		callback = function()
			-- Nunca encima del tutorial: su mascara se traga la X y la partida
			-- se queda atascada (visto en Naruto). Si hay tutorial no se marca
			-- como mostrada: saldra en la siguiente vuelta a la ciudad.
			if missionIsOver() ~= true or fwin:find("TuitionControllerClass") ~= nil then
				return
			end
			_gift_codes_popup_at_start_done = true
			state_machine.excute("gift_codes_window_open", 0, "")
		end,
		delay = 1.0,
	})
end

function GiftCodesCell:createCell()
	local cell = GiftCodesCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function GiftCodesCell:onExit()
end
