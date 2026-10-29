--------------------------------------------------------------------------------------------------------------
--  -- 签到右侧控件
--------------------------------------------------------------------------------------------------------------
SignInCellRight = class("SignInCellRightClass", Window)
SignInCellRight.__size = nil
--创建cell
local sign_in_cell_right_create_cell_terminal = {
    _name = "sign_in_cell_right_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local data = params[1]
        local col_index = params[2]
        local index = params[3]
        local cell = SignInCellRight:new()
        cell:init(data,col_index,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sign_in_cell_right_create_cell_terminal)
state_machine.init()

function SignInCellRight:ctor()
	self.super:ctor()
	self.roots = {}
    self.data = nil
    self.index = nil

    app.load("client.utils.ConfirmTip")
	 -- Initialize sign_in_cell_right state machine.
    local function init_sign_in_cell_right_terminal()
	
        local sign_in_cell_right_click_terminal = {
            _name = "sign_in_cell_right_click",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local need_vip = params[1].parent.data.achieve_other_info
                local data_temp = params[1].parent.data.achieve_reward
                local index = params[1].parent.data.achieve_index
                data_temp = zstring.split(data_temp,",")
                local reward_data = {
                    prop_item = data_temp[1],
                    prop_type = data_temp[2],
                    item_value = data_temp[3]
                }
                local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
                need_vip = zstring.split(need_vip,",")
                need_vip = need_vip[2]
                if zstring.tonumber(need_vip) > 0 then
                    if zstring.tonumber(need_vip) == 8 
                        and (_ED.month_card == nil 
                        or _ED.month_card == ""
                        or _ED.month_card[_drawMonth[1][1]] == nil) 
                        then
                        -- local tip = ConfirmTip:new()
                        -- tip:init(params[1].parent, params[1].parent.sureBuy, red_alert_all_str[192])
                        -- fwin:open(tip, fwin._windows)
                        
                        state_machine.excute("sign_in_receive_two_window_open",0,{reward_data,need_vip,index})
                    elseif zstring.tonumber(need_vip) == 9 
                        and (_ED.month_card == nil 
                        or _ED.month_card == ""
                        or _ED.month_card[_drawMonth[1][1]] == nil) 
                        then
                        -- local tip = ConfirmTip:new()
                        -- tip:init(params[1].parent, params[1].parent.sureBuy, red_alert_all_str[196])
                        -- fwin:open(tip, fwin._windows)
                        state_machine.excute("sign_in_receive_two_window_open",0,{reward_data,need_vip,index})
                    else
                        -- params[1].parent:sureBuy(0)
                        state_machine.excute("sign_in_receive_two_window_open",0,{reward_data,need_vip,index})
                    end
                else
                    -- params[1].parent:sureBuy(0)
                    state_machine.excute("sign_in_receive_window_open",0,{reward_data,need_vip,index})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sign_in_cell_right_click_terminal)
        state_machine.init()
    end
    
    -- call func sign_in_cell_right create state machine.
    init_sign_in_cell_right_terminal()

end

function SignInCellRight:sureBuy(sure_number)
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("reward_obtain_window_open",0,{1015})
            state_machine.excute("sign_in_update_state",0,"")    
        end
    end
    if sure_number == 0 then
        local login_day = tonumber(zstring.split(_ED.activity_info["15"].activity_add_state,",")[2])
        protocol_command.draw_activity_reward.param_list = _ED.activity_info["15"].activity_id .."\r\n" .. "15" .. "\r\n" .. "1" .."\r\n" .. (login_day - 1)
        NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, nil, responseCallback, false, nil) 
    end
end

