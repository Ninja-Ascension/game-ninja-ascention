-- ----------------------------------------------------------------------------------------------------
-- 说明：领取耐力界面
-- 创建时间	2015-04-16
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FriendManagerTwo = class("FriendManagerTwoClass", Window)
    
function FriendManagerTwo:ctor()
    self.super:ctor()
	self.roots = {}
	self._id = {}
    -- Initialize FriendManager page state machine.
    local function init_friend_manager_two_terminal()
		--领取耐力
		local friend_manager_two_get_once_terminal = {
            _name = "friend_manager_two_get_once",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- draw_endurance
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							if response.node == nil or response.node.roots == nil then
								return
							end
						end
						ccui.Helper:seekWidgetByName(response.node.roots[1], "ListView_02"):removeAllItems()
						_ED.endurance_init_info.get_count = "0"
						_ED.endurance_init_info.get_info = {}
						response.node._id = {}
						response.node:onUpdateEnduranceTimes()

					end
				end
				local str = ""
				for i = 1, table.getn(instance._id) do
					if str == "" then
						str = instance._id[i]..","
					else
						str = str .. instance._id[i]..","
					end
				end
				if str ~= "" then
					if tonumber(_ED.endurance_init_info.remain_times) > 0 then
						protocol_command.draw_endurance.param_list = str .."\r\n".."1"
						NetworkManager:register(protocol_command.draw_endurance.code, nil, nil, nil, instance, recruitCallBack, false, nil)
					else
						TipDlg.drawTextDailog(_string_piece_info[326])
					end
				else
					TipDlg.drawTextDailog(_string_piece_info[325])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local friend_manager_two_check_terminal = {
            _name = "friend_manager_two_check",
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

		state_machine.add(friend_manager_two_get_once_terminal)
		state_machine.add(friend_manager_two_check_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_friend_manager_two_terminal()
end

function FriendManagerTwo:checkDel(_id)
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_02")
	local items = listView:getItems()
	for i,v in pairs(items) do
		if tonumber(v.friend.id) == tonumber(_id) then
			listView:removeItem(i-1)
			self._id[i] = ""
			_ED.endurance_init_info.get_count = tostring(tonumber(_ED.endurance_init_info.get_count) - 1)
			
			for i, v in pairs(_ED.endurance_init_info.get_info) do
				if tonumber(v.id) == tonumber(_id) then
					table.remove(_ED.endurance_init_info.get_info, i)
				end
			end
			
			TipDlg.drawTextDailog(_string_piece_info[354])
			break
		end
	end
	self:onUpdateEnduranceTimes()
end

function FriendManagerTwo:loading_cell()
	if FriendManagerTwo.cacheListView == nil then
		return 
	end
	
	local v = _ED.endurance_init_info.get_info[FriendManagerTwo.asyncIndex]
	-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if v == nil then
			return
		end
	-- end
	local friendInfo = {}
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
		and ___is_open_fashion == true
		 then
		friendInfo = {
			id = v.id,
			user_id = v.user_id,
			vip_grade = v.vip_grade,
			lead_mould_id = v.lead_mould_id,
			title = v.title,
			name = v.name,
			grade = v.grade,
			fighting  = v.fighting,
			army = v.army,
			leave_time = v.leave_time,
			fashion_pic = v.fashion_pic,
			begin_time = v.begin_time,
		}
	else
		friendInfo = {
			id = v.id,
			user_id = v.user_id,
			vip_grade = v.vip_grade,
			lead_mould_id = v.lead_mould_id,
			title = v.title,
			name = v.name,
			grade = v.grade,
			fighting  = v.fighting,
			army = v.army,
			leave_time = v.leave_time,
			begin_time = v.begin_time,
		}
	end
	
	local cell = FriendManagerList:createCell()
	cell:init(friendInfo,2)
	FriendManagerTwo.cacheListView:addChild(cell)
	FriendManagerTwo.cacheListView:requestRefreshView()
	FriendManagerTwo.asyncIndex = FriendManagerTwo.asyncIndex + 1
end

function FriendManagerTwo:onUpdateEnduranceTimes()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local bat = ccui.Helper:seekWidgetByName(root, "Text_06_0_6")   --次数
	bat:setString(_ED.endurance_init_info.remain_times)	--剩余次数
end

function FriendManagerTwo:onUpdateDraw()
	local root = self.roots[1]
	local bat = ccui.Helper:seekWidgetByName(root, "Text_06_0_6")   --次数
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_02")
	listView:requestRefreshView()
	bat:setString(_ED.endurance_init_info.remain_times)	--剩余次数
	
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	FriendManagerTwo.asyncIndex = 1
	FriendManagerTwo.cacheListView = listView
	
	for i, v in pairs(_ED.endurance_init_info.get_info) do
		local friendInfo = {}
		if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
			and ___is_open_fashion == true
			 then
			friendInfo = {
				id = v.id,
				user_id = v.user_id,
				vip_grade = v.vip_grade,
				lead_mould_id = v.lead_mould_id,
				title = v.title,
				name = v.name,
				grade = v.grade,
				fighting  = v.fighting,
				army = v.army,
				leave_time = v.leave_time,
				fashion_pic = v.fashion_pic,
				begin_time = v.begin_time,
				}
		else
			friendInfo = {
				id = v.id,
				user_id = v.user_id,
				vip_grade = v.vip_grade,
				lead_mould_id = v.lead_mould_id,
				title = v.title,
				name = v.name,
				grade = v.grade,
				fighting  = v.fighting,
				army = v.army,
				leave_time = v.leave_time,
				begin_time = v.begin_time,
			}
		end
		self._id[i] = friendInfo.id
		-- local cell = FriendManagerList:createCell()
		-- cell:init(friendInfo,2)
		-- listView:addChild(cell)
		cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
		
	end
	
end


function FriendManagerTwo:onEnterTransitionFinish()
	local csbFriendManagerTwo = csb.createNode("friend/friend_collect_ammunition.csb")
	self:addChild(csbFriendManagerTwo)
	local root = csbFriendManagerTwo:getChildByName("root")
	table.insert(self.roots, root)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2_6"), nil, 
	{
		terminal_name = "friend_manager_two_get_once", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, nil, 0)

	
	
	local function recruitInitCallBack(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil then
				response.node:onUpdateDraw()
			end
		end
	end
	
	NetworkManager:register(protocol_command.draw_endurance_init.code, nil, nil, nil, self, recruitInitCallBack, false, nil)
end


function FriendManagerTwo:onExit()
	FriendManagerTwo.asyncIndex = 1
	FriendManagerTwo.cacheListView = nil

	state_machine.remove("friend_manager_two_get_once")
	state_machine.remove("friend_manager_two_check")

end

function FriendManagerTwo:createCell()
	local cell = FriendManagerTwo:new()
	cell:registerOnNodeEvent(cell)
	return cell
end