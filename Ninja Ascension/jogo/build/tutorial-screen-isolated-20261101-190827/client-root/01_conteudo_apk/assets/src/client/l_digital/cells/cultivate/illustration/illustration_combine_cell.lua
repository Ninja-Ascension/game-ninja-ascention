--[[ ----------------------------------------------------------------------------
-- 卡册列表控件
--]] ----------------------------------------------------------------------------
IllustrationCombineCell = class("IllustrationCombineCellClass", Window)
IllustrationCombineCell.__size = nil

-- 创建Cell实例
local illustration_combine_cell_create_terminal = {
	_name = "illustration_combine_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if IllustrationCombineCell then
			local cell = IllustrationCombineCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			cell:registerOnNoteUpdate(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_combine_cell_create_terminal)
state_machine.init()

-- 构造器
function IllustrationCombineCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._combine_card_data = nil
	self._cardMouldId = nil
	self._card_datas = nil

	-- load lua files.
	app.load("client.l_digital.cultivate.illustration.IllustrationActivate")
	app.load("client.l_digital.cultivate.illustration.IllustrationLevelup")
	app.load("client.l_digital.cultivate.illustration.IllustrationCombineCardMaxLevel")

	-- Initialize illustration cell page state machine.
	local function init_illustration_combine_cell_terminal()

		-- 激活和升级
		local illustration_combine_cell_click_terminal = {
			_name = "illustration_combine_cell_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if params then
					local mType = params._datas.m_type
					if 0 == mType then	-- 激活
						local cardMouldId = params._datas.cardMouldId 
						state_machine.excute("illustration_activate_window_open", 0, {cardMouldId})
					elseif 1 == mType then	-- 升级
						local cardData = params._datas.level_data
						local isCombineCard = true
						state_machine.excute("illustration_levelup_window_open",0,{cardData, isCombineCard})
					else -- 组合卡册满级
						local cardData = params._datas.level_data
						state_machine.excute("illustration_max_level_window_open",0,{cardData})
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(illustration_combine_cell_click_terminal)
		state_machine.init()
	end
	-- call func init illustration cell state machine.
	init_illustration_combine_cell_terminal()
end

-- 对象初始化
function IllustrationCombineCell:init(params)
	self._cardMouldId = params[1]

	self._combine_card_data = IllustrationHandle.getCombineCardDataByCardId(self._cardMouldId)
	self._card_datas = IllustrationHandle.getCardDataByCardMouldId(self._cardMouldId)

	self:onInit(params)
	return self
end

function IllustrationCombineCell:onUpdateDraw()
	local root = self.roots[1]

	-- 角色立绘
	self.Panel_big_icon_card:removeAllChildren(true)
	local pic = IllustrationHandle.getHeadIndex(self._cardMouldId, true)
	local headSp = cc.Sprite:create(string.format("images/face/big_head/big_head_%d.png", pic))
	-- Misma guarda que en `illustration_cell.lua`: hay ocho retratos que
	-- no existen en ninguna version y sin esto la pantalla se cae.
	if headSp then
		headSp:setAnchorPoint(0.5,0.5)
		headSp:setPosition(cc.p(self.Panel_big_icon_card:getContentSize().width/2,self.Panel_big_icon_card:getContentSize().height/2 - 60))
		self.Panel_big_icon_card:addChild(headSp)
	end

	-- 角色名称
	self.Text_charactor = ccui.Helper:seekWidgetByName(root, "Text_charactor")
    local name = IllustrationHandle.getCardName(self._cardMouldId, true)
	self.Text_charactor:setString(name)

	-- 单卡卡册评分
	self.Text_point_one_n = ccui.Helper:seekWidgetByName(root, "Text_point_one_n")
	self.Text_point_one_n:setVisible(false)
	self.Text_point_one_t = ccui.Helper:seekWidgetByName(root, "Text_point_one_t")
	self.Text_point_one_t:setVisible(false)

	-- 单卡卡册等级
	self.Image_lv = ccui.Helper:seekWidgetByName(root, "Image_lv")
	self.Image_lv:setVisible(false)
	self.AtlasLabel_illustration_lv = ccui.Helper:seekWidgetByName(root, "AtlasLabel_illustration_lv")
	self.AtlasLabel_illustration_lv:setVisible(false)

	-- 卡片左上角未激活（默认隐藏）
	self.Image_wjh = ccui.Helper:seekWidgetByName(root, "Image_wjh")
	self.Image_wjh:setVisible(false)

	self.Text_lvl_up = ccui.Helper:seekWidgetByName(root, "Text_lvl_up")
	
	-- 最大级
	self.Text_lvl_max = ccui.Helper:seekWidgetByName(root, "Text_lvl_max")
	self.Text_lvl_max:setVisible(false)

	-- 按钮
	self.Button_activate:setVisible(false)
	self.Button_lvl_up:setVisible(false)

	local cardDatas = self._card_datas
	if nil == cardDatas then	-- 未激活
		self.Button_activate:setVisible(true)
		self.Image_wjh:setVisible(true)
		if IllustrationHandle.getCombineCardCanUnlock(self._combine_card_data) then	-- 是否可激活
			self.Button_activate:setTouchEnabled(true)
			self.Button_activate:setBright(true)
			self.Text_point_one_n:setVisible(true)
			self.Text_point_one_t:setVisible(true)
			self.Text_point_one_t:setString("0")
		else
			local image = ccui.Helper:seekWidgetByName(root, "Image_4")
			self.Button_activate:setTouchEnabled(false)
			self.Button_activate:setBright(false)
			gray.setGray(headSp)
		end

	else	-- 已激活
		self.Button_lvl_up:setVisible(true)
		self.Text_point_one_n:setVisible(true)
		self.AtlasLabel_illustration_lv:setVisible(true)
		self.AtlasLabel_illustration_lv:setString(cardDatas.cardStar)
		self.Text_point_one_n:setVisible(true)
		self.Text_point_one_t:setVisible(true)
		self.Text_point_one_t:setString(cardDatas.cardScore)
		self.Image_lv:setVisible(true)
		local maxLevel = IllustrationHandle.getCombineCardMaxLevel(self._cardMouldId)
		if cardDatas.cardStar >= maxLevel then
			self.Button_lvl_up:setVisible(false)
			self.Text_lvl_max:setVisible(true)
		end
	end

	-- 设置人物立绘的点击事件
	self:addPanelEventListener(cardDatas)


	if self._ani_flag then
		self:playAnimationsOnce()
		self._ani_flag = false
	end

	self:pushRedTip()
end

-- 红点推送
function IllustrationCombineCell:pushRedTip()
	local root = self.roots[1]
	if nil == self._card_datas and IllustrationHandle.getCombineCardCanUnlock(self._combine_card_data) then
		self:playAnimations(1)
	elseif IllustrationHandle.getFlagLevelup(self._cardMouldId, true) then
		self:playAnimations(2)
	end
end

function IllustrationCombineCell:playAnimationsOnce( )
	self.Panel_effect_1:removeAllChildren()
	local jsonFile = "images/ui/effice/effect_illustration/effect_illustration.json"
	local atlasFile = "images/ui/effice/effect_illustration/effect_illustration.atlas"
	local aniName = "animation"
	local skeletonNode = sp.SkeletonAnimation:create(jsonFile, atlasFile, 1)
	skeletonNode:setAnimation(0, aniName, false)
	local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, false, nil)
	self.Panel_effect_1:addChild(skeletonNode)
end

-- 播放动画
function IllustrationCombineCell:playAnimations(type)
	self.Panel_effect:removeAllChildren()
	if type == 1 then
		local jsonFile = "images/ui/effice/effect_illustration3/effect_illustration3.json"
		local atlasFile = "images/ui/effice/effect_illustration3/effect_illustration3.atlas"
		local aniName = "animation"
		local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, true, nil)
		self.Panel_effect:addChild(animation)
	elseif type == 2 then
		local jsonFile = "images/ui/effice/effect_illustration2/effect_illustration2.json"
		local atlasFile = "images/ui/effice/effect_illustration2/effect_illustration2.atlas"
		local aniName = "animation"
		local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, true, nil)
		self.Panel_effect:addChild(animation)
	end
