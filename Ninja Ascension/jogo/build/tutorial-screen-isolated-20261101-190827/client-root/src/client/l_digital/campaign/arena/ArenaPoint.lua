-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场积分界面
-------------------------------------------------------------------------------------------------------

ArenaPoint = class("ArenaPointClass", Window)

local arena_point_window_open_terminal = {
    _name = "arena_point_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- Fury: sin la respuesta de arena_init (el tutorial deja pulsar antes de que llegue)
        -- la lista de premios cobrados es nil y la ventana revienta en pairs(nil).
        if _ED.user_arena_order_score_draw_state == nil then
            return false
        end
        if fwin:find("ArenaPointClass") == nil then
            local _win = ArenaPoint:new()
            _win:init()
            fwin:open(_win, fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_point_window_close_terminal = {
    _name = "arena_point_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ArenaPointClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(arena_point_window_open_terminal)
state_machine.add(arena_point_window_close_terminal)
state_machine.init()

function ArenaPoint:ctor()
    self.super:ctor()
    self.roots = {}
    self.canReceive = false

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    app.load("client.l_digital.cells.arena.arena_point_list")
    app.load("client.reward.DrawRareReward")
    local function init_arena_point_terminal()
        -- 一键领取
        local arena_point_window_receive_one_key_terminal = {
            _name = "arena_point_window_receive_one_key",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if self.canReceive == false then
                    TipDlg.drawTextDailog(_new_interface_text[37])
                    return
                end
                local function responseReceiveCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            instance:onUpdateDraw()
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(14)
                            fwin:open(getRewardWnd, fwin._windows)
                        end 
                    end
                end
                protocol_command.draw_arena_score_reward.param_list = "-1"
                NetworkManager:register(protocol_command.draw_arena_score_reward.code, nil, nil, nil, instance, responseReceiveCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local arena_point_window_update_reward_state_terminal = {
            _name = "arena_point_window_update_reward_state",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateRewardState()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(arena_point_window_receive_one_key_terminal)
        state_machine.add(arena_point_window_update_reward_state_terminal)
        state_machine.init()
    end
    
    init_arena_point_terminal()
end

function ArenaPoint:onUpdateRewardState()
    local root = self.roots[1]
    local Button_yjlq = ccui.Helper:seekWidgetByName(root, "Button_yjlq")
    self.canReceive = false

    local ListView_jifen = ccui.Helper:seekWidgetByName(root, "ListView_jifen")
    for i, v in pairs(ListView_jifen:getItems()) do
        if v.canReward == true then
            self.canReceive = true
            break
        end
    end

    if self.canReceive == true then
        Button_yjlq:setBright(true)
        Button_yjlq:setVisible(true)
    else
        Button_yjlq:setBright(false)
        Button_yjlq:setVisible(false)
    end
end

function ArenaPoint:onUpdateDraw()
    local root = self.roots[1]
    local Text_jifen_n = ccui.Helper:seekWidgetByName(root, "Text_jifen_n")
    local myPoint = tonumber(_ED.user_arena_score)  
    Text_jifen_n:setString(myPoint)
    
    local Button_yjlq = ccui.Helper:seekWidgetByName(root, "Button_yjlq")
    self.canReceive = false

    local ListView_jifen = ccui.Helper:seekWidgetByName(root, "ListView_jifen")
    ListView_jifen:removeAllItems()
    local rewardInfo = dms["arena_score"]
    local jumpToIndex = 0
    for i = 0 , #rewardInfo do
        local cell = state_machine.excute("arene_point_cell_creat" , 0 , i)
        ListView_jifen:addChild(cell)
        if i > 0 then
            local reward_target = dms.atoi(rewardInfo[i] ,arena_score.point_target)
            local haveReward = false
            if myPoint >= tonumber(reward_target) then
                for j , w in pairs(_ED.user_arena_order_score_draw_state) do 
                    if i == tonumber(w) then
                        haveReward = true
                    end
                end
                if haveReward == false then
                    self.canReceive = true
                    if jumpToIndex == 0 then
                        jumpToIndex = i + 1
                    end
                end
            end
        end
    end
    local per = jumpToIndex * 100 / ( #rewardInfo + 1) 
    ListView_jifen:jumpToPercentVertical(per)
    -- self.canReceive = false
    -- for i, v in pairs(ListView_jifen:getItems()) do
    --     if v.canReward == true then
    --         self.canReceive = true
    --         break
    --     end
    -- end

    if self.canReceive == true then
        Button_yjlq:setBright(true)
        Button_yjlq:setVisible(true)
    else
        Button_yjlq:setBright(false)
        Button_yjlq:setVisible(false)
    end
    ListView_jifen:requestRefreshView()
    self._list_view = ListView_jifen
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self:runAction(cc.Sequence:create({cc.DelayTime:create(0.05), cc.CallFunc:create(function ( sender )
        sender._list_view:jumpToPercentVertical(per)
        sender:onUpdate(0)
    end)}))
end

function ArenaPoint:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
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

function ArenaPoint:onEnterTransitionFinish()
    local csbArenaPoint = csb.createNode(config_csb.campaign.ArenaStorage.ArenaStorage_jifen)
	local root = csbArenaPoint:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArenaPoint)
    
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),nil, 
    {
        terminal_name = "arena_point_window_close",           
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --一键领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yjlq"),nil, 
    {
        terminal_name = "arena_point_window_receive_one_key",           
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	self:onUpdateDraw()

    app.load("client.player.UserInformationHeroStorage")
    local userInformationHeroStorage = UserInformationHeroStorage:new()
    userInformationHeroStorage._rootWindows = self
    fwin:open(userInformationHeroStorage,fwin._view)
end

function ArenaPoint:init()
	
end

function ArenaPoint:onExit()
    state_machine.remove("arena_point_window_receive_one_key")
    state_machine.remove("arena_point_window_update_reward_state")
end
