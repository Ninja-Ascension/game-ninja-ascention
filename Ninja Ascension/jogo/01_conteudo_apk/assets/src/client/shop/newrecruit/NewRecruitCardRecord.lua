--[[ ----------------------------------------------------------------------------
-- 抽卡记录
--]] ----------------------------------------------------------------------------
NewRecruitCardRecord = class("NewRecruitCardRecordClass", Window)

-- 打开窗口
local new_recruit_card_record_window_open_terminal = {
	_name = "new_recruit_card_record_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("NewRecruitCardRecordClass") then
			fwin:open(NewRecruitCardRecord:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local new_recruit_card_record_window_close_terminal = {
	_name = "new_recruit_card_record_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("NewRecruitCardRecordClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(new_recruit_card_record_window_open_terminal)
state_machine.add(new_recruit_card_record_window_close_terminal)
state_machine.init()

-- 构造器
function NewRecruitCardRecord:ctor()
	self.super:ctor()
	self.roots = {}

	-- var
    self.cardRecord = {}        -- 抽卡记录
    self.curPage = 1            -- 当前天数
    self.allPages = 1            -- 总天数
    self.records = 1            -- 历史记录数量
	-- load lua files.
	app.load("client.shop.newrecruit.NewRecruitCardRecordList")
	-- Initialize service carnival rule page state machine.
	local function init_new_recruit_card_record_terminal()
		-- 打开角色创建窗口
		local new_recruit_card_record_open_terminal = {
			_name = "new_recruit_card_record_open",
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
		local new_recruit_card_record_close_terminal = {
			_name = "new_recruit_card_record_close",
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
		local new_recruit_card_record_show_terminal = {
			_name = "new_recruit_card_record_show",
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
		local new_recruit_card_record_hide_terminal = {
			_name = "new_recruit_card_record_hide",
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

        -- 跳转页面
		local new_recruit_card_record_jump_page_terminal = {
			_name = "new_recruit_card_record_jump_page",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
                
				-- 跳转页面
				if nil ~= instance then
					local m_type = params._datas.m_type
					local curPage = instance.curPage
					local allPages = instance.allPagess
					if m_type == 1 then		-- 前往下一天
						if curPage == allPages then
							return false
						else 
							curPage = curPage + 1
						end
					elseif m_type == 2 then	-- 前往上一天
						if curPage == 1 then
							return false
						else
							curPage = curPage - 1
						end
					elseif m_type == 3 then	-- 前往最后一天
						if curPage == allPages then
							return false
						else 
							curPage = allPages
						end
					elseif m_type == 4 then	-- 前往第一天
						if curPage == 1 then
							return false
						else 
							curPage = 1
						end
					end
					-- local function responseCallback(response)
					-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					-- 		if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
					-- 			instance:updateListView(curPage)
					-- 		end
					-- 	end
					-- end
					-- protocol_command.view_draw_items.param_list = "" .. curPage
					-- NetworkManager:register(protocol_command.view_draw_items.code, nil, nil, nil, instance, responseCallback, false, nil)
					instance:updateListView(curPage)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(new_recruit_card_record_open_terminal)
		state_machine.add(new_recruit_card_record_close_terminal)
		state_machine.add(new_recruit_card_record_show_terminal)
		state_machine.add(new_recruit_card_record_hide_terminal)
		state_machine.add(new_recruit_card_record_jump_page_terminal)
		state_machine.init()
	end
	-- call func init service carnival rule state machine.
	init_new_recruit_card_record_terminal()
end

-- 绘制历史记录内容
function NewRecruitCardRecord:updateListView(curPage)
    self.curPage = curPage
	local data = _ED.newRecruitInfo
	if data == nil then
		return false
	end
	-- 总页数，当前页数
	local allRecords = data.recordLists
	local everyLists = tonumber(dms.int(dms["play_config"], 262, play_config.param))
	self.allPagess = math.ceil(allRecords / everyLists)
	if self.allPagess == 0 then
		self.allPagess = 1
	end
	-- local everyLists = 10
	-- local allPagess = 3
	self.scrollview:removeAllItems()
	local recordInfo = data.recordInfo
	-- local recordInfo = {{rewardInfo = "13,50,1,-1", reward_time = 123456897, rewardCoins = 20},{rewardInfo = "6,23,1,-1", reward_time = 123456897, rewardCoins = 20},{rewardInfo = "13,53,1,-1", reward_time = 123456897, rewardCoins = 20},{rewardInfo = "13,53,1,-1", reward_time = 123456897, rewardCoins = 20},{rewardInfo = "13,53,1,-1", reward_time = 123456897, rewardCoins = 20},{rewardInfo = "13,53,1,-1", reward_time = 123456897, rewardCoins = 20},{rewardInfo = "13,53,1,-1", reward_time = 12345689712, rewardCoins = 20},{rewardInfo = "13,53,1,-1", reward_time = 12345689712, rewardCoins = 20},{rewardInfo = "13,53,1,-1", reward_time = 12345689712, rewardCoins = 20},{rewardInfo = "13,53,1,-1", reward_time = 12345689712, rewardCoins = 20},{rewardInfo = "13,58,1,-1", reward_time = 12345689712, rewardCoins = 20},{rewardInfo = "13,56,1,-1", reward_time = 12345689712, rewardCoins = 20}}
	-- self.allRecords = #recordInfo
	-- self.allPagess = math.ceil(self.allRecords / everyLists)
	self.All_Page_Text:setString(self.allPagess.."")
	self.Cur_Page_Text:setString(self.curPage.."")
	for i = (self.curPage - 1)* everyLists + 1, self.curPage* everyLists do
		if recordInfo[i] ~= nil then
			local isShow = false
			if i % 2 == 1 then
				isShow = false
			else
				isShow = true
			end
			local cell = state_machine.excute("new_recruit_card_record_list_create", 0, {recordInfo[i], i, isShow})
			self.scrollview:addChild(cell)
		end
	end
	self.scrollview:requestRefreshView()
	self.scrollview:jumpToTop()

    self.listview_ContainerPosY = self.scrollview:getInnerContainer():getPositionY()
    -- self.curText:setString(self.curPage)
end

function NewRecruitCardRecord:onUpdate(dt)
    -- if self.scrollview ~= nil and #(self.scrollview:getItems()) > 0 then
    --     local posY = self.scrollview:getInnerContainer():getPositionY()
    --     if posY == self.listview_ContainerPosY then
    --         return
    --     end
    --     self.listview_ContainerPosY = posY

    --     -- local size = self.scrollview:getContentSize()
    --     -- local items = self._cell_group
    --     -- local itemSize = self._cell_size
    --     -- for i, v in pairs(items) do
    --     --     if v ~= nil and tolua.isnull(v) == false then
    --     --         if v ~= nil then
    --     --             local tempY = v:getPositionY() + posY
    --     --             if tempY + itemSize.height < 0 or tempY > size.height + itemSize.height then
    --     --                 v:unload()
    --     --             else
    --     --                 v:reload()
    --     --             end
    --     --         end
    --     --     end
    --     -- end
	-- 	local items = self.scrollview:getItems()
	-- 	if items[1] == nil then
	-- 		return
	-- 	end
	-- 	local itemSize = items[1]:getContentSize()
	-- 	for i, v in pairs(items) do
	-- 		local tempY = v:getPositionY() + posY
	-- 		if tempY + itemSize.height / 2 + itemSize.height < 0 or tempY > itemSize.height + itemSize.height / 2 then
	-- 			v:unload()
	-- 		else
	-- 			v:reload()
	-- 		end
	-- 	end
    -- end
end


function NewRecruitCardRecord:updateDraw()
	local root = self.roots[1]

	self.All_Page_Text = ccui.Helper:seekWidgetByName(root, "Text_4")
	self.Cur_Page_Text = ccui.Helper:seekWidgetByName(root, "Text_6")
	self.scrollview = ccui.Helper:seekWidgetByName(root, "ListView_1")
	self:updateListView(self.curPage)
end

-- 对象初始化
function NewRecruitCardRecord:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function NewRecruitCardRecord:onInit(params)
	self.curPage = params[1]
end


function NewRecruitCardRecord:onEnterTransitionFinish()
	-- 加载RecruitSuccessOneWindow界面资源.
	-- res.activity.service_carnival.new_recruit_card_record = res/shop/new_recruit_record.csb
	local csbNode = csb.createNode("shop/new_recruit_record.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
    self.nextDay = nil
    self.lastDay = nil
    self.finalDay = nil
    self.firstDay = nil
	-- 下一天按钮
	self.Button_next = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5"), nil,
	{
		terminal_name = "new_recruit_card_record_jump_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		m_type = 1,
	}, nil, 0)	

	-- 上一天按钮
	self.Button_last = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil,
	{
		terminal_name = "new_recruit_card_record_jump_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		m_type = 2,
	}, nil, 0)	

	-- 最后一天按钮
	self.Button_final = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_6"), nil,
	{
		terminal_name = "new_recruit_card_record_jump_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		m_type = 3,
	}, nil, 0)	

	-- 第一天按钮
	self.Button_first = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil,
	{
		terminal_name = "new_recruit_card_record_jump_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		m_type = 4,
	}, nil, 0)	

	-- 关闭按钮
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil,
	{
		terminal_name = "new_recruit_card_record_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	-- self.recordListView = ccui.Helper:seekWidgetByName(root, "listview")
	self:updateDraw()
end

function NewRecruitCardRecord:onExit()
	-- 释放RecruitSuccessOneWindow界面资源.
	state_machine.remove("new_recruit_card_record_open")
	state_machine.remove("new_recruit_card_record_close")
	state_machine.remove("new_recruit_card_record_show")
	state_machine.remove("new_recruit_card_record_hide")
	state_machine.remove("new_recruit_card_record_jump_page")
end

function NewRecruitCardRecord:close()
	-- window event : close.
	
end

function NewRecruitCardRecord:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
