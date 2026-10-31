-- ----------------------------------------------------------------------------------------------------
-- 说明：开服基金活动页面的列表项
-------------------------------------------------------------------------------------------------------

OpenServerListCellNew = class("OpenServerListCellNewClass", Window)

function OpenServerListCellNew:ctor()
    self.super:ctor()
	self.roots = {}
	self.interfaceType = 0
	self.listView = nil
	self.activity = nil
	self.activityReward = nil
	self.rewardIndex = 0
	self.activityExtraPrame = nil
	self.rewardState = 0  -- 0:不可领取  1：可领取  2：已经领取
	self.drawState = 0

	self._enum_type = {
		_ACTIVITY_TYPE_FUND = 1,       -- 开服基金活动
		_ACTIVITY_TYPE_WELFARE = 2,    -- 全民福利活动
	}
	
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.utils.resources_icon_cell")

	-- Initialize open server list cell page state machine.
    local function init_open_server_list_cell_new_terminal()
		local open_server_list_cell_new_draw_fund_reward_terminal = {
            _name = "open_server_list_cell_new_draw_fund_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            		if tonumber(_ED.vip_grade) < tonumber(_ED.active_activity[27].limit_vip_level) then
            			TipDlg.drawTextDailog(_string_piece_info[278])
            			return
            		end
            	end
				if TipDlg.drawStorageTipo() == false then
					local RewardCell = params._datas._cell
					local _rewardId = params._datas.rewardId
					local _rewardType = params._datas.rewardType

					if _new_interface_text[303] ~= nil then
	            		local needUserLevel = zstring.tonumber(RewardCell.activityReward.activityInfo_need_day)
						local userLevel = zstring.tonumber(_ED.user_info.user_grade)
						if needUserLevel > userLevel then
							TipDlg.drawTextDailog(string.format(_new_interface_text[303], ""..needUserLevel))
							return
						end
					end
					local function responseGetActivityRewardCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							-- response.node:isDrawedUpdateDraw()
							app.load("client.reward.DrawRareReward")
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7)
							fwin:open(getRewardWnd, fwin._ui)
							state_machine.excute("all_server_fund_activity_update_draw", 0, nil)
						end
					end
					if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
						protocol_command.get_activity_reward.param_list = ""..RewardCell.activity.activity_id.."\r\n"..RewardCell.rewardIndex.."\r\n".."1"
					else	
						protocol_command.get_activity_reward.param_list = ""..RewardCell.activity.activity_id.."\r\n"..RewardCell.rewardIndex.."\r\n1"
					end	
					NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, RewardCell, responseGetActivityRewardCallback, false, nil)
				end
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local open_server_list_cell_new_draw_welfare_reward_terminal = {
            _name = "open_server_list_cell_new_draw_welfare_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	state_machine.excute("open_server_list_cell_new_draw_fund_reward", 0, params)
				-- local RewardCell = params._datas._cell
				-- local _rewardId = params._datas.rewardId
				-- local _rewardType = params._datas.rewardType
				-- local function responseDrawServerFundCallback(response)
				-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				-- 		-- state_machine.excute("gain_reward_news_send", 0, {response.node, response.node.example})
				-- 	end
				-- end
				-- protocol_command.draw_server_fund.param_list = ""..RewardCell.activity.activity_id.."\r\n"..RewardCell.rewardIndex
				-- NetworkManager:register(protocol_command.draw_server_fund.code, nil, nil, nil, RewardCell, responseDrawServerFundCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local open_server_list_cell_new_update_draw_terminal = {
            _name = "open_server_list_cell_new_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local cell = params
            	cell:onUpdateDraw()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(open_server_list_cell_new_draw_fund_reward_terminal)
		state_machine.add(open_server_list_cell_new_draw_welfare_reward_terminal)
		state_machine.add(open_server_list_cell_new_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init open server list cell state machine.
    init_open_server_list_cell_new_terminal()
end

function OpenServerListCellNew:drawText(panel, one , two , three, fontSize, fontName)
	panel:removeAllChildren(true)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local _richText2 = ccui.RichText:create()
        _richText2:ignoreContentAdaptWithSize(false)
        _richText2:setContentSize(cc.size(300, 30))
        _richText2:setAnchorPoint(cc.p(0, 0.5))
        local char_str = one.."%|1|"..two.."%"..three
        local rt, count, text = draw.richTextCollectionMethod(_richText2, 
        char_str, 
        cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),
        cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),
        0, 
        0, 
        panel:getFontName(), 
        panel:getFontSize(),
        chat_rich_text_color)
        _richText2:setPositionX(-148)
        local rsize = _richText2:getContentSize()
        _richText2:setPositionY(panel:getContentSize().height)
        panel:addChild(_richText2)
    else
		local _richText = ccui.RichText:create();
		-- _richText:ignoreContentAdaptWithSize(false);
		_richText:setContentSize(cc.size(300, 30))

	local color = panel:getColor()
	if panel.dispatchFocusEvent ~= nil then
		color = panel:getTextColor()
	end
	
	local re1 = ccui.RichElementText:create(1, color, 255, one, fontName, fontSize)
	local re2 = ccui.RichElementText:create(2, cc.c3b(255, 0, 0), 255, two, fontName, fontSize)
	local re3 = ccui.RichElementText:create(3, color, 255, three, fontName, fontSize)
	_richText:pushBackElement(re1)
	_richText:pushBackElement(re2)
	_richText:pushBackElement(re3)
	if panel.getTextColor ~= nil then
		_richText:setAnchorPoint(cc.p(0, 0.5))
	else
		_richText:setAnchorPoint(cc.p(0.25, 0.5))
	end
	-- _richText:setPosition(cc.p(-140, -30))
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		_richText:setPosition(cc.p(-100,0))
	end
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		_richText:setPosition(cc.p(-100,0))
	end
	panel:addChild(_richText)
	end
end

function OpenServerListCellNew:isDrawedUpdateDraw()
    self:retain()
    self:onUpdateDraw()
    local itmes = self.listView:getItems()
    for i=1,#itmes do
       if itmes[i] == self then
            self.listView:removeItem(i - 1)
            -- self.self.activityReward.activityInfo_isReward = 1
            self.listView:addChild(self)
			self:release()
            break
       end
    end
end

function OpenServerListCellNew:onUpdateDraw()
	local root = self.roots[1]
	local drawButton = ccui.Helper:seekWidgetByName(root, "Button_kf_01")
	-- drawButton:setVisible(false)
	local ArmatureNode_1 = root:getChildByName("ArmatureNode_1")
	if ArmatureNode_1 ~= nil then
		ArmatureNode_1:setVisible(false)
	end

	local drawRewardState = 0
	local needCompleteCount = 0
	local completeCount = -1
	local root = self.roots[1]
	if self.interfaceType == self._enum_type._ACTIVITY_TYPE_FUND then
		local needUserLevel = zstring.tonumber(self.activityReward.activityInfo_need_day)
		local userLevel = zstring.tonumber(_ED.user_info.user_grade)
		drawRewardState = zstring.tonumber(self.activityReward.activityInfo_isReward)
		needCompleteCount = needUserLevel
		completeCount = userLevel
		-- drawButton:setVisible(drawRewardState == 0)
		local activity = _ED.active_activity[27]
		if activity == nil or activity.activity_isReward ~= "3" then
			completeCount = 0
		end
		local Text_kf_2 = ccui.Helper:seekWidgetByName(root, "Text_kf_2")
		-- drawButton:setVisible(drawRewardState == 0 and completeCount >= needCompleteCount)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
			then
			Text_kf_2:setString(string.format(_new_interface_text[5], needUserLevel))
		else
			if verifySupportLanguage(_lua_release_language_en) == true then
				self:drawText(Text_kf_2, _string_piece_info[284], _string_piece_info[6]..needUserLevel, _string_piece_info[283], 22, Text_kf_2:getFontName())
			else
				self:drawText(Text_kf_2, _string_piece_info[284], ""..needUserLevel.._string_piece_info[6], _string_piece_info[283], 22, Text_kf_2:getFontName())
			end
		end
		self._Image_3:setVisible(drawRewardState == 1)
	elseif self.interfaceType == self._enum_type._ACTIVITY_TYPE_WELFARE then
		local needBuyCount = zstring.tonumber(self.activityReward.activityInfo_need_day)
		local buyCount = zstring.tonumber(self.activity.activity_buy_count)
		drawRewardState = zstring.tonumber(self.activityReward.activityInfo_isReward)
		needCompleteCount = needBuyCount
		completeCount = buyCount
		-- drawButton:setVisible(drawRewardState == 0)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
			then
			Text_kf_2:setString(_string_piece_info[282]..needBuyCount)
		else
			self:drawText(ccui.Helper:seekWidgetByName(root, "Text_kf_2"), _string_piece_info[282], ""..needBuyCount, _string_piece_info[283], 22)
		end
		self._Image_3:setVisible(drawRewardState == 1)
	end
	-- drawButton:setBright(true)
 --    drawButton:setTouchEnabled(true)
	-- ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(drawRewardState == 1)

	if _ED.active_activity[27].activity_isReward ~= "3" then
		drawButton:setVisible(false)
	else
		drawButton:setVisible(true)
		if drawRewardState == 0 then
	        if completeCount >= needCompleteCount then
		        if ArmatureNode_1 ~= nil then
					ArmatureNode_1:setVisible(true)
				end
	            self.drawState = 1
	        else
	            self.drawState = 0
	   --          drawButton:setBright(false)
	   --      	drawButton:setTouchEnabled(false)
				-- drawButton:setVisible(true)
				if self.interfaceType == self._enum_type._ACTIVITY_TYPE_FUND then
					-- ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						-- if tonumber(_ED.active_activity[27].activity_isReward) <= 0 then
							-- drawButton:setVisible(false)
							ccui.Helper:seekWidgetByName(root, "Text_kf_jd"):setString(_ED.user_info.user_grade.."/"..self.activityReward.activityInfo_need_day)
							if tonumber(self.activityReward.activityInfo_need_day) <= tonumber(_ED.user_info.user_grade) then
								ccui.Helper:seekWidgetByName(root, "Text_kf_jd"):setColor(cc.c3b(15, 255, 0))
							else
								ccui.Helper:seekWidgetByName(root, "Text_kf_jd"):setColor(cc.c3b(255, 255, 255))
							end
						-- else
						-- 	drawButton:setVisible(true)		
						-- 	ccui.Helper:seekWidgetByName(root, "Text_kf_jd"):setString("")
						-- end
					end
				elseif self.interfaceType == self._enum_type._ACTIVITY_TYPE_WELFARE then
					-- ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
				end
	        end
	    else
	        self.drawState = 2
	        drawButton:setVisible(false)
	    end
	end
end

function OpenServerListCellNew:drawReward()
	local root = self.roots[1]
	-- 绘制奖励图标
	local reward = self.activityReward
	if reward ~= nil then
		-- 绘制奖励名称
		if __lua_project_id == __lua_project_l_naruto 
			then
			local Text_kfjj_01 = ccui.Helper:seekWidgetByName(root, "Text_kfjj_01")
    		Text_kfjj_01:removeAllChildren(true)
			local _richText2 = ccui.RichText:create()
	        _richText2:ignoreContentAdaptWithSize(false)

	        local richTextWidth = Text_kfjj_01:getContentSize().width
	        if richTextWidth == 0 then
		        richTextWidth = Text_kfjj_01:getFontSize() * 6
		    end
			    
	        _richText2:setContentSize(cc.size(richTextWidth, 0))
	        _richText2:setAnchorPoint(cc.p(0, 0))
	        local char_str = reward.activityInfo_name
	        local rt, count, text = draw.richTextCollectionMethod(_richText2, 
	        char_str, 
	        cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),
	        cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),
	        0, 
	        0, 
	        Text_kfjj_01:getFontName(), 
	        Text_kfjj_01:getFontSize(),
	        chat_rich_text_color)
	        if _ED.is_can_use_formatTextExt == false then
	            _richText2:setPositionX((_richText2:getPositionX() - _richText2:getContentSize().width / 2) + (Text_kfjj_01:getContentSize().width-_richText2:getContentSize().width)/2)
	        else
	            _richText2:formatTextExt()
	        end
	        local rsize = _richText2:getContentSize()
	        _richText2:setPositionY(Text_kfjj_01:getContentSize().height)
	        Text_kfjj_01:addChild(_richText2)
	        Text_kfjj_01:setString("")
	    else
	    	ccui.Helper:seekWidgetByName(root, "Text_kfjj_01"):setString(reward.activityInfo_name)
	    end

		app.load("client.cells.equip.equip_icon_cell")
	    app.load("client.cells.prop.prop_icon_cell")
	    app.load("client.cells.utils.resources_icon_cell")
	    app.load("client.cells.prop.prop_money_icon")

		local rewardIcon = nil
		-- 绘制银币
		if zstring.tonumber(reward.activityInfo_silver) > 0 then
			rewardIcon = propMoneyIcon:createCell()			
			rewardIcon:init("1", -1, nil)
		elseif zstring.tonumber(reward.activityInfo_gold) > 0  then
			-- rewardIcon = propMoneyIcon:createCell()		
			-- rewardIcon:init("2", -1, nil)
			rewardIcon = ResourcesIconCell:createCell()	
			rewardIcon:init("2", 0, -1,nil,nil,true,true,0)
		elseif zstring.tonumber(reward.activityInfo_food) > 0  then
			rewardIcon = ResourcesIconCell:createCell()		
			rewardIcon:init("12", -1, -1)
		elseif zstring.tonumber(reward.activityInfo_honour) > 0  then
			rewardIcon = propMoneyIcon:createCell()		
			rewardIcon:init("3", -1, -1)
		elseif zstring.tonumber(reward.activityInfo_prop_count) > 0 then
			rewardIcon = PropIconCell:createCell()
			if rewardIcon.hideNameAndCount ~= nil then
				rewardIcon:hideNameAndCount()
			end
            rewardIcon:init(23, {user_prop_template = reward.activityInfo_prop_info[1].propMould, prop_number = -1}, -1)
		elseif zstring.tonumber(reward.activityInfo_equip_count) > 0 then
            rewardIcon = EquipIconCell:createCell()
            if rewardIcon.hideNameAndCount ~= nil then
				rewardIcon:hideNameAndCount()
			end
            rewardIcon:init(10, nil, reward.activityInfo_equip_info[1].equipMould, nil)
		end

		if rewardIcon ~= nil then
			ccui.Helper:seekWidgetByName(root, "Panel_kfjj_03"):removeAllChildren(true)
			ccui.Helper:seekWidgetByName(root, "Panel_kfjj_03"):addChild(rewardIcon)
		end
	end
