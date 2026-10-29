-----------------------------
--任务完成获得奖励界面
-----------------------------
TaskFinish = class("TaskFinishClass", Window)

local task_finish_window_open_terminal = {
    _name = "task_finish_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TaskFinishClass"))
        fwin:close(fwin:find("TaskClass"))
        local task_info = params[1]
        local reward_data = params[2]
        if reward_data == nil then
            return
        end
        -- 任务完成界面动画资源加载
        for i, v in pairs(config_res.armatures_cached["task_finish"]) do
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(v)
        end
        for i, v in pairs(config_res.armatures_cached["effice_reward"]) do
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(v)
        end
        fwin:open(TaskFinish:new():init(task_info, reward_data), fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local task_finish_window_close_terminal = {
    _name = "task_finish_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TaskFinishClass"))
		if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
			if _ED.last_level ~= _ED.user_info.user_grade then
				if zstring.tonumber(_ED.last_level) <= 6 and zstring.tonumber(_ED.last_level)~=0 then
					local UpLArmature = ccs.Armature:create("effice_zhangmenshengji")
					UpLArmature:getAnimation():playWithIndex(0)
					local size = fwin._dialog._layer:getContentSize()
					UpLArmature:setPosition(cc.p((fwin._width - app.baseOffsetX) / 2,(fwin._height - app.baseOffsetY) / 2))
					fwin._dialog._layer:addChild(UpLArmature)
					_ED.last_level = "0"
				end
			end
		end	
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(task_finish_window_open_terminal)
state_machine.add(task_finish_window_close_terminal)
state_machine.init()

function TaskFinish:ctor()
    self.super:ctor()
    self.roots = {}

    self.task_info = nil
    self.reward_data = nil
    self.prop_numbers = nil
    self.scroll_view = nil
    self.scroll_view_poy = nil

    self.table_panels = {}

    local function init_task_finish_terminal()
        --确定
        local task_finish_comfirm_terminal = {
            _name = "task_finish_comfirm",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local task_id = instance.task_info.task_id
                local task_mould_id = instance.task_info.task_mould_id
                local item_value = instance._item_value
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    end
                end
                protocol_command.get_task_reward.param_list = task_id.."\r\n"..task_mould_id
                state_machine.excute("task_finish_window_close", 0, "")
                if fwin:find("DuplicateTitleClass") ~= nil then
                    state_machine.excute("duplicate_title_play_animation",0,{item_value})
                else
                    state_machine.excute("player_resource_play_animation",0,{item_value})
                end
                NetworkManager:register(protocol_command.get_task_reward.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(task_finish_comfirm_terminal)
        state_machine.init()
    end
    
    init_task_finish_terminal()
end

function TaskFinish:onUpdateDraw()
    local root = self.roots[1]
    -- debug.print_r(self.reward_data)
    local ScrollView_reward_obtain_receive = ccui.Helper:seekWidgetByName(root,"ScrollView_reward_obtain_receive")
    ScrollView_reward_obtain_receive:removeAllChildren(true)
    local width = ScrollView_reward_obtain_receive:getContentSize().width
    local height = ScrollView_reward_obtain_receive:getContentSize().height
    local scroll_height = 0
    local col_all = 0
    if self.prop_numbers % 4 == 0 then
        scroll_height = self.prop_numbers / 4
    else
        scroll_height = math.floor(self.prop_numbers / 4) + 1
    end
    col_all = scroll_height
    local csbItem = csb.createNode("cells/packs/resource_1.csb")
    local root_temp = csbItem:getChildByName("root")
    local cell_height = root_temp:getContentSize().height + 35
    local cell_width = root_temp:getContentSize().width

    if scroll_height*cell_height > height then
        height = scroll_height*cell_height
    end

    for i,v in pairs(self.reward_data.show_reward_list) do
        local wight_n = 1
        local height_n = 1
        if i % 4 == 0 then
            wight_n = 4
        else
            wight_n = i % 4
        end

        if i % 4 == 0 then
            height_n = i / 4
        else
            height_n = math.floor(i / 4) + 1
        end
        local cell = nil
        local panel = ccui.Layout:create()
        if tonumber(v.prop_type) == 6 then    
            if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.change_of_equipment))> 0 
                or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.use_of_ship)) > 0  then
                cell = state_machine.excute("all_resource_create_cell",0,{3,v,v,1,0,true,true})
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,0,true,true})
            end  
        elseif tonumber(v.prop_type) == 34 then    
            cell = state_machine.excute("all_resource_create_cell",0,{5,v,v,1,0,true,true})
        elseif tonumber(v.prop_type) == 35 then    
            cell = state_machine.excute("all_resource_create_cell",0,{6,v,v,1,0,true,true})  
        elseif tonumber(v.prop_type) == 36 then    
            cell = state_machine.excute("all_resource_create_cell",0,{5,v,v,1,0,true,true})   
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,0,true,true})
        end
        table.insert(self.table_panels,panel)
        panel:setVisible(false)
        cell:setVisible(false)
        panel:setAnchorPoint(cc.p(0.5,0.5))
        panel:setContentSize(cell:getContentSize())
        panel:setPosition(cc.p((wight_n-1)*(width/4)+panel:getContentSize().width/2+30,height - (height_n-1)*cell_height-panel:getContentSize().height/2))
        panel.cell = cell
        panel:addChild(cell)
        ScrollView_reward_obtain_receive:addChild(panel)
    end

    ScrollView_reward_obtain_receive:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_reward_obtain_receive:jumpToTop()

    self.scroll_view = ScrollView_reward_obtain_receive
    self.scroll_view_poy = ScrollView_reward_obtain_receive:getInnerContainer():getPositionY()
