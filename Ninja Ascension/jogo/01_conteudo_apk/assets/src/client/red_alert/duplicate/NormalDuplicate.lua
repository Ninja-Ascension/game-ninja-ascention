-----------------------------
--普通副本列表页
-----------------------------
NormalDuplicate = class("NormalDuplicateClass", Window)

--打开普通副本列表页
local normal_duplicate_window_open_terminal = {
    _name = "normal_duplicate_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _normalDuplicateWindow = fwin:find("NormalDuplicateClass")
        if nil == _normalDuplicateWindow then
            fwin:open(NormalDuplicate:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭普通副本列表页
local normal_duplicate_window_close_terminal = {
    _name = "normal_duplicate_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local win = fwin:find("NormalDuplicateClass")
        if win ~= nil then
            fwin:close(win)
        end 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(normal_duplicate_window_open_terminal)
state_machine.add(normal_duplicate_window_close_terminal)
state_machine.init()

function NormalDuplicate:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize NormalDuplicate state machine.
    local function init_NormalDuplicate_terminal()
    
        --显示界面
        local normal_duplicate_window_show_terminal = {
            _name = "normal_duplicate_window_show",
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
        local normal_duplicate_window_hide_terminal = {
            _name = "normal_duplicate_window_hide",
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

        --刷新
        local normal_duplicate_update_list_view_terminal = {
            _name = "normal_duplicate_update_list_view",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        state_machine.add(normal_duplicate_window_show_terminal)  
        state_machine.add(normal_duplicate_window_hide_terminal)
        state_machine.add(normal_duplicate_update_list_view_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_NormalDuplicate_terminal()
end

--隐藏界面
function NormalDuplicate:onHide()
    self:setVisible(false)
end

--显示界面
function NormalDuplicate:onShow()
    self:setVisible(true)
end

--刷新普通副本列表页
function NormalDuplicate:onUpdateDraw()
    local root = self.roots[1]
    local ListView_pve_chapter = ccui.Helper:seekWidgetByName(root,"ListView_pve_chapter")
    ListView_pve_chapter:setSwallowTouches(false)
    local sCountCurrent = 0 --用于记录当前有多少条场景
    local normalScene = {}
    local sCount = 0
    local maxCount = 0
    local bLastScene = false
    
    --得到开放场景列表
    local function getOpenSceneList()
        local open_number = 0
        for i = 1,table.getn(_ED.scene_current_state) do
            local _scene_type = dms.int(dms["pve_scene"], i, pve_scene.scene_type) 
            if _scene_type == 1 then
                if _ED.scene_current_state[i] == nil or _ED.scene_current_state[i] == "" then
                    return
                end
                if tonumber(_ED.scene_current_state[i]) < 0 then
                    if open_number < 3 then
                        return
                    end
                    -- -- 未开启章节
                    -- if open_number < 9 then
                    --     sCount = sCount + 1
                    --     sCountCurrent = sCount
                    --     normalScene[sCount] = i
                    --     open_number = open_number + 1
                    --     if open_number == 8 then
                    --         return
                    --     end
                    -- else
                        sCount = sCount + 1
                        sCountCurrent = sCount
                        normalScene[sCount] = i    
                        return
                    -- end
                else
                    open_number = open_number + 1
                    sCount = sCount + 1
                    sCountCurrent = sCount
                    normalScene[sCount] = i    
                end
                
            end
        end
    end

    getOpenSceneList()
    maxCount = sCount
    self.maxMapCount = sCount
    
    self.openSceneList = normalScene
    ListView_pve_chapter:removeAllItems()
    
    -- debug.print_r(self.openSceneList)
    local nCount = table.getn(self.openSceneList)
    for i = 1, nCount do
        local v = self.openSceneList[i]
        if v ~= nil then
            local cell = state_machine.excute("duplicate_list_create_cell",0,{2,v,i})
            ListView_pve_chapter:addChild(cell)            
        end
    end

    ListView_pve_chapter:refreshView()
    local move_x = ListView_pve_chapter:getContentSize().width - ListView_pve_chapter:getInnerContainer():getContentSize().width
    
    ListView_pve_chapter:getInnerContainer():setPosition(cc.p(move_x,0))

end

function NormalDuplicate:onEnterTransitionFinish()

end

--初始化页面
function NormalDuplicate:onInit( )
    local csbItem = csb.createNode(config_csb.duplicate.normal_duplicate)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    --进入副本页面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, ""), nil, 
    {
        terminal_name = "", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw() 
end

function NormalDuplicate:init(params)
    local rootWindow = params[1]

    self._rootWindows = rootWindow    
    self:onInit()
    return self
end

--移除状态机
function NormalDuplicate:onExit()
    state_machine.remove("normal_duplicate_window_show")  
    state_machine.remove("normal_duplicate_window_hide")
    state_machine.remove("normal_duplicate_update_list_view")
end

