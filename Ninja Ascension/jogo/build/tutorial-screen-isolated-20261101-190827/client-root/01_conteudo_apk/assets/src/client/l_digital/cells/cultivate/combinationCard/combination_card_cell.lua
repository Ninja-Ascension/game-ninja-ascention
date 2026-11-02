--[[ ----------------------------------------------------------------------------
-- 组合卡cell
--]] ----------------------------------------------------------------------------
CombinationCardCell = class("CombinationCardCellClass", Window)
CombinationCardCell.__size = nil
function CombinationCardCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.ship_id = nil
	self.choose_index = nil
	self.is_come_soon = false -- 期待标志
	app.load("client.cells.ship.ship_icon_cell")
	app.load("client.l_digital.cultivate.combinationCard.CombinationCardNotUnlockedWindow")
	-- Initialize adventure hero icon cell state machine.
	local function init_combination_card_cell_terminal()
		-- 打开角色创建窗口
		local combination_card_cell_open_terminal = {
			_name = "combination_card_cell_open",
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

		-- 关闭角色创建窗口
		local combination_card_cell_close_terminal = {
			_name = "combination_card_cell_close",
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

		-- 显示窗口
		local combination_card_cell_show_terminal = {
			_name = "combination_card_cell_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local combination_card_cell_hide_terminal = {
			_name = "combination_card_cell_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--卡牌详情展示
		local combination_card_cell_mould_info_terminal = {
            _name = "combination_card_cell_mould_info",
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
				local shipMouldId = params._datas.ship_id
				local index = params._datas.choose_index
				if shipMouldId and index then
					state_machine.excute("sm_role_information_open", 0, {shipMouldId, 1, index})
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		--卡牌加成信息显示
		local combination_card_cell_add_info_terminal = {
            _name = "combination_card_cell_add_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params)
				--是否解锁
				local shipId = params._datas.m_ship_id
				if CombinationCardHandle.getCardStateById(shipId) then
					-- 请求单卡详情
					local function responseOneDetailCallBack( response )
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							state_machine.excute("combination_card_not_unlocked_window_open", 0,{shipId})
						end
					end

					protocol_command.combine_ship_get_one.param_list = ""..shipId
					NetworkManager:register(protocol_command.combine_ship_get_one.code, nil, nil, nil, instance, responseOneDetailCallBack, false, nil)
				else
					state_machine.excute("combination_card_not_unlocked_window_open", 0,{shipId})
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		state_machine.add(combination_card_cell_open_terminal)
		state_machine.add(combination_card_cell_close_terminal)
		state_machine.add(combination_card_cell_show_terminal)
		state_machine.add(combination_card_cell_hide_terminal)
		state_machine.add(combination_card_cell_mould_info_terminal)
		state_machine.add(combination_card_cell_add_info_terminal)
		state_machine.init()
	end
	-- call func init combination card cell state machine.
	init_combination_card_cell_terminal()
end

function CombinationCardCell:onUpdateDraw()
	local root = self.roots[1]
	local isUnLock = false
	if self.ship_id then
		isUnLock = CombinationCardHandle.getCardStateById(self.ship_id)
	end
	
	-- 立绘
	self.Image_lihui_1 = ccui.Helper:seekWidgetByName(root, "Image_lihui_1")
	self.Image_lihui_1:setVisible(false)
	-- 卡片标题
	self.Image_wenzi_1 = ccui.Helper:seekWidgetByName(root, "Image_wenzi_1")
	self.Image_wenzi_1:setVisible(false)
	-- 未解锁
	self.Image_lock_1 = ccui.Helper:seekWidgetByName(root, "Image_lock_1")
	self.Image_lock_1:setVisible(false)
	
	-- 敬请期待底图
	self.Image_jingqingqidai = ccui.Helper:seekWidgetByName(root, "Image_jingqingqidai")
	self.Image_jingqingqidai:setVisible(false)
	-- 敬请期待标题
	self.Image_wenzi_2 = ccui.Helper:seekWidgetByName(root, "Image_wenzi_2")
	self.Image_wenzi_2:setVisible(false)

	-- 未解锁
	self.Text_unlock = ccui.Helper:seekWidgetByName(root, "Text_open_lv_info_1")
	self.Text_unlock:setVisible(false)

	if self.is_come_soon then
		self.Image_jingqingqidai:setVisible(true)
		self.Image_wenzi_2:setVisible(true)
		self.Button_yulan_1:setVisible(false)
	else
		-- 立绘
		local pic = dms.int(dms["ship_mould"], self.ship_id, ship_mould.All_icon)
		self.Image_lihui_1:loadTexture(string.format("images/face/big_head/big_head_%d.png", pic))
		self.Image_lihui_1:setVisible(true)
		if cc.FileUtils:getInstance():isFileExist(string.format("images/ui/text/TF_res/combination_card/combination_card_wenzi_%d.png", pic)) then
			self.Image_wenzi_1:loadTexture(string.format("images/ui/text/TF_res/combination_card/combination_card_wenzi_%d.png", pic))
		end
		self.Image_wenzi_1:setVisible(true)
		if isUnLock then
			
		else
			self.Image_lock_1:setVisible(true)
			self.Image_wenzi_2:setVisible(true)
			if CombinationCardHandle.getCanUnlockByMouldId(self.ship_id) then
				self.Text_unlock:setString(tipStringInfo_combination_card_configure[15])
			else
				self.Text_unlock:setString(tipStringInfo_combination_card_configure[14])
			end
			self.Text_unlock:setVisible(true)
		end
		-- 卡片底图
		self.Image_diqiban = ccui.Helper:seekWidgetByName(root, "Image_diqiban")
		fwin:addTouchEventListener(self.Image_diqiban, nil,
		{
			terminal_name = "combination_card_cell_add_info",
			terminal_state = 0,
			m_ship_id = self.ship_id,
			isPressedActionEnabled = true,
		}, nil, 0)
		self:redTipPush()
	end
end

-- 红点推送
function CombinationCardCell:redTipPush()
	if CombinationCardHandle.getCanUnlockByMouldId(self.ship_id) or CombinationCardHandle.getSoltCanUnlockByMouldId(self.ship_id) or CombinationCardHandle:getCardRedCountFlag(self.ship_id) then
		CombinationCardHandle.pushTipControl(self.Image_diqiban,true)
	else
		CombinationCardHandle.pushTipControl(self.Image_diqiban,false)
	end
end

function CombinationCardCell:onInit()
	self.roots = {}
	local root = cacher.createUIRef("cultivate/Combination_card/Combination_card_cell.csb", "root")
 	table.insert(self.roots, root)
	 self:addChild(root)
	 if CombinationCardCell.__size == nil then
        CombinationCardCell.__size = ccui.Helper:seekWidgetByName(root, "root"):getContentSize()
	end
	
	self:setContentSize(CombinationCardCell.__size)

	-- 预览按钮
	self.Button_yulan_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yulan_1"), nil,
	{
		terminal_name = "combination_card_cell_mould_info",
		ship_id = self.ship_id,
		choose_index = self.choose_index,
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	
	self:onUpdateDraw()
end

function CombinationCardCell:onExit()
	state_machine.remove("combination_card_cell_mould_info")
	state_machine.remove("combination_card_cell_add_info")

	cacher.freeRef("cultivate/Combination_card/Combination_card_cell.csb", self.roots[1])
	self.roots = {}
end

-- /**
--初始化
-- */
function CombinationCardCell:init(params)
	self.ship_id = params[1]
	self.choose_index = params[2]
	if params[3] then
		self.is_come_soon = true
	end
	self:onInit()

	return self
end

function CombinationCardCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CombinationCardCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("cultivate/Combination_card/Combination_card_cell.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

function CombinationCardCell:createCell()
	local cell = CombinationCardCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end