--------------------------------------------------------------------------------------------------------------
--  说明：
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingChangeSign = class("UnionTheMeetingChangeSignClass", Window)

--打开界面
local union_the_meeting_change_sign_open_terminal = {
    _name = "union_the_meeting_change_sign_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local UnionTheMeetingChangeSignWindow = fwin:find("UnionTheMeetingChangeSignClass")
        if UnionTheMeetingChangeSignWindow ~= nil and UnionTheMeetingChangeSignWindow:isVisible() == true then
            return true
        end
        state_machine.lock("union_the_meeting_change_sign_open", 0, "")
		fwin:open(UnionTheMeetingChangeSign:createCell(), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local union_the_meeting_change_sign_close_terminal = {
    _name = "union_the_meeting_change_sign_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        UnionTheMeetingChangeSign:closeCell()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_the_meeting_change_sign_open_terminal)
state_machine.add(union_the_meeting_change_sign_close_terminal)
state_machine.init()

function UnionTheMeetingChangeSign:ctor()
	self.super:ctor()
	self.roots = {}

	self.selectkuangIndex = -1
	self.selecttuIndex = -1
	self.suo2Image = false
    self.suo3Image = false
	 -- Initialize union the meeting place trends machine.
    local function init_union_the_meeting_change_sign_terminal()
		
		-- 隐藏界面
        local union_the_meeting_change_sign_hide_event_terminal = {
            _name = "union_the_meeting_change_sign_hide_event",
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
		
		-- 显示界面
        local union_the_meeting_change_sign_show_event_terminal = {
            _name = "union_the_meeting_change_sign_show_event",
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
		--刷新信息
		local union_the_meeting_change_sign_refresh_info_terminal = {
            _name = "union_the_meeting_change_sign_refresh_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- -- 选择军团图标
        local union_the_meeting_change_sign_select_tu_terminal = {
            _name = "union_the_meeting_change_sign_select_tu",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local mcell = params._datas.cell
                mcell.selecttuIndex = params._datas.selecttuIndex
                local but_bgImage = nil
                if terminal.page_tu_name ~= nil then
                    but_bgImage = ccui.Helper:seekWidgetByName(mcell.roots[1], terminal.page_tu_name)
                    if but_bgImage ~= nil then
                        but_bgImage:setVisible(false)
                    end
                end
                terminal.page_tu_name = params._datas.but_image
                but_bgImage = ccui.Helper:seekWidgetByName(mcell.roots[1], terminal.page_tu_name)
                if but_bgImage ~= nil then
                    but_bgImage:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- -- 选择军团kuang
        local union_the_meeting_change_sign_select_kuang_terminal = {
            _name = "union_the_meeting_change_sign_select_kuang",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local mcell = params._datas.cell
                if params._datas.selectkuangIndex == 2 and self.suo2Image == true then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[34])
                    return
                end
                if params._datas.selectkuangIndex == 3 and self.suo3Image == true then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[34])
                    return
                end
                mcell.selectkuangIndex = params._datas.selectkuangIndex
                local but_bgImage = nil
                if terminal.page_name ~= nil then
                    but_bgImage = ccui.Helper:seekWidgetByName(mcell.roots[1], terminal.page_name)
                    if but_bgImage ~= nil then
                        but_bgImage:setVisible(false)
                    end
                end
                terminal.page_name = params._datas.but_image
                but_bgImage = ccui.Helper:seekWidgetByName(mcell.roots[1], terminal.page_name)
                if but_bgImage ~= nil then
                    but_bgImage:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local union_the_meeting_change_sign_ensure_button_terminal = {
            _name = "union_the_meeting_change_sign_ensure_button",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local mcell = params._datas.cell
				if mcell.selecttuIndex == -1  or mcell.selectkuangIndex == -1 then
					TipDlg.drawTextDailog(tipStringInfo_union_str[21])
					return
				end
				local config = nil
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    config = zstring.split(dms.string(dms["pirates_config"], 297, pirates_config.param), ",")
                else
                    config = zstring.split(dms.string(dms["pirates_config"], 292, pirates_config.param), ",")
                end
				if zstring.tonumber(config[mcell.selectkuangIndex]) > _ED.union.union_info.union_grade then
					TipDlg.drawTextDailog(tipStringInfo_union_str[34])
					return
				end
				local function responseUnionCreateCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
						
							_ED.union.union_info.union_icon = mcell.selecttuIndex
							_ED.union.union_info.union_kuang = mcell.selectkuangIndex
							 state_machine.excute("union_the_meeting_place_information_refresh", 0, "")
							state_machine.excute("union_the_meeting_change_sign_close", 0, "")
						end	
						
					end
				end
	
			
				protocol_command.unino_pic_frame_exchange.param_list = ""..mcell.selecttuIndex.."\r\n"..mcell.selectkuangIndex
				NetworkManager:register(protocol_command.unino_pic_frame_exchange.code, nil, nil, nil, mcell, responseUnionCreateCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(union_the_meeting_change_sign_hide_event_terminal)
		state_machine.add(union_the_meeting_change_sign_select_tu_terminal)
		state_machine.add(union_the_meeting_change_sign_show_event_terminal)
		state_machine.add(union_the_meeting_change_sign_refresh_info_terminal)
		state_machine.add(union_the_meeting_change_sign_select_kuang_terminal)
		state_machine.add(union_the_meeting_change_sign_ensure_button_terminal)
        state_machine.init()
    end
    
    -- call func init union the meeting place trends  machine.
    init_union_the_meeting_change_sign_terminal()

end

function UnionTheMeetingChangeSign:onHide()
	self:setVisible(false)
end

function UnionTheMeetingChangeSign:onShow()
	self:setVisible(true)
end

function UnionTheMeetingChangeSign:updateDraw()
    local root = self.roots[1]

   
end

function UnionTheMeetingChangeSign:onInit()
	self:updateDraw()
end

function UnionTheMeetingChangeSign:onEnterTransitionFinish()
    local csbUnionTheMeetingChangeSignCell = csb.createNode("legion/legion_biaozhi.csb")
    local root = csbUnionTheMeetingChangeSignCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionTheMeetingChangeSignCell)
	 local action = csb.createTimeline("legion/legion_biaozhi.csb")

    csbUnionTheMeetingChangeSignCell:runAction(action)
 
    action:play("window_open", false)
	
	
    self:init()

   
	local suo2 = ccui.Helper:seekWidgetByName(root, "Image_suo_32")
    local suo3 = ccui.Helper:seekWidgetByName(root, "Image_suo_33")
    suo2:setVisible(false)
    suo3:setVisible(false)
    local config = nil
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        config = zstring.split(dms.string(dms["pirates_config"], 297, pirates_config.param), ",")
    else
        config = zstring.split(dms.string(dms["pirates_config"], 292, pirates_config.param), ",")
    end
    if zstring.tonumber(config[2]) > _ED.union.union_info.union_grade then
        suo2:setVisible(true)
        self.suo2Image = true
        -- ccui.Helper:seekWidgetByName(root, "Image_biankuang_"..2):setTouchEnabled(false)
    end
    if zstring.tonumber(config[3]) > _ED.union.union_info.union_grade then
        suo3:setVisible(true)
        self.suo3Image = true
         -- ccui.Helper:seekWidgetByName(root, "Image_biankuang_"..3):setTouchEnabled(false)
    end

	for i = 1, 3 do          -- 根据物品数量添加响应
		local butimage = "Image_gou_2"..i
		
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_biankuang_"..i),       nil, 
        {
            terminal_name = "union_the_meeting_change_sign_select_kuang",     
            but_image = butimage,
            terminal_state = 0, 
            cell = self,
            selectkuangIndex = i,
            isPressedActionEnabled = false
        }, 
        nil, 0)
    end
	for i = 1, 3 do          -- 根据物品数量添加响应
		local butimage = "Image_gou_1"..i
		
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_biaozhi_"..i),       nil, 
        {
            terminal_name = "union_the_meeting_change_sign_select_tu",     
            but_image = butimage,
            terminal_state = 0, 
            cell = self,
            selecttuIndex = i,
            isPressedActionEnabled = false
        }, 
        nil, 0)
    end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_122_0"), nil, 
    {
        terminal_name = "union_the_meeting_change_sign_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0) 
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_123"), nil, 
    {
        terminal_name = "union_the_meeting_change_sign_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_122"), nil, 
    {
        terminal_name = "union_the_meeting_change_sign_ensure_button", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    state_machine.unlock("union_the_meeting_change_sign_open", 0, "")
end

function UnionTheMeetingChangeSign:init()
	self:onInit()
	return self
end

function UnionTheMeetingChangeSign:onExit()
	state_machine.remove("union_the_meeting_change_sign_hide_event")
	state_machine.remove("union_the_meeting_change_sign_show_event")
	state_machine.remove("union_the_meeting_change_sign_refresh_info")
	state_machine.remove("union_the_meeting_change_sign_select_tu")
	state_machine.remove("union_the_meeting_change_sign_select_kuang")
	state_machine.remove("union_the_meeting_change_sign_ensure_button")
end

function UnionTheMeetingChangeSign:createCell( ... )
    local cell = UnionTheMeetingChangeSign:new()
	
    cell:registerOnNodeEvent(cell)
    return cell
end

function UnionTheMeetingChangeSign:closeCell( ... )
    local UnionTheMeetingChangeSignWindow = fwin:find("UnionTheMeetingChangeSignClass")
    if UnionTheMeetingChangeSignWindow == nil then
        return
    end
    fwin:close(UnionTheMeetingChangeSignWindow)
end