----------------------------------------------------------------------------------------------------
-- 说明：扫荡结果cell
-------------------------------------------------------------------------------------------------------
PveSweepResultCell = class("PveSweepResultCellClass", Window)
PveSweepResultCell.__size = nil

local pve_sweep_result_create_cell_terminal = {
    _name = "pve_sweep_result_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PveSweepResultCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 1)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_sweep_result_create_cell_terminal)
state_machine.init()

function PveSweepResultCell:ctor()
    self.super:ctor()
	self.roots = {}		
	self.reward = nil
	app.load("client.red_alert_time.cells.props.props_icon_cell")
	
 	local function init_pve_sweep_result_cell_terminal()
        local pve_sweep_result_cell_choose_terminal = {
            _name = "pve_sweep_result_cell_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local pve_sweep_result_cell_update_sprint_terminal = {
            _name = "pve_sweep_result_cell_update_sprint",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				checkRewardObtainDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(pve_sweep_result_cell_choose_terminal)
        state_machine.add(pve_sweep_result_cell_update_sprint_terminal)
        state_machine.init()
    end
	init_pve_sweep_result_cell_terminal()        	
end

function PveSweepResultCell:onUpdateDraw()
	local root = self.roots[1]
	local ListView_reward_props = ccui.Helper:seekWidgetByName(root,"ListView_reward_props")
	ListView_reward_props:removeAllItems()
	ListView_reward_props:setItemsMargin(ListView_reward_props._margin)
	for i=1, tonumber(self.reward.show_reward_item_count) do
		local cell = nil
		local rewardType = tonumber(self.reward.show_reward_list[i].prop_type)
		local propItem = tonumber(self.reward.show_reward_list[i].prop_item)
		if propItem == -1 then
			cell = state_machine.excute("props_icon_create_cell",0,{6, 1, resource_prop_id[rewardType], 1, self.reward.show_reward_list[i].item_value})
		elseif rewardType == 6 then
			cell = state_machine.excute("props_icon_create_cell",0,{6, 1, propItem, 1, self.reward.show_reward_list[i].item_value})
		end
		if nil ~= cell then
			ListView_reward_props:addChild(cell)
		end
	end
	ListView_reward_props:requestRefreshView()
end

function PveSweepResultCell:onEnterTransitionFinish()

end

function PveSweepResultCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.pve.pve_sweep_cell_reward, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if PveSweepResultCell.__size == nil then
		PveSweepResultCell.__size = root:getContentSize()
	end
	if ccui.Helper:seekWidgetByName(root,"ListView_reward_props")._margin == nil then
		ccui.Helper:seekWidgetByName(root,"ListView_reward_props")._margin = ccui.Helper:seekWidgetByName(root,"ListView_reward_props"):getItemsMargin()
	end
	
	self:onUpdateDraw()
end

function PveSweepResultCell:onExit()
	cacher.freeRef(config_csb.cells.pve.pve_sweep_cell_reward, self.roots[1])
end

function PveSweepResultCell:reload()
	-- local root = self.roots[1]
	-- if root ~= nil then
	-- 	return
	-- end
	-- self:onInit()
end

function PveSweepResultCell:unload()
	-- local root = self.roots[1]
	-- if root == nil then
	-- 	return
	-- end
	-- cacher.freeRef(config_csb.cells.pve.pve_sweep_cell_reward, root)
	-- root:removeFromParent(false)
	-- self.roots = {}
end

function PveSweepResultCell:init(params)
	self.reward = params
    self:onInit()
	self:setContentSize(PveSweepResultCell.__size)
end

