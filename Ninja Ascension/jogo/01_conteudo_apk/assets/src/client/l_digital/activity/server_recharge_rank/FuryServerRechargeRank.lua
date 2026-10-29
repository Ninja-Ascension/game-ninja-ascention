-----------------------------------------------------------------------------------------------
-- EL RANKING DE RECARGA DEL SERVIDOR (encargo de Victor, 6-oct-2026;
-- docs/systems/ranking_recarga_servidor.md).
--
-- El hermano POR SERVIDOR del «Ranking de recarga» entre servidores (20004): solo compiten los
-- del mismo servidor, en rondas de 3 dias, siempre a la vez que el 20004. El cliente no trae un
-- tipo nativo para esto, asi que se reusa ENTERA la ventana del 20004 (RechargeWindow: pestanas,
-- tablon, reglas, S2C 13037/13038) con dos comandos PROPIOS y un icono propio en la ciudad.
--
--   icono:   el del 20004 de cada juego (activity/icon/acyivity_recharge_ranking.csb) con el
--            rotulo «Mi servidor» encima, al estilo de los iconos nuevos (fwin:furyCityIconLabel);
--   ventana: RechargeWindow con params.fury_scope = "server" (RechargeWindow.lua pide aqui sus
--            comandos con FuryServerRechargeRank_command y se titula con
--            FuryServerRechargeRank_decorate); la ventana de reglas lista los «servidores del
--            evento» con serverGroup, que aqui es SOLO el del jugador.
-- Textos: `_fury_server_recharge_rank_text` de TipStringInfo.lua (13 idiomas).
--
-- PROTOCOLO (comandos PROPIOS, fury_legacy_activity_games.erl), por el transporte de siempre:
--   C2S 29230 fury_server_recharge_rank_init   rol                  -> S2C 13037 (como el 9093)
--   C2S 29231 fury_server_recharge_rank_order  rol, desde, hasta    -> S2C 13038 (como el 9094)
-- El servidor manda: la ronda, el tablon y los premios salen de su base.
-----------------------------------------------------------------------------------------------
local INIT_CODE, ORDER_CODE = 29230, 29231
local FONT = "fonts/FZYiHei-M20S.ttf"

local function text(i)
	return _fury_server_recharge_rank_text ~= nil and tostring(_fury_server_recharge_rank_text[i] or "") or ""
end

local function rank_command(key)
	return function(str)
		local item = protocol_command[key]
		return str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
	end
end

-- El comando de esta ventana para «init» u «order». Idempotente: da de alta los dos la primera vez.
-- Los bloques de respuesta (13037/13038) son los del 20004 y ya estan en protocol_parse.
function FuryServerRechargeRank_command(kind)
	protocol_command.fury_server_recharge_rank_init = protocol_command.fury_server_recharge_rank_init or
		{ code = INIT_CODE, command = "fury_server_recharge_rank_init",
		  command_fun = rank_command("fury_server_recharge_rank_init"), param_list = "" }
	protocol_command.fury_server_recharge_rank_order = protocol_command.fury_server_recharge_rank_order or
		{ code = ORDER_CODE, command = "fury_server_recharge_rank_order",
		  command_fun = rank_command("fury_server_recharge_rank_order"), param_list = "" }
	return protocol_command["fury_server_recharge_rank_" .. kind]
end

