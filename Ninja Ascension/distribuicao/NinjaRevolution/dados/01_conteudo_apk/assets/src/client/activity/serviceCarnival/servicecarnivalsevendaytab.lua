--[[ ----------------------------------------------------------------------------
-- 任务类型按钮列表容器cell
--]] ----------------------------------------------------------------------------
ServiceCarnivalSevendayTab = class("ServiceCarnivalSevendayTabClass", Window)
ServiceCarnivalSevendayTab.__size = nil

-- 创建Cell实例
local service_carnival_sevenday_tab_create_terminal = {
	_name = "service_carnival_sevenday_tab_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if ServiceCarnivalSevendayTab then
			local cell = ServiceCarnivalSevendayTab:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(service_carnival_sevenday_tab_create_terminal)
state_machine.init()

-- 构造器
function ServiceCarnivalSevendayTab:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
    self.m_type = 1         -- 任务类型
	-- load lua files.

	-- Initialize service carnival sevenday list page state machine.
	local function init_service_carnival_sevenday_tab_terminal()
		local service_carnival_sevenday_tab_change_terminal = {
            _name = "service_carnival_sevenday_tab_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(service_carnival_sevenday_tab_change_terminal)
        state_machine.init()
	end
	-- call func init service carnival sevenday list state machine.
	init_service_carnival_sevenday_tab_terminal()
end

-- 对象初始化
function ServiceCarnivalSevendayTab:init(params)
    self.m_type = params.type
	self:onInit(params)
	self:setContentSize(ServiceCarnivalSevendayTab.__size)
	return self
end

function ServiceCarnivalSevendayTab:onUpdateDraw()
	local root = self.roots[1]
    
end

function ServiceCarnivalSevendayTab:onEnterTransitionFinish()
	
end

function ServiceCarnivalSevendayTab:onInit(params)
	-- 加载ServiceCarnivalSevendayTabWindow界面资源.
	-- res.activity.service_carnival.service_carnival_sevenday_tab = res/activity/service_carnival/service_carnival_sevenday_tab.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/service_carnival/service_carnival_sevenday_tab.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/service_carnival/service_carnival_sevenday_tab.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if ServiceCarnivalSevendayTab.__size == nil then
		ServiceCarnivalSevendayTab.__size = root:getContentSize()
	end

    self.Text_light = ccui.Helper:seekWidgetByName(root, "Text_light")

    self.Text_dark = ccui.Helper:seekWidgetByName(root, "Text_dark")

    self.Button_tab = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tab"), nil,
	{
		terminal_name = "",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:onUpdateDraw()
end

function ServiceCarnivalSevendayTab:onExit()
	-- 释放ServiceCarnivalSevendayTabWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/service_carnival/service_carnival_sevenday_tab.csb", root)
	-- ]]
end

function ServiceCarnivalSevendayTab:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ServiceCarnivalSevendayTab:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/service_carnival/service_carnival_sevenday_tab.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
