-- ----------------------------------------------------------------------------------------------------
-- 说明：三国无双选择加成属性
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
AdditionSelect = class("AdditionSelectClass", Window)
    
function AdditionSelect:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.selectIndex = -1 --当前所选的属性加成选项索引
    -- Initialize AdditionSelect page state machine.
    local function init_guan_qia_terminal()
		--属性加成
		local addition_select_back_activity_terminal = {
            _name = "addition_select_back_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
				instance:nextLevel()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(addition_select_back_activity_terminal)
        state_machine.init()
    end
    
    -- call func init guan qia state machine.
    init_guan_qia_terminal()
end


function AdditionSelect:onUpdateDraw()
	
	
end

function AdditionSelect:nextLevel()
	-- local root = self.roots[1]
	-- local challenge_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_5_1"), nil, {func_string = [[state_machine.excute("trial_tower_challenge", 0, "trial_tower_challenge.'")]]}, nil, 0)
	-- local formation_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1"), nil, {func_string = [[state_machine.excute("trial_tower_formation", 0, "trial_tower_formation.'")]]}, nil, 0)
	-- --> print("ooooooooo",challenge_button)
	-- --战斗请求
		-- local function responseBattleInitCallback(response)
			-- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				-- BattleSceneClass.Draw()
			-- end
		-- end
			
			-- protocol_command.three_kingdoms_fight.param_list = 
					-- NetworkManager:register(protocol_command.three_kingdoms_fight.code, nil, nil, nil, nil, responseBattleInitCallback, true, nil)
					
	
	--检查是否选择了属性
	--发起属性请求
	--属性完成后,进入到下一关页面,即通知主窗口重刷数据
	local item = self.additionList[self.selectIndex]
	if nil == item then
		TipDlg.drawTextDailog(tipStringInfo_trialTower[11])
		return
	end
	
	local function responseBattleInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		
			--已作出选择,清理加成属性记录
			_ED.three_kingdoms_property = {}
			
			--关闭自己
			--fwin:close(self)
			if response.node ~= nil and response.node.actions ~= nil then
				response.node.actions[1]:play("window_close", false)
			end
			
			--通知主界面刷新到下一层
			state_machine.excute("trialtower_goto_next_level", 0, nil) 
			
		end
	end
	protocol_command.get_attribute.param_list = item
	NetworkManager:register(protocol_command.get_attribute.code, nil, nil, nil, self, responseBattleInitCallback, false, nil)
end

function AdditionSelect:initData()
	
end

function AdditionSelect:updateSelectIndex(index)

	local starI = self.starQ[index]
	if tonumber(_ED.three_kingdoms_view.left_stars) < starI[1] then
		TipDlg.drawTextDailog(tipStringInfo_trialTower[12])
		return
	end

	self.selectIndex = index
	-- self.selectQueue = {
		-- {atype=nil, img = nil},
		-- {atype=nil, img = nil},
		-- {atype=nil, img = nil},
	-- }
	local data = self.selectQueue[index]
	for i=1,3 do
		self.selectQueue[i].img:setVisible(false)
	end
	self.selectQueue[index].img:setVisible(true)
end


function AdditionSelect:registerTouchEvent(trigger)

	local function trigger_onTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if evenType == ccui.TouchEventType.began then
		elseif evenType == ccui.TouchEventType.moved then
		elseif evenType == ccui.TouchEventType.ended or evenType == ccui.TouchEventType.canceled then
			--if math.abs(__epoint.x - __spoint.x) < 5 then
				self:updateSelectIndex(sender._index)
			--end
		end
	end
	trigger:addTouchEventListener(trigger_onTouchEvent)
end

function AdditionSelect:onEnterTransitionFinish()
    local csbCampaign = csb.createNode("campaign/TrialTower/trial_tower_Addition.csb")	
    self:addChild(csbCampaign)
	local root = csbCampaign:getChildByName("root")
	table.insert(self.roots, root)
	
	
	
	local action = csb.createTimeline("campaign/TrialTower/trial_tower_Addition.csb")
    table.insert(self.actions, action )
    csbCampaign:runAction(action)
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
	
	
	--图标
	local iconQ = {
		"Panel_10",
		"Panel_11",
		"Panel_12",
	} 
	--显示属性名
	local nameQ = {
		"Text_shuxing1",
		"Text_shuxing2",
		"Text_shuxing3",
	} 
	
	--显示值
	local valueQ = {
		"Text_shuxing1_0",
		"Text_shuxing2_0",
		"Text_shuxing3_0",
	} 
	
	--str星数
	self.starQ = {
		{3,"Text_xh1"},
		{6,"Text_xh2"},
		{9,"Text_xh2_0"},
	}
	

	self.selectQueue = {
		{atype=nil, img = nil},
		{atype=nil, img = nil},
		{atype=nil, img = nil},
	}
	
	--当前可用星星
	ccui.Helper:seekWidgetByName(root,"Text_state"):setString(_ED.three_kingdoms_view.left_stars)
	
	
	--星星数--不够数的上红色
	self.additionList = {
		_ED.three_kingdoms_property.three_star,
		_ED.three_kingdoms_property.six_star,
		_ED.three_kingdoms_property.nine_star
	}
	--zstring.split(dms.string(dms["three_kingdoms_config"], self.index, three_kingdoms_config.attribute_add_id),",")
	for i = 1, 3 do
		local aIndex = self.additionList[i]
		
		local icon = dms.int(dms["three_kingdoms_attribute"], aIndex, three_kingdoms_attribute.attribute_sign_id)
		
		local list = zstring.split( dms.string(dms["three_kingdoms_attribute"], aIndex, three_kingdoms_attribute.attribute_value),",")
		
		local atype = tonumber(list[1])
		self.selectQueue[i].atype = atype
		
		local avalue = tonumber(list[2])
		
		ccui.Helper:seekWidgetByName(root,iconQ[i]):setBackGroundImage(string.format("images/ui/play/trial_tower/cg_buf_%d.png",icon))
		
		ccui.Helper:seekWidgetByName(root,nameQ[i]):setString(tipStringInfo_trialTower_attribute[icon+1])

		local str = tipStringInfo_trialTower_attribute_info[atype+1]
		
		local vStr = getTrialtowerAdditionFormatValue(atype+1, avalue)
		
		ccui.Helper:seekWidgetByName(root,valueQ[i]):setString(vStr)
		
		--ceshi
		-- local name = atype
		-- local value = avalue
		-- local one_atrr = {name, value}
		-- table.insert(_ED.three_kingdoms_view.atrribute, one_atrr)
		
		--检查用户星数
		local starI = self.starQ[i]
		if tonumber(_ED.three_kingdoms_view.left_stars) < starI[1] then
			ccui.Helper:seekWidgetByName(root,starI[2]):setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
		end
		ccui.Helper:seekWidgetByName(root,starI[2]):setString(starI[1])
		
	end
	
	local Panel_green = ccui.Helper:seekWidgetByName(root,"Panel_green")
	Panel_green._index = 1
	self.selectQueue[1].img = ccui.Helper:seekWidgetByName(root,"Image_9")
	self.selectQueue[1].img:setVisible(false)
	
	local Panel_blue = ccui.Helper:seekWidgetByName(root,"Panel_blue")
	Panel_blue._index = 2
	self.selectQueue[2].img = ccui.Helper:seekWidgetByName(root,"Image_9_0")
	self.selectQueue[2].img:setVisible(false)
	
	local Panel_red = ccui.Helper:seekWidgetByName(root,"Panel_red")
	Panel_red._index = 3
	self.selectQueue[3].img = ccui.Helper:seekWidgetByName(root,"Image_9_0_0")
	self.selectQueue[3].img:setVisible(false)
	
	self:registerTouchEvent(Panel_green)
	self:registerTouchEvent(Panel_blue)
	self:registerTouchEvent(Panel_red)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1"), nil, {
		func_string = [[state_machine.excute("addition_select_back_activity", 0, "addition_select_back_activity.'")]],
		isPressedActionEnabled = true,
	}, nil, 2)

	
	--对位
	function aligning(title, text)
		--调整字左对齐
		local x = title:getPositionX()
		local w = title:getContentSize().width
		text:setPositionX(x + w)
	end
	
	-- 当前的属性列表{属性名 - 属性值}
	local textQ = {
		{"Text_5",  "Text_6"}, --1
		
		{"Text_5_0",  "Text_6_0"}, --2
		
		{"Text_5_1",  "Text_6_1"}, --3
		
		{"Text_5_2",  "Text_6_2"}, --4
		
		{"Text_5_0_0",  "Text_6_0_0"}, --5
		
		{"Text_5_1_0",  "Text_6_1_0"}, --6
		
		{"Text_5_3",  "Text_6_3"}, --7
		
		{"Text_5_0_1",  "Text_6_0_1"}, --8
		
		{"Text_5_1_1",  "Text_6_1_1"}, --9
		
		{"Text_5_4",  " Text_6_4"}, --10
		
		{"Text_5_0_2",  "Text_6_0_2"}, --11
		
		{"Text_5_1_2",  "Text_6_1_2"}, --12
	}

	local atrribute = _ED.three_kingdoms_view.atrribute
	if table.getn(atrribute) > 0 then
		for i, v in ipairs(atrribute) do		
			if nil ~= tonumber(v[1]) and nil ~= tonumber(v[2]) then
			
				local title = ccui.Helper:seekWidgetByName(root, textQ[i][1])
				local text = ccui.Helper:seekWidgetByName(root, textQ[i][2])
				
				local value,name = getTrialtowerAdditionFormatValue(v[1], v[2]) 
				title:setString(name)
				text:setString(value)
				
				aligning(title, text)
			end
		end
	else
		ccui.Helper:seekWidgetByName(root,"Text_5_0_3"):setString(tipStringInfo_trialTower[13])
	end
	

end

-- 
function AdditionSelect:init()
	--self.index = index
end


function AdditionSelect:onExit()
	state_machine.remove("guan_qia_back_activity")
	state_machine.remove("trial_tower_challenge")
	state_machine.remove("trial_tower_formation")
	
end
