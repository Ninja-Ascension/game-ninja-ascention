-- ----------------------------------------------------------------------------------------------------
-- 说明：单笔累积充值
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityOnceRecharge = class("ActivityOnceRechargeClass", Window)
-- FURY: la pagina del 151 (client/l_digital/activity/wonderful/ActivityOnceRecharge.lua)
-- declara OTRA clase con este MISMO nombre global; la que se cargue la ultima se queda el
-- nombre. Por eso el 45 acababa abriendo la pagina del 151, que lee activity_params, un
-- token que al 45 no le llega NUNCA (ProtocolParserCopy.lua:4325-4338). Con este local,
-- todo lo de este fichero apunta siempre a ESTA clase, que es la que lee los datos de la
-- entrada (available_count / completed_count / activityInfo_need_day / activityInfo_isReward,
-- ProtocolParserCopy.lua:4503-4534) via accumlate_rechargeable_cell.
local ActivityOnceRecharge = ActivityOnceRecharge
    
function ActivityOnceRecharge:ctor()
    self.super:ctor()
	app.load("client.cells.activity.accumlate_rechargeable_cell")
	self.roots = {}
	self.loaded = false
	self.typeIndex = 45
    -- Initialize ActivityOnceRecharge state machine.
    local function init_activityOnceRecharge_terminal()
		local activity_once_recharge_button_terminal = {
            _name = "activity_once_recharge_button",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.onUpdateDraw111 ~= nil then
					instance:onUpdateDraw111()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(activity_once_recharge_button_terminal)
		
        state_machine.init()
    end
    
    -- call func init ActivityOnceRecharge state machine.
    init_activityOnceRecharge_terminal()
end

function ActivityOnceRecharge:onUpdateDraw111()
	local root = self.roots[1]
	
	local activity = _ED.active_activity[self.typeIndex]--累充活动
	local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	if rewardListView == nil then
		return
	end
	rewardListView:removeAllItems()
	for i, v in pairs(activity.activity_Info) do
		local cell = AccumlateRechargeableCell:createCell()
		cell:init(v,i,self.typeIndex)
		rewardListView:addChild(cell)
	end
end

function ActivityOnceRecharge:loading_cell()
	if ActivityOnceRecharge.cacheListView == nil then
		return 
	end
	local activity = _ED.active_activity[ActivityOnceRecharge.typeIndex]--累充活动
	-- FURY: dos onUpdateDraw seguidos encolan el doble de cargas asincronas y
	-- asyncIndex pasa del final de la lista: la celda moria en :183 con nil.
	if activity == nil or activity.activity_Info == nil or activity.activity_Info[ActivityOnceRecharge.asyncIndex] == nil then
		return
	end
	local cell = AccumlateRechargeableCell:createCell()
	cell:init(activity.activity_Info[ActivityOnceRecharge.asyncIndex],ActivityOnceRecharge.asyncIndex,ActivityOnceRecharge.typeIndex)
	ActivityOnceRecharge.cacheListView:addChild(cell)
	ActivityOnceRecharge.cacheListView:requestRefreshView()
	ActivityOnceRecharge.asyncIndex = ActivityOnceRecharge.asyncIndex + 1
end

function ActivityOnceRecharge:onUpdateDraw()
	local root = self.roots[1]
	-- FURY: esta pagina no construye su csb hasta :lazy(); si la pestana aun no se abrio,
	-- roots esta vacio y seekWidgetByName(nil, ...) revienta.
	if root == nil then
		return
	end
	local activity = _ED.active_activity[self.typeIndex]--累充活动
	if activity ~= nil then
		local countText = ccui.Helper:seekWidgetByName(root, "Text_45")
		local titleText = ccui.Helper:seekWidgetByName(root, "Text_032")
		if titleText ~= nil then
			titleText:setString(_tip_info_activity[self.typeIndex][1])
		end
		countText:setString(_tip_info_activity[self.typeIndex][2])
		local activityEndTime = ccui.Helper:seekWidgetByName(root, "Text_32")	--活动截止时间
		local rewardEndTime = ccui.Helper:seekWidgetByName(root, "Text_44")	--领奖截止时间
		
		-- activityEndTime:setString(zstring.exchangeFrom(activity.activity_over_time))
		-- rewardEndTime:setString(zstring.exchangeFrom(activity.activity_draw_over_time))
		activityEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.activity_over_time)/1000)))
		-- FURY: `rewardEndTime` no esta en landed_gifts.csb de este proyecto; sin la guarda esto moria en el primer metodo sobre nil.
		if rewardEndTime ~= nil then
			rewardEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
												.."%m"..tipStringInfo_time_info[2]
												.."%d"..tipStringInfo_time_info[10]
												.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.activity_draw_over_time)/1000)))	
		end
		
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		ActivityOnceRecharge.asyncIndex = 1
		ActivityOnceRecharge.cacheListView = rewardListView
		ActivityOnceRecharge.typeIndex = self.typeIndex
		
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		rewardListView:removeAllItems()
		for i, v in pairs(activity.activity_Info) do
			-- local cell = AccumlateRechargeableCell:createCell()
			-- cell:init(v,i)
			-- rewardListView:addChild(cell)
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
		end
	end
	
end

function ActivityOnceRecharge:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	
	self:onUpdateDraw()
end

function ActivityOnceRecharge:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
    self:initDraw()
end

function ActivityOnceRecharge:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	ActivityOnceRecharge.asyncIndex = 1
	ActivityOnceRecharge.cacheListView = nil
end

function ActivityOnceRecharge:onEnterTransitionFinish()
	-- local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
 --    local root = csbAccumlateRechargeable:getChildByName("root")
 --    table.insert(self.roots, root)
	-- self:addChild(csbAccumlateRechargeable)
	
	-- self:onUpdateDraw()

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
end

function ActivityOnceRecharge:onExit()
	ActivityOnceRecharge.asyncIndex = 1
	ActivityOnceRecharge.cacheListView = nil
end

function ActivityOnceRecharge:init()
	
end


function ActivityOnceRecharge:createCell()
	local cell = ActivityOnceRecharge:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

-- FURY: asa estable para ActivityWindow:activityOnceRecharge() (tipo 45).
ActivityOnceRecharge45 = ActivityOnceRecharge
