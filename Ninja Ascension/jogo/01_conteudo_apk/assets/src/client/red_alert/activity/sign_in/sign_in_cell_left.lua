--------------------------------------------------------------------------------------------------------------
-- 签到左侧控件
--------------------------------------------------------------------------------------------------------------
SignInCellLeft = class("SignInCellLeftClass", Window)
SignInCellLeft.__size = nil
--创建cell
local sign_in_cell_left_create_cell_terminal = {
    _name = "sign_in_cell_left_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local data = params[1]
        local index = params[2]
        local cell = SignInCellLeft:new()
        cell:init(data,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sign_in_cell_left_create_cell_terminal)
state_machine.init()

function SignInCellLeft:ctor()
	self.super:ctor()
	self.roots = {}
    self.data = nil
	 -- Initialize sign_in_cell_left state machine.
    local function init_sign_in_cell_left_terminal()
		
        --领取奖励
        local sign_in_cell_left_get_reward_terminal = {
            _name = "sign_in_cell_left_get_reward",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local login_day = tonumber(zstring.split(_ED.activity_info["15"].activity_add_state,",")[1])
                local need_login_day = zstring.split(cell.data.achieve_complete_count,"/")
                need_login_day = tonumber(need_login_day[2])
                if login_day < need_login_day then
                    return
                end

                if tonumber(cell.data.achieve_state) == 2 then
                    -- print("=======已领取",self.index)
                    return
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open",0,{1015})
                        if cell ~= nil and cell.updateDraw ~= nil then
                            cell:updateDraw()
                        end
                    end
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["15"].activity_id .. "\r\n" .."15" .. "\r\n" .. "0" .."\r\n" .. (cell.index - 1)
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, nil, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sign_in_cell_left_get_reward_terminal)
        state_machine.init()
    end
    
    -- call func sign_in_cell_left create state machine.
    init_sign_in_cell_left_terminal()

end

function SignInCellLeft:updateDraw()
    local root = self.roots[1]
    local data_temp = self.data.achieve_reward 
    data_temp = zstring.split(data_temp,",")
    local reward_data = {
        prop_item = data_temp[1],
        prop_type = data_temp[2],
        item_value = data_temp[3]
    }
    local Panel_add_sign_icon = ccui.Helper:seekWidgetByName(root,"Panel_add_sign_icon")
    Panel_add_sign_icon:removeAllChildren(true)
    local cell = nil
    if tonumber(reward_data.prop_type) == 6 then    
        if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(reward_data.prop_item), prop_mould.change_of_equipment))> 0 
            or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(reward_data.prop_item), prop_mould.use_of_ship)) > 0  then
            cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,8,0,false,true})
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,data,reward_data,8,0,false,true})
        end  
    elseif tonumber(reward_data.prop_type) == 34 then    
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,8,0,false,true})   
    else
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,8,0,false,true})
    end    
    Panel_add_sign_icon:addChild(cell)

    local Text_add_sign_name = ccui.Helper:seekWidgetByName(root,"Text_add_sign_name")
    local need_login_day = zstring.split(self.data.achieve_complete_count,"/")
    need_login_day = tonumber(need_login_day[2])
    Text_add_sign_name:setString(string.format(red_alert_all_str[151],need_login_day))

    if tonumber(self.data.achieve_state) == 2 then
        -- print("=======已领取",self.index)
    end

    local login_day = tonumber(zstring.split(_ED.activity_info["15"].activity_add_state,",")[1])
    if login_day >= tonumber(need_login_day) then
        -- print("=======可领取",self.index)
    end
end

--缓存清理
function SignInCellLeft:close()
    local Panel_add_sign_icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_add_sign_icon")
    Panel_add_sign_icon:removeAllChildren(true)
end

function SignInCellLeft:onInit()
    local csbItem = csb.createNode(config_csb.activity.sign_in.sign_in_cell_left)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(true)
    self:addChild(root)
    table.insert(self.roots, root) 
    
    if SignInCellLeft.__size == nil then
        SignInCellLeft.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add_sign"), nil, 
    {
        terminal_name = "sign_in_cell_left_get_reward", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 
	self:updateDraw()

end

function SignInCellLeft:onEnterTransitionFinish()

end

function SignInCellLeft:init(data,index)
    self.data = data
    self.index = index
	self:onInit()
    self:setContentSize(SignInCellLeft.__size)
end

function SignInCellLeft:onExit()
    
end