-- ------------------------------------------------------------------------------------------------------------
--  说明：资源建造详情
-- ------------------------------------------------------------------------------------------------------------
BuildUpResBuildInfor = class("BuildUpResBuildInforClass", Window)

--打开界面
local build_up_res_build_infor_window_open_terminal = {
    _name = "build_up_res_build_infor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("BuildUpResBuildInforClass") == nil then
            local build_id = params[1]
            local base_build_info = params[2]
            
            local _win = BuildUpResBuildInfor:new()
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
local build_up_res_build_infor_window_close_terminal = {
    _name = "build_up_res_build_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildUpResBuildInforClass"))
        state_machine.excute("home_button_window_show", 0, "")
        state_machine.excute("main_window_update_userinfo", 0, nil)

        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_res_build_infor_window_open_terminal)
state_machine.add(build_up_res_build_infor_window_close_terminal)
state_machine.init()

function BuildUpResBuildInfor:ctor()
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

    self._build_res_cell = nil
    --load lua file
    app.load("client.red_alert_time.cells.build_up.build_up_cell")
     -- Initialize alert_home state machine.
    local function init_build_up_res_build_infor_terminal()

        --显示所有
        local build_up_res_build_infor_window_show_terminal = {
            _name = "build_up_res_build_infor_window_show",
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
        local build_up_res_build_infor_window_hide_terminal = {
            _name = "build_up_res_build_infor_window_hide",
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
        local build_up_res_build_infor_to_up_terminal = {
            _name = "build_up_res_build_infor_to_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                            state_machine.excute("build_up_res_build_infor_window_close",0,"")
                        end
                        TipDlg.drawTextDailog(red_alert_all_str[279])
                        state_machine.excute("build_up_res_build_window_close",0,"")
                        state_machine.excute("home_map_update_build",0,"")
                        checkPlayEffect(31)
                    end
                end     
                protocol_command.build_level_up.param_list = self._base_build_info.base_mould_id .. "\r\n" .. instance._build_id
                NetworkManager:register(protocol_command.build_level_up.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        state_machine.add(build_up_res_build_infor_window_show_terminal)
        state_machine.add(build_up_res_build_infor_window_hide_terminal)   
        state_machine.add(build_up_res_build_infor_to_up_terminal)
        state_machine.init()
    end
    
    init_build_up_res_build_infor_terminal()
end

--显示
function BuildUpResBuildInfor:onShow()
   self:setVisible(true)
end

--隐藏
function BuildUpResBuildInfor:onHide()
   self:setVisible(false)
end

--初始化界面
function BuildUpResBuildInfor:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_res_build_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "build_up_res_build_infor_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "build_up_res_build_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)  

    -- 建造
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_res_build"), nil, 
    {
        terminal_name = "build_up_res_build_infor_to_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    local Panel_res_build_icon = ccui.Helper:seekWidgetByName(root,"Panel_res_build_icon")
    Panel_res_build_icon:removeBackGroundImage()
    local pic = dms.int(dms["build_mould"], self._build_id, build_mould.pic)
    Panel_res_build_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, pic))

    self:onUpdateDraw()
end

-- 显示信息
function BuildUpResBuildInfor:onUpdateDraw()
    local root = self.roots[1]
    local Text_res_build_name = ccui.Helper:seekWidgetByName(root,"Text_res_build_name")
    local Text_res_build_name_1 = ccui.Helper:seekWidgetByName(root,"Text_res_build_name_1")
    local build_name = dms.string(dms["build_mould"], self._build_id, build_mould.build_name)
    Text_res_build_name:setString(build_name)
    Text_res_build_name_1:setString(build_name)

    local Text_res_build_infor = ccui.Helper:seekWidgetByName(root,"Text_res_build_infor")
    Text_res_build_infor:setString(tipStringInfo_build_name_info[self._build_id+3])

    local Panel_produciton_res_infor = ccui.Helper:seekWidgetByName(root,"Panel_produciton_res_infor")
    local level = zstring.tonumber(self._base_build_info.level)
    local base_build_level_info = _ED.base_build_level_info[""..level]

    if self._build_res_cell == nil then
        self._build_res_cell = state_machine.excute("build_up_cell_create", 0, {Panel_produciton_res_infor, self._base_build_info.base_mould_id,_ED.base_build_info[""..self._build_id],base_build_level_info,true})
    else
        state_machine.excute("build_up_cell_update_all_info", 0, {cell = self._build_res_cell, build_info = _ED.base_build_info[""..self._build_id], build_up_info = base_build_level_info})
    end

    local Text_build_time = ccui.Helper:seekWidgetByName(root,"Text_build_time")
    local need_up_time = _ED.base_build_info[""..self._build_id].need_time
    Text_build_time:setString(exChangeTimeToString(need_up_time))
end

function BuildUpResBuildInfor:onUpdate(dt)

end


--初始化
function BuildUpResBuildInfor:init(build_id,base_build_info)
    self._build_id = build_id
    self._base_build_info = base_build_info
    self:onInit()
end


--移除状态机
function BuildUpResBuildInfor:onExit()
    state_machine.remove("build_up_res_build_infor_window_show")
    state_machine.remove("build_up_res_build_infor_window_hide")
    state_machine.remove("build_up_res_build_infor_to_up")
end