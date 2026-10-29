-- ---------------------------
-- 配件补给扫荡
-- ---------------------------
PvePartsSupplySweep = class("PvePartsSupplySweepClass", Window)

local pve_parts_supply_sweep_window_open_terminal = {
    _name = "pve_parts_supply_sweep_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)     
        if nil == fwin:find("PvePartsSupplySweepClass") then
            fwin:open(PvePartsSupplySweep:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local pve_parts_supply_sweep_window_close_terminal = {
    _name = "pve_parts_supply_sweep_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PvePartsSupplySweepClass"))
        _ED.show_reward_list_group = {}
        _ED.show_reward_list_group_ex = {}
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_parts_supply_sweep_window_open_terminal)
state_machine.add(pve_parts_supply_sweep_window_close_terminal)
state_machine.init()

function PvePartsSupplySweep:ctor()
    self.super:ctor()
    self.roots = {}

    -- var 
    -- 列表
    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0
    self._Image_world_attack_arrow_down = nil
    self._Image_world_attack_arrow_up = nil

    self._sweep_name = ""
    self._get_reward_list = nil
    self._current_index = 1

    self._total_count = 0
    self._sweep_count = 0
    self._scene_name = {}

    self._last_sweep_cell = nil

    local function init_pve_parts_supply_sweep_terminal()
        local pve_parts_supply_sweep_next_reward_terminal = {
            _name = "pve_parts_supply_sweep_next_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:showNextReward()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        local pve_parts_supply_sweep_update_zidi_terminal = {
            _name = "pve_parts_supply_sweep_update_zidi",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:runAction(cc.Sequence:create(cc.DelayTime:create(0.01), cc.CallFunc:create(function (sender)
                    instance._list_view:scrollToPercentVertical(100,0.5,true)
                end )))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   


        state_machine.add(pve_parts_supply_sweep_next_reward_terminal)
        state_machine.add(pve_parts_supply_sweep_update_zidi_terminal)
        state_machine.init()
    end
    
    -- call func equipment_parts_tab create state machine.
    init_pve_parts_supply_sweep_terminal()
end

function PvePartsSupplySweep:showNextReward()
    local index = self._current_index
    local reward_index = self._sweep_count + 1 - index

    if (self._total_count == self._sweep_count and index <= self._sweep_count)
        or (self._total_count > self._sweep_count and index <= self._sweep_count + 1)
        then
        local show_reward_list = nil
        if index <= self._sweep_count then
            show_reward_list = self._get_reward_list[reward_index].show_reward_list
        end
        local cell = state_machine.excute("pve_parts_supply_sweep_create_cell",0,{show_reward_list,self._scene_name[index],index})
        self._current_index = self._current_index + 1
        self._list_view:addChild(cell)
        self._list_view:requestRefreshView()
        self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
        self._list_view_height = self._list_view:getInnerContainer():getPositionY()

        if self._last_sweep_cell ~= nil then
            state_machine.excute("pve_parts_supply_sweep_cell_animation_play", 0, self._last_sweep_cell)
        end
        self._last_sweep_cell = cell

        self._list_view:scrollToPercentVertical(100,0.5,true)
    else
        if self._last_sweep_cell ~= nil then
            state_machine.excute("pve_parts_supply_sweep_cell_animation_play", 0, self._last_sweep_cell)
        end
        self._last_sweep_cell = nil
    end
end

function PvePartsSupplySweep:onUpdateDraw()
    local root = self.roots[1]
    local ListView_sweep_result = ccui.Helper:seekWidgetByName(root,"ListView_sweep_result")
    self._list_view = ListView_sweep_result
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()


    self._list_view:requestRefreshView()
    -- self._list_view:getInnerContainer():setPositionY(-height*index)
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self:showNextReward()
    self:showNextReward()
end

--设置扫荡列表Y轴
function PvePartsSupplySweep:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_world_attack_arrow_down:setVisible(true)
        else
            self._Image_world_attack_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_world_attack_arrow_up:setVisible(true)
        else
            self._Image_world_attack_arrow_up:setVisible(false)
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

function PvePartsSupplySweep:onEnterTransitionFinish()

end

function PvePartsSupplySweep:onInit( )
    local csbItem = csb.createNode(config_csb.pve.pve_parts_supply_sweep)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_pve_sweep_close"), nil, 
    {
        terminal_name = "pve_parts_supply_sweep_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "pve_parts_supply_sweep_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_pve_sweep_sure"), nil, 
    {
        terminal_name = "pve_parts_supply_sweep_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self._Image_world_attack_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_world_attack_arrow_down")
    self._Image_world_attack_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_world_attack_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_world_attack_arrow_down:stopAllActions()
    self._Image_world_attack_arrow_up:stopAllActions()
    playActions(self._Image_world_attack_arrow_down)
    playActions(self._Image_world_attack_arrow_up)
    self._Image_world_attack_arrow_down:setVisible(false)
    self._Image_world_attack_arrow_up:setVisible(false)

	self:onUpdateDraw()	
end

function PvePartsSupplySweep:init(params)
    self._sweep_name = params[1]

    self._get_reward_list = _ED.show_reward_list_group_ex
    self._scene_name = zstring.split(self._sweep_name, ",")
    self._total_count = #self._scene_name
    self._sweep_count = #self._get_reward_list

	self:onInit()
    return self
end

function PvePartsSupplySweep:onExit()
    state_machine.remove("pve_parts_supply_sweep_next_reward")
    state_machine.remove("pve_parts_supply_sweep_update_zidi")
end
