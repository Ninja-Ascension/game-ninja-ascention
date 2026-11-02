-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场成就界面
-------------------------------------------------------------------------------------------------------

ArenaAchieveReward = class("ArenaAchieveRewardClass", Window)

local arena_achieve_reward_window_open_terminal = {
    _name = "arena_achieve_reward_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- Fury: sin la respuesta de arena_init (el tutorial deja pulsar antes de que llegue)
        -- la lista de premios cobrados es nil y la ventana revienta en pairs(nil).
        if _ED.user_arena_order_reward_draw_state == nil then
            return false
        end
        if fwin:find("ArenaAchieveRewardClass") == nil then
            local _win = ArenaAchieveReward:new()
            _win:init()
            fwin:open(_win, fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_achieve_reward_window_close_terminal = {
    _name = "arena_achieve_reward_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ArenaAchieveRewardClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(arena_achieve_reward_window_open_terminal)
state_machine.add(arena_achieve_reward_window_close_terminal)
state_machine.init()

function ArenaAchieveReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.canReceive = false

    self._list_view = nil
    self._list_view_pox = 0
    self._list_view_width = 0

    self._list_view_posY = 0
    self._list_view_height= 0

    self.allget = {}
    self.per = 0
    self.left_button = nil
    self.right_button = nil  
    app.load("client.l_digital.cells.arena.arena_achieve_reward_list")
    app.load("client.cells.utils.resources_icon_cell")
    local function init_arena_achieve_reward_terminal()
        -- 滑动listView
        local arena_achieve_reward_slip_listView_terminal = {
            _name = "arena_achieve_reward_slip_listView",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currType = params._datas._type
                if currType == 1 then
                    instance.per = instance.per - 10
                elseif currType == 2 then
                    instance.per = instance.per + 10  
                end
                instance.per = math.min(instance.per , 100)
                instance.per = math.max(instance.per , 0)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
                    instance._list_view:jumpToPercentVertical(instance.per)
                else
                    instance._list_view:jumpToPercentHorizontal(instance.per)
                end
                instance._list_view:refreshView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 添加总收益
        local arena_achieve_reward_all_get_update_terminal = {
            _name = "arena_achieve_reward_all_get_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addAllGet(tonumber(params))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(arena_achieve_reward_all_get_update_terminal)
		state_machine.add(arena_achieve_reward_slip_listView_terminal)
        state_machine.init()
    end
    
    init_arena_achieve_reward_terminal()
end
function ArenaAchieveReward:addAllGet( reward_id )
    local root = self.roots[1]
    local rewardInfo = dms.string(dms["arena_welfare"], reward_id ,arena_welfare.reward_info)
    local reward = zstring.split(rewardInfo, "|")
    for i , v in pairs( reward ) do
        local data = zstring.split(v, ",")
        if self.allget[1] == nil then
            table.insert(self.allget , data)
        else
            local haveSame = false
            local sameIndex = nil
            for j , w in pairs(self.allget) do
                if tonumber(data[1]) == tonumber(w[1]) and tonumber(data[2]) == tonumber(w[2]) then
                    haveSame = true
                    sameIndex = j
                    break
                end
            end
            if haveSame == true then
                self.allget[sameIndex][3] = tonumber(self.allget[sameIndex][3]) + tonumber(data[3])
            else
                table.insert(self.allget , data)
            end
        end
    end

    --总收益
    local ListView_profit = ccui.Helper:seekWidgetByName(root, "ListView_profit")
    ListView_profit:removeAllItems()
    for i , v in pairs(self.allget) do
        -- local cell = ResourcesIconCell:createCell()
        -- cell:init(v[1], v[3], v[2],nil,nil,nil,true)
        -- ListView_profit:addChild(cell)
        local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{v[1],v[2],v[3]},false,true,false,true})
        ListView_profit:addChild(cell)
    end
    ListView_profit:requestRefreshView()
end

function ArenaAchieveReward:onUpdateDraw()
    local root = self.roots[1]
    local Text_best_rank = ccui.Helper:seekWidgetByName(root, "Text_best_rank")
    local myPoint = tonumber(_ED.user_arena_max_order)  
    Text_best_rank:setString(myPoint)
    
    local ListView_challenger = ccui.Helper:seekWidgetByName(root, "ListView_challenger")
    ListView_challenger:removeAllItems()
    local rewardInfo = dms["arena_welfare"]
    local jumpToIndex = 0
    local width = 0
    local height = 0
    self.allget = {}
    for i = 1 , #rewardInfo do
        local cell = state_machine.excute("arena_achieve_reward_cell_creat", 0, i)
        if width == 0 then
            width = cell:getContentSize().width
        elseif height == 0 then
            height = cell:getContentSize().height
        end
        ListView_challenger:addChild(cell)
        local reward_target = dms.atoi(rewardInfo[i],arena_welfare.rank_target)
        if myPoint <= tonumber(reward_target) then
            local haveReward = false
            for j , w in pairs(_ED.user_arena_order_reward_draw_state) do 
                if i == tonumber(w) then
                    haveReward = true
                end
            end
            if haveReward == false then  -- 未领奖
                if jumpToIndex == 0 then
                    jumpToIndex = i
                end
            else
                self:addAllGet(i)
            end
        else
            if jumpToIndex == 0 then
                jumpToIndex = i
            end
        end
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
        if jumpToIndex == #rewardInfo or jumpToIndex == (#rewardInfo - 1) then
            jumpToIndex = #rewardInfo - 2
        end
    end

    self.per = jumpToIndex * 100 / (#rewardInfo)
    ListView_challenger:requestRefreshView()
    --ListView_challenger:jumpToPercentHorizontal(self.per)
    --ListView_challenger:refreshView() 
    self._list_view = ListView_challenger
    -- self._list_view_pox = self._list_view:getInnerContainer():getPositionX()
    -- self._list_view_width = self._list_view:getInnerContainer():getPositionX()
    -- state_machine.excute("arena_achieve_reward_slip_listView",0,{_datas = { currType = 0}})
    
    -- self._list_view:getInnerContainer():setPositionX(-width * (jumpToIndex - 1))
    -- self._list_view:requestRefreshView()

    self.left_button = ccui.Helper:seekWidgetByName(root, "Button_arrow_l")
    self.right_button = ccui.Helper:seekWidgetByName(root, "Button_arrow_r")

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
        self:runAction(cc.Sequence:create({cc.DelayTime:create(0.01), cc.CallFunc:create(function ( sender )
            listviewPositioningMoves(self._list_view, jumpToIndex)
            self._list_view:requestRefreshView()
        end)}))
    else
        self:runAction(cc.Sequence:create({cc.DelayTime:create(0.01), cc.CallFunc:create(function ( sender )
            self._list_view:getInnerContainer():setPositionX(-width * (jumpToIndex - 1))
            self._list_view:requestRefreshView()
        end)}))
    end
end

function ArenaAchieveReward:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posX = self._list_view:getInnerContainer():getPositionX()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_width == 0 then
            self._list_view_width = posX
        elseif self ._list_view_posY == 0 then
            self._list_view_posY = posY
        end

        if self.right_button ~= nil then
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
                 if self._list_view_posY < -30 then 
                    self.right_button:setVisible(true)
                else
                    self.right_button:setVisible(false)
                end
                if self._list_view_posY >= self._list_view:getContentSize().height - self._list_view:getInnerContainer():getContentSize().height + 30 then
                    self.left_button:setVisible(true)
                else
                    self.left_button:setVisible(false)
                end

                if self._list_view_posY == posY then
                    return
                end
                self._list_view_posY = posY
                local items = self._list_view:getItems()
                if items[1] == nil then
                    return
                end
                local itemSize = items[1]:getContentSize()
                for i, v in pairs(items) do
                    local tempY = v:getPositionY() + posY
                    if tempY + itemSize.height/2 < 0 or tempY > size.height + itemSize.height /2 then
                        v:unload()
                    else
                        v:reload()
                    end
                end
            else
                if self._list_view_pox < -30 then 
                    self.left_button:setVisible(true)
                else
                    self.left_button:setVisible(false)
                end
                if self._list_view_pox >= self._list_view:getContentSize().width - self._list_view:getInnerContainer():getContentSize().width + 30 then
                    self.right_button:setVisible(true)
                else
                    self.right_button:setVisible(false)
                end

                if self._list_view_pox == posX then
                    return
                end
                self._list_view_pox = posX
                local items = self._list_view:getItems()
                if items[1] == nil then
                    return
                end
                local itemSize = items[1]:getContentSize()
                for i, v in pairs(items) do
                    local tempX = v:getPositionX() + posX
                    if tempX + itemSize.width/2 < 0 or tempX > size.width + itemSize.width /2 then
                        v:unload()
                    else
                        v:reload()
                    end
                end
            end
        end
    end
end

function ArenaAchieveReward:onEnterTransitionFinish()
    local csbArenaAchieveReward = csb.createNode(config_csb.campaign.ArenaStorage.ArenaStorage_ranking_reward)
	local root = csbArenaAchieveReward:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArenaAchieveReward)

    
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),nil, 
    {
        terminal_name = "arena_achieve_reward_window_close",           
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --左滑
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_l"),nil, 
    {
        terminal_name = "arena_achieve_reward_slip_listView",           
        terminal_state = 0,
        _type = 1, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --右滑
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_r"),nil, 
    {
        terminal_name = "arena_achieve_reward_slip_listView",           
        terminal_state = 0, 
        _type = 2,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	self:onUpdateDraw()

    app.load("client.player.UserInformationHeroStorage")
    local userInformationHeroStorage = UserInformationHeroStorage:new()
    userInformationHeroStorage._rootWindows = self
    fwin:open(userInformationHeroStorage,fwin._view)
end

function ArenaAchieveReward:init()
	
end

function ArenaAchieveReward:onExit()
    state_machine.remove("arena_achieve_reward_slip_listView")
    state_machine.remove("arena_achieve_reward_all_get_update")   
end
