-- ----------------------------------------------------------------------------------------------------
-- 说明：讨论区
-------------------------------------------------------------------------------------------------------
AdventureForums = class("AdventureForumsClass", Window)
    
function AdventureForums:ctor()
    self.super:ctor()
    self.roots = {}
	self.index = 1
	app.load("client.adventure.chat.AdventureChatSayOtherCell")
    -- Initialize adventure forums state machine.
    local function init_adventure_forums_terminal()
    	-- 页面多窗口管理器
    	local adventure_forums_manager_terminal = {
            _name = "adventure_forums_manager",
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

    	-- 讨论区
    	local adventure_forums_message_terminal = {
            _name = "adventure_forums_message",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.index = 1
				self:onUpdateDrawList()
                -- TipDlg.drawTextDailog("讨论区：未实现。")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

    	-- 与我相关
    	local adventure_forums_myself_message_terminal = {
            _name = "adventure_forums_myself_message",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.index = 2
				self:onUpdateDrawList()
                -- TipDlg.drawTextDailog("与我相关：未实现。")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

    	-- 发起讨论
    	local adventure_forums_launch_terminal = {
            _name = "adventure_forums_launch",
            _init = function (terminal)
            	app.load("client.adventure.system.forums.AdventureLaunchForums")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureLaunchForums:new():init(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_forums_manager_terminal)
        state_machine.add(adventure_forums_message_terminal)
        state_machine.add(adventure_forums_myself_message_terminal)
        state_machine.add(adventure_forums_launch_terminal)
        state_machine.init()
    end
    
    -- call func init adventure forums state machine.
    init_adventure_forums_terminal()
end

function AdventureForums:init()
	return self
end

function AdventureForums:onUpdateDrawList()
	local root = self.roots[1]
	local myListViewOne = ccui.Helper:seekWidgetByName(root, "ListView_discuss")
	local myListViewTwo = ccui.Helper:seekWidgetByName(root, "ListView_with_me")
	local button_one =ccui.Helper:seekWidgetByName(root, "Button_discuss")
	local button_two =ccui.Helper:seekWidgetByName(root, "Button_me")
	if tonumber(self.index) == 1 then
		myListViewOne:removeAllItems()
		button_one:setTouchEnabled(false)
		button_one:setHighlighted(true)
        button_one:setColor(cc.c3b(255, 255, 255))
        button_two:setColor(cc.c3b(150, 150, 150))
		button_two:setTouchEnabled(true)
		button_two:setHighlighted(false)
		myListViewOne:setVisible(true)
		myListViewTwo:setVisible(false)
        -- 修改层级关系
        button_one:getParent():reorderChild(button_one, 10)
        button_two:getParent():reorderChild(button_two, 0)
		local function responseSendMessage2Callback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --debug.print_r(_ED.send_information)
                myListViewOne:removeAllItems()
                local items = {}
                
				for i,v in pairs(_ED.send_information) do
					if tonumber(v.send_information_id) ~= 0 and  tonumber(v.information_type) == 1 then
						local cell = AdventureChatSayOtherCell:createCell()
                        cell._refresh_time = v.last_update
						cell:init(v)
                        table.insert(items,cell)
						--myListViewOne:addChild(cell)		
					end
				end	
                local sortFunc = function( cell1, cell2 )
                    return cell2._refresh_time < cell1._refresh_time
                end

                table.sort(items, sortFunc)

                for k,d in pairs(items) do
                    myListViewOne:addChild(d)        
                end
                myListViewOne:requestRefreshView()
			end
		end
		NetworkManager:register(protocol_command.refush_msg.code, nil, nil, nil, nil, responseSendMessage2Callback, false, nil)
	else
		myListViewTwo:removeAllItems()
		button_one:setTouchEnabled(true)
		button_one:setHighlighted(false)
        button_one:setColor(cc.c3b(150, 150, 150))
        button_two:setColor(cc.c3b(255, 255, 255))
		button_two:setTouchEnabled(false)
		button_two:setHighlighted(true)
		myListViewOne:setVisible(false)
		myListViewTwo:setVisible(true)
        -- 修改层级关系
        button_two:getParent():reorderChild(button_two, 10)
        button_one:getParent():reorderChild(button_one, 0)
		
		local function responseSendMessage3Callback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                myListViewTwo:removeAllItems()
                local items = {}
				for i,v in pairs(_ED.send_information) do
					if tonumber(v.send_information_id) == tonumber(_ED.user_info.user_id) and  tonumber(v.information_type) == 1 then
						local cell = AdventureChatSayOtherCell:createCell()
						cell:init(v)
                        cell._refresh_time = v.last_update
						table.insert(items,cell)
						
					end
				end	
                local sortFunc = function( cell1, cell2 )
                    return cell2._refresh_time < cell1._refresh_time
                end

                table.sort(items, sortFunc)
                for k,d in pairs(items) do
                    myListViewTwo:addChild(d)        
                end
                myListViewTwo:requestRefreshView()
			end
		end
		NetworkManager:register(protocol_command.show_self_message.code, nil, nil, nil, nil, responseSendMessage3Callback, false, nil)
		
	end
end

function AdventureForums:onUpdateDraw()
	local root = self.roots[1]
	self:onUpdateDrawList()
end

function AdventureForums:onEnterTransitionFinish()
    local csbAdventureForums = csb.createNode("Chat/discussion.csb")
    local root = csbAdventureForums:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureForums)
	self:onUpdateDraw()
    -- 讨论区
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_discuss"),       nil, 
    {
		terminal_name = "adventure_forums_message",        
		terminal_state = 0, 
		isPressedActionEnabled = true
    },   nil, 2)

    -- 与我相关
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_me"),       nil, 
    {
		terminal_name = "adventure_forums_myself_message",        
		terminal_state = 0, 
		isPressedActionEnabled = true
    },  nil, 2)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
		terminal_name = "menu_manager",     
		next_terminal_name = "menu_show_home_page", 
		current_button_name = "Button_daditu",
		but_image = "Image_daditu",         
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 发起讨论
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhao"),       nil, 
    {
		terminal_name = "adventure_forums_launch",        
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureForums:onExit()
    -- state_machine.remove("adventure_forums_manager")
    -- state_machine.remove("adventure_forums_message")
    -- state_machine.remove("adventure_forums_myself_message")
    -- state_machine.remove("adventure_forums_launch")
end