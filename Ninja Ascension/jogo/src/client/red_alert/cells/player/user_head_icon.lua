--------------------------------------------------------------------------------------------------------------
--  玩家头像
--------------------------------------------------------------------------------------------------------------
UserHeadIcon = class("UserHeadIconClass", Window)
UserHeadIcon.__size = nil

--创建cell
local user_head_icon_create_terminal = {
    _name = "user_head_icon_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local user_data = params[1]
        local from_type = params[2]
        local cell = UserHeadIcon:new()
        cell:init(user_data,from_type)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(user_head_icon_create_terminal)
state_machine.init()

function UserHeadIcon:ctor()
    -- 初始化调用参数
    self.super:ctor()
    self.roots = {}

    self.user_data = nil
    self.from_type = nil --1 战将夺宝 2 运送军资头像 3 三国无双排行 4 排行榜
end

function UserHeadIcon:onUpdateDraw()
        -- _ED.raiders_info[i] = {
        --     user_id = i,
        --     user_name = "yanghan",
        --     user_fight = "10000",
        --     user_level = i+20,
        --     user_camp = i,
        --     user_sex = math.random(0,1),
        --     star_numbers = i,
        --     quatily = i,
        -- }

    local root = self.roots[1]

    local Panel_leading_head = ccui.Helper:seekWidgetByName(root,"Panel_leading_head")
    local Text_lv = ccui.Helper:seekWidgetByName(root,"Text_lv")
    local Panel_camp = ccui.Helper:seekWidgetByName(root,"Panel_camp")
    local Image_camp_head_bg = ccui.Helper:seekWidgetByName(root,"Image_camp_head_bg_")
    local Text_camp_faction = ccui.Helper:seekWidgetByName(root,"Text_camp_faction")
    if tonumber(self.user_data.user_sex) == 1 then -- 男
        Panel_leading_head:setBackGroundImage("images/ui/home/home_head_bg_man.png")
    else--if tonumber(self.user_data.user_sex) == 2 then -- 女
        Panel_leading_head:setBackGroundImage("images/ui/home/home_head_bg_women.png")
    end
    Text_lv:setString(self.user_data.user_level)
    Text_camp_faction:setString(red_alert_hero_camp[tonumber(self.user_data.user_camp)])

    Panel_camp:setVisible(false)
    if self.from_type == 1 then
        Panel_camp:setVisible(true)
    elseif self.from_type == 2 then
        Panel_camp:setVisible(false)
    elseif self.from_type == 3 then
        Panel_camp:setVisible(false)
    elseif self.from_type == 4 then
        Panel_camp:setVisible(true)
        Image_camp_head_bg:setVisible(false)
        -- Text_camp_faction:setString(self.user_data.user_name)
    end

    Panel_leading_head:setTouchEnabled(false)

end

function UserHeadIcon:onInit()
    -- 绘图初始化
    local csbItem = csb.createNode(config_csb.cells.player_head_info)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)

    if UserHeadIcon.__size == nil then
        UserHeadIcon.__size = root:getContentSize()
    end

    self:setContentSize(UserHeadIcon.__size)
    self:onUpdateDraw()
end

function UserHeadIcon:init(user_data,from_type)
    self.user_data = user_data
    self.from_type = from_type
    self:onInit()
    return self
end

function UserHeadIcon:onExit()

end