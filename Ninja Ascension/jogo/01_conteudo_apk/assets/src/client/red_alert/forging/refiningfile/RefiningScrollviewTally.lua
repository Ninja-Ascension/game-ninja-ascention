-----------------------------
--分解滚动层 -兵符
-----------------------------
RefiningScrollviewTally = class("RefiningScrollviewTallyClass", Window)

local refining_scrollview_tally_window_open_terminal = {
    _name = "refining_scrollview_tally_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("RefiningScrollviewTallyClass")
        if nil == _Window then
            fwin:open(RefiningScrollviewTally:new():init(params))
        end  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(refining_scrollview_tally_window_open_terminal)
state_machine.init()

function RefiningScrollviewTally:ctor()
    self.super:ctor()
    self.roots = {}
    self.prop_numbers = 0
    self.user_ships = {}
    -- Initialize refining_scrollview_tally state machine.
    local function init_refining_scrollview_tally_terminal()
        --显示界面
        local refining_scrollview_tally_window_show_terminal = {
            _name = "refining_scrollview_tally_window_show",
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
        local refining_scrollview_tally_window_hide_terminal = {
            _name = "refining_scrollview_tally_window_hide",
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
        --取消所有选中
        local refining_scrollview_tally_un_set_selected_terminal = {
            _name = "refining_scrollview_tally_un_set_selected",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setUnSelecet()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(refining_scrollview_tally_window_show_terminal)    
        state_machine.add(refining_scrollview_tally_window_hide_terminal)
        state_machine.add(refining_scrollview_tally_un_set_selected_terminal)
        state_machine.init()
    end
    
    -- call func init refining_scrollview_tally state machine.
    init_refining_scrollview_tally_terminal()
end

function RefiningScrollviewTally:onHide( ... )
    self:setVisible(false)
end

function RefiningScrollviewTally:onShow( ... )
    self:setVisible(true)
end

function RefiningScrollviewTally:setUnSelecet()
    local root = self.roots[1]
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_packs")
    for i,v in pairs(ScrollView_packs:getChildren()) do
        if v.selected == true and v.sesetSelected ~= nil then
            v.selected = false
            v:setSelected()
        end
    end
end

function RefiningScrollviewTally:onUpdateDraw()
    local root = self.roots[1]
    local all_row = 0
    local all_col = 0
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_packs")
    ScrollView_packs:removeAllChildren(true)
    local width = ScrollView_packs:getContentSize().width
    local height = ScrollView_packs:getContentSize().height
    local scroll_height = 0
    local index = 0
    local cell_temp = state_machine.excute("packs_icon_bg_create_cell",0,"")
    local cell_height = cell_temp:getContentSize().height
    for i = 1,10000 do
        local v = self.user_tallys[i]
        index = index + 1
        local wight_n = 1
        local height_n = 1
        if i % 4 == 0 then
            wight_n = 4
        else
            wight_n = i % 4
        end
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end
    if index % 4 == 0 then
        scroll_height = index / 4
    else
        scroll_height = math.floor(index / 4) + 1
    end

    if scroll_height*cell_height > height then
        height = scroll_height*cell_height
    end  
    for i = 1,10000 do
        local v = self.user_tallys[i] 
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
        if v == nil then
            cell = state_machine.excute("packs_icon_bg_create_cell",0,"")
        else
            cell = state_machine.excute("all_resource_create_cell",0,{7,v.prop_data,v.prop,3,height_n})
        end
        cell:setAnchorPoint(cc.p(0,1))
        -- print("============",wight_n,height_n,(wight_n-1)*(width/4),height - (height_n-1)*92)
        cell:setPosition(cc.p((wight_n-1)*(width/4),height - (height_n-1)*cell_height))
        ScrollView_packs:addChild(cell)
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end

    ScrollView_packs:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_packs:jumpToTop()  
end

function RefiningScrollviewTally:getAllData( ... )
    local result = {}
    return result
end

function RefiningScrollviewTally:onEnterTransitionFinish()

end

function RefiningScrollviewTally:onInit( )
    local csbItem = csb.createNode(config_csb.forging.forging_scrollview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw() 
end

function RefiningScrollviewTally:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.user_tallys = self:getAllData()
    self:onInit()
    return self
end

function RefiningScrollviewTally:onExit()
    state_machine.remove("refining_scrollview_tally_window_show")    
    state_machine.remove("refining_scrollview_tally_window_hide")
    state_machine.remove("refining_scrollview_tally_un_set_selected")
end
