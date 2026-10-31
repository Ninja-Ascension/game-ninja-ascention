-----------------------------
--无双试炼通关成功
-----------------------------
TrialtowerPassReward = class("TrialtowerPassRewardClass", Window)


local trialtower_pass_reward_window_open_terminal = {
    _name = "trialtower_pass_reward_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)     
        if nil == fwin:find("TrialtowerPassRewardClass") then
            local reward_type = params[1]
            local reward_data = nil
            if reward_type == nil then
                reward_data = params[2]
            else
                reward_data = getSceneReward(reward_type)
            end
            if reward_data == nil then
                return
            end

            if #reward_data.show_reward_list == 0 then
                return
            end
            fwin:open(TrialtowerPassReward:new():init(reward_data), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local trialtower_pass_reward_window_close_terminal = {
    _name = "trialtower_pass_reward_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TrialtowerPassRewardClass"))
        state_machine.excute("trialtower_hero_go_out",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(trialtower_pass_reward_window_open_terminal)
state_machine.add(trialtower_pass_reward_window_close_terminal)
state_machine.init()

function TrialtowerPassReward:ctor()
    self.super:ctor()
    self.roots = {}

    --var
    --奖励获得数据
    self.reward_data = nil
    self.prop_numbers = nil
    self.scroll_view = nil
    self.scroll_view_poy = nil

    self.table_panels = {}
    -- Initialize racecourse_pack state machine.
    local function init_trialtower_pass_reward_terminal()

    end
    -- call func init hom state machine.
    init_trialtower_pass_reward_terminal()
end 

function TrialtowerPassReward:playBoxAnimations()
    local root = self.roots[1]
    local Button_sure = ccui.Helper:seekWidgetByName(root, "Button_sure")
    Button_sure:setVisible(false)
    --通关成功
    local Panel_pass = ccui.Helper:seekWidgetByName(root, "Panel_pass")
    local ArmatureNode_2 = Panel_pass:getChildByName("ArmatureNode_2")
    local animation_2 = ArmatureNode_2:getAnimation()
    --顶部宝箱放大动画
    local Panel_reward = ccui.Helper:seekWidgetByName(root, "Panel_reward")
    local ArmatureNode_3 = Panel_reward:getChildByName("ArmatureNode_3")
    local animation_3 = ArmatureNode_3:getAnimation()
    Panel_reward:setVisible(false)
    --顶部宝箱循环动画
    local Panel_reward_on = ccui.Helper:seekWidgetByName(root, "Panel_reward_on")
    Panel_reward_on:setVisible(false)
    local ArmatureNode_4 = Panel_reward_on:getChildByName("ArmatureNode_4")
    local animation_4 = ArmatureNode_4:getAnimation()

    draw.initArmature(ArmatureNode_2, nil, -1, 0, 1)
    ArmatureNode_2._invoke = function(armatureBack)
        Panel_reward:setVisible(true)
        csb.animationChangeToAction(ArmatureNode_3, 0, 0, false)
        ArmatureNode_2._invoke = nil            
    end

    draw.initArmature(ArmatureNode_3, nil, -1, 0, 1)
    ArmatureNode_3._invoke = function(armatureBack)
        Panel_reward_on:setVisible(true)
        self:onUpdateDrawAtion()
        Button_sure:setVisible(true)
        Button_sure:setOpacity(0)
        Button_sure:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.FadeIn:create(1)))
        ArmatureNode_3._invoke = nil            
    end
    csb.animationChangeToAction(ArmatureNode_2, 0, 0, false)
    
end

function TrialtowerPassReward:onUpdateDraw()
    local root = self.roots[1]
    -- debug.print_r(self.reward_data)
    local ScrollView_1 = ccui.Helper:seekWidgetByName(root,"ScrollView_1")
    ScrollView_1:removeAllChildren(true)
    local width = ScrollView_1:getContentSize().width
    local height = ScrollView_1:getContentSize().height
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
        ScrollView_1:addChild(panel)
    end

    ScrollView_1:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_1:jumpToTop()

    self.scroll_view = ScrollView_1
    self.scroll_view_poy = ScrollView_1:getInnerContainer():getPositionY()


end

function TrialtowerPassReward:onUpdateDrawAtion()
    local root = self.roots[1]
    local ScrollView_1 = ccui.Helper:seekWidgetByName(root,"ScrollView_1")

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
            ScrollView_1:scrollToBottom(col_all*0.3,true)
        end
    end 
    local delay_time = 0.05
    local function playActions( )
        for i,panel in pairs(self.table_panels) do
            if i < 9 then
                local armature = ccs.Armature:create("effice_reward")
                armature:setPosition(cc.p(panel:getPositionX(), panel:getPositionY()))
                armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)  
                ScrollView_1:addChild(armature)
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

function TrialtowerPassReward:onUpdate(dt) 
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
                if v.unload ~= nil then
                    v:unload()
                end
            else
                if v.reload ~= nil then
                    v:reload()
                end
            end
        end
    end
end

--剔除不要的显示
function TrialtowerPassReward:getClearData()
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

function TrialtowerPassReward:onUpdateDrawOne()
    local root = self.roots[1]
    local ScrollView_1 = ccui.Helper:seekWidgetByName(root,"ScrollView_1")
    ScrollView_1:removeAllChildren(true)
    local width = ScrollView_1:getContentSize().width
    local height = ScrollView_1:getContentSize().height
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
        ScrollView_1:addChild(panel)      
    end
end

function TrialtowerPassReward:onUpdateDrawTwo()
    local root = self.roots[1]
    local ScrollView_1 = ccui.Helper:seekWidgetByName(root,"ScrollView_1")
    ScrollView_1:removeAllChildren(true)
    local width = ScrollView_1:getContentSize().width
    local height = ScrollView_1:getContentSize().height
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
        ScrollView_1:addChild(panel)     
    end
end

function TrialtowerPassReward:onUpdateDrawThree()
    local root = self.roots[1]
    local ScrollView_1 = ccui.Helper:seekWidgetByName(root,"ScrollView_1")
    ScrollView_1:removeAllChildren(true)
    local width = ScrollView_1:getContentSize().width
    local height = ScrollView_1:getContentSize().height
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
        ScrollView_1:addChild(panel) 
    end

end

function TrialtowerPassReward:onUpdateDrawFour()
    local root = self.roots[1]
    local ScrollView_1 = ccui.Helper:seekWidgetByName(root,"ScrollView_1")
    ScrollView_1:removeAllChildren(true)
    local width = ScrollView_1:getContentSize().width
    local height = ScrollView_1:getContentSize().height
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
        ScrollView_1:addChild(panel)     
    end
end


function TrialtowerPassReward:onInit()
    local csbItem = csb.createNode(config_csb.campaign.trialtower.trialtower_pass_reward)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_sure"), nil, 
    {
        terminal_name = "trialtower_pass_reward_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

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
    self:playBoxAnimations()
    
end

function TrialtowerPassReward:init(reward_data)
    self.reward_data = reward_data
    self.reward_data = self:getClearData()
    self:onInit()
    return self
end

function TrialtowerPassReward:onExit()
    self:stopAllActions()
end
