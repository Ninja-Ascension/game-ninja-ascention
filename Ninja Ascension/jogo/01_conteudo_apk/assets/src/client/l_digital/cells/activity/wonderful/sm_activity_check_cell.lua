--------------------------------------------------------------------------------------------------------------
--  说明：签到的单个控件
--------------------------------------------------------------------------------------------------------------
SmActivityCheckCell = class("SmActivityCheckCellClass", Window)
SmActivityCheckCell.__size = nil

--创建cell
local sm_activity_check_cell_terminal = {
    _name = "sm_activity_check_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmActivityCheckCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_activity_check_cell_check_terminal = {
    _name = "sm_activity_check_cell_check",
    _init = function (terminal)       
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cells= params._datas.cells
        local isAuto = params._datas.isAuto
        if isAuto == nil and tonumber(cells.activity.activityInfo_isReward) == 2 and tonumber(_ED.vip_grade) < tonumber(cells.activity.activityInfo_need_vip) then
            app.load("client.l_digital.union.meeting.SmUnionTipsWindow")
            state_machine.excute("sm_union_tips_window_open", 0, {_new_interface_text[87],1,cells})
        else
            local function responseGetServerListCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if cells == nil or cells.roots == nil or cells.roots[1] == nil then
                        return
                    end
                    app.load("client.reward.DrawRareReward")
                    local getRewardWnd = DrawRareReward:new()
                    getRewardWnd:init(7)
                    fwin:open(getRewardWnd, fwin._ui)
                    cells.activity = _ED.active_activity[38].activity_Info[tonumber(cells.index)]
                    -- local year,month = os.date("%Y", tonumber(_ED.system_time)), os.date("%m", tonumber(_ED.system_time))+1 -- 正常是获取服务器给的时间来算
                    -- local dayAmount = os.date("%d", os.time({year=year, month=month, day=0})) -- 获取当月天数
                    cells:updateDraw()
                    state_machine.excute("sm_check_in_info_window_update_draw_time",0,"")    
                end
            end
            local activityId = nil
            activityId = _ED.active_activity[38].activity_id
            protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..(tonumber(cells.index)-1).."\r\n1"
            NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, cells, responseGetServerListCallback, false, nil)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_check_cell_check_terminal)
state_machine.add(sm_activity_check_cell_terminal)
state_machine.init()

function SmActivityCheckCell:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.cells.utils.resources_icon_cell")
	 -- Initialize sm_activity_check_cell state machine.
    local function init_sm_activity_check_cell_terminal()
        
        state_machine.init()
    end 
    -- call func sm_activity_check_cell create state machine.
    init_sm_activity_check_cell_terminal()

end

