--[[ ----------------------------------------------------------------------------
-- @class
--]] ----------------------------------------------------------------------------
FightSpiritQianghuaSx = class("FightSpiritQianghuaSxClass", Window)

-- 打开窗口
local fight_spirit_qianghua_sx_window_open_terminal = {
	_name = "fight_spirit_qianghua_sx_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritQianghuaSxClass") then
			fwin:open(FightSpiritQianghuaSx:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_qianghua_sx_window_close_terminal = {
	_name = "fight_spirit_qianghua_sx_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritQianghuaSxClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_qianghua_sx_window_open_terminal)
state_machine.add(fight_spirit_qianghua_sx_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritQianghuaSx:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit qianghua sx page state machine.
	local function init_fight_spirit_qianghua_sx_terminal()
		
	end
	-- call func init fight spirit qianghua sx state machine.
	init_fight_spirit_qianghua_sx_terminal()
end

-- 对象初始化
function FightSpiritQianghuaSx:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritQianghuaSx:onInit(params)
	--筛选高级魂石，中级魂石，低级魂石，红色，橙色，紫色，蓝色，绿色
	local filterParams = readKey("fight_spirit_sx_params")
	if filterParams == "" then
		self.filterParams = {1,1,1,1,1,1,1,1}
	else
		self.filterParams = zstring.split(filterParams, ",", function (value)
			return tonumber(value)
		end)
	end
end

function FightSpiritQianghuaSx:onUpdateDraw()
	local root = self.roots[1]

	
end

function FightSpiritQianghuaSx:onEnterTransitionFinish()
	-- 加载FightSpiritQianghuaSxWindow界面资源.
	-- res.cocostudio.packs.FightSpirit_qianghua_sx = res/packs/FightSpirit/FightSpirit_qianghua_sx.csb
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_qianghua_sx.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	local function onOpenTouchEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            self:click(sender)
        end
    end

    ccui.Helper:seekWidgetByName(root, "CheckBox_h").types = 1
    ccui.Helper:seekWidgetByName(root, "CheckBox_m").types = 2
    ccui.Helper:seekWidgetByName(root, "CheckBox_l").types = 3
    ccui.Helper:seekWidgetByName(root, "CheckBox_red").types = 4
    ccui.Helper:seekWidgetByName(root, "CheckBox_orange").types = 5
    ccui.Helper:seekWidgetByName(root, "CheckBox_purple").types = 6
    ccui.Helper:seekWidgetByName(root, "CheckBox_blue").types = 7
    ccui.Helper:seekWidgetByName(root, "CheckBox_green").types = 8
    ccui.Helper:seekWidgetByName(root, "CheckBox_h"):addTouchEventListener(onOpenTouchEvent)
    ccui.Helper:seekWidgetByName(root, "CheckBox_m"):addTouchEventListener(onOpenTouchEvent)
    ccui.Helper:seekWidgetByName(root, "CheckBox_l"):addTouchEventListener(onOpenTouchEvent)
    ccui.Helper:seekWidgetByName(root, "CheckBox_red"):addTouchEventListener(onOpenTouchEvent)
    ccui.Helper:seekWidgetByName(root, "CheckBox_orange"):addTouchEventListener(onOpenTouchEvent)
    ccui.Helper:seekWidgetByName(root, "CheckBox_purple"):addTouchEventListener(onOpenTouchEvent)
    ccui.Helper:seekWidgetByName(root, "CheckBox_blue"):addTouchEventListener(onOpenTouchEvent)
    ccui.Helper:seekWidgetByName(root, "CheckBox_green"):addTouchEventListener(onOpenTouchEvent)
    ccui.Helper:seekWidgetByName(root, "CheckBox_h"):setSelected(self.filterParams[1] == 1)
    ccui.Helper:seekWidgetByName(root, "CheckBox_m"):setSelected(self.filterParams[2] == 1)
    ccui.Helper:seekWidgetByName(root, "CheckBox_l"):setSelected(self.filterParams[3] == 1)
    ccui.Helper:seekWidgetByName(root, "CheckBox_red"):setSelected(self.filterParams[4] == 1)
    ccui.Helper:seekWidgetByName(root, "CheckBox_orange"):setSelected(self.filterParams[5] == 1)
    ccui.Helper:seekWidgetByName(root, "CheckBox_purple"):setSelected(self.filterParams[6] == 1)
    ccui.Helper:seekWidgetByName(root, "CheckBox_blue"):setSelected(self.filterParams[7] == 1)
    ccui.Helper:seekWidgetByName(root, "CheckBox_green"):setSelected(self.filterParams[8] == 1)

    -- 关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_1_1"), nil,
	{
		terminal_name = "fight_spirit_qianghua_sx_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	local Button_qd = ccui.Helper:seekWidgetByName(root, "Button_qd")
	Button_qd:setPressedActionEnabled(true)
	Button_qd:addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local saveParams = ""
			for i,v in ipairs(self.filterParams) do
				saveParams = saveParams .. v
				if i ~= #self.filterParams then
					saveParams = saveParams .. ","
				end
			end
			writeKey("fight_spirit_sx_params", saveParams)
			state_machine.excute("fight_spirit_qianghua_filter", nil, {filterParams = self.filterParams})
			state_machine.excute("fight_spirit_qianghua_sx_window_close", nil, {})
		end
	end)

	self:onUpdateDraw()
end

function FightSpiritQianghuaSx:click(sender)
	if self.filterParams[sender.types] == 1 then
    	self.filterParams[sender.types] = 0
    else
    	self.filterParams[sender.types] = 1
    end
	-- sender:setSelected(self.filterParams[sender.types] == 1)
end

function FightSpiritQianghuaSx:onExit()
	-- 释放FightSpiritQianghuaSxWindow界面资源.
	
end

function FightSpiritQianghuaSx:close()
	-- window event : close.
	
end

function FightSpiritQianghuaSx:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
