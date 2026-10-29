-- ----------------------------------------------------------------------------------------------------
-- 说明：平台的facebook功能界面（红警项目）
-- 创建时间	2017-05-4
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

platformFbMethod = class("platformFbMethodClass", Window)

local platform_fb_method_open_terminal = {
    _name = "platform_fb_method_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
       	local platformFbMethodWindow = fwin:find("platformFbMethodClass")
        if platformFbMethodWindow ~= nil and platformFbMethodWindow:isVisible() == true then
            return true
        elseif platformFbMethodWindow ~= nil and platformFbMethodWindow:isVisible() == false then 
        	platformFbMethodWindow:setVisible(true)
        	return true
        end

        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                local cell = platformFbMethod:new()
                fwin:open(cell:init(), fwin._notification)
                return cell
            end
        end
        NetworkManager:register(protocol_command.fb_reward_init.code, nil, nil, nil, instance, responseCallback, false, nil)
    end,
    _terminal = nil,
    _terminals = nil
}

local platform_fb_method_close_terminal = {
    _name = "platform_fb_method_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
      	fwin:close(fwin:find("platformFbMethodClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(platform_fb_method_open_terminal)
state_machine.add(platform_fb_method_close_terminal)
state_machine.init()
    
function platformFbMethod:ctor()
    self.super:ctor()
	self.roots = {}
	self.group = {}
    self.listView = nil 
    app.load("client.operation.platformSDKInterface.platformFacebook.cell.platformFblist")
    local function init_platform_fb_method_terminal()
		local platform_fb_goto_home_page_terminal = {
            _name = "platform_fb_goto_home_page",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                handlePlatformRequest(0, CC_FACEBOOK_HOME, _face_book_url)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local platform_fb_login_command_terminal = {
            _name = "platform_fb_login_command",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("notification_center_update", 0, "push_notification_facebook")
                        state_machine.excute("platform_fb_home_page_updata", 0, "platform_fb_home_page_updata.")
                    end
                end
                protocol_command.fb_login_init.param_list = m_my_fb_id
                NetworkManager:register(protocol_command.fb_login_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local platform_fb_home_page_updata_terminal = {
            _name = "platform_fb_home_page_updata",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local items = instance.listView:getItems()
                if items ~= nil then
                    for k,v in pairs(items) do
                        state_machine.excute("platform_fb_list_update", 0, v)
                    end
                end 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local platform_fb_info_command_terminal = {
            _name = "platform_fb_info_command",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:completeFbTask(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(platform_fb_info_command_terminal)
        state_machine.add(platform_fb_home_page_updata_terminal)
        state_machine.add(platform_fb_login_command_terminal)
        state_machine.add(platform_fb_goto_home_page_terminal)
        state_machine.init()
    end
    
    init_platform_fb_method_terminal()
end

function platformFbMethod:completeFbTask( _type )
    local curtype = _type
    local command_info = ""
    if curtype == 2 then
        command_info = m_aladion_facebook_invite
    else
        command_info = m_my_fb_id
    end
    command_info = command_info.."\r\n"..curtype
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("notification_center_update", 0, "push_notification_facebook")
            state_machine.excute("platform_fb_home_page_updata", 0, "platform_fb_home_page_updata.")
            if fwin:find("platformFbFriendInviteClass") ~= nil then
                state_machine.excute("after_invite_update_list", 0, "after_invite_update_list.")
            end
        end
    end
    protocol_command.complete_fb_task.param_list = command_info
    NetworkManager:register(protocol_command.complete_fb_task.code, nil, nil, nil, instance, responseCallback, false, nil)
end

function platformFbMethod:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function platformFbMethod:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function platformFbMethod:onUpdateDraw()
	local root = self.roots[1]
	local ListView_jiangli = ccui.Helper:seekWidgetByName(root, "ListView_jiangli")
    ListView_jiangli:removeAllItems()
    self.listView = ListView_jiangli
    local fb_datas = dms['fb_share_reward']
    for i = 1 ,#fb_datas do
        local cell = platformFblist:createCell()
        cell:init(fb_datas[i])
        ListView_jiangli:addChild(cell)
    end 
end

function platformFbMethod:onEnterTransitionFinish()
	local csbplatformFbMethod = csb.createNode(config_csb.abroad.facebook_jiangli)
	self:addChild(csbplatformFbMethod)
	local root = csbplatformFbMethod:getChildByName("root")
	table.insert(self.roots, root)
	
	local Button_back = ccui.Helper:seekWidgetByName(root, "Button_back")
	fwin:addTouchEventListener(Button_back, nil, 
        {
            terminal_name = "platform_fb_method_close", 
            terminal_state = 0, 
            status = false,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    local Button_jinruzhuye = ccui.Helper:seekWidgetByName(root, "Button_jinruzhuye")
    fwin:addTouchEventListener(Button_jinruzhuye, nil, 
        {
            terminal_name = "platform_fb_goto_home_page", 
            terminal_state = 0, 
            status = false,
            isPressedActionEnabled = true
        }, 
        nil, 0)
	self:onUpdateDraw()
end

function platformFbMethod:onInit()
	
end

function platformFbMethod:init()
	return self
end

function platformFbMethod:onExit()
    state_machine.remove("platform_fb_goto_home_page")
    state_machine.remove("platform_fb_login_command")
    state_machine.remove("platform_fb_info_command")
    state_machine.remove("platform_fb_home_page_updata")
end
