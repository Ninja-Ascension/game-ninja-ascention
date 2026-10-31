--------------------------------------------------------------------------------------------------------------
--  说明：将领魂魄信息
--------------------------------------------------------------------------------------------------------------
LeaderExchangeInfo = class("LeaderExchangeInfoClass", Window)

--打开界面
local leader_exchange_info_window_open_terminal = {
	_name = "leader_exchange_info_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(LeaderExchangeInfo:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local leader_exchange_info_window_close_terminal = {
	_name = "leader_exchange_info_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LeaderExchangeInfoClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(leader_exchange_info_window_open_terminal)
state_machine.add(leader_exchange_info_window_close_terminal)
state_machine.init()

function LeaderExchangeInfo:ctor()
	self.super:ctor()
	self.roots = {}

    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0
    self._ship_id = nil
    self._info = nil

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

    app.load("client.red_alert_time.cells.leader.leader_infor_skill_window_cell")
    app.load("client.red_alert_time.leader.LeaderSynopsisWindow")

    local function init_leader_exchange_info_terminal()
        local leader_exchange_info_update_terminal = {
            _name = "leader_exchange_info_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local leader_exchange_info_attribute_terminal = {
            _name = "leader_exchange_info_attribute",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("leader_synopsis_window_window_open",0,{instance._ship_id,instance._info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(leader_exchange_info_update_terminal)    
        state_machine.add(leader_exchange_info_attribute_terminal)    
        state_machine.init()
    end
    init_leader_exchange_info_terminal()
end

function LeaderExchangeInfo:updateDraw( ... )
    local root = self.roots[1]
    
    local ship_info = dms.element(dms["ship_mould"], self._ship_id)
    -- icon
    local Panel_leader_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_icon")
    Panel_leader_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{2,3,self._ship_id,3})
    Panel_leader_icon:addChild(cell)
    -- name
    local Text_leader_name = ccui.Helper:seekWidgetByName(root, "Text_leader_name")
    local captain_name = dms.atos(ship_info, ship_mould.captain_name)
    local ship_type =  dms.atoi(ship_info, ship_mould.ship_type)
    local skill_describe = dms.atos(ship_info, ship_mould.skill_describe)                       -- 特点
    Text_leader_name:setString(captain_name)
    Text_leader_name:setColor(cc.c3b(color_Type[ship_type+1][1],color_Type[ship_type+1][2],color_Type[ship_type+1][3]))
    
    local ListView_leader_infor = ccui.Helper:seekWidgetByName(root, "ListView_leader_infor")
    ListView_leader_infor:jumpToTop()
    ListView_leader_infor:removeAllItems()

    local Text_leader_point_t_0 = ccui.Helper:seekWidgetByName(root, "Text_leader_point_t_0")   -- 是否拥有   
    local Text_leader_point_t = ccui.Helper:seekWidgetByName(root, "Text_leader_point_t")
    local Text_leader_point_n = ccui.Helper:seekWidgetByName(root, "Text_leader_point_n")
    local Text_leader_lv = ccui.Helper:seekWidgetByName(root, "Text_leader_lv")
    local Text_dodge_n = ccui.Helper:seekWidgetByName(root, "Text_dodge_n")                     -- 闪避
    local Text_hit_n = ccui.Helper:seekWidgetByName(root, "Text_hit_n")                         -- 命中
    local Text_protect_n = ccui.Helper:seekWidgetByName(root, "Text_protect_n")                 -- 坚守
    local Text_uprising_n = ccui.Helper:seekWidgetByName(root, "Text_uprising_n")               -- 抗暴
    local Text_pierce_through_n = ccui.Helper:seekWidgetByName(root, "Text_pierce_through_n")   -- 指挥
    local Text_crit_n = ccui.Helper:seekWidgetByName(root, "Text_crit_n")                       -- 暴击
    Text_leader_point_t_0:setString("")
    Text_leader_point_t:setVisible(false)
    Text_leader_point_n:setString("")
    Text_leader_lv:removeAllChildren(true)
    Text_leader_lv:setString("")
    Text_dodge_n:setString("")
    Text_hit_n:setString("")
    Text_protect_n:setString("")
    Text_uprising_n:setString("")
    Text_pierce_through_n:setString("")
    Text_crit_n:setString("")

    if self._info == nil then
        local ship_base_template_id = dms.atoi(ship_info, ship_mould.base_mould)
        for k, v in pairs(_ED.user_ship) do
            if tonumber(v.ship_base_template_id) == ship_base_template_id then
                self._info = v
                break
            end
        end
    end

    if self._info == nil or self._from_type == 1 then
        local initial_accuracy = dms.atof(ship_info, ship_mould.initial_accuracy)                   -- 初始命中
        local initial_jink = dms.atof(ship_info, ship_mould.initial_jink)                           -- 初始闪避
        local initial_critical = dms.atof(ship_info, ship_mould.initial_critical)                   -- 初始暴击
        local initial_critical_resist = dms.atof(ship_info, ship_mould.initial_critical_resist)     -- 初始抗暴
        local leader = dms.atof(ship_info, ship_mould.leader)                                       -- 初始指挥
        local force = dms.atof(ship_info, ship_mould.force)                                         -- 初始坚守
        Text_dodge_n:setString(initial_jink.."%")
        Text_hit_n:setString(initial_accuracy.."%")
        Text_protect_n:setString(force.."%")
        Text_uprising_n:setString(initial_critical_resist.."%")
        Text_pierce_through_n:setString(leader.."%")
        Text_crit_n:setString(initial_critical.."%")
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false) 
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[63], "fonts/simhei.ttf",20)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, skill_describe, "fonts/simhei.ttf",20)
        _richText:pushBackElement(re2)
        _richText:setPosition(cc.p(Text_leader_lv:getContentSize().width/2,Text_leader_lv:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_leader_lv:getContentSize().width,20))
        Text_leader_lv:addChild(_richText)

        if self._info == nil then
            Text_leader_point_t_0:setString(red_alert_time_str[62])
        else
            Text_leader_point_t_0:setString(red_alert_time_str[61])
        end

        local talent_id = zstring.split(dms.atos(ship_info, ship_mould.talent_id), "|")
        for k, v in pairs(talent_id) do
            local talent_info = zstring.split(v, ",")
            local cell = state_machine.excute("leader_infor_skill_window_cell_create_cell", 0, {k,talent_info, 1, false})
            ListView_leader_infor:addChild(cell)
        end
    elseif self._info.ship_id ~= nil then           -- 查看拥有的将领属性
        if self._from_type == 2 then
            local have_leader = false
            local ship_base_template_id = dms.atoi(ship_info, ship_mould.base_mould)
            for k, v in pairs(_ED.user_ship) do
                if tonumber(v.ship_base_template_id) == ship_base_template_id then
                    have_leader = true
                    break
                end
            end
            if have_leader == true then
                Text_leader_point_t_0:setString(red_alert_time_str[61])
            else
                Text_leader_point_t_0:setString(red_alert_time_str[62])
            end
        else
            Text_leader_point_t_0:setString(red_alert_time_str[61])
        end
        -- 等级
        local current_level = tonumber(self._info.ship_level)
        Text_leader_lv:setString(string.format(red_alert_time_str[33], current_level))

        -- 特点
        Text_leader_point_t:setVisible(true)
        Text_leader_point_n:setString(skill_describe)

        -- 属性
        Text_hit_n:setString(self._info.hit .. "%")
        Text_dodge_n:setString(self._info.dodge .. "%")
        Text_crit_n:setString(self._info.crit .. "%")
        Text_uprising_n:setString(self._info.toughness .. "%")
        Text_pierce_through_n:setString(self._info.pierce_through .. "%") 
        Text_protect_n:setString(self._info.protect .. "%")              

        local talent_id = zstring.split(dms.atos(ship_info, ship_mould.talent_id), "|")
        for k, v in pairs(talent_id) do
            local talent_info = zstring.split(v, ",")
            local talent_level = tonumber(self._info.talents[k].is_activited)
            local cell = nil
            if talent_level > 0 then
                cell = state_machine.excute("leader_infor_skill_window_cell_create_cell", 0, {k,talent_info, talent_level, false})
            else
                cell = state_machine.excute("leader_infor_skill_window_cell_create_cell", 0, {k,talent_info, 1, true})
            end
            ListView_leader_infor:addChild(cell)
        end
    elseif self._info.star_ship_type ~= nil then           -- 查看升星后将领属性
        local current_level = self._info.level
        Text_leader_point_t_0:setString(red_alert_time_str[61])
        Text_leader_lv:setString(string.format(red_alert_time_str[33], current_level))

        -- 特点
        Text_leader_point_t:setVisible(true)
        Text_leader_point_n:setString(skill_describe)

        -- 属性
        local initial_accuracy = dms.atof(ship_info, ship_mould.initial_accuracy)                   -- 初始命中
        local initial_jink = dms.atof(ship_info, ship_mould.initial_jink)                           -- 初始闪避
        local initial_critical = dms.atof(ship_info, ship_mould.initial_critical)                   -- 初始暴击
        local initial_critical_resist = dms.atof(ship_info, ship_mould.initial_critical_resist)     -- 初始抗暴
        local leader = dms.atof(ship_info, ship_mould.leader)                                       -- 初始指挥
        local force = dms.atof(ship_info, ship_mould.force)                                         -- 初始坚守

        -- 成长值
        local add_attr_info = zstring.split(dms.atos(ship_info, ship_mould.skill_grow_up_param), "|")
        local add_attr = {["49"] = 0, ["50"] = 0, ["51"] = 0, ["52"] = 0, ["71"] = 0, ["72"] = 0}
        for k, v in pairs(add_attr_info) do
            local info = zstring.split(v, ",")
            add_attr[""..info[1]] = add_attr[""..info[1]] + tonumber(info[2])
        end

        Text_dodge_n:setString((initial_jink + (current_level - 1) * add_attr["52"]).."%")
        Text_hit_n:setString((initial_accuracy + (current_level - 1) * add_attr["51"]).."%")
        Text_protect_n:setString((force + (current_level - 1) * add_attr["72"]).."%")
        Text_uprising_n:setString((initial_critical_resist + (current_level - 1) * add_attr["50"]).."%")
        Text_pierce_through_n:setString((leader + (current_level - 1) * add_attr["71"]).."%")
        Text_crit_n:setString((initial_critical + (current_level - 1) * add_attr["49"]).."%")

        local talent_id = zstring.split(dms.atos(ship_info, ship_mould.talent_id), "|")
        for k, v in pairs(talent_id) do
            local talent_info = zstring.split(v, ",")
            local talent_level = tonumber(self._info.talents[k].is_activited)
            local cell = nil

            if talent_level > 0 then        -- 已解锁技能
                cell = state_machine.excute("leader_infor_skill_window_cell_create_cell", 0, {k,talent_info, talent_level, false})
            elseif ship_type == k then      -- 下一星解锁技能
                cell = state_machine.excute("leader_infor_skill_window_cell_create_cell", 0, {k,talent_info, 1, false})
            else                            -- 未解锁技能
                cell = state_machine.excute("leader_infor_skill_window_cell_create_cell", 0, {k,talent_info, 1, true})
            end
            ListView_leader_infor:addChild(cell)
        end
    end

    ListView_leader_infor:requestRefreshView()
    self.listview = ListView_leader_infor
    self.listview_poy = ListView_leader_infor:getInnerContainer():getPositionY()
    self.listview_height = ListView_leader_infor:getInnerContainer():getPositionY()
