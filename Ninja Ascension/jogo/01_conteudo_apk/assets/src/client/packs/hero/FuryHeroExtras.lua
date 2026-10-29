-----------------------------------------------------------------------------------------------
-- EL MARCO DE BOTONES DEL HEROE (Fury, sistema E, 29-sep-2026; docs/systems/marco_heroe.md).
--
-- Los sistemas nuevos del heroe (rango, artefactos, cronicas, arbol de pasivas, prohibidores,
-- pergaminos, pociones, runas, gemas) ponen su boton en la pantalla de detalle del heroe
-- (la pestaña de fortalecimiento, SmRoleStrengthenTab.lua, packs/HeroStorage/
-- sm_role_strengthen_tab.csb) SIN tocar esa pantalla: cada uno AÑADE UNA ENTRADA a
-- FuryHeroExtras.BUTTONS (aqui abajo) y escribe su ventana en su propio fichero.
--
-- Entrada:
--   id      texto corto unico (solo para el nombre del widget)
--   icon    ruta de una imagen que ya exista en res/ (se encaja a ICON_SIZE)
--   text    function() -> rotulo (de TipStringInfo, 12 idiomas)
--   level   nivel minimo del JUGADOR; por debajo el boton sale gris, con candado y «Nv. N»
--   module  modulo Lua de la ventana (se carga al pulsar: app.load)
--   open    terminal que abre la ventana; recibe { ship = _ED.user_ship[id] }
--
-- 30-sep-2026, cambio de Victor («se ven atascados»): la ficha pinta UN SOLO boton, «Mejoras»,
-- en el primer hueco libre de la rejilla de los nativos (junto a Aleacion Z, sin tapar el
-- modelo ni el nombre), y al pulsarlo abre un PANEL con los botones de BUTTONS en rejilla.
-- El panel es la maqueta de los Codigos y las Suscripciones
-- (activity/wonderful/sm_limited_time_equip_box_help.csb: Text_title, ListView_xsbx_rule,
-- Button_closed). Cada boton es el marco redondo de los botones del heroe sin dibujo
-- (images/ui/button/fury_hero_extra_btn.png) con el icono encima y el rotulo debajo.
-- Punto rojo: ningun sistema del marco tiene hoy logica de aviso, asi que «Mejoras» no lo lleva.
-----------------------------------------------------------------------------------------------
FuryHeroExtras = FuryHeroExtras or {}

