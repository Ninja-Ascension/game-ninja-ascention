-- ----------------------------------------------------------------------------------------------------
-- 说明：武将仓库
-------------------------------------------------------------------------------------------------------
AdventureHeroStorage = class("AdventureHeroStorageClass", Window)
    
app.load("client.adventure.cells.prop.adventure_new_prop_small_icon_cell")
app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
app.load("client.adventure.cells.skill.adventure_skill_icon_cell")

function AdventureHeroStorage:ctor()
    self.super:ctor()
    self.roots = {}

    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    self.current_page_index = 1 --当前选中的页面

    app.load("client.adventure.cells.hero.adventure_hero_list_cell")
    app.load("client.adventure.cells.hero.adventure_hero_list_strength_cell")

    -- Initialize adventure hero storage state machine.
    local function init_adventure_hero_storage_terminal()
		-- 刷新战力
        local adventure_hero_storage_update_capacity_terminal = {
            _name = "adventure_hero_storage_update_capacity_",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.roots ~= nil and instance.roots[1] ~= nil then 
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Text_zhanli"):setString("" .. _ED.user_info.fight_capacity)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新列表升级状态
        local adventure_hero_storage_update_hero_list_up_states_terminal = {
            _name = "adventure_hero_storage_update_hero_list_up_states",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateListCellUpStates()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
         -- 刷新列表标签页
        local adventure_hero_stroage_list_manager_terminal = {
            _name = "adventure_hero_stroage_list_manager",
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
                instance:onUpdateListView(tonumber(params._datas.current_button_type))
               
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(adventure_hero_storage_update_hero_list_terminal)
		state_machine.add(adventure_hero_storage_update_capacity_terminal)
        state_machine.add(adventure_hero_storage_update_hero_list_up_states_terminal)
        state_machine.add(adventure_hero_stroage_list_manager_terminal)
        
        state_machine.init()
    end
    
    -- call func init adventure hero storage state machine.
    init_adventure_hero_storage_terminal()
end

function AdventureHeroStorage:init()
    return self
end

function AdventureHeroStorage:updateDraw(isupdate)
    local root = self.roots[1]

    if root == nil then 
        return false
    end
 -- 绘制武将列表
    
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_team")
    listView:removeAllItems()
    local nCound = #_ED.formetion
    for i = 2, nCound do
        local shipId = zstring.tonumber(_ED.formetion[i])
        if shipId > 0 then
            local cell = AdventureHeroListCell:createCell()
            cell:init(_ED.user_ship["" .. shipId],shipId, i - 1)
            listView:addChild(cell)
        end
    end
       
    if isupdate == false then 
        listView:requestRefreshView()

        self.currentListView = listView
        self.currentInnerContainer = self.currentListView:getInnerContainer()
        self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    else
        self.currentInnerContainerPosY = 10
        self:onUpdate(1)
    end
end

function AdventureHeroStorage:onUpdate(dt)
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

function AdventureHeroStorage:onUpdateListCellUpStates()
    local root = self.roots[1]

    if root == nil then 
        return false
    end
    local items = self.currentListView:getItems()
    for i,v in pairs(items) do
        v:onUpdateUpStates()
    end
end

function AdventureHeroStorage:onUpdateListView(pageIndex,isupdate)
    local root = self.roots[1]

    if root == nil then 
        return false
    end
    -- 绘制武将列表
    self.current_page_index = pageIndex
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_team")
    listView:removeAllItems()
    listView:jumpToTop()
    local nCound = #_ED.formetion
    for i = 2, nCound do
        local shipId = zstring.tonumber(_ED.formetion[i])
        if shipId > 0 then
            local cell = nil
            if pageIndex == 1 then  -- 升级
                cell = AdventureHeroListCell:createCell()
            else  --强化
                cell = AdventureHeroListStrengthCell:createCell()
            end
            
            cell:init(_ED.user_ship["" .. shipId],shipId, i - 1)
            listView:addChild(cell)
        end
    end
    
    listView:requestRefreshView()

    self.currentListView = listView
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    -- else
    --     self.currentInnerContainerPosY = 10
    --     self:onUpdate(1)
    -- end
end

function AdventureHeroStorage:onEnterTransitionFinish()
    local csbAdventureHeroStorage = csb.createNode("duplicate/Team_strengthen.csb")
    local root = csbAdventureHeroStorage:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureHeroStorage)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureHeroStorageClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    --佣兵升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shengji"),       nil, 
    {
        terminal_name = "adventure_hero_stroage_list_manager",     
        current_button_name = "Button_shengji",  
        current_button_type = 1 ,      
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)

    local qianghuaButton = ccui.Helper:seekWidgetByName(root, "Button_qianghua")
    qianghuaButton:setColor(cc.c3b(130, 130, 130))
    qianghuaButton:setHighlighted(false)
    qianghuaButton:setTouchEnabled(true)
    --佣兵强化
    fwin:addTouchEventListener(qianghuaButton,       nil, 
    {
        terminal_name = "adventure_hero_stroage_list_manager",     
        current_button_name = "Button_qianghua",  
        current_button_type = 2 ,      
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)
    state_machine.excute("adventure_hero_stroage_list_manager", 0, 
        {_datas ={
            current_button_name = "Button_shengji",        
            current_button_type = 1 ,      
            terminal_state = 0, 
            isPressedActionEnabled = true
        }}
        )

    -- 绘制总战力
    ccui.Helper:seekWidgetByName(root, "Text_zhanli"):setString("" .. _ED.user_info.fight_capacity)
    --self:updateDraw(false)
   
end

function AdventureHeroStorage:onExit()
    state_machine.remove("adventure_hero_storage_update_hero_list")
    state_machine.remove("adventure_hero_storage_update_hero_list_up_states")
    state_machine.remove("adventure_hero_stroage_list_manager")

end
