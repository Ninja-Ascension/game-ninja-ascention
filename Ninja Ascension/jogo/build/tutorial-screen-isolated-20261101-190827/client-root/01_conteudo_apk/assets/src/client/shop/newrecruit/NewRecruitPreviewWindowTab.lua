--------------------------------------------------------------------------------------------------------------
--  招募奖励预览
--------------------------------------------------------------------------------------------------------------
NewRecruitPreviewWindowTab = class("NewRecruitPreviewWindowTabClass", Window)

--打开界面
local new_recruit_preview_window_tab_open_terminal = {
    _name = "new_recruit_preview_window_tab_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = fwin:open(NewRecruitPreviewWindowTab:new():init(params), fwin._ui)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(new_recruit_preview_window_tab_open_terminal)
state_machine.init()

function NewRecruitPreviewWindowTab:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._cell_group = {}
    self._cell_size = nil
    self._scroll_view = nil
    self._scroll_view_posy = 0

    self.rewardInfo = {}        -- 存放奖励内容
    self.curPage = 1            -- 当前页数
    self.weight = 0             -- 总权重

    -- app.load("client.l_digital.cells.shop.new_recruit_preview_window_ship_cell")
    -- app.load("client.l_digital.cells.shop.new_recruit_preview_window_prop_cell")
    -- app.load("client.l_digital.shop.SmRecruitPreviewWindowTab_One")
    app.load("client.shop.newrecruit.NewRecruitPreviewWindowTabCell")
    
    -- 初始化状态机
    local function init_new_recruit_preview_window_tab_terminal()
        local new_recruit_preview_window_tab_show_terminal = {
            _name = "new_recruit_preview_window_tab_show",
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

        local new_recruit_preview_window_tab_hide_terminal = {
            _name = "new_recruit_preview_window_tab_hide",
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
                    -- local ScrollView_yulan_1 = ccui.Helper:seekWidgetByName(root,"ScrollView_1")
                    -- ScrollView_yulan_1:removeAllChildren(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

     
        state_machine.add(new_recruit_preview_window_tab_hide_terminal)
        state_machine.add(new_recruit_preview_window_tab_show_terminal)
        state_machine.init()
    end
    
    init_new_recruit_preview_window_tab_terminal()
end

function NewRecruitPreviewWindowTab:updateDraw()
    local root = self.roots[1]

    local ScrollView_yulan_1 = ccui.Helper:seekWidgetByName(root,"ScrollView_1")
    ScrollView_yulan_1:removeAllChildren(true)

    local cell_size = nil
    local cell_group = {}

    for k, v in pairs(self.rewardInfo) do
        local cell = nil
        local cell = state_machine.excute("new_recruit_preview_window_tab_cell_create", 0, {k, v, self.weight})
        ScrollView_yulan_1:addChild(cell)
        table.insert(cell_group, cell)

        if cell_size == nil then
            cell_size = cell:getContentSize()
        end
    end

    local width = ScrollView_yulan_1:getContentSize().width
    local height = ScrollView_yulan_1:getContentSize().height
    local count = #self.rewardInfo
    local row_count = 3
    -- if self._prop_type >= 5 then
    --     row_count = 5
    -- end
    local col_count = math.ceil(count / row_count)
    if count > 0 then
        if cell_size.height * col_count > height then
            height = cell_size.height * col_count
            -- if self._prop_type >= 5 then
                
            -- else
            --     height = cell_size.height * (col_count +1)
            -- end
        end
        -- 进行scrollView的绘制
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

function NewRecruitPreviewWindowTab:getRecruitRewards()
    local type = 0
    if self.curPage == 1 then
        type = 2
    elseif self.curPage == 2 then
        type = 4
    elseif self.curPage == 3 then
        type = 5
    end
    local allInfo = dms.searchs(dms["new_draw_card_library_group"], new_draw_card_library_group.type, type)
    self.weight = 0
    for i, v in ipairs(allInfo) do
        local tempInfo = {}
        tempInfo.type = dms.atoi(v, new_draw_card_library_group.type)
        tempInfo.rewardInfo = v[new_draw_card_library_group.reward]
        tempInfo.weight = dms.atoi(v, new_draw_card_library_group.weight)
        self.rewardInfo[i] = tempInfo
        self.weight = self.weight + tempInfo.weight
    end
end

function NewRecruitPreviewWindowTab:onUpdate(dt)
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
function NewRecruitPreviewWindowTab:onInit()
    local csbItem = csb.createNode("shop/new_recruit_preview_tab.csb") 
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 
    self:getRecruitRewards()
    self:updateDraw()
end

function NewRecruitPreviewWindowTab:onEnterTransitionFinish()
end

function NewRecruitPreviewWindowTab:init(params)
    self._rootWindows = params[1]
    self.curPage = params[2]
    self:onInit()
    return self
end

function NewRecruitPreviewWindowTab:onExit()
    -- 移除状态机
end