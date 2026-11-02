-- ----------------------------------------------------------------------------------------------------
-- 说明：豪华首冲活动
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityRichFirstRecharge = class("ActivityRichFirstRechargeClass", Window)

local activity_rich_first_recharge_open_terminal = {
    _name = "activity_rich_first_recharge_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
	_invoke = function(terminal, instance, params)
		if nil == _ED.active_activity[144] then
			if fwin:find("ActivityRichFirstRechargeClass") then
				fwin:close(fwin:find("ActivityRichFirstRechargeClass"))
			end		
			return
		end 
    	if nil == fwin:find("ActivityRichFirstRechargeClass") then
			fwin:open(ActivityRichFirstRecharge:new():init(params), fwin._windows)
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_rich_first_recharge_close_terminal = {
    _name = "activity_rich_first_recharge_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ActivityRichFirstRechargeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_rich_first_recharge_open_terminal)  
state_machine.add(activity_rich_first_recharge_close_terminal)  
state_machine.init()
function ActivityRichFirstRecharge:ctor()
    self.super:ctor()
	self.roots = {}
	self.loaded = false
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	
	self.reworld_sorting = {}
	self.Panel_shouchong = {}

    -- Initialize ActivityRichFirstRecharge state machine.
    local function init_activity_rich_first_recharge_terminal()
		--前往充值
		local go_to_rechargeable_button_terminal = {
            _name = "go_to_rechargeable_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
	         --    if __lua_project_id == __lua_project_l_digital 
	         --    	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
	         --    	or __lua_project_id == __lua_project_l_naruto 
	         --    	then
		        --     if funOpenDrawTip(181) == true then
		        --         return
		        --     end
		        -- end
				fwin:open(RechargeDialog:new(), fwin._windows)
				fwin:close(fwin:find("ActivityRichFirstRechargeClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --获取奖励
		local go_to_get_reword_terminal = {
            _name = "go_to_get_reword",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local _self = params._datas.tab
            	-- local exit = false
            	-- if _self.curIndex == #_ED.active_activity[144].activity_Info then
            	-- 	exit = true
            	-- end
	            local function callBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- response.node:isDrawedUpdateDraw()
						app.load("client.reward.DrawRareReward")
						local getRewardWnd = DrawRareReward:new()
						getRewardWnd:init(7)
						fwin:open(getRewardWnd, fwin._windows)
						-- if exit then
						-- 	fwin:close(fwin:find("ActivityRichFirstRechargeClass"))
						-- else
						-- 	_self:sortDatas(_self.curIndex)
						-- end
						if response.node and response.node.roots and response.node.roots[1] then
							_self:sortDatas(_self.curIndex)
						end
					end
				end
				protocol_command.get_activity_reward.param_list = "".._ED.active_activity[144].activity_id.."\r\n"..(_self.curIndex - 1).."\r\n".."1"
				NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, _self, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --按钮切换
		local button_recharge_tab_terminal = {
            _name = "Button_recharge_tab",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local id = params._datas.index
	            instance:buttonThreeTab(id)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(go_to_rechargeable_button_terminal)
		state_machine.add(go_to_get_reword_terminal)
		state_machine.add(button_recharge_tab_terminal)
        state_machine.init()
    end
    init_activity_rich_first_recharge_terminal()
end

function ActivityRichFirstRecharge:onUpdateDraw(id)
    local root = self.roots[1]
    self.curIndex = id
    local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_recharge_three_reward")
    local Button_recharge = ccui.Helper:seekWidgetByName(root, "Button_recharge")
    local Text_recharge_three_tips = ccui.Helper:seekWidgetByName(root, "Text_recharge_three_tips")
    local LoadingBar_recharge = ccui.Helper:seekWidgetByName(root, "LoadingBar_recharge")
    local Image_recharge = ccui.Helper:seekWidgetByName(root, "Image_recharge")
    local Button_receive  = ccui.Helper:seekWidgetByName(root, "Button_receive")
    local Image_7  = ccui.Helper:seekWidgetByName(root, "Image_7")
    local Panel_recharge_three_pic  = ccui.Helper:seekWidgetByName(root, "Panel_recharge_three_pic")
    local Image_recharge_01  = ccui.Helper:seekWidgetByName(root, "Image_recharge_01")

    ListViewDraw:removeAllItems()
    local activeItem = _ED.active_activity[144]
    if nil == ListViewDraw or nil == activeItem then
		return
	end
	Panel_recharge_three_pic:removeBackGroundImage()
	Panel_recharge_three_pic:setBackGroundImage("images/ui/text/sm_hd/recharge_three/recharge_three_pic_" .. id .. ".png")

	for i, v in ipairs(self.Panel_shouchong) do
		v:setVisible(id == i)
	end

	--已经充值
	local curRecharge = tonumber(activeItem.activity_params)
	--需要充值
	Text_recharge_three_tips:removeAllChildren(true)
	local needRecharge = tonumber(activeItem.activity_Info[id].activityInfo_need_day)
	if curRecharge < needRecharge then
		local textColor = chat_rich_text_color
		-- DSC重塑
		if __lua_project_id == __lua_project_l_digital then
			textColor = chat_rich_text_two_color
		end
		local char_str = string.format(tipStringInfo_new_activity_tips[1], "%|8|" .. curRecharge .. "%", "%|8|" .. (needRecharge-curRecharge) .. "%")
		local _richText = ccui.RichText:create()
	    _richText:ignoreContentAdaptWithSize(false)
	    _richText:setContentSize(cc.size(5000, 0))
	    _richText:setAnchorPoint(cc.p(0, 0))
	    local rt, count, text = draw.richTextCollectionMethod(_richText, 
	        char_str, 
	        cc.c3b(255, 255, 255),
	        cc.c3b(255, 255, 255),
	        0, 
	        0, 
	        Text_recharge_three_tips:getFontName(), 
	        Text_recharge_three_tips:getFontSize(),
	        textColor)

	    _richText:formatTextExt()
	    local rsize = _richText:getContentSize()
	    _richText:setPosition(cc.p(0, rsize.height))
	    Text_recharge_three_tips:setString("")
	    Text_recharge_three_tips:addChild(_richText)
	    Image_recharge_01:setVisible(true)
		LoadingBar_recharge:setPercent(curRecharge/needRecharge*100)
	else
		Text_recharge_three_tips:removeAllChildren(true)
		Text_recharge_three_tips:setString("")
		LoadingBar_recharge:setPercent(100)
		Image_recharge_01:setVisible(false)
	end
	-- 领取状态
	local state = 0
	for i,info in ipairs(self.needRecharges) do
		if info.id == id then
			state = info.state
		end
	end

	if state == 0 then
		Button_recharge:setVisible(false)
		Button_receive:setVisible(true)
		Image_7:setVisible(false)
		LoadingBar_recharge:setVisible(false)
		Image_recharge:setVisible(false)
	elseif state == 1 then
		Button_recharge:setVisible(true)
		Button_receive:setVisible(false)
		Image_7:setVisible(false)
		LoadingBar_recharge:setVisible(true)
		Image_recharge:setVisible(true)
	elseif state == 2 then
		Button_recharge:setVisible(false)
		Button_receive:setVisible(false)
		Image_7:setVisible(true)
		LoadingBar_recharge:setVisible(false)
		Image_recharge:setVisible(false)
	end

	local scaleBase = ListViewDraw:getScale()
	local centerPosX = Button_recharge:getPositionX()
	local cellSize = 0
	local index = 1
	-- 奖励
    local rewards = zstring.splits(activeItem.activity_Info[id].activityInfo_reward_select, "|", ",")
    local activity_count = tonumber(#rewards)
    for i, reward in ipairs(rewards) do
        local rewardType = zstring.tonumber(reward[1])
        local cell = ResourcesIconCell:createCell()
        if 13 == rewardType then
            local table = {}
            if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
                table.shipStar = tonumber(reward[4])
            end
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1,table)
        else
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1)
        end
        cellSize = cell:getContentSize().width
        local rewardinfo = {}
        rewardinfo.type = rewardType
        rewardinfo.id = reward[2]
        rewardinfo.number = tonumber(reward[3])
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
        ListViewDraw:addChild(cell)
	end

	ListViewDraw:requestRefreshView()

	local cellsAllSize = (cellSize*activity_count + (activity_count -1)*ListViewDraw:getItemsMargin())*scaleBase
	local newPosX = centerPosX - cellsAllSize/2
	ListViewDraw:setPositionX(newPosX)

	self:tabRedotShow()
end

function ActivityRichFirstRecharge:onUpdate(dt)
    
end

function ActivityRichFirstRecharge:onEnterTransitionFinish()

end

function ActivityRichFirstRecharge:onInit( )
    local csbItem = csb.createNode("activity/wonderful/recharge_three.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

	-- 关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recharge_three_close"), nil, 
	{
		terminal_name = "activity_rich_first_recharge_close", 
		terminal_state = 0, 
		tab = self,
		isPressedActionEnabled = true
	},
	nil,0)

	--充值
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recharge"), nil, 
	{
		terminal_name = "go_to_rechargeable_button", 
		terminal_state = 0, 
		tab = self,
		isPressedActionEnabled = true
	},
	nil,0)

	--领奖
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_receive"), nil, 
	{
		terminal_name = "go_to_get_reword", 
		terminal_state = 0, 
		tab = self,
		isPressedActionEnabled = true
	},
	nil,0)

	for i = 1, #_ED.active_activity[144].activity_Info do
		local Button_recharge_three = ccui.Helper:seekWidgetByName(root, "Button_recharge_three_" .. i)
		fwin:addTouchEventListener(Button_recharge_three, nil, 
		{
			terminal_name = "Button_recharge_tab", 
			terminal_state = 0, 
			tab = self,
			index = i,
			isPressedActionEnabled = true
		},
		nil,0)	
	end

	local Panel_shouchong_1 = ccui.Helper:seekWidgetByName(root, "Panel_shouchong_1")
	if Panel_shouchong_1 then
		Panel_shouchong_1:setVisible(true)
		local jsonFile = "images/ui/effice/effect_baduola/effect_baduola.json"
        local atlasFile = "images/ui/effice/effect_baduola/effect_baduola.atlas"
		local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		Panel_shouchong_1:addChild(animation)
	end

	local Panel_shouchong_2 = ccui.Helper:seekWidgetByName(root, "Panel_shouchong_2")
	if Panel_shouchong_2 then
		Panel_shouchong_2:setVisible(true)
		local jsonFile = "images/ui/effice/effect_cell/effect_cell.json"
        local atlasFile = "images/ui/effice/effect_cell/effect_cell.atlas"
		local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		Panel_shouchong_2:addChild(animation)
	end

	local Panel_shouchong_3 = ccui.Helper:seekWidgetByName(root, "Panel_shouchong_3")
	if Panel_shouchong_3 then
		Panel_shouchong_3:setVisible(true)
		local jsonFile = "images/ui/effice/effect_xite/effect_xite.json"
        local atlasFile = "images/ui/effice/effect_xite/effect_xite.atlas"
		local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		Panel_shouchong_3:addChild(animation)
	end

	self.Panel_shouchong = {[1] = Panel_shouchong_1, [2] = Panel_shouchong_2, [3] = Panel_shouchong_3}

	self:sortDatas()
end

-- 红点
function ActivityRichFirstRecharge:tabRedotShow()
	local root = self.roots[1]
	local function hasDayRedot(index)
		local activity_type = 144
		local key = "activity_push_"..activity_type .. "_".. index
		local lastReadTimes = cc.UserDefault:getInstance():getStringForKey(getKey(key))
		if lastReadTimes == nil or lastReadTimes == "" then
			return true
		end
		lastReadTimes = zstring.split(lastReadTimes, "-")
		if #lastReadTimes <= 1 then
			lastReadTimes = zstring.split(os.date("%Y".."-".."%m".."-".."%d".."-".."%H", lastReadTimes[1]), "-")
		end
		lastReadTimes[4] = lastReadTimes[4] or 0
		local nowTimes = os.date("%Y".."-".."%m".."-".."%d".."-".."%H", getBaseGTM8Time(_ED.system_time + (os.time() - _ED.native_time)))
		nowTimes = zstring.split(nowTimes , "-")
		-- if tonumber(lastReadTimes[1]) < tonumber(nowTimes[1]) then
		-- 	return true
		-- end
		-- if tonumber(lastReadTimes[2]) < tonumber(nowTimes[2]) then
		-- 	return true
		-- end
		local lastTime = os.time({year=tonumber(lastReadTimes[1]), month=tonumber(lastReadTimes[2]), day=tonumber(lastReadTimes[3]), hour=tonumber(lastReadTimes[4]), min=0, sec=0})
		local nowTime = os.time({year=tonumber(nowTimes[1]), month=tonumber(nowTimes[2]), day=tonumber(nowTimes[3]), hour=tonumber(nowTimes[4]), min=0, sec=0})
		if nowTime - lastTime >= 24*3600 then
			return true
		else
			if (tonumber(lastReadTimes[3]) ~= tonumber(nowTimes[3]) and tonumber(nowTimes[4]) >= 5)
				or (tonumber(lastReadTimes[3]) == tonumber(nowTimes[3]) 
					and zstring.tonumber(lastReadTimes[4]) < 5
					and tonumber(nowTimes[4]) >= 5)
				then
				return true
			end
		end
		return false
	end
	local function isHaveRedot( index )
		if _ED.active_activity[144] == nil or _ED.active_activity[144] == "" then
			return false
		end

		local needRecharges = {}
		local curRecharge = tonumber(_ED.active_activity[144].activity_params)
		for i,info in ipairs(_ED.active_activity[144].activity_Info) do
			local needRecharge = tonumber(info.activityInfo_need_day)
			local index = tonumber(info.index)
			local isGet = info.activityInfo_isReward 
			local states = 1 -- 0已完成，1 未完成 ，2已领取  方便排序
			if tonumber(isGet) == 1 then
				states = 2
			else
				if curRecharge < needRecharge then
					states = 1
				else
					states = 0
				end
			end
			needRecharges[i] = {id = index, state = states}
		end
		if needRecharges and needRecharges[index] and needRecharges[index].state == 0 then
			return true
		end
		if needRecharges and needRecharges[index] and needRecharges[index].state == 1
			and hasDayRedot(index) then
			return true
		end
		return false
	end

	for i = 1, #_ED.active_activity[144].activity_Info do
		local Button_recharge_three = ccui.Helper:seekWidgetByName(root, "Button_recharge_three_" .. i)
		local Image_redpoint = ccui.Helper:seekWidgetByName(root, "Image_redpoint_" .. i)
		if Image_redpoint then 
			Image_redpoint:setVisible(false)
			if isHaveRedot(i) == true then
				Image_redpoint:setVisible(true)
			else
				Image_redpoint:setVisible(false)
			end
		end
	end

	
end

function ActivityRichFirstRecharge:sortDatas(upId)
	--已经充值
	local curRecharge = tonumber(_ED.active_activity[144].activity_params)
	--需要充值
	local needRecharges = {}
	-- debug.print_r(_ED.active_activity[144])
	for i,info in ipairs(_ED.active_activity[144].activity_Info) do
		local needRecharge = tonumber(info.activityInfo_need_day)
		local index = tonumber(info.index)
		local isGet = info.activityInfo_isReward 
		local states = 1 -- 0已完成，1 未完成 ，2已领取  方便排序
		if tonumber(isGet) == 1 then
			states = 2
		else
			if curRecharge < needRecharge then
				states = 1
			else
				states = 0
			end
		end
		needRecharges[i] = {id = index, state = states}
	end

	local function sortList( a, b )
        if a.state < b.state then
            return true
        elseif a.state == b.state then
            return a.id < b.id
        else
            return false
        end
    end
    table.sort(needRecharges, sortList)

    self.needRecharges = needRecharges
    local id = upId or self.needRecharges[1].id
    self:buttonThreeTab(id)
end

function ActivityRichFirstRecharge:buttonThreeTab( index )
	local root = self.roots[1]
	for i = 1, #_ED.active_activity[144].activity_Info do
		local Button_recharge_three = ccui.Helper:seekWidgetByName(root, "Button_recharge_three_" .. i)
		local Panel_shouchong_donghua = ccui.Helper:seekWidgetByName(root, "Panel_shouchong_" .. i)
		if i == index then
			Button_recharge_three:setTouchEnabled(false)
	        Button_recharge_three:setHighlighted(true)
	        if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_naruto ) and Panel_shouchong_donghua then
	        	Panel_shouchong_donghua:setVisible(true)
	        end
	    else
	    	Button_recharge_three:setTouchEnabled(true)
	        Button_recharge_three:setHighlighted(false)
	        if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_naruto ) and Panel_shouchong_donghua then
	        	Panel_shouchong_donghua:setVisible(false)
	        end
		end
	end
	local activity_type = 144
	local key = "activity_push_"..activity_type .. "_".. index
	if activity_type > 0 then
		local readTime = cc.UserDefault:getInstance():getStringForKey(getKey(key))
		local nowTimeStr = os.date("%Y".."-".."%m".."-".."%d".."-".."%H", getBaseGTM8Time(_ED.system_time + (os.time() - _ED.native_time)))
		local nowTimes = zstring.split(nowTimeStr , "-")
		if readTime == nil or readTime == "" then
			writeKey( key , nowTimeStr)
		else
			local readTimes = zstring.split(readTime, "-")
			if #readTimes <= 1 then
				readTimes = zstring.split(os.date("%Y".."-".."%m".."-".."%d".."-".."%H", readTimes[1]), "-")
			end
			readTimes[4] = readTimes[4] or 0
			local lastTime = os.time({year=tonumber(readTimes[1]), month=tonumber(readTimes[2]), day=tonumber(readTimes[3]), hour=tonumber(readTimes[4]), min=0, sec=0})
			local nowTime = os.time({year=tonumber(nowTimes[1]), month=tonumber(nowTimes[2]), day=tonumber(nowTimes[3]), hour=tonumber(nowTimes[4]), min=0, sec=0})
			if nowTime - lastTime >= 24*3600 then
				writeKey( key, nowTimeStr)
			else
				if (tonumber(readTimes[3]) ~= tonumber(nowTimes[3]) and tonumber(nowTimes[4]) >= 5)
				or (tonumber(readTimes[3]) == tonumber(nowTimes[3]) 
				and zstring.tonumber(readTimes[4]) < 5
				and tonumber(nowTimes[4]) >= 5)
				then
					writeKey( key, nowTimeStr)
				end
			end
		end
	end
	self:onUpdateDraw(index)
end

function ActivityRichFirstRecharge:init(params)   
	self:onInit()
    return self
end

function ActivityRichFirstRecharge:onExit()
end