FuryHeroExtras.BUTTONS = {
	-- Sistema E: rango / titulo del heroe (FuryHeroTitle.lua).
	{ id = "title", icon = "images/ui/props/props_8350.png",
	  text = function() return _fury_hero_title_text ~= nil and _fury_hero_title_text[1] or "Rank" end,
	  level = 1, module = "client.packs.hero.FuryHeroTitle", open = "fury_hero_title_open" },
	-- Sistema K: pociones del heroe (FuryHeroPotion.lua).
	{ id = "potion", icon = "images/ui/props/props_8483.png",
	  text = function() return _fury_potion_text ~= nil and _fury_potion_text[1] or "Potions" end,
	  level = 1, module = "client.l_digital.cultivate.potion.FuryHeroPotion", open = "fury_hero_potion_open" },
	-- Sistema G: la cronica de ese guerrero (FuryChronicle.lua; la global sale en la misma ventana).
	{ id = "chronicle", icon = "images/ui/props/props_8400.png",
	  text = function() return _fury_chronicle_text ~= nil and _fury_chronicle_text[1] or "Chronicles" end,
	  level = 25, module = "client.l_digital.activity.chronicle.FuryChronicle", open = "fury_chronicle_open" },
	-- Sistema I: prohibidores (FuryProhibitor.lua); global, el heroe no cambia nada.
	{ id = "prohibitor", icon = "images/ui/props/props_8442.png",
	  text = function() return _fury_prohibitor_text ~= nil and _fury_prohibitor_text[1] or "Prohibitors" end,
	  level = 1, module = "client.l_digital.prohibitor.FuryProhibitor", open = "fury_prohibitor_open" },
	-- Sistema F: artefactos de companero (FuryCompanionArtifact.lua).
	{ id = "artifact", icon = "images/ui/props/props_8370.png",
	  text = function() return _fury_companion_artifact_text ~= nil and _fury_companion_artifact_text[1] or "Artifact" end,
	  level = 1, module = "client.packs.hero.FuryCompanionArtifact", open = "fury_companion_artifact_open" },
	-- Sistema M: gemas del heroe (FuryHeroGem.lua).
	{ id = "gem", icon = "images/ui/props/props_8526.png",
	  text = function() return _fury_hero_gem_text ~= nil and _fury_hero_gem_text[1] or "Gems" end,
	  level = 1, module = "client.packs.hero.FuryHeroGem", open = "fury_hero_gem_open" },
	-- Sistema J: pergaminos del heroe (FuryHeroScroll.lua).
	{ id = "scroll", icon = "images/ui/props/props_8463.png",
	  text = function() return _fury_hero_scroll_text ~= nil and _fury_hero_scroll_text[1] or "Scroll" end,
	  level = 1, module = "client.packs.hero.FuryHeroScroll", open = "fury_hero_scroll_open" },
	-- Sistema L: runas del heroe (FuryHeroRune.lua).
	{ id = "rune", icon = "images/ui/props/props_8501.png",
	  text = function() return _fury_rune_text ~= nil and _fury_rune_text[1] or "Runes" end,
	  level = 10, module = "client.packs.hero.FuryHeroRune", open = "fury_hero_rune_open" },
	-- Sistema H: arbol de pasivas del heroe (FuryHeroPassiveTree.lua).
	{ id = "ptree", icon = "images/ui/props/props_8420.png",
	  text = function() return _fury_passive_tree_text ~= nil and _fury_passive_tree_text[1] or "Passive Tree" end,
	  level = 1, module = "client.packs.hero.FuryHeroPassiveTree", open = "fury_hero_ptree_open" },
}

-- 1-oct-2026, orden de Victor: gemas, pergaminos, runas y arbol de pasivas quedan OCULTOS hasta
-- una «nueva actualizacion» (docs/systems/sistemas_ocultos.md). No se borra nada: para volver a
-- encender uno, quitar su id de esta lista (y devolver sus objetos con la migracion inversa).
FuryHeroExtras.HIDDEN = { gem = true, scroll = true, rune = true, ptree = true }

-- Los botones que SI salen en el panel, en el orden de BUTTONS y sin huecos.
function FuryHeroExtras.visible()
	local list = {}
	for _, entry in ipairs(FuryHeroExtras.BUTTONS) do
		if not FuryHeroExtras.HIDDEN[entry.id] then
			list[#list + 1] = entry
		end
	end
	return list
end

FuryHeroExtras.FRAME = "images/ui/button/fury_hero_extra_btn.png"
FuryHeroExtras.MAIN_ICON = "images/ui/props/props_8350.png"
FuryHeroExtras.LOCK = "images/ui/icon/suo_01.png"
FuryHeroExtras.ICON_SIZE = 46
-- Rejilla de los botones nativos (coordenadas del .csb). La fila 528 es la del nombre del
-- heroe: el boton «Mejoras» va en el primer hueco libre desde la fila 450.
FuryHeroExtras.COLUMNS = { 452, 522, 590 }
FuryHeroExtras.FIRST_ROW, FuryHeroExtras.ROW_STEP, FuryHeroExtras.ROWS = 450, 70, 4
-- Botones nativos cuyo hueco se respeta cuando estan visibles.
FuryHeroExtras.NATIVE = { "Button_evo", "Button_fashion", "Button_rebirth", "Button_energy", "Button_matrix" }
-- Panel: botones por fila y alto de cada fila.
FuryHeroExtras.PANEL_COLUMNS, FuryHeroExtras.CELL_HEIGHT = 5, 150

local function text(i, fallback)
	return _fury_hero_extras_text ~= nil and _fury_hero_extras_text[i] or fallback
end

local function playerLevel()
	return tonumber(_ED.user_info ~= nil and _ED.user_info.user_grade or 0) or 0
end

-- Los huecos libres de la rejilla, de izquierda a derecha y de arriba abajo.
local function freeSlots(root)
	local busy = {}
	for _, name in ipairs(FuryHeroExtras.NATIVE) do
		local b = ccui.Helper:seekWidgetByName(root, name)
		if b ~= nil and b:isVisible() then
			busy[#busy + 1] = { b:getPositionX(), b:getPositionY() }
		end
	end
	local slots = {}
	for row = 0, FuryHeroExtras.ROWS - 1 do
		local y = FuryHeroExtras.FIRST_ROW - row * FuryHeroExtras.ROW_STEP
		for _, x in ipairs(FuryHeroExtras.COLUMNS) do
			local free = true
			for _, p in ipairs(busy) do
				if math.abs(p[1] - x) < 20 and math.abs(p[2] - y) < 20 then
					free = false
				end
			end
			if free then
				slots[#slots + 1] = { x, y }
			end
		end
	end
	return slots
end

-- Un rotulo que no pasa de `room` de ancho (en dos lineas por el espacio mas centrado si hace falta).
local function fitLabel(label, str, room)
	label:setScale(1)
	label:setString(str)
	if label:getVirtualRendererSize().width > room and string.find(str, " ") ~= nil then
		local best, bestGap = nil, nil
		for i = 1, #str do
			if string.sub(str, i, i) == " " then
				local gap = math.abs(i - #str / 2)
				if bestGap == nil or gap < bestGap then
					best, bestGap = i, gap
				end
			end
		end
		label:setString(string.sub(str, 1, best - 1) .. "\n" .. string.sub(str, best + 1))
		label:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	end
	local w = label:getVirtualRendererSize().width
	if w > room then
		label:setScale(room / w)
	end
end

-- El marco redondo con su icono; `labelInside` pone el rotulo dentro (el de la ficha, como los
-- nativos); si no, el rotulo se devuelve para colocarlo debajo (el del panel).
local function createButton(id, iconPath, str, fontName, labelInside)
	local button = ccui.Button:create(FuryHeroExtras.FRAME, FuryHeroExtras.FRAME)
	button:setName("Button_fury_extra_" .. id)
	local size = button:getContentSize()
	local icon = ccui.ImageView:create(iconPath)
	local isize = icon:getContentSize()
	local side = math.max(isize.width, isize.height)
	if side > 0 then
		icon:setScale(FuryHeroExtras.ICON_SIZE / side)
	end
	icon:setPosition(cc.p(size.width / 2, size.height / 2 + 2))
	button:addChild(icon)
	-- Letra 18 con contorno de 1 y encogida por escala: a 13 con contorno de 2 el TTF separaba
	-- las letras («M e j o r a s» en la ficha de Formacion, 30-sep).
	local label = ccui.Text:create(str, fontName, labelInside and 18 or 20)
	label:setColor(cc.c3b(255, 230, 60))
	label:enableOutline(cc.c4b(40, 20, 0, 255), labelInside and 1 or 2)
	if labelInside then
		label:setPosition(cc.p(size.width / 2, 12))
		fitLabel(label, str, size.width - 12)
		button:addChild(label)
	end
	return button, label, icon
end

-----------------------------------------------------------------------------------------------
-- EL PANEL «MEJORAS»
-----------------------------------------------------------------------------------------------
FuryHeroExtrasPanel = class("FuryHeroExtrasPanelClass", Window)

local fury_hero_extras_panel_open_terminal = {
	_name = "fury_hero_extras_panel_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local shipId = params ~= nil and params.ship_id or nil
		if shipId == nil or fwin:find("FuryHeroExtrasPanelClass") ~= nil then
			return true
		end
		fwin:open(FuryHeroExtrasPanel:new():init(shipId), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_hero_extras_panel_close_terminal = {
	_name = "fury_hero_extras_panel_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FuryHeroExtrasPanelClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fury_hero_extras_panel_open_terminal)
state_machine.add(fury_hero_extras_panel_close_terminal)
state_machine.init()

function FuryHeroExtrasPanel:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryHeroExtrasPanel:init(shipId)
	self.ship_id = shipId
	self:setTouchEnabled(true)
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fury_hero_extras_panel_close",
		terminal_state = 0,
		touch_black = true,
	}, nil, 3)
	local title = ccui.Helper:seekWidgetByName(root, "Text_title")
	title:setString(text(1, "Upgrades"))
	self:draw(title:getFontName())
	return self
end

function FuryHeroExtrasPanel:draw(fontName)
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	listView:removeAllItems()
	local width = listView:getContentSize().width
	local columns = FuryHeroExtras.PANEL_COLUMNS
	local cell = width / columns
	local shipId = self.ship_id
	local row = nil
	for n, entry in ipairs(FuryHeroExtras.visible()) do
		if (n - 1) % columns == 0 then
			row = ccui.Layout:create()
			row:setContentSize(cc.size(width, FuryHeroExtras.CELL_HEIGHT))
			listView:addChild(row)
		end
		local x = cell * ((n - 1) % columns) + cell / 2
		local locked = playerLevel() < (entry.level or 1)
		local str = tostring(entry.text())
		local button, label, icon = createButton(entry.id, entry.icon, str, fontName, false)
		button:setPosition(cc.p(x, FuryHeroExtras.CELL_HEIGHT - 60))
		row:addChild(button)
		label:setPosition(cc.p(x, 28))
		row:addChild(label)
		if locked then
			local grey = cc.c3b(120, 120, 120)
			button:setColor(grey)
			icon:setColor(grey)
			local lock = ccui.ImageView:create(FuryHeroExtras.LOCK)
			local size = button:getContentSize()
			lock:setPosition(cc.p(size.width / 2, size.height / 2))
			button:addChild(lock)
			str = string.format(text(2, "Lv. %d"), entry.level)
			label:setColor(cc.c3b(255, 90, 90))
		end
		fitLabel(label, str, cell - 8)
		button:addTouchEventListener(function(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				if locked then
					TipDlg.drawTextDailog(string.format(text(2, "Lv. %d"), entry.level))
					return
				end
				app.load(entry.module)
				state_machine.excute(entry.open, 0, { ship = _ED.user_ship["" .. shipId] })
			end
		end)
	end
	listView:requestRefreshView()
end

function FuryHeroExtrasPanel:onExit()
end

-----------------------------------------------------------------------------------------------
-- EL BOTON DE LA FICHA
-----------------------------------------------------------------------------------------------
-- Lo llama SmRoleStrengthenTab:onUpdateDraw (al abrir y al cambiar de heroe). Idempotente:
-- quita el boton que pusiera antes y lo vuelve a colocar (la visibilidad de los nativos
-- cambia con el heroe: Button_energy solo sale con la evolucion 4).
function FuryHeroExtras.attach(window)
	local root = window.roots ~= nil and window.roots[1] or nil
	if root == nil then
		return
	end
	local anchor = ccui.Helper:seekWidgetByName(root, "Button_rebirth")
	if anchor == nil then
		return
	end
	local parent = anchor:getParent()
	for _, b in ipairs(window._fury_extras or {}) do
		b:removeFromParent(true)
	end
	window._fury_extras = {}
	local slots = freeSlots(root)
	if #slots == 0 or #FuryHeroExtras.visible() == 0 then
		return
	end
	-- Siempre la fuente del juego: el Text_41 de la ficha de Formacion trae otra con las letras
	-- separadas (visto 30-sep).
	local fontName = "fonts/FZYiHei-M20S.ttf"
	local button = createButton("main", FuryHeroExtras.MAIN_ICON, text(1, "Upgrades"), fontName, true)
	button:setPosition(cc.p(slots[1][1], slots[1][2]))
	parent:addChild(button)
	window._fury_extras[1] = button
	button:addTouchEventListener(function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local shipId = window.ship_id or (type(window.ship) == "table" and window.ship.ship_id) or nil
			state_machine.excute("fury_hero_extras_panel_open", 0, { ship_id = shipId })
		end
	end)
end
