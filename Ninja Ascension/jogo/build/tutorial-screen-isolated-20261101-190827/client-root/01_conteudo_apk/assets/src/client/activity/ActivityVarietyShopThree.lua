-- ----------------------------------------------------------------------------------------------------
-- 说明：限时兑换三
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityVarietyShopThree = class("ActivityVarietyShopThreeClass", Window)
    
function ActivityVarietyShopThree:ctor()
    self.super:ctor()
	app.load("client.cells.activity.activity_variety_shop_three_list_cell")
	self.roots = {}
	self.loaded = false
	self._Text_32 = nil
	
	self.examples = {}
	
    -- Initialize ActivityVarietyShopThree state machine.
    local function init_ActivityVarietyShopThree_terminal()
		
		
        state_machine.init()
    end
    
    -- call func init ActivityVarietyShopThree state machine.
    init_ActivityVarietyShopThree_terminal()
end



function ActivityVarietyShopThree:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[71]--
	if activity ~= nil then
		local countText = ccui.Helper:seekWidgetByName(root, "Text_45")
		local titleText = ccui.Helper:seekWidgetByName(root, "Text_032")
		-- _tip_info_activity[62][2]
		if titleText ~= nil then
			titleText:setString(_tip_info_activity[71][1])
		end
		countText:setString(_tip_info_activity[71][2])
		
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
			-- FURY: cuenta atras en vez de la fecha absoluta. Ver
			-- `updateDrawActivityTime` mas abajo.
			self._Text_32 = activityStartTime
			self:updateDrawActivityTime()
		end

		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		for i, v in ipairs(self.examples) do
			local cell = ActivityVarietyShopThreeListCell:createCell()
			cell:init(v,i)
			rewardListView:addChild(cell)
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
function ActivityVarietyShopThree:updateDrawActivityTime()
	if self._Text_32 == nil then
		return
	end
	local activity = _ED.active_activity[71]
	if activity == nil then
		return
	end
	local surplus = zstring.tonumber(activity.activity_login_day)
					- (os.time() + _ED.time_add_or_sub)
	self._Text_32:setString(tostring(surplus < 0 and _string_piece_info[305]
								 or getRedAlertTimeActivityFormat(surplus)))
end

function ActivityVarietyShopThree:onUpdate(dt)
	self:updateDrawActivityTime()
end

function ActivityVarietyShopThree:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	
	self:onUpdateDraw()
end

function ActivityVarietyShopThree:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
 	self:initDraw()
 	self:registerOnNoteUpdate(self, 1)
end

function ActivityVarietyShopThree:unload()
	self._Text_32 = nil
	self:unregisterOnNoteUpdate(self)
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}

end

function ActivityVarietyShopThree:onEnterTransitionFinish()
	
end

function ActivityVarietyShopThree:onExit()

end

function ActivityVarietyShopThree:init()
	local activity = _ED.active_activity[71]--限时兑换三
	self.examples = zstring.split(activity.activity_extra_prame, "\\r\\n")
	if _ED.variety_shop_three_exchang_times == nil or _ED.variety_shop_three_exchang_times == "" then
		_ED.variety_shop_three_exchang_times = zstring.split(activity.activity_extra_prame2, ",")
	end	
end


function ActivityVarietyShopThree:createCell()
	local cell = ActivityVarietyShopThree:new()
	cell:registerOnNodeEvent(cell)
	return cell
end