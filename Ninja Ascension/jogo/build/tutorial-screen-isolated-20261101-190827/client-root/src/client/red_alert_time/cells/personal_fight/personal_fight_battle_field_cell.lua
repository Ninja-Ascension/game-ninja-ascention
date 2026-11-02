-------------------------------------------------------------------------------------
--  居所战报cell
-------------------------------------------------------------------------------------

PersonalFightBattleFieldCell = class("PersonalFightBattleFieldCellClass", Window)
PersonalFightBattleFieldCell.__size = nil

local personal_fight_battle_field_cell_create_cell_terminal = {
    _name = "personal_fight_battle_field_cell_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = PersonalFightBattleFieldCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(personal_fight_battle_field_cell_create_cell_terminal)
state_machine.init()

function PersonalFightBattleFieldCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._chooseState = 0
    self._user_data = nil

    -- load lua file
    app.load("client.red_alert_time.cells.hero.hero_icon_cell")
    app.load("client.red_alert_time.personal_fight.PersonalFightBuildInfor")

    local function init_personal_fight_battle_field_cell_terminal()
        local personal_fight_battle_field_click_terminal = {
            _name = "personal_fight_battle_field_click",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local userId = cell._user_data.userId
                local param = zstring.split(cell._user_data.param, "|")
                local user_server_number = param[#param - 1]
                local current_server_number = param[#param]
                state_machine.excute("personal_fight_build_infor_open",0,{userId = userId, user_server_number = user_server_number, current_server_number = current_server_number})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(personal_fight_battle_field_click_terminal)
        state_machine.init()
    end
    init_personal_fight_battle_field_cell_terminal()
end

function PersonalFightBattleFieldCell:onUpdateDraw()
    local root = self.roots[1]
    -- 品阶
    if tonumber(self._user_data.userOfficialRankId) == 0 then
        self._user_data.userOfficialRankId = 34
    end
    local Text_office = ccui.Helper:seekWidgetByName(root,"Text_office")
    local arena_official = dms.int(dms["arena_reward_param"],self._user_data.userOfficialRankId,arena_reward_param.arena_official)
    local color_table = red_alert_officer_color[arena_official]
    Text_office:setString(red_alert_officer[arena_official])
    Text_office:setColor(cc.c3b(color_table[1],color_table[2],color_table[3]))

    -- 名字
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    Text_name:setString(self._user_data.userName)

    -- 战斗力
    local Text_combat_number = ccui.Helper:seekWidgetByName(root, "Text_combat_number")
    Text_combat_number:setString(self._user_data.userFighting)

    -- 时间   
    local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
    local server_time = _ED.system_time + (os.time() - _ED.native_time)
    local now_time = tonumber(server_time - self._user_data.time/1000)
    local timeString = math.floor(now_time/3600)
    if timeString >= 1 then 
        Text_time:setString(string.format(daily_string[10],timeString))
    else
        timeString = math.ceil((now_time%3600)/60)
        Text_time:setString(string.format(daily_string[11],timeString))
    end

    -- 头像
    local Panel_header = ccui.Helper:seekWidgetByName(root, "Panel_header")
    Panel_header:removeBackGroundImage()
    Panel_header:removeAllChildren(true)
    local data = {
            user_id = self._user_data.userId,
            user_name = self._user_data.userName,
            user_fight = self._user_data.userFighting,
            user_level = self._user_data.userLevel,
            user_camp = self._user_data.userCamp,
            user_sex = self._user_data.userGender,
        }
    local user_icon = state_machine.excute("user_head_icon_create",0,{data})
    Panel_header:addChild(user_icon)
    -- 胜利
    local Image_victory = ccui.Helper:seekWidgetByName(root, "Image_victory")
    Image_victory:setVisible(false)
    -- 失败
    local Image_defeat = ccui.Helper:seekWidgetByName(root, "Image_defeat")
    Image_defeat:setVisible(false)

    local Text_field_infor = ccui.Helper:seekWidgetByName(root, "Text_field_infor")
    local Text_gold_t = ccui.Helper:seekWidgetByName(root, "Text_gold_t")
    local Text_gold_n = ccui.Helper:seekWidgetByName(root, "Text_gold_n")
    Text_gold_n:setVisible(false)

    local str = ""          --奖励信息
    local score = 0         --个人积分
    if self._user_data.param ~= "" then
        local reward_list = zstring.split(self._user_data.param, "|")
        local reward_info = {}

        local server_number = 0
        local server_info = _ED.all_servers[""..reward_list[(#reward_list - 1)]]
        if server_info ~= nil and server_info.server_code ~= nil and tonumber(server_info.server_code) ~= nil then
            server_number = server_info.server_code
        end
        local server_flag = ""
        if server_info ~= nil and server_info.server_flag ~= nil then
            server_flag = server_info.server_flag
        end
        -- if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
        --     if server_info ~= nil and server_info.server_code ~= nil then
        --         Text_name:setString(self._user_data.userName.."("..server_info.server_code..")")
        --     else
        --         Text_name:setString(self._user_data.userName)
        --     end
        -- else
        --     Text_name:setString(string.format(red_alert_all_str[239], self._user_data.userName, server_number))
        -- end
        Text_name:setString(string.format(red_alert_all_str[239], self._user_data.userName, server_flag, server_number))

        score = reward_list[2]
        --获取奖励信息
        for i, reward in pairs(reward_list) do
            if i > 2 and reward ~= "" then
                table.insert(reward_info, reward)
            end
        end

        if #reward_info ~= 0 then
            for i, reward in pairs(reward_info) do
                local rewards = zstring.split(reward, ",")
                if tonumber(rewards[1]) == -1 then
                    local name = reward_prop_list[tonumber(rewards[2])]    --奖励名
                    local num = zstring.tonumber(rewards[3])               --奖励数量
                    if num == nil then
                        num = 0
                    end

                    if i ~= 1 then 
                        str = str.." "
                    end
                    str = str..string.format("%s: %d", name, num)
                end
            end
        end
    end

    -- 显示积分
    local Text_inergration_n = ccui.Helper:seekWidgetByName(root, "Text_inergration_n")
    Text_inergration_n:setString(score)

    --显示奖励
    if self._chooseState == 1 then
        if tonumber(self._user_data.result) == 1 then       --掠夺胜利
            Image_victory:setVisible(true)

            if str == "" then    --没有掠夺到资源
                Text_field_infor:setString(red_alert_all_str[234])
                Text_gold_t:setVisible(false)
            else
                Text_field_infor:setString(red_alert_all_str[233])
                --显示获得的资源数
                Text_gold_t:setVisible(true)
                Text_gold_t:setString(str)
            end
        else
            Image_defeat:setVisible(true)
            Text_field_infor:setString(red_alert_all_str[234])

            Text_gold_t:setVisible(false)
        end
    else
        if tonumber(self._user_data.result) == 1 then       --防守胜利
            Image_victory:setVisible(true)
            Text_field_infor:setString(red_alert_all_str[236])

            Text_gold_t:setVisible(false)
        else
            Image_defeat:setVisible(true)

            if str == "" then       --没有损失资源
                Text_field_infor:setString(red_alert_all_str[236])
                Text_gold_t:setVisible(false)
            else
                Text_field_infor:setString(red_alert_all_str[235])

                --显示失去的资源数
                Text_gold_t:setVisible(true)
                Text_gold_t:setString(str)
            end
        end
    end
    
    local color = tipStringInfo_player_build_color_Type[self._chooseState]
    Text_field_infor:setColor(color)
    Text_gold_t:setColor(color)
end

function PersonalFightBattleFieldCell:onEnterTransitionFinish()

end

--初始化列表
function PersonalFightBattleFieldCell:onInit( )
    local root = cacher.createUIRef(config_csb.cells.palyer_build.player_build_battle_field_cell, "root")
    root:removeFromParent(false)
    self:addChild(root)
    
    table.insert(self.roots, root)
    if PersonalFightBattleFieldCell.__size == nil then
        PersonalFightBattleFieldCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_revenge"), nil, 
    {
        terminal_name = "personal_fight_battle_field_click", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cell = self,
    }, nil, 0)

    if self._chooseState == 2 then
        ccui.Helper:seekWidgetByName(root, "Button_revenge"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root, "Button_revenge"):setVisible(false)
    end
    self:onUpdateDraw() 
end

function PersonalFightBattleFieldCell:init(params)
    self._index = params[1]
    self._chooseState = params[2]
    self._user_data = params[3]
    if self._index ~= nil and self._index < 6 then
        self:onInit()
    end
    self:setContentSize(PersonalFightBattleFieldCell.__size)
    return self
end

function PersonalFightBattleFieldCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function PersonalFightBattleFieldCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local root = self.roots[1]
    local Panel_header = ccui.Helper:seekWidgetByName(root, "Panel_header")
    Panel_header:removeBackGroundImage()
    Panel_header:removeAllChildren(true)
    cacher.freeRef(config_csb.cells.palyer_build.player_build_battle_field_cell, root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function PersonalFightBattleFieldCell:onExit()
    local root = self.roots[1]
    local Panel_header = ccui.Helper:seekWidgetByName(root, "Panel_header")
    if Panel_header ~= nil then
        Panel_header:removeBackGroundImage()
        Panel_header:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.cells.palyer_build.player_build_battle_field_cell, root)
end
