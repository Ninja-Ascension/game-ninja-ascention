-- ----------------------------------------------------------------------------------------------------
-- 说明：连续登陆奖励
-------------------------------------------------------------------------------------------------------
SmActivityLangingReword = class("SmActivityLangingRewordClass", Window)

local sm_activity_langing_reword_window_open_terminal = {
    _name = "sm_activity_langing_reword_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmActivityLangingRewordClass")
        if nil == _homeWindow then
            local panel = SmActivityLangingReword:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_activity_langing_reword_window_close_terminal = {
    _name = "sm_activity_langing_reword_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmActivityLangingRewordClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmActivityLangingRewordClass"))
        end
        state_machine.excute("home_update_top_activity_info_state", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_langing_reword_window_open_terminal)
state_machine.add(sm_activity_langing_reword_window_close_terminal)
state_machine.init()
    
function SmActivityLangingReword:ctor()
    self.super:ctor()
    self.roots = {}
    self.loaded = false
    self.actions = {}
    self.ship_id = 0
    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    app.load("client.l_digital.cells.activity.wonderful.sm_activity_langing_reword_cell")
    app.load("client.cells.utils.resources_icon_cell")
    local function init_sm_activity_langing_reword_window_terminal()
        -- 显示界面
        local sm_activity_langing_reword_window_display_terminal = {
            _name = "sm_activity_langing_reword_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmActivityLangingRewordWindow = fwin:find("SmActivityLangingRewordClass")
                if SmActivityLangingRewordWindow ~= nil then
                    SmActivityLangingRewordWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_activity_langing_reword_window_hide_terminal = {
            _name = "sm_activity_langing_reword_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmActivityLangingRewordWindow = fwin:find("SmActivityLangingRewordClass")
                if SmActivityLangingRewordWindow ~= nil then
                    SmActivityLangingRewordWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local sm_activity_langing_reword_window_update_draw_terminal = {
            _name = "sm_activity_langing_reword_window_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(sm_activity_langing_reword_window_display_terminal)
        state_machine.add(sm_activity_langing_reword_window_hide_terminal)
        state_machine.add(sm_activity_langing_reword_window_update_draw_terminal)
        state_machine.init()
    end
    init_sm_activity_langing_reword_window_terminal()
end

function SmActivityLangingReword:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local activity = _ED.active_activity[24]
    if activity == nil then
        return
    end
    --列表
    local ListView_login_gift = ccui.Helper:seekWidgetByName(root,"ListView_login_gift")
    ListView_login_gift:jumpToTop()
    ListView_login_gift:removeAllItems()
    local index = 0
    if activity.activity_Info ~= nil then
        table.sort(activity.activity_Info, function(c1, c2)
            if c1 ~= nil 
                and c2 ~= nil 
                and ((zstring.tonumber(c1.activityInfo_isReward) < zstring.tonumber(c2.activityInfo_isReward))
                    or (zstring.tonumber(c1.activityInfo_isReward) == zstring.tonumber(c2.activityInfo_isReward) and zstring.tonumber(c1.activityInfo_need_day) < zstring.tonumber(c2.activityInfo_need_day))) then
                return true
            end
            return false
        end)
    end

    for i, v in pairs(activity.activity_Info) do
        local cell = state_machine.excute("sm_activity_langing_reword_cell",0,{v, i})
        ListView_login_gift:addChild(cell)
        if tonumber(v.activityInfo_isReward) > 0 then
            index = index + 1
        end
    end
    ListView_login_gift:requestRefreshView()

    self.currentListView = ListView_login_gift
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    --活动描述
    local Text_login_gift_p = ccui.Helper:seekWidgetByName(root,"Text_login_gift_p")

    --已经登陆的天数
    local currentDay = activity.activity_login_day
    local Text_10_0_1 = ccui.Helper:seekWidgetByName(root,"Text_10_0_1")
    Text_10_0_1:setString(currentDay)
    if tonumber(currentDay) >= 4 then
        currentDay = 4
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        local Panel_name = ccui.Helper:seekWidgetByName(root,"Panel_name")
        if Panel_name ~= nil then
            if currentDay == 1 then
                Panel_name:setBackGroundImage(string.format("images/ui/text/sm_hd/lxdl_%d.png", currentDay))
            else
                Panel_name:setBackGroundImage(string.format("images/ui/text/sm_hd/lxdl_%d.png", currentDay-1))
            end
        end
    else
        local Text_10_0_0 = ccui.Helper:seekWidgetByName(root,"Text_10_0_0")
        if Text_10_0_0 ~= nil then
            Text_10_0_0:setString(login_gift_reward_info[tonumber(currentDay)])
        end
    end

    local Panel_login_gift_role = ccui.Helper:seekWidgetByName(root,"Panel_login_gift_role")
    if Panel_login_gift_role ~= nil then
        Panel_login_gift_role:removeBackGroundImage()
        local shipsMouldId = tonumber(login_gift_reward_role_info[tonumber(currentDay)])
        local ships = fundShipWidthTemplateId(shipsMouldId)
        local shipIndex = 0 
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], shipsMouldId, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        if ships ~= nil then
            --进化模板id
            local ship_evo = zstring.split(ships.evolution_status, "|")
            local evo_mould_id = evo_info[tonumber(ship_evo[1])]
            --新的形象编号
            shipIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
        else
            local evo_mould_id = evo_info[dms.int(dms["ship_mould"], shipsMouldId, ship_mould.captain_name)]
            --新的形象编号
            shipIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
        end
        Panel_login_gift_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png",shipIndex))
    end
end

function SmActivityLangingReword:onUpdate(dt)
    if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentListView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentListView:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height < 0 or tempY > size.height + itemSize.height then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function SmActivityLangingReword:init()
    self:onInit()
    return self
end

function SmActivityLangingReword:onInit()
    if false then
        if self.loaded == false then
            return
        end
    end
    local csbSmActivityLangingReword = csb.createNode("activity/login_gift.csb")
    local root = csbSmActivityLangingReword:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmActivityLangingReword)
    local action = csb.createTimeline("activity/login_gift.csb")
    table.insert(self.actions, action)
    csbSmActivityLangingReword:runAction(action)
	action:play("animation0", false)
    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_login_gift_close"), nil, 
    {
        terminal_name = "sm_activity_langing_reword_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
end

function SmActivityLangingReword:lazy()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        if self.loaded == true then
            return
        end
        self.loaded = true
        self:init()
        self:registerOnNoteUpdate(self, 1)
    end
end

function SmActivityLangingReword:unload()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        self:removeAllChildren(true)
        self.loaded = false
        self.roots = {}
        self:unregisterOnNoteUpdate(self)
    end
end

function SmActivityLangingReword:onExit()
    state_machine.remove("sm_activity_langing_reword_window_display")
    state_machine.remove("sm_activity_langing_reword_window_hide")
end

function SmActivityLangingReword:createCell()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        local cell = SmActivityLangingReword:new()
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 1)
        return cell
    end
end