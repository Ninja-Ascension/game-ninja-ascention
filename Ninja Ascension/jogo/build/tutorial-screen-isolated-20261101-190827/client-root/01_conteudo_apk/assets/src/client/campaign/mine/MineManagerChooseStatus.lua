----------------------------------------------------------------------------------------------------
-- 说明：点击巡逻收益时长
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MineManagerChooseStatus = class("MineManagerChooseStatusClass", Window)
    
function MineManagerChooseStatus:ctor()
    self.super:ctor()
    self.roots = {}
	
    -- Initialize MineManager page state machine.
    local function init_mine_manager_choose_status_terminal()
	
		--返回
		local mine_manager_choose_status_back_terminal = {
            _name = "mine_manager_choose_status_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local mine_manager_choose_status_choose_back_terminal = {
            _name = "mine_manager_choose_status_choose_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if params._datas._status == 1 then
					state_machine.excute("mine_manager_manager_patrol_status_back", 0, {_datas = {_time = 1}})
					fwin:close(instance)
				elseif params._datas._status == 2 then
					if tonumber(_ED.vip_grade) >= 4 then
						state_machine.excute("mine_manager_manager_patrol_status_back", 0, {_datas = {_time = 2}})
						fwin:close(instance)
					else
						TipDlg.drawTextDailog(game_mine_tip_str[6])
					end
				elseif params._datas._status == 3 then
					if tonumber(_ED.vip_grade) >= 8 then
						state_machine.excute("mine_manager_manager_patrol_status_back", 0, {_datas = {_time = 3}})
						fwin:close(instance)
					else
						TipDlg.drawTextDailog(game_mine_tip_str[6])
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(mine_manager_choose_status_back_terminal)
		state_machine.add(mine_manager_choose_status_choose_back_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_mine_manager_choose_status_terminal()
end

function MineManagerChooseStatus:onEnterTransitionFinish()

    local csbMineManagerChooseStatus = csb.createNode("campaign/MineManager/attack_territory_way.csb")
	local action = csb.createTimeline("campaign/MineManager/attack_territory_way.csb")
    csbMineManagerChooseStatus:runAction(action)
	action:play("window_open", false)
	self:addChild(csbMineManagerChooseStatus)
	
   	local root = csbMineManagerChooseStatus:getChildByName("root")
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_61"), nil, 
	{
		func_string = [[state_machine.excute("mine_manager_choose_status_back", 0, "mine_manager_choose_status_back.'")]],
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_65"), nil, 
	{
		func_string = [[state_machine.excute("mine_manager_choose_status_back", 0, "mine_manager_choose_status_back.'")]],
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_62"), nil, 
	{
		terminal_name = "mine_manager_choose_status_choose_back", 
		_status = 1,
		isPressedActionEnabled = true
	}, 
	nil, 1)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_63"), nil, 
	{
		terminal_name = "mine_manager_choose_status_choose_back", 
		_status = 2,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_64"), nil, 
	{
		terminal_name = "mine_manager_choose_status_choose_back", 
		_status = 3,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	
end

function MineManagerChooseStatus:onExit()
	state_machine.remove("mine_manager_choose_status_back")
	state_machine.remove("mine_manager_choose_status_choose_back")
end

function MineManagerChooseStatus:createCell()
	local cell = MineManagerChooseStatus:new()
	cell:registerOnNodeEvent(cell)
	return cell
end