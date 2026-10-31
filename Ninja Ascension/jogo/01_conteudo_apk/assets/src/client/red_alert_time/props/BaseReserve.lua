-- ------------------------------------------------------------------------------------------------------------
--  说明：基地储备显示
-- ------------------------------------------------------------------------------------------------------------
BaseReserve = class("BaseReserveClass", Window)

--打开界面
local base_reserve_window_open_terminal = {
    _name = "base_reserve_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        if funOpenDrawTip(241) == true then
            return
        end 
        if fwin:find("BaseReserveClass") == nil then
            local page_index = params._datas.page_index
            local _win = BaseReserve:new()
            _win:init(page_index)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local base_reserve_window_close_terminal = {
    _name = "base_reserve_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BaseReserveClass"))
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(base_reserve_window_open_terminal)
state_machine.add(base_reserve_window_close_terminal)
state_machine.init()

function BaseReserve:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- 1：基地储备，2：增益
    self._last_page_index = 1

    self._pages = {}

    self._list_view = nil
    self._list_view_poy = nil

    app.load("client.red_alert_time.props.BaseResYieldInfor")
    app.load("client.red_alert_time.props.BaseReserveTab")
    app.load("client.red_alert_time.cells.props.base_reserve_pack_cell")
    app.load("client.red_alert_time.cells.props.base_reserve_gain_cell")
    app.load("client.red_alert_time.cells.props.base_reserve_gain_ing_cell")
    app.load("client.red_alert_time.cells.props.base_reserve_factory_gain_cell")
     -- Initialize alert_home state machine.
    local function init_base_reserve_terminal()
        --显示所有
        local base_reserve_window_show_terminal = {
            _name = "base_reserve_window_show",
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
        local base_reserve_window_hide_terminal = {
            _name = "base_reserve_window_hide",
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
        -- 切换页面
        local base_reserve_change_page_terminal = {
            _name = "base_reserve_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._last_page_index = params._datas.page_index
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新界面
        local base_reserve_update_draw_terminal = {
            _name = "base_reserve_update_draw",
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

        -- 刷新
        local base_reserve_update_draw_page_terminal = {
            _name = "base_reserve_update_draw_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                instance:onUpdateDrawPage()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 打开分享
        local base_reserve_update_open_share_terminal = {
            _name = "base_reserve_update_open_share",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local root = instance.roots[1]
                local Panel_share = ccui.Helper:seekWidgetByName(root, "Panel_share")
                local Panel_share_close = ccui.Helper:seekWidgetByName(root, "Panel_share_close")
                Panel_share:setVisible(true)
                Panel_share_close:setVisible(true)
                Animations_PlayOpenMainUI({Panel_share}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_SLIDE_DOWN, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 关闭分享
        local base_reserve_update_close_share_terminal = {
            _name = "base_reserve_update_close_share",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local root = instance.roots[1]
                local Panel_share = ccui.Helper:seekWidgetByName(root, "Panel_share")
                local Panel_share_close = ccui.Helper:seekWidgetByName(root, "Panel_share_close")
                Panel_share:setVisible(false)
                Panel_share_close:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		-- 分享到世界
        local base_reserve_update_share_world_chat_terminal = {
            _name = "base_reserve_update_share_world_chat",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(params._datas.chat_index) == 14 then
                    if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
                        state_machine.excute("base_reserve_update_close_share", 0, 0)           
                        TipDlg.drawTextDailog(game_share_tip_text[2])
                        return
                    end
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("base_reserve_update_close_share", 0, 0)       
                    return
                end 
				local function responseSendMessageCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("base_reserve_update_close_share", 0, 0)
						TipDlg.drawTextDailog(game_share_tip_text[1])
					end
				end
				local datas = dms.string(dms["message_share"], 2, message_share.content)
				local data1 =  string.gsub(datas, "!x@", exChangeNumToString(_ED.output_per_hour_iron))
				local data2 = string.gsub(data1, "!y@", exChangeNumToString(_ED.output_per_hour_oil))
				local data3 = string.gsub(data2, "!z@", exChangeNumToString(_ED.output_per_hour_exploits))
				local data4 = string.gsub(data3, "!s@", exChangeNumToString(_ED.output_per_hour_tiger))
				local data5 = string.gsub(data4, "!a@", exChangeNumToString(_ED.output_per_hour_silver))
				datas = data5
				local str = zstring.exchangeTo(dms.string(dms["message_share"], 2, message_share.title).."\r\n"..datas)
				str = ""
                -- local paramsInfo = exChangeNumToString(_ED.output_per_hour_iron)..","..exChangeNumToString(_ED.output_per_hour_oil)..","..exChangeNumToString(_ED.output_per_hour_exploits)..","..exChangeNumToString(_ED.output_per_hour_tiger)..","..exChangeNumToString(_ED.output_per_hour_silver)
                local paramsInfo = "0-0,"..exChangeNumToString(_ED.output_per_hour_iron)..","..exChangeNumToString(_ED.output_per_hour_oil)..","..exChangeNumToString(_ED.output_per_hour_exploits)..","..exChangeNumToString(_ED.output_per_hour_tiger)..","..exChangeNumToString(_ED.output_per_hour_silver)
                protocol_command.send_message.param_list = str.."\r\n"..params._datas.chat_index.. "\r\n0\r\n2\r\n" .. paramsInfo
				-- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, self, responseSendMessageCallback, false, nil)
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseSendMessageCallback({node=self, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(base_reserve_window_show_terminal)
        state_machine.add(base_reserve_window_hide_terminal)  
        state_machine.add(base_reserve_change_page_terminal)  
        state_machine.add(base_reserve_update_draw_terminal) 
        state_machine.add(base_reserve_update_draw_page_terminal) 
        state_machine.add(base_reserve_update_open_share_terminal) 
        state_machine.add(base_reserve_update_close_share_terminal) 
        state_machine.add(base_reserve_update_share_world_chat_terminal) 
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_base_reserve_terminal()
end

--显示
function BaseReserve:onShow()
   self:setVisible(true)
end

--隐藏
function BaseReserve:onHide()
   self:setVisible(false)
end

--初始化界面
function BaseReserve:onInit()
    local csbItem = csb.createNode(config_csb.props.base_reserve)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_base_reserve_close"), nil, 
    {
        terminal_name = "base_reserve_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    -- 仓库
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_base_pack"), nil, 
    {
        terminal_name = "base_reserve_change_page", 
        terminal_state = 0, 
        page_index = 1,
    }, nil, 1)   

    -- 增益
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_base_gain"), nil, 
    {
        terminal_name = "base_reserve_change_page", 
        terminal_state = 0, 
        page_index = 2,
    }, nil, 1)   
	
	-- 分享
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build_up"), nil, 
    {
        terminal_name = "base_reserve_update_open_share", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)   
	
	ccui.Helper:seekWidgetByName(root,"Panel_share_close"):setSwallowTouches(false)
	--分享关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_share_close"), nil, 
    {
        terminal_name = "base_reserve_update_close_share", 
        terminal_state = 0, 
    }, nil, 1)
	
	-- 分享到世界
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_world_chat"), nil, 
    {
        terminal_name = "base_reserve_update_share_world_chat", 
        terminal_state = 0, 
        touch_black = true,
		chat_index = 13,
    }, nil, 1) 
	
	-- 分享到军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_legion_chat"), nil, 
    {
        terminal_name = "base_reserve_update_share_world_chat", 
        terminal_state = 0, 
        touch_black = true,
		chat_index = 14,
    }, nil, 1) 

    self:onUpdateDraw()
end

-- 显示信息
function BaseReserve:onUpdateDraw()
    local root = self.roots[1]
    local Button_base_pack = ccui.Helper:seekWidgetByName(root, "Button_base_pack")
    local Button_base_gain = ccui.Helper:seekWidgetByName(root, "Button_base_gain")
    local Panel_base_reserve_tab = ccui.Helper:seekWidgetByName(root, "Panel_base_reserve_tab")
    -- 可保护资源
    local Text_base_res_t_1 = ccui.Helper:seekWidgetByName(root, "Text_base_res_t_1")
    Text_base_res_t_1:setString(string.format(red_alert_time_str[14],exChangeNumToString(_ED.warehouse_capacity_iron)))
    -- 可被掠夺资源
    local Text_base_res_t_2 = ccui.Helper:seekWidgetByName(root, "Text_base_res_t_2")
    local looted_iron = math.max(0,_ED.user_info.user_iron - _ED.warehouse_capacity_iron)
    local looted_oil = math.max(0,_ED.user_info.oil_field - _ED.warehouse_capacity_oil)
    local looted_exploits = math.max(0,_ED.user_info.exploits - _ED.warehouse_capacity_exploits)
    local looted_tiger = math.max(0,_ED.user_info.tiger_shaped - _ED.warehouse_capacity_tiger)
    local looted_silver = math.max(0,_ED.user_info.user_silver - _ED.warehouse_capacity_silver)
    looted_all = looted_iron + looted_oil + looted_exploits + looted_tiger + looted_silver
    Text_base_res_t_2:setString(string.format(red_alert_time_str[15],exChangeNumToString(looted_all)))

    for i, page in pairs(self._pages) do 
        state_machine.excute("base_reserve_tab_hide", 0, page)
    end
    local Text_base_res_prompt = ccui.Helper:seekWidgetByName(root, "Text_base_res_prompt")
    if self._last_page_index == 1 then
        --判断繁荣度
        local currFlore = tonumber(_ED.user_info.booming)
        local maxFlore = tonumber(_ED.user_info.forage)
        local loss_boom_resources = 0
        if currFlore < maxFlore then
            local boom_bar = currFlore/maxFlore
            for i= 1, dms.count(dms["build_boom_lose"]) do
                local boom_proportion = dms.string(dms["build_boom_lose"], i, build_boom_lose.boom_proportion)
                if boom_bar >= tonumber(boom_proportion) then
                    loss_boom_resources = dms.int(dms["build_boom_lose"], i, build_boom_lose.loss_boom_resources)
                    break
                end
            end
        end
        if loss_boom_resources > 0 then
            local str = Text_base_res_prompt:getString()
            local str1 = string.gsub(str,"100",loss_boom_resources)
            Text_base_res_prompt:setString(str1)
            Text_base_res_prompt:setVisible(true)
        else
            Text_base_res_prompt:setVisible(false)
        end
        Button_base_pack:setHighlighted(true)
        Button_base_pack:setTouchEnabled(false)
        Button_base_gain:setHighlighted(false)
        Button_base_gain:setTouchEnabled(true)
        if self._pages["1"] == nil then
            self._pages["1"] = state_machine.excute("base_reserve_tab_window_open", 0, {Panel_base_reserve_tab, 1})
        end
        state_machine.excute("base_reserve_tab_show", 0, self._pages["1"])
    else
        Text_base_res_prompt:setVisible(false)
        Button_base_pack:setHighlighted(false)
        Button_base_pack:setTouchEnabled(true)
        Button_base_gain:setHighlighted(true)
        Button_base_gain:setTouchEnabled(false)
        if self._pages["2"] == nil then
            self._pages["2"] = state_machine.excute("base_reserve_tab_window_open", 0, {Panel_base_reserve_tab, 2})
        end
        state_machine.excute("base_reserve_tab_show", 0, self._pages["2"])
    end
end

function BaseReserve:onUpdateDrawPage()
    for i, page in pairs(self._pages) do 
        state_machine.excute("base_reserve_tab_update_draw", 0, page)
    end
end

--初始化
function BaseReserve:init(params)
    self._last_page_index = params
    self:setTouchEnabled(true)
    self:onInit()
end

--移除状态机
function BaseReserve:onExit()
    state_machine.remove("base_reserve_window_show")
    state_machine.remove("base_reserve_window_hide")
    state_machine.remove("base_reserve_change_page")
    state_machine.remove("base_reserve_update_draw")
    state_machine.remove("base_reserve_update_draw_page")
    state_machine.remove("base_reserve_update_open_share")
    state_machine.remove("base_reserve_update_share_world_chat")
end