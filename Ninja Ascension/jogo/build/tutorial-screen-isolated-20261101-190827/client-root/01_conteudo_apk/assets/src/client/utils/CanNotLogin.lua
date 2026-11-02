-- ----------------------------------------------------------------------------------------------------
-- 说明：账号被封停
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-- 时间 : 
-------------------------------------------------------------------------------------------------------

CanNotLogin = class("CanNotLoginClass", Window)
local can_not_login_open_terminal = {
    _name = "can_not_login_open",
    _init = function (terminal) 
    	
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
   		local win = CanNotLogin:new()
   		win:init()
   		fwin:open(win,fwin._system)
        return true
    end,
    _terminal = nil,
    _terminals = nil
} 

state_machine.add(can_not_login_open_terminal)  
state_machine.init()
function CanNotLogin:ctor()
    self.super:ctor()
    self.roots = {}
    self._endTime = nil      -- 解封时间
    self._text = nil
    self.deltaTime = 1
    self.totalTime = 0
    self.updateFlag = false
    
   local function init_can_not_login_terminal()
		-- 界面确定按钮
        local can_not_login_ok_terminal = {
            _name = "can_not_login_ok",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                NetworkView:connectingErase()
            	fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(can_not_login_ok_terminal)  
        state_machine.init()
    end
    
    -- call func init LoginOfOtherTip state machine.
    init_can_not_login_terminal()    
end

function CanNotLogin:onUpdate(dt)
    if self.updateFlag then 
        self.totalTime = self.totalTime + dt
        if self.totalTime >= self.deltaTime then
            self.totalTime = 0
            if self.Label_5324 then 
                self:refushDownUpdate()
            end
        end
    end
end

-- 封号倒计时的刷新
function CanNotLogin:refushDownUpdate()
    if self._endTime and self._endTime ~= -1 then 
        local surplus_time = (self._endTime - ((os.time() + _ED.time_add_or_sub))*1000)
        self.Label_5324:setString(string.format(tipStringInfo_account_closure[1],surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time)))
   end
end

function CanNotLogin:drawTime(_time)
	local timeString = ""
	local _dayTime = math.floor((_time / 1000) / 86400)
	local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
	local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
	local _secondsTime = math.floor((_time / 1000) % 60)
	if _dayTime > 0 then
		timeString = timeString .. _dayTime .._string_piece_info[231]
	end
	if _hourTime < 10 then
		timeString = timeString .. "0".._hourTime ..":"
	else
		timeString = timeString .. _hourTime ..":"
	end

	if _minutesTime < 10 then
		timeString = timeString .. "0".._minutesTime ..":"
	else
		timeString = timeString .. _minutesTime ..":"
	end

	if _secondsTime < 10 then
		timeString = timeString .. "0".._secondsTime 
	else
		timeString = timeString .. _secondsTime 
	end
	return timeString
end

function CanNotLogin:onEnterTransitionFinish()
    local csbLoginOfOtherTip = csb.createNode("utils/tuichu_zhanghao.csb")
    self:addChild(csbLoginOfOtherTip)
    local root = csbLoginOfOtherTip:getChildByName("root")
    table.insert(self.roots,root)
    self.Label_5324 = ccui.Helper:seekWidgetByName(root, "Label_5324*")
    self.Label_5324:setString("")

    local function callback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            self._endTime = tonumber(_ED.user_ban_end_time)
            self:onUpdateDraw()
        end
    end
    protocol_command.get_user_ban_time.param_list = ""
    NetworkManager:register(protocol_command.get_user_ban_time.code, nil, nil, nil, nil, callback, false, nil)
	
end

function CanNotLogin:onUpdateDraw( )
    local root = self.roots[1]
    self.Label_5324 = ccui.Helper:seekWidgetByName(root, "Label_5324*")
    if self._endTime == -1 then 
        self.Label_5324:setString(tipStringInfo_account_closure[2])
    else
        self.updateFlag = true
        self:refushDownUpdate()
    end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5328"), nil, 
	{
		terminal_name = "can_not_login_ok", 
		terminal_state = 1,
		taget = self,
		isPressedActionEnabled = true
	}, nil, 0)
end


function CanNotLogin:init()
    return self
end

function CanNotLogin:onExit()
	state_machine.remove("can_not_login_ok")
end