end

function TaskFinish:onUpdateDrawAtion()
    local root = self.roots[1]
    local ScrollView_reward_obtain_receive = ccui.Helper:seekWidgetByName(root,"ScrollView_reward_obtain_receive")

    local cells_numbers = #self.table_panels

    local col_all = 0
    if cells_numbers % 4 == 0 then
        col_all = cells_numbers / 4
    else
        col_all = math.floor(cells_numbers / 4) + 1
    end
    
    local function scroll_action( )
        if cells_numbers > 8 then
            ScrollView_reward_obtain_receive:scrollToBottom(col_all*0.3,true)
        end
    end 
    local delay_time = 0.05
    local function playActions( )
        for i,panel in pairs(self.table_panels) do
            if i < 9 then
                local armature = ccs.Armature:create("effice_reward")
                armature:setPosition(cc.p(panel:getPositionX(), panel:getPositionY()))
                armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)  
                ScrollView_reward_obtain_receive:addChild(armature)
                armature:setVisible(false)
                
                local function playAnimation()
                    armature:setVisible(true)
                    armature:getAnimation():playWithIndex(0,0,0)
                    
                    panel:setScale(0.8)
                    panel:setOpacity(200)
                    panel:setVisible(true)
                    
                end
                local play_time = delay_time*math.random(1,cells_numbers)
                if i == 1 then
                    play_time = delay_time*cells_numbers
                end
                local action_show = cc.Sequence:create(cc.DelayTime:create(play_time),cc.CallFunc:create(playAnimation))
                self:runAction(action_show)
            end
        end
        for i,panel in pairs(self.table_panels) do
            if i < 9 then
                local function panelCellShow()
                    panel.cell:setVisible(true)
                end
                local function removeOpacity()
                    panel:setOpacity(255)
                end
                panel:runAction(
                                    cc.Sequence:create(
                                        cc.DelayTime:create(delay_time*cells_numbers+i*0.06),
                                        cc.CallFunc:create(panelCellShow),
                                        cc.ScaleTo:create(0.1,1),
                                        cc.ScaleTo:create(0.05,1.05),
                                        cc.ScaleTo:create(0.05,1),
                                        cc.CallFunc:create(removeOpacity)
                                    )
                                )
            end
        end
    end

    local function showCells( )
        for i,v in pairs(self.table_panels) do
            v:setVisible(true)
            v.cell:setVisible(true)
        end
    end

    local action = cc.Sequence:create(cc.CallFunc:create(playActions),cc.DelayTime:create(cells_numbers*delay_time + 0.2),cc.CallFunc:create(showCells),cc.DelayTime:create(0.5),cc.CallFunc:create(scroll_action))
    self:runAction(action)
end

