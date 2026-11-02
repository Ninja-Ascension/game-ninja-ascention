-- ----------------------------------------------------------------------------------------------------
-- 说明：活动主界面
-------------------------------------------------------------------------------------------------------
AdventureActivityWindow = class("AdventureActivityWindowClass", Window)


local adventure_activity_list_terminal = {
    _name = "adventure_activity_list_update",
    _init = function (terminal)
    	--app.load("client.notification.push_notification_adventure_sign_in")
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local  window = fwin:find("AdventureActivityWindowClass")
    	if window ~= nil then
    		window:onUpdateIconListView()
    	end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(adventure_activity_list_terminal)
state_machine.init()
    
function AdventureActivityWindow:ctor()
    self.super:ctor()
    self.roots = {}
	self.listView = nil
	self.first = nil
	self.allItems = {}
	self.activityCount = -1
	app.load("client.adventure.activity.AdventureActivityIcon")
	app.load("client.adventure.activity.AdventureActivityInterface")
    -- Initialize adventure activity window state machine.
    local function init_adventure_activity_window_terminal()
    	local adventure_activity_move_first_recharge_terminal = {
		    _name = "adventure_activity_move_first_recharge",
		    _init = function (terminal)
		    	
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)

		    	instance:onInitActivityIcon()
				instance:onUpdateDraw()
		      return true
   		end,
	    _terminal = nil,
	    _terminals = nil
		}
	state_machine.add(adventure_activity_move_first_recharge_terminal)
    state_machine.init()
    end
    
    -- call func init adventure activity window state machine.
    init_adventure_activity_window_terminal()
end

function AdventureActivityWindow:init()
	return self
end

function AdventureActivityWindow:activityGiftCodes()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_PACKAGE_EXCHANGE)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 22
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_PACKAGE_EXCHANGE)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activityFirstRecharge()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_FIRST_RECHARGE)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 1
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_FIRST_RECHARGE)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activityCumulativeRecharge()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_CUMULATIVE_RECHARGE)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 5
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_CUMULATIVE_RECHARGE)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activitySingleRecharge()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_SINGLE_RECHARGE)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 3
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_SINGLE_RECHARGE)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activityCumulativeConsumption()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_CUMULATIVE_CONSUMPTION)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 6
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_CUMULATIVE_CONSUMPTION)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activityCumulativeConsumptionLong()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_CUMULATIVE_CONSUMPTION_LONG)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 7
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_CUMULATIVE_CONSUMPTION_LONG)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activityCumulativeRecruit()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_CUMULATIVE_RECRUIT)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 10
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_CUMULATIVE_RECRUIT)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activityDekaronBoss()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_DEKARON_BOSS)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 21
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_DEKARON_BOSS)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activityCumulatuveFtre()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_CUMULATIVE_FIRE)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 12
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_CUMULATIVE_FIRE)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activityGifts()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_GIFTS)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 8
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_GIFTS)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activityCustomsClearance()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_CUSTOMS_CLEARANCE)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 13
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_CUSTOMS_CLEARANCE)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activityXueyuxinfeng()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_XUEYUXINFENG)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 14
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_XUEYUXINFENG)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activityCapabilityUp()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_CAPABILITY_UP)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 9
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_CAPABILITY_UP)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activityBingqiangmazhuang()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_BINQIANGMAZHUANG)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 15
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_BINQIANGMAZHUANG)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activityCompetitiveKing()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_COMPETITIVE_KING)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 17
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_COMPETITIVE_KING)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activityActivityCompetitiveKingTwo()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_COMPETITIVE_KING_TWO)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 16
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_COMPETITIVE_KING_TWO)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activityDiamondsRecruit()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_DIAMONDS_RECRUIT)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 11
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_DIAMONDS_RECRUIT)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activityKillSoldier()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_KILL_SOLDIER)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 18
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_KILL_SOLDIER)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activitySigninSign()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_SIGNIN_SIGN)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 2
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_SIGNIN_SIGN)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:activitySigninSignNew()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_SIGNIN_SIGN_NEW)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 3
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_SIGNIN_SIGN_NEW)
	
end

function AdventureActivityWindow:activitySingleStockRecharhe()
	local root = self.roots[1]
	local activityIcon = AdventureActivityIcon:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_SINGLE_SROCK_RECHARGE)
	table.insert(self.allItems,activityIcon)
	activityIcon._flag = 4
	--print(_ED.fetchable_activities[45],"------------------")
	self:onRefreshActivityIcon(activityIcon,activityIcon.enum_type.ACTIVITY_SINGLE_SROCK_RECHARGE)
	--self.listView:addChild(activityIcon)
end

function AdventureActivityWindow:onUpdateDraw()
	local root = self.roots[1]
	self.listView = ccui.Helper:seekWidgetByName(root, "ListView_wonderful")
	
	self.listView:removeAllItems()
	
	 -- 排序算法
    local sortFunc = function( cell1, cell2 )
        return cell2._flag > cell1._flag
    end

	table.sort(self.allItems, sortFunc)
	 for i, v in pairs(self.allItems) do
        self.listView:addChild(v)
    end
	 
	self.listView:requestRefreshView()
	local items = self.listView:getItems()
	local focue = items[1]
	state_machine.excute("adventure_activity_icon_selected", 0, {_datas={cell = focue}})
end

function AdventureActivityWindow:onEnterTransitionFinish()
	local csbAdventureActivityWindow = csb.createNode("activity/wonderful/wonderful.csb")
    local root = csbAdventureActivityWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureActivityWindow)
	
	fwin:open(AdventureActivityInterface:new():init(), fwin._view)
	self:onInitActivityIcon()
	self:onUpdateDraw()