end

function IllustrationCombineCell:addPanelEventListener(cardDatas)
	local maxLevel = IllustrationHandle.getCombineCardMaxLevel(self._cardMouldId)
		
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.IllustrationLevelMax)

	if cardDatas == nil then
		fwin:addTouchEventListener(self.Panel_big_icon_card, nil,
		{
			terminal_name = "illustration_combine_cell_click",
			terminal_state = 0,
			m_type = 0,
			cardMouldId = self._cardMouldId,
			isPressedActionEnabled = true,
		}, nil, 0)
	elseif cardDatas.cardStar < maxLevel then
		fwin:addTouchEventListener(self.Panel_big_icon_card, nil,
		{
			terminal_name = "illustration_combine_cell_click",
			terminal_state = 0,
			m_type = 1,
			level_data = self._card_datas,
			isPressedActionEnabled = true,
		}, nil, 0)
	elseif (fun_is_open == true) and (cardDatas.cardStar == maxLevel) then
		fwin:addTouchEventListener(self.Panel_big_icon_card, nil,
		{
			terminal_name = "illustration_combine_cell_click",
			terminal_state = 0,
			m_type = 2,
			level_data = self._card_datas,
			isPressedActionEnabled = true,
		}, nil, 0)
	end
end


function IllustrationCombineCell:onEnterTransitionFinish()
	
