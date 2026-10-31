-----------------------------
--七星台地图顶部信息栏
-----------------------------
SevenStarMapUi = class("SevenStarMapUiClass", Window)

--打开副本地图顶部信息
local seven_star_map_ui_window_open_terminal = {
    _name = "seven_star_map_ui_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _SevenStarMapUiWindow = fwin:find("SevenStarMapUiClass")
        if nil == _SevenStarMapUiWindow then
            if type(params) == "table" then
                terminal._datas = params._datas -- 记录数据
            end
            local index = terminal._datas.index
            local scenceID = terminal._datas._scenceID
            fwin:open(SevenStarMapUi:new():init(index,scenceID), fwin._ui)
        end
        state_machine.excute("home_button_for_action_window_show",0,"")  
        state_machine.excute("player_resource_window_hide", 0, "")     
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭副本地图顶部信息
local seven_star_map_ui_window_close_terminal = {
    _name = "seven_star_map_ui_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local win = fwin:find("SevenStarMapUiClass")
        if win ~= nil then
            fwin:close(win)
        end 
        state_machine.excute("home_button_for_action_window_hide",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(seven_star_map_ui_window_open_terminal)
state_machine.add(seven_star_map_ui_window_close_terminal)
state_machine.init()

function SevenStarMapUi:ctor()
    self.super:ctor()
    self.roots = {}

    --var
    -- 层数
    self._index = nil
    -- 场景id
    self._scenceID = scenceID
    --奖励
    self.reward_data = nil

    --load lua file
    app.load("client.red_alert.cells.reward.star_box_duplicate_cell")
    app.load("client.red_alert.duplicate.DuplicateNpcWindow")
    app.load("client.red_alert.duplicate.DuplicateStarBoxWindow")
    app.load("client.red_alert.campaign.trialtower.TrialtowerPassReward")

    -- Initialize SevenStarMapUi state machine.
    local function init_seven_star_map_ui_terminal()
        --显示界面
        local seven_star_map_ui_window_show_terminal = {
            _name = "seven_star_map_ui_window_show",
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
        local seven_star_map_ui_window_hide_terminal = {
            _name = "seven_star_map_ui_window_hide",
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
        --返回上级界面
        local seven_star_map_ui_back_up_floor_terminal = {
            _name = "seven_star_map_ui_back_up_floor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("seven_star_map_ui_window_close",0,"")
                state_machine.excute("duplicate_map_window_close",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        state_machine.add(seven_star_map_ui_window_show_terminal) 
        state_machine.add(seven_star_map_ui_window_hide_terminal)
        state_machine.add(seven_star_map_ui_back_up_floor_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_seven_star_map_ui_terminal()
end

--隐藏
function SevenStarMapUi:onHide()
    self:setVisible(false)
end

--显示
function SevenStarMapUi:onShow()
    self:setVisible(true)
end

--刷新七星台地图顶部信息
function SevenStarMapUi:onUpdateDraw()
    local root = self.roots[1]
    -- 当前层数
    local Text_level_number = ccui.Helper:seekWidgetByName(root,"Text_level_number")
    Text_level_number:setString(self._index)
    -- 剩余斩敌次数
    local Text_remind_number = ccui.Helper:seekWidgetByName(root,"Text_remind_number")
    local attack_times = dms.int(dms["copy_config"],10,copy_config.param)   -- 总攻击次数
    local leave_times = attack_times - _ED.seven_star_attack_times  -- 剩余攻击次数
    Text_remind_number:setString(leave_times)
end

function SevenStarMapUi:onEnterTransitionFinish()
    if self.reward_data ~= nil then
        self:checkReward()
    end
end

function SevenStarMapUi:checkReward()
   state_machine.excute("trialtower_pass_reward_window_open",0,{nil,self.reward_data})
end

--添加宝箱
function SevenStarMapUi:addStarBox()
    local root = self.roots[1]
    local Panel_box = ccui.Helper:seekWidgetByName(root,"Panel_box")
    Panel_box:removeAllChildren(true)
    local cell = state_machine.excute("star_box_duplicate_create_cell",0,{1,105,self._scenceID})
    Panel_box:addChild(cell)
end

--初始化副本地图顶部信息
function SevenStarMapUi:onInit( )
    local csbItem = csb.createNode(config_csb.genral_choose.seven_star.seven_star_map_ui)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    --返回上级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "seven_star_map_ui_back_up_floor", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    -- 宝箱
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_box"), nil, 
    {
        terminal_name = "", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw() 
    self:addStarBox()
end

function SevenStarMapUi:init(index,scenceID)
    self._index = index
    self._scenceID = scenceID
    self.reward_data = getSceneReward(79) 
    self:onInit()
    return self 
end

--移除状态机
function SevenStarMapUi:onExit()
    state_machine.remove("seven_star_map_ui_window_show") 
    state_machine.remove("seven_star_map_ui_window_hide")
    state_machine.remove("seven_star_map_ui_back_up_floor")
end
