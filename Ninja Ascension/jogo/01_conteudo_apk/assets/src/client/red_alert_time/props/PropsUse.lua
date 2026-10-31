-- ------------------------------------------------------------------------------------------------------------
--  说明：使用道具
-- ------------------------------------------------------------------------------------------------------------
PropsUse = class("PropsUseClass", Window)

--打开界面
local props_use_window_open_terminal = {
    _name = "props_use_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("PropsUseClass") == nil then
            local id = params[1]
            local prop_list = params[2]
            local buy_type = params[3]
            local use_id = params[4]
            local _win = PropsUse:new()
            _win:init(id, prop_list, buy_type, use_id)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local props_use_window_close_terminal = {
    _name = "props_use_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PropsUseClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(props_use_window_open_terminal)
state_machine.add(props_use_window_close_terminal)
state_machine.init()

function PropsUse:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._id = 0
    self._prop_list = {}
    self._buy_type = 1      -- 道具使用类型：1：资源，2：建筑加速，3：科技加速，4：生产加速
    self._use_id = -1           -- 建筑加速:建筑基础模板 科技加速:科技实例id 生产加速:生产实例

    self._need_update = false   -- 是否有购买或使用过道具

    app.load("client.red_alert_time.cells.props.props_use_cell")
     -- Initialize alert_home state machine.
    local function init_props_use_terminal()
        --显示所有
        local props_use_window_show_terminal = {
            _name = "props_use_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:onShow()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 隐藏所有
        local props_use_window_hide_terminal = {
            _name = "props_use_window_hide",
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

        local props_use_window_update_terminal = {
            _name = "props_use_window_update",
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

        local props_use_window_need_update_terminal = {
            _name = "props_use_window_need_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._need_update = true
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local props_use_window_on_close_terminal = {
            _name = "props_use_window_on_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._need_update == true then
                    state_machine.excute("main_window_update_userinfo", 0, nil)
                    if instance._buy_type == 4 
                        or instance._buy_type == 1
                        then
                        state_machine.excute("build_up_tank_factory_to_update_draw",0,nil)
                    else
                        state_machine.excute("build_up_tank_factory_production_upgrade_info",0,nil)
                        state_machine.excute("build_up_tank_factory_production_ex_upgrade_info",0,nil)
                    end
                    state_machine.excute("build_up_headquarters_to_update_draw",0,nil)
                    state_machine.excute("build_up_scientific_to_update_draw",0,nil)
                    state_machine.excute("build_up_res_to_update_draw",0,nil)
                    state_machine.excute("build_up_reform_factory_to_update_draw",0,nil)
                    state_machine.excute("player_info_build_upgrade_update_draw",0,nil)
                    state_machine.excute("build_up_tank_production_proc_cell_update",0,nil)
                    state_machine.excute("build_up_scientific_info_update_draw",0,nil)
                    state_machine.excute("build_up_scientific_up_update_draw",0,"")
                    state_machine.excute("formation_factor_update",0,nil)
                    state_machine.excute("formation_defend_update_factor",0,nil)
                    state_machine.excute("build_up_make_props_update_draw",0,nil)
                    state_machine.excute("build_up_tank_production_proc_update_draw", 0, nil)
                    state_machine.excute("build_up_tank_production_proc_ex_update_draw", 0, nil)
                end
                state_machine.excute("props_use_window_close",0,nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(props_use_window_show_terminal)
        state_machine.add(props_use_window_hide_terminal)
        state_machine.add(props_use_window_update_terminal)
        state_machine.add(props_use_window_need_update_terminal)
        state_machine.add(props_use_window_on_close_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_props_use_terminal()
end

--显示
function PropsUse:onShow()
   self:setVisible(true)
end

--隐藏
function PropsUse:onHide()
   self:setVisible(false)
end

--初始化界面
function PropsUse:onInit()
    local csbItem = csb.createNode(config_csb.props.props_use)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_props_use_close"), nil, 
    {
        terminal_name = "props_use_window_on_close", 
        terminal_state = 0, 
        touch_black = true, 
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "props_use_window_on_close", 
        terminal_state = 0, 
    }, nil, 3)

    self:onUpdateDraw()
end

-- 显示信息
function PropsUse:onUpdateDraw()
    local root = self.roots[1]
    local ListView_props_use = ccui.Helper:seekWidgetByName(root,"ListView_props_use") -- 道具列表
    ListView_props_use:jumpToTop()
    ListView_props_use:removeAllItems()
    for k,v in pairs(self._prop_list) do
        local cell = state_machine.excute("props_use_create_cell", 0, {k, self._id, v, self._buy_type, self._use_type, self._use_id})
        ListView_props_use:addChild(cell)
    end
end

--初始化
function PropsUse:init(id, prop_list, buy_type, use_id)
    self._id = id
    self._prop_list = prop_list
    self._buy_type = buy_type
    if use_id ~= nil then
        self._use_id = use_id           -- 建筑加速:建筑基础模板 科技加速:科技实例id 生产加速:生产实例
    end
    self:onInit()
end

--移除状态机
function PropsUse:onExit()
    state_machine.remove("props_use_window_show")
    state_machine.remove("props_use_window_hide")
    state_machine.remove("props_use_window_update")
    state_machine.remove("props_use_window_need_update")
    state_machine.remove("props_use_window_on_close")
end