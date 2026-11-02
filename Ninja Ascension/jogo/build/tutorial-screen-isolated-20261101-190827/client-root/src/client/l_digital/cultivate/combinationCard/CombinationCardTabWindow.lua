--[[ ----------------------------------------------------------------------------
-- 组合卡碎片兑换
--]] ----------------------------------------------------------------------------
CombinationCardTabWindow = class("CombinationCardTabWindowClass", Window)

-- 打开窗口
local combination_card_tab_window_open_terminal = {
	_name = "combination_card_tab_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CombinationCardTabWindowClass") then
			fwin:open(CombinationCardTabWindow:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local combination_card_tab_window_close_terminal = {
	_name = "combination_card_tab_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CombinationCardTabWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(combination_card_tab_window_open_terminal)
state_machine.add(combination_card_tab_window_close_terminal)
state_machine.init()

-- 构造器
function CombinationCardTabWindow:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._max_select_num = 0
	self.Text_num_widget = {}
	self.ship_mould_id = nil
	self._select_num = 0
	self.haveNumDatas = {}			-- 碎片拥有量
	-- load lua files.
	app.load("client.cells.ship.hero_icon_list_cell")
	app.load("client.cells.ship.ship_icon_cell")
	app.load("client.cells.utils.resources_icon_cell")
	-- Initialize combination card tab window page state machine.
	local function init_combination_card_tab_window_terminal()

		-- 显示窗口
		local combination_card_tab_window_show_terminal = {
			_name = "combination_card_tab_window_show",
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
		local combination_card_tab_window_hide_terminal = {
			_name = "combination_card_tab_window_hide",
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

		-- 碎片兑换
        local combination_card_tab_window_request_terminal = {
            _name = "combination_card_tab_window_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._max_select_num == 0 then
                    TipDlg.drawTextDailog(_new_interface_text[26])
                    return
                end
                local function responseChangeCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd,fwin._ui)

                        state_machine.excute("sm_role_strengthen_tab_rising_star_update_draw", 0 , "sm_role_strengthen_tab_rising_star_update_draw.")
						state_machine.excute("combination_card_tab_window_close", 0 , "")
						
                    end
                end
                protocol_command.combine_ship_debris_exchange.param_list = ""..instance.ship_mould_id.."\r\n"..instance._select_num
                NetworkManager:register(protocol_command.combine_ship_debris_exchange.code, nil, nil, nil, instance, responseChangeCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 修改数量
        local combination_card_tab_window_change_number_terminal = {
            _name = "combination_card_tab_window_change_number",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currtype = params._datas.currtype
                if instance._max_select_num == 0 then
                    TipDlg.drawTextDailog(_new_interface_text[26])
                    return
                end
                local select_num = 0
                if currtype == 1 then
                    select_num = instance._select_num + 1
                    if select_num > instance._max_select_num then
                        return
                    end
                else
                    select_num = instance._select_num - 1
                    if select_num < 0 then
                        return
                    end
				end
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 进度条修改
        local combination_card_tab_window_update_slider_terminal = {
            _name = "combination_card_tab_window_update_slider",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local select_num = math.ceil(tonumber(params[2]) * params[1]._max_select_num / 100)
                params[1]:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		state_machine.add(combination_card_tab_window_show_terminal)
		state_machine.add(combination_card_tab_window_hide_terminal)
		state_machine.add(combination_card_tab_window_request_terminal)
		state_machine.add(combination_card_tab_window_change_number_terminal)
		state_machine.add(combination_card_tab_window_update_slider_terminal)	
		state_machine.init()
	end
	-- call func init combination card tab window state machine.
	init_combination_card_tab_window_terminal()
end

function CombinationCardTabWindow:onUpdateDraw()
	local root = self.roots[1]

	-- 兑换数量
	self.Text_tips_2 = ccui.Helper:seekWidgetByName(root, "Text_tips_2")
	
	-- 列表容器
	self.ListView_props = ccui.Helper:seekWidgetByName(root, "ListView_props")


	-- 兑换成功道具
	self.Panel_props_6 = ccui.Helper:seekWidgetByName(root, "Panel_props_6")

	local prop_id = dms.int(dms["ship_mould"], tonumber(self.ship_mould_id), ship_mould.fitSkillOne)
	local cell = ResourcesIconCell:createCell()
	cell:init(6, 0, prop_id,nil,nil,true,true,0,nil)
	self.Panel_props_6:addChild(cell)



	-- 需求数量
	self.Text_number_6 = ccui.Helper:seekWidgetByName(root, "Text_number_6")

	-- 进度条背景
	self.Image_number_bg = ccui.Helper:seekWidgetByName(root, "Image_number_bg")

	-- 进度条背景
	self.Slider_number = ccui.Helper:seekWidgetByName(root, "Slider_number")
	-- 处理显示几个碎片
	self:showChipSlot()
end

-- 处理显示几个碎片
function CombinationCardTabWindow:showChipSlot()
	local root = self.roots[1]
	self.Text_num_widget = {}
	-- 或得兑换条件

	local slotNum = CombinationCardHandle.getPerMouldByShipId(self.ship_mould_id,ship_combination_card_mould.solt_num)

	local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_props_1"):retain()
	
	local ListViewProps = self.ListView_props
	ListViewProps:removeAllChildren(true)

	local oldPosX = ListViewProps:getPositionX()
	local oldPosY = ListViewProps:getPositionY()
	local oldSize = ListViewProps:getContentSize()

	local listWidth = math.floor(oldSize.width)
	local perWidth = math.floor(listWidth/5)
	local newX = math.floor(oldPosX + perWidth * (5 - slotNum)/2 - (5 - slotNum) * 16)
	
	local newPos = cc.p(newX,oldPosY)
	local newSize = cc.size(perWidth * slotNum,oldSize.height)
	ListViewProps:setContentSize(newSize)
	ListViewProps:setPosition(newPos)
	-- 最大兑换数
	local lastNum = {}
	
	for i=1,slotNum do
		local Panel_prop_per = Panel_prop:clone()
		local Text_number = Panel_prop_per:getChildByName("Text_number_1")

		Text_number:retain()
		Panel_prop_per:removeAllChildren(true)

		local cur_ship_id = CombinationCardHandle.unLockConditionByShipId(self.ship_mould_id,ship_combination_card_mould.unlock_conditon_one + (i - 1)).ship_id
		local prop_id = dms.int(dms["ship_mould"], tonumber(cur_ship_id), ship_mould.fitSkillOne)
		local cell = ResourcesIconCell:createCell()
		cell:init(6, 0, prop_id,nil,nil,true,true,0,nil)

		Panel_prop_per:addChild(cell)
		local haveNum = 0
		if fundPropWidthId(prop_id) then
			haveNum = tonumber(fundPropWidthId(prop_id).prop_number)
		end
		table.insert(lastNum,haveNum)
		self.haveNumDatas[i] = {}
		self.haveNumDatas[i] = haveNum

		local Text_number_per = Text_number:clone()
		Panel_prop_per:addChild(Text_number_per)
		self.Text_num_widget[i] = Text_number
		Text_number:setString(haveNum.."/".."1")
		ListViewProps:addChild(Panel_prop_per)
		Text_number:release()
	end
	table.sort( lastNum, function(a,b)
		if a < b then
			return true
		end
		return false
	end)				
	self.ListView_props = ListViewProps
	self._max_select_num = tonumber(lastNum[1])
	Panel_prop:release()
	local curr_number = math.min( self._max_select_num , 1)
    self:setSelectNum(curr_number)
end


function CombinationCardTabWindow:updateSliderInfo(percent)
    local root = self.roots[1]

    local Slider_number = ccui.Helper:seekWidgetByName(root, "Slider_number")
    local Text_tips_3 = ccui.Helper:seekWidgetByName(root, "Text_tips_3")
    if self._max_select_num == 0 then
        Text_tips_3:setString(tipStringInfo_combination_card_tip[10])
    else
        Text_tips_3:setString(string.format(_new_interface_text[25], self._select_num , self._max_select_num))
    end
    Slider_number:setPercent(percent)

	if self._max_select_num >= 0 then
		local itemDatas = self.ListView_props:getItems()
		local index = 1
		for k,v in pairs (itemDatas) do
			local Text_number_per = v:getChildByName("Text_number_1")
			Text_number_per:setVisible(true)
			Text_number_per:setString(self.haveNumDatas[index].."/"..self._select_num)
			index = index + 1
		end
		self.Text_number_6:setString(""..self._select_num)
    end
end

function CombinationCardTabWindow:setSelectNum(select_num)
    self._select_num = tonumber(select_num)
    if self._select_num > self._max_select_num then
        self._select_num = self._max_select_num
    end
    if self._select_num <= 0 then
        self._select_num = 0
    end

    local percent = math.floor(self._select_num * 100 / self._max_select_num)
	self:updateSliderInfo(percent)

	self.Text_tips_2:setString(""..self._select_num)

	
end

function CombinationCardTabWindow:onEnterTransitionFinish()
	-- 加载CombinationCardTabWindowWindow界面资源.
	-- res.cultivate.combinationCard.Combination_card_tab_window = res/cultivate/combinationCard/Combination_card_tab_window.csb
	local csbNode = csb.createNode("cultivate/Combination_card/Combination_card_tab_window.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭按钮
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "combination_card_tab_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 兑换按钮
	self.Button_zhuanhua = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhuanhua"), nil,
	{
		terminal_name = "combination_card_tab_window_request",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 兑换减号
	self.Button_reduce = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reduce"), nil,
	{
		terminal_name = "combination_card_tab_window_change_number",
		terminal_state = 0,
		currtype = 2,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 兑换加号
	self.Button_add = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"), nil,
	{
		terminal_name = "combination_card_tab_window_change_number",
		terminal_state = 0,
		currtype = 1,
		isPressedActionEnabled = true,
	}, nil, 0)	

	local Slider_number = ccui.Helper:seekWidgetByName(root, "Slider_number")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("combination_card_tab_window_update_slider", 0, {sender._self, sender:getPercent()})
        end
    end
    Slider_number._self = self
    Slider_number:addEventListener(percentChangedEvent)

	self:onUpdateDraw()
end

-- 对象初始化
function CombinationCardTabWindow:init(params)
	
	if params then
		self.ship_mould_id = params[1]
	end

	return self
end

function CombinationCardTabWindow:onExit()
	-- 释放CombinationCardTabWindowWindow界面资源.
	state_machine.remove("combination_card_tab_window_show")
	state_machine.remove("combination_card_tab_window_hide")
	state_machine.remove("combination_card_tab_window_request")
	state_machine.remove("combination_card_tab_window_change_number")
	state_machine.remove("combination_card_tab_window_update_slider")
	
end

function CombinationCardTabWindow:close()
	-- window event : close.
	
end

function CombinationCardTabWindow:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
