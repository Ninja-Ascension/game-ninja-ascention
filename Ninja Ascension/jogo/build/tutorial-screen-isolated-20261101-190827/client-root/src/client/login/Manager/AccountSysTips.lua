-- ----------------------------------------------------------------------------------------------------
-- 说明：自己的账号提示界面
-------------------------------------------------------------------------------------------------------
AccountSysTips = class("AccountSysTipsClass", Window)
local account_sys_tips_open_terminal = {
    _name = "account_sys_tips_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local _window = fwin:find("AccountSysTipsClass")
        if _window == nil then
			local panel = AccountSysTips:new():init(params)
			fwin:open(panel,fwin._windows)
		else
			fwin:close(fwin:find("AccountSysTipsClass"))
			local panel = AccountSysTips:new():init(params)
			fwin:open(panel,fwin._windows)
        end
    	return true
    end,
    _terminal = nil,
    _terminals = nil
}

local account_sys_tips_close_terminal = {
	_name = "account_sys_tips_close",
	_init = function (terminal)

	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("AccountSysTipsClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(account_sys_tips_open_terminal)
state_machine.add(account_sys_tips_close_terminal)
state_machine.init()
    
function AccountSysTips:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
	
    local function init_sm_player_change_nick_name_terminal()

        
        state_machine.init()
    end
    
    init_sm_player_change_nick_name_terminal()
end


function AccountSysTips:onUpdataDraw()
	local root = self.roots[1]
	local Text_account_tips = ccui.Helper:seekWidgetByName(root,"Text_account_tips")
	Text_account_tips:setString(self.tipInfo)
	
	self:runAction(cc.Sequence:create({cc.DelayTime:create(1), cc.CallFunc:create(function ( sender )
		state_machine.excute("account_sys_tips_close", 0, "account_sys_tips_close")
	end)}))
end

function AccountSysTips:onInit()
	local csbUserInfo = csb.createNode("login/register/register_prompt_5.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)
	root:setPositionX((fwin._width - app.baseOffsetX)/2)
	root:setPositionY((fwin._height - app.baseOffsetY)-root:getContentSize().height)
	self:onUpdataDraw()
end

function AccountSysTips:init(str)
	self.tipInfo = str
	self:onInit()
	return self
end

function AccountSysTips:onExit()
end
