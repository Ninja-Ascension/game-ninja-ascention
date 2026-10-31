-----------------------------
-- 七星台
-----------------------------
SevenStar = class("SevenStarClass", Window)

--打开七星台
local seven_star_window_open_terminal = {
    _name = "seven_star_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(85) == true then
            return
        end
        local _SevenStarWindow = fwin:find("SevenStarClass")
        if nil == _SevenStarWindow then
            fwin:open(SevenStar:new():init(params))
        end
        state_machine.excute("main_window_hide", 0, "")
        state_machine.excute("player_resource_window_hide", 0, "")     
        state_machine.excute("home_button_for_action_window_hide",0,"")
        state_machine.excute("chat_view_window_hide",0,"")   
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭七星台
local seven_star_window_close_terminal = {
    _name = "seven_star_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SevenStarClass"))

        state_machine.excute("main_window_open",0,"")
        state_machine.excute("player_resource_window_show",0,"")   
        state_machine.excute("home_button_for_action_window_show",0,"")  
        state_machine.excute("chat_view_window_show",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(seven_star_window_open_terminal)
state_machine.add(seven_star_window_close_terminal)
state_machine.init()

function SevenStar:ctor()
    self.super:ctor()
    self.roots = {}
    --load lua file
    app.load("client.red_alert.battle.battle_enum")
    app.load("client.red_alert.cells.genral_choose.seven_star.seven_star_cell")

    -- Initialize SevenStar state machine.
    local function init_SevenStar_terminal()
    
        --显示界面
        local seven_star_window_show_terminal = {
            _name = "seven_star_window_show",
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
        local seven_star_window_hide_terminal = {
            _name = "seven_star_window_hide",
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
        local seven_star_update_list_view_terminal = {
            _name = "seven_star_update_list_view",
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

        state_machine.add(seven_star_window_show_terminal)  
        state_machine.add(seven_star_window_hide_terminal)
        state_machine.add(seven_star_update_list_view_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_SevenStar_terminal()
end

--隐藏界面
function SevenStar:onHide()
    self:setVisible(false)
end

--显示界面
function SevenStar:onShow()
    self:setVisible(true)
end

-- 七星台列表页
function SevenStar:onUpdateDraw()
    local root = self.roots[1]
    -- 斩敌次数
    local Text_kill_numbers = ccui.Helper:seekWidgetByName(root,"Text_kill_numbers")
    local attack_times = dms.int(dms["copy_config"],10,copy_config.param)   -- 总攻击次数
    local leave_times = attack_times - _ED.seven_star_attack_times  -- 剩余攻击次数
    Text_kill_numbers:setString(leave_times)

    local ListView_2 = ccui.Helper:seekWidgetByName(root,"ListView_2")
    ListView_2:removeAllItems()
    --得到开放场景列表
    local open_number = 0
    for i = 1,table.getn(_ED.scene_current_state) do
        local _scene_type = dms.int(dms["pve_scene"], i, pve_scene.scene_type) 
        if _scene_type == battle_enum._fight_type._fight_type_104 then
            local open_level = dms.int(dms["pve_scene"], i, pve_scene.open_level) 
            open_number = open_number + 1
            if tonumber(_ED.user_info.user_grade) >= open_level then 
                local cell = state_machine.excute("seven_star_create_cell",0,{battle_enum._fight_type._fight_type_104,i,open_number})
                ListView_2:addChild(cell)  
            end
        end
    end
    ListView_2:requestRefreshView()
end

function SevenStar:onEnterTransitionFinish()

end

--初始化界面
function SevenStar:onInit( )
    local csbItem = csb.createNode(config_csb.genral_choose.seven_star.seven_star)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "seven_star_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw() 
end

function SevenStar:init()
    self:onInit()
    return self
end

--移除状态机
function SevenStar:onExit()
    state_machine.remove("seven_star_window_show")  
    state_machine.remove("seven_star_window_hide")
    state_machine.remove("seven_star_update_list_view")
end