function SignInCellRight:updateDraw()
    local root = self.roots[1]
    local Panel_sign_icon = ccui.Helper:seekWidgetByName(root,"Panel_sign_icon") 
    if Panel_sign_icon == nil then
        --缓存的刷新
        return
    end
    Panel_sign_icon:removeAllChildren(true)
    local data_temp = self.data.achieve_reward 

    data_temp = zstring.split(data_temp,",")
    local reward_data = {
        prop_item = data_temp[1],
        prop_type = data_temp[2],
        item_value = data_temp[3]
    }

    local Panel_on_sign = ccui.Helper:seekWidgetByName(root,"Panel_on_sign")
    local Panel_hide = ccui.Helper:seekWidgetByName(root,"Panel_hide")

    Panel_on_sign:setVisible(false)
    Panel_hide:setTouchEnabled(false)
    local can_touch = false
    local login_day = tonumber(zstring.split(_ED.activity_info["15"].activity_add_state,",")[2])
    if login_day < zstring.tonumber(self.index) then    --签到的天数小于当前的天数
        -- Panel_hide:setTouchEnabled(true)
        Panel_on_sign:setVisible(false)
        can_touch = true
    elseif login_day >= zstring.tonumber(self.index) then   --等于的时候
        if zstring.tonumber(self.data.achieve_state) == 2 then
            -- Panel_hide:setTouchEnabled(true)
            Panel_on_sign:setVisible(false)
            can_touch = false
        else
            -- Panel_hide:setTouchEnabled(false)
            Panel_on_sign:setVisible(true)
            can_touch = true
        end
    end

    local touch_type = 0

    if can_touch == true then
        touch_type = 13
    else
        touch_type = 9
    end
    local cell = nil
    if tonumber(reward_data.prop_type) == 6 then    
        if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(reward_data.prop_item), prop_mould.change_of_equipment))> 0 
            or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(reward_data.prop_item), prop_mould.use_of_ship)) > 0  then
            cell = state_machine.excute("all_resource_create_cell",0,{3,reward_data,reward_data,touch_type,0,false,true})
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        end  
    elseif tonumber(reward_data.prop_type) == 34 then    
        cell = state_machine.excute("all_resource_create_cell",0,{5,reward_data,reward_data,touch_type,0,false,true})   
    else
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
    end
    cell.parent = self
    Panel_sign_icon:addChild(cell)

    local Image_sign_r_hook = ccui.Helper:seekWidgetByName(root,"Image_sign_r_hook")
    Image_sign_r_hook:setVisible(false)
    local Image_had_geted = ccui.Helper:seekWidgetByName(root,"Image_had_geted")
    Image_had_geted:setVisible(false)

    if tonumber(self.data.achieve_state) == 2 then
        Image_sign_r_hook:setVisible(true)
        Image_had_geted:setVisible(true)
    end
    local Image_vip = ccui.Helper:seekWidgetByName(root,"Image_vip")
    Image_vip:setVisible(false)
    local BitmapFontLabel_v = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_v")
    BitmapFontLabel_v:setString("")
    local need_vip = self.data.achieve_other_info
    need_vip = zstring.split(need_vip,",")
    need_vip = need_vip[2]
    if zstring.tonumber(need_vip) > 0 then
        Image_vip:setVisible(true)
        BitmapFontLabel_v:setString(sign_in_string[tonumber(need_vip)])
    end
    if zstring.tonumber(need_vip) == 8 then
        ccui.Helper:seekWidgetByName(root,"Image_vip_gold"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root,"Image_vip_gold"):setVisible(false)
    end
end

function SignInCellRight:onInit()
    local root = cacher.createUIRef(config_csb.activity.sign_in.sign_in_cell_right, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    if SignInCellRight.__size == nil then
        SignInCellRight.__size = root:getContentSize()
    end

	self:updateDraw()

end

function SignInCellRight:onEnterTransitionFinish()

end

function SignInCellRight:init(data,col_index,index)
    self.data = data
    self.index = index
    if col_index ~= nil and col_index < 5 then
	   self:onInit()
    end
    self:setContentSize(SignInCellRight.__size)
end


function SignInCellRight:onExit()
    local root = self.roots[1]
    local Panel_sign_icon = ccui.Helper:seekWidgetByName(root,"Panel_sign_icon") 
    if Panel_sign_icon ~= nil then
        Panel_sign_icon:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.activity.sign_in.sign_in_cell_right, self.roots[1])

end

function SignInCellRight:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SignInCellRight:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local Panel_sign_icon = ccui.Helper:seekWidgetByName(root,"Panel_sign_icon") 
    Panel_sign_icon:removeAllChildren(true)
    cacher.freeRef(config_csb.activity.sign_in.sign_in_cell_right, root)
    root:removeFromParent(false)
    self.roots = {}
end