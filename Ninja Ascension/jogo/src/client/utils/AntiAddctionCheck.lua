-- ----------------------------------------------------------------------------------------------------
-- 说明：防沉迷弹出
-- 创建时间
-- 作者：
-- 修改记录：
-------------------------------------------------------------------------------------------------------
AntiAddctionCheck = class("AntiAddctionCheckClass", Window)

local anti_addction_check_open_terminal = {
    _name = "anti_addction_check_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("AntiAddctionCheckClass") == nil then
            local win_anti = AntiAddctionCheck:new()
            win_anti:init()
            fwin:open(win_anti,fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(anti_addction_check_open_terminal)
state_machine.init()
function AntiAddctionCheck:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize ConfirmTip state machine.
    local function init_anti_addction_check_terminal()
		-- 界面确定按钮
        local anti_addction_check_ok_terminal = {
            _name = "anti_addction_check_ok",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
               
                fwin:reset(nil)
                cacher.destoryRefPools()
                cacher.cleanSystemCacher()
                cacher.cleanActionTimeline()
                
                cacher.remvoeUnusedArmatureFileInfoes()
                fwin:open(Login:new(), fwin._view)
                _ED.m_is_games = false
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(anti_addction_check_ok_terminal)
        state_machine.init()
    end
    
    -- call func init ConfirmTip state machine.
    init_anti_addction_check_terminal()
end

function AntiAddctionCheck:onEnterTransitionFinish()
   
end

function AntiAddctionCheck:onInit()
    local csbAnti = csb.createNode("utils/tuichu_fangchenmi.csb")
    self:addChild(csbAnti)
    local root = csbAnti:getChildByName("root")
    table.insert(self.roots, root )
    --提示文本
    local Button_ok = ccui.Helper:seekWidgetByName(root, "Button_53281")

    fwin:addTouchEventListener(Button_ok, nil, {
        terminal_name = "anti_addction_check_ok", 
        terminal_state = 1,
        taget = self,
        isPressedActionEnabled = true
    }, nil, 0)
    --去验证
    local Button_yanzheng = ccui.Helper:seekWidgetByName(root,"Button_53281_0")
    fwin:addTouchEventListener(Button_yanzheng, nil, {
        terminal_name = "anti_addction_loginin_open", 
        terminal_state = 1,
        from_type = "home",
        isPressedActionEnabled = true
    }, nil, 0)
    local Label_5324 = ccui.Helper:seekWidgetByName(root,"Label_5324")  
    local last_time = os.date("*t",math.floor(zstring.tonumber(_ED.last_can_login_time)/1000))
    Label_5324:setString(string.format(addction_string_info[3],last_time.hour,last_time.min,last_time.sec))
    
end
function AntiAddctionCheck:init()
    self:onInit()
end

function AntiAddctionCheck:onExit()
    state_machine.remove("anti_addction_check_ok")
end