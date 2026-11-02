----------------------------------------------------------------------------------------------------
-- 说明：次日活动大宝箱
-- to:李彪
-------------------------------------------------------------------------------------------------------
-- app.load("client.cells.reward.ActivityNextDayBigBoxRewad")
ActivityNextDayBigBoxRewad = class("ActivityNextDayBigBoxRewadClass", Window)

function ActivityNextDayBigBoxRewad:ctor()
    self.super:ctor()
    -- 定义封装类中的变量
	self.roots = {}				-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.selectIndex = 0 		-- 当前点击选中的索引
	
	self.res = {				-- 资源集合
		icon = { -- 图标
		},
		choice = { -- 选中
		},	
		touch = { -- 响应区
		},	
		
	}
	
	self.idList ={} --存着每个显示的模板id
	
	self.vacancyIndex = 1	-- 空着的位置索引,用于创建时填入空位的.
	
	local function init_big_box_rewad_terminal()
		local big_box_rewad_close_terminal = {
            _name = "activity_next_day_big_box_rewad_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				fwin:close(cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local big_box_rewad_select_index_submit_terminal = {
            _name = "activity_next_day_big_box_rewad_select_index_submit",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				cell:useProp()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local big_box_rewad_enter_select_terminal = {
            _name = "big_box_rewad_enter_select",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				local index = params._datas._index
				cell:updateSelectIndex(index )
				-- cell:useProp()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		
		
		state_machine.add(big_box_rewad_select_index_submit_terminal)
		state_machine.add(big_box_rewad_close_terminal)
		state_machine.add(big_box_rewad_enter_select_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_big_box_rewad_terminal()
end

function ActivityNextDayBigBoxRewad:addToIconPanel(cell)
	local vIndex = self.vacancyIndex
	local iconPanel = self.res.icon[vIndex]
	if nil ~= iconPanel then
		iconPanel:addChild(cell)
		self.vacancyIndex = self.vacancyIndex + 1
	end
end


function ActivityNextDayBigBoxRewad:getPropIconCell(mid)
	app.load("client.cells.prop.model_prop_icon_cell")
	local iconCell = ModelPropIconCell:createCell()
	local config = iconCell:createConfig(mid, 1, true, 1, 13)
	config.isDebris = true
	iconCell:init(config)
	return iconCell
end


function ActivityNextDayBigBoxRewad:onUpdateDraw()
	for i = 1, table.getn(self.idList) do
		local cell = self:getPropIconCell(self.idList[i])
		self:addToIconPanel(cell)
	end
end

function ActivityNextDayBigBoxRewad:useProp()
	local activeItem = _ED.active_activity[48]
	
	if nil == activeItem then
		return
	end
	
	local item_mouldid = self.mouldId
	 local function responseUsePropCallback(response)
		 if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then  --网络连接判断
			local rewardList = getSceneReward(7)
			
			if nil ~= rewardList then
				app.load("client.reward.AcquireRewad")
				local win = AcquireRewad:new()
				win:initRewad171(rewardList)
				fwin:open(win, fwin._dialog)
			end
			state_machine.excute("activity_next_day_refresh_button", 0, {_datas={cell = self.cell}})
			fwin:close(self)
		end
	end

	local _activity_id = activeItem.activity_id
	protocol_command.draw_morrow_reward.param_list = _activity_id.."\r\n" ..(self.selectIndex-1)
	NetworkManager:register(protocol_command.draw_morrow_reward.code, nil, nil, nil, nil, responseUsePropCallback,false, nil)

end

function  ActivityNextDayBigBoxRewad:updateSelectIndex(index)
	self.selectIndex = index
	
	local choice = self.res.choice
	for i = 1 , table.getn(choice) do
		if i == index then
			choice[i]:setVisible(true)
		else
			choice[i]:setVisible(false)
		end
		
	end
end


function ActivityNextDayBigBoxRewad:registerTouchEvent(trigger)

	local function trigger_onTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if evenType == ccui.TouchEventType.began then
		elseif evenType == ccui.TouchEventType.moved then
		elseif evenType == ccui.TouchEventType.ended or evenType == ccui.TouchEventType.canceled then
			if math.abs(__epoint.x - __spoint.x) < 5 then
				--> print("registerTouchEvent-----------",sender._index )
				self:updateSelectIndex(sender._index )
			end
		end
	end
	trigger:addTouchEventListener(trigger_onTouchEvent)
end

function ActivityNextDayBigBoxRewad:onEnterTransitionFinish()
	self.selectIndex = 0
	self.vacancyIndex = 1
	
	local csbItem = csb.createNode("utils/select_award.csb")
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("utils/select_award.csb")
    -- table.insert(self.actions, action )
    csbItem:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "close" then
        	fwin:close(self)
        end
    end)
    action:play("window_open", false)

    self:addChild(csbItem)
	
	self.res = {
		icon = { -- 图标
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_20"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_21"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_22"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_23"),
		},
		choice = { -- 选中
			ccui.Helper:seekWidgetByName(self.roots[1], "Image_38"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Image_39"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Image_40"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Image_41"),
		},	
		touch = { -- 响应区
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_xy_01"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_xy_02"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_xy_03"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_xy_04"),
		},	
	}

	for i = 1, table.getn(self.res.touch) do
		local touch = self.res.touch[i]
		touch._index = i
		if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			fwin:addTouchEventListener(touch, nil, 
			{
				terminal_name = "big_box_rewad_enter_select", 
				cell = self,
				_index = i,
				terminal_state = 0,
				isPressedActionEnabled = true
			},
			nil, 2)
		else
			self:registerTouchEvent(touch)
		end
	end

	self:onUpdateDraw()

	local function useProp_onTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if evenType == ccui.TouchEventType.began then
		elseif evenType == ccui.TouchEventType.moved then
		elseif evenType == ccui.TouchEventType.ended or evenType == ccui.TouchEventType.canceled then
			--> print("这里是selectIndex-------1111-----------------",self.selectIndex)
			if self.selectIndex > 0 then
				--> print("这里是selectIndex----2222--------------------",self.selectIndex)
				self:useProp()
			end
		end
	end
	ccui.Helper:seekWidgetByName(self.roots[1], "Button_10"):addTouchEventListener(useProp_onTouchEvent)
	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_11"), nil, 
	{
		terminal_name = "activity_next_day_big_box_rewad_close", 
		cell = self,
		terminal_state = 0,
		isPressedActionEnabled = true
	},
	nil, 2)	
end

function ActivityNextDayBigBoxRewad:onExit()
	state_machine.remove("activity_next_day_big_box_rewad_close")
	state_machine.remove("activity_next_day_big_box_rewad_select_index_submit")
	state_machine.remove("big_box_rewad_enter_select")

end

function ActivityNextDayBigBoxRewad:init(heroList, cell)
	self.idList = heroList
	self.cell = cell
end
