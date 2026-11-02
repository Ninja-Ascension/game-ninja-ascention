----------------------------------------------------------------------------------------------------
-- 说明：好友申请列表项
----------------------------------------------------------------------------------------------------
AdventureFirendRecommendListCell = class("AdventureFirendRecommendListCellClass", Window)
AdventureFirendRecommendListCell.__size = nil


function AdventureFirendRecommendListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	self.drawIndex = 0
	self.friendInfo = nil
	self.type = 1
	self.person = nil
	self.isClickSendMessage = false  --是否点击了添加好友 下一次不可以点了

	-- Initialize adventure firend apply list cell state machine.
	local function init_firend_recommend_list_cell_terminal()
         -- 添加
        local firend_recommend_list_cell_add_terminal = {
            _name = "firend_recommend_list_cell_add",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local firend = params._datas.cell.friendInfo
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						response.node.isClickSendMessage = true
						response.node:onUpdateDraw()
						state_machine.excute("adventure_friend_clean_search_find", 0, "")		
						TipDlg.drawTextDailog(_string_piece_info[259] .. firend.name .._string_piece_info[260])
					end
				end
				protocol_command.friend_request.param_list = firend.user_id .."\r\n".."1"
				--NetworkManager:register(protocol_command.friend_pass.code, nil, nil, nil, nil, recruitCallBack, false, nil)
				NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, params._datas.cell, recruitCallBack, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        state_machine.add(firend_recommend_list_cell_add_terminal)
      
		state_machine.init()
	end

	-- call func init adventure firend apply list cell state machine.
	init_firend_recommend_list_cell_terminal()
end

function AdventureFirendRecommendListCell:onEnterTransitionFinish()

end

function AdventureFirendRecommendListCell:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_13_4")
	local textGrade = ccui.Helper:seekWidgetByName(root, "Text_11_2")
	local textName = ccui.Helper:seekWidgetByName(root, "Text_4")
	local textLeaveTime = ccui.Helper:seekWidgetByName(root, "Text_13_6")
	local textFighting = ccui.Helper:seekWidgetByName(root, "Text_16_12")
	local textArmy = ccui.Helper:seekWidgetByName(root, "Text_3_14")
	local textDuanwei = ccui.Helper:seekWidgetByName(root, "Text_duanshu")
	if verifySupportLanguage(_lua_release_language_en) == true then
		textGrade:setString(_string_piece_info[6]..self.friendInfo.grade)
	else
		textGrade:setString(self.friendInfo.grade .. _string_piece_info[6])
	end
	textGrade:setVisible(false)
	panelHead:removeAllChildren(true)
	
	if zstring.tonumber(self.friendInfo.title_id) == 0 then 
		textDuanwei:setString(_string_piece_info[468])
	else
		local titleName = dms.string(dms["warcraft_mould"], self.friendInfo.title_id, warcraft_mould.title_name)
		textDuanwei:setString(titleName)	
	end
	local cell = AdventureHeroIconCell:createCell()
    cell:init(0, {ship_template_id = self.friendInfo.lead_mould_id}, 1, 0, nil, nil, nil, nil, 1)
    panelHead:addChild(cell)

	local quality = dms.int(dms["ship_mould"], self.friendInfo.lead_mould_id, ship_mould.ship_type)
	textName:setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))
	textName:setString(self.friendInfo.name)
	local recommendFight = tonumber(self.friendInfo.fighting)
	if recommendFight >= 10000 then
		recommendFight = math.floor(recommendFight / 10000).._string_piece_info[150]
	end
	textFighting:setString(recommendFight)
	local addButton = ccui.Helper:seekWidgetByName(root, "Button_106_6")
	if self.isClickSendMessage == false then 
		addButton:setTouchEnabled(true)
		addButton:setColor(cc.c3b(255, 255, 255))
	else
		addButton:setColor(cc.c3b(150, 150, 150))
		addButton:setTouchEnabled(false)
	end
	
	-- if self.person.army ~= nil then
		-- textArmy:setString(self.person.army)
	-- else
		textArmy:setString(_string_piece_info[310])
	-- end
	
	local times = self.friendInfo.leave_time
	local str = ""
	local hour = math.floor(tonumber(self.friendInfo.leave_time)/3600)
	local mins = math.floor((tonumber(self.friendInfo.leave_time)%3600)/60)
	local day = ""
	-- if self.friendInfo.leave_time == 0 then
	-- 	str = _string_piece_info[268]
	-- elseif hour < 1 then
	-- 	str = _string_piece_info[269] .. mins .. _string_piece_info[270]
	-- elseif hour >= 1 and hour < 24 then
	-- 	str = _string_piece_info[269] .. hour .._string_piece_info[271]
	-- elseif hour >= 24 and hour < 168 then
	-- 	day = math.ceil(hour / 24)
	-- 	str = _string_piece_info[269] .. day .._string_piece_info[231]
	-- elseif hour >= 168 then
	-- 	str = _string_piece_info[269] .. 1 .._string_piece_info[272]
	-- end
	textLeaveTime:setString(str)
	textLeaveTime:setVisible(false)

	
end

function AdventureFirendRecommendListCell:onInit()
	local root = cacher.createUIRef("friend/friend_tuijian_list.csb", "root")
 	table.insert(self.roots, root)
 	--root:removeFromParent(false)
 	self:addChild(root)
 	self.isClickSendMessage = false
	if AdventureFirendRecommendListCell.__size == nil then
		AdventureFirendRecommendListCell.__size = root:getContentSize()
	end
	self:onUpdateDraw()
	local addButton = ccui.Helper:seekWidgetByName(root, "Button_106_6")
	fwin:addTouchEventListener(addButton, nil, 
	{
		terminal_name = "firend_recommend_list_cell_add",	
		terminal_state = 0,
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)

end

function AdventureFirendRecommendListCell:getLeaveTimeString(leave_time)
	local str = ""
	local hour = math.floor(tonumber(leave_time)/3600)
	local mins = math.floor((tonumber(leave_time)%3600)/60)
	local day = ""

	if tonumber(leave_time) == 0 or (mins < 1 and hour == 0) then
		str = _string_piece_info[268]					-- 在线
	elseif hour < 1 then
		str = _string_piece_info[269] .. mins .. _string_piece_info[270]
	elseif hour >= 1 and hour < 24 then
		str = _string_piece_info[269] .. hour .._string_piece_info[271]
	elseif hour >= 24 and hour < 168 then
		day = math.ceil(hour / 24)
		str = _string_piece_info[269] .. day .._string_piece_info[231]
	elseif hour >= 168 then
		str = _string_piece_info[269] .. 1 .._string_piece_info[272]
	end
	
	return str
end

function AdventureFirendRecommendListCell:onExit()
	cacher.freeRef("friend/friend_tuijian_list.csb", self.roots[1])
end

function AdventureFirendRecommendListCell:init(friend, drawIndex)
	self.friendInfo = friend
	self.drawIndex = drawIndex
	
	if drawIndex ~= nil and drawIndex < 10 then
		self:onInit()
	end
	self:setContentSize(AdventureFirendRecommendListCell.__size)
	return self
end

function AdventureFirendRecommendListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureFirendRecommendListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("friend/friend_tuijian_list.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureFirendRecommendListCell:createCell()
	local cell = AdventureFirendRecommendListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
