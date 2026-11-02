-- ----------------------------------------------------------------------------------------------------
-- 说明：奖励记录
-------------------------------------------------------------------------------------------------------
RichmanRewardRecord = class("RichmanRewardRecordClass", Window)

local richman_reward_record_window_open_terminal = {
    _name = "richman_reward_record_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RichmanRewardRecordClass") then
			fwin:open(RichmanRewardRecord:new():init(params), fwin._view)
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local richman_reward_record_window_close_terminal = {
    _name = "richman_reward_record_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("RichmanRewardRecordClass") then
            fwin:close(fwin:find("RichmanRewardRecordClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(richman_reward_record_window_open_terminal)
state_machine.add(richman_reward_record_window_close_terminal)
state_machine.init()

function RichmanRewardRecord:ctor()
    self.super:ctor()
    
    self.roots = {}

    self.curPage = 1            -- 当前页数
    self.allPagess = 0          -- 总页数
    
    app.load("client.activity.richman.RichmanRewardRecordList")

    local function init_richman_reward_record_terminal()
		-- 打开角色创建窗口
		local richman_reward_record_open_terminal = {
			_name = "richman_reward_record_open",
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
		local richman_reward_record_close_terminal = {
			_name = "richman_reward_record_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("richman_reward_record_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local richman_reward_record_show_terminal = {
			_name = "richman_reward_record_show",
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
		local richman_reward_record_hide_terminal = {
			_name = "richman_reward_record_hide",
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
		local richman_reward_record_jump_page_terminal = {
			_name = "richman_reward_record_jump_page",
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
					instance:updateListView(curPage)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(richman_reward_record_open_terminal)
		state_machine.add(richman_reward_record_close_terminal)
		state_machine.add(richman_reward_record_show_terminal)
		state_machine.add(richman_reward_record_hide_terminal)
		state_machine.add(richman_reward_record_jump_page_terminal)
        
		state_machine.init()
	end
	-- call func init richman_reward record state machine.
	init_richman_reward_record_terminal()
end

function RichmanRewardRecord:updateListView(curPage)
    self.curPage = curPage
	local activity_data = _ED.active_activity[187].activity_data
	if activity_data == nil then
		return false
	end
    
	self.ListView_1:removeAllItems()

	-- 总页数，当前页数
	local allRecords = table.nums(activity_data.rewardHistoryInfo)
	local everyLists = tonumber(dms.int(dms["activity_config"], 109, activity_config.param))
	local maxLists = tonumber(dms.int(dms["activity_config"], 108, activity_config.param))
    allRecords = allRecords >= maxLists and maxLists or allRecords
	self.allPagess = math.ceil(allRecords / everyLists)
    self.allPagess = self.allPagess == 0 and 1 or self.allPagess
	local recordInfo = activity_data.rewardHistoryInfo

    self.Text_2:setString(self.curPage.."/"..self.allPagess)
	for i = (self.curPage - 1)* everyLists + 1, self.curPage* everyLists do
		if recordInfo[i] ~= nil then
			local isShow = false
			if i % 2 == 1 then
				isShow = false
			else
				isShow = true
			end
			local cell = state_machine.excute("richman_reward_record_list_create", 0, {recordInfo[i], i, isShow})
			self.ListView_1:addChild(cell)
		end
	end
	self.ListView_1:requestRefreshView()
	self.ListView_1:jumpToTop()
end

function RichmanRewardRecord:onUpdateDraw()
    local root = self.roots[1]
    -- 历史记录列表
   self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
   -- 页数文本
   self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
   
	self:updateListView(self.curPage)
end

-- 对象初始化
function RichmanRewardRecord:init(params)
	if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function RichmanRewardRecord:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/dafuweng/dafuweng_jilv.csb")
	local root = csbNode:getChildByName("root")
    self:addChild(csbNode)
    table.insert(self.roots, root)

    -- 下一页
    self.Button_3 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil,
	{
		terminal_name = "richman_reward_record_jump_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		m_type = 1,
	}, nil, 0)	
    
    -- 上一页
    self.Button_3_0 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_0"), nil,
	{
		terminal_name = "richman_reward_record_jump_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		m_type = 2,
	}, nil, 0)	

    -- 最后一页
    self.Button_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil,
	{
		terminal_name = "richman_reward_record_jump_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		m_type = 3,
	}, nil, 0)	

    -- 第一页
    self.Button_2_0 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2_0"), nil,
	{
		terminal_name = "richman_reward_record_jump_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		m_type = 4,
	}, nil, 0)	

    -- 关闭
    self.Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil,
	{
		terminal_name = "richman_reward_record_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
		m_type = 1,
	}, nil, 0)	

    self:onUpdateDraw()
end

function RichmanRewardRecord:onExit()
    state_machine.remove("richman_reward_record_open")
	state_machine.remove("richman_reward_record_close")
	state_machine.remove("richman_reward_record_show")
	state_machine.remove("richman_reward_record_hide")
	state_machine.remove("richman_reward_record_jump_page")
end


function RichmanRewardRecord:close()
	-- window event : close.
	
end

function RichmanRewardRecord:destroy(window)
	-- window event : destroy.
	
end