end

function LeaderExchangeInfo:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_arrow_down:setVisible(true)
        else
            self._Image_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_arrow_up:setVisible(true)
        else
            self._Image_arrow_up:setVisible(false)
        end
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
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

function LeaderExchangeInfo:onInit(params)
    local csbItem = csb.createNode(config_csb.leader.leader_infor_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_infor_close"), nil, 
    {
        terminal_name = "leader_exchange_info_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "leader_exchange_info_window_close", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95,
        -- touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_infor"), nil, 
    {
        terminal_name = "leader_exchange_info_attribute", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_leader_point_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_leader_point_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_arrow_down:stopAllActions()
    self._Image_arrow_up:stopAllActions()
    playActions(self._Image_arrow_down)
    playActions(self._Image_arrow_up)
    self._Image_arrow_down:setVisible(false)
    self._Image_arrow_up:setVisible(false)

    self:updateDraw()
end

function LeaderExchangeInfo:onEnterTransitionFinish()

end

function LeaderExchangeInfo:init(params)
    self._ship_id = params[1]
    self._info = params[2]
    self._from_type = params[3]           -- 0:将领，1：魂魄，2：分享
	self:onInit(params)
    return self
end

function LeaderExchangeInfo:onExit()
    state_machine.remove("leader_exchange_info_update")
    state_machine.remove("leader_exchange_info_attribute")
end