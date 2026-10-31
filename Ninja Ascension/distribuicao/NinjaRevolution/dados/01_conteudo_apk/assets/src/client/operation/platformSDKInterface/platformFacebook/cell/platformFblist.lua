platformFblist = class("platformFblistClass", Window)

function platformFblist:ctor()
    self.super:ctor()
	self.roots = {}
	self.data = nil
    local function init_platform_fb_list_terminal()
		local platform_fb_list_lingqu_terminal = {
			_name = "platform_fb_list_lingqu",
			_init = function (terminal) 
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._cell
				local mouldId = dms.atos(cell.data,fb_share_reward.id)
				local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	state_machine.excute("main_window_update_userinfo", 0, nil)
                    	state_machine.excute("home_map_update_build", 0, nil)
                        state_machine.excute("platform_fb_list_update", 0, response.node)
                        state_machine.excute("notification_center_update", 0, "push_notification_facebook")
                    end
                end
                protocol_command.draw_fb_reward.param_list = mouldId
                NetworkManager:register(protocol_command.draw_fb_reward.code, nil, nil, nil, cell, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		local platform_Method_invite_friend_terminal = {
            _name = "platform_Method_invite_friend",
            _init = function (terminal)
            	app.load("client.operation.platformSDKInterface.platformFacebook.platformFbFriendInvite")
            	app.load("client.operation.platformSDKInterface.platformFacebook.cell.platformFbFriendCell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if m_my_fb_id == nil then
            		local targetPlatform = cc.Application:getInstance():getTargetPlatform()
            		if targetPlatform == cc.PLATFORM_OS_WINDOWS then
            			m_my_fb_id = "123456"
						state_machine.excute("platform_fb_login_command", 0, "platform_fb_login_command.")
            		else
            			handlePlatformRequest(0, CC_FACEBOOK_BE_INVITED, "")
            		end
            	else
	                fwin:open(ConnectingView:new(), fwin._windows)
	                if m_aladion_facebook_graph_path == "" or m_aladion_facebook_graph_path == nil then
	                    handlePlatformRequest(0, CC_FACEBOOK_FRIENDS_REQUEST, "")
	                    --添加facebook邀请请求的统计
	                    protocol_command.fb_launch.param_list = "0"
	                    NetworkManager:register(protocol_command.fb_launch.code, nil, nil, nil, nil, nil, false, nil)
	                else
	                    state_machine.excute("platform_fb_friend_invite_open", 0, "platform_fb_friend_invite_open.")
	                end
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		local platform_fb_dianzan_terminal = {
            _name = "platform_fb_dianzan",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
            	if m_my_fb_id == nil then
            		if targetPlatform == cc.PLATFORM_OS_WINDOWS then
            			m_my_fb_id = "123456"
						state_machine.excute("platform_fb_login_command", 0, "platform_fb_login_command.")
            		else
            			handlePlatformRequest(0, CC_FACEBOOK_BE_INVITED, "")
            		end
            	else
                	local function platformFun( )
                		state_machine.excute("platform_fb_goto_home_page" , 0, "") 
				    end
				    local function protocolFun()	
            			state_machine.excute("platform_fb_info_command",0,3)
				    end
            		instance:runAction(cc.Sequence:create(cc.CallFunc:create(platformFun), cc.DelayTime:create(2), cc.CallFunc:create(protocolFun)))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local platform_fb_share_terminal = {
            _name = "platform_fb_share",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
            	if m_my_fb_id == nil then
            		if targetPlatform == cc.PLATFORM_OS_WINDOWS then
            			m_my_fb_id = "123456"
						state_machine.excute("platform_fb_login_command", 0, "platform_fb_login_command.")
            		else
            			handlePlatformRequest(0, CC_FACEBOOK_BE_INVITED, "")
            		end
            	else
            		if targetPlatform == cc.PLATFORM_OS_WINDOWS then
            			state_machine.excute("platform_fb_info_command",0,5)
            		else
            			local index = math.random(1, #_face_book_share_pic_http_arry)
            			local share_str = nil
            			if targetPlatform == cc.PLATFORM_OS_ANDROID then
            				share_str = string.format(_face_book_share_str,_face_book_share_pic_http_arry[index],_face_book_share_android_http)
            			elseif cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
            				share_str = string.format(_face_book_share_str,_face_book_share_pic_http_arry[index],_face_book_share_ios_http)
            			end
               			handlePlatformRequest(0, CC_SHARE_REQUEST, share_str)
               		end
               	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local platform_fb_list_update_terminal = {
            _name = "platform_fb_list_update",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateButtonType(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(platform_fb_list_update_terminal)
        state_machine.add(platform_fb_share_terminal)
        state_machine.add(platform_Method_invite_friend_terminal)
        state_machine.add(platform_fb_dianzan_terminal)
		state_machine.add(platform_fb_list_lingqu_terminal)
        state_machine.init()
    end
	
    init_platform_fb_list_terminal()
end
function platformFblist:onUpdateButtonType( _cell )
	local root = _cell.roots[1]
	local Text_player_rs = ccui.Helper:seekWidgetByName(root, "Text_player_rs")
	local Button_lingqu = ccui.Helper:seekWidgetByName(root, "Button_lingqu")
	local Text_Claimed = ccui.Helper:seekWidgetByName(root, "Text_Claimed")
	local Button_yaoqing = ccui.Helper:seekWidgetByName(root, "Button_yaoqing")
	local Button_dianzan = ccui.Helper:seekWidgetByName(root, "Button_dianzan")
	local Button_share = ccui.Helper:seekWidgetByName(root, "Button_share")
	local Text_cannot_collect = ccui.Helper:seekWidgetByName(root, "Text_cannot_collect")
	--按钮
	Button_lingqu:setVisible(false)
	Text_Claimed:setVisible(false)
	Button_yaoqing:setVisible(false)
	Button_dianzan:setVisible(false)
	Button_share:setVisible(false)
	Text_cannot_collect:setVisible(false)
	local curr_mouldID = dms.atos(_cell.data,fb_share_reward.id)
	local curr_state = _ED.redAlertTime_fb_info[curr_mouldID]
	if tonumber(curr_state.reward_state) == 2 then    --已领取
		Text_Claimed:setVisible(true)
	elseif tonumber(curr_state.reward_state) == 1 then --已完成
		Button_lingqu:setVisible(true)
	else
		-- 2 每日邀请 ，3点赞 ， 4被邀请 ， 1成功邀请人数 ，5分享
		local curr_type = dms.atoi(_cell.data,fb_share_reward.list_type)
		if curr_type == 2 or curr_type == 1 then
			Button_yaoqing:setVisible(true)
		elseif curr_type == 3 then
			Button_dianzan:setVisible(true)
		elseif curr_type == 4 then
			Text_cannot_collect:setVisible(true)
		elseif curr_type == 5 then
			Button_share:setVisible(true)
		end
	end
	local need_progress = dms.atoi(_cell.data,fb_share_reward.need_progress)
	if need_progress == -1 then
		Text_player_rs:setString("")
	else
		local curr_progress = math.min(curr_state.completeProgress, need_progress)
		Text_player_rs:setString("("..curr_progress.."/"..need_progress..")")
		if curr_progress < need_progress then
			Text_player_rs:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
		else
			Text_player_rs:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
		end
	end
end

function platformFblist:onUpdateDraw()
	local root = self.roots[1]
	local Text_ms = ccui.Helper:seekWidgetByName(root, "Text_ms")
	local ListView_jiangli = ccui.Helper:seekWidgetByName(root, "ListView_jiangli")
	--文本
	Text_ms:setString(dms.atos(self.data,fb_share_reward.name))
	
	ListView_jiangli:removeAllItems()
	local reward_info = zstring.split(dms.atos(self.data,fb_share_reward.rewards_info) ,"|")
	for i = 1, #reward_info do
		local datas = zstring.split(reward_info[i] ,",")
		local prop_type = tonumber(datas[2])
		local show_type = 6
		local prop_from_type = 3
		if tonumber(datas[2]) == 13 then --坦克
			prop_type = 3
			prop_from_type = 10
		elseif tonumber(datas[2]) == 6 then --道具	
			prop_type = 1
			prop_from_type = 1
		elseif tonumber(datas[2]) == 7 then --配件	
			prop_type = 7
			prop_from_type = 3
		else
			prop_type = 1
			prop_from_type = 1
		end
		local cell = nil

		cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})  
        ListView_jiangli:addChild(cell)
	end
	self:onUpdateButtonType(self)
end

function platformFblist:onEnterTransitionFinish()
	local csbCharacterCreateChooseCell = csb.createNode(config_csb.abroad.list_jiangli)
	local root = csbCharacterCreateChooseCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
		
	local Panel_5 = ccui.Helper:seekWidgetByName(root, "Panel_5")
	self:setContentSize(Panel_5:getContentSize())
	--领奖
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lingqu"), nil, 
		{
			terminal_name = "platform_fb_list_lingqu", 
			terminal_state = 0,
			_cell = self,
			isPressedActionEnabled = true 
		},
		nil,0)
	--邀请
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yaoqing"), nil, 
        {
            terminal_name = "platform_Method_invite_friend",
            terminal_state = 0,
            status = false,
            isPressedActionEnabled = true
        },
        nil,0)
	--点赞
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_dianzan"),nil,
        {
            terminal_name = "platform_fb_dianzan",
            terminal_state = 0,
            status = false,
            isPressedActionEnabled = true
        },
        nil,0)
    --分享
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_share"),nil,
        {
            terminal_name = "platform_fb_share",
            terminal_state = 0,
            status = false,
            isPressedActionEnabled = true
        },
        nil,0)  	
	self:onUpdateDraw()
end

function platformFblist:onExit()
	state_machine.remove("platform_fb_list_lingqu")
	state_machine.remove("platform_Method_invite_friend")
	state_machine.remove("platform_fb_dianzan")
	state_machine.remove("platform_fb_share")
	state_machine.remove("platform_fb_list_update")
end

function platformFblist:init(_data)
	self.data = _data
end

function platformFblist:createCell()
	local cell = platformFblist:new()
	cell:registerOnNodeEvent(cell)
	return cell
end