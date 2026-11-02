-- ------------------------------------------------------------------------------------------------------------
--  说明：活动道具预览
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeBoxPreview = class("RedAlertTimeBoxPreviewClass", Window)

local red_alert_time_box_preview_window_open_terminal = {
    _name = "red_alert_time_box_preview_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeBoxPreviewClass") then
            fwin:open(RedAlertTimeBoxPreview:new():init(params), fwin._ui)
        else
            state_machine.excute("red_alert_time_box_preview_reset", 0, params)
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_box_preview_window_close_terminal = {
    _name = "red_alert_time_box_preview_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeBoxPreviewClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_box_preview_window_open_terminal)
state_machine.add(red_alert_time_box_preview_window_close_terminal)
state_machine.init()

function RedAlertTimeBoxPreview:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._reward_info = {}
    self._Image_act_congratulations_arrow_down = nil
    self._Image_act_congratulations_arrow_up = nil
    self.iconGroup = {}
    self._tipString = nil

    app.load("client.red_alert_time.cells.props.props_icon_cell")
    local function init_red_alert_time_box_preview_terminal()
        local red_alert_time_box_preview_reset_terminal = {
            _name = "red_alert_time_box_preview_reset",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._reward_info = params[1]
                if params[2] ~= nil then
                    instance._tipString = params[2]   
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_box_preview_reset_terminal)

        state_machine.init()
    end
    init_red_alert_time_box_preview_terminal()
end

function RedAlertTimeBoxPreview:onUpdateDraw()
    local root = self.roots[1]
    if self._reward_info ~= nil then
        if #self._reward_info == 1 then
            self:onUpdateDrawOne()
        elseif #self._reward_info == 2 then
            self:onUpdateDrawTwo()
        elseif #self._reward_info == 3 then
            self:onUpdateDrawThree()
        elseif #self._reward_info >= 4 then
            self:onUpdateDrawFour()
        end
    end

    if self._tipString ~= nil then
        local Text_act_congratulations_get_name_0 = ccui.Helper:seekWidgetByName(root, "Text_act_congratulations_get_name_0")
        Text_act_congratulations_get_name_0:setString(self._tipString)
    end
end

function RedAlertTimeBoxPreview:onUpdateDrawOne()
    local root = self.roots[1]
    local ScrollView_reward_box = ccui.Helper:seekWidgetByName(root,"ScrollView_reward_box")
    self.listview = ScrollView_reward_box
    self.listview_height = ScrollView_reward_box:getContentSize().height
    self.listview_poy = ScrollView_reward_box:getContentSize().height
    ScrollView_reward_box:removeAllChildren(true)
    local width = ScrollView_reward_box:getContentSize().width
    local height = ScrollView_reward_box:getContentSize().height
    local csbItem = csb.createNode(string.format(config_csb.cells.props.props_res_icon, 4))
    local root_temp = csbItem:getChildByName("root")
    local cell_height = root_temp:getContentSize().height + 35
    local cell_width = root_temp:getContentSize().width

    for i,v in pairs(self._reward_info) do
        local temp_tab = zstring.split(v, ",")
        local reward_data = {
            item_value = temp_tab[3],
            prop_type = temp_tab[2],
            prop_item = temp_tab[1],
        }
        local panel = ccui.Layout:create()
        local cell = createPropIconCell(reward_data, true, true, true)
        panel:setAnchorPoint(cc.p(0.5,0.5))
        panel:setContentSize(cell:getContentSize())
        panel:setPosition(cc.p(width/2,height - cell_height/2))
        panel.cell = cell
        panel:addChild(cell)
        ScrollView_reward_box:addChild(panel)      
    end
end

function RedAlertTimeBoxPreview:onUpdateDrawTwo()
    local root = self.roots[1]
    local ScrollView_reward_box = ccui.Helper:seekWidgetByName(root,"ScrollView_reward_box")
    self.listview = ScrollView_reward_box
    self.listview_height = ScrollView_reward_box:getContentSize().height
    self.listview_poy = ScrollView_reward_box:getContentSize().height
    ScrollView_reward_box:removeAllChildren(true)
    local width = ScrollView_reward_box:getContentSize().width
    local height = ScrollView_reward_box:getContentSize().height
    local csbItem = csb.createNode(string.format(config_csb.cells.props.props_res_icon, 4))
    local root_temp = csbItem:getChildByName("root")
    local cell_height = root_temp:getContentSize().height + 35
    local cell_width = root_temp:getContentSize().width

    for i,v in pairs(self._reward_info) do
        local temp_tab = zstring.split(v, ",")
        local reward_data = {
            item_value = temp_tab[3],
            prop_type = temp_tab[2],
            prop_item = temp_tab[1],
        }
        local panel = ccui.Layout:create()
        local cell = createPropIconCell(reward_data, true, true, true)
        panel:setAnchorPoint(cc.p(0.5,0.5))
        panel:setContentSize(cell:getContentSize())
        if i == 1 then
            panel:setPosition(cc.p(width/2 - cell_width ,height - cell_height/2))
        elseif i == 2 then
            panel:setPosition(cc.p(width/2 + cell_width ,height - cell_height/2))
        end
        panel.cell = cell
        panel:addChild(cell)
        ScrollView_reward_box:addChild(panel)    
    end
end

function RedAlertTimeBoxPreview:onUpdateDrawThree()
    local root = self.roots[1]
    local ScrollView_reward_box = ccui.Helper:seekWidgetByName(root,"ScrollView_reward_box")
    self.listview = ScrollView_reward_box
    self.listview_height = ScrollView_reward_box:getContentSize().height
    self.listview_poy = ScrollView_reward_box:getContentSize().height
    ScrollView_reward_box:removeAllChildren(true)
    local width = ScrollView_reward_box:getContentSize().width
    local height = ScrollView_reward_box:getContentSize().height
    local csbItem = csb.createNode(string.format(config_csb.cells.props.props_res_icon, 4))
    local root_temp = csbItem:getChildByName("root")
    local cell_height = root_temp:getContentSize().height + 35
    local cell_width = root_temp:getContentSize().width

    for i,v in pairs(self._reward_info) do
        local temp_tab = zstring.split(v, ",")
        local reward_data = {
            item_value = temp_tab[3],
            prop_type = temp_tab[2],
            prop_item = temp_tab[1],
        }
        local panel = ccui.Layout:create()
        local cell = createPropIconCell(reward_data, true, true, true)
        panel:setAnchorPoint(cc.p(0.5,0.5))
        panel:setContentSize(cell:getContentSize())
        panel:setPosition(cc.p(i*(width/3) - cell_width+30,height - cell_height/2))
        panel.cell = cell
        panel:addChild(cell)
        ScrollView_reward_box:addChild(panel)    
    end
end

function RedAlertTimeBoxPreview:onUpdateDrawFour()
    local root = self.roots[1]
    local ScrollView_reward_box = ccui.Helper:seekWidgetByName(root,"ScrollView_reward_box")
    self.listview = ScrollView_reward_box
    self.listview_height = ScrollView_reward_box:getContentSize().height
    self.listview_poy = ScrollView_reward_box:getContentSize().height
    ScrollView_reward_box:removeAllChildren(true)
    self.iconGroup = {}
    local width = ScrollView_reward_box:getContentSize().width
    local height = ScrollView_reward_box:getContentSize().height
    local csbItem = csb.createNode(string.format(config_csb.cells.props.props_res_icon, 4))
    local root_temp = csbItem:getChildByName("root")
    local cell_height = root_temp:getContentSize().height + 35
    local cell_width = root_temp:getContentSize().width
    local tocalHeight = 0
    for i,v in pairs(self._reward_info) do
        local temp_tab = zstring.split(v, ",")
        local reward_data = {
            item_value = temp_tab[3],
            prop_type = temp_tab[2],
            prop_item = temp_tab[1],
        }
        local cell = createPropIconCell(reward_data, true, true, true)

        table.insert(self.iconGroup, cell)
        ScrollView_reward_box:addChild(cell)
    end
    tocalHeight = cell_height * (math.ceil( #self._reward_info / 3 ))
    tocalHeight = math.max(tocalHeight , height)
    ScrollView_reward_box:setInnerContainerSize(cc.size(width, tocalHeight))
    for i, v in pairs(self.iconGroup) do
        local wight_n = 1
        local height_n = 1
        if i % 3 == 0 then
            wight_n = 3
        else
            wight_n = i % 3
        end
        local interval = (width - 3 * cell_width) / 2 - 18
        if i % 3 == 0 then
            height_n = i / 3
        else
            height_n = math.floor(i / 3) + 1
        end
        v:setPosition(cc.p((wight_n - 1) * ( interval + cell_width ) + 18, tocalHeight - cell_height * height_n + 35))
    end
end

function RedAlertTimeBoxPreview:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_act_congratulations_arrow_down:setVisible(true)
        else
            self._Image_act_congratulations_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_act_congratulations_arrow_up:setVisible(true)
        else
            self._Image_act_congratulations_arrow_up:setVisible(false)
        end
    end
end

function RedAlertTimeBoxPreview:onInit(index)
    local csbItem = csb.createNode(config_csb.activity.seven_day_recruit_prompt)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_act_congratulations_get_close"), nil, 
    {
        terminal_name = "red_alert_time_box_preview_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_act_congratulations_get_sure"), nil, 
    {
        terminal_name = "red_alert_time_box_preview_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_box_preview_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    self._Image_act_congratulations_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_act_congratulations_arrow_down")
    self._Image_act_congratulations_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_act_congratulations_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_act_congratulations_arrow_down:stopAllActions()
    self._Image_act_congratulations_arrow_up:stopAllActions()
    playActions(self._Image_act_congratulations_arrow_down)
    playActions(self._Image_act_congratulations_arrow_up)
    self._Image_act_congratulations_arrow_down:setVisible(false)
    self._Image_act_congratulations_arrow_up:setVisible(false)

    self:onUpdateDraw()
end

function RedAlertTimeBoxPreview:init(params)
    self._reward_info = params[1]
    if params[2] ~= nil then
        self._tipString = params[2]   
    end
    self:onInit()
    return self
end

function RedAlertTimeBoxPreview:onExit()
    state_machine.remove("red_alert_time_box_preview_reset")
end