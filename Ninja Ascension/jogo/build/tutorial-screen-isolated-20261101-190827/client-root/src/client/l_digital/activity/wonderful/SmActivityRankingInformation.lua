-----------------------------
--战力排行活动排名
-----------------------------
SmActivityRankingInformation = class("SmActivityRankingInformationClass", Window)

local sm_activity_ranking_information_window_open_terminal = {
    _name = "sm_activity_ranking_information_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmActivityRankingInformation:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_ranking_information_window_open_terminal)
state_machine.init()

function SmActivityRankingInformation:ctor()
    self.super:ctor()
    self.roots = {}
    self._list_view = nil
    self._list_view_posy = 0
    self.loaded = false
    app.load("client.l_digital.cells.activity.wonderful.sm_activity_ranking_information_cell")
    local function init_sm_activity_ranking_information_terminal()
		--显示界面
		local sm_activity_ranking_information_show_terminal = {
            _name = "sm_activity_ranking_information_show",
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
		--隐藏界面
		local sm_activity_ranking_information_hide_terminal = {
            _name = "sm_activity_ranking_information_hide",
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


		state_machine.add(sm_activity_ranking_information_show_terminal)	
		state_machine.add(sm_activity_ranking_information_hide_terminal)

        state_machine.init()
    end
    init_sm_activity_ranking_information_terminal()
end

function SmActivityRankingInformation:onHide()
    local root = self.roots[1]
    local ListView_tab_3 = ccui.Helper:seekWidgetByName(root, "ListView_tab_3")
    ListView_tab_3:jumpToTop()
    ListView_tab_3:removeAllItems()
    self:setVisible(false)
    self:stopAllActions()
end

function SmActivityRankingInformation:onShow()
    self:setVisible(true)
    self:onUpdateDraw()
end

function SmActivityRankingInformation:onUpdateDraw()
    local root = self.roots[1]
    
    --列表
    local ListView_tab_3 = ccui.Helper:seekWidgetByName(root, "ListView_tab_3")
    ListView_tab_3:removeAllItems()
    local index = 1
    for i, v in pairs(_ED.charts.force) do
        if index <= 10 then
            local cell = state_machine.excute("sm_activity_ranking_information_cell",0,{v, index})
            ListView_tab_3:addChild(cell)
            index = index + 1
        end
    end
    ListView_tab_3:requestRefreshView()
    self._list_view = ListView_tab_3
    self._list_view_posy = self._list_view:getInnerContainer():getPositionY()
end

function SmActivityRankingInformation:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_posy == posY then
            return
        end
        self._list_view_posy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height/2 < 0 or tempY > size.height + itemSize.height /2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function SmActivityRankingInformation:onEnterTransitionFinish()

end

function SmActivityRankingInformation:onInit( )
    local csbItem = csb.createNode("activity/wonderful/sm_fighting_up_tab_3.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    self:onUpdateDraw()

end

function SmActivityRankingInformation:lazy()
    if self.loaded == true then
        return
    end
    self.loaded = true
    self:onInit()
end

function SmActivityRankingInformation:unload()
    self:removeAllChildren(true)
    self.loaded = false
    self.roots = {}
end

function SmActivityRankingInformation:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmActivityRankingInformation:onExit()
    state_machine.remove("sm_activity_ranking_information_show")    
    state_machine.remove("sm_activity_ranking_information_hide")
end
