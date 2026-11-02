--------------------------------------------------------------------------------------------------------------
--  说明：公会副本分配奖励cell
--------------------------------------------------------------------------------------------------------------
UnionNpcDistributionListCell = class("UnionNpcDistributionListCellClass", Window)
UnionNpcDistributionListCell.__size = nil
function UnionNpcDistributionListCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.last = 0
	self.example = nil
	self.index = 0
	app.load("client.cells.utils.resources_icon_cell")
	 -- Initialize union rank list cell state machine.
    local function init_union_npc_distribution_list_cell_terminal()

        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_union_npc_distribution_list_cell_terminal()

end

function UnionNpcDistributionListCell:updateDraw()
	local root = self.roots[1]
	local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
	local Text_wj_name = ccui.Helper:seekWidgetByName(root, "Text_wj_name")
	local Panel_reward_icon = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon")

	--奖励
	Panel_reward_icon:removeAllChildren(true)
	local rewardData = zstring.split(self.example.user_reward, ",") 
	local cell = ResourcesIconCell:createCell()
    cell:init(rewardData[1], tonumber(rewardData[3]), rewardData[2],nil,nil,true,true)
    Panel_reward_icon:addChild(cell)

	--名称
	Text_wj_name:setString(self.example.user_name)

	--时间
	if __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
		Text_time = ccui.Helper:seekWidgetByName(root, "Text_legion_pve_time")	
	end
	Text_time:setString(self:getTimeFormatYMDHMS(tonumber(self.example.user_time)/1000).._new_interface_text[75])
end

function UnionNpcDistributionListCell:getTimeFormatYMDHMS( m_time )
	local temp = os.date("*t",m_time)
	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)
	local m_sec 	= string.format("%02d", temp.sec)


	local timeString = temp.year ..tipStringInfo_time_info[1].. m_month ..tipStringInfo_time_info[2].. m_day ..tipStringInfo_time_info[10].. m_hour ..":".. m_min


    return timeString
end

function UnionNpcDistributionListCell:onInit()

	local csbUnionNpcDistributionListCell= csb.createNode("legion/sm_legion_pve_window_distribution_list.csb")
    local root = csbUnionNpcDistributionListCell:getChildByName("root")
    table.insert(self.roots, root)
	 
    self:addChild(csbUnionNpcDistributionListCell)
	if UnionNpcDistributionListCell.__size == nil then
		UnionNpcDistributionListCell.__size = root:getChildByName("Panel_247"):getContentSize()
	end	
	root:getChildByName("Panel_247"):setTouchEnabled(false)
	
	self:updateDraw()
end

function UnionNpcDistributionListCell:onEnterTransitionFinish()

end

function UnionNpcDistributionListCell:init(example,index,last)
	self.example = example
	self.index = index
	if index < 5 then
		self:onInit()
	end
	self:setContentSize(UnionNpcDistributionListCell.__size)
	-- self:onInit()
	return self
end

function UnionNpcDistributionListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionNpcDistributionListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("legion/sm_legion_pve_window_distribution_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end
function UnionNpcDistributionListCell:onExit()
	cacher.freeRef("legion/sm_legion_pve_window_distribution_list.csb", self.roots[1])
end

function UnionNpcDistributionListCell:createCell()
	local cell = UnionNpcDistributionListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