end

function IllustrationCombineCell:onInit(params)
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/illustration/illustration_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	self:clearUIInfo()
	if IllustrationCombineCell.__size == nil then
		IllustrationCombineCell.__size = root:getContentSize()
	end
	self:setContentSize(IllustrationCombineCell.__size)
	self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
	self.Panel_effect:removeAllChildren(true)
	self.Panel_effect:setSwallowTouches(false)

	-- 动画控件
	self.Panel_effect_1 = ccui.Helper:seekWidgetByName(root, "Panel_effect_1")
	self.Panel_effect_1:removeAllChildren(true)
	self.Panel_effect_1:setSwallowTouches(false)
	-- 激活按钮（默认隐藏）
	self.Button_activate = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_activate"), nil,
	{
		terminal_name = "illustration_combine_cell_click",
		terminal_state = 0,
		m_type = 0,
		cardMouldId = self._cardMouldId,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 升级按钮
	self.Button_lvl_up = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lvl_up"), nil,
	{
		terminal_name = "illustration_combine_cell_click",
		terminal_state = 0,
		m_type = 1,
		level_data = self._card_datas,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.Panel_big_icon_card = ccui.Helper:seekWidgetByName(root, "Panel_big_icon_card")

	self:onUpdateDraw()
end

function IllustrationCombineCell:onExit()
	-- 释放IllustrationCombineCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/illustration/illustration_combine_cell.csb", root)
	-- ]]
end

function IllustrationCombineCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function IllustrationCombineCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	cacher.freeRef("cultivate/illustration/illustration_combine_cell.csb", root)
	self:unregisterOnNoteUpdate(self)
	root:removeFromParent(false)
	self.roots = {}
end

function IllustrationCombineCell:clearUIInfo()
	local root = self.roots[1]
	if root == nil then
        return
    end
	if root._x ~= nil then
        root:setPositionX(root._x)
    end
    if root._y ~= nil then
        root:setPositionY(root._y)
    end
	local Panel_big_icon_card = ccui.Helper:seekWidgetByName(root, "Panel_big_icon_card")
	Panel_big_icon_card:removeAllChildren()
	fwin:removeTouchEventListener(Panel_big_icon_card)
end

-- ~END
-- ----------------------------------------------------------------------------