function TaskFinish:onUpdate(dt) 
    if self.scroll_view ~= nil then
        local size = self.scroll_view:getContentSize()
        local posY = self.scroll_view:getInnerContainer():getPositionY()
        if self.scroll_view_poy == posY then
            return
        end
        self.scroll_view_poy = posY
        local items = self.scroll_view:getChildren()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                if v.cell ~= nil and v.cell.unload ~= nil then
                    v.cell:unload()
                end
            else
                if v.cell ~= nil and v.cell.reload ~= nil then
                    v.cell:reload()
                end
            end
        end
    end
end

--剔除不要的显示
function TaskFinish:getClearData()
    self.prop_numbers = 0
    local result = {}
    result.show_reward_list = {}
    for i,v in pairs(self.reward_data.show_reward_list) do
        if tonumber(v.prop_type) ~= 19 then --日常积分
            table.insert(result.show_reward_list,v)
            self.prop_numbers = self.prop_numbers  + 1
        end
    end 
    return result
end

function TaskFinish:onEnterTransitionFinish()

end

function TaskFinish:onUpdateDrawOne()
    local root = self.roots[1]
    local ScrollView_reward_obtain_receive = ccui.Helper:seekWidgetByName(root,"ScrollView_reward_obtain_receive")
    ScrollView_reward_obtain_receive:removeAllChildren(true)
    local width = ScrollView_reward_obtain_receive:getContentSize().width
    local height = ScrollView_reward_obtain_receive:getContentSize().height
    local csbItem = csb.createNode("cells/packs/resource_1.csb")
    local root_temp = csbItem:getChildByName("root")
    local cell_height = root_temp:getContentSize().height + 35
    local cell_width = root_temp:getContentSize().width

    for i,v in pairs(self.reward_data.show_reward_list) do
        local cell = nil
        local panel = ccui.Layout:create()
        if tonumber(v.prop_type) == 6 then    
            if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.change_of_equipment))> 0 
                or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.use_of_ship)) > 0  then
                cell = state_machine.excute("all_resource_create_cell",0,{3,v,v,1,0,true,true})
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,0,true,true})
            end  
        elseif tonumber(v.prop_type) == 34 then    
            cell = state_machine.excute("all_resource_create_cell",0,{5,v,v,1,0,true,true})
        elseif tonumber(v.prop_type) == 35 then    
            cell = state_machine.excute("all_resource_create_cell",0,{6,v,v,1,0,true,true})  
        elseif tonumber(v.prop_type) == 36 then    
            cell = state_machine.excute("all_resource_create_cell",0,{5,v,v,1,0,true,true})   
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,0,true,true})
        end
        table.insert(self.table_panels,panel)
        panel:setVisible(false)
        panel:setAnchorPoint(cc.p(0.5,0.5))
        panel:setContentSize(cell:getContentSize())
        -- panel:setPosition(cc.p((wight_n-1)*(width/4)+panel:getContentSize().width/2+30,height - (height_n-1)*cell_height-panel:getContentSize().height/2))
        panel:setPosition(cc.p(width/2,height - cell_height))
        panel.cell = cell
        panel:addChild(cell)
        ScrollView_reward_obtain_receive:addChild(panel)      
    end
end

