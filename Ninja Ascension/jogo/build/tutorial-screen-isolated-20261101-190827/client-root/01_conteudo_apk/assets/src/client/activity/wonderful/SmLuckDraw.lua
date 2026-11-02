--[[ ----------------------------------------------------------------------------
-- 幸运拉霸主界面
--]] ----------------------------------------------------------------------------
SmLuckDraw = class("SmLuckDrawClass", Window)

-- 打开窗口
local sm_luck_draw_window_open_terminal = {
	_name = "sm_luck_draw_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SmLuckDrawClass") then
			fwin:open(SmLuckDraw:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local sm_luck_draw_window_close_terminal = {
	_name = "sm_luck_draw_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmLuckDrawClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}


state_machine.add(sm_luck_draw_window_open_terminal)
state_machine.add(sm_luck_draw_window_close_terminal)
state_machine.init()

-- 构造器
function SmLuckDraw:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.start_up_page = 1
	self.panelSpecialTable = {}
	-- load lua files.
    app.load("client.activity.wonderful.SmLuckDrawWindow10")
    app.load("client.activity.wonderful.SmLuckDrawRecord")
    app.load("client.activity.wonderful.SmLuckDrawReview")

	-- Initialize sm luck draw page state machine.
	local function init_sm_luck_draw_terminal()
		-- 打开角色创建窗口
		local sm_luck_draw_open_terminal = {
			_name = "sm_luck_draw_open",
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
		local sm_luck_draw_close_terminal = {
			_name = "sm_luck_draw_close",
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
		local sm_luck_draw_show_terminal = {
			_name = "sm_luck_draw_show",
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
		local sm_luck_draw_hide_terminal = {
			_name = "sm_luck_draw_hide",
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

		-- 转
        local sm_luck_draw_terminal = {
			_name = "sm_luck_draw",
			_init = function (terminal) 
				
		
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 

				local type = tonumber(params._datas.type)
				instance.type = type

				state_machine.lock("sm_luck_draw")
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							-- response.node._needNumber = 0
							response.node:startRound()
    						response.node:onUpdateDrawInfo()

							-- local machine_data = zstring.split(_ED.union_slot_machine_data ,",")
							-- response.node.start_up_page = 1
							-- for i,v in pairs(machine_data) do
							-- 	if tonumber(v) ==6 then
							-- 		response.node.start_up_page = response.node.start_up_page + 1
							-- 	end
							-- end
							-- instance:updateButton()
							-- state_machine.excute("home_map_update_build", 0, nil)
							-- state_machine.lock("sm_union_slot_machine_close")
						end
					else
						state_machine.unlock("sm_luck_draw")   
					end
				end     
				protocol_command.lucky_pull_rod_start.param_list = type
				NetworkManager:register(protocol_command.lucky_pull_rod_start.code, nil, nil, nil, instance, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(sm_luck_draw_terminal)
		state_machine.add(sm_luck_draw_open_terminal)
		state_machine.add(sm_luck_draw_close_terminal)
		state_machine.add(sm_luck_draw_show_terminal)
		state_machine.add(sm_luck_draw_hide_terminal)
		state_machine.init()
	end
	-- call func init sm luck draw state machine.
	init_sm_luck_draw_terminal()
end

-- 对象初始化
function SmLuckDraw:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function SmLuckDraw:onUpdateDraw()
	local root = self.roots[1]
	-- 主界面动画
	self.Panel_effice = ccui.Helper:seekWidgetByName(root, "Panel_effice")
	-- 规则显示列表容器
	self.ListView_rule = ccui.Helper:seekWidgetByName(root, "ListView_rule")
	self:onUpdateDrawInfo()
	-- 主界面动画
	-- 	effice_luck_draw_box---界面左边宝箱展示动画
	-- 其中动画组animation为宝箱开启，animation2为开启后宝箱待机

	-- effice_luck_draw_frame---出现稀有道具的边框动画
	-- 其中动画组只有animation一个
	local jsonFile = "images/ui/effice/effice_luck_draw_box/effice_luck_draw_box.json"
	local atlasFile = "images/ui/effice/effice_luck_draw_box/effice_luck_draw_box.atlas"
	self.skeletonBox = sp.SkeletonAnimation:create(jsonFile, atlasFile, 1)
	-- self.skeletonBox:setPosition( cc.p( 50, 100) )
	self.skeletonBox:setAnimation(0, "animation2", true)
	self.Panel_effice:addChild(self.skeletonBox)
	-- 动画
	self.start_up_page = 1
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_act_tank_draw/effect_act_tank_draw.ExportJson")
    self.ArmatureNodes = {}
    for i=1,6 do
        local panel = ccui.Helper:seekWidgetByName(root, "Panel_laba_"..i)
        panel:removeAllChildren(true)
        panel:removeBackGroundImage()
        local cell = ccs.Armature:create("effect_act_tank_draw")
        cell:getAnimation():playWithIndex(0)
        cell:setAnchorPoint(0.5,0.5)
        cell.index = i
        cell._number = 0
        cell._over = false
        table.insert(self.ArmatureNodes,cell)
		-- cell:setPosition(cc.p(panel:getContentSize().width/2,150))
		local sprite2 = cc.Sprite:create("images/ui/text/NIUDAN_res/icon_di_nothing_0.png")
		cell:getBone("Layer_tank_2"):addDisplay(sprite2, 0)
		cell:setTag(100)
		panel:addChild(cell)
        local panelSpecial = ccui.Helper:seekWidgetByName(root, "Panel_special_"..i)
		table.insert(self.panelSpecialTable, panelSpecial)
		self:addProAni(panelSpecial)

    end
    local function resetOver_changeActionCallback(armatureBack)
        local armature = armatureBack
        if armature ~= nil then
            local actionIndex = armature._actionIndex
            if actionIndex == 0 then
                -- armature._nextAction = 1
                if tonumber(armature.index) == 6 and armature._over ~= false then
                    -- self.isOver = true
                    self.isOver = true
                    self.isCanSpeedUp = true
                    armature._over = false
                    -- checkPlayEffect(67)
                    -- state_machine.excute("red_alert_time_congratulations_get_window_open", 0, self._activity_type.activity_type)
                    -- self:updateButton()
                    -- state_machine.unlock("sm_union_slot_machine_close")
                    
                end
                if armature._over ~= false then
                    armature._over = false
                    -- checkPlayEffect(67)
                end
            elseif actionIndex == 1 then
                local function stopRoundFuncN(sender)
                    armature._nextAction = 2
                end
                self.ArmatureNodes[tonumber(armature.index)]:runAction(cc.Sequence:create(
                cc.DelayTime:create((tonumber(armature.index)-1)*0.05),
                cc.CallFunc:create(stopRoundFuncN)))
            elseif actionIndex == 2 then
                armature._number = 0
                -- armature._nextAction = 0

                if tonumber(armature.index) == 6 and armature._over ~= false then
                    self.isOver = true
					self:showLight()
					local function showRewardFuncN(sender)
						self:showReward()
					end
					self:runAction(cc.Sequence:create(
					cc.DelayTime:create(0.5),
					cc.CallFunc:create(showRewardFuncN)))
                    -- state_machine.unlock("sm_union_slot_machine_change_lottery")  
                    state_machine.unlock("sm_luck_draw")
                end
                armature._over = true
                self.isCanSpeedUp = false
            end
        end
    end
    
    local function drawFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
        local armature = bone:getArmature()
        if evt == "change" then
            self:replaceSkeleton(armature.index)
        end
    end
        
    for i=self.start_up_page,6 do    
        -- self.ArmatureNodes[i]:getAnimation():playWithIndex(1)
        self.ArmatureNodes[i]:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        self.ArmatureNodes[i]._actionIndex = 0
        self.ArmatureNodes[i]._nextAction = 0
        self.ArmatureNodes[i]._invoke = resetOver_changeActionCallback
        self.ArmatureNodes[i]:getAnimation():setFrameEventCallFunc(drawFrameEvent)
    end


end
--开始转动 
function SmLuckDraw:startRound()
	self.isOver = false
	self.skeletonBox:setAnimation(0, "animation", false)
	self.skeletonBox:addAnimation(0, "animation2", true)
	
	for i,v in pairs(self.panelSpecialTable) do
		v:setVisible(false)
	end

    for i=self.start_up_page,6 do
        -- self.ArmatureNodes[i]:getAnimation():playWithIndex(0)
        csb.animationChangeToAction(self.ArmatureNodes[i], 0, 0, false)
        local function startRoundFuncN(sender)
            if self.isOver == false then
                self.ArmatureNodes[i]._over = false
                self.ArmatureNodes[i]._nextAction = 1
            end
        end
        self.ArmatureNodes[i]:runAction(cc.Sequence:create(
        -- cc.DelayTime:create((i-1)/2),
        cc.CallFunc:create(startRoundFuncN)))
    end 
end
function SmLuckDraw:showReward()
	-- if _ED.active_activity[161].activity_params.extObj.totalReward == "" then
	
	if _ED.active_activity[162].isReward == 0 then
		if self.type == 1 then --十次
			TipDlg.drawTextDailog(dms.string(dms.searchs(dms["activity_error_code"], 1,26029), 1, 3))
		else
			state_machine.excute("sm_luck_draw_window10_window_open", 0, 0)
		end
	else
		if self.type == 10 then
			state_machine.excute("sm_luck_draw_window10_window_open", 0, 0)
		else
			local getRewardWnd = DrawRareReward:new()
			getRewardWnd:init(7)
			fwin:open(getRewardWnd,fwin._ui)
		end
	end
end
function SmLuckDraw:addProAni(panel)
	-- effice_luck_draw_frame---出现稀有道具的边框动画
	-- 其中动画组只有animation一个
    local jsonFile = "images/ui/effice/effice_luck_draw_frame/effice_luck_draw_frame.json"
	local atlasFile = "images/ui/effice/effice_luck_draw_frame/effice_luck_draw_frame.atlas"
	local skeletonBox = sp.SkeletonAnimation:create(jsonFile, atlasFile, 1)
	skeletonBox:setAnimation(0, "animation", true)
	skeletonBox:setTag(50)
	panel:addChild(skeletonBox)
end

function SmLuckDraw:replaceSkeleton(index)
    -- debug.print_r(self._activity_type)
    local root = self.roots[1]
    -- local activity_info = zstring.split(self._activity_type.activity_add_state,"|")
    -- local activity_optimal_tank = zstring.split(activity_info[#activity_info],",")
    -- for i=1,3 do
        local panel = ccui.Helper:seekWidgetByName(root, "Panel_laba_"..index)
        local cell = panel:getChildByTag(100)
		local cellres = ResourcesIconCell:createCell()
		local reward = _ED.active_activity[162].pullResult[1].returnIconId[index]
		if 13 == tonumber(reward[1]) then
			local table = {}
			if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
				table.shipStar = tonumber(reward[4])
			else
				table.shipStar = 0
			end
			cellres:init(reward[1], 0, tonumber(reward[2]),nil,nil,true,true,1,table)
		else
			cellres:init(reward[1], 0, tonumber(reward[2]),nil,nil,true,true,1)
		end
		local sprite = cc.Sprite:createWithTexture(cellres.panel_prop:getTexture())
		sprite:setScale(0.8)
		sprite:setPosition(40,40)
		local sprite2 = cc.Sprite:create("images/ui/text/NIUDAN_res/icon_di_nothing_0.png")
		sprite2:addChild(sprite)
		if tonumber(reward[1]) == 6 then 
			local footerData = dms.string(dms["prop_mould"], tonumber(reward[2]), prop_mould.trace_remarks)
			local footerInfo = zstring.split(footerData ,",")
			if footerInfo[1] ~= nil and tonumber(footerInfo[1])~= -1 then
				local props_left_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[1])))
				props_left_icon:setScale(0.8)
				props_left_icon:setPosition(cc.p(sprite2:getContentSize().width/5,sprite2:getContentSize().height - 10))
				sprite2:addChild(props_left_icon)
			end
		end
        cell:getBone("Layer_tank_2"):addDisplay(sprite2, 0)
	-- end
		
end
function SmLuckDraw:showLight()
	for k=1,6 do
		local reward = _ED.active_activity[162].pullResult[1].returnIconId[k]
		if tonumber(reward[1])==tonumber(self.aReward[1]) and tonumber(reward[2])==tonumber(self.aReward[2]) then
			self.panelSpecialTable[k]:setVisible(true)
		end
	end
end

function SmLuckDraw:replaceSkeletonAll()
	for i=1,6 do
		local cell = self.ArmatureNodes[i]
		for k=1,6 do
			local displayParams = zstring.splits(_ED.active_activity[162].allRule, "|", ",")
			local cellres = ResourcesIconCell:createCell()
			local reward = ''
			if k == 2 then
				reward = displayParams[1]
				self.aReward = displayParams[1]
			else
				reward = displayParams[math.random(2, 6)]
			end
			if 13 == tonumber(reward[1]) then
				local table = {}
				if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
					table.shipStar = tonumber(reward[4])
				else
					table.shipStar = 0
				end
				cellres:init(reward[1], 0, tonumber(reward[2]),nil,nil,true,true,1,table)
			else
				cellres:init(reward[1], 0, tonumber(reward[2]),nil,nil,true,true,1)
			end
			local sprite = cc.Sprite:createWithTexture(cellres.panel_prop:getTexture())
			sprite:setScale(0.8)
			sprite:setPosition(40,40)
			local sprite2 = cc.Sprite:create("images/ui/text/NIUDAN_res/icon_di_nothing_0.png")
			sprite2:addChild(sprite)

			if tonumber(reward[1]) == 6 then 
				local footerData = dms.string(dms["prop_mould"], tonumber(reward[2]), prop_mould.trace_remarks)
				local footerInfo = zstring.split(footerData ,",")
				if footerInfo[1] ~= nil and tonumber(footerInfo[1])~= -1 then
					local props_left_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[1])))
					props_left_icon:setScale(0.8)
					props_left_icon:setPosition(cc.p(sprite2:getContentSize().width/5,sprite2:getContentSize().height - 10))
					sprite2:addChild(props_left_icon)
				end
			end

			cell:getBone("Layer_tank_"..k):addDisplay(sprite2, 0)
		end
	end
end

function SmLuckDraw:initData()
	local function responseChanllengeCallback(response)
		if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
			return
		end
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			response.node:replaceSkeletonAll()
		else
			-- response.node.Button_luck_free:setTouchEnabled(true)
			-- response.node.Button_luck_ten:setTouchEnabled(true)
		end
	end
	NetworkManager:register(protocol_command.lucky_pull_rod_init.code, nil, nil, nil, self, responseChanllengeCallback, false, nil)
end

-- 更新界面信息 
function SmLuckDraw:onUpdateDrawInfo()
	local root = self.roots[1]
	-- 一次转动拉霸券图标
	self.Image_xianshi_1 = ccui.Helper:seekWidgetByName(root, "Image_xianshi_1")
	-- 十次转动拉霸券图标
	self.Image_xianshi_2 = ccui.Helper:seekWidgetByName(root, "Image_xianshi_2")
	-- 一次转动金币图标
	self.Image_zuanshi_1 = ccui.Helper:seekWidgetByName(root, "Image_zuanshi_1")
	-- 十次转动金币图标
	self.Image_zuanshi_2 = ccui.Helper:seekWidgetByName(root, "Image_zuanshi_2")
	-- 一次转动花费数值
	self.Text_zuanshi_1 = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_1")
	-- 十次转动花费数值
	self.Text_zuanshi_2 = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_2")
	--显示消耗钻石 
	local zs = zstring.split(dms.string(dms["activity_config"], 58, 4),",")
	
	self.Text_zuanshi_1:setString(zs[1])
	self.Text_zuanshi_2:setString(zs[2])
	-- 抽取券
    local lvs = zstring.tonumber(dms.string(dms["shop_config"], 26, shop_config.param))
    if lvs > 0 then
        local needPropNumber = 0
        if fundPropWidthId(lvs) then
            needPropNumber = zstring.tonumber(fundPropWidthId(lvs).prop_number)
		end
		
		if needPropNumber >= 10 then
			self.Text_zuanshi_1:setString('1')
			self.Text_zuanshi_2:setString('10')
			self.Image_xianshi_1:setVisible(true)
			self.Image_xianshi_2:setVisible(true)
			self.Image_zuanshi_1:setVisible(false)
			self.Image_zuanshi_2:setVisible(false)
		elseif needPropNumber >= 1 then
			self.Text_zuanshi_1:setString('1')
			self.Text_zuanshi_2:setString(zs[2])
			self.Image_xianshi_1:setVisible(true)
			self.Image_xianshi_2:setVisible(false)
			self.Image_zuanshi_1:setVisible(false)
			self.Image_zuanshi_2:setVisible(true)
		else
			self.Text_zuanshi_1:setString(zs[1])
			self.Text_zuanshi_2:setString(zs[2])
			self.Image_xianshi_1:setVisible(false)
			self.Image_xianshi_2:setVisible(false)
			self.Image_zuanshi_1:setVisible(true)
			self.Image_zuanshi_2:setVisible(true)
		end
    end
end

function SmLuckDraw:onEnterTransitionFinish()
	-- 加载SmLuckDrawWindow界面资源.
	-- res.activity.wonderful.sm_luck_draw = res/activity/wonderful/sm_luck_draw.csb
	local csbNode = csb.createNode("activity/wonderful/sm_luck_draw.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	
	self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")

	-- 一次转动
	self.Button_pull = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pull"), nil,
	{
		terminal_name = "sm_luck_draw",
		terminal_state = 0,
		isPressedActionEnabled = true,
		type = 1
	}, nil, 0)	

	-- 十次转动
	self.Button_pull_10 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pull_10"), nil,
	{
		terminal_name = "sm_luck_draw",
		terminal_state = 0,
		isPressedActionEnabled = true,
		type = 10
	}, nil, 0)	

	-- 再转一次
	self.Button_pull_0 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pull_0"), nil,
	{
		terminal_name = "",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 再转十次
	self.Button_pull_10_0 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pull_10_0"), nil,
	{
		terminal_name = "",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 跳转至预览界面
	self.Button_review = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_review"), nil,
	{
		terminal_name = "sm_luck_draw_review_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 跳转至获奖记录界面
	self.Button_jilu = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jilu"), nil,
	{
		terminal_name = "sm_luck_draw_record_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 勾选跳过动画
	self.CheckBox_skip = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_skip"), nil,
	{
		terminal_name = "",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed_pr1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "sm_luck_draw_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:initData()
	self:onUpdateDraw()
end

function SmLuckDraw:onUpdate(dt)
	if self.Text_time ~= nil then
	    self:updateDrawActivityTime(os.time() + _ED.time_add_or_sub)
	end
end
function SmLuckDraw:updateDrawActivityTime(times)
    local root = self.roots[1]
    if root == nil then
        return
    end
    local activity = _ED.active_activity[162]
    local surplus_time = (activity.end_time - ((times))*1000)
    self.Text_time:setString(surplus_time < 0 and _string_piece_info[305] or getRedAlertTimeActivityFormat(surplus_time / 1000))
end

function SmLuckDraw:onExit()
	-- 释放SmLuckDrawWindow界面资源.
	state_machine.remove("sm_luck_draw_open")
	state_machine.remove("sm_luck_draw_close")
	state_machine.remove("sm_luck_draw_show")
	state_machine.remove("sm_luck_draw_hide")
	state_machine.remove("sm_luck_draw")
	
end

function SmLuckDraw:close()
	-- window event : close.
	
end

function SmLuckDraw:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
