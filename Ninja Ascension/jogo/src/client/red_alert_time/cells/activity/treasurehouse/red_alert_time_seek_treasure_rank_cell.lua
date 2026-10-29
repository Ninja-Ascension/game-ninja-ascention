-- ------------------------------------------------------------------------------------------------------------
--  说明：科威特的排名cell
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeSeekTreasureTankCell = class("RedAlertTimeSeekTreasureTankCellClass", Window)
RedAlertTimeSeekTreasureTankCell.__size = nil

--创建cell
local red_alert_time_seek_treasure_rank_cell_create_terminal = {
    _name = "red_alert_time_seek_treasure_rank_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeSeekTreasureTankCell:new()
        local activity_data = params[1]
        local activity = params[2]
        local index = params[3]
        cell:init(activity_data,activity,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_seek_treasure_rank_cell_create_terminal)
state_machine.init()

function RedAlertTimeSeekTreasureTankCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._activity_data = nil
    self._activity = nil
    self._index = 0 
    local function init_red_alert_time_seek_treasure_rank_cell_terminal()
		-- local red_alert_time_brothers_share_package_receive_terminal = {
            -- _name = "red_alert_time_brothers_share_package_receive",
            -- _init = function (terminal)
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
            	-- local function responseCallback(response)
					-- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- if response.node ~= nil and response.node.roots ~= nil then
							-- instance._activity_data.status = 1
							-- instance._activity_data.receiveNumber = instance._activity_data.receiveNumber + 1
							-- instance:updateDraw()
							-- checkRewardObtainDraw()
						-- end
					-- end
				-- end		
				-- debug.print_r(self.activityInfo[1])
				-- protocol_command.draw_activity_reward.param_list = instance._activity.activity_id .. "\r\n"..instance._activity.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."1".."\r\n"..tonumber(instance._index)-1
				-- NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
        
        -- state_machine.add(red_alert_time_brothers_share_package_receive_terminal)
    end
    init_red_alert_time_seek_treasure_rank_cell_terminal()
end

function RedAlertTimeSeekTreasureTankCell:updateDraw()
    local root = self.roots[1]
	--排名
	local Text_seek_treasure_rank_n_1 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_n_1")
	if tonumber(self._activity_data.rank) < 4 then
		Text_seek_treasure_rank_n_1:setString("")
	else
		Text_seek_treasure_rank_n_1:setString(self._activity_data.rank)
	end
	--昵称
	local Text_seek_treasure_rank_n_2 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_n_2")
	local colos = nil
	if tonumber(self._activity_data.rank) < 4 then
		colos = cc.c3b(arena_color_Type[tonumber(self._activity_data.rank)+2][1], arena_color_Type[tonumber(self._activity_data.rank)+2][2], arena_color_Type[tonumber(self._activity_data.rank)+2][3])
	else
		colos = cc.c3b(arena_color_Type[6][1], arena_color_Type[6][2], arena_color_Type[6][3])
	end
	Text_seek_treasure_rank_n_2:setColor(colos)
	Text_seek_treasure_rank_n_2:setString(self._activity_data.name)
	--积分
	local Text_seek_treasure_rank_n_3 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_n_3")
    local haveScore = self._activity_data.integral
    if tonumber(self._activity.activity_type) == 97
        or tonumber(self._activity.activity_type) == 127
        then
        haveScore = exChangeNumToString(haveScore , true)
    end
	Text_seek_treasure_rank_n_3:setString(haveScore)
	--前3排名图
	local Panel_seek_treasure_rank_top = ccui.Helper:seekWidgetByName(root, "Panel_seek_treasure_rank_top")
	Panel_seek_treasure_rank_top:removeBackGroundImage()
	if tonumber(self._activity_data.rank) < 4 then
		Panel_seek_treasure_rank_top:setBackGroundImage(string.format("images/ui/share/rank_icon_%s.png", self._activity_data.rank))
	end
end

function RedAlertTimeSeekTreasureTankCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.seek_treasure_rank_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeSeekTreasureTankCell.__size == nil then
        RedAlertTimeSeekTreasureTankCell.__size = root:getContentSize()
    end
	
    self:updateDraw()
end

function RedAlertTimeSeekTreasureTankCell:onEnterTransitionFinish()

end

function RedAlertTimeSeekTreasureTankCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeSeekTreasureTankCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.seek_treasure_rank_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeSeekTreasureTankCell:clearUIInfo()
    local root = self.roots[1]
    local Text_seek_treasure_rank_n_1 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_n_1")
    local Text_seek_treasure_rank_n_2 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_n_2")
    local Text_seek_treasure_rank_n_3 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_n_3")
    local Panel_seek_treasure_rank_top = ccui.Helper:seekWidgetByName(root, "Panel_seek_treasure_rank_top")
    if Text_seek_treasure_rank_n_1 ~= nil then
        Text_seek_treasure_rank_n_1:setString("")
        Text_seek_treasure_rank_n_2:setString("")
        Text_seek_treasure_rank_n_3:setString("")
        Panel_seek_treasure_rank_top:removeBackGroundImage()
    end
end

function RedAlertTimeSeekTreasureTankCell:init(activity_data,activity,index)
    self._activity_data = activity_data
    self._activity = activity
    self._index = index
    -- if index ~= nil and index <= 5 then
        self:onInit()
    -- end
    self:setContentSize(RedAlertTimeSeekTreasureTankCell.__size)
    return self
end

function RedAlertTimeSeekTreasureTankCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.seek_treasure_rank_cell, self.roots[1])
end

