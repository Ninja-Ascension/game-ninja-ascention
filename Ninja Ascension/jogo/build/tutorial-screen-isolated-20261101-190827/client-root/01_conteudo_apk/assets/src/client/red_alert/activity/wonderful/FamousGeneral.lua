-----------------------------
--名将招募(活动类型8)
-----------------------------
FamousGeneral = class("FamousGeneralClass", Window)
--打开界面
local famous_general_window_open_terminal = {
    _name = "famous_general_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("FamousGeneralClass") then
            local panel = FamousGeneral:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local famous_general_window_close_terminal = {
    _name = "famous_general_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FamousGeneralClass"))

        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(famous_general_window_open_terminal)
state_machine.add(famous_general_window_close_terminal)
state_machine.init()

function FamousGeneral:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.pos_table = {
        {x = 0,y =0},
        {x = 0,y =0},
        {x = 0,y =0},
        {x = 0,y =0},
        {x = 0,y =0},

    }   
    --面板表
    self.panel_tables = {}

    self._height = 0
    --load lua file

    -- Initialize FamousGeneral state machine.
    local function init_famous_general_terminal()
		--滚动
        local famous_general_turn_page_terminal = {
            _name = "famous_general_turn_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("famous_general_turn_page",0,"")
                local turn_type = params[1]
                if turn_type == "left" then
                    instance:turnLeft()
                    -- print("=====左滑动")
                elseif turn_type == "right" then
                    instance:turnRight()
                    -- print("=====右滑动")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --选择英雄
        local famous_general_get_hero_reward_terminal = {
            _name = "famous_general_get_hero_reward",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local select_hero_index = params._datas.select_hero_index
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open",0,{1008})
                        state_machine.excute("wonderful_remove_page",0,{8})  
                    end
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["8"].activity_id .. "\r\n" .."8" .. "\r\n" .. "0" .."\r\n" .. (select_hero_index - 1)
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, nil, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --重新设置进度
        local famous_general_set_complite_count_terminal = {
            _name = "famous_general_set_complite_count",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setCompliteCount()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新
        local famous_general_set_positiony_terminal = {
            _name = "famous_general_set_positiony",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                local height = instance._list_view:getContentSize().height
                if instance._height > height then
                    instance._list_view:getInnerContainer():setPositionY(height - instance._height)
                else
                    instance._list_view:getInnerContainer():setPositionY(0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --播放动画
        local famous_general_play_actions_terminal = {
            _name = "famous_general_play_actions",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:playActions()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(famous_general_turn_page_terminal)
        state_machine.add(famous_general_get_hero_reward_terminal)
        state_machine.add(famous_general_set_complite_count_terminal)
        state_machine.add(famous_general_set_positiony_terminal)
        state_machine.add(famous_general_play_actions_terminal)
        state_machine.init()
    end
    
    -- call func init up_level state machine.
    init_famous_general_terminal()
end

function FamousGeneral:onUpdateDraw()
    local root = self.roots[1]
    local ListView_general = ccui.Helper:seekWidgetByName(root, "ListView_general") 
    ListView_general:removeAllItems()

    local result1 = {}
    local result2 = {}
    local result3 = {}
    for k,v in pairs(_ED.activity_info["8"].activity_data[2]) do
        if tonumber(v.achieve_state) == 1 then
            table.insert(result1, v)
        elseif tonumber(v.achieve_state) == 0 then
            table.insert(result2, v)
        elseif tonumber(v.achieve_state) == 2 then
            table.insert(result3, v)
        end
    end
    for k,v in pairs(result2) do
        table.insert(result1, v)
    end
    for k,v in pairs(result3) do
        table.insert(result1, v)
    end
    for i, v in pairs(result1) do
        local cell = state_machine.excute("famous_general_create_cell",0,{v,"8",i,2})
        ListView_general:addChild(cell)
        self._height = cell:getContentSize().height + self._height
    end
    ListView_general:requestRefreshView()
    self._list_view = ListView_general
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self:setCompliteCount()
end

function FamousGeneral:setCompliteCount()
    local root = self.roots[1]
    local Text_task_v = ccui.Helper:seekWidgetByName(root,"Text_task_v")
    Text_task_v:setString(_ED.activity_info["8"].activity_add_state)

    for i = 1 ,5 do
        local Button_recruit = ccui.Helper:seekWidgetByName(root,"Button_recruit_"..i)
        --招募
        if Button_recruit ~= nil then
            if tonumber(_ED.activity_info["8"].activity_data[1][i].achieve_state) == 1 then
                Button_recruit:setBright(true)
                Button_recruit:setTouchEnabled(true)
            else
                Button_recruit:setBright(false)
                Button_recruit:setTouchEnabled(false)
            end
        end
    end
end

function FamousGeneral:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
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

function FamousGeneral:onEnterTransitionFinish()

end

--设置面板大小
function FamousGeneral:setPanelScale(panel)
    local index = panel.index
    local scale_number = 1
    if index == 1 then
        if #self.panel_tables == 2 then
            scale_number = 0.9
            panel:setLocalZOrder(30)
        else
            scale_number = 0.6
            panel:setLocalZOrder(30)
        end
    elseif index == 2 then
        if #self.panel_tables == 2 then
            scale_number = 0.9
            panel:setLocalZOrder(40)
        else
            scale_number = 0.8
            panel:setLocalZOrder(40)
        end
    elseif index == 3 then
        scale_number = 1
        panel:setLocalZOrder(50)
    elseif index == 4 then
        scale_number = 0.8
        panel:setLocalZOrder(40)
    elseif index == 5 then
        scale_number = 0.6
        panel:setLocalZOrder(30)
    end

    panel:setScale(scale_number)
end

function FamousGeneral:initUI()
    state_machine.lock("famous_general_turn_page",0,"")
    local root = self.roots[1]
    for i = 1,5 do
        local Panel_card = ccui.Helper:seekWidgetByName(root, "Panel_card_"..i)
        if Panel_card ~= nil then
            self.panel_tables[i] = Panel_card
            self.pos_table[i].x,self.pos_table[i].y = self.panel_tables[i]:getPosition()
            self.panel_tables[i].index = i

            -- local cell = state_machine.excute("fate_create_cell",0,{i})
            -- cell:setAnchorPoint(0.5,0.5)
            -- cell:setPosition(cc.p(Panel_altar_hide:getContentSize().width/2,Panel_altar_hide:getContentSize().height/2))
            -- self.panel_tables[i]:addChild(cell)
        end
    end

    for k,v in pairs(self.panel_tables) do
        self:setPanelScale(v)
    end

    local width = math.abs(tonumber(self.pos_table[1].x) - tonumber(self.pos_table[2].x))
    --滑动按钮
    local function PanelTouchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        
        if ccui.TouchEventType.began == evenType then

        elseif ccui.TouchEventType.moved == evenType then
            -- print("===============",__mpoint.x - __spoint.x,width/2)
            if __mpoint.x - __spoint.x > width/3 then
                state_machine.excute("famous_general_turn_page",0,{"left"})
            end

            if __mpoint.x - __spoint.x < -width/3  then
                state_machine.excute("famous_general_turn_page",0,{"right"})
            end
        elseif ccui.TouchEventType.canceled == evenType then
            state_machine.unlock("famous_general_turn_page",0,"")
        elseif ccui.TouchEventType.ended == evenType then
        --注掉，滑动不松开就会一直划。 不注释，松开就不划了
            state_machine.unlock("famous_general_turn_page",0,"")
        end
    end
    -- 滑动监听
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_card_xx"), PanelTouchEvent, 
    {
        terminal_name = "", 
        terminal_state = 0,
    },
    nil,0)

    for i = 1 ,5 do
        local Button_recruit = ccui.Helper:seekWidgetByName(root,"Button_recruit_"..i)
        if Button_recruit ~= nil then
            --招募
            fwin:addTouchEventListener(Button_recruit, nil, 
            {
                terminal_name = "famous_general_get_hero_reward", 
                terminal_state = 0,
                select_hero_index = i,
                touch_scale = true,
                touch_scale_xy = 0.95, 
            }, nil, 0)
        end
    end
end

--向左滑动
function FamousGeneral:turnLeft()
    local function MoveCallBack()
        -- self:checkPageIndex()
    end

    local moveIndex = 0
    for i,panel in pairs(self.panel_tables) do
        moveIndex = panel.index + 1
        if moveIndex == #self.panel_tables + 1 then
            moveIndex = 1
        end

        if i ~= #self.panel_tables then
            move = cc.MoveTo:create(0.1,cc.p(self.pos_table[moveIndex].x,self.pos_table[moveIndex].y))      
        else
            move = cc.Sequence:create(cc.MoveTo:create(0.1,cc.p(self.pos_table[moveIndex].x,self.pos_table[moveIndex].y)),cc.CallFunc:create(MoveCallBack))
        end
        panel:runAction(move)
        panel.index = moveIndex
        
        self:setPanelScale(panel)
    end
end

--向右滑动
function FamousGeneral:turnRight()
    local function MoveCallBack()
        -- self:checkPageIndex()
    end
    local moveIndex = 0
    for i,panel in pairs(self.panel_tables) do
        moveIndex = panel.index - 1
        if moveIndex == 0 then
            moveIndex = #self.panel_tables
        end

        if i ~= #self.panel_tables then
            move = cc.MoveTo:create(0.1,cc.p(self.pos_table[moveIndex].x,self.pos_table[moveIndex].y))      
        else
            move = cc.Sequence:create(cc.MoveTo:create(0.1,cc.p(self.pos_table[moveIndex].x,self.pos_table[moveIndex].y)),cc.CallFunc:create(MoveCallBack))
        end
        panel:runAction(move)
        panel.index = moveIndex
    
        self:setPanelScale(panel)
    end
end

--播放动画
function FamousGeneral:playActions()
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("windows_open", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_open_over" then
            state_machine.unlock("famous_general_turn_page",0,"")
        end
    end)
end

function FamousGeneral:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.famous_general)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.activity.wonderful.famous_general)
    table.insert(self.actions, action)
    csbItem:runAction(action)

    self:initUI()
	self:onUpdateDraw()
    self:playActions()
end

function FamousGeneral:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self:onInit()
    return self
end

function FamousGeneral:onExit()
    state_machine.remove("famous_general_turn_page")
    state_machine.remove("famous_general_get_hero_reward")
    state_machine.remove("famous_general_set_complite_count")
    state_machine.remove("famous_general_set_positiony")
    state_machine.remove("famous_general_play_actions")
end
