--[[ ----------------------------------------------------------------------------
-- 心愿单
--]] ----------------------------------------------------------------------------
NewRecruitWish = class("NewRecruitWishClass", Window)

-- 打开窗口
local new_recruit_wish_window_open_terminal = {
	_name = "new_recruit_wish_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("NewRecruitWishClass") then
            local panel = NewRecruitWish:new():init(params)
            fwin:open(panel, fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local new_recruit_wish_window_close_terminal = {
	_name = "new_recruit_wish_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("NewRecruitWishClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(new_recruit_wish_window_open_terminal)
state_machine.add(new_recruit_wish_window_close_terminal)
state_machine.init()

-- 构造器
function NewRecruitWish:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.chooseInfo = {}		-- 当前选中奖励
	self.allInfo = {}			-- 全部奖励
	self.chooseIdx = -1			-- 选中奖励下标
	self.deltaTime = 1	
    self.totalTime = 0
	self.activityEndTime = 0	-- 结束的时间
	-- load lua files.
	app.load("client.shop.newrecruit.NewRecruitWishList")
	
	-- Initialize service carnival rule page state machine.
	local function init_new_recruit_wish_terminal()
		-- 打开角色创建窗口
		local new_recruit_wish_open_terminal = {
			_name = "new_recruit_wish_open",
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
		local new_recruit_wish_close_terminal = {
			_name = "new_recruit_wish_close",
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
		local new_recruit_wish_show_terminal = {
			_name = "new_recruit_wish_show",
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
		local new_recruit_wish_hide_terminal = {
			_name = "new_recruit_wish_hide",
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
		
		-- 更新选中的内容
		local new_recruit_wish_update_choose_terminal = {
			_name = "new_recruit_wish_update_choose",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 更新选中的内容
				if nil ~= instance then
					local chooseInfo = params._datas.info
					local chooseIdx = params._datas.idx
					state_machine.excute("new_recruit_wish_list_choose", 0, chooseIdx)
					instance:updatePanelChoose(chooseInfo, chooseIdx)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 确认选中的心愿
		local new_recruit_wish_confirm_choose_terminal = {
			_name = "new_recruit_wish_confirm_choose",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 确认选中的心愿
				if nil ~= instance then
					local chooseInfo = instance.chooseInfo
					if chooseInfo == nil then
						TipDlg.drawTextDailog(new_recruit_shop_str[6])
						return false
					else
						local chooseIdx = instance.chooseIdx
						if chooseIdx == -1 then
							state_machine.excute("new_recruit_wish_window_close", 0, nil)
							return true
						end

						local activity_params = json.decode(_ED.active_activity[184].activity_params)
						if tonumber(activity_params.lastDrawCount) <= 0 then
							TipDlg.drawTextDailog(new_recruit_shop_str[13])
							return false
						end
						local function responseCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
									TipDlg.drawTextDailog(new_recruit_shop_str[7])
									state_machine.excute("new_recruit_main_update_redDot",0,"")
									state_machine.excute("new_recruit_wish_window_close", 0, nil)
								end
							end
						end
						
						protocol_command.wish_list_set.param_list = ""..chooseIdx
						NetworkManager:register(protocol_command.wish_list_set.code, nil, nil, nil, instance, responseCallback, false, nil)
					end
					
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 点击进入阵容推荐
		local new_recruit_wish_enter_formation_template_terminal = {
			_name = "new_recruit_wish_enter_formation_template",
			_init = function (terminal)
				app.load("client.formation.FormationTemplateWindow")
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.lock("new_recruit_wish_enter_formation_template")
				state_machine.excute("formation_template_window_open",0,"")
				state_machine.unlock("new_recruit_wish_enter_formation_template", 0, "")
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(new_recruit_wish_open_terminal)
		state_machine.add(new_recruit_wish_close_terminal)
		state_machine.add(new_recruit_wish_show_terminal)
		state_machine.add(new_recruit_wish_hide_terminal)
		state_machine.add(new_recruit_wish_update_choose_terminal)
		state_machine.add(new_recruit_wish_confirm_choose_terminal)
		state_machine.add(new_recruit_wish_enter_formation_template_terminal)
		state_machine.init()
	end
	-- call func init service carnival rule state machine.
	init_new_recruit_wish_terminal()
end

function NewRecruitWish:drawTime(_time)
	local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.floor((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .. _string_piece_info[231]
    end
    if _hourTime < 10 then
        timeString = timeString .. "0" .. _hourTime .. ":"
    else
        timeString = timeString .. _hourTime .. ":"
    end

    if _minutesTime < 10 then
        timeString = timeString .. "0" .. _minutesTime .. ":"
    else
        timeString = timeString .. _minutesTime .. ":"
    end

    if _secondsTime < 10 then
        timeString = timeString .. "0" .. _secondsTime
    else
        timeString = timeString .. _secondsTime
    end
    return timeString
end

function NewRecruitWish:updateRemainTime()
	if self.Text_remain_time == nil or self.activityEndTime == nil then
        return
    end
    local surplus_time = (self.activityEndTime - (os.time() + _ED.time_add_or_sub) * 1000)
	if surplus_time < 0 then
		self.activityEndTime = nil
		state_machine.excute("new_recruit_main_close_wishlist", 0, nil)
		state_machine.excute("new_recruit_wish_window_close", 0, nil)
	end
    self.Text_remain_time:setString(self:drawTime(surplus_time))
end

function NewRecruitWish:onUpdate(dt)

	self.totalTime = self.totalTime + dt
    if self.totalTime >= self.deltaTime then
        self:updateRemainTime()
        self.totalTime = 0
    end

	-- if self.listView ~= nil then
	-- 	print(self.listView:getInnerContainer():getPositionY(), "===self.listView:getInnerContainer():getPositionY()")
    --     local posY = self.listView:getInnerContainer():getPositionY()
    --     if posY == self._scroll_view_posy then
    --         return
    --     end
    --     self._scroll_view_posy = posY

    --     local size = self.listView:getContentSize()
    --     local items = self._cell_group
    --     local itemSize = self._cell_size
    --     for i, v in pairs(items) do
    --         if v ~= nil and tolua.isnull(v) == false then
    --             if v ~= nil then
    --                 local tempY = v:getPositionY() + posY
    --                 if tempY + itemSize.height < 0 or tempY > size.height + itemSize.height then
    --                     v:unload()
    --                 else
    --                     v:reload()
    --                 end
    --             end
    --         end
    --     end
    -- end
end

-- 进行奖励列表的绘制
function NewRecruitWish:initListView(rewardInfo)
	self.listView:removeAllChildren()
	local cell_group = {}
	local cell_size = nil
	for i, v in ipairs(rewardInfo) do
		if v == self.chooseInfo then
			self.chooseIdx = i
		end
		local cell = state_machine.excute("new_recruit_wish_list_create", 0, {v, i, self.chooseIdx})
		self.listView:addChild(cell)
		table.insert(cell_group, cell)
		
		if cell_size == nil then
			cell_size = cell:getContentSize()
		end
	end

	local width = self.listView:getContentSize().width
	local height = self.listView:getContentSize().height
	local count = #rewardInfo
	local row_count = 4
	local col_count = math.ceil(count / row_count)
    if count > 0 then
        if cell_size.height * col_count > height then
			height = cell_size.height * col_count
        end
        -- 进行scrollView的绘制
        self.listView:getInnerContainer():setContentSize(cc.size(width, height + 15))
        for i = 1, count do
            local row = 0
            local col = 0
            local cell = nil
            row = math.floor((i - 1) % row_count)
            col = math.floor((i - 1) / row_count)
            cell = cell_group[i]
            cell:setAnchorPoint(cc.p(0,1))
            cell:setPosition(cc.p(row * (width / row_count), height - col * cell_size.height))
        end
    end

	self.listView:jumpToTop()

    self._scroll_view_posy = self.listView:getInnerContainer():getPositionY()
    self._cell_group = cell_group
    self._cell_size = cell_size

end

function NewRecruitWish:updateChooseEffect()
	local items = self.listView:getChildren()
	if items ~= 0 then
		for i, v in ipairs(items) do
			v:updateChoose(self.chooseIdx)
		end
	end
end

-- 更新选中的内容
function NewRecruitWish:updatePanelChoose(chooseInfo, idx)
	if idx ~= nil then
		self.chooseIdx = idx
	end
	-- print(self.chooseIdx, "====self.chooseIdx")
	self.chooseInfo = chooseInfo
	self.Panel_role:removeAllChildren()
	local cell = DrawHandle.drawIcon(chooseInfo)
	self.Panel_role:addChild(cell)
	self:updateChooseEffect()
end

-- 进行文本的更新
function NewRecruitWish:updateDraw()
	local root = self.roots[1]
	self.Panel_role:removeAllChildren()
	local data = {}
	-- local activity_data = _ED.active_activity[184].activity_data
	local activity_params = json.decode(_ED.active_activity[184].activity_params)
	self.activityEndTime = tonumber(_ED.active_activity[184].end_time)
	
	self:updateRemainTime()
	local allCount = activity_params.drawTotalCount
	local rewardInfoString = activity_params.wishRewards
	-- 当前许愿内容
	local chooseInfo = {}
	-- 剩余许愿次数
	local remainCount = {}
	-- if activity_data ~= nil and activity_data ~= {} then
	-- 	remainCount = activity_data.wish_counts
	-- 	chooseInfo = activity_data.wish_reward
	-- else
	remainCount = activity_params.lastDrawCount
	chooseInfo = activity_params.wishRewardSet
	-- end
	local wishViewWeights = activity_params.wishViewWeights
	-- local rewardInfo = {{"13,57,1,3"}, {"13,12,1,2"}, {"13,267,1,3"},{"13,57,1,3"}, {"13,12,1,2"}, {"13,267,1,3"},{"13,57,1,3"}, {"13,12,1,2"}, {"13,12,1,2"}, {"13,267,1,3"},{"13,57,1,3"}, {"13,12,1,2"}, {"13,267,1,3"},}
	self.Text_cur:setString(remainCount.."")
	self.Text_all:setString(allCount.."")
	self.Text_probability:setString(wishViewWeights)

	if tonumber(chooseInfo) ~= -1 then
		self:updatePanelChoose(chooseInfo)
	end

	if remainCount == 0 then
		-- 蒙版出现
		self.wishMashPic:setVisible(true)
		-- 确认按钮无法点击
		self.Button_confirm:setTouchEnabled(false)
	else
		self.wishMashPic:setVisible(false)
		self.Button_confirm:setTouchEnabled(true)
	end

	local rewardInfo = zstring.split(rewardInfoString, "|")
	self:initListView(rewardInfo)
end


-- 对象初始化
function NewRecruitWish:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end


function NewRecruitWish:onEnterTransitionFinish()
	-- 加载RecruitSuccessOneWindow界面资源.
	-- res.activity.service_carnival.new_recruit_wish = res/activity/service_carnival/new_recruit_wish.csb
	local csbNode = csb.createNode("shop/new_recruit_wish.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 剩余心愿次数
	self.Text_cur = ccui.Helper:seekWidgetByName(root, "Text_6")
	-- 总共心愿次数
	self.Text_all = ccui.Helper:seekWidgetByName(root, "Text_8")
	-- 当前心愿概率
	self.Text_probability = ccui.Helper:seekWidgetByName(root, "Text_2")
	self.Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_2")
	self.listView = ccui.Helper:seekWidgetByName(root, "ScrollView_list_role_item")

	-- 倒计时文本
	self.Text_remain_time = ccui.Helper:seekWidgetByName(root, "Text_11")
	
	-- 已许愿完后图片蒙版
	self.wishMashPic = ccui.Helper:seekWidgetByName(root, "Image_9")

	-- 确认按钮
	self.Button_confirm = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_0"), nil,
	{
		terminal_name = "new_recruit_wish_confirm_choose",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	-- 取消按钮
	self.Button_cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil,
	{
		terminal_name = "new_recruit_wish_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	-- 关闭按钮
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil,
	{
		terminal_name = "new_recruit_wish_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 阵容推荐
	local Button_4 = ccui.Helper:seekWidgetByName(root, "Button_4")
	if Button_4 then
		fwin:addTouchEventListener(Button_4, nil, 
		{
			terminal_name = "new_recruit_wish_enter_formation_template", 		
			terminal_state = 0, 
			isPressedActionEnabled = true
		},	
		nil, 0)
	end
	
	-- debug.print_r(_ED.active_activity[184], "==_ED.active_activity[184]")
	self:updateDraw()
end

function NewRecruitWish:onExit()
	-- 释放RecruitSuccessOneWindow界面资源.
	state_machine.remove("new_recruit_wish_open")
	state_machine.remove("new_recruit_wish_close")
	state_machine.remove("new_recruit_wish_show")
	state_machine.remove("new_recruit_wish_hide")
	state_machine.remove("new_recruit_wish_update_choose")
	state_machine.remove("new_recruit_wish_confirm_choose")
	state_machine.remove("new_recruit_wish_enter_formation_template")
	
end

function NewRecruitWish:close()
	-- window event : close.
	
end

function NewRecruitWish:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
