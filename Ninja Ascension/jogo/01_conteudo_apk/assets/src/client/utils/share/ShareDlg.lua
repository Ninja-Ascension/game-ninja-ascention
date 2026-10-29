--------------------------------------------------------------------------------------------------------------
--  说明：分享
--  日期：15.11.06
--  创建：杨晗

--------------------------------------------------------------------------------------------------------------
ShareDlg = class("ShareDlgClass", Window)
--打开界面
local sharedlg_to_open_terminal = {
	_name = "sharedlg_to_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local share_id = params
		local _ShareDlg = ShareDlg:new()
		_ShareDlg:init(share_id)
		fwin:open( _ShareDlg,fwin._dialog)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sharedlg_to_close_terminal = {
	_name = "sharedlg_to_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ShareDlgClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sharedlg_to_open_terminal)
state_machine.add(sharedlg_to_close_terminal)
state_machine.init()

function ShareDlg:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	self.enum_type = {
	
	}

	self.share_id = 0
	 -- Initialize union duplicate seat machine.
    local function init_sharedlg_terminal()

		state_machine.init()
    end
    
    -- call func init union duplicate seat machine.
    init_sharedlg_terminal()

end

function ShareDlg:initDraw()
	
end

--初始化界面csb，点击事件
function ShareDlg:onInit()
	local csbShareDlg= csb.createNode("system/set_share.csb")
	
    self:addChild(csbShareDlg)
	local root = csbShareDlg:getChildByName("root")
	table.insert(self.roots, root)
	local action = csb.createTimeline("system/set_share.csb")
    table.insert(self.actions, action)
    csbShareDlg:runAction(action)
    action:play("window_open", false)
    -- local number = dms.int(dms["share_reward_mould"],1,share_reward_mould.share_type)
    local Text_dfdfdfdf = ccui.Helper:seekWidgetByName(root, "Text_dfdfdfdf")
  	local str = string.format(share_text[self.share_id][3],_ED.user_info.user_name,_ED.all_servers[_ED.selected_server].server_name)
    Text_dfdfdfdf:setString(str)
	local close_button = ccui.Helper:seekWidgetByName(root, "Button_close")
	fwin:addTouchEventListener(close_button, nil, 
    {
        terminal_name = "sharedlg_to_close", 
        terminal_state = 0,
		isPressedActionEnabled = true,
		share_id = self.share_id
    }, 
    nil, 0)
    app.load("client.system.share.ShareCenter")
    local share_button = ccui.Helper:seekWidgetByName(root, "Button_1265")
    fwin:addTouchEventListener(share_button, nil, 
    {
        terminal_name = "shareCenter_to_share", 
        terminal_state = 0,
		isPressedActionEnabled = true,
		share_id = self.share_id
    }, 
    nil, 0)
	self:initDraw()
	state_machine.unlock("shareCenter_to_getdata_and_open_share_dlg")
end

function ShareDlg:onEnterTransitionFinish()
	
end

function ShareDlg:init(_share_id)
	self.share_id = _share_id
	self:onInit()
	return self
end

function ShareDlg:onExit()
end