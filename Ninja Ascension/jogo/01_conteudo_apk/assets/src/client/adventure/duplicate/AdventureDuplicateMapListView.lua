-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险副本地图列表
-------------------------------------------------------------------------------------------------------
AdventureDuplicateMapListView = class("AdventureDuplicateMapListViewClass", Window)

app.load("client.adventure.cells.duplicate.adventure_duplicate_map_list_cell")
    
function AdventureDuplicateMapListView:ctor()
    self.super:ctor()
    self.roots = {}

    self.selectSceneId = -1
    
    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    self.setListViewStartPosY = 0
    self.isFirstEnter = false
    self.show_perNum = 0 

    state_machine.excute("adventure_duplicate_map_list_view_close_window", 0, 0)

    -- Initialize adventure duplicate map list view state machine.
    local function init_adventure_duplicate_map_list_view_terminal()
        -- 关闭
        local adventure_duplicate_map_list_view_close_window_terminal = {
            _name = "adventure_duplicate_map_list_view_close_window",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("AdventureDuplicateMapListViewClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_duplicate_map_list_view_close_window_terminal)
        state_machine.init()
    end
    
    -- call func init adventure duplicate map list view state machine.
    init_adventure_duplicate_map_list_view_terminal()
end

function AdventureDuplicateMapListView:init(sceneId)
    self.selectSceneId = sceneId
    self:unregisterOnNoteUpdate(self)
    return self
end

local possssY = 0
function AdventureDuplicateMapListView:initListView()
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_guanka")
    listView:removeAllItems()
    local openNum = 0
    self.setListViewStartPosY = 0
    local scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, "0")
    for i, v in pairs(scenes) do
        local cell = AdventureDuplicateMapListCell:createCell()
        cell:init(v, self.selectSceneId, i)
        self.setListViewStartPosY = self.setListViewStartPosY + AdventureDuplicateMapListCell.__size.height
        cell:unload()
        listView:addChild(cell)
        if cell:isOpened() == false then
        else
            if cell:checkCapacity() == true then
                openNum = openNum + 1
            end
        end
       
    end
    
    self.currentListView = listView

    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    if openNum > 7 then 
        self.show_perNum = openNum/ (#scenes) - 2 / (#scenes) 
    else 
        self.show_perNum = 0 
    end
    --print("打开了几个:",openNum)
    --这个地方计算坐标有问题...
    local show_pos = cc.p(0,-(1-self.show_perNum) * self.setListViewStartPosY - AdventureDuplicateMapListCell.__size.height)
    self.currentListView:getInnerContainer():setPosition(show_pos)
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
       
    self:onUpdate(1)
end

function AdventureDuplicateMapListView:onUpdate(dt)
    if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentListView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        -- if self.isFirstEnter == false then
        --     print(" ----shezhi le gaodu :",-self.setListViewStartPosY)
        --     self.currentListView:getInnerContainer():setPosition(cc.p(0,-self.setListViewStartPosY))
        --     self.isFirstEnter = true
        -- end
        
        if self.currentInnerContainerPosY == posY then
            return
        end
       -- print(" -----y:",self.currentInnerContainerPosY)
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

function AdventureDuplicateMapListView:onEnterTransitionFinish()
    local csbAdventureDuplicateMapListView = csb.createNode("duplicate/maoxian_map_1.csb")
    local root = csbAdventureDuplicateMapListView:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureDuplicateMapListView)
    self:unregisterOnNoteUpdate(self)

    -- 绘制当前场景的名称
    local scene_name = dms.string(dms["pve_scene"], self.selectSceneId, pve_scene.scene_name)
    ccui.Helper:seekWidgetByName(root, "Text_mapname"):setString(scene_name)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        -- func_string = [[fwin:close(fwin:find("AdventureDuplicateMapListViewClass"))]],    
        terminal_name = "adventure_duplicate_map_list_view_close_window",   
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    self:initListView()
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_guanka")
    --listView:setVisible(false)
    local scheduler = cc.Director:getInstance():getScheduler()  
    local schedulerID = nil  
    local  timer = 0
    schedulerID = scheduler:scheduleScriptFunc(function ()
           local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_guanka")

            listView:jumpToPercentVertical(self.show_perNum*100)

            self:registerOnNodeEvent(self)
            self:registerOnNoteUpdate(self, 0)

           cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID)
          
    end,0.15,false)
end

function AdventureDuplicateMapListView:onExit()
    state_machine.remove("adventure_duplicate_map_list_view_close_window")
end