-- El titulo de la ventana: el arte del 20004 dice «X-Server Recharge Ranking»; aqui se tapa con
-- el rotulo del idioma en el mismo sitio.
function FuryServerRechargeRank_decorate(root)
	local art = ccui.Helper:seekWidgetByName(root, "Image_bt")
	if art == nil then
		return
	end
	art:setVisible(false)
	local title = ccui.Text:create(text(2), FONT, 34)
	title:setAnchorPoint(cc.p(0.5, 0.5))
	title:setTextColor(cc.c4b(255, 238, 110, 255))
	title:enableOutline(cc.c4b(35, 12, 0, 255), 3)
	title:enableShadow(cc.c4b(0, 0, 0, 200), cc.size(2, -2), 0)
	local room = art:getContentSize().width * art:getScaleX()
	local w = title:getVirtualRendererSize().width
	if room > 0 and w > room then
		title:setScale(room / w)
	end
	-- En el centro del dibujo que tapa, pero nunca por debajo del borde de arriba del marco de la
	-- ventana: en Naruto el texto del dibujo va en su parte de arriba y en el centro el rotulo
	-- pisaba las pestanas (LDPlayer 6-oct, v16; recharge_ranking.csb: Image_bt 696x274 en
	-- (356,467), marco hasta 499).
	local box = art:getBoundingBox()
	local y = box.y + box.height / 2
	local frame = ccui.Helper:seekWidgetByName(root, "Image_recharge_ranking_bar")
	if frame ~= nil and frame:getParent() == art:getParent() then
		local f = frame:getBoundingBox()
		y = math.max(y, f.y + f.height + title:getVirtualRendererSize().height * title:getScaleY() / 2)
	end
	title:setPosition(cc.p(box.x + box.width / 2, y))
	art:getParent():addChild(title, art:getLocalZOrder() + 1)
end

local fury_server_recharge_rank_open_terminal = {
	_name = "fury_server_recharge_rank_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		FuryServerRechargeRank_command("init")
		state_machine.excute("menu_clean_page_state", 0, "home")
		app.load("client.activity.recharge.RechargeWindow")
		state_machine.excute("recharge_window_open", 0, { fury_scope = "server" })
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fury_server_recharge_rank_open_terminal)
state_machine.init()

-----------------------------------------------------------------------------------------------
-- El icono de la ciudad: el del 20004 con «Mi servidor» encima.
-----------------------------------------------------------------------------------------------

-- Su sitio en la ciudad: JUSTO DETRAS del 20004 (Home.lua lo pide al anadirlo al grupo). Donde el
-- cliente ordena los iconos con `activity_sorting_mould` (Fury: el 20004 va en la fila 1, orden
-- 1013) toma la fila del 20004 y su orden + 0.5; sin esa tabla (Naruto, One Piece, Digimon) manda
-- el orden de insercion, que ya es detras del suyo, y se queda con `default`.
-- Sin esto, en Fury caia en la fila 2 con el orden 10000 (el de los que no estan en la tabla):
-- lejos del 20004 y con su rotulo debajo del de la fila de arriba (LDPlayer 6-oct, v89).
function FuryServerRechargeRank_lineType(cell, default)
	if dms ~= nil and dms["activity_sorting_mould"] ~= nil and activity_sorting_mould ~= nil then
		local row = dms.searchs(dms["activity_sorting_mould"], activity_sorting_mould.activityID, 20004)
		if row ~= nil and row[1] ~= nil then
			cell.sortID = dms.atoi(row[1], activity_sorting_mould.sortID) + 0.5
			return dms.atoi(row[1], activity_sorting_mould.lineType)
		end
	end
	return default
end
FuryServerRechargeRankCell = class("FuryServerRechargeRankCellClass", Window)

function FuryServerRechargeRankCell:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryServerRechargeRankCell:init()
	local csbCell = csb.createNode("activity/icon/acyivity_recharge_ranking.csb")
	local root = csbCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	local size = root:getContentSize()
	self:setContentSize(size)

	local button = ccui.Helper:seekWidgetByName(root, "Button_act_but")
	local caption = ccui.Text:create(text(1), FONT, 19)
	caption:setAnchorPoint(cc.p(0.5, 0.5))
	-- Sobre el cofre, no en el borde de arriba: ahi lo tapaba el rotulo del icono de la fila de
	-- encima, y a media altura pisaba el «Ranking» del dibujo (LDPlayer 6-oct, v89).
	caption:setPosition(cc.p(size.width / 2, size.height * 0.62))
	root:addChild(caption, 10)
	fwin:furyCityIconLabel(caption)
	fwin:addTouchEventListener(button, nil,
	{
		terminal_name = "fury_server_recharge_rank_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
end

function FuryServerRechargeRankCell:createCell()
	local cell = FuryServerRechargeRankCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function FuryServerRechargeRankCell:onExit()
end
