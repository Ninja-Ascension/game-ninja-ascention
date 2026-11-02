--[[ ----------------------------------------------------------------------------
-- 神兽页签左侧icon cell
--]] ----------------------------------------------------------------------------
MythicalAnimalsIconCell = class("MythicalAnimalsIconCellClass", Window)
MythicalAnimalsIconCell.__size = nil

-- 创建Cell实例
local mythical_animals_icon_cell_create_terminal = {
	_name = "mythical_animals_icon_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if MythicalAnimalsIconCell then
			local cell = MythicalAnimalsIconCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_icon_cell_create_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsIconCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_mythical_animals_icon_cell_terminal()
		local mythical_animals_icon_cell_select_terminal = {
			_name = "mythical_animals_icon_cell_select",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				if cell then
					state_machine.excute("mythical_animals_refresh_ui", 0, cell._index)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(mythical_animals_icon_cell_select_terminal)
	end
	-- call func init ninja biographies0 cell state machine.
	init_mythical_animals_icon_cell_terminal()
end

-- 对象初始化
function MythicalAnimalsIconCell:init(params)
	-- 神兽信息
	self._data = params.data

	self._index = params.index

	-- 是否只显示 而不可点击
	self._isCanTouch = params.isCanTouch

	self:onInit(params)
	
	self:setContentSize(MythicalAnimalsIconCell.__size)
	return self
end

function MythicalAnimalsIconCell:onUpdateDraw()
	local root = self.roots[1]

	-- 选中
	fwin:removeTouchEventListener(self.Panel_animals_prop_box)
	if self._isCanTouch == true then
		self.Panel_animals_prop_box = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_animals_prop_box"), nil,
		{
			terminal_name = "mythical_animals_icon_cell_select",
			terminal_state = 0,
			isPressedActionEnabled = true,
			_self = self
		}, nil, 0)	
	end

	-- 底图
	self.Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	-- 图标
	self.Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	self.Panel_prop:setTouchEnabled(false)
	-- 数量
	self.Text_num = ccui.Helper:seekWidgetByName(root, "Text_num")
	-- 选中光效
	self.Image_select = ccui.Helper:seekWidgetByName(root, "Image_select")

	-- 阶数
	self.Image_stage = {}
	for i = 1, 6 do
		table.insert(self.Image_stage, ccui.Helper:seekWidgetByName(root, "Image_stage_"..i))
	end
	-- 锁
	self.Image_lock = ccui.Helper:seekWidgetByName(root, "Image_lock")
	-- 已装备
	self.Image_employed = ccui.Helper:seekWidgetByName(root, "Image_employed")
	-- 可升星
	self.Image_starUp = ccui.Helper:seekWidgetByName(root, "Image_starUp")
	--可解锁
	self.Image_unlock = ccui.Helper:seekWidgetByName(root, "Image_unlock")
	--红点
	self.Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")

	self.Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")

	self.Panel_stage = ccui.Helper:seekWidgetByName(root, "Panel_stage")

	-- 限定神兽标签挂载控件
	self.Panel_effect_sp_1 = ccui.Helper:seekWidgetByName(root, "Panel_effect_sp_1")

	self:updateUI()
end

function MythicalAnimalsIconCell:updateUI()
	local data = self._data

	local animalsId = dms.atof(data, magical_animals_mould.id)
	local quality = dms.atof(data, magical_animals_mould.quality)
	local icon_index = dms.atof(data, magical_animals_mould.picIndex)

	local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(animalsId)
	local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(animalsId)

	local Panel_ditu = self.Panel_ditu
	Panel_ditu:removeBackGroundImage()
	Panel_ditu:removeAllChildren(true)

	local animalsInfo = MythicalAnimalsHandle.getMythicalAnimalsInfoById(animalsId)

	local sp = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", quality + 1))
	sp:setPosition(cc.p(Panel_ditu:getContentSize().width/2, Panel_ditu:getContentSize().height/2))
	if animalsInfo == nil then
		display:gray(sp)
	else
		display:ungray(sp)
	end
	Panel_ditu:addChild(sp)

	local Panel_prop = self.Panel_prop
	Panel_prop:removeBackGroundImage()
	Panel_prop:removeAllChildren(true)

	local sp1 = cc.Sprite:create(string.format("images/ui/props/props_%d.png", icon_index))
	sp1:setPosition(cc.p(Panel_prop:getContentSize().width/2, Panel_prop:getContentSize().height/2))
	if animalsInfo == nil then
		display:gray(sp1)
	else
		display:ungray(sp1)
	end
	Panel_prop:addChild(sp1)

	-- 阶数
	if curStage > 0 then
		self.Panel_stage:setVisible(true)
		for i, v in ipairs(self.Image_stage) do
			v:setVisible(i == (curStage + 1))
		end
	else
		self.Panel_stage:setVisible(false)
	end

	-- 星级
	self.Panel_star:removeAllChildren(true)
	if curStar > 0 then
		self.Panel_star:setVisible(true)
		neWshowShipStar(self.Panel_star , curStar)
	else
		self.Panel_star:setVisible(false)
	end

	self.Image_lock:setVisible(false)
	self.Image_employed:setVisible(false)
	self.Image_starUp:setVisible(false)
	self.Image_unlock:setVisible(false)
	self.Image_red:setVisible(false)

	if animalsInfo == nil then
		-- 可激活
		if MythicalAnimalsHandle.canMythicalAnimalsUpStar(animalsId, 0) then
			self.Image_unlock:setVisible(true)
		else
			self.Image_lock:setVisible(true)
		end
	else
		local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(animalsId)
		if MythicalAnimalsHandle.canMythicalAnimalsUpStar(animalsId, curStar) then
			self.Image_starUp:setVisible(true)
		end
		if MythicalAnimalsHandle.isEquipAnimalSkill(animalsId) then
			self.Image_employed:setVisible(true)
		end
	end

	if self._isCanTouch == true then
		local isShowRed = MythicalAnimalsHandle.showMythicalAnimalsRedDotById(animalsId)
		self.Image_red:setVisible(isShowRed)
	else
		self.Image_starUp:setVisible(false)
		self.Image_employed:setVisible(false)
	end

	-- 限定神兽标签
	if self.Panel_effect_sp_1 then 
		self.Panel_effect_sp_1:removeAllChildren(true)
		self.Panel_effect_sp_1:setVisible(false)
		DisplayLimitAnimal(animalsId, nil, self.Panel_effect_sp_1, 1)
	end
end

function MythicalAnimalsIconCell:setSelectState(isShow)
	self.Image_select:setVisible(isShow)
end

function MythicalAnimalsIconCell:onInit(params)
	-- 加载MythicalAnimalsIconCellWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_item = res/cultivate/Mythical_animals/mythical_animals_item.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_item.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/Mythical_animals/mythical_animals_item.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if MythicalAnimalsIconCell.__size == nil then
		MythicalAnimalsIconCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function MythicalAnimalsIconCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	self.Panel_ditu:removeAllChildren(true)
	self.Panel_ditu:removeBackGroundImage()

	self.Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	self.Panel_prop:removeAllChildren(true)
	self.Panel_prop:removeBackGroundImage()

	self.Text_num = ccui.Helper:seekWidgetByName(root, "Text_num")
	self.Text_num:setString("")

	self.Image_select = ccui.Helper:seekWidgetByName(root, "Image_select")
	self.Image_select:setVisible(false)

	self.Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
	self.Panel_star:setVisible(false)

	self.Panel_stage = ccui.Helper:seekWidgetByName(root, "Panel_stage")
	self.Panel_stage:setVisible(false)

	self.Image_lock = ccui.Helper:seekWidgetByName(root, "Image_lock")
	self.Image_lock:setVisible(false)

	self.Image_employed = ccui.Helper:seekWidgetByName(root, "Image_employed")
	self.Image_employed:setVisible(false)

	self.Image_starUp = ccui.Helper:seekWidgetByName(root, "Image_starUp")
	self.Image_starUp:setVisible(false)

	self.Image_unlock = ccui.Helper:seekWidgetByName(root, "Image_unlock")
	self.Image_unlock:setVisible(false)

	self.Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")
	self.Image_red:setVisible(false)
	-- 限定神兽标签挂载控件清除
	if self.Panel_effect_sp_1 then 
		self.Panel_effect_sp_1 = ccui.Helper:seekWidgetByName(root, "Panel_effect_sp_1")
		self.Panel_effect_sp_1:removeAllChildren(true)
		self.Panel_effect_sp_1:setVisible(false)
	end
end

function MythicalAnimalsIconCell:onExit()
	-- 释放MythicalAnimalsIconCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_item.csb", root)
	-- ]]
end

function MythicalAnimalsIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MythicalAnimalsIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_item.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
