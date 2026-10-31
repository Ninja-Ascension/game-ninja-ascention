--[[ ----------------------------------------------------------------------------
-- home弹窗动画
--]] ----------------------------------------------------------------------------
HomeTips = class("HomeTipsClass", Window)
HomeTips.__size = nil

-- 创建Cell实例
local home_tips_to_get_list_create_terminal = {
	_name = "home_tips_to_get_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if HomeTips then
			local cell = HomeTips:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(home_tips_to_get_list_create_terminal)
state_machine.init()

-- 构造器
function HomeTips:ctor()
	self.super:ctor()
	self.roots = {}
    self.action = nil

	-- var
	self._taskInfo = nil
	self._remainBuyTimes = 0
	self._buyPropCost = 0

	-- load lua files.

	-- Initialize state machine.
	local function init_home_tips_to_get_list_terminal()
		-- 显示视图
		local home_tips_to_show_view_terminal = {
			_name = "home_tips_to_show_view",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:setVisible(true)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(home_tips_to_show_view_terminal)
	end
	-- call func state machine.
	init_home_tips_to_get_list_terminal()
end

-- 对象初始化
function HomeTips:init(params)
	
	self:onInit(params)
	self:setContentSize(HomeTips.__size)
	return self
end

function HomeTips:onUpdateDraw()
	local root = self.roots[1]

    local Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")
    -- Text_tip:setVisible(false)
    if Text_tip ~= nil then
        if home_duplicate_tips_info ~= nil then
            local lastOpenNpc = 0
            for k,v in pairs(_ED.npc_state) do
                if tonumber(v) == 0 then
                    lastOpenNpc = k
                    break
                end
            end
            for k,v in pairs(home_duplicate_tips_info) do
                if tonumber(v[1]) > lastOpenNpc then
                    Text_tip:setString(v[2])
                    break
                end
            end
        end
    end
end

function HomeTips:onEnterTransitionFinish()
	
end

function HomeTips:onInit(params)
    local csbNode = csb.createNode("home/home_tips.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

    local action = csb.createTimeline("home/home_tips.csb")
    csbNode:runAction(action)
	self.action = action
	-- -- [[ 使用缓存创建
	-- local root = cacher.createUIRef("home/home_tips.csb", "root")
	-- -- ]]
	-- root:removeFromParent(false)
	-- table.insert(self.roots, root)
	-- self:addChild(root)
	if HomeTips.__size == nil then
		HomeTips.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function HomeTips:onExit()
	
	-- [[ 释放缓存
	local root = self.roots[1]
	-- cacher.freeRef("home/home_tips.csb", root)
	-- ]]
end

function HomeTips:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	-- self:onInit()
end

function HomeTips:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	-- self:stopAllActions()
	-- root:removeFromParent(false)
	-- cacher.freeRef("home/home_tips.csb", root)
	
	-- self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