function TaskFinish:onUpdateDrawTwo()
    local root = self.roots[1]
    local ScrollView_reward_obtain_receive = ccui.Helper:seekWidgetByName(root,"ScrollView_reward_obtain_receive")
    ScrollView_reward_obtain_receive:removeAllChildren(true)
    local width = ScrollView_reward_obtain_receive:getContentSize().width
    local height = ScrollView_reward_obtain_receive:getContentSize().height
    local csbItem = csb.createNode("cells/packs/resource_1.csb")
    local root_temp = csbItem:getChildByName("root")
    local cell_height = root_temp:getContentSize().height + 35
    local cell_width = root_temp:getContentSize().width

    for i,v in pairs(self.reward_data.show_reward_list) do
        local cell = nil
        local panel = ccui.Layout:create()
        if tonumber(v.prop_type) == 6 then    
            if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.change_of_equipment))> 0 
                or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.use_of_ship)) > 0  then
                cell = state_machine.excute("all_resource_create_cell",0,{3,v,v,1,0,true,true})
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,0,true,true})
            end  
        elseif tonumber(v.prop_type) == 34 then    
            cell = state_machine.excute("all_resource_create_cell",0,{5,v,v,1,0,true,true})
        elseif tonumber(v.prop_type) == 35 then    
            cell = state_machine.excute("all_resource_create_cell",0,{6,v,v,1,0,true,true})  
        elseif tonumber(v.prop_type) == 36 then    
            cell = state_machine.excute("all_resource_create_cell",0,{5,v,v,1,0,true,true})   
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,0,true,true})
        end
        table.insert(self.table_panels,panel)
        panel:setVisible(false)
        panel:setAnchorPoint(cc.p(0.5,0.5))
        panel:setContentSize(cell:getContentSize())
       
        if i == 1 then
            panel:setPosition(cc.p(width/2 - cell_width ,height - cell_height))
        elseif i == 2 then
            panel:setPosition(cc.p(width/2 + cell_width ,height - cell_height))
        end
        panel.cell = cell
        panel:addChild(cell)
        ScrollView_reward_obtain_receive:addChild(panel)     
    end
end

function TaskFinish:onUpdateDrawThree()
    local root = self.roots[1]
    local ScrollView_reward_obtain_receive = ccui.Helper:seekWidgetByName(root,"ScrollView_reward_obtain_receive")
    ScrollView_reward_obtain_receive:removeAllChildren(true)
    local width = ScrollView_reward_obtain_receive:getContentSize().width
    local height = ScrollView_reward_obtain_receive:getContentSize().height
    local csbItem = csb.createNode("cells/packs/resource_1.csb")
    local root_temp = csbItem:getChildByName("root")
    local cell_height = root_temp:getContentSize().height + 35
    local cell_width = root_temp:getContentSize().width

    for i,v in pairs(self.reward_data.show_reward_list) do
        local cell = nil
        local panel = ccui.Layout:create()
        if tonumber(v.prop_type) == 6 then    
            if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.change_of_equipment))> 0 
                or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.use_of_ship)) > 0  then
                cell = state_machine.excute("all_resource_create_cell",0,{3,v,v,1,0,true,true})
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,0,true,true})
            end  
        elseif tonumber(v.prop_type) == 34 then    
            cell = state_machine.excute("all_resource_create_cell",0,{5,v,v,1,0,true,true})
        elseif tonumber(v.prop_type) == 35 then    
            cell = state_machine.excute("all_resource_create_cell",0,{6,v,v,1,0,true,true})  
        elseif tonumber(v.prop_type) == 36 then    
            cell = state_machine.excute("all_resource_create_cell",0,{5,v,v,1,0,true,true})   
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,0,true,true})
        end
        table.insert(self.table_panels,panel)
        panel:setVisible(false)
        panel:setAnchorPoint(cc.p(0.5,0.5))
        panel:setContentSize(cell:getContentSize())
        panel:setPosition(cc.p(i*(width/3) - cell_width,height - cell_height))
        panel.cell = cell
        panel:addChild(cell)
        ScrollView_reward_obtain_receive:addChild(panel) 
    end

end

