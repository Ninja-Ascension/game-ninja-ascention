-----------------------------
--将魂副本奖励获得
-----------------------------
SoulDuplicateResult = class("SoulDuplicateResultClass", Window)

local soul_duplicate_result_window_open_terminal = {
    _name = "soul_duplicate_result_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("SoulDuplicateResultClass")
        if nil == _Window then
            -- debug.print_r(params)
            local  reward_type = params[1]
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
            fwin:open(SoulDuplicateResult:new():init(reward_data), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local soul_duplicate_result_window_close_terminal = {
    _name = "soul_duplicate_result_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SoulDuplicateResultClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(soul_duplicate_result_window_open_terminal)
state_machine.add(soul_duplicate_result_window_close_terminal)
state_machine.init()

function SoulDuplicateResult:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.reward_data = nil
    self.prop_numbers = nil
    self.scroll_view = nil
    self.scroll_view_poy = nil

    self._now_percent = 0
    --伤害百分比进度条
    self._loadingbar = nil
    --伤害百分比数
    self._loadingbar_num = 0
    self.table_panels = {}
    -- Initialize SoulDuplicateResult state machine.
    local function init_soul_duplicate_result_terminal()

        state_machine.init()
    end
    
    -- call func init soul_duplicate_result machine.
    init_soul_duplicate_result_terminal()
end

function SoulDuplicateResult:onUpdateDraw()
    local root = self.roots[1]
    -- debug.print_r(self.reward_data)
    local ScrollView_soul_duplicate_result = ccui.Helper:seekWidgetByName(root,"ScrollView_soul_duplicate_result")
    ScrollView_soul_duplicate_result:removeAllChildren(true)
    local width = ScrollView_soul_duplicate_result:getContentSize().width
    local height = ScrollView_soul_duplicate_result:getContentSize().height
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
                cell = state_machine.excute("all_resource_create_cell",0,{3,v,v,1,height_n,true,true,nil,3})
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,height_n,true,true,nil,3})
            end  
        elseif tonumber(v.prop_type) == 34 then    
            cell = state_machine.excute("all_resource_create_cell",0,{5,v,v,1,height_n,true,true,3})   
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,height_n,true,true,3})
        end
        table.insert(self.table_panels,panel)
        panel:setVisible(false)
        cell:setVisible(false)
        panel:setAnchorPoint(cc.p(0.5,0.5))
        panel:setContentSize(cell:getContentSize())
        panel:setPosition(cc.p((wight_n-1)*(width/4)+panel:getContentSize().width/2+30,height - (height_n-1)*cell_height-panel:getContentSize().height/2))
        panel.cell = cell
        panel:addChild(cell)
        ScrollView_soul_duplicate_result:addChild(panel)
    end

    ScrollView_soul_duplicate_result:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_soul_duplicate_result:jumpToTop()

    self.scroll_view = ScrollView_soul_duplicate_result
    self.scroll_view_poy = ScrollView_soul_duplicate_result:getInnerContainer():getPositionY()


end

function SoulDuplicateResult:onUpdateDrawAtion()
    local root = self.roots[1]
    local ScrollView_soul_duplicate_result = ccui.Helper:seekWidgetByName(root,"ScrollView_soul_duplicate_result")

    local cells_numbers = #self.table_panels
	-- 恭喜获得动画资源加载
    for i, v in pairs(config_res.armatures_cached["effice_reward"]) do
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(v)
    end

    local col_all = 0
    if cells_numbers % 4 == 0 then
        col_all = cells_numbers / 4
    else
        col_all = math.floor(cells_numbers / 4) + 1
    end
    
    local function scroll_action( )
        if cells_numbers > 8 then
            ScrollView_soul_duplicate_result:scrollToBottom(col_all*0.3,true)
        end
    end 
    local delay_time = 0.05
    local function playActions( )
        for i,panel in pairs(self.table_panels) do
            if i < 9 then
                local armature = ccs.Armature:create("effice_reward")
                armature:setPosition(cc.p(panel:getPositionX(), panel:getPositionY()))
                armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)  
                ScrollView_soul_duplicate_result:addChild(armature)
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