function SmActivityCheckCell:updateDraw()
    local root = self.roots[1]
    local activity = _ED.active_activity[38]
    --道具
    local Panel_props = ccui.Helper:seekWidgetByName(root, "Panel_props")
    Panel_props:removeAllChildren(true)
    if tonumber(self.activity.activityInfo_silver) ~= 0 then
        --金币
        local cell = ResourcesIconCell:createCell()
        cell:init(1, tonumber(self.activity.activityInfo_silver), -1,nil,nil,true,true)
        Panel_props:addChild(cell)
    elseif tonumber(self.activity.activityInfo_gold) ~= 0 then
        --钻石
        local cell = ResourcesIconCell:createCell()
        cell:init(2, tonumber(self.activity.activityInfo_gold), -1,nil,nil,true,true)
        Panel_props:addChild(cell)
    elseif tonumber(self.activity.activityInfo_food) ~= 0 then
        --体力
        local cell = ResourcesIconCell:createCell()
        cell:init(12, tonumber(self.activity.activityInfo_gold), -1,nil,nil,true,true)
        Panel_props:addChild(cell)
    -- elseif tonumber(self.activity.activityInfo_equip_count) ~= 0 then
    --     --装备
    --     local equip_data = self.activity.activityInfo_equip_info[1]
    --     local cell = ResourcesIconCell:createCell()
    --     cell:init(7, tonumber(equip_data.propMouldCount), equip_data.propMould,nil,nil,true,true)
    --     Panel_props:addChild(cell)
    elseif tonumber(self.activity.activityInfo_prop_count) ~= 0 then
        --道具
        local prop_data = self.activity.activityInfo_prop_info[1]
        local cell = ResourcesIconCell:createCell()
        cell:init(6, tonumber(prop_data.propMouldCount), prop_data.propMould,nil,nil,true,true)
        Panel_props:addChild(cell)
        if dms.int(dms["prop_mould"], prop_data.propMould, prop_mould.use_of_ship) > 0  and dms.int(dms["prop_mould"], prop_data.propMould, prop_mould.storage_page_index) == 18 then
            local jsonFile = "sprite/sprite_wzkp.json"
            local atlasFile = "sprite/sprite_wzkp.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            animation:setPosition(cc.p(Panel_props:getContentSize().width/2,Panel_props:getContentSize().height/2))
            Panel_props:addChild(animation)
        end
    end

    --vip双倍的标识
    local Image_vip_bg = ccui.Helper:seekWidgetByName(root, "Image_vip_bg")
    if tonumber(self.activity.activityInfo_need_vip) > 0 then
        Image_vip_bg:setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Text_vip_double"):setString(string.format(_new_interface_text[79],zstring.tonumber(self.activity.activityInfo_need_vip)))
    else
        Image_vip_bg:setVisible(false)
    end
    --vip继续领取的标识
    local Image_continue = ccui.Helper:seekWidgetByName(root, "Image_continue")

    local Image_props_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_props_bg_1")
    local Image_props_bg_2 = ccui.Helper:seekWidgetByName(root, "Image_props_bg_2")
    --不能再领的标识
    local Panel_received = ccui.Helper:seekWidgetByName(root, "Panel_received")
    if tonumber(self.index) >= tonumber(_ED.active_activity[38].activity_login_day) then
        Panel_received:setVisible(false)
        Image_continue:setVisible(false)
        -- 需求天数大于已经领取天数
        if tonumber(self.index) == tonumber(_ED.active_activity[38].activity_login_day) then
            --可领取
            if tonumber(self.activity.activityInfo_isReward) == 2 then
                Image_continue:setVisible(true)
            elseif tonumber(self.activity.activityInfo_isReward) == 1 then
                ccui.Helper:seekWidgetByName(root,"Panel_check"):setTouchEnabled(false)
                Panel_received:setVisible(true)  
                Image_props_bg_1:setVisible(true)
                Image_props_bg_2:setVisible(false)
            else
                ccui.Helper:seekWidgetByName(root,"Panel_check"):setTouchEnabled(true)
                Image_props_bg_1:setVisible(false)
                Image_props_bg_2:setVisible(true)
                state_machine.excute("sm_activity_check_cell_check", 0, {_datas = {cells = self, isAuto = true}})
            end
        else
            --不能领取
            ccui.Helper:seekWidgetByName(root,"Panel_check"):setTouchEnabled(false)
            Image_props_bg_1:setVisible(true)
            Image_props_bg_2:setVisible(false)
        end
        
    elseif tonumber(self.index) < tonumber(_ED.active_activity[38].activity_login_day) then
        -- 需求天数小于已经领取天数
        -- 领取按钮不能点击
        -- 会被标黑
        ccui.Helper:seekWidgetByName(root,"Panel_check"):setTouchEnabled(false)
        Panel_received:setVisible(true)
        Image_props_bg_1:setVisible(true)
        Image_props_bg_2:setVisible(false)
    end
end

function SmActivityCheckCell:onUpdate(dt)
    
end

function SmActivityCheckCell:onInit()
    local root = cacher.createUIRef("activity/wonderful/sm_month_sign_reward_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmActivityCheckCell.__size == nil then
        SmActivityCheckCell.__size = root:getContentSize()
    end

    -- if tonumber(self.m_type) == 0 then
    -- 	--
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_check"), nil, 
        {
            terminal_name = "sm_activity_check_cell_check", 
            terminal_state = 0, 
            touch_black = true,
    		cells = self,
        }, nil, 1)
    -- end

	self:updateDraw()
end

function SmActivityCheckCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function SmActivityCheckCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_props = ccui.Helper:seekWidgetByName(root, "Panel_props")
    if Panel_props ~= nil then
        Panel_props:removeAllChildren(true)
    end
end

function SmActivityCheckCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmActivityCheckCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/sm_month_sign_reward_list.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmActivityCheckCell:init(params)
    self.activity = params[1]
    self.m_type = params[2]
    self.index = tonumber(params[3])
    self.number = tonumber(params[4])
	self:onInit()

    self:setContentSize(SmActivityCheckCell.__size)
    return self
end

function SmActivityCheckCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/sm_month_sign_reward_list.csb", self.roots[1])
end