function TaskFinish:onUpdateDrawFour()
    local root = self.roots[1]
    local ScrollView_reward_obtain_receive = ccui.Helper:seekWidgetByName(root,"ScrollView_reward_obtain_receive")
    ScrollView_reward_obtain_receive:removeAllChildren(true)
    local width = ScrollView_reward_obtain_receive:getContentSize().width
    local height = ScrollView_reward_obtain_receive:getContentSize().height
    local scroll_height = 0
    local col_number = 2
    if self.prop_numbers % col_number == 0 then
        scroll_height = self.prop_numbers / col_number
    else
        scroll_height = math.floor(self.prop_numbers / col_number) + 1
    end

    local csbItem = csb.createNode("cells/packs/resource_1.csb")
    local root_temp = csbItem:getChildByName("root")
    local cell_height = root_temp:getContentSize().height + 35
    local cell_width = root_temp:getContentSize().width

    if scroll_height*cell_height > height then
        height = scroll_height*cell_height
    end

    for i,v in pairs(self.reward_data.show_reward_list) do
        local cell = nil
        local panel = ccui.Layout:create()
        if tonumber(v.prop_type) == 6 then    
            if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.change_of_equipment))> 0 
                or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.use_of_ship)) > 0  then
                cell = state_machine.excute("all_resource_create_cell",0,{3,v,v,1,0,true,true})
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,0,true,true})
            end  
        elseif tonumber(v.prop_type) == 34 then    
            cell = state_machine.excute("all_resource_create_cell",0,{5,v,v,1,0,true,true})
        elseif tonumber(v.prop_type) == 35 then    
            cell = state_machine.excute("all_resource_create_cell",0,{6,v,v,1,0,true,true})  
        elseif tonumber(v.prop_type) == 36 then    
            cell = state_machine.excute("all_resource_create_cell",0,{5,v,v,1,0,true,true})   
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,0,true,true})
        end
        table.insert(self.table_panels,panel)
        panel:setVisible(false)
        panel:setAnchorPoint(cc.p(0.5,0.5))
        panel:setContentSize(cell:getContentSize())
        if i == 1 then
            panel:setPosition(cc.p(width/2 - cell_width ,height - cell_height/2))
        elseif i == 2 then
            panel:setPosition(cc.p(width/2 + cell_width ,height - cell_height/2))
        elseif i == 3 then
            panel:setPosition(cc.p(width/2 - cell_width ,height - cell_height/2 - cell_height))
        elseif i == 4 then
            panel:setPosition(cc.p(width/2 + cell_width ,height - cell_height/2 - cell_height))
        end
        panel.cell = cell
        panel:addChild(cell)
        ScrollView_reward_obtain_receive:addChild(panel)     
    end
end

function TaskFinish:onInit( )
    local csbItem = csb.createNode(config_csb.activity.dailytasks.task_finish)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_reward_obtain_receive"), nil, 
    {
        terminal_name = "task_finish_comfirm", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    local ScrollView_reward_obtain_receive = ccui.Helper:seekWidgetByName(root,"ScrollView_reward_obtain_receive")
    self.scroll_view = ScrollView_reward_obtain_receive
    if self.prop_numbers == 1 then
        self:onUpdateDrawOne()
    elseif self.prop_numbers == 2 then
        self:onUpdateDrawTwo()
    elseif self.prop_numbers == 3 then
        self:onUpdateDrawThree()
    elseif self.prop_numbers == 4 then
        self:onUpdateDrawFour()
    elseif self.prop_numbers > 4 then
	    self:onUpdateDraw()
    end

    self:onUpdateDrawAtion()
end

function TaskFinish:init(task_info, reward_data)
    self.task_info = task_info
    self.reward_data = reward_data
    self._item_value = 0 
    for k,v in pairs(self.reward_data.show_reward_list) do
        if tonumber(v.prop_type) == 2 then 
            self._item_value = v.item_value
        end
    end
    self.reward_data = self:getClearData()
	self:onInit()
    return self
end

function TaskFinish:close()
    self.scroll_view:removeAllChildren(true)
end

function TaskFinish:onExit()
    self:stopAllActions()
    state_machine.remove("task_finish_comfirm")
end

function TaskFinish:onUpdate(dt)
    local TuitionController = fwin:find("TuitionControllerClass")
    if TuitionController ~= nil and TuitionController:isVisible() == true then
        TuitionController:setVisible(false)
        TuitionController:unregisterOnNoteUpdate(TuitionController)
    end
    if fwin:find("WindowLockClass") ~= nil and fwin:find("WindowLockClass"):isVisible() == true then
        fwin:find("WindowLockClass"):setVisible(false)
    end
    if fwin:find("RoleDialogueClass") ~= nil and fwin:find("RoleDialogueClass"):isVisible() == true then
        fwin:find("RoleDialogueClass"):setVisible(false)
    end
end

function TaskFinish:destroy()
    local TuitionController = fwin:find("TuitionControllerClass")
    if TuitionController ~= nil then
        TuitionController:setVisible(true)
        TuitionController:registerOnNoteUpdate(TuitionController, 0.1)
    end
    if fwin:find("WindowLockClass") ~= nil then
        fwin:find("WindowLockClass"):setVisible(true)
    end
    if fwin:find("RoleDialogueClass") ~= nil then
        fwin:find("RoleDialogueClass"):setVisible(true)
    end
end
