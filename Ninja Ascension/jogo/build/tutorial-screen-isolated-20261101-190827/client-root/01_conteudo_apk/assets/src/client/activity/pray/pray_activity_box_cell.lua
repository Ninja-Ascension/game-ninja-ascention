--[[ ----------------------------------------------------------------------------
-- 祈福活动
-- 祈福值宝箱
--]] ----------------------------------------------------------------------------
PrayActivityBoxCell = class("PrayActivityBoxCellClass", Window)
PrayActivityBoxCell.__size = nil

-- 创建Cell实例
local pray_activity_box_cell_create_terminal = {
	_name = "pray_activity_box_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if PrayActivityBoxCell then
			local cell = PrayActivityBoxCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(pray_activity_box_cell_create_terminal)
state_machine.init()

-- 构造器
function PrayActivityBoxCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._boxInfo = nil
	-- load lua files.
	app.load("client.activity.pray.PrayActivityBoxTip")
	-- Initialize pray activity box cell page state machine.
	local function init_pray_activity_box_cell_terminal()
		-- 开启宝箱
		local pray_activity_box_cell_open_terminal = {
			_name = "pray_activity_box_cell_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= params then
					local mCell = params._datas.m_cell
					local boxInfo = mCell._boxInfo
					state_machine.excute("activity_pray_box_tip_create",0,{mIndex = boxInfo.boxIdx,rewardInfos = boxInfo.boxReward,state = boxInfo.boxState,aim = boxInfo.boxAim})
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(pray_activity_box_cell_open_terminal)
		state_machine.init()
	end
	-- call func init pray activity box cell state machine.
	init_pray_activity_box_cell_terminal()
end

-- 对象初始化
function PrayActivityBoxCell:init(params)
	self._boxInfo = params.boxInfo
	self:onInit(params)
	self:setContentSize(PrayActivityBoxCell.__size)
	return self
end

function PrayActivityBoxCell:onUpdateDraw()
	local root = self.roots[1]

	-- 普通宝箱显示容器
	self.Panel_bule_box = ccui.Helper:seekWidgetByName(root, "Panel_bule_box")
	self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
	self.Panel_effect:removeAllChildren()
	-- 普通宝箱已领取状态
	self.Image_bule_received = ccui.Helper:seekWidgetByName(root, "Image_bule_received")
	self.Image_bule_received:setVisible(false)
	-- 普通宝箱正常状态
	self.Image_bule_normal = ccui.Helper:seekWidgetByName(root, "Image_bule_normal")
	self.Image_bule_normal:setVisible(false)
	-- 普通宝箱可领取状态
	self.Image_bule_Available = ccui.Helper:seekWidgetByName(root, "Image_bule_Available")
	self.Image_bule_Available:setVisible(false)
	-- 祈愿目标值
	self.Text_xuyuanzhi = ccui.Helper:seekWidgetByName(root, "Text_xuyuanzhi")
	self.Text_xuyuanzhi:setString(self._boxInfo.boxAim)
	if tonumber(self._boxInfo.boxState) == 0 then 
		self.Image_bule_normal:setVisible(true)
	elseif tonumber(self._boxInfo.boxState) == 1 then
		self.Image_bule_Available:setVisible(true)
		self:playAnimations(self.Panel_effect)
	else
		self.Image_bule_received:setVisible(true)
	end

end

function PrayActivityBoxCell:playAnimations(sender)
    sender:removeAllChildren()
    local jsonFile = "images/ui/effice/effect_xianshiqiyuan_box/effect_xianshiqiyuan_box.json"
    local atlasFile = "images/ui/effice/effect_xianshiqiyuan_box/effect_xianshiqiyuan_box.atlas"
    local aniName = "animation"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, true, nil)
    animation:setPosition(cc.p(sender:getContentSize().width/2, 0))
    sender:addChild(animation)
end

function PrayActivityBoxCell:onEnterTransitionFinish()
	
end

function PrayActivityBoxCell:onInit(params)
	-- 加载PrayActivityBoxCellWindow界面资源.
	-- res.activity.Pray.Pray_box = res/activity/Pray/Pray_box.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/Pray/Pray_box.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/Pray/Pray_box.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if PrayActivityBoxCell.__size == nil then
		PrayActivityBoxCell.__size = root:getContentSize()
	end

	-- 宝箱领取按钮
	self.Button_receive = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_receive"), nil,
	{
		terminal_name = "pray_activity_box_cell_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
		m_cell = self,
	}, nil, 0)	


	self:onUpdateDraw()
end

function PrayActivityBoxCell:onExit()
	-- 释放PrayActivityBoxCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/Pray/Pray_box.csb", root)
	-- ]]
end

function PrayActivityBoxCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PrayActivityBoxCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/Pray/Pray_box.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
