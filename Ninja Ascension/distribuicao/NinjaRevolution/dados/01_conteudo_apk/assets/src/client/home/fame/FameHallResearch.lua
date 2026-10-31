-- ----------------------------------------------------------------------------------------------------
-- 说明：名人堂留言
-- 创建时间	2015.4.27
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FameHallResearch = class("FameHallResearchClass", Window)
    
function FameHallResearch:ctor()
    self.super:ctor()
    self.roots = {}
	self.action = nil
	app.load("client.home.fame.FameHallList")
	
    -- Initialize FameHall page state machine.
    local function init_fame_hall_research_terminal()
		
		local fame_hall_research_close_terminal = {
            _name = "fame_hall_research_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance.action:play("window_close",false)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local fame_hall_research_ok_terminal = {
            _name = "fame_hall_research_ok",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local user_message = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_2"):getString()
				local function responseStartCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							response.node.action:play("window_close",false)
							fwin:close(response.node)
							TipDlg.drawTextDailog(_string_piece_info[313])
							
							-- 遍历下 数据 ,发现存在自己就更新
							-- for i = 1, tonumber(_ED.celebrity_num) do
								-- -- local celebrity_info = {
									-- -- user_id = npos(list),
									-- -- user_name = npos(list),
									-- -- user_fighting = npos(list),
									-- -- user_ranking = npos(list),
									-- -- user_level = npos(list),
									-- -- user_star_num = npos(list),
									-- -- user_message = npos(list),
									-- -- pic_index = npos(list),
								-- -- }
								-- -- _ED.celebrity_info[i] = celebrity_info
								
								-- local item = _ED.celebrity_info[i]
								
								-- if tonumber(item.user_id) == tonumber(_ED.user_info.user_id) then
									-- item.user_message = user_message
									
									-- _ED.celebrity_info[i] = item
									
									-- -- 发布 消息 去更新 
									
									-- break
								-- end
								
							-- end
							
							-- 发布 消息 去更新 
							state_machine.excute("fame_hall_update_user_message", 0, 0)
						end
							
					end
				end
				if user_message == "" then
					protocol_command.celebrity_leave_msg.param_list = " "
					NetworkManager:register(protocol_command.celebrity_leave_msg.code, nil, nil, nil, instance, responseStartCallback, false, nil)
				else
					protocol_command.celebrity_leave_msg.param_list = user_message
					NetworkManager:register(protocol_command.celebrity_leave_msg.code, nil, nil, nil, instance, responseStartCallback, false, nil)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(fame_hall_research_ok_terminal)
		state_machine.add(fame_hall_research_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_fame_hall_research_terminal()
end

function FameHallResearch:onEnterTransitionFinish()
	local csbFameHallHead = csb.createNode("system/famous_modify_messages.csb")
	self:addChild(csbFameHallHead)
	local root = csbFameHallHead:getChildByName("root")
	table.insert(self.roots, root)
	local action = csb.createTimeline("system/famous_modify_messages.csb")
    csbFameHallHead:runAction(action)
	self.action = action
	action:play("window_open",false)
	local roleName = ccui.Helper:seekWidgetByName(root, "TextField_2")
	draw:addEditBox(roleName, _string_piece_info[342], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_510_0"), 120, cc.KEYBOARD_RETURNTYPE_DONE)
	local Button_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_510"), nil, {terminal_name = "fame_hall_research_close", terminal_state = 0,isPressedActionEnabled = true}, nil, 2)
	local Button_3 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_510_0"), nil, {terminal_name = "fame_hall_research_ok", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	Button_2:setSwallowTouches(false)
	Button_3:setSwallowTouches(false)
end

function FameHallResearch:onExit()
	state_machine.remove("fame_hall_research_ok")
	state_machine.remove("fame_hall_research_close")
end

