--[[ ----------------------------------------------------------------------------
-- 奖励预览列表控件
--]] ----------------------------------------------------------------------------
RescueStationRewardPreviewList = class("RescueStationRewardPreviewListClass", Window)
RescueStationRewardPreviewList.__size = nil

-- 创建Cell实例
local rescue_station_reward_preview_list_create_terminal = {
	_name = "rescue_station_reward_preview_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RescueStationRewardPreviewList then
			local cell = RescueStationRewardPreviewList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rescue_station_reward_preview_list_create_terminal)
state_machine.init()

-- 构造器
function RescueStationRewardPreviewList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
   
	local function init_rescue_station_reward_preview_list_terminal()
		
	end

	init_rescue_station_reward_preview_list_terminal()
end

-- 对象初始化
function RescueStationRewardPreviewList:init(params)
	self.actions = params[1]
	self:onInit(params)
	self:setContentSize(RescueStationRewardPreviewList.__size)
	return self
end

function RescueStationRewardPreviewList:onUpdateDraw()
	local root = self.roots[1]
	local rankIndexs = {}
	local rewardDatas = nil
	for k,v in pairs(self.actions) do
		rankIndexs = zstring.split(k,"-")
		rewardDatas = v
	end
	-- 名次
	self.Text_ranking = ccui.Helper:seekWidgetByName(root, "Text_ranking")    
    if tonumber(rankIndexs[1]) == tonumber(rankIndexs[2]) then
    	self.Text_ranking:setString(tipStringInfo_rescue_station[1]..rankIndexs[1]..tipStringInfo_rescue_station[2])
    else
    	self.Text_ranking:setString(tipStringInfo_rescue_station[1]..rankIndexs[1].."~"..rankIndexs[2]..tipStringInfo_rescue_station[2])
    end	

    local info = zstring.splits(rewardDatas,"|",",")
	-- 奖励道具列表
	self.ListView_ranking_reward_2 = ccui.Helper:seekWidgetByName(root, "ListView_ranking_reward_2")
    self.ListView_ranking_reward_2:removeAllItems()
    
    for k,reward in pairs(info) do
    	local rewardType = zstring.tonumber(reward[1])
        local cell = ResourcesIconCell:createCell()
        if 13 == rewardType then
            local table = {}
            if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
                table.shipStar = tonumber(reward[4])
            end
			cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1,table)
		elseif 71 == rewardType then
			local property_info = dms.string(dms["ship_silk_bag_mould"],tonumber(reward[2]),ship_silk_bag_mould.base_property)
            local basePropertyList = {}
            if nil ~= property_info then
                local add_property_info = zstring.split(property_info,"|")
                for i = 1,table.nums(add_property_info) do
                    local add_property_per = zstring.split(add_property_info[i],",")
                    if nil ~= add_property_per then
                        local a = tipStringInfo_rescue_silkbag_property["0"]
                        local baseProperty ={}
                        baseProperty.property_name = tipStringInfo_rescue_silkbag_property[tostring(add_property_per[1])]
                        baseProperty.property_value = add_property_per[2]
                        basePropertyList[i] = baseProperty
                    end
                end
			end
			cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,nil,{basePropertyList,0})
        else
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1)
        end
    self.ListView_ranking_reward_2:addChild(cell)
    end
end

function RescueStationRewardPreviewList:onEnterTransitionFinish()
	
end

function RescueStationRewardPreviewList:onInit(params)
	
	local root = cacher.createUIRef("activity/rescue_station/rescue_station_reward_preview_list.csb", "root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RescueStationRewardPreviewList.__size == nil then
		RescueStationRewardPreviewList.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function RescueStationRewardPreviewList:onExit()
	-- 释放RescueStationRewardPreviewListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/rescue_station/rescue_station_reward_preview_list.csb", root)
	-- ]]
end

function RescueStationRewardPreviewList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RescueStationRewardPreviewList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/rescue_station/rescue_station_reward_preview_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
