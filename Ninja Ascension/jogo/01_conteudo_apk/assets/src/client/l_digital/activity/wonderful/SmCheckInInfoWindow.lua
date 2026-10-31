-- ----------------------------------------------------------------------------------------------------
-- 说明：签到界面
-------------------------------------------------------------------------------------------------------
SmCheckInInfoWindow = class("SmCheckInInfoWindowClass", Window)

local sm_check_in_info_window_window_open_terminal = {
    _name = "sm_check_in_info_window_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
        then
        state_machine.excute("activity_window_open", 0, {"client.l_digital.activity.wonderful.SmCheckInInfoWindow", "SmCheckInInfoWindow"})
        state_machine.excute("activity_window_open_page_activity",0,{"SmCheckInInfoWindow"})
    else
        local _homeWindow = fwin:find("SmCheckInInfoWindowClass")
        if nil == _homeWindow then
            local panel = SmCheckInInfoWindow:new():init(params)
            fwin:open(panel,fwin._ui)
        end
    end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_check_in_info_window_window_close_terminal = {
    _name = "sm_check_in_info_window_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmCheckInInfoWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmCheckInInfoWindowClass"))
        end
        state_machine.excute("menu_window_login_popup_banner_open", 0, 0) 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_check_in_info_window_window_open_terminal)
state_machine.add(sm_check_in_info_window_window_close_terminal)
state_machine.init()
    
function SmCheckInInfoWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.loaded = false
    self.actions = {}
    self.ship_id = 0
    app.load("client.l_digital.cells.activity.wonderful.sm_activity_check_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.landscape.cells.duplicate.lpve_reward_cell")

    local function init_sm_check_in_info_window_window_terminal()
        -- 显示界面
        local sm_check_in_info_window_window_display_terminal = {
            _name = "sm_check_in_info_window_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmCheckInInfoWindowWindow = fwin:find("SmCheckInInfoWindowClass")
                if SmCheckInInfoWindowWindow ~= nil then
                    SmCheckInInfoWindowWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_check_in_info_window_window_hide_terminal = {
            _name = "sm_check_in_info_window_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmCheckInInfoWindowWindow = fwin:find("SmCheckInInfoWindowClass")
                if SmCheckInInfoWindowWindow ~= nil then
                    SmCheckInInfoWindowWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_check_in_info_window_check_terminal = {
            _name = "sm_check_in_info_window_check",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cells= params._datas.cells
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- if cells == nil then
                        --     return
                        -- end
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._ui)
                        local year,month = os.date("%Y", tonumber(_ED.system_time)), os.date("%m", tonumber(_ED.system_time))+1 -- 正常是获取服务器给的时间来算
                        local dayAmount = os.date("%d", os.time({year=year, month=month, day=0})) -- 获取当月天数
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:DrawUpdateList(tonumber(dayAmount))
                        end
                    end
                end
                local index = 1
                for i=32, #_ED.active_activity[38].activity_Info do
                    if tonumber(_ED.active_activity[38].activity_Info[i].activityInfo_isReward) == 0 then
                        index = i - 1
                        break
                    end
                end
                local activityId = nil
                activityId = _ED.active_activity[38].activity_id
                protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..index.."\r\n1"
                NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新签到天数
        local sm_check_in_info_window_update_draw_time_terminal = {
            _name = "sm_check_in_info_window_update_draw_time",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local year,month = os.date("%Y", tonumber(_ED.system_time)), os.date("%m", tonumber(_ED.system_time))+1 -- 正常是获取服务器给的时间来算
                local dayAmount = os.date("%d", os.time({year=year, month=month, day=0})) -- 获取当月天数
                instance:DrawUpdateList(tonumber(dayAmount))
                local number = 0
                for i, v in pairs(_ED.active_activity[38].activity_Info) do
                    if i<= tonumber(dayAmount) then
                        if tonumber(v.activityInfo_isReward) > 0 then
                            number = number + 1
                        end
                    end
                end
                local Text_sign_number = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_sign_number")
                Text_sign_number:setString("" .. number)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    local Text_leiji_number = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_leiji_number")
                    local days_info = zstring.split(_ED.active_activity[38].activity_day_infos, ",")
                    local receiveNumber = tonumber(days_info[1])
                    local needNumber = tonumber(days_info[2])
                    -- local max_dayAmount = _ED.active_activity[38].activity_Info[#_ED.active_activity[38].activity_Info].activityInfo_need_day
                    Text_leiji_number:setString(receiveNumber.."/"..needNumber)
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开签到累计奖励
        local sm_check_in_info_window_open_reworld_grand_total_terminal = {
            _name = "sm_check_in_info_window_open_reworld_grand_total",
            _init = function (terminal) 
                app.load("client/l_digital/activity/wonderful/SmCheckInInfoGrandTotal")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local activity = _ED.active_activity[38]
                if activity ~= nil then
                    local index = tonumber(params._datas.m_index)
                    state_machine.excute("sm_check_in_info_grand_total_open", 0, activity.activity_Info[index])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新宝箱
        local sm_check_in_info_window_update_reworld_grand_total_terminal = {
            _name = "sm_check_in_info_window_update_reworld_grand_total",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local year,month = os.date("%Y", tonumber(_ED.system_time)), os.date("%m", tonumber(_ED.system_time))+1 -- 正常是获取服务器给的时间来算
                local dayAmount = os.date("%d", os.time({year=year, month=month, day=0})) -- 获取当月天数
                instance:DrawUpdateList(tonumber(dayAmount))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_check_in_info_window_window_display_terminal)
        state_machine.add(sm_check_in_info_window_window_hide_terminal)
        state_machine.add(sm_check_in_info_window_check_terminal)
        state_machine.add(sm_check_in_info_window_update_draw_time_terminal)
        state_machine.add(sm_check_in_info_window_open_reworld_grand_total_terminal)
        state_machine.add(sm_check_in_info_window_update_reworld_grand_total_terminal)
        state_machine.init()
    end
    init_sm_check_in_info_window_window_terminal()
end

function SmCheckInInfoWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local horizontalNumber = 5
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        horizontalNumber = 5
    elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
        horizontalNumber = 7
    end
    local activity = _ED.active_activity[38]
    local year,month = os.date("%Y", tonumber(_ED.system_time)), os.date("%m", tonumber(_ED.system_time))+1 -- 正常是获取服务器给的时间来算
    local dayAmount = os.date("%d", os.time({year=year, month=month, day=0})) -- 获取当月天数

    local Panel_month = ccui.Helper:seekWidgetByName(root, "Panel_month")
    if Panel_month ~= nil then
        Panel_month:removeBackGroundImage()
        Panel_month:setBackGroundImage(string.format("images/ui/text/QD_res/qd_%d.png",month-1))
    end

    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_sign_reward")
    m_ScrollView:removeAllChildren(true)
    local panel = m_ScrollView:getInnerContainer()
    panel:setContentSize(m_ScrollView:getContentSize())
    panel:setPosition(cc.p(0,0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = m_ScrollView:getInnerContainerSize()
    local nextY = sSize.height
    local nextX = sSize.width
    local tHeight = 0
    local cellHeight = 0
    local tWidth = 0
    local wPosition = sWidth/horizontalNumber
    local Hlindex = 0
    local number = tonumber(dayAmount)
    local m_number = math.ceil(number/horizontalNumber)
    cellHeight = m_number*(m_ScrollView:getContentSize().width/horizontalNumber)
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    local first = nil
    local index = 0 
    local number = 0    --已经领取的总数
    for i, v in pairs(activity.activity_Info) do
        if i<= tonumber(dayAmount) then
            if tonumber(v.activityInfo_isReward) > 0 then
                number = number + 1
            end
        end
    end
    for j, v in pairs(activity.activity_Info) do
        if (index+1)<= tonumber(dayAmount) then
            index = index + 1
            self:runAction(cc.Sequence:create({cc.DelayTime:create((index-1)*0.05), cc.CallFunc:create(function ( sender )
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
                then
                    if sender ~= nil and sender.roots ~= nil and sender.roots[1] ~= nil and sender.loaded == true then
                        local cell = state_machine.excute("sm_activity_check_cell",0,{v,0,j,number})
                        panel:addChild(cell)
                        -- table.insert(self.prop_list, cell)
                        if j == 1 then
                            first = cell
                        end
                        tWidth = tWidth + wPosition
                        if (j-1)%horizontalNumber ==0 then
                            Hlindex = Hlindex+1
                            tWidth = 0
                            tHeight = sHeight - wPosition*Hlindex  
                        end
                        if j <= horizontalNumber then
                            tHeight = sHeight - wPosition
                        end
                        cell:setPosition(cc.p(tWidth,tHeight))
                    end
                else
                    local cell = state_machine.excute("sm_activity_check_cell",0,{v,0,j,number})
                    panel:addChild(cell)
                    -- table.insert(self.prop_list, cell)
                    if j == 1 then
                        first = cell
                    end
                    tWidth = tWidth + wPosition
                    if (j-1)%horizontalNumber ==0 then
                        Hlindex = Hlindex+1
                        tWidth = 0
                        tHeight = sHeight - wPosition*Hlindex  
                    end
                    if j <= horizontalNumber then
                        tHeight = sHeight - wPosition
                    end
                    cell:setPosition(cc.p(tWidth,tHeight))
                end
            end)}))
        end
    end
    m_ScrollView:jumpToTop()

    local Text_sign_number = ccui.Helper:seekWidgetByName(root, "Text_sign_number")
    Text_sign_number:setString("" .. number)

    self:DrawUpdateList(tonumber(dayAmount))

end

function SmCheckInInfoWindow:DrawUpdateList(number)
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local activity = _ED.active_activity[38]
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        local ListView_leiji_reward = ccui.Helper:seekWidgetByName(root, "ListView_leiji_reward")
        ListView_leiji_reward:removeAllItems()
        local activity2Datas = nil
        for i=32, #activity.activity_Info do
            if tonumber(activity.activity_Info[i].activityInfo_isReward) == 0 then
                activity2Datas = activity.activity_Info[i]
                self.receiveNumber = i
                break
            end
        end
        if activity2Datas ~= nil then
            if tonumber(activity2Datas.activityInfo_silver) ~= 0 then
                --金币
                local cell = ResourcesIconCell:createCell()
                cell:init(1, tonumber(activity2Datas.activityInfo_silver), -1,nil,nil,true,true)
                ListView_leiji_reward:addChild(cell)
            end
            if tonumber(activity2Datas.activityInfo_gold) ~= 0 then
                --钻石
                local cell = ResourcesIconCell:createCell()
                cell:init(2, tonumber(activity2Datas.activityInfo_gold), -1,nil,nil,true,true)
                ListView_leiji_reward:addChild(cell)
            end
            if tonumber(activity2Datas.activityInfo_food) ~= 0 then
                --体力
                local cell = ResourcesIconCell:createCell()
                cell:init(12, tonumber(activity2Datas.activityInfo_gold), -1,nil,nil,true,true)
                ListView_leiji_reward:addChild(cell)
            end
            -- if tonumber(_ED.active_activity[39].activity_Info[m_number].activityInfo_equip_count) ~= 0 then
            --     --装备
            --     local equip_data = _ED.active_activity[39].activity_Info[m_number].activityInfo_equip_info[1]
            --     local cell = ResourcesIconCell:createCell()
            --     cell:init(7, tonumber(equip_data.propMouldCount), equip_data.propMould,nil,nil,true,true)
            --     Panel_props:addChild(cell)
            -- end
            if tonumber(activity2Datas.activityInfo_prop_count) ~= 0 then
                --道具
                local prop_data = activity2Datas.activityInfo_prop_info[1]
                local cell = ResourcesIconCell:createCell()
                cell:init(6, tonumber(prop_data.propMouldCount), prop_data.propMould,nil,nil,true,true)
                ListView_leiji_reward:addChild(cell)
                if dms.int(dms["prop_mould"], prop_data.propMould, prop_mould.use_of_ship) > 0  and dms.int(dms["prop_mould"], prop_data.propMould, prop_mould.storage_page_index) == 18 then
                    local jsonFile = "sprite/sprite_wzkp.json"
                    local atlasFile = "sprite/sprite_wzkp.atlas"
                    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                    animation:setPosition(cc.p(cell:getContentSize().width/2,cell:getContentSize().height/2))
                    animation:setTag(2586)
                    cell:addChild(animation)
                end
            end
        end

        --设置listview不可动 取消其滑动方向，但需要手动对齐子控件
        ListView_leiji_reward:setDirection(ccui.ListViewDirection.none)
        -- local itemSpace = ListView_leiji_reward:getItemsMargin()
        -- local items = ListView_leiji_reward:getItems()
        -- for i ,v in pairs(items) do
        --     local root = v:getChildByName("root")
        --     root:setPositionX(root:getPositionX() - ( i - 1) * itemSpace)
        -- end
        ListView_leiji_reward:requestRefreshView()
        -- local receiveNumber = 0
        -- for i, v in pairs(activity.activity_Info) do
        --     if i<= number then
        --         if tonumber(v.activityInfo_isReward) > 0 then
        --             receiveNumber = receiveNumber + 1
        --         end
        --     end
        -- end
        local days_info = zstring.split(activity.activity_day_infos, ",")
        local receiveNumber = tonumber(days_info[1])
        local needNumber = tonumber(days_info[2])
        if activity2Datas ~= nil then
            local Text_leiji_number = ccui.Helper:seekWidgetByName(root, "Text_leiji_number")
            Text_leiji_number:setString(receiveNumber.."/"..needNumber)
            if receiveNumber < tonumber(needNumber) then
                ccui.Helper:seekWidgetByName(root,"Button_receive"):setBright(false)
                ccui.Helper:seekWidgetByName(root,"Button_receive"):setTouchEnabled(false)
                for i, v in pairs(ListView_leiji_reward:getItems()) do
                    if v:getChildByTag(2587) ~= nil then 
                        v:removeChildByTag(2587)
                    end
                end
            else
                for i, v in pairs(ListView_leiji_reward:getItems()) do
                    if v:getChildByTag(2586) == nil then 
                        if v:getChildByTag(2587) ~= nil then 
                            v:removeChildByTag(2587)
                        end
                        local jsonFile = "sprite/sprite_wzkp.json"
                        local atlasFile = "sprite/sprite_wzkp.atlas"
                        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                        animation:setPosition(cc.p(v:getContentSize().width/2,v:getContentSize().height/2))
                        animation:setTag(2587)
                        v:addChild(animation)
                    end
                end
                ccui.Helper:seekWidgetByName(root,"Button_receive"):setBright(true)
                ccui.Helper:seekWidgetByName(root,"Button_receive"):setTouchEnabled(true)
            end
            local LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
            local persent = math.floor(tonumber(receiveNumber)*100/tonumber(needNumber))
            LoadingBar_1:setPercent(persent)
        end
    else
        local ListView_leiji_reward = ccui.Helper:seekWidgetByName(root, "ListView_leiji_reward")
        ListView_leiji_reward:removeAllItems()
        local activity2Datas = nil
        for i=32, #activity.activity_Info do
            if tonumber(activity.activity_Info[i].activityInfo_isReward) == 0 then
                activity2Datas = activity.activity_Info[i]
                self.receiveNumber = i
                break
            end
        end
        if activity2Datas ~= nil then
            if tonumber(activity2Datas.activityInfo_silver) ~= 0 then
                --金币
                local cell = ResourcesIconCell:createCell()
                cell:init(1, tonumber(activity2Datas.activityInfo_silver), -1,nil,nil,true)
                ListView_leiji_reward:addChild(cell)
            end
            if tonumber(activity2Datas.activityInfo_gold) ~= 0 then
                --钻石
                local cell = ResourcesIconCell:createCell()
                cell:init(2, tonumber(activity2Datas.activityInfo_gold), -1,nil,nil,true)
                ListView_leiji_reward:addChild(cell)
            end
            if tonumber(activity2Datas.activityInfo_food) ~= 0 then
                --体力
                local cell = ResourcesIconCell:createCell()
                cell:init(12, tonumber(activity2Datas.activityInfo_gold), -1,nil,nil,true)
                ListView_leiji_reward:addChild(cell)
            end
            -- if tonumber(_ED.active_activity[39].activity_Info[m_number].activityInfo_equip_count) ~= 0 then
            --     --装备
            --     local equip_data = _ED.active_activity[39].activity_Info[m_number].activityInfo_equip_info[1]
            --     local cell = ResourcesIconCell:createCell()
            --     cell:init(7, tonumber(equip_data.propMouldCount), equip_data.propMould,nil,nil,true,true)
            --     Panel_props:addChild(cell)
            -- end
            if tonumber(activity2Datas.activityInfo_prop_count) ~= 0 then
                --道具
                local prop_data = activity2Datas.activityInfo_prop_info[1]
                local cell = ResourcesIconCell:createCell()
                cell:init(6, tonumber(prop_data.propMouldCount), prop_data.propMould,nil,nil,true)
                ListView_leiji_reward:addChild(cell)
                if dms.int(dms["prop_mould"], prop_data.propMould, prop_mould.use_of_ship) > 0  and dms.int(dms["prop_mould"], prop_data.propMould, prop_mould.storage_page_index) == 18 then
                    local jsonFile = "sprite/sprite_wzkp.json"
                    local atlasFile = "sprite/sprite_wzkp.atlas"
                    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                    animation:setPosition(cc.p(cell:getContentSize().width/2,cell:getContentSize().height/2))
                    cell:addChild(animation)
                end
            end
        end

        --设置listview不可动 取消其滑动方向，但需要手动对齐子控件
        ListView_leiji_reward:setDirection(ccui.ListViewDirection.none)
        local itemSpace = ListView_leiji_reward:getItemsMargin()
        local items = ListView_leiji_reward:getItems()
        for i ,v in pairs(items) do
            local root = v:getChildByName("root")
            root:setPositionY(root:getPositionY() - ( i - 1) * itemSpace)
        end
        --ListView_leiji_reward:requestRefreshView()
        -- local receiveNumber = 0
        -- for i, v in pairs(activity.activity_Info) do
        --     if i<= number then
        --         if tonumber(v.activityInfo_isReward) > 0 then
        --             receiveNumber = receiveNumber + 1
        --         end
        --     end
        -- end
        local days_info = zstring.split(activity.activity_day_infos, ",")
        local receiveNumber = tonumber(days_info[1])
        local needNumber = tonumber(days_info[2])
        if activity2Datas ~= nil then
            local Text_leiji_number = ccui.Helper:seekWidgetByName(root, "Text_leiji_number")
            Text_leiji_number:setString(receiveNumber.."/"..needNumber)
            if receiveNumber < tonumber(needNumber) then
                ccui.Helper:seekWidgetByName(root,"Button_receive"):setBright(false)
                ccui.Helper:seekWidgetByName(root,"Button_receive"):setTouchEnabled(false)
            else
                ccui.Helper:seekWidgetByName(root,"Button_receive"):setBright(true)
                ccui.Helper:seekWidgetByName(root,"Button_receive"):setTouchEnabled(true)
            end
        end
    end
end 

function SmCheckInInfoWindow:init()
    self:onInit()
    return self
end

function SmCheckInInfoWindow:onInit()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
        then
        if self.loaded == false then
            return
        end
    end
    local csbSmCheckInInfoWindow = csb.createNode("activity/wonderful/sm_month_sign_reward.csb")
    local root = csbSmCheckInInfoWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmCheckInInfoWindow)
    local action = csb.createTimeline("activity/wonderful/sm_month_sign_reward.csb")
    table.insert(self.actions, action)
    csbSmCheckInInfoWindow:runAction(action)
	action:play("window_open", false)
    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "sm_check_in_info_window_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    -- 领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_receive"), nil, 
    {
        terminal_name = "sm_check_in_info_window_check",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
end

function SmCheckInInfoWindow:onExit()
    if _ED.native_time ~= nil and _ED.system_time ~= nil then
        local server_time = _ED.system_time + (os.time() - _ED.native_time)
        cc.UserDefault:getInstance():setStringForKey(getKey("notification_popup_windows_-1"), zstring.tonumber(server_time) - _ED.GTM_Time)
        state_machine.remove("sm_check_in_info_window_window_display")
        state_machine.remove("sm_check_in_info_window_window_hide")
    end
end

function SmCheckInInfoWindow:lazy()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
        then
        if self.loaded == true then
            return
        end
        self.loaded = true
        self:init()
        self:registerOnNoteUpdate(self, 1)
    end
end

function SmCheckInInfoWindow:unload()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
        then
        self:stopAllActions()
        self:removeAllChildren(true)
        self.loaded = false
        self.roots = {}
        self:unregisterOnNoteUpdate(self)
    end
end

function SmCheckInInfoWindow:createCell()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
        then
        local cell = SmCheckInInfoWindow:new()
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 1)
        return cell
    end
end