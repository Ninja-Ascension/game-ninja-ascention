--------------------------------------------------------------------------------------------------------------
--  战报详情
--------------------------------------------------------------------------------------------------------------
TourneyfieldGrandCell = class("TourneyfieldGrandCellClass", Window)
TourneyfieldGrandCell.__size = nil

--创建cell
local tourneyfield_grand_create_cell_terminal = {
    _name = "tourneyfield_grand_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = TourneyfieldGrandCell:new()
        local user_data = params[1]
        local index = params[2]
        cell:init(user_data,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(tourneyfield_grand_create_cell_terminal)
state_machine.init()

function TourneyfieldGrandCell:ctor()
    -- 初始化调用参数
    self.super:ctor()
    self.roots = {}

    --var 
    self._user_data = nil
    self._pk_action = false
        -- Initialize tourneyfield_grand_cell state machine.
    local function init_tourneyfield_grand_cell_terminal()
        state_machine.init()
    end

    -- call func init hom state machine.
    init_tourneyfield_grand_cell_terminal()
end

function TourneyfieldGrandCell:onUpdateDraw()
    local root = self.roots[1]
    -- 品阶
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

    -- 称谓
    local Text_office_up_to = ccui.Helper:seekWidgetByName(root, "Text_office_up_to")
    local Text_office_up = ccui.Helper:seekWidgetByName(root, "Text_office_up")
    local arena_name = dms.string(dms["arena_reward_param"],self._user_data.userOfficialRankId,arena_reward_param.arena_name)
    arena_name = zstring.split(arena_name,",")
    arena_name = arena_name[tonumber(_ED.user_info.user_force)]
    Text_office_up_to:setString(arena_name)

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
    if tonumber(self._user_data.result) == 1 then
        Image_victory:setVisible(true)
        Text_office_up_to:setString(string.format(red_alert_all_str[211],self._user_data.param))
        Text_office_up:setString(red_alert_all_str[209])
    else
        Image_defeat:setVisible(true)
        Text_office_up_to:setString(string.format(red_alert_all_str[203],self._user_data.param))
        Text_office_up:setString(red_alert_all_str[210])
    end
    --按钮(暂时没用)
    local Button_playback = ccui.Helper:seekWidgetByName(root, "Button_playback")
    Button_playback:setVisible(false)
end



function TourneyfieldGrandCell:onInit()
    -- 绘图初始化
    local csbItem = csb.createNode(config_csb.cells.campaign.tourneyfield.tourneyfield_grand_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)

    if TourneyfieldGrandCell.__size == nil then
        TourneyfieldGrandCell.__size = root:getContentSize()
    end

    self:setContentSize(TourneyfieldGrandCell.__size)
    self:onUpdateDraw(params)
end

function TourneyfieldGrandCell:init(user_data,index)
    self._user_data = user_data
    -- debug.print_r(user_data)
    if index ~= nil and index < 6 then
       self:onInit()
    end
    return self
end

function TourneyfieldGrandCell:onExit()

end