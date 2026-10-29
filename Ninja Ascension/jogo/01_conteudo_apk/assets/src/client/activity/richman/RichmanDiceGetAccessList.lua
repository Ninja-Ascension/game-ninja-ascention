--[[ ----------------------------------------------------------------------------
-- 可选奖励cell
--]] ----------------------------------------------------------------------------
RichmanDiceGetAccessList = class("RichmanDiceGetAccessListClass", Window)
RichmanDiceGetAccessList.__size = nil

-- 创建Cell实例
local richman_dice_get_access_list_create_terminal = {
	_name = "richman_dice_get_access_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RichmanDiceGetAccessList then
			local cell = RichmanDiceGetAccessList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(richman_dice_get_access_list_create_terminal)
state_machine.init()

-- 构造器
function RichmanDiceGetAccessList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.pathInfo = {}

	-- load lua files.

	local function init_richman_dice_get_access_list_terminal()
		local richman_dice_get_access_list_goto_terminal = {
            _name = "richman_dice_get_access_list_goto",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and params ~= nil then
                    local traceFunctionId = params._datas.functionID
					local openFunctionId = dms.int(dms["function_param"], traceFunctionId, function_param.open_function)
					if openFunctionId <= 0 or dms.int(dms["fun_open_condition"], openFunctionId, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
						state_machine.excute("shortcut_function_trace", 0, {trace_function_id = traceFunctionId, _datas = {}})
						state_machine.excute("richman_dice_get_access_window_close", 0, nil)
					else
						TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], openFunctionId, fun_open_condition.tip_info))
					end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(richman_dice_get_access_list_goto_terminal)
		state_machine.init()
	end
	
	init_richman_dice_get_access_list_terminal()
end


-- 对象初始化
function RichmanDiceGetAccessList:init(params)
   self.pathInfo = params
   -- self.funcID = dms.int(dms["achieve"], self.taskInfo.achieveID, achieve.track_address)
	self:onInit(params)
	self:setContentSize(RichmanDiceGetAccessList.__size)
	return self
end

function RichmanDiceGetAccessList:updateUI()
    
end

function RichmanDiceGetAccessList:onUpdateDraw()
	local root = self.roots[1]

	-- 途径文本信息
	self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")

	-- 倒计时
	self.Text_3 = ccui.Helper:seekWidgetByName(root, "Text_3")
    
	-- 前往
	self.Button_4 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, {
        terminal_name = "richman_dice_get_access_window_close",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 2)

	self:updateUI()
end

function RichmanDiceGetAccessList:onEnterTransitionFinish()
	
end

function RichmanDiceGetAccessList:onInit(params)

	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/dafuweng/dafuweng_tujing_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RichmanDiceGetAccessList.__size == nil then
		RichmanDiceGetAccessList.__size = root:getContentSize()
	end

    -- 选择按钮    如果不可以选择，不能点击按钮
    if self.canChoose == true then
        self.Panel_icon = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_icon"), nil,
        {
            terminal_name = "richman_dice_get_access_idx",
            terminal_state = 0,
            isPressedActionEnabled = true,
            chooseDdx = self.curIndex,
        }, nil, 0)	
    end

	self:onUpdateDraw()
end

function RichmanDiceGetAccessList:onExit()
	-- 释放LimPoolRewardListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/dafuweng/dafuweng_tujing_list.csb", root)
	-- ]]
end

function RichmanDiceGetAccessList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RichmanDiceGetAccessList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/dafuweng/dafuweng_tujing_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
