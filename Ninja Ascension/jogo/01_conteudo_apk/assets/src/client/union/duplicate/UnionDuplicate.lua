--------------------------------------------------------------------------------------------------------------
--  说明：军团副本主界面
--------------------------------------------------------------------------------------------------------------
UnionDuplicate = class("UnionDuplicateClass", Window)

--打开界面
local union_duplicate_open_terminal = {
    _name = "union_duplicate_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local unionDuplicateWindow = fwin:find("UnionDuplicateClass")
        if unionDuplicateWindow ~= nil and unionDuplicateWindow:isVisible() == true then
            return true
        end
        state_machine.lock("union_duplicate_open")
        local function responseUnionInitPveCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                fwin:open(UnionDuplicate:createCell(), fwin._view)
            else
                state_machine.unlock("union_duplicate_open")
                TipDlg.drawTextDailog(_string_piece_info[100])
            end 
        end
        NetworkManager:register(protocol_command.union_pve_init.code, nil, nil, nil, nil, responseUnionInitPveCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local union_duplicate_close_terminal = {
    _name = "union_duplicate_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        UnionDuplicate:closeCell()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


-- 进入副本场景
local union_duplicate_enter_pve_scene_terminal = {
    _name = "union_duplicate_cell_enter_pve_scene",
    _init = function (terminal)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            app.load("client.l_digital.union.duplicate.UnionDuplicateChallenge")
        else
            app.load("client.union.duplicate.UnionDuplicateChallenge")
        end
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        state_machine.lock("union_duplicate_cell_enter_pve_scene")
        local userDatas = params._datas
        local seatId = userDatas._seat_id
        local open_scene_id = tonumber(_ED.union.union_current_scene_id)
        if seatId == open_scene_id then
           state_machine.excute("union_duplicate_challenge_open", 0,"")
        elseif seatId < open_scene_id then
            TipDlg.drawTextDailog(_string_piece_info[105])
            state_machine.unlock("union_duplicate_cell_enter_pve_scene")
        else
            local desc = dms.string(dms["union_pve_scene"], seatId,union_pve_scene.open_condition_desc)
            TipDlg.drawTextDailog(desc)  
            state_machine.unlock("union_duplicate_cell_enter_pve_scene") 
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_duplicate_open_terminal)
state_machine.add(union_duplicate_close_terminal)
state_machine.add(union_duplicate_enter_pve_scene_terminal)
state_machine.init()

function UnionDuplicate:ctor()
	self.super:ctor()
	self.roots = {}
    self.action = {}

    self.listview = nil
    self.listview_ContainerPosY = nil
	
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        app.load("client.l_digital.union.duplicate.UnionDuplicateClearanceReward")
        app.load("client.l_digital.cells.union.union_duplicate_seat_cell")
    else
        app.load("client.union.duplicate.UnionDuplicateClearanceReward")
        app.load("client.cells.union.union_duplicate_seat_cell")
    end
	-- Initialize union duplicate machine.
    local function init_union_duplicate_terminal()
		-- 隐藏界面
        local union_duplicate_hide_event_terminal = {
            _name = "union_duplicate_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local union_duplicate_show_event_terminal = {
            _name = "union_duplicate_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新信息
		local union_duplicate_refresh_terminal = {
            _name = "union_duplicate_refresh",
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
		--查看帮助
		local union_duplicate_look_help_info_terminal = {
            _name = "union_duplicate_look_help_info",
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
		--点击章节重置
		local union_duplicate_open_reset_terminal = {
            _name = "union_duplicate_open_reset",
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
		-- 点击通关奖励
		local union_duplicate_open_clearance_reward_terminal = {
            _name = "union_duplicate_open_clearance_reward",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("union_duplicate_open_clearance_reward")
                state_machine.excute("union_duplicate_clearance_reward_open",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--点击成员战绩
		local union_duplicate_open_member_mark_terminal = {
            _name = "union_duplicate_open_member_mark",
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
		-- 点击购买挑战次数
		local union_duplicate_to_buy_times_terminal = {
            _name = "union_duplicate_to_buy_times",
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
		state_machine.add(union_duplicate_hide_event_terminal)
		state_machine.add(union_duplicate_show_event_terminal)
		state_machine.add(union_duplicate_refresh_terminal)
		state_machine.add(union_duplicate_look_help_info_terminal)
		state_machine.add(union_duplicate_open_reset_terminal)
		state_machine.add(union_duplicate_open_clearance_reward_terminal)
		state_machine.add(union_duplicate_open_member_mark_terminal)
		state_machine.add(union_duplicate_to_buy_times_terminal)
        state_machine.init()
    end
    
    -- call func init union duplicate  machine.
    init_union_duplicate_terminal()

end

function UnionDuplicate:onHide()
	self:setVisible(false)
end

function UnionDuplicate:onShow()
	self:setVisible(true)
end
function UnionDuplicate:onUpdate()
    if self.listview ~= nil and self.listview:getInnerContainer() ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_ContainerPosY == posY then
            return
        end
        self.listview_ContainerPosY = posY
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
function UnionDuplicate:updateDraw()

    -- _ED.union.union_current_scene_id = npos(list)       --工会当前副本id
    -- _ED.union.union_current_scene_total_hp = npos(list) --工会当前副本总血量
    -- _ED.union.union_current_scene_cur_hp = npos(list)   --工会当前副本当前血量
    -- _ED.union.union_current_scene_open_list = npos(list)        --工会当前已经通关副本列表

    local root = self.roots[1]
    local List_view = ccui.Helper:seekWidgetByName(root, "ListView_chapter_list")
    self.listview = List_view
    -- List_view:removeAllChildren(true)
    List_view:removeAllItems()
    local open_scene_id = tonumber(_ED.union.union_current_scene_id)
    for i= 1 , open_scene_id +1 do
        local cell_type = i%4 --   1,2,3,0
        local seatID = i
        local cell = UnionDuplicateSeatCell:createCell()
        cell:init(seatID,open_scene_id + 1-(i-1),cell_type)--第一个是npcscene,第二个是列表索引 ,倒着来的                                                                                 
        List_view:insertCustomItem(cell,0)
    end
    self.listview_Container = List_view:getInnerContainer()
    self.listview_ContainerPosY = List_view:getInnerContainer():getPositionY()

end

function UnionDuplicate:onInit()
	self:updateDraw()
    -- self:registerOnNoteUpdate(self)
end

function UnionDuplicate:onEnterTransitionFinish()
    local csbUnionDuplicateCell = csb.createNode("legion/legion_pve_chapter.csb")
    local root = csbUnionDuplicateCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionDuplicateCell)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help_4"),  nil, 
    {
        terminal_state = 0
    }, 
    nil, 0)._uncanceled = true
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rollback_6"),  nil, 
    {
        terminal_name = "union_duplicate_close",
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_14_tgjl"),  nil, 
    {
        terminal_name = "union_duplicate_open_clearance_reward",
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:init()
    state_machine.unlock("union_duplicate_open")
end

function UnionDuplicate:init()
	self:onInit()
	return self
end

function UnionDuplicate:onExit()
    self:unregisterOnNoteUpdate(self)
	state_machine.remove("union_duplicate_hide_event")
	state_machine.remove("union_duplicate_show_event")
	state_machine.remove("union_duplicate_refresh")
	state_machine.remove("union_duplicate_look_help_info")
	state_machine.remove("union_duplicate_open_reset")
	state_machine.remove("union_duplicate_open_clearance_reward")
	state_machine.remove("union_duplicate_open_member_mark")
	state_machine.remove("union_duplicate_to_buy_times")
end

function UnionDuplicate:createCell( ... )
    local cell = UnionDuplicate:new()
    -- cell:registerOnNodeEvent(cell)
    return cell
end

function UnionDuplicate:closeCell( ... )
    local unionDuplicateWindow = fwin:find("UnionDuplicateClass")
    if unionDuplicateWindow == nil then
        return
    end
    fwin:close(unionDuplicateWindow)
end