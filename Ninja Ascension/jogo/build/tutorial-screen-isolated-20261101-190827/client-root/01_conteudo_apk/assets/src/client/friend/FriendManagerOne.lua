-- ----------------------------------------------------------------------------------------------------
-- 说明：好友界面
-- 创建时间	2015-04-16
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FriendManagerOne = class("FriendManagerOneClass", Window)
    
function FriendManagerOne:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	app.load("client.friend.FriendManagerRecommend")
	app.load("client.friend.FriendManagerAdd")
	self.max_friend_number = 0
	self.max_draw_strength = 0
	self.num = 0
	self.currPage = 1 -- 当前显示第几页
	self.max_page = 0
	self.onePageNumber = 0
    -- Initialize FriendManager page state machine.
    local function init_friend_manager_one_terminal()
		
		--推荐好友
		local friend_manager_one_click_friend_recommend_terminal = {
            _name = "friend_manager_one_click_friend_recommend",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:open(FriendManagerRecommend:new(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--添加好友
		local friend_manager_one_click_friend_add_terminal = {
            _name = "friend_manager_one_click_friend_add",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:open(FriendManagerAdd:new(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--移除好友(删除时调用)
		local friend_manager_del_friend_terminal = {
            _name = "friend_manager_del_friend",
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
		
		local friend_manager_insert_friend_terminal = {
            _name = "friend_manager_insert_friend",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- instance:checkAdd(params)
				-- local listView = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_01")
				-- listView:requestRefreshView()
				local function responseInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
								or __lua_project_id == __lua_project_l_naruto
								then
								response.node:onUpdateDraw()
							else
								for i, v in pairs(_ED.friend_info) do
									local friendInfo = {}
									if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
										or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
										and ___is_open_fashion == true
										 then
										friendInfo = {
											user_id=v.user_id,
											vip_grade=v.vip_grade,
											lead_mould_id=v.lead_mould_id,
											title=v.title,
											name=v.name,
											grade=v.grade,
											fighting=v.fighting,
											army=v.army,
											is_send=v.is_send,
											leave_time=v.leave_time,
											fashion_pic = v.fashion_pic,
											begin_time = v.begin_time,
										}
									else
										friendInfo = {
											user_id=v.user_id,
											vip_grade=v.vip_grade,
											lead_mould_id=v.lead_mould_id,
											title=v.title,
											name=v.name,
											grade=v.grade,
											fighting=v.fighting,
											army=v.army,
											is_send=v.is_send,
											leave_time=v.leave_time,
											begin_time = v.begin_time,
										}
									end
									if tonumber(friendInfo.user_id) == tonumber(params) then
										local cell = FriendManagerList:createCell()
										cell:init(friendInfo,1)
										listView:addChild(cell)
									end
								end
							end
						end
					end
				end
				NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, instance, responseInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--一键领取体力
		local friend_manager_one_click_friend_get_terminal = {
            _name = "friend_manager_one_click_friend_get",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							TipDlg.drawTextDailog(_new_interface_text[52])
							self:onUpdateDraw()
						end
					end
				end
				local draw_number = 0
				for i, v in pairs(_ED.endurance_init_info.get_info) do
					if tonumber(v.draw_state) == 1 then
						draw_number = draw_number + 1
					end
				end
				if draw_number >= instance.max_draw_strength then
					TipDlg.drawTextDailog(_string_piece_info[326])
					return
				end
				local last_draw_number = instance.max_draw_strength - draw_number
				local str = ""
				local can_draw_number = 0
				for i, v in pairs(_ED.friend_info) do
					if can_draw_number >= last_draw_number then
						break
					end
					for k, v1 in pairs(_ED.endurance_init_info.get_info) do
						if tonumber(v.user_id) == tonumber(v1.user_id) then
							if tonumber(v1.draw_state) == 0 then
								str = str .. v1.id..","
								can_draw_number = can_draw_number + 1
							end
							break
						end
					end
				end
				if str ~= "" then
					str = string.sub(str,1,-2)
					protocol_command.draw_endurance.param_list = str .."\r\n".."1"
					NetworkManager:register(protocol_command.draw_endurance.code, nil, nil, nil, instance, recruitCallBack, false, nil)
				else
					TipDlg.drawTextDailog(_string_piece_info[325])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --一键赠送体力
		local friend_manager_one_click_friend_give_terminal = {
            _name = "friend_manager_one_click_friend_give",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local cell = params._datas._cell
				local function recruitSendCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							TipDlg.drawTextDailog(_new_interface_text[54])
							response.node:onUpdateDraw()
						end
					end
				end
				local str = ""
				-- local items = FriendManagerOne.cacheListView:getItems()
				for i, v in pairs(_ED.friend_info) do
					if tonumber(v.is_send) == 0 then
						str = str .. v.user_id..","
					end
				end
				if str ~= "" then
					str = string.sub(str,1,-2)
					protocol_command.present_endurance.param_list = str .."\r\n".."1"
					NetworkManager:register(protocol_command.present_endurance.code, nil, nil, nil, instance, recruitSendCallBack, false, nil)
				else
					TipDlg.drawTextDailog(_new_interface_text[53])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新
		local friend_manager_click_friend_updata_terminal = {
            _name = "friend_manager_click_friend_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local function responseInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then	
						if response.node ~= nil and response.node.roots ~= nil then
							response.node.max_page = math.ceil( tonumber(_ED.friend_number) / response.node.onePageNumber)
							response.node.max_page = math.max(response.node.max_page , 1)
							response.node:onUpdateDraw()
							state_machine.excute("friend_manager_four_update_friend_number",0,"")
							state_machine.excute("friend_manager_recommend_update_all_friend_number",0,"")
						end
					end
				end
				NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, instance, responseInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --翻页
		local friend_manager_scroll_to_page_updata_terminal = {
            _name = "friend_manager_scroll_to_page_updata",
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
		state_machine.add(friend_manager_one_click_friend_recommend_terminal)
		state_machine.add(friend_manager_one_click_friend_add_terminal)
		state_machine.add(friend_manager_del_friend_terminal)
		state_machine.add(friend_manager_insert_friend_terminal)
        state_machine.add(friend_manager_one_click_friend_get_terminal)
        state_machine.add(friend_manager_one_click_friend_give_terminal)
		state_machine.add(friend_manager_click_friend_updata_terminal)
		state_machine.add(friend_manager_scroll_to_page_updata_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_friend_manager_one_terminal()
end

function FriendManagerOne:checkDel(_id)
	local root = self.roots[1]
	for i , v in pairs(_ED.friend_info) do 
		if tonumber(v.user_id) == tonumber(_id) then
			table.remove(_ED.friend_info,i)
			break
		end
	end
	self.max_page = math.ceil( tonumber(_ED.friend_number) / self.onePageNumber)
	self.max_page = math.max(self.max_page , 1)
	self:onUpdateDraw()
	-- local listView = ccui.Helper:seekWidgetByName(root, "ListView_01")
	-- local items = listView:getItems()
	-- for i,v in pairs(items) do
	-- 	if tonumber(v.friend.user_id) == tonumber(_id) then
	-- 		listView:removeItem(i-1)
	-- 	end
	-- end
	-- self.num = self.num - 1
	-- if self.num < 0 then
	-- 	self.num = 0
	-- end
	-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	-- 	ccui.Helper:seekWidgetByName(root, "Text_06_4"):setString(self.num.."/"..self.max_friend_number)
	-- end
	-- local str = self.num.."/"..self.max_friend_number
	-- state_machine.excute("friend_manager_four_update_friend_number", 0,str)
	-- state_machine.excute("friend_manager_recommend_update_all_friend_number",0,str)
end

function FriendManagerOne:checkAdd(cell)
	local root = self.roots[1]
	-- self.num = self.num + 1
	-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	-- 	ccui.Helper:seekWidgetByName(root, "Text_06_4"):setString(self.num.."/"..self.max_friend_number)
	-- end
	-- local str = self.num.."/"..self.max_friend_number
	-- state_machine.excute("friend_manager_four_update_friend_number", 0,str)
	-- state_machine.excute("friend_manager_recommend_update_all_friend_number",0,str)
	self:onUpdateDraw()
end

function FriendManagerOne:loading_cell()
	if FriendManagerOne.cacheListView == nil then
		return 
	end
	
	local v = _ED.friend_info[FriendManagerOne.asyncIndex]
	local friendInfo = {}
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
		and ___is_open_fashion == true
		 then
		friendInfo = {
			user_id=v.user_id,
			vip_grade=v.vip_grade,
			lead_mould_id=v.lead_mould_id,
			title=v.title,
			name=v.name,
			grade=v.grade,
			fighting=v.fighting,
			army=v.army,
			is_send=v.is_send,
			leave_time=v.leave_time,
			fashion_pic = v.fashion_pic,
			begin_time=v.begin_time,
		}
	else
		friendInfo = {
			user_id=v.user_id,
			vip_grade=v.vip_grade,
			lead_mould_id=v.lead_mould_id,
			title=v.title,
			name=v.name,
			grade=v.grade,
			fighting=v.fighting,
			army=v.army,
			is_send=v.is_send,
			leave_time=v.leave_time,
			begin_time=v.begin_time,
		}
	end
	local cell = FriendManagerList:createCell()
	cell:init(friendInfo,1)
	FriendManagerOne.cacheListView:addChild(cell)
	FriendManagerOne.cacheListView:requestRefreshView()
	FriendManagerOne.asyncIndex = FriendManagerOne.asyncIndex + 1
end

function FriendManagerOne:onUpdateDraw()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_01")
	listView:removeAllItems()
	local Text_page_n = ccui.Helper:seekWidgetByName(root, "Text_page_n")
	Text_page_n:setString(self.currPage.."/"..self.max_page)
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	FriendManagerOne.asyncIndex = 1
	FriendManagerOne.cacheListView = listView
	
	for i, v in pairs(_ED.friend_info) do
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if i <= self.onePageNumber * self.currPage and i > self.onePageNumber * (self.currPage - 1) then
				local friendInfo = {
					user_id=v.user_id,
					vip_grade=v.vip_grade,
					lead_mould_id=v.lead_mould_id,
					title=v.title,
					name=v.name,
					grade=v.grade,
					fighting=v.fighting,
					army=v.army,
					is_send=v.is_send,
					leave_time=v.leave_time,
					begin_time=v.begin_time,
				}
				local cell = FriendManagerList:createCell()
				cell:init(friendInfo,1)
				listView:addChild(cell)
			end
		else	
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)
		end	
	end
	listView:requestRefreshView()
	self.num = tonumber(_ED.friend_number)
	local num = self.num
	local Image_tip = ccui.Helper:seekWidgetByName(root, "Image_tip")
	Image_tip:setVisible(true)
	if num > 0 then
		Image_tip:setVisible(false)
	end	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		num = num.."/"..self.max_friend_number
		local draw_number = 0
		for i, v in pairs(_ED.endurance_init_info.get_info) do
			if tonumber(v.draw_state) == 1 then
				draw_number = draw_number + 1
			end
		end
		ccui.Helper:seekWidgetByName(root, "Text_tili_receive_n"):setString(draw_number.."/"..self.max_draw_strength)
	end
	ccui.Helper:seekWidgetByName(root, "Text_06_4"):setString(num)
end

function FriendManagerOne:onEnterTransitionFinish()
	local csbFriendManagerOne = csb.createNode("friend/friend_friend.csb")
	self:addChild(csbFriendManagerOne)
	local root = csbFriendManagerOne:getChildByName("root")
	table.insert(self.roots, root)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert  then
		local action = csb.createTimeline("friend/friend_friend.csb") 
		table.insert(self.actions, action )
		csbFriendManagerOne:runAction(action)
		action:play("window_open", false)
	end
	self.max_friend_number = dms.int(dms["friend_config"] , 1 , friend_config.param)
	self.max_draw_strength = zstring.split(dms.string(dms["friend_config"] , 4 , friend_config.param),",")
	self.max_draw_strength = tonumber(self.max_draw_strength[1])
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		ccui.Helper:seekWidgetByName(root, "Text_06_4"):setString("0/"..self.max_friend_number)
		ccui.Helper:seekWidgetByName(root, "Text_tili_receive_n"):setString("0/"..self.max_draw_strength)
	end
	local function responseInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then	
			if response.node ~= nil and response.node.roots ~= nil then
				self.onePageNumber = dms.int(dms["friend_config"], 5 , friend_config.param)
				self.max_page = math.ceil( tonumber(_ED.friend_number) / self.onePageNumber)
				self.max_page = math.max(self.max_page , 1)
				response.node:onUpdateDraw()
			end
		end
	end
	NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, self, responseInitCallback, false, nil)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_06_2"), nil, {terminal_name = "friend_manager_one_click_friend_recommend", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_07_4"), nil, {terminal_name = "friend_manager_one_click_friend_add", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_quickly_receive"), nil, {terminal_name = "friend_manager_one_click_friend_get", terminal_state = 0, isPressedActionEnabled = true}, nil, 0) -- 一键领取
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_quickly_give"), nil, {terminal_name = "friend_manager_one_click_friend_give", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)	--一键赠送
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_refresh"), nil, {terminal_name = "friend_manager_click_friend_updata", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)	--刷新
	--左翻页
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_flip_left"), nil, 
	{	
		terminal_name = "friend_manager_scroll_to_page_updata", 
		terminal_state = 0, 
		_type = 1,
		isPressedActionEnabled = true
	}, nil, 0)
	--右翻页
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_flip_right"), nil, 
	{	
		terminal_name = "friend_manager_scroll_to_page_updata", 
		terminal_state = 0, 
		_type = 2,
		isPressedActionEnabled = true
	}, nil, 0)
	
	
end


function FriendManagerOne:onExit()
	FriendManagerOne.asyncIndex = 1
	FriendManagerOne.cacheListView = nil

	state_machine.remove("friend_manager_one_click_friend_add")
	state_machine.remove("friend_manager_one_click_friend_recommend")
	state_machine.remove("friend_manager_del_friend")
	state_machine.remove("friend_manager_insert_friend")
	state_machine.remove("friend_manager_one_click_friend_get")
	state_machine.remove("friend_manager_one_click_friend_give")
	state_machine.remove("friend_manager_click_friend_updata")
	state_machine.remove("friend_manager_scroll_to_page_updata")
end

function FriendManagerOne:createCell()
	local cell = FriendManagerOne:new()
	cell:registerOnNodeEvent(cell)
	return cell
end