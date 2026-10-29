----------------------------------------------------------------------------------------------------
-- 说明：大宝箱(爆竹类)
-- to:李彪
-------------------------------------------------------------------------------------------------------
-- app.load("client.cells.reward.BigBoxRewad")
BigBoxRewad = class("BigBoxRewadClass", Window)

function BigBoxRewad:ctor()
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
            _name = "big_box_rewad_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local big_box_rewad_select_index_submit_terminal = {
            _name = "big_box_rewad_select_index_submit",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- 请求使用
				--fwin:close(instance)
				
				instance:useProp()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(big_box_rewad_select_index_submit_terminal)
		state_machine.add(big_box_rewad_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_big_box_rewad_terminal()
end

function BigBoxRewad:addToIconPanel(cell)
	local vIndex = self.vacancyIndex
	local iconPanel = self.res.icon[vIndex]
	if nil ~= iconPanel then
		iconPanel:addChild(cell)
		self.vacancyIndex = self.vacancyIndex + 1
	end
end


function BigBoxRewad:getPropIconCell(mid, amount)
	app.load("client.cells.prop.model_prop_icon_cell")
	local iconCell = ModelPropIconCell:createCell()
	local config = iconCell:createConfig(mid, amount, true, 1)
	config.isDebris = true
	iconCell:init(config)
	return iconCell
end

function BigBoxRewad:checkupAndDraw(index)
	-- 检查到有什么就显示什么
	
	-- 体力
	local food = dms.int(dms["popper_reward"], index, popper_reward.get_of_combat_food)
	-- 贝利
	local silver = dms.int(dms["popper_reward"], index, popper_reward.get_of_silver)
	-- 宝石
	local gold = dms.int(dms["popper_reward"], index, popper_reward.get_of_gold)
	-- 悬赏值
	local bounty = dms.int(dms["popper_reward"], index, popper_reward.get_of_bounty)
	-- 将魂
	local soul = dms.int(dms["popper_reward"], index, popper_reward.get_of_soul)
	-- 魂玉 
	local jade = dms.int(dms["popper_reward"], index, popper_reward.get_of_jade)
	-- 道具
	local prop = dms.int(dms["popper_reward"], index, popper_reward.prop_mould)
	-- 霸气
	local power = dms.int(dms["popper_reward"], index, popper_reward.power_mould)
	-- 竞技点
	local arena = dms.int(dms["popper_reward"], index, popper_reward.get_of_arena_point)
	-- 装备
	local equipment = dms.int(dms["popper_reward"], index, popper_reward.get_of_equipment)
	
	
	if 0 ~= prop then
		-- 发现道具
		local prop_amount = dms.int(dms["popper_reward"], index, popper_reward.prop_amount)
		--调用显示
		local cell = self:getPropIconCell(prop, prop_amount)
		self:addToIconPanel(cell)
		--返回id记录
		return prop
		
	elseif 0 ~= equipment then
		-- ...
	end
	
	return nil
end

function BigBoxRewad:onUpdateDraw()
	
	-- 取出 爆竹 数据
	-- 爆竹奖励表
	local addition_group_index = dms.int(dms["prop_mould"], self.mouldId, prop_mould.addition_group_index)
	--> print("addition_group_index---------------------",addition_group_index ,popper_reward.popper_group)
	-- 遍历 匹配该值的 item
	local prData = dms["popper_reward"]
	
	self.idList ={}

	local index = 1
	for i = 1, table.getn(prData) do
		if tonumber(addition_group_index) == dms.int(dms["popper_reward"], i, popper_reward.popper_group) then
			--> print("iiiiiiiiiiiiiiiiiiiiiii---------------------",i)
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
				self.res.panel[index]:setVisible(true)
				index = index + 1
	        end
			local mid =  self:checkupAndDraw(i)
			table.insert(self.idList, i) -- 爆竹库索引
		end
	end

end

function BigBoxRewad:useProp()
	--> print("这里是selectIndex---333---------------------",self.selectIndex)
	local item_mouldid = self.mouldId
	 local function responseUsePropCallback(response)
		 if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then  --网络连接判断
			--> print("这里是selectIndex-------7777-----------------",self.selectIndex)
			--获得奖励
			-- 171
			-- 4
			-- 1
			-- 133 13 1
			
			-- 171
			-- 4
			-- 1
			-- 269 6 20
			
			-- 获取4的
			local rewardList = getSceneReward(4)
			
			if nil ~= rewardList then
				app.load("client.reward.AcquireRewad")
				local win = AcquireRewad:new()
				win:initRewad171(rewardList)
				fwin:open(win, fwin._dialog)
			end
			
			local PropPageWin = fwin:find("PropPageClass")
			if nil ~= PropPageWin then
				state_machine.excute("prop_list_cell_request_prop_use_clean", 0, {_datas ={_cell = self.cell}})
			end
			fwin:close(self)
		end
	end
	
	local _count = 1
	local prop = fundPropWidthId(item_mouldid)
	if nil ~= prop then
		local _prop_id = prop.user_prop_id
		--> print("这里是selectIndex-------4444-----------------",self.selectIndex)
		local _popper_id = self.idList[self.selectIndex]
		
		protocol_command.prop_use.param_list = _prop_id.."\r\n" .. _count.."\r\n" .._popper_id
		
		--> print("这里是selectIndex-------5555-----------------",self.selectIndex)
		
		--> print("这里是selectIndex-------6666-----------------",protocol_command.prop_use.param_list)
		
		NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, nil, responseUsePropCallback,false, nil)
	end
end

function  BigBoxRewad:updateSelectIndex(index)
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


function BigBoxRewad:registerTouchEvent(trigger)

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

function BigBoxRewad:onEnterTransitionFinish()
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
	
	-- local csbItem = csb.createNode("utils/select_award.csb")
	-- local root = csbItem:getChildByName("root")
	-- root:removeFromParent(false)
	-- self:addChild(root)
	-- table.insert(self.roots, root)
	
	self.res = {
		panel = {
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_12"),
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_13"),
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_14"),
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_15"),
        },
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

	for i=1,4 do
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
            self.res.panel[i]:setVisible(false)
        end
	end
	for i = 1, table.getn(self.res.touch) do
		local touch = self.res.touch[i]
		touch._index = i
		self:registerTouchEvent(touch)
	end

	self:onUpdateDraw()
	
	--确定
	-- fwin:addTouchEventListener(, nil, 
	-- {
		-- terminal_name = "big_box_rewad_select_index_submit", 
		-- cell = self,
	
	-- },
	-- nil, 1)	
	
	
	local function useProp_onTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if evenType == ccui.TouchEventType.began then
		elseif evenType == ccui.TouchEventType.moved then
		elseif evenType == ccui.TouchEventType.ended then -- or evenType == ccui.TouchEventType.canceled then
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
		terminal_name = "big_box_rewad_close", 
		cell = self,
		isPressedActionEnabled = true
	
	},
	nil, 2)	
end

function BigBoxRewad:onExit()
	state_machine.remove("big_box_rewad_close")
	state_machine.remove("big_box_rewad_select_index_submit")
end

-- mouldId
function BigBoxRewad:init(mouldId, cell)
	--> print("init mouldId---------------------------",mouldId)
	self.mouldId = mouldId
	
	self.cell = cell
end
