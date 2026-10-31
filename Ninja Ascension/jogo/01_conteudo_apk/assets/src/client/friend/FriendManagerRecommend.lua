-- ----------------------------------------------------------------------------------------------------
-- 说明：好友推荐界面
-- 创建时间	2015-04-16
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FriendManagerRecommend = class("FriendManagerRecommendClass", Window)
    
function FriendManagerRecommend:ctor()
    self.super:ctor()
	self.roots = {}
	self.butStatus = true
	self.times = nil
	self.startTime = nil
	app.load("client.friend.FriendManagerRecommendList")
	self.listView = nil 
    -- Initialize FriendManager page state machine.
    local function init_friend_manager_one_terminal()
		
		--关闭
		local friend_manager_recommend_close_terminal = {
            _name = "friend_manager_recommend_close",
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
		
		--刷新
		local friend_manager_recommend_refrush_terminal = {
            _name = "friend_manager_recommend_refrush",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onRefrush()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--移除点击的推荐好友(删除时调用)
		local friend_manager_recommend_del_terminal = {
            _name = "friend_manager_recommend_del",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then 
            		instance:checkDel(params)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --搜索好友
		local search_friend_by_name_terminal = {
            _name = "search_friend_by_name",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local text = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_friend_name")	--输入框
				if text:getString() == nil or text:getString() == "" then
					TipDlg.drawTextDailog(_string_piece_info[280])
				else
					local function recruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								response.node:onUpdateDraw()
							end
						end
					end
					protocol_command.search_user.param_list = _ED.user_info.user_id .. "\r\n" ..text:getString()
					NetworkManager:register(protocol_command.search_user.code, nil, nil, nil, instance, recruitCallBack, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --全部申请
		local friend_manager_recommend_cell_add_all_terminal = {
            _name = "friend_manager_recommend_cell_add_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			    local items = instance.listView:getItems()
            	local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
			            	for i , v in pairs(items) do
			            		state_machine.excute("friend_manager_recommend_cell_update", 0,v)
			            	end
			            end
			            TipDlg.drawTextDailog(_new_interface_text[55])
		            end
		        end
		        local str = ""
		        for i , v in pairs(items) do
		        	str = str..v.person.user_id..","
		        end
		        if str ~= nil then
		        	str = string.sub(str,1,-2)
	            	protocol_command.friend_request.param_list = str .."\r\n".."1"
					NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, instance, recruitCallBack, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新好友数量
		local friend_manager_recommend_update_all_friend_number_terminal = {
            _name = "friend_manager_recommend_update_all_friend_number",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local  Text_friend_n = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_friend_n")
            	if params ~= nil and params ~= "" then
					Text_friend_n:setString(params)
				else
					local max_friend_number = dms.int(dms["friend_config"] , 1 , friend_config.param)
					Text_friend_n:setString(_ED.friend_number.."/"..max_friend_number)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(friend_manager_recommend_update_all_friend_number_terminal)
        state_machine.add(search_friend_by_name_terminal)
		state_machine.add(friend_manager_recommend_close_terminal)
		state_machine.add(friend_manager_recommend_refrush_terminal)
		state_machine.add(friend_manager_recommend_del_terminal)
		state_machine.add(friend_manager_recommend_cell_add_all_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_friend_manager_one_terminal()
end

function FriendManagerRecommend:checkDel(_id)
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_103")
	local items = listView:getItems()
	for i,v in pairs(items) do
		if tonumber(v.person.user_id) == tonumber(_id) then
			listView:removeItem(i-1)
		end
	end
end

function FriendManagerRecommend:onUpdateSort()
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
		return _ED.friend_find
	end
	local onTime = {}
	local leaveTime = {}
	local all = {}
	function _idSortTime(a, b)
		if a.leave_time < b.leave_time then
			return true
		end
		return false
	end
	
	function _idSortGrade(a, b)
		if a.grade > b.grade then
			return true
		end
		return false
	end
	
	for i , v in pairs(_ED.friend_find) do
		if tonumber(v.leave_time) > 0 then
			table.insert(leaveTime,v)
		else
			table.insert(onTime,v)
		end
	end
	
	table.sort(leaveTime, _idSortTime)
	table.sort(onTime, _idSortGrade)
	
	for i, v in ipairs(onTime) do
		table.insert(all, v)
	end
	for i, v in ipairs(leaveTime) do
		table.insert(all, v)
	end
	
	
	return all
end

function FriendManagerRecommend:onRefrush()
	local function responseInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
				response.node.butStatus = false
				local root = response.node.roots[1]
				local listView = ccui.Helper:seekWidgetByName(root, "ListView_103")				
				listView:removeAllItems()
				listView:requestRefreshView()
				for i , v in pairs(response.node:onUpdateSort()) do
					local cell = FriendManagerRecommendList:createCell()
					cell:init(v)
					listView:addChild(cell)
				end
			end
		end
	end
	NetworkManager:register(protocol_command.random_user_list.code, nil, nil, nil, self, responseInitCallback, false, nil)
end


function FriendManagerRecommend:isOpenRefreshTime()
	local times = math.ceil(os.time() - zstring.tonumber(_ED.friend_find_refresh_time))
	if times < 10 then
		return false
	end
	return true
end

function FriendManagerRecommend:onUpdate(dt)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		return
	end
	if self.butStatus == false then
		local root = self.roots[1]
		local times = math.ceil(os.time() - zstring.tonumber(_ED.friend_find_refresh_time))
		if false == self:isOpenRefreshTime() and zstring.tonumber(_ED.friend_find_refresh_time) > 0 then
			ccui.Helper:seekWidgetByName(root, "Text_3"):setString(_string_piece_info[307] .. 10-times .. _string_piece_info[308])
			ccui.Helper:seekWidgetByName(root, "Button_298"):setBright(false)
			ccui.Helper:seekWidgetByName(root, "Button_298"):setTouchEnabled(false)
			self.startTime = times
		else
			self.butStatus = true
			ccui.Helper:seekWidgetByName(root, "Button_298"):setBright(true)
			ccui.Helper:seekWidgetByName(root, "Button_298"):setTouchEnabled(true)
			ccui.Helper:seekWidgetByName(root, "Text_3"):setString("")
		end
	end
end

function FriendManagerRecommend:onUpdateDraw()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_103")
	listView:removeAllItems()
	listView:requestRefreshView()
	for i , v in pairs(self:onUpdateSort()) do
		local cell = FriendManagerRecommendList:createCell()
		cell:init(v)
		listView:addChild(cell)
	end
	-- local Text_friend_n = ccui.Helper:seekWidgetByName(root, "Text_friend_n")
	local Text_my_uid = ccui.Helper:seekWidgetByName(root, "Text_my_uid")
	-- if Text_friend_n ~= nil then
	-- 	local max_friend_number = dms.int(dms["friend_config"] , 1 , friend_config.param)
	-- 	Text_friend_n:setString(zstring.tonumber(_ED.friend_number).."/"..max_friend_number)
	-- end
	if Text_my_uid ~= nil then
		Text_my_uid:setString(_ED.user_info.user_id)
	end
	self.listView = listView
end

function FriendManagerRecommend:onEnterTransitionFinish()
	local csbFriendManagerRecommend = csb.createNode("friend/friend_tuijian.csb")
	self:addChild(csbFriendManagerRecommend)
	local root = csbFriendManagerRecommend:getChildByName("root")
	table.insert(self.roots, root)
	

	local function buttonOneTouchEvent(sender, evenType)
		if ccui.TouchEventType.began == evenType then
			
		elseif ccui.TouchEventType.ended == evenType then
			state_machine.excute("friend_manager_recommend_refrush", 0, "friend_manager_recommend_refrush.")
		end
	end
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_298"), buttonOneTouchEvent, {terminal_name = "", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
	else
		ccui.Helper:seekWidgetByName(root, "Button_298"):addTouchEventListener(buttonOneTouchEvent)
	end
	
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_298"), nil, {terminal_name = "friend_manager_recommend_refrush", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
	
	--数码暴龙 “Panel_1”盖住了关闭按钮Button_691
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		local garyPanel_1 = ccui.Helper:seekWidgetByName(root,"Panel_1")
		if garyPanel_1 ~= nil then
			garyPanel_1:setVisible(false)
		end
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_691"), nil, {terminal_name = "friend_manager_recommend_close", terminal_state = 0, isPressedActionEnabled = true}, nil, 2)
	local currPo = "0"
	if _ED.friend_number == nil or zstring.tonumber(_ED.friend_number) == 0 then
		currPo = "1"
	end
	local function responseInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then	
			if response.node ~= nil and response.node.roots ~= nil then
				response.node.butStatus = false
				response.node.times = os.time()
				response.node:onUpdateDraw()
				state_machine.excute("friend_manager_recommend_update_all_friend_number",0,"")
			end
		end
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		-- protocol_command.random_user_list.param_list = currPo
		-- NetworkManager:register(protocol_command.random_user_list.code, nil, nil, nil, self, responseInitCallback, true, nil)
		responseInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0, node = self})
	else
		self.butStatus = true
		if true == self:isOpenRefreshTime()  then
			if nil ~= _ED.friend_find_number and zstring.tonumber(_ED.friend_find_number) > 0 then
				self:onUpdateDraw()
			else
				NetworkManager:register(protocol_command.random_user_list.code, nil, nil, nil, self, responseInitCallback, false, nil)
			end
		else
			self.butStatus = false
			self:onUpdateDraw()
		end
	end
	local Button_find = ccui.Helper:seekWidgetByName(root, "Button_find")
	if Button_find ~= nil then
		fwin:addTouchEventListener(Button_find,nil,
			{
				terminal_name = "search_friend_by_name",
				terminal_state = 0,
				status = false,
				isPressedActionEnabled = true
			},
			nil,0)
		draw:addEditBox(ccui.Helper:seekWidgetByName(root, "TextField_friend_name"), _new_interface_text[49], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_find"), 16, cc.KEYBOARD_RETURNTYPE_DONE)
	end

	local Button_all_apply = ccui.Helper:seekWidgetByName(root, "Button_all_apply")
	if Button_all_apply ~= nil then
		fwin:addTouchEventListener(Button_all_apply,nil,
		{
			terminal_name = "friend_manager_recommend_cell_add_all",
			terminal_state = 0,
			status = false,
			isPressedActionEnabled = true
		},
		nil,0)
	end
end


function FriendManagerRecommend:onExit()
	state_machine.remove("friend_manager_recommend_close")
	state_machine.remove("friend_manager_recommend_refrush")
	state_machine.remove("friend_manager_recommend_del")
	state_machine.remove("search_friend_by_name")
	state_machine.remove("friend_manager_recommend_update_all_friend_number")
	state_machine.remove("friend_manager_recommend_cell_add_all")
end

function FriendManagerRecommend:createCell()
	local cell = FriendManagerRecommend:new()
	cell:registerOnNodeEvent(cell)
	return cell
end