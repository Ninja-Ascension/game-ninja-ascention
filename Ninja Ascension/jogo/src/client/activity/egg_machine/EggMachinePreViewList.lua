--------------------------------------------------------------------------------------------------------------
--  招募奖励预览
--------------------------------------------------------------------------------------------------------------
EggMachinePreViewList = class("EggMachinePreViewListClass", Window)

--打开界面
local egg_machine_preview_list_open_terminal = {
    _name = "egg_machine_preview_list_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = fwin:open(EggMachinePreViewList:new():init(params), fwin._ui)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(egg_machine_preview_list_open_terminal)
state_machine.init()

function EggMachinePreViewList:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._cell_group = {}
    self._cell_size = nil
    self._scroll_view = nil
    self._scroll_view_posy = 0

    app.load("client.l_digital.cells.shop.sm_recruit_preview_window_ship_cell")
    app.load("client.l_digital.cells.shop.sm_recruit_preview_window_prop_cell")
    app.load("client.l_digital.shop.SmRecruitPreviewWindowTab_One")
    
    -- 初始化状态机
    local function init_egg_machine_preview_list_terminal()
        local egg_machine_preview_list_show_terminal = {
            _name = "egg_machine_preview_list_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local panel = params
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    panel:setVisible(true)
                    panel:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local egg_machine_preview_list_hide_terminal = {
            _name = "egg_machine_preview_list_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local panel = params
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    panel:setVisible(false)
                    local root = panel.roots[1]
                    local ScrollView_yulan_1 = ccui.Helper:seekWidgetByName(root,"ScrollView_yulan_1")
                    ScrollView_yulan_1:removeAllChildren(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local egg_machine_preview_list_update_draw_terminal = {
            _name = "egg_machine_preview_list_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local panel = params
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    panel:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(egg_machine_preview_list_update_draw_terminal)
        state_machine.add(egg_machine_preview_list_hide_terminal)
        state_machine.add(egg_machine_preview_list_show_terminal)
        state_machine.init()
    end
    
    init_egg_machine_preview_list_terminal()
end

function EggMachinePreViewList:updateDraw()
    local root = self.roots[1]

    local ScrollView_yulan_1 = ccui.Helper:seekWidgetByName(root,"ScrollView_yulan_1")
    ScrollView_yulan_1:removeAllChildren(true)

    local cell_size = nil
    local cell_group = {}

    for k, v in pairs(self._rewards) do
        local cell = nil
        cell = state_machine.excute("sm_recruit_preview_window_prop_cell_create", 0, {k, v})
        ScrollView_yulan_1:addChild(cell)
        table.insert(cell_group, cell)

        if cell_size == nil then
            cell_size = cell:getContentSize()
        end
    end

    local width = ScrollView_yulan_1:getContentSize().width
    local height = ScrollView_yulan_1:getContentSize().height
    local count = #self._rewards
    local row_count = 4
    if self._prop_type >= 5 then
        row_count = 5
    end
    local col_count = math.ceil(count / row_count)
    if count > 0 then
        if cell_size.height * col_count > height then
            if self._prop_type >= 5 then
                height = cell_size.height * col_count
            else
                height = cell_size.height * (col_count +1)
            end
        end
        ScrollView_yulan_1:getInnerContainer():setContentSize(cc.size(width, height + 15))
        for i = 1, count do
            local row = 0
            local col = 0
            local cell = nil
            row = math.floor((i - 1) % row_count)
            col = math.floor((i - 1) / row_count)
            cell = cell_group[i]
            cell:setAnchorPoint(cc.p(0,1))
            cell:setPosition(cc.p(row * (width / row_count), height - col * cell_size.height))
        end
    end

    ScrollView_yulan_1:jumpToTop()

    self._scroll_view = ScrollView_yulan_1
    self._scroll_view_posy = self._scroll_view:getInnerContainer():getPositionY()
    self._cell_group = cell_group
    self._cell_size = cell_size
end

function EggMachinePreViewList:onUpdate(dt)
    if self._scroll_view ~= nil then
        local posY = self._scroll_view:getInnerContainer():getPositionY()
        if posY == self._scroll_view_posy then
            return
        end
        self._scroll_view_posy = posY

        local size = self._scroll_view:getContentSize()
        local items = self._cell_group
        local itemSize = self._cell_size
        for i, v in pairs(items) do
            if v ~= nil and tolua.isnull(v) == false then
                if v ~= nil then
                    local tempY = v:getPositionY() + posY
                    if tempY + itemSize.height < 0 or tempY > size.height + itemSize.height then
                        v:unload()
                    else
                        v:reload()
                    end
                end
            end
        end
    end
end

--初始化
function EggMachinePreViewList:onInit()
    local csbItem = csb.createNode("shop/sm_recruit_preview_window_tab_1.csb") 
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)  

    self:updateDraw()
end

function EggMachinePreViewList:onEnterTransitionFinish()

end

function EggMachinePreViewList:init(params)
    self._rootWindows = params[1]
    self._from_type = params[2]         -- 1:金币奖励预览，2：钻石奖励预览，3：装备宝箱
    self._prop_type = params[3]         -- 道具类型：1-4：数码兽，5,6：装备、道具,7：装备,8:道具
    self._rewards = params[4]       -- 
    self:onInit()
    return self
end

function EggMachinePreViewList:onExit()
    -- 移除状态机
end