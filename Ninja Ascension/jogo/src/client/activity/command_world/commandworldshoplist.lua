--[[ ----------------------------------------------------------------------------
-- 道具购买
--]] ----------------------------------------------------------------------------
CommandWorldShopList = class("CommandWorldShopListClass", Window)
CommandWorldShopList.__size = nil

-- 创建Cell实例
local command_world_shop_list_create_terminal = {
	_name = "command_world_shop_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if CommandWorldShopList then
			local cell = CommandWorldShopList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_shop_list_create_terminal)
state_machine.init()

-- 构造器
function CommandWorldShopList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize command world shop list page state machine.
	local function init_command_world_shop_list_terminal()
		-- 购买
		local command_world_shop_list_buy_terminal = {
			_name = "command_world_shop_list_buy",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local data = params._datas.data
				state_machine.excute("command_world_buy_window_open", 0, data)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(command_world_shop_list_buy_terminal)
	end
	-- call func init command world shop list state machine.
	init_command_world_shop_list_terminal()
end

-- 对象初始化
function CommandWorldShopList:init(params)
	self._data = params

	self:onInit(params)
	self:setContentSize(CommandWorldShopList.__size)
	return self
end

function CommandWorldShopList:updateUI()
	local data = self._data

	local exchangePropStr = zstring.splits(data.exchangeProp, "|", ",")
	local exchangeProp = exchangePropStr[1]

	local cell = self:addResourcesIconCell(exchangeProp)
	self.Panel_6:removeAllChildren(true)
	self.Panel_6:addChild(cell)

	local exchangePropId = tonumber(exchangeProp[2])

	local name = getItemNameAndQuality(exchangeProp)[1]
	self.Text_name:setString(name)

	local quality = getItemNameAndQuality(exchangeProp)[2]
	self.Text_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))

	local remainTimes = tonumber(data.maxNumber) - tonumber(data.currentNumber)
	self.Image_sell_out:setVisible(remainTimes <= 0)
	self.Text_1:setString(string.format(tipStringInfo_command_world[5], remainTimes))
	
	self.Button_buy:setTouchEnabled(remainTimes > 0)
	self.Button_buy:setBright(remainTimes > 0)

	-- 消耗图标的显示
	local costPropDatas = zstring.splits(dms.string(dms["activity_config"], 76, activity_config.param), "|", ",")

	local needPropStr = zstring.splits(data.needProp, "|", ",")
	local needPropType = tonumber(needPropStr[1][1])
	local needPropId = tonumber(needPropStr[1][2])
	local needPropCount = tonumber(needPropStr[1][3])

	self.Text_own:setString(needPropCount)

	for i, v in ipairs(self.Image) do
		if i <= 3 and tonumber(costPropDatas[i][2]) == needPropId then
			v:setVisible(true)
		else
			v:setVisible(false)
		end
	end
	
	if needPropType == 2 then
		self.Image[4]:setVisible(true)
	end
end

function CommandWorldShopList:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
	end
	return cell
end

function CommandWorldShopList:onUpdateDraw()
	local root = self.roots[1]

	self.Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")

	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	self.Image_sell_out = ccui.Helper:seekWidgetByName(root, "Image_sell_out")
	self.Text_own = ccui.Helper:seekWidgetByName(root, "Text_own")

	self.Image = {}
	for i = 1, 4 do
		local Image = ccui.Helper:seekWidgetByName(root, "Image_"..i)
		table.insert(self.Image, Image)
	end
	
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	
	-- 购买
	self.Button_buy = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy"), nil,
	{
		terminal_name = "command_world_shop_list_buy",
		terminal_state = 0,
		isPressedActionEnabled = true,
		data = self._data,
	}, nil, 0)

	self:updateUI()
end

function CommandWorldShopList:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
	self.Panel_6:removeAllChildren(true)

	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	self.Text_name:setString("")

	self.Image_sell_out = ccui.Helper:seekWidgetByName(root, "Image_sell_out")
	self.Image_sell_out:setVisible(false)

	self.Text_own = ccui.Helper:seekWidgetByName(root, "Text_own")
	self.Text_own:setString("")

	for i = 1, 4 do
		local Image = ccui.Helper:seekWidgetByName(root, "Image_"..i)
		Image:setVisible(false)
	end
	
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	self.Text_1:setString("")
end

function CommandWorldShopList:onEnterTransitionFinish()
	
end

function CommandWorldShopList:onInit(params)
	-- 加载CommandWorldShopListWindow界面资源.
	-- res.activity.command_world.command_world_shop_list = res/activity/command_world/command_world_shop_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/command_world/command_world_shop_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/command_world/command_world_shop_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if CommandWorldShopList.__size == nil then
		CommandWorldShopList.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function CommandWorldShopList:onExit()
	-- 释放CommandWorldShopListWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/command_world/command_world_shop_list.csb", root)
	-- ]]
end

function CommandWorldShopList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CommandWorldShopList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/command_world/command_world_shop_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
