-- ----------------------------------------------------------------------------------------------------
-- 说明：邀请好友
-------------------------------------------------------------------------------------------------------
ActivityInviteFriend = class("ActivityInviteFriendClass", Window)
    
function ActivityInviteFriend:ctor()
    self.super:ctor()
	self.roots = {}
	self.loaded = false
	self._inviteEdit = nil --邀请码输入框

	app.load("client.cells.activity.activity_invite_friend_list_cell")
    -- Initialize ActivityInviteFriend state machine.
    local function init_activity_invite_friend_terminal()
		-- 复制
        local activity_invite_friend_copy_terminal = {
            _name = "activity_invite_friend_copy",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance ~= nil and instance.onUpdateDraw ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
					instance.loaded = true
					instance:onUpdateDraw()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --分享
        local activity_invite_friend_share_terminal = {
            _name = "activity_invite_friend_share",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --确定邀请码
        local activity_invite_friend_invite_ok_terminal = {
            _name = "activity_invite_friend_invite_ok",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local target = params._datas._self
            	local inviteString = target._inviteEdit:getString()
            	if inviteString == nil or "" then 
            		TipDlg.drawTextDailog(_string_piece_info[315])
            		return
            	end
            	local roleName = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_create_character_name")
                local roleNameTextFieldString = roleName:getString()
				local function responseBoxRewardCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            --response.node:onUpdateDraw()
                        end
                    end
                end
                protocol_command.share_write_invite_key.param_list = inviteString
                NetworkManager:register(protocol_command.share_write_invite_key.code, nil, nil, nil, instance, responseBoxRewardCallBack, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(activity_invite_friend_copy_terminal)
        state_machine.add(activity_invite_friend_share_terminal)
        state_machine.add(activity_invite_friend_invite_ok_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityInviteFriend state machine.
    init_activity_invite_friend_terminal()
    
    self._load_over = false
	self:onLoad()
end

function ActivityInviteFriend:onUpdateDrawData( ... )
	self.loaded = true
	self:onUpdateDraw()
end

function ActivityInviteFriend:onUpdateDraw()
	if self.loaded == false then
		return
	end

	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	listView:removeAllItems()
	for i=1,2 do
		local cell = ActivityInviteFriendListCell:createCell()
		cell:init()
		listView:addChild(cell)
	end
	listView:requestRefreshView()
end

function ActivityInviteFriend:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
 	self:onInit()
end

function ActivityInviteFriend:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
end

function ActivityInviteFriend:onEnterTransitionFinish()

end

function ActivityInviteFriend.onImageLoaded(texture)
	
end

function ActivityInviteFriend:onArmatureDataLoad(percent)
	
end

function ActivityInviteFriend:onArmatureDataLoadEx(percent)

end

function ActivityInviteFriend:onLoad()

end

function ActivityInviteFriend:onInit()
	local csbMonthCard = csb.createNode("activity/wonderful/invite_friend.csb")
    local root = csbMonthCard:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbMonthCard)
	
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self, false)
	
	local roleName = ccui.Helper:seekWidgetByName(root, "TextField_input")
    draw:addEditBox(roleName, _string_piece_info[341], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_4"), 16, cc.KEYBOARD_RETURNTYPE_DONE)     
    
	--复制
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_copy"), nil, 
	{
		terminal_name = "activity_invite_friend_copy", 
		terminal_state = 0, 
		ptype = 1,
		_cell = self,
		isPressedActionEnabled = true
	},
	nil,0)

	--分享
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share"), nil, 
	{
		terminal_name = "activity_invite_friend_share", 
		terminal_state = 0,
		_cell = self,
		isPressedActionEnabled = true
	},
	nil,0)

	--输入邀请码确定
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, 
	{
		terminal_name = "activity_invite_friend_invite_ok", 
		terminal_state = 0,
		_cell = self,
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)
end

function ActivityInviteFriend:onExit()
	
end

function ActivityInviteFriend:init()

end

function ActivityInviteFriend:createCell()
	local cell = ActivityInviteFriend:new()
	cell:registerOnNodeEvent(cell)
	return cell
end