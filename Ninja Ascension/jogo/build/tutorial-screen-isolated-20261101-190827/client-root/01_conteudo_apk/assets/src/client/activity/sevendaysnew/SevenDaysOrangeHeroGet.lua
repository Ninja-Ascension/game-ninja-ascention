----------------------------------------------------------------------------------------------------
-- 说明：次日活动大宝箱
-- to:
-------------------------------------------------------------------------------------------------------
-- app.load("client.cells.reward.SevenDaysOrangeHeroGet")
SevenDaysOrangeHeroGet = class("SevenDaysOrangeHeroGetClass", Window)
local seven_days_box_hero_open_terminal = {
    _name = "seven_days_box_hero_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)

        local win = SevenDaysOrangeHeroGet:new()
        win:init(params)
        fwin:open(win, fwin._ui)

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(seven_days_box_hero_open_terminal)
state_machine.init()
function SevenDaysOrangeHeroGet:ctor()
    self.super:ctor()
    -- 定义封装类中的变量
    self.roots = {}             -- 界面中的UI根节点，供模块获取界面中的UI元素实例
    self.selectIndex = 0        -- 当前点击选中的索引
    
    self.res = {                -- 资源集合
        icon = { -- 图标
        },
        choice = { -- 选中
        },  
        touch = { -- 响应区
        },  
        
    }
    self.selectIndex = 0
    self.idList ={} --存着每个显示的模板id
    self.activityType = 0
    self.chooseActivityIndex = 0
    self.lastParent = nil
    
    self.vacancyIndex = 1   -- 空着的位置索引,用于创建时填入空位的.
    self.reward_id = nil
    local function init_big_box_rewad_terminal()
        local seven_days_box_getreward_hero_close_terminal = {
            _name = "seven_days_box_getreward_hero_close",
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
        
        --橙色英雄
        local seven_days_box_getreward_hero_terminal = {
            _name = "seven_days_box_getreward_hero",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(instance.activityType) == 7 then
                    local function responseDrawWeekRewardCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            for i,v in ipairs(_ED.active_activity[42].seven_days_rewards[7].welfare) do
                                if response.node.reward_id == tonumber(v.id) then
                                    _ED.active_activity[42].seven_days_rewards[7].welfare[i].state = "1"
                                end
                            end
                            response.node:updateButton()
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(47)
                            fwin:open(getRewardWnd, fwin._ui)
                            state_machine.excute("seven_days_every_day_update_state",0,"")
                            fwin:close(response.node)
                        end
                    end

                    local index = instance.selectIndex -1
                    protocol_command.draw_week_reward.param_list = "" .. 7 .. "\r\n" .. 0 ..  "\r\n"..instance.reward_id .. "\r\n" .. index
                    NetworkManager:register(protocol_command.draw_week_reward.code, nil, nil, nil, instance, responseDrawWeekRewardCallback, false, nil)
                elseif tonumber(instance.activityType) == 17 then
                    local index = instance.selectIndex
                    local function responseGetServerListCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.lastParent ~= nil then
                                response.node.lastParent:updateGetRewardEnd(index - 1)
                            end
                            fwin:close(instance)
                        end
                    end
                    local activityId = _ED.active_activity[17].activity_id
                    local chooseActivityIndex = tonumber(instance.chooseActivityIndex) - 1
                
                    protocol_command.get_activity_reward.param_list = activityId.."\r\n"..chooseActivityIndex.."\r\n"..index
                    NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local seven_days_box_getreward_hero_change_select_terminal = {
            _name = "seven_days_box_getreward_hero_change_select",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateSelectIndex(params._datas.index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
                
        
        state_machine.add(seven_days_box_getreward_hero_close_terminal)
        state_machine.add(seven_days_box_getreward_hero_terminal)
        state_machine.add(seven_days_box_getreward_hero_change_select_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_big_box_rewad_terminal()
end

function SevenDaysOrangeHeroGet:addToIconPanel(cell)
    local vIndex = self.vacancyIndex
    local iconPanel = self.res.icon[vIndex]
    if nil ~= iconPanel then
        iconPanel:addChild(cell)
        self.vacancyIndex = self.vacancyIndex + 1
    end
end


function SevenDaysOrangeHeroGet:getPropIconCell(mid)
    app.load("client.cells.prop.model_prop_icon_cell")
    local iconCell = ModelPropIconCell:createCell()
    local config = iconCell:createConfig(mid, 1, true, 1, 13)
    config.isDebris = true
    iconCell:init(config)
    return iconCell
end


function SevenDaysOrangeHeroGet:onUpdateDraw()
    for i = 1, table.getn(self.idList) do
        local cell = self:getPropIconCell(self.idList[i])
        self:addToIconPanel(cell)
    end
end

function  SevenDaysOrangeHeroGet:updateSelectIndex(index)
    self.selectIndex = index
    
    local choice = self.res.choice
    for i = 1 , table.getn(choice) do
        if i == index then
            choice[i]:setVisible(true)
        else
            choice[i]:setVisible(false)
        end  
    end
end
function  SevenDaysOrangeHeroGet:updateButton()
    local root = self.roots[1]
    local rewards_str_table = dms.searchs(dms["daily_welfare"],daily_welfare.reward_need_gold,0)

    for i, v in pairs(rewards_str_table) do
        if i == 7 then
            local id = dms.atoi(v,daily_welfare.id)
            local rewards_str = dms.string(dms["daily_welfare"],id,daily_welfare.reward_value)
            local rewards_table = zstring.split(rewards_str,"|")
            self.reward_id = id
        end
    end

    local Button_13 = ccui.Helper:seekWidgetByName(root, "Button_10")
    if _ED._sevenDaysActivity_currentActivityDayCount < 7 then
        Button_13:setTouchEnabled(false)
        Button_13:setBright(false)
        -- return
    end

    local state = 0
    for i,v in ipairs(_ED.active_activity[42].seven_days_rewards[7].welfare) do
        if self.reward_id == tonumber(v.id) then
            state = tonumber(v.state)
        end
    end
    if state == 1 then
        Button_13:setTouchEnabled(false)
        Button_13:setBright(false)
    end
end

function SevenDaysOrangeHeroGet:onEnterTransitionFinish()
end
function SevenDaysOrangeHeroGet:onInit()

    self.vacancyIndex = 1
    
    local csbItem = csb.createNode("utils/select_award.csb")
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("utils/select_award.csb")
    -- table.insert(self.actions, action )
    csbItem:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "close" then
            fwin:close(self)
        end
    end)
    action:play("window_open", false)

    self:addChild(csbItem)
    
    self.res = {
        panel = {
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_12"),
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_13"),
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_14"),
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_15"),
        },
        icon = { -- 图标
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_20"),
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_21"),
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_22"),
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_23"),
        },
        choice = { -- 选中
            ccui.Helper:seekWidgetByName(self.roots[1], "Image_38"),
            ccui.Helper:seekWidgetByName(self.roots[1], "Image_39"),
            ccui.Helper:seekWidgetByName(self.roots[1], "Image_40"),
            ccui.Helper:seekWidgetByName(self.roots[1], "Image_41"),
        },  
        touch = { -- 响应区
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_xy_01"),
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_xy_02"),
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_xy_03"),
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_xy_04"),
        },  
    }

    for i=1,4 do
        if i > table.nums(self.idList) then
            if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
                self.res.panel[i]:setVisible(false)
            end
        else
            if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
                self.res.panel[i]:setVisible(true)
            end
            local touch = self.res.touch[i]
            touch._index = i
            fwin:addTouchEventListener(touch, nil, 
            {
                terminal_name = "seven_days_box_getreward_hero_change_select", 
                index = touch._index,
                terminal_state = 0,
                isPressedActionEnabled = true
            },
            nil, 2)
        end
    end

    self:onUpdateDraw()
    if self.activityType == 7 then
        self:updateButton()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_10"), nil, 
    {
        terminal_name = "seven_days_box_getreward_hero", 
        cell = self,
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil, 2) 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_11"), nil, 
    {
        terminal_name = "seven_days_box_getreward_hero_close", 
        cell = self,
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil, 2) 
end

function SevenDaysOrangeHeroGet:onExit()
    state_machine.remove("seven_days_box_getreward_hero_close")
    state_machine.remove("seven_days_box_getreward_hero")
    state_machine.remove("seven_days_box_getreward_hero_change_select")
end

function SevenDaysOrangeHeroGet:init(params)
    self.idList = params[1]
    self.activityType = params[2]
    self.chooseActivityIndex = params[3]
    self.lastParent = params[4]
    self:onInit()
end
