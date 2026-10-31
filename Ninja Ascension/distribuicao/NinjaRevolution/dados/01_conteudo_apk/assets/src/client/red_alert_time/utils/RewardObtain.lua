-----------------------------
--奖励获得1
-----------------------------
RewardObtain = class("RewardObtainClass", Window)

local reward_obtain_window_open_terminal = {
    _name = "reward_obtain_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("RewardObtainClass")
        if nil == _Window then
            -- debug.print_r(params)
            local  reward_type = params[1]
            local reward_data = nil
            if reward_type == nil then
                reward_data = params[2]
            else
                if type(reward_type) == "table" then
                    for i, v in pairs(reward_type) do
                        local treward_data = getSceneReward(v)
                        if nil == reward_data then
                            reward_data = treward_data
                        else
                            if nil ~= treward_data then
                                for n, m in pairs(treward_data.show_reward_list) do
                                    table.insert(reward_data.show_reward_list, m)
                                end
                            end
                        end
                    end
                else
                    reward_data = getSceneReward(reward_type)
                end
            end
            if reward_data == nil then
                return
            end

            if #reward_data.show_reward_list == 0 then
                return
            end
            -- print("==================reward_type",reward_type)
            fwin:open(RewardObtain:new():init(reward_data), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local reward_obtain_window_close_terminal = {
    _name = "reward_obtain_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RewardObtainClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(reward_obtain_window_open_terminal)
state_machine.add(reward_obtain_window_close_terminal)
state_machine.init()

function RewardObtain:ctor()
    self.super:ctor()
    self.roots = {}

    self.reward_data = nil
    self.prop_numbers = nil
    self.scroll_view = nil
    self.scroll_view_poy = nil

    self.table_panels = {}
    -- Initialize RewardObtain state machine.
    local function init_reward_obtain_terminal()
        --确定
        local reward_obtain_recruit_comfirm_terminal = {
            _name = "reward_obtain_recruit_comfirm",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("reward_obtain_window_close",0,"")
                if fwin:find("RacecourseClass") ~= nil then
                    state_machine.excute("racecourse_show_panel_treasure",0,"")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(reward_obtain_recruit_comfirm_terminal)
        state_machine.init()
    end
    
    -- call func init reward_obtain machine.
    init_reward_obtain_terminal()
end

function RewardObtain:onUpdateDraw()
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

function RewardObtain:onUpdateDrawAtion()
    local root = self.roots[1]
    local ScrollView_reward_obtain_receive = ccui.Helper:seekWidgetByName(root,"ScrollView_reward_obtain_receive")

    local cells_numbers = #self.table_panels
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_reward/effice_reward.ExportJson")

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

function RewardObtain:onUpdate(dt) 
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
function RewardObtain:getClearData()
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

function RewardObtain:onEnterTransitionFinish()

end

function RewardObtain:onUpdateDrawOne()
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

function RewardObtain:onUpdateDrawTwo()
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

function RewardObtain:onUpdateDrawThree()
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

function RewardObtain:onUpdateDrawFour()
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

function RewardObtain:onInit( )
    local csbItem = csb.createNode(config_csb.utils.reward_obtain)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_reward_obtain_receive"), nil, 
    {
        terminal_name = "reward_obtain_recruit_comfirm", 
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

function RewardObtain:init(reward_data)
    self.reward_data = reward_data
    self.reward_data = self:getClearData()
	self:onInit()
    return self
end

function RewardObtain:close()
    self.scroll_view:removeAllChildren(true)
end

function RewardObtain:onExit()
    self:stopAllActions()
    state_machine.remove("reward_obtain_recruit_comfirm")
end
