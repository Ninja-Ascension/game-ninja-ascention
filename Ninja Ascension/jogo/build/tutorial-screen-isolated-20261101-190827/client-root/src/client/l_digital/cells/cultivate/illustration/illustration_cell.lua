--[[ ----------------------------------------------------------------------------
-- 卡册列表控件
--]] ----------------------------------------------------------------------------
IllustrationCell = class("IllustrationCellClass", Window)
IllustrationCell.__size = nil

-- 创建Cell实例
local illustration_cell_create_terminal = {
	_name = "illustration_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if IllustrationCell then
			local cell = IllustrationCell:new()
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

state_machine.add(illustration_cell_create_terminal)
state_machine.init()

-- 构造器
function IllustrationCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._per_card_data = nil
	-- load lua files.
	app.load("client.l_digital.cultivate.illustration.IllustrationLevelup")
	-- Initialize illustration cell page state machine.
	local function init_illustration_cell_terminal()

		-- 激活和升级
		local illustration_cell_click_terminal = {
			_name = "illustration_cell_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if params then
					state_machine.lock("illustration_cell_click")
					local mouldId = params._datas.mould_id
					local cardId = IllustrationHandle.switchCardId(mouldId)
					local mType = params._datas.m_type
					if 0 == mType then	-- 激活
						local function responseCallBack( response )
							state_machine.unlock("illustration_cell_click")
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								TipDlg.drawTextDailog(tipStringInfo_illustration_tip[4])
								state_machine.excute("illustration_refush_bar_list", 0,{mouldId})
							end
						end

						protocol_command.user_card_info_activate.param_list = ""..cardId
						NetworkManager:register(protocol_command.user_card_info_activate.code, nil, nil, nil, instance, responseCallBack, false, nil)
					else	-- 升级
						state_machine.unlock("illustration_cell_click")
						local cardData = params._datas.level_data 
						state_machine.excute("illustration_levelup_window_open",0,{cardData})
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--卡牌详情展示
		local illustration_cell_mould_info_terminal = {
            _name = "illustration_cell_mould_info",
            _init = function (terminal) 
                app.load("client.formation.HeroInformation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params)
				if not params then
					return true
				end
				local shipMouldId = params._datas.ship_mould_id
				local index = params._datas.choose_index
				if shipMouldId and index then
					state_machine.excute("sm_role_information_open", 0, {shipMouldId, 1, index})
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		state_machine.add(illustration_cell_click_terminal)
		state_machine.add(illustration_cell_mould_info_terminal)
		state_machine.init()
	end
	-- call func init illustration cell state machine.
	init_illustration_cell_terminal()
end

-- 对象初始化
function IllustrationCell:init(params)
	self._ship_mould_id = params[1]
	self._choose_index = params[2]
	self._ani_flag = params[3]
	self._card_datas = IllustrationHandle.getCardDataByShipMouldId(self._ship_mould_id)
	self:onInit(params)
	return self
end

function IllustrationCell:onUpdateDraw()
	local root = self.roots[1]

	-- 角色立绘
	self.Panel_big_icon_card:removeAllChildren(true)
	local pic = IllustrationHandle.getHeadIndex(self._ship_mould_id)
	local headSp = cc.Sprite:create(string.format("images/face/big_head/big_head_%d.png", pic))
	-- Ocho retratos de la tabla no existen en NINGUNA version del juego
	-- (310004..310404 y 1997xx). Sin esta guarda, cc.Sprite:create
	-- devuelve nil y la linea siguiente tumba la pantalla Deck entera.
	if headSp then
		headSp:setAnchorPoint(0.5,0.5)
		headSp:setPosition(cc.p(self.Panel_big_icon_card:getContentSize().width/2,self.Panel_big_icon_card:getContentSize().height/2 - 60))
		self.Panel_big_icon_card:addChild(headSp)
	end

	-- 角色名称
	self.Text_charactor = ccui.Helper:seekWidgetByName(root, "Text_charactor")
	self.Text_charactor:setString(IllustrationHandle.getCardName(self._ship_mould_id))

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
		if IllustrationHandle.getUnlockByShipMouldId(self._ship_mould_id) then	-- 是否可激活
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
		if cardDatas.cardStar >= 7 then
			self.Button_lvl_up:setVisible(false)
			self.Text_lvl_max:setVisible(true)
		end
	end
	if self._ani_flag then
		self:playAnimationsOnce()
		self._ani_flag = false
	end


	self:pushRedTip()
end

-- 红点推送
function IllustrationCell:pushRedTip()
	local root = self.roots[1]
	local Image_4 = ccui.Helper:seekWidgetByName(root, "Image_4")
	if nil == self._card_datas and IllustrationHandle.getUnlockByShipMouldId(self._ship_mould_id) then
		-- IllustrationHandle.pushTipControl(Image_4,true)
		self:playAnimations(1)
	elseif IllustrationHandle.getFlagLevelup(self._ship_mould_id) then
		-- IllustrationHandle.pushTipControl(Image_4,true)
		self:playAnimations(2)
	else
		-- IllustrationHandle.pushTipControl(Image_4,false)
	end
end

function IllustrationCell:playAnimationsOnce( )
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
function IllustrationCell:playAnimations(type)
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

function IllustrationCell:onEnterTransitionFinish()
	
end

function IllustrationCell:onInit(params)
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/illustration/illustration_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	self:clearUIInfo()
	if IllustrationCell.__size == nil then
		IllustrationCell.__size = root:getContentSize()
	end
	self:setContentSize(IllustrationCell.__size)
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
		terminal_name = "illustration_cell_click",
		terminal_state = 0,
		mould_id = self._ship_mould_id,
		m_type = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 升级按钮
	self.Button_lvl_up = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lvl_up"), nil,
	{
		terminal_name = "illustration_cell_click",
		terminal_state = 0,
		m_type = 1,
		level_data = self._card_datas,
		mould_id = self._ship_mould_id,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self.Panel_big_icon_card = ccui.Helper:seekWidgetByName(root, "Panel_big_icon_card")
	fwin:addTouchEventListener(self.Panel_big_icon_card, nil,
	{
		terminal_name = "illustration_cell_mould_info",
		terminal_state = 0,
		ship_mould_id = self._ship_mould_id,
		choose_index = self._choose_index,
		isPressedActionEnabled = true,
	}, nil, 0)

	

	self:onUpdateDraw()
end

function IllustrationCell:onExit()
	-- 释放IllustrationCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/illustration/illustration_cell.csb", root)
	-- ]]
end

function IllustrationCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function IllustrationCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	cacher.freeRef("cultivate/illustration/illustration_cell.csb", root)
	self:unregisterOnNoteUpdate(self)
	root:removeFromParent(false)
	self.roots = {}
end

function IllustrationCell:clearUIInfo()
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
