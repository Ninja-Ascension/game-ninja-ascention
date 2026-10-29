-- ------------------------------------------------------------------------------------------------------------
--  说明：资源建造
-- ------------------------------------------------------------------------------------------------------------
BuildUpResBuild = class("BuildUpResBuildClass", Window)

--打开界面
local build_up_res_build_window_open_terminal = {
    _name = "build_up_res_build_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("BuildUpResBuildClass") == nil then
            local build_id = params[1]
            local base_build_info = params[2]
            
            local _win = BuildUpResBuild:new()
            _win:init(build_id,base_build_info)
            fwin:open(_win, fwin._ui)
        end

        state_machine.excute("home_button_window_hide", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local build_up_res_build_window_close_terminal = {
    _name = "build_up_res_build_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildUpResBuildClass"))
        state_machine.excute("home_button_window_show", 0, "")
        state_machine.excute("main_window_update_userinfo", 0, nil)

        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_res_build_window_open_terminal)
state_machine.add(build_up_res_build_window_close_terminal)
state_machine.init()

function BuildUpResBuild:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.last_time = nil
    -- 1建造，2介绍
    self._last_page_index = 0

    -- 建筑id
    self._build_id = 0
    -- 加速倒计时
    self._text_time = nil
    self._loading_bar = nil
    -- 建筑模板信息
    self._base_build_info = nil
    self._update_image = nil
    -- 加速所需金币
    self._need_gold = 0
    --load lua file
    app.load("client.red_alert_time.cells.build_up.build_up_cell")
     -- Initialize alert_home state machine.
    local function init_build_up_res_build_terminal()

        --显示所有
        local build_up_res_build_window_show_terminal = {
            _name = "build_up_res_build_window_show",
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
        local build_up_res_build_window_hide_terminal = {
            _name = "build_up_res_build_window_hide",
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

        -- 建造
        local build_up_res_build_to_up_terminal = {
            _name = "build_up_res_build_to_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local base_build_id = params._datas.base_build_id
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                            state_machine.excute("build_up_res_build_window_close",0,"")
                        end
                        TipDlg.drawTextDailog(red_alert_all_str[279])
                        state_machine.excute("home_map_update_build",0,"")
                        checkPlayEffect(31)
                    end
                end     
                protocol_command.build_level_up.param_list = _ED.home_build[""..instance._build_id].base_mould_id .. "\r\n" .. base_build_id
                NetworkManager:register(protocol_command.build_level_up.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 详情
        local build_up_res_build_to_infor_terminal = {
            _name = "build_up_res_build_to_infor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local base_build_id = params._datas.base_build_id
                state_machine.excute("build_up_res_build_infor_window_open",0,{base_build_id, _ED.home_build[""..instance._build_id]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        state_machine.add(build_up_res_build_window_show_terminal)
        state_machine.add(build_up_res_build_window_hide_terminal)   
        state_machine.add(build_up_res_build_to_up_terminal)
        state_machine.add(build_up_res_build_to_infor_terminal)
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_build_up_res_build_terminal()

end

--显示
function BuildUpResBuild:onShow()
   self:setVisible(true)
end

--隐藏
function BuildUpResBuild:onHide()
   self:setVisible(false)
end

--初始化界面
function BuildUpResBuild:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_res_build)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "build_up_res_build_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    for i=1,3 do
        -- 建造
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build_"..i), nil, 
        {
            terminal_name = "build_up_res_build_to_up", 
            terminal_state = 0, 
            touch_black = true,
            base_build_id = 21 + i,
        }, nil, 1)  

        -- 详情
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_infor_"..i), nil, 
        {
            terminal_name = "build_up_res_build_to_infor", 
            terminal_state = 0, 
            touch_black = true,
            base_build_id = 21 + i,
        }, nil, 1)  
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_res_infor_bg_"..i), nil, 
        {
            terminal_name = "build_up_res_build_to_infor", 
            terminal_state = 0, 
            touch_black = true,
            base_build_id = 21 + i,
        }, nil, 1)  
    end

    self:onUpdateDraw()

end

-- 显示信息
function BuildUpResBuild:onUpdateDraw()
    local root = self.roots[1]
    local Text_iron_ore_n = ccui.Helper:seekWidgetByName(root,"Text_iron_ore_n") -- 铁矿场拥有数量
    local Text_petroeum_n = ccui.Helper:seekWidgetByName(root,"Text_petroeum_n") -- 石油场拥有数量
    local Text_lead_ore_n = ccui.Helper:seekWidgetByName(root,"Text_lead_ore_n") -- 铅矿场拥有数量

    local iron_count = 0
    local petroeum_count = 0
    local lead_count = 0

    for k,v in pairs(_ED.home_build) do
        local build_mould_id = tonumber(v.build_mould_id)
        if build_mould_id == 22 then
            iron_count = iron_count + 1
        elseif build_mould_id == 23 then
            petroeum_count = petroeum_count + 1
        elseif build_mould_id == 24 then
            lead_count = lead_count + 1
        end
    end

    Text_iron_ore_n:setString(iron_count)
    Text_petroeum_n:setString(petroeum_count)
    Text_lead_ore_n:setString(lead_count)

    for i=1,3 do
        local Text_res_have_time_n = ccui.Helper:seekWidgetByName(root,"Text_res_have_time_n_"..i)
        local need_up_time = _ED.base_build_info[""..(21 + i)].need_time
        Text_res_have_time_n:setString(exChangeTimeToString(need_up_time))
    end
end

function BuildUpResBuild:onUpdate(dt)

end


--初始化
function BuildUpResBuild:init(build_id,base_build_info)
    self._build_id = build_id
    self._base_build_info = base_build_info
    self:setTouchEnabled(true)
    self:onInit()
end


--移除状态机
function BuildUpResBuild:onExit()
    state_machine.remove("build_up_res_build_window_show")
    state_machine.remove("build_up_res_build_window_hide")
    state_machine.remove("build_up_res_build_to_up")
    state_machine.remove("build_up_res_build_to_infor")
end