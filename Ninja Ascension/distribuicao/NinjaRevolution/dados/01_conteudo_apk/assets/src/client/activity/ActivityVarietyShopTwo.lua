-- ----------------------------------------------------------------------------------------------------
-- 说明：限时兑换二
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityVarietyShopTwo = class("ActivityVarietyShopTwoClass", Window)
    
function ActivityVarietyShopTwo:ctor()
    self.super:ctor()
	app.load("client.cells.activity.activity_variety_shop_two_list_cell")
	self.roots = {}
	self.loaded = false
	self._Text_32 = nil
	
	self.examples = {}
	
    -- Initialize ActivityVarietyShopTwo state machine.
    local function init_ActivityVarietyShopTwo_terminal()
		
		
        state_machine.init()
    end
    
    -- call func init ActivityVarietyShopTwo state machine.
    init_ActivityVarietyShopTwo_terminal()
end



function ActivityVarietyShopTwo:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[70]--
	if activity ~= nil then
		local countText = ccui.Helper:seekWidgetByName(root, "Text_45")
		local titleText = ccui.Helper:seekWidgetByName(root, "Text_032")
		-- _tip_info_activity[62][2]
		if titleText ~= nil then
			titleText:setString(_tip_info_activity[70][1])
		end
		countText:setString(_tip_info_activity[70][2])
		
		local activityStartTime = ccui.Helper:seekWidgetByName(root, "Text_32")	--活动开始时间
		activityStartTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(activity.activity_start_day)))
		
		
		local activityEndTime = ccui.Helper:seekWidgetByName(root, "Text_44")	--活动截止时间
		-- FURY: `activityEndTime` no esta en landed_gifts.csb de este proyecto; sin la guarda esto moria en el primer metodo sobre nil.
		if activityEndTime ~= nil then
			activityEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
												.."%m"..tipStringInfo_time_info[2]
												.."%d"..tipStringInfo_time_info[10]
												.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(activity.activity_login_day)))
		end
		
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			then
			-- FURY: `activityEndTime` no esta en landed_gifts.csb de este proyecto; sin la guarda esto moria en el primer metodo sobre nil.
			if activityEndTime ~= nil then
				activityEndTime:setVisible(false)
			end
			local fury_text_33 = ccui.Helper:seekWidgetByName(root, "Text_33") if fury_text_33 ~= nil then fury_text_33:setVisible(false) end
			-- FURY: TIENDA PREMIUM (29-sep-2026). El 70 es una tienda
			-- PERMANENTE: sin cuenta atras. Se ocultan el reloj (`Text_32`) y su
			-- cartel `yyhd_djs.png` (`Image_34`); `self._Text_32` sigue en nil,
			-- asi que `updateDrawActivityTime` no hace nada.
			activityStartTime:setVisible(false)
			local fury_image_34 = ccui.Helper:seekWidgetByName(root, "Image_34")
			if fury_image_34 ~= nil then fury_image_34:setVisible(false) end
		end

		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		for i, v in ipairs(self.examples) do
			local cell = ActivityVarietyShopTwoListCell:createCell()
			cell:init(v,i)
			rewardListView:addChild(cell)
		end
		-- NARUTO (prueba en pantalla 1-oct): aqui cada articulo es una CARTA vertical de 246 de ancho
		-- y la lista mide 860: apiladas en vertical salia una sola columna con el resto vacio. Si caben
		-- dos cartas a lo ancho, la lista va en horizontal. En Fury (filas de 596 en 708) nada cambia.
		local first = rewardListView:getItems()[1]
		if first ~= nil and first:getContentSize().width > 0
			and first:getContentSize().width * 2 <= rewardListView:getContentSize().width then
			rewardListView:setDirection(ccui.ListViewDirection.horizontal)
			rewardListView:setItemsMargin(12)
			rewardListView:requestRefreshView()
		end
	end
	
end

-- FURY: EL RELOJ DEL EVENTO, copiado del 28
-- (ActivityExchangeProp.lua:231-245). `Text_32` de `landed_gifts.csb`
-- viene con "00:00:00" y justo al lado el cartel `yyhd_djs.png`
-- («cuenta regresiva del evento»): ese hueco es una CUENTA ATRAS, no
-- una fecha. Lo alimenta `activity_login_day`, que es el PRIMER token
-- del bloque y YA VIAJA -el parser lo guarda como
-- `os.time() + restante/1000`, ProtocolParserCopy.lua:4664-4665-, asi
-- que no faltaba ningun token: faltaba el refresco.
function ActivityVarietyShopTwo:updateDrawActivityTime()
	if self._Text_32 == nil then
		return
	end
	local activity = _ED.active_activity[70]
	if activity == nil then
		return
	end
	local surplus = zstring.tonumber(activity.activity_login_day)
					- (os.time() + _ED.time_add_or_sub)
	self._Text_32:setString(tostring(surplus < 0 and _string_piece_info[305]
								 or getRedAlertTimeActivityFormat(surplus)))
end

function ActivityVarietyShopTwo:onUpdate(dt)
	self:updateDrawActivityTime()
end

function ActivityVarietyShopTwo:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	
	self:onUpdateDraw()
end

function ActivityVarietyShopTwo:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
 	self:initDraw()
 	self:registerOnNoteUpdate(self, 1)
end

function ActivityVarietyShopTwo:unload()
	self._Text_32 = nil
	self:unregisterOnNoteUpdate(self)
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}

end

function ActivityVarietyShopTwo:onEnterTransitionFinish()
	
end

function ActivityVarietyShopTwo:onExit()

end

function ActivityVarietyShopTwo:init()
	local activity = _ED.active_activity[70]--限时兑换二

	self.examples = zstring.split(activity.activity_extra_prame, "\\r\\n")
	-- FURY: TIENDA PREMIUM. Se relee SIEMPRE: los topes diarios y semanales
	-- vuelven a cero y la cuenta buena es la que manda el servidor en cada
	-- login. La celda mantiene al dia `activity_extra_prame2` tras cada compra
	-- (ActivityVarietyShopTwoListCell:rewadDraw), asi que reabrir la ventana
	-- no pierde lo comprado.
	_ED.variety_shop_two_exchang_times = zstring.split(activity.activity_extra_prame2, ",")
end


function ActivityVarietyShopTwo:createCell()
	local cell = ActivityVarietyShopTwo:new()
	cell:registerOnNodeEvent(cell)
	return cell
end