end

function OpenServerListCellNew:initDraw()
	local root = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		root = cacher.createUIRef("activity/wonderful/open_service_fund_list_1.csb", "root")
	else
	    local csbOpenServerListCell = csb.createNode("activity/wonderful/open_service_fund_list_1.csb")
		root = csbOpenServerListCell:getChildByName("root")
		-- 列表控件动画播放
		local action = csb.createTimeline("activity/wonderful/open_service_fund_list_1.csb")
	    root:runAction(action)
	    -- action:play("list_view_cell_open", false)
		action:gotoFrameAndPlay(15, 15, false)
	end
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		self:setContentSize(root:getContentSize())
	else
		self:setContentSize(root:getChildByName("Panel_kfjj_list"):getContentSize())
	end

	self._Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
	self:onUpdateDraw()

	self:drawReward()

    -- 领取开服基金奖励的按钮事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kf_01"),       nil, 
    {
        terminal_name = self.interfaceType == self._enum_type._ACTIVITY_TYPE_FUND and "open_server_list_cell_new_draw_fund_reward" or "open_server_list_cell_new_draw_welfare_reward",
        current_button_name = "Button_kf_01",
        but_image = "Image_kf_01",   
        _cell = self,    
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end
function OpenServerListCellNew:onEnterTransitionFinish()
	-- self:onUpdateDraw()
end

function OpenServerListCellNew:clearUIInfo( ... )
	local root = self.roots[1]
    local Text_kf_jd = ccui.Helper:seekWidgetByName(root,"Text_kf_jd")        
    local Panel_kfjj_03 = ccui.Helper:seekWidgetByName(root,"Panel_kfjj_03")    
    local Text_kfjj_01 = ccui.Helper:seekWidgetByName(root,"Text_kfjj_01") 
    local Text_kf_2 = ccui.Helper:seekWidgetByName(root,"Text_kf_2") 
    if Text_kf_jd ~= nil then 
        Text_kf_jd:setString("")
    end
    if Panel_kfjj_03 ~= nil then
        Panel_kfjj_03:removeAllChildren(true)
    end
    if Text_kfjj_01 ~= nil then
        Text_kfjj_01:removeAllChildren(true)
    end
    if Text_kf_2 ~= nil then
        Text_kf_2:removeAllChildren(true)
        Text_kf_2:setString("")
    end
    local ArmatureNode_1 = root:getChildByName("ArmatureNode_1")
	if ArmatureNode_1 ~= nil then
		ArmatureNode_1:setVisible(false)
	end
    self._Image_3 = nil
end

function OpenServerListCellNew:onExit()
	local root = self.roots[1]
    self:clearUIInfo()
    cacher.freeRef("activity/wonderful/open_service_fund_list_1.csb", root)
end

function OpenServerListCellNew:init(interfaceType, listView, activity, activityReward, rewardIndex, activityExtraPrame, rewardState)
	self.interfaceType = interfaceType
	self.listView = listView
	self.activity = activity
	self.activityReward = activityReward
	self.rewardIndex = rewardIndex
	self.activityExtraPrame = activityExtraPrame
	self.rewardState = drawState
	self:initDraw()
	return self, self.drawState
end

function OpenServerListCellNew:createCell()
	local cell = OpenServerListCellNew:new()
	cell:registerOnNodeEvent(cell)
	return cell
end