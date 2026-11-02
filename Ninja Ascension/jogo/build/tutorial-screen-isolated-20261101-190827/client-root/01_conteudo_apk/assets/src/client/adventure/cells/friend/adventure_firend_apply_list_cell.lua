----------------------------------------------------------------------------------------------------
-- 说明：好友申请列表项
----------------------------------------------------------------------------------------------------
AdventureFirendApplyListCell = class("AdventureFirendApplyListCellClass", Window)
AdventureFirendApplyListCell.__size = nil


function AdventureFirendApplyListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	self.drawIndex = 0
	self.friendInfo = nil
	self.type = 1

	-- Initialize adventure firend apply list cell state machine.
	local function init_firend_apply_list_cell_terminal()
		-- 取消
        local firend_apply_list_cell_cancel_terminal = {
            _name = "firend_apply_list_cell_cancel",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local firend = params._datas.cell.friendInfo

				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("adventure_friend_apply_delete", 0, firend.user_id)
					end
				end
				protocol_command.friend_pass.param_list = firend.user_id .."\r\n".."2"
				NetworkManager:register(protocol_command.friend_pass.code, nil, nil, nil, nil, recruitCallBack, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        -- 同意
        local firend_apply_list_cell_agree_terminal = {
            _name = "firend_apply_list_cell_agree",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local firend = params._datas.cell.friendInfo

				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("adventure_friend_apply_delete", 0, firend.user_id)
						state_machine.excute("adventure_friend_manager_insert_friend", 0, "")
						TipDlg.drawTextDailog(_string_piece_info[397])
					end
				end
				protocol_command.friend_pass.param_list = firend.user_id .."\r\n".."1"
				NetworkManager:register(protocol_command.friend_pass.code, nil, nil, nil, nil, recruitCallBack, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

         -- 添加
        local firend_apply_list_cell_add_terminal = {
            _name = "firend_apply_list_cell_add",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local firend = params._datas.cell.friendInfo
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("adventure_friend_clean_search_find", 0, "")		
						TipDlg.drawTextDailog(_string_piece_info[259] .. firend.name .._string_piece_info[260])
					end
				end
				protocol_command.friend_request.param_list = firend.user_id .."\r\n".."1"
				--NetworkManager:register(protocol_command.friend_pass.code, nil, nil, nil, nil, recruitCallBack, false, nil)
				NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, nil, recruitCallBack, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }


        state_machine.add(firend_apply_list_cell_cancel_terminal)
        state_machine.add(firend_apply_list_cell_agree_terminal)
        state_machine.add(firend_apply_list_cell_add_terminal)
    
		state_machine.init()
	end

	-- call func init adventure firend apply list cell state machine.
	init_firend_apply_list_cell_terminal()
end

function AdventureFirendApplyListCell:onEnterTransitionFinish()

end

function AdventureFirendApplyListCell:onInit()
	local root = cacher.createUIRef("list/list_friend_1.csb", "root")
 	table.insert(self.roots, root)
 	--root:removeFromParent(false)
 	self:addChild(root)

	if AdventureFirendListCell.__size == nil then
		AdventureFirendListCell.__size = root:getContentSize()
	end

	local cancelButton = ccui.Helper:seekWidgetByName(root, "Button_del")
	fwin:addTouchEventListener(cancelButton, nil, 
	{
		terminal_name = "firend_apply_list_cell_cancel",	
		terminal_state = 0,
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)

	local agreeButton = ccui.Helper:seekWidgetByName(root, "Button_agree")
	fwin:addTouchEventListener(agreeButton, nil, 
	{
		terminal_name = "firend_apply_list_cell_agree",	
		terminal_state = 0,
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)

	local addButton = ccui.Helper:seekWidgetByName(root, "Button_add")
	fwin:addTouchEventListener(addButton, nil, 
	{
		terminal_name = "firend_apply_list_cell_add",	
		terminal_state = 0,
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	ccui.Helper:seekWidgetByName(root, "Button_agree"):setVisible(self.type == 1)
	ccui.Helper:seekWidgetByName(root, "Button_del"):setVisible(self.type == 1)
	ccui.Helper:seekWidgetByName(root, "Button_add"):setVisible(self.type == 2)
	
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_rolename")
	nameText:setString(self.friendInfo.name)
	local leaveTimeText = ccui.Helper:seekWidgetByName(root, "Text_denglutime")
	-- 搜索到的好友不需要显示上次登入时间
	if self.type == 2 then
		leaveTimeText:setString("")
	else 
		leaveTimeText:setString(self:getLeaveTimeString(self.friendInfo.leave_time))
	end
	leaveTimeText:setVisible(false)
	local mould_data = dms.element(dms["ship_mould"], self.friendInfo.lead_mould_id)
	local picIndex = dms.atos(mould_data, ship_mould.head_icon)
	-- fashion_pic
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		if self.friendInfo.fashion_pic ~= nil and zstring.tonumber(self.friendInfo.fashion_pic) then
			picIndex = zstring.tonumber(self.friendInfo.fashion_pic)
		end
	end
	local pick = ccui.Helper:seekWidgetByName(root, "Panel_role")
	pick:removeAllChildren(true)
	pick:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(picIndex)))
end

function AdventureFirendApplyListCell:getLeaveTimeString(leave_time)
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

function AdventureFirendApplyListCell:onExit()
	cacher.freeRef("list/list_friend_1.csb", self.roots[1])
end

function AdventureFirendApplyListCell:init(friend, drawIndex,type)
	self.friendInfo = friend
	self.drawIndex = drawIndex
	self.type = type
	if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	end
	self:setContentSize(AdventureFirendListCell.__size)
	return self
end

function AdventureFirendApplyListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureFirendApplyListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("list/list_friend_1.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureFirendApplyListCell:createCell()
	local cell = AdventureFirendApplyListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
