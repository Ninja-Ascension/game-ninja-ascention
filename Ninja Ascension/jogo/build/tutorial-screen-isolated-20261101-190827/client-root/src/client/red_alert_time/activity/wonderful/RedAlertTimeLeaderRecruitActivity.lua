-----------------------------
-- 英雄招募活动
-----------------------------
RedAlertTimeLeaderRecruitActivity = class("RedAlertTimeLeaderRecruitActivityClass", Window)

local red_alert_time_leader_recruit_activity_window_open_terminal = {
    _name = "red_alert_time_leader_recruit_activity_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeLeaderRecruitActivityClass") then
            local panel = RedAlertTimeLeaderRecruitActivity:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_leader_recruit_activity_window_open_terminal)
state_machine.init()

function RedAlertTimeLeaderRecruitActivity:ctor()
    self.super:ctor()
    self.roots = {}
    self.activity_type = nil
    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0
    self._Image_act_share_arrow_down = nil
    self._Image_act_share_arrow_up = nil

    self.m_times = 0
    self._label_close_time = nil
    self._is_end = false
    -- load lua file
    app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_leader_recruit_activity_cell")
    -- Initialize red_alert_time_leader_recruit_activity state machine.
    local function init_red_alert_time_leader_recruit_activity_terminal()

        local red_alert_time_leader_recruit_activity_update_draw_terminal = {
            _name = "red_alert_time_leader_recruit_activity_update_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)  
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    local posY = instance._list_view_poy
                    instance:onUpdateDraw()
                    if math.abs(posY) > math.abs(instance._list_view_height) then
                        posY = instance._list_view_height
                    end
                    instance._list_view:getInnerContainer():setPositionY(posY)  
                    instance._list_view_poy = posY + 1
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_leader_recruit_activity_go_to_terminal = {
            _name = "red_alert_time_leader_recruit_activity_go_to",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)  
                if instance.activity_type == 121 then
                    state_machine.excute("leader_school_window_open", 0, "")
                elseif instance.activity_type == 124 then
                    state_machine.excute("armor_window_open", 0, "")
                else
                    state_machine.excute("red_alert_time_lucky_draw_window_open", 0, "")
                    state_machine.excute("red_alert_time_lucky_draw_change_page",0,{_datas = {_page = 2 , _fun_open = 231}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_leader_recruit_activity_update_draw_terminal)
        state_machine.add(red_alert_time_leader_recruit_activity_go_to_terminal)
        state_machine.init()
    end
    
    -- call func init up_level state machine.
    init_red_alert_time_leader_recruit_activity_terminal()
end

function RedAlertTimeLeaderRecruitActivity:onUpdateRankInfo()
    local root = self.roots[1]
    local Text_rank_t = ccui.Helper:seekWidgetByName(root, "Text_rank_t") 
    local Text_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rank_n") 
    local Text_fight_t = ccui.Helper:seekWidgetByName(root, "Text_fight_t") 
    local Text_fight_n = ccui.Helper:seekWidgetByName(root, "Text_fight_n") 

    local activity_info = _ED.activity_info[""..self.activity_type]
    local activity_add_state = zstring.split(activity_info.activity_add_state, ",")

    Text_rank_t:setVisible(false)
    Text_fight_t:setVisible(false)
    Text_fight_n:setVisible(false)

    local infor = ""
    if self.activity_type == 121 then       -- 英雄招募
        -- activity_add_state = "活动起始时间,活动关闭时间,累计次数"
        infor = string.format(activity_str_tip[187], activity_add_state[3])
    elseif self.activity_type == 122 then       -- 幸运抽奖
        -- activity_add_state = "活动起始时间,活动关闭时间,普通次数,高级次数"
        infor = string.format(activity_str_tip[189], activity_add_state[4])
    elseif self.activity_type == 124 then
        infor = string.format(activity_str_tip[194], activity_add_state[3])
    end

    Text_rank_n:removeAllChildren(true)
    Text_rank_n:setString("")
    local font_size = Text_rank_n:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    local rt2, count2, text2 = draw.richTextCollectionMethod(_richText, 
        infor, 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        config_res.font.font_name, 
        font_size,
        chat_rich_text_color)

    _richText:setContentSize(cc.size(root:getContentSize().width, Text_rank_n:getContentSize().height))  
    _richText:setPosition(cc.p(_richText:getContentSize().width / 2, _richText:getContentSize().height / 2))  
    Text_rank_n:addChild(_richText)
end

-- 刷新列表
function RedAlertTimeLeaderRecruitActivity:onUpdateListView()
    local root = self.roots[1]

    local activity_info = _ED.activity_info[""..self.activity_type]
    local result = {}
    result = activity_info.activity_data[1]

    local ListView_act_share = ccui.Helper:seekWidgetByName(root, "ListView_act_share") 
    ListView_act_share:jumpToTop()

    local items = ListView_act_share:getItems()
    for k,v in pairs(items) do
        state_machine.excute("red_alert_time_leader_recruit_activity_cell_update_info", 0, {cell = v, info = result[k], index = k, group = 1})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            ListView_act_share:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("red_alert_time_leader_recruit_activity_cell_create", 0, {i, result[i], self.activity_type, 1})
            ListView_act_share:addChild(cell)
        end
    end

    self._list_view = ListView_act_share
    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function RedAlertTimeLeaderRecruitActivity:onUpdateDraw()
    local root = self.roots[1]

    local activity_info = _ED.activity_info[""..self.activity_type]

    local Text_act_share_name = ccui.Helper:seekWidgetByName(root, "Text_act_share_name") 
    Text_act_share_name:setString(activity_info.activity_title)

    local Text_act_share_infor = ccui.Helper:seekWidgetByName(root, "Text_act_share_infor") 
    Text_act_share_infor:setString(activity_info.activity_dec)

    --活动开启结束时间
    local activity_add_state = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")

    self.m_times = tonumber(activity_add_state[2]) / 1000 - (os.time() + _ED.time_add_or_sub)
    time_str = activity_str_tip[93]

    -- 结束和关闭倒计时
    local Text_act_share_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_act_share_act_time_1")
    Text_act_share_act_time_1:removeAllChildren(true)
    Text_act_share_act_time_1:setString("")
    local font_size = Text_act_share_act_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(time_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_act_share_act_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_act_share_act_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_act_share_act_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_act_share_act_time_1:addChild(time_int)
    self._label_close_time = time_int

    self:onUpdateListView()
    self:onUpdateRankInfo()
end

function RedAlertTimeLeaderRecruitActivity:onUpdateButton()
    local root = self.roots[1]
    local Button_look_rank = ccui.Helper:seekWidgetByName(root,"Button_look_rank")
    local Button_rule = ccui.Helper:seekWidgetByName(root,"Button_rule")

    Button_look_rank:setVisible(false)
    Button_rule:setPositionX(root:getContentSize().width / 2)

    if self.activity_type == 121 then
        Button_rule:setTitleText(activity_str_tip[188])
    elseif self.activity_type == 124 then
        Button_rule:setTitleText(activity_str_tip[195])
    else
        Button_rule:setTitleText(activity_str_tip[4])
    end
end

function RedAlertTimeLeaderRecruitActivity:onUpdate(dt)
    if self.m_times > 0 and self._label_close_time ~= nil then
        self.m_times = self.m_times - dt
        self._label_close_time:setString(getRedAlertTimeActivityFormat(self.m_times))
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_wonderful_update_first",0,self.activity_type)
        end
    end

    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_act_share_arrow_down:setVisible(true)
        else
            self._Image_act_share_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_act_share_arrow_up:setVisible(true)
        else
            self._Image_act_share_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function RedAlertTimeLeaderRecruitActivity:onEnterTransitionFinish()

end

function RedAlertTimeLeaderRecruitActivity:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_share_tab_3)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --招募
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rule"), nil, 
    {
        terminal_name = "red_alert_time_leader_recruit_activity_go_to", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self._Image_act_share_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_act_share_arrow_down")
    self._Image_act_share_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_act_share_arrow_up")
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_act_share_arrow_down:stopAllActions()
    self._Image_act_share_arrow_up:stopAllActions()
    playActions(self._Image_act_share_arrow_down)
    playActions(self._Image_act_share_arrow_up)
    self._Image_act_share_arrow_down:setVisible(false)
    self._Image_act_share_arrow_up:setVisible(false)

    self:onUpdateDraw()
    self:onUpdateButton()
end

function RedAlertTimeLeaderRecruitActivity:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self.activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeLeaderRecruitActivity:onExit()
    state_machine.remove("red_alert_time_leader_recruit_activity_update_draw")
    state_machine.remove("red_alert_time_leader_recruit_activity_go_to")
end
