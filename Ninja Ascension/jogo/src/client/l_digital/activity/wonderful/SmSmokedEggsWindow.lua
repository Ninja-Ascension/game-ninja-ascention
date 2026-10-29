-- ----------------------------------------------------------------------------------------------------
-- 说明：砸金蛋界面
-------------------------------------------------------------------------------------------------------
SmSmokedEggsWindow = class("SmSmokedEggsWindowClass", Window)

local sm_smoked_eggs_window_window_open_terminal = {
    _name = "sm_smoked_eggs_window_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmSmokedEggsWindowClass")
        if nil == _homeWindow then
            local panel = SmSmokedEggsWindow:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_smoked_eggs_window_window_close_terminal = {
    _name = "sm_smoked_eggs_window_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmSmokedEggsWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmSmokedEggsWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_smoked_eggs_window_window_open_terminal)
state_machine.add(sm_smoked_eggs_window_window_close_terminal)
state_machine.init()
    
function SmSmokedEggsWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
    self._activity_type = 0

    self._have_times = 0
    self._can_get_times = 0
    self._egg_state = {0, 0, 0}

    self._info_table = {}           -- 跑马灯信息队列
    self._is_playing = false

    self._text_time = nil

    self._need_cost = 0         -- 消耗

    app.load("client.l_digital.activity.wonderful.SmSmokedEggsHelp")
    app.load("client.packs.hero.HeroPatchInformationPageGetWay")
    app.load("client.reward.DrawRareReward")

    local function init_sm_smoked_eggs_window_window_terminal()
        -- 显示界面
        local sm_smoked_eggs_window_window_display_terminal = {
            _name = "sm_smoked_eggs_window_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmSmokedEggsWindowWindow = fwin:find("SmSmokedEggsWindowClass")
                if SmSmokedEggsWindowWindow ~= nil then
                    SmSmokedEggsWindowWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_smoked_eggs_window_window_hide_terminal = {
            _name = "sm_smoked_eggs_window_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmSmokedEggsWindowWindow = fwin:find("SmSmokedEggsWindowClass")
                if SmSmokedEggsWindowWindow ~= nil then
                    SmSmokedEggsWindowWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_smoked_eggs_window_get_reward_terminal = {
            _name = "sm_smoked_eggs_window_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                if tonumber(instance._egg_state[index]) > 0 then
                    return
                end

                if instance._have_times == 0 then
                    if instance._can_get_times == 0 then
                        TipDlg.drawTextDailog(_new_interface_text[197])
                    else
                        TipDlg.drawTextDailog(_new_interface_text[166])
                    end
                    return
                end

                if instance._activity_type == 87 then   -- 金币砸金蛋
                    if instance._need_cost > tonumber(_ED.user_info.user_silver) then
                        local fightWindow = HeroPatchInformationPageGetWay:new()
                        fightWindow:init(0,6)
                        fwin:open(fightWindow, fwin._windows)
                        return
                    end
                end

                state_machine.lock("sm_smoked_eggs_window_get_reward", 0, "")
                local activity = _ED.active_activity[instance._activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:smokedEgg(index)
                        end
                    end
                end
                protocol_command.get_activity_reward.param_list = ""..activity.activity_id.."\r\n"..(index - 1).."\r\n".."0".."\r\n"..instance._activity_type
                NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_smoked_eggs_window_update_play_info_terminal = {
            _name = "sm_smoked_eggs_window_update_play_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params[1] ~= nil then
                    table.insert(instance._info_table, params[1])
                end
                instance:onUpdatePlayInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_smoked_eggs_window_update_draw_terminal = {
            _name = "sm_smoked_eggs_window_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_smoked_eggs_window_window_display_terminal)
        state_machine.add(sm_smoked_eggs_window_window_hide_terminal)
        state_machine.add(sm_smoked_eggs_window_get_reward_terminal)
        state_machine.add(sm_smoked_eggs_window_update_play_info_terminal)
        state_machine.add(sm_smoked_eggs_window_update_draw_terminal)
        state_machine.init()
    end
    init_sm_smoked_eggs_window_window_terminal()
end

function SmSmokedEggsWindow:smokedEgg(index)
    local root = self.roots[1]

    local Panel_egg_dh = ccui.Helper:seekWidgetByName(root,"Panel_egg_dh_"..index)
    local armature = Panel_egg_dh._armature
    if armature ~= nil then
        armature._is_smoked = true
        csb.animationChangeToAction(armature, 1, 0, false)
    end
end

function SmSmokedEggsWindow:rewadDraw()
    local root = self.roots[1]
    
    local getRewardWnd = DrawRareReward:new()
    getRewardWnd:init(7)
    fwin:open(getRewardWnd,fwin._ui)
    
    self:onUpdateDraw()
    self:onUpdatePlayInfo()
end

-- 跑马灯信息
function SmSmokedEggsWindow:onUpdatePlayInfo()
    local root = self.roots[1]

    if self._is_playing == true or #self._info_table == 0 then
        return
    end
    local Panel_gg = ccui.Helper:seekWidgetByName(root, "Panel_gg")
    local Text_gg = ccui.Helper:seekWidgetByName(root, "Text_gg")

    self._is_playing = true
    
    Text_gg:setString("")
    Text_gg:removeAllChildren(true)
    Panel_gg:setVisible(true)

    local info = table.remove(self._info_table, 1)

    local char_str = _new_interface_text[167]
    char_str = string.gsub(char_str, "!x@", info.name)

    if tonumber(info.sliver_count) > 0 then
        char_str = string.gsub(char_str, "!y@", info.sliver_count)
        char_str = string.gsub(char_str, "!z@", reward_prop_list[1])
    else
        char_str = string.gsub(char_str, "!y@", info.gold_count)
        char_str = string.gsub(char_str, "!z@", reward_prop_list[2])
    end
    char_str = string.gsub(char_str, "!a@", string.format(_new_interface_text[168], info.factor))

    font_name = Text_gg:getFontName()
    font_size = Text_gg:getFontSize()

    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    _richText:setContentSize(cc.size(5000, 0))
    _richText:setAnchorPoint(cc.p(0, 0))
    local rt, count, text = draw.richTextCollectionMethod(_richText, 
        char_str, 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        font_name, 
        font_size,
        chat_rich_text_color)

    _richText:formatTextExt()
    local rsize = _richText:getContentSize()
    _richText:setPosition(cc.p(0, rsize.height))
    Text_gg:addChild(_richText)
 
    local function callback(sender)
        sender:removeFromParent(true)
        if sender._self ~= nil and sender._self.roots ~= nil and sender._self.roots[1] ~= nil then
            sender._self._is_playing = false
            state_machine.excute("sm_smoked_eggs_window_update_play_info", 0, {})
        end
    end
    
    _richText._self = self
    _richText:setPositionX(Text_gg:getContentSize().width)
    local need_time = (rsize.width + Text_gg:getContentSize().width) * 0.01
    _richText:runAction(cc.Sequence:create(
        cc.MoveTo:create(need_time, cc.p(-rsize.width, _richText:getPositionY())),
        cc.CallFunc:create(callback)
    ))
end

function SmSmokedEggsWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local activity_info = _ED.active_activity[self._activity_type]

    local Text_time_1 = ccui.Helper:seekWidgetByName(root,"Text_time_1")
    local Text_time_2 = ccui.Helper:seekWidgetByName(root,"Text_time_2")

    local time_str = ""..getRedAlertTimeActivityFormat(tonumber(activity_info.begin_time) / 1000, 1)
    time_str = time_str.."-"..getRedAlertTimeActivityFormat(tonumber(activity_info.end_time) / 1000, 1)
    Text_time_1:setString(time_str)

    local leave_time = tonumber(activity_info.end_time) / 1000 - (os.time() + _ED.time_add_or_sub)
    Text_time_2:setString(getRedAlertTimeActivityFormat(leave_time))
    self._text_time = Text_time_2

    local egg_type = 1      -- 钻石砸蛋
    if self._activity_type == 87 then
        egg_type = 2        -- 金币砸蛋
    end

    local Panel_type_1 = ccui.Helper:seekWidgetByName(root,"Panel_type_1")
    local Panel_type_2 = ccui.Helper:seekWidgetByName(root,"Panel_type_2")
    if egg_type == 1 then
        Panel_type_1:setVisible(true)
        Panel_type_2:setVisible(false)
    else
        Panel_type_1:setVisible(false)
        Panel_type_2:setVisible(true)
    end

    local Text_res_n = ccui.Helper:seekWidgetByName(root,"Text_res_n")      -- 消耗
    local Text_sy_n = ccui.Helper:seekWidgetByName(root,"Text_sy_n")      -- 收益
    local Text_hammer_n_2 = ccui.Helper:seekWidgetByName(root,"Text_hammer_n_2")      -- 剩余次数
    local Text_hammer_n_3 = ccui.Helper:seekWidgetByName(root,"Text_hammer_n_3")      -- 还可获得次数

    local cost_info = zstring.split(activity_info.need_recharge_count, ",")
    Text_res_n:setString(cost_info[3])

    self._need_cost = tonumber(cost_info[3])

    local other_info = zstring.split(activity_info.activity_params, "|")
    local get_info = zstring.split(other_info[1], ",")
    Text_sy_n:setString(get_info[1])
    Text_hammer_n_2:setString(get_info[2])
    Text_hammer_n_3:setString(get_info[3])

    self._have_times = tonumber(get_info[2])
    self._can_get_times = tonumber(get_info[3])

    local egg_state = zstring.split(other_info[3], ",")         -- 0:未砸开，1：已砸开
    self._egg_state = egg_state

    -- 金蛋状态
    for i = 1, 3 do
        local Image_egg = ccui.Helper:seekWidgetByName(root,"Image_egg_"..i)
        local Panel_egg_dh = ccui.Helper:seekWidgetByName(root,"Panel_egg_dh_"..i)

        Image_egg:setOpacity(0)
        Panel_egg_dh:setVisible(false)

        if tonumber(egg_state[i]) == 0 then
            Panel_egg_dh:setVisible(true)

            if Panel_egg_dh._armature == nil then
                local function callback(armature)
                    if armature._is_smoked == true then
                        armature._is_smoked = false
                        state_machine.unlock("sm_smoked_eggs_window_get_reward", 0, "")
                        if armature._self ~= nil and armature._self.roots ~= nil and armature._self.roots[1] ~= nil then
                            armature._self:rewadDraw()
                        end
                    end
                end

                local base_name = "sprite/sprite_zadan"
                local animation_name = "egg_daiji_"..i.."_"..egg_type
                local armature = sp.spine(base_name..".json", base_name..".atlas", 1, 0, nil, false, nil)
                sp.initArmature(armature, true)
                armature.animationNameList = {
                    "egg_daiji_"..i.."_"..egg_type,
                    "egg_zakai_"..i.."_"..egg_type,
                }
                armature._invoke = callback
                -- armature:getAnimation():playWithIndex(0)
                armature:setMovementEventCallFunc(changeAction_animationEventCallFunc)
                armature._is_smoked = false
                armature._index = i
                armature._self = self
                Panel_egg_dh:addChild(armature)
                Panel_egg_dh._armature = armature
            end
            Panel_egg_dh._armature:getAnimation():playWithIndex(0)
        else
            Image_egg:setOpacity(255)
        end
    end
end

function SmSmokedEggsWindow:onUpdate(dt)
    if self._text_time ~= nil and _ED.active_activity[self._activity_type] ~= nil then 
        local leave_time = tonumber(_ED.active_activity[self._activity_type].end_time) / 1000 - (os.time() + _ED.time_add_or_sub)
        self._text_time:setString(getRedAlertTimeActivityFormat(leave_time))
    end
end

function SmSmokedEggsWindow:init(params)
    self._activity_type = params[1]
    self:onInit()
    return self
end

function SmSmokedEggsWindow:onInit()
    local csbSmSmokedEggsWindow = csb.createNode("activity/wonderful/sm_gold_egg.csb")
    local root = csbSmSmokedEggsWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmSmokedEggsWindow)
    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_smoked_eggs_window_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_help"), nil, 
    {
        terminal_name = "sm_smoked_eggs_help_window_open",
        terminal_state = 0,
        touch_black = true,
        activity_type = self._activity_type
    },
    nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_chongzhi"), nil, 
    {
        terminal_name = "recharge_dialog_window_open",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)

    for i = 1, 3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_egg_"..i), nil, 
        {
            terminal_name = "sm_smoked_eggs_window_get_reward",
            terminal_state = 0,
            index = i,
        },
        nil,0) 
    end
end

function SmSmokedEggsWindow:onExit()
    state_machine.remove("sm_smoked_eggs_window_window_display")
    state_machine.remove("sm_smoked_eggs_window_window_hide")
    state_machine.remove("sm_smoked_eggs_window_get_reward")
    state_machine.remove("sm_smoked_eggs_window_update_play_info")
    state_machine.remove("sm_smoked_eggs_window_update_draw")
end