end

function AdventureActivityWindow:onInitActivityIcon()
	
	self.allItems = {}
	if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
		self:activityGiftCodes() 	--兑换码
	end
	if _ED.active_activity[4] ~= nil and _ED.active_activity[4]~="" then 
		-- 首冲奖励
		self:activityFirstRecharge()
	end
	if _ED.active_activity[7] ~= nil and _ED.active_activity[7]~="" then 
		-- 累积充值
		self:activityCumulativeRecharge()
	end
	if _ED.active_activity[21] ~= nil and _ED.active_activity[21]~="" then 
		-- 单次充值
		self:activitySingleRecharge()
	end
	if _ED.active_activity[17] ~= nil and _ED.active_activity[17]~="" then 
		-- 累积消费
		self:activityCumulativeConsumption()
	end

	if _ED.active_activity[69] ~= nil and _ED.active_activity[69]~="" then 
		-- 累积消费(长期)
		self:activityCumulativeConsumptionLong()
	end

	if _ED.active_activity[50] ~= nil and _ED.active_activity[50]~="" then 
		-- 累积招募 
		self:activityCumulativeRecruit()
	end
	if _ED.active_activity[51] ~= nil and _ED.active_activity[51]~="" then 
		-- 挑战boss 
		self:activityDekaronBoss()
	end
	if _ED.active_activity[52] ~= nil and _ED.active_activity[52]~="" then 
		-- 累计解雇 
		self:activityCumulatuveFtre()
	end	
	if _ED.active_activity[53] ~= nil and _ED.active_activity[53]~="" then 
		-- 友情送礼 
		self:activityGifts()
	end
	if _ED.active_activity[54] ~= nil and _ED.active_activity[54]~="" then 
		-- 过关斩将 
		self:activityCustomsClearance()
	end	
	if _ED.active_activity[55] ~= nil and _ED.active_activity[55]~="" then 
		-- 血雨腥风 
		self:activityXueyuxinfeng()
	end	
	if _ED.active_activity[56] ~= nil and _ED.active_activity[56]~="" then 
		-- 战力爆表 
		self:activityCapabilityUp()
	end	
	if _ED.active_activity[57] ~= nil and _ED.active_activity[57]~="" then 
		-- 兵强马壮 
		self:activityBingqiangmazhuang()
	end	
	if _ED.active_activity[58] ~= nil and _ED.active_activity[58]~="" then 
		-- 竞技王者 
		self:activityCompetitiveKing()
	end		
	if _ED.active_activity[59] ~= nil and _ED.active_activity[59]~="" then 
		-- 竞技王者20连胜
		self:activityActivityCompetitiveKingTwo()
	end		
	if _ED.active_activity[60] ~= nil and _ED.active_activity[60]~="" then 
		-- 血钻招募
		self:activityDiamondsRecruit()
	end
	if _ED.active_activity[61] ~= nil and _ED.active_activity[61]~="" then 
		-- 击杀杂兵
		self:activityKillSoldier()
	end
	if _ED.active_activity[73] ~= nil and _ED.active_activity[73]~="" then 
		-- 新登陆签到
		local isHave = false
		if #_ED.active_activity[73].activity_Info > 0 then
			for i=1,#_ED.active_activity[73].activity_Info do
				if tonumber(_ED.active_activity[73].activity_Info[i].activityInfo_isReward) == 1 then
					isHave = true
				end
			end
		end
		if isHave == true then 
			self:activitySigninSignNew()
		end
	end
	if _ED.active_activity[24] ~= nil and _ED.active_activity[24]~="" then 
		-- 登陆签到
		local isHave = false
		if #_ED.active_activity[24].activity_Info > 0 then
			for i=1,#_ED.active_activity[24].activity_Info do
				if tonumber(_ED.active_activity[24].activity_Info[i].activityInfo_isReward) == 0 then
					isHave = true

					if tonumber(_ED.active_activity[24].activity_Info[i].activityInfo_need_day) <= tonumber(_ED.active_activity[24].activity_login_day) then
						isHave = true
						
					end	
				end
			end
		end
		if isHave == true then 
			self:activitySigninSign()
		end
		
	end
	if _ED.active_activity[45] ~= nil and _ED.active_activity[45]~="" then 
		-- 单笔充值
		self:activitySingleStockRecharhe()
	end
	--debug.print_r(_ED.active_activity[73] )
end
function AdventureActivityWindow:onRefreshActivityIcon(cell,type)
	if cell ~= nil then 
		if _ED.fetchable_activities[tonumber(type)] ~= nil and tonumber(_ED.fetchable_activities[tonumber(type)]) == 1 then 
			if cell:getChildByTag(500) == nil then 
				local ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
				ball:setAnchorPoint(cc.p(0.5, 0.5))
				ball:setTag(500)
				ball:setPosition(cc.p(cell:getContentSize().width-ball:getContentSize().width*0.5,cell:getContentSize().height-ball:getContentSize().height*0.5))
				cell:addChild(ball)
			end
		else 
			if cell:getChildByTag(500) ~= nil then 
				cell:removeChildByTag(500)
			else 
				--cell:removeChildByTag(500)
			end
		end
	end
end

function AdventureActivityWindow:onUpdateIconListView()
	if self.listView ~= nil and self.listView:getItems() ~=nil then 

		for i,v in ipairs(self.listView:getItems()) do
			local type = v.current_type
			self:onRefreshActivityIcon(v,type)
			--v:onUpdateIconTip()	
		end
	end
end

function AdventureActivityWindow:onExit()
	--state_machine.remove("adventure_activity_list_update")
end