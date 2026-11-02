-- ----------------------------------------------------------------------------------------------------
-- 说明：黑名单界面
-- 创建时间	2015-04-16
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FriendManagerThree = class("FriendManagerThreeClass", Window)
    
function FriendManagerThree:ctor()
    self.super:ctor()
	self.roots = {}
	
    -- Initialize FriendManager page state machine.
    local function init_friend_manager_three_terminal()
		--返回
		local friend_manager_three_add_terminal = {
            _name = "friend_manager_three_add",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:checkDel(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local friend_manager_three_insert_terminal = {
            _name = "friend_manager_three_insert",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
            		or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
            		or __lua_project_id == __lua_project_warship_girl_b 
            		then 
            		if instance == nil or instance.roots == nil or instance.roots[1] == nil then 
            			return
            		end
            	end
				local listView = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_14")
				listView:requestRefreshView()
				local id = params
				local function responseInitThreeCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						for i=1, tonumber(_ED.black_user_num) do
							local friendInfo = {}
							if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
								or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
								and ___is_open_fashion == true
								 then
								friendInfo = {
									user_id = _ED.black_user[i].user_id,
									vip_grade = _ED.black_user[i].vip_grade,
									lead_mould_id = _ED.black_user[i].lead_mould_id,
									title = _ED.black_user[i].title,
									name = _ED.black_user[i].name,
									grade = _ED.black_user[i].grade,
									fighting  = _ED.black_user[i].fighting,
									army = _ED.black_user[i].army,
									leave_time =_ED.black_user[i].leave_time,
									fashion_pic = _ED.black_user[i].fashion_pic,
									begin_time = _ED.black_user[i].begin_time,
								}
							else
								friendInfo = {
									user_id = _ED.black_user[i].user_id,
									vip_grade = _ED.black_user[i].vip_grade,
									lead_mould_id = _ED.black_user[i].lead_mould_id,
									title = _ED.black_user[i].title,
									name = _ED.black_user[i].name,
									grade = _ED.black_user[i].grade,
									fighting  = _ED.black_user[i].fighting,
									army = _ED.black_user[i].army,
									leave_time =_ED.black_user[i].leave_time,
									begin_time = _ED.black_user[i].begin_time,
								}
							end
							if tonumber(friendInfo.user_id) == tonumber(response.node) then
								local cell = FriendManagerList:createCell()
								cell:init(friendInfo,3)
								listView:addChild(cell)
							end
						end
					end
				end
				NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, id, responseInitThreeCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(friend_manager_three_add_terminal)
		state_machine.add(friend_manager_three_insert_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_friend_manager_three_terminal()
end

function FriendManagerThree:checkDel(_id)
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_14")
	listView:requestRefreshView()
	local items = listView:getItems()
	for i,v in ipairs(items) do
		if tonumber(v.friend.user_id) == tonumber(_id) then
			local function responseRemoveBlackManCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					listView:removeItem(i-1)
					table.remove(_ED.black_user, i,1)
				end
			end
			protocol_command.remove_black.param_list = "".._id
			NetworkManager:register(protocol_command.remove_black.code, nil, nil, nil, nil, responseRemoveBlackManCallback, false, nil)
			return
		end
	end
end

function FriendManagerThree:loading_cell()
	if FriendManagerThree.cacheListView == nil then
		return 
	end
	
	local i = FriendManagerThree.asyncIndex
	local friendInfo = {}
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
		and ___is_open_fashion == true
		 then
		friendInfo = {
			user_id = _ED.black_user[i].user_id,
			vip_grade = _ED.black_user[i].vip_grade,
			lead_mould_id = _ED.black_user[i].lead_mould_id,
			title = _ED.black_user[i].title,
			name = _ED.black_user[i].name,
			grade = _ED.black_user[i].grade,
			fighting  = _ED.black_user[i].fighting,
			army = _ED.black_user[i].army,
			leave_time =_ED.black_user[i].leave_time,
			fashion_pic = _ED.black_user[i].fashion_pic,
			begin_time = _ED.black_user[i].begin_time,
		}
	else
		friendInfo = {
			user_id = _ED.black_user[i].user_id,
			vip_grade = _ED.black_user[i].vip_grade,
			lead_mould_id = _ED.black_user[i].lead_mould_id,
			title = _ED.black_user[i].title,
			name = _ED.black_user[i].name,
			grade = _ED.black_user[i].grade,
			fighting  = _ED.black_user[i].fighting,
			army = _ED.black_user[i].army,
			leave_time =_ED.black_user[i].leave_time,
			begin_time = _ED.black_user[i].begin_time,
		}
	end
	local cell = FriendManagerList:createCell()
	cell:init(friendInfo,3)
	FriendManagerThree.cacheListView:addChild(cell)
	FriendManagerThree.cacheListView:requestRefreshView()
	FriendManagerThree.asyncIndex = FriendManagerThree.asyncIndex + 1
end

function FriendManagerThree:onUpdateDraw()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_14")
	listView:setVisible(true)
	listView:requestRefreshView()
	
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	FriendManagerThree.asyncIndex = 1
	FriendManagerThree.cacheListView = listView
	if tonumber(_ED.black_user_num) > 0 then
		for i=1, tonumber(_ED.black_user_num) do
			-- self.friendInfo = {
				-- user_id = _ED.black_user[i].user_id,
				-- vip_grade = _ED.black_user[i].vip_grade,
				-- lead_mould_id = _ED.black_user[i].lead_mould_id,
				-- title = _ED.black_user[i].title,
				-- name = _ED.black_user[i].name,
				-- grade = _ED.black_user[i].grade,
				-- fighting  = _ED.black_user[i].fighting,
				-- army = _ED.black_user[i].army,
				-- leave_time =_ED.black_user[i].leave_time,
			-- }
			-- local cell = FriendManagerList:createCell()
			-- cell:init(friendInfo,3)
			-- listView:addChild(cell)
			
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
		end
	end
	
end

function FriendManagerThree:onEnterTransitionFinish()
	local csbFriendManager = csb.createNode("friend/friend_blacklist.csb")
	self:addChild(csbFriendManager)
	local root = csbFriendManager:getChildByName("root")
	table.insert(self.roots, root)
	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_106_0"), nil, 
	{
		terminal_name = "friend_manager_two_get", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, nil, 0)
	
	local function responseInitThreeCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				-- or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh  then
				if response.node == nil or response.node.roots == nil then
					return
				end
				response.node:onUpdateDraw()
			-- else
				-- response.node:onUpdateDraw()
			-- end
		end
	end
	NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, self, responseInitThreeCallback, false, nil)
end


function FriendManagerThree:onExit()
	FriendManagerThree.asyncIndex = 1
	FriendManagerThree.cacheListView = nil

	state_machine.remove("friend_manager_three_add")
	state_machine.remove("friend_manager_three_insert")
end

function FriendManagerThree:createCell()
	local cell = FriendManagerThree:new()
	cell:registerOnNodeEvent(cell)
	return cell
end