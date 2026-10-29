-- ----------------------------------------------------------------------------------------------------
-- 说明：更多奖励
-------------------------------------------------------------------------------------------------------
AdventureArenaWarcraftMoreReward = class("AdventureArenaWarcraftMoreRewardClass", Window)
    
function AdventureArenaWarcraftMoreReward:ctor()
    self.super:ctor()
    self.roots = {}

    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    app.load("client.adventure.cells.arena.AdventureArenaWarcraftRewardListCell")
    -- Initialize adventure arena state machine.
    local function init_adventure_arena_warcraft_more_reard_terminal()
    
        --返回
		  local adventure_arena_warcraft_more_reward_list_manager_terminal = {
            _name = "adventure_arena_warcraft_more_reward_list_manager",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			          if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setColor(cc.c3b(130, 130, 130))
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setColor(cc.c3b(255, 255, 255))
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end
                instance:onUpdateStates(tonumber(params._datas.current_button_type))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        local adventure_arena_warcraft_more_reward_update_tip_terminal = {
            _name = "adventure_arena_warcraft_more_reward_update_tip",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateRewardTip()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }          

        
        state_machine.add(adventure_arena_warcraft_more_reward_list_manager_terminal)	
        state_machine.add(adventure_arena_warcraft_more_reward_update_tip_terminal)   

        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_warcraft_more_reard_terminal()
end

function AdventureArenaWarcraftMoreReward:init(isGetServer)

	return self
end

function AdventureArenaWarcraftMoreReward:onUpdate(dt)
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
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function AdventureArenaWarcraftMoreReward:onUpdateStates(show_type)
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
    listView:removeAllItems()
    listView:jumpToTop()
    if show_type == 1 then 
        local states = zstring.split("" .. _ED.warcraft_info.get_reward_states, ",")
        if states == nil then 
            return
        end
        for i=1,26 do
            local cell = AdventureArenaWarcraftRewardListCell:createCell()
            cell:init(1,i)
            listView:addChild(cell)
        end
    else
       local states = zstring.split("" .. _ED.warcraft_info.current_win_reward_buy_states, ",")
        if states == nil then 
            return
        end
        for i=1,12 do
            local cell = AdventureArenaWarcraftRewardListCell:createCell()
            cell:init(2,i)
            listView:addChild(cell)
        end
    end

    listView:requestRefreshView()
    self.currentListView = listView
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function AdventureArenaWarcraftMoreReward:onUpdateDraw()
	local root = self.roots[1]
    if root == nil then 
        return
    end
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
    listView:removeAllItems()

    local states = zstring.split("" .. _ED.warcraft_info.get_reward_states, ",")
    if states == nil then 
        return
    end
    for i=1,26 do
        local cell = AdventureArenaWarcraftRewardListCell:createCell()
        cell:init(i)
        listView:addChild(cell)
    end
    listView:requestRefreshView()

    self.currentListView = listView
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function AdventureArenaWarcraftMoreReward:onUpdateRewardTip()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local dwButton = ccui.Helper:seekWidgetByName(root, "Button_duanwei")
    local lsButton = ccui.Helper:seekWidgetByName(root, "Button_liansheng")

    local states = zstring.split("" .. _ED.warcraft_info.get_reward_states, ",")
    local isNeedTip = false
    for i=1,26 do
        local current_state = states[i]
        if i <= zstring.tonumber(_ED.warcraft_info.current_history_best_title) then 
        --可以领取
            if zstring.tonumber(current_state) == 0  then  -- 0 未领取 1 已经领取
                --未领取的
                isNeedTip = true
            end
        end
    end
    local tipBall = dwButton:getChildByName("ball1")
    if isNeedTip == true then 
        --添加提示
        if tipBall == nil then 
            local ball = cc.Sprite:create("images/ui/bar/tips.png")
            ball:setName("ball1")
            ball:setAnchorPoint(cc.p(1, 1))
            ball:setPosition(cc.p(dwButton:getContentSize().width + 5 , dwButton:getContentSize().height))
            dwButton:addChild(ball)    
        end
    else
        if tipBall ~= nil then 
            dwButton:removeChildByName("ball1")
        end
    end
    isNeedTip = false
    local states_1 = zstring.split("" .. _ED.warcraft_info.current_win_reward_buy_states, ",")
    for i=1,12 do
        local current_state = states_1[i]
        local current_win = dms.int(dms["warcraft_win_reward"],i, warcraft_win_reward.win_count)
        if current_win <= zstring.tonumber(_ED.warcraft_info.current_win_max_count) then 
        --可以领取
            if zstring.tonumber(current_state) == 0  then  -- 0 未领取 1 已经领取
                --未领取的
                isNeedTip = true
            end
        end
    end
    tipBall = lsButton:getChildByName("ball2")
    if isNeedTip == true then 
        --添加提示
        if tipBall == nil then 
            local ball = cc.Sprite:create("images/ui/bar/tips.png")
            ball:setName("ball2")
            ball:setAnchorPoint(cc.p(1, 1))
            ball:setPosition(cc.p(lsButton:getContentSize().width + 5 , lsButton:getContentSize().height))
            lsButton:addChild(ball)    
        end
    else
        if tipBall ~= nil then 
            lsButton:removeChildByName("ball2")
        end
    end
    -- body
end
function AdventureArenaWarcraftMoreReward:onEnterTransitionFinish()
	local csbAdventureArena = csb.createNode("campaign/Arena/jingji_pws_jiangli_0.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)

	-- -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureArenaWarcraftMoreRewardClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    --段位奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_duanwei"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_more_reward_list_manager",     
        current_button_name = "Button_duanwei",  
        current_button_type = 1 ,      
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)
    --上周排行
    local lianshengButton = ccui.Helper:seekWidgetByName(root, "Button_liansheng")
    lianshengButton:setColor(cc.c3b(130, 130, 130))
    lianshengButton:setHighlighted(false)
    lianshengButton:setTouchEnabled(true)
    --
    --连胜奖励
    fwin:addTouchEventListener(lianshengButton,       nil, 
    {
        terminal_name = "adventure_arena_warcraft_more_reward_list_manager",     
        current_button_name = "Button_liansheng",  
        current_button_type = 2 ,      
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)
    state_machine.excute("adventure_arena_warcraft_more_reward_list_manager", 0, 
        {_datas ={
            current_button_name = "Button_duanwei",        
            current_button_type = 1 ,      
            terminal_state = 0, 
            isPressedActionEnabled = true
        }}
    )
    self:onUpdateRewardTip()
   --self:onUpdateDraw()
end

function AdventureArenaWarcraftMoreReward:onExit()
    self.roots = nil
    
end