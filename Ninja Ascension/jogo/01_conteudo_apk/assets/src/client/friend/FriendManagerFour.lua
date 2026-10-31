-- ----------------------------------------------------------------------------------------------------
-- 说明：好友申请界面
-- 创建时间	2015-04-16
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FriendManagerFour = class("FriendManagerFourClass", Window)
    
function FriendManagerFour:ctor()
    self.super:ctor()
	self.roots = {}
	self.currPage = 1 -- 当前显示第几页
	self.max_page = 0
	self.onePageNumber = 0
    -- Initialize FriendManager page state machine.
    local function init_friend_manager_four_terminal()
		
		local friend_manager_four_del_terminal = {
            _name = "friend_manager_four_del",
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
		
		local friend_manager_four_update_terminal = {
            _name = "friend_manager_four_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local friend_manager_four_all_refuse_terminal = {
            _name = "friend_manager_four_all_refuse",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local items = FriendManagerFour.cacheListView:getItems()
	            local user_id = ""
	            for i , v in pairs(items) do
	            	user_id = user_id..v.friend.user_id..","
	            end
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						TipDlg.drawTextDailog(_new_interface_text[57])
						for i , v in pairs(items) do
							state_machine.excute("friend_manager_four_del", 0, v.friend.user_id)
						end
					end
				end
				if user_id ~= "" then
					user_id = string.sub(user_id,1,-2)
					protocol_command.friend_pass.param_list = user_id .."\r\n".."2"
					NetworkManager:register(protocol_command.friend_pass.code, nil, nil, nil, instance, recruitCallBack, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --一键同意
        local friend_manager_four_all_agree_terminal = {
            _name = "friend_manager_four_all_agree",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
	            local items = FriendManagerFour.cacheListView:getItems()
	            local user_id = ""
	            -- for i , v in pairs(items) do
	            -- 	user_id = user_id..v.friend.user_id..","
	            -- end
	            for i , v in pairs(_ED.request_user) do 
					user_id = user_id..v.user_id..","
				end
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						for i , v in pairs(items) do
							_ED.friend_number = _ED.friend_number + 1
						end
						_ED.request_user_num = 0
						_ED.request_user = {}
						state_machine.excute("friend_manager_insert_friend", 0, nil)
						-- for i , v in pairs(items) do
						-- 	state_machine.excute("friend_manager_four_del", 0, v.friend.user_id)
						-- end
						state_machine.excute("friend_manager_four_update", 0, nil)
						state_machine.excute("friend_manager_four_update_friend_number",0,"")
						state_machine.excute("friend_manager_recommend_update_all_friend_number",0,"")
    					state_machine.excute("notification_center_update", 0, "push_notification_center_friend_apply")
				    	state_machine.excute("notification_center_update", 0, "push_notification_center_friend_all")
						TipDlg.drawTextDailog(_new_interface_text[56])
					end
				end
				if user_id ~= "" then
					user_id = string.sub(user_id,1,-2)
					protocol_command.friend_pass.param_list = user_id .."\r\n".."1"
					NetworkManager:register(protocol_command.friend_pass.code, nil, nil, nil, instance, recruitCallBack, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local friend_manager_four_update_friend_number_terminal = {
            _name = "friend_manager_four_update_friend_number",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local Text_friend_n = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_friend_n")
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
        --翻页
		local friend_manager_four_page_updata_terminal = {
            _name = "friend_manager_four_page_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local currType = params._datas._type
            	if currType == 1 then --左
            		if instance.currPage <= 1 then
            			return
            		end
            		instance.currPage = instance.currPage - 1
            	else
            		if instance.currPage >= instance.max_page then
            			return
            		end
            		instance.currPage = instance.currPage + 1
            	end
            	instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(friend_manager_four_update_friend_number_terminal)
		state_machine.add(friend_manager_four_del_terminal)
		state_machine.add(friend_manager_four_update_terminal)
		state_machine.add(friend_manager_four_all_refuse_terminal)
		state_machine.add(friend_manager_four_all_agree_terminal)
		state_machine.add(friend_manager_four_page_updata_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_friend_manager_four_terminal()
end

function FriendManagerFour:checkDel(_id)
	local root = self.roots[1]
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        then
		for i , v in pairs(_ED.request_user) do 
			if tonumber(v.user_id) == tonumber(_id) then
				table.remove(_ED.request_user,i)
				_ED.request_user_num = tostring(tonumber(_ED.request_user_num) - 1)
				break
			end
		end
		if tonumber(_ED.request_user_num) < 0 then
			_ED.request_user_num = 0
		end
		local Text_sq_n = ccui.Helper:seekWidgetByName(root, "Text_sq_n")
		if Text_sq_n ~= nil then
			Text_sq_n:setString(_ED.request_user_num)
		end
		local Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")
		if Text_tip ~= nil then
			Text_tip:setVisible(true)
			if tonumber(_ED.request_user_num) > 0 then
				Text_tip:setVisible(false)
			end
		end
		self.max_page = math.ceil(tonumber(_ED.request_user_num) / self.onePageNumber)
		self.max_page = math.max(self.max_page , 1)
		self:onUpdateDraw()
	else
		local listView = ccui.Helper:seekWidgetByName(root, "ListView_15")
		local items = listView:getItems()
		for i,v in pairs(items) do
			if tonumber(v.friend.user_id) == tonumber(_id) then
				listView:removeItem(i-1)
				_ED.request_user_num = tostring(tonumber(_ED.request_user_num) - 1)
			end
		end
	end
end

function FriendManagerFour:loading_cell()
	if FriendManagerFour.cacheListView == nil then
		return 
	end
	
	local i = FriendManagerFour.asyncIndex
	local friendInfo = {}
	
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
		and ___is_open_fashion == true
		 then
		friendInfo = {
			user_id = _ED.request_user[i].user_id,
			vip_grade = _ED.request_user[i].vip_grade,
			lead_mould_id = _ED.request_user[i].lead_mould_id,
			title = _ED.request_user[i].title,
			name = _ED.request_user[i].name,
			grade = _ED.request_user[i].grade,
			fighting  = _ED.request_user[i].fighting,
			army = _ED.request_user[i].army,
			leave_time = _ED.request_user[i].leave_time,
			fashion_pic = _ED.request_user[i].fashion_pic,
			begin_time = _ED.request_user[i].begin_time,
		}
	else
		friendInfo = {
			user_id = _ED.request_user[i].user_id,
			vip_grade = _ED.request_user[i].vip_grade,
			lead_mould_id = _ED.request_user[i].lead_mould_id,
			title = _ED.request_user[i].title,
			name = _ED.request_user[i].name,
			grade = _ED.request_user[i].grade,
			fighting  = _ED.request_user[i].fighting,
			army = _ED.request_user[i].army,
			leave_time = _ED.request_user[i].leave_time,
			begin_time = _ED.request_user[i].begin_time,
		}
	end
	local cell = FriendManagerList:createCell()
	cell:init(friendInfo,4)
	FriendManagerFour.cacheListView:addChild(cell)
	FriendManagerFour.cacheListView:requestRefreshView()
	FriendManagerFour.asyncIndex = FriendManagerFour.asyncIndex + 1
end

function FriendManagerFour:onUpdateDraw()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_15")
	listView:removeAllItems()
	listView:requestRefreshView()
	-- local Text_friend_n = ccui.Helper:seekWidgetByName(root, "Text_friend_n")
	-- if Text_friend_n ~= nil then
	-- 	local max_friend_number = dms.int(dms["friend_config"] , 1 , friend_config.param)
	-- 	Text_friend_n:setString(_ED.friend_number.."/"..max_friend_number)
	-- end
	local Text_sq_n = ccui.Helper:seekWidgetByName(root, "Text_sq_n")
	if Text_sq_n ~= nil then
		Text_sq_n:setString(_ED.request_user_num)
	end
	local Text_page_n = ccui.Helper:seekWidgetByName(root, "Text_page_n")
	Text_page_n:setString(self.currPage.."/"..self.max_page)

	local Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")
	if Text_tip ~= nil then
		Text_tip:setVisible(true)
		if tonumber(_ED.request_user_num) > 0 then
			Text_tip:setVisible(false)
		end
	end
	
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	FriendManagerFour.asyncIndex = 1
	FriendManagerFour.cacheListView = listView
	
	-- for i, v in pairs(_ED.request_user) do
	for i=1, tonumber(_ED.request_user_num) do
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if i <= self.onePageNumber * self.currPage and i > self.onePageNumber * (self.currPage - 1) then
				local friendInfo = {
					user_id = _ED.request_user[i].user_id,
					vip_grade = _ED.request_user[i].vip_grade,
					lead_mould_id = _ED.request_user[i].lead_mould_id,
					title = _ED.request_user[i].title,
					name = _ED.request_user[i].name,
					grade = _ED.request_user[i].grade,
					fighting  = _ED.request_user[i].fighting,
					army = _ED.request_user[i].army,
					leave_time = _ED.request_user[i].leave_time,
					begin_time = _ED.request_user[i].begin_time,
				}
				local cell = FriendManagerList:createCell()
				cell:init(friendInfo,4)
				listView:addChild(cell)
			end	
		else
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)
		end
	end
	
end

function FriendManagerFour:onEnterTransitionFinish()
	local csbFriendManager = csb.createNode("friend/friend_requests.csb")
	self:addChild(csbFriendManager)
	local root = csbFriendManager:getChildByName("root")
	table.insert(self.roots, root)
	state_machine.excute("friend_manager_four_update_friend_number",0,"")
	
	local Button_all_reject = ccui.Helper:seekWidgetByName(root, "Button_all_reject")
	if Button_all_reject ~= nil then

		fwin:addTouchEventListener(Button_all_reject, nil, 
		{
			terminal_name = "friend_manager_four_all_refuse", 
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, nil, 0)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_all_agree"), nil, 
		{
			terminal_name = "friend_manager_four_all_agree", 
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, nil, 0)

		--左翻页
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_flip_left"), nil, 
		{	
			terminal_name = "friend_manager_four_page_updata", 
			terminal_state = 0, 
			_type = 1,
			isPressedActionEnabled = true
		}, nil, 0)
		--右翻页
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_flip_right"), nil, 
		{	
			terminal_name = "friend_manager_four_page_updata", 
			terminal_state = 0, 
			_type = 2,
			isPressedActionEnabled = true
		}, nil, 0)
	end

	local function recruitInitCallBack(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
				return
			end
			self.onePageNumber = dms.int(dms["friend_config"], 5 , friend_config.param)
			self.max_page = math.ceil(tonumber(_ED.request_user_num) / self.onePageNumber)
			self.max_page = math.max(self.max_page , 1)
			response.node:onUpdateDraw()
		end
	end

	NetworkManager:register(protocol_command.search_friend_apply.code, nil, nil, nil, self, recruitInitCallBack, false, nil)
end


function FriendManagerFour:onExit()
	FriendManagerFour.asyncIndex = 1
	FriendManagerFour.cacheListView = nil

	state_machine.remove("friend_manager_four_del")
	state_machine.remove("friend_manager_four_update")
	state_machine.remove("friend_manager_four_all_refuse")
	state_machine.remove("friend_manager_four_all_agree")
	state_machine.remove("friend_manager_four_update_friend_number")
	state_machine.remove("friend_manager_four_page_updata")
end

function FriendManagerFour:createCell()
	local cell = FriendManagerFour:new()
	cell:registerOnNodeEvent(cell)
	return cell
end