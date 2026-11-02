----------------------------------------------------------------------------------------------------
-- 说明：好友列表项
----------------------------------------------------------------------------------------------------
AdventureFirendListCell = class("AdventureFirendListCellClass", Window)
AdventureFirendListCell.__size = nil

app.load("client.adventure.cells.icons.adventure_player_head_icon_cell")

function AdventureFirendListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.drawIndex = 0
	self.friendInfo = nil
	self.sendButton = nil
	self.deleteButton = nil
	self.parentNode = nil
	
	-- Initialize adventure firend list cell state machine.
	local function init_firend_list_cell_terminal()
		-- 挑战
        local firend_list_cell_fight_terminal = {
            _name = "firend_list_cell_fight",
            _init = function (terminal)
                app.load("client.adventure.battle.AdventureBattle")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local firend = params._datas.cell.friendInfo
				local function recruitSendCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						fwin:removeAll()
                        cc.Director:getInstance():purgeCachedData()
						_ED._battle_map_type = 1
                        fwin:open(AdventureBattle:new():init(), fwin._background)
					end
				end
	
                protocol_command.union_fight.param_list = firend.user_id .."\r\n"
				NetworkManager:register(protocol_command.union_fight.code, nil, nil, nil, nil, recruitSendCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        -- 送爱心
        local firend_list_cell_send_terminal = {
            _name = "firend_list_cell_send",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local firend = params._datas.cell.friendInfo

				local function recruitSendCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						TipDlg.drawTextDailog(_string_piece_info[398])
						local  ui = fwin:find("AdventureFriendMangerClass")
						if ui ~= nil then 
							state_machine.excute("adventure_friend_manager_update_friend_list",0,0)
						end
					end
				end
				
				-- 公用送耐力接口
				protocol_command.present_endurance.param_list = firend.user_id .."\r\n"
				NetworkManager:register(protocol_command.present_endurance.code, nil, nil, nil, nil, recruitSendCallBack, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        -- 删除
        local firend_list_cell_delete_terminal = {
            _name = "firend_list_cell_delete",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local friend = params._datas.cell.friendInfo

				local function recruitDelBackCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local str = fwin:find("AdventureFriendMangerClass")
						if str ~= nil then
							state_machine.excute("adventure_friend_manager_delete_friend", 0, friend.user_id)
						end
					end
				end
				
				protocol_command.friend_del.param_list = friend.user_id
				NetworkManager:register(protocol_command.friend_del.code, nil, nil, nil, nil, recruitDelBackCallBack, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        -- 更新 删除 送爱心 按钮状态
        local firend_list_cell_update_del_send_button_terminal = {
            _name = "firend_list_cell_update_del_send_button",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._cell
            	local state = params._state

                cell:changeDelButton(state)
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        state_machine.add(firend_list_cell_fight_terminal)
        state_machine.add(firend_list_cell_send_terminal)
        state_machine.add(firend_list_cell_delete_terminal)
        state_machine.add(firend_list_cell_update_del_send_button_terminal)

        state_machine.init()
	end

	-- call func init adventure firend list cell state machine.
	init_firend_list_cell_terminal()
end

function AdventureFirendListCell:onEnterTransitionFinish()

end

function AdventureFirendListCell:changeDelButton(state)
	if  self.sendButton ~= nil then 
		if  self.parentNode.state == "delete" then
			self.sendButton:setVisible(false)
			self.deleteButton:setVisible(true)
		else
			self.sendButton:setVisible(true)
			self.deleteButton:setVisible(false)
		end
	end
end

function AdventureFirendListCell:onInit()
	local root = cacher.createUIRef("list/list_friend.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

	if AdventureFirendListCell.__size == nil then
		AdventureFirendListCell.__size = root:getContentSize()
	end

	-- 挑战
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tiaozhan"), nil, 
	{
		terminal_name = "firend_list_cell_fight",	
		terminal_state = 0,
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)

	local sendButton = ccui.Helper:seekWidgetByName(root, "Button_give")
	sendButton:setVisible(true)
	if tonumber(self.friendInfo.is_send) == 1 then
		sendButton:setTouchEnabled(false)
		sendButton:setHighlighted(false)
		sendButton:setColor(cc.c3b(150, 150, 150))
	else
		sendButton:setTouchEnabled(true)
		-- 送友情点数
		fwin:addTouchEventListener(sendButton, nil, 
		{
			terminal_name = "firend_list_cell_send",	
			terminal_state = 0,
			cell = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
		sendButton:setColor(cc.c3b(255, 255, 255))
	end

	local delButton = ccui.Helper:seekWidgetByName(root, "Button_del")
	delButton:setVisible(false)
	fwin:addTouchEventListener(delButton, nil, 
	{
		terminal_name = "firend_list_cell_delete",	
		terminal_state = 0,
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)


	self.sendButton = sendButton
	self.deleteButton = delButton
	if self.parentNode.state ~= nil  then 
		if self.parentNode.state == "delete" then
			self.sendButton:setVisible(false)
			self.deleteButton:setVisible(true)
		else
			self.sendButton:setVisible(true)
			self.deleteButton:setVisible(false)
		end
	end
	-- 添加玩家头像
	-- local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_role")
	-- headPanel:removeAllChildren(true)
	-- local headCell = AdventurePlayerHeadIconCell:createCell()
	-- headCell:init(1)
	-- headPanel:addChild(headCell)

	local mould_data = dms.element(dms["ship_mould"], self.friendInfo.lead_mould_id)
	local picIndex = dms.atos(mould_data, ship_mould.head_icon)
	local pick = ccui.Helper:seekWidgetByName(root, "Panel_role")
	pick:removeAllChildren(true)

	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte.ExportJson")
	local size = pick:getContentSize()
	local armature = ccs.Armature:create("spirte")
	local spriteIcon = string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(picIndex))
    local skinIcon = ccs.Skin:create(spriteIcon)
    skinIcon:getTexture():setAliasTexParameters()
    armature:getBone("big_head_"..1):addDisplay(skinIcon, 0) 
    armature:setPosition(cc.p(size.width/2,0))
    pick:addChild(armature)
	--pick:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(picIndex)))
	local duanweiText = ccui.Helper:seekWidgetByName(root, "Text_duanwei")
	if zstring.tonumber(self.friendInfo.title_id) == 0 then 
		duanweiText:setString(_string_piece_info[468])
	else
		local titleName = dms.string(dms["warcraft_mould"], self.friendInfo.title_id, warcraft_mould.title_name)
		duanweiText:setString(titleName)	
	end
	
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_rolename")
	nameText:setString(self.friendInfo.name)

	local leaveTimeText = ccui.Helper:seekWidgetByName(root, "Text_denglutime")
	leaveTimeText:setString(self:getLeaveTimeString(self.friendInfo.leave_time))
end

function AdventureFirendListCell:getLeaveTimeString(leave_time)
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

function AdventureFirendListCell:onExit()
	cacher.freeRef("list/list_friend.csb", self.roots[1])
end

function AdventureFirendListCell:init(friend, drawIndex,parent)
	self.friendInfo = friend
	self.drawIndex = drawIndex
	self.parentNode = parent

	if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	end

	self:setContentSize(AdventureFirendListCell.__size)
	return self
end

function AdventureFirendListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureFirendListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("list/list_friend.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureFirendListCell:createCell()
	local cell = AdventureFirendListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