function SoulDuplicateResult:onUpdatepercentUp()
    local root = self.roots[1]
    --伤害百分比进度条
    local LoadingBar_harm = ccui.Helper:seekWidgetByName(root,"LoadingBar_harm")
    self._loadingbar = LoadingBar_harm
    self._loadingbar:setPercent(0)
    --伤害百分比数
    local Text_harm_v = ccui.Helper:seekWidgetByName(root,"Text_harm_v")
    self._loadingbar_num = Text_harm_v
    self._loadingbar_num:setString(self._now_percent.."%")
    -- 伤害对象
    local Panel_text_harm_to_boss = ccui.Helper:seekWidgetByName(root,"Panel_text_harm_to_boss") 
    Panel_text_harm_to_boss:removeAllChildren(true)
    local npc_name = dms.string(dms["npc"],_ED.soul_duplicate.npc_id,npc.npc_name)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)  
    local re1 = nil
    local re2 = nil
    local re3 = nil
    re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[18][1],color_Type[18][2],color_Type[18][3]),255, red_alert_all_str[155] , "fonts/simhei.ttf",22)
    _richText:pushBackElement(re1)
    re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[19][1],color_Type[19][2],color_Type[19][3]),255, npc_name, "fonts/simhei.ttf",22)
    _richText:pushBackElement(re2)
    re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[18][1],color_Type[18][2],color_Type[18][3]),255, red_alert_all_str[156], "fonts/simhei.ttf",22)
    _richText:pushBackElement(re3)
    _richText:setContentSize(cc.size(260,24))
    _richText:setAnchorPoint(cc.p(0.3,0.4))
    Panel_text_harm_to_boss:addChild(_richText)

end

function SoulDuplicateResult:percentUp()
    self._now_percent = self._now_percent + 1
    if self._now_percent > _ED.soul_duplicate.my_damage then
        return
    end
    self._loadingbar:setPercent(self._now_percent)
    self._loadingbar_num:setString(self._now_percent.."%")
end

function SoulDuplicateResult:onUpdate(dt) 
    self:percentUp()
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
function SoulDuplicateResult:getClearData()
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

function SoulDuplicateResult:onEnterTransitionFinish()

end

function SoulDuplicateResult:onUpdateDrawOne()
    local root = self.roots[1]
    local ScrollView_soul_duplicate_result = ccui.Helper:seekWidgetByName(root,"ScrollView_soul_duplicate_result")
    ScrollView_soul_duplicate_result:removeAllChildren(true)
    local width = ScrollView_soul_duplicate_result:getContentSize().width
    local height = ScrollView_soul_duplicate_result:getContentSize().height
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
        ScrollView_soul_duplicate_result:addChild(panel)      
    end
end

function SoulDuplicateResult:onUpdateDrawTwo()
    local root = self.roots[1]
    local ScrollView_soul_duplicate_result = ccui.Helper:seekWidgetByName(root,"ScrollView_soul_duplicate_result")
    ScrollView_soul_duplicate_result:removeAllChildren(true)
    local width = ScrollView_soul_duplicate_result:getContentSize().width
    local height = ScrollView_soul_duplicate_result:getContentSize().height
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
        ScrollView_soul_duplicate_result:addChild(panel)     
    end
end

function SoulDuplicateResult:onUpdateDrawThree()
    local root = self.roots[1]
    local ScrollView_soul_duplicate_result = ccui.Helper:seekWidgetByName(root,"ScrollView_soul_duplicate_result")
    ScrollView_soul_duplicate_result:removeAllChildren(true)
    local width = ScrollView_soul_duplicate_result:getContentSize().width
    local height = ScrollView_soul_duplicate_result:getContentSize().height
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
        ScrollView_soul_duplicate_result:addChild(panel) 
    end

end

function SoulDuplicateResult:onUpdateDrawFour()
    local root = self.roots[1]
    local ScrollView_soul_duplicate_result = ccui.Helper:seekWidgetByName(root,"ScrollView_soul_duplicate_result")
    ScrollView_soul_duplicate_result:removeAllChildren(true)
    local width = ScrollView_soul_duplicate_result:getContentSize().width
    local height = ScrollView_soul_duplicate_result:getContentSize().height
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
        ScrollView_soul_duplicate_result:addChild(panel)     
    end
end

function SoulDuplicateResult:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.soul_duplicate.soul_duplicate_result)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.campaign.soul_duplicate.soul_duplicate_result)
    table.insert(self.actions,action)
    csbItem:runAction(action)
    action:play("animation0", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "text_up_over" then
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
    end)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_reward_soul_duplicate_result"), nil, 
    {
        terminal_name = "soul_duplicate_result_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    
    self:onUpdatepercentUp()
end

function SoulDuplicateResult:init(reward_data)
    self.reward_data = reward_data
    self.reward_data = self:getClearData()
    self:onInit()
    return self
end

function SoulDuplicateResult:onExit()
    self:stopAllActions()
end
