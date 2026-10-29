-- ----------------------------------------------------------------------------------------------------
-- 说明：好友搜索
-------------------------------------------------------------------------------------------------------
AdventureFriendSearch = class("AdventureFriendSearchClass", Window)
    
function AdventureFriendSearch:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize adventure friend search state machine.
    local function init_adventure_friend_search_terminal()
    	--关闭
		local adventure_friend_search_close_terminal = {
            _name = "adventure_friend_search_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 清空搜索到的好友列表
        local adventure_friend_clean_search_find_terminal = {
            _name = "adventure_friend_clean_search_find",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self:updateCleanListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--搜索
		local adventure_friend_search_search_terminal = {
            _name = "adventure_friend_search_search",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local input_box = params._datas.input_editbox
                local friend_list = params._datas.friend_list
				
				if input_box:getString() == nil or input_box:getString() == "" then
				else
					local function recruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            self:updateSearchFriendString("")
                            self:updateListView()
                        else
                            self:updateSearchFriendString(_string_piece_info[394])
						end
					end
					protocol_command.search_user.param_list = _ED.user_info.user_id .. "\r\n" .. input_box:getString()
					NetworkManager:register(protocol_command.search_user.code, nil, nil, nil, nil, recruitCallBack, false, nil)
				end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
				
		state_machine.add(adventure_friend_search_close_terminal)
		state_machine.add(adventure_friend_search_search_terminal)
        state_machine.add(adventure_friend_clean_search_find_terminal)

        state_machine.init()
    end
    
    -- call func init adventure friend search state machine.
    init_adventure_friend_search_terminal()
end

function AdventureFriendSearch:init()

end

function AdventureFriendSearch:onEnterTransitionFinish()
	local csbFriendSearch = csb.createNode("friend/friend_search.csb")
    local root = csbFriendSearch:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbFriendSearch)

    local inputBox = ccui.Helper:seekWidgetByName(root, "TextField_player")
	draw:addEditBox(inputBox, _string_piece_info[341], "effect/effice_1500.png", nil, 16, cc.KEYBOARD_RETURNTYPE_DONE)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
    	terminal_name = "adventure_friend_search_close", 
    	terminal_state = 0, 
    	isPressedActionEnabled = true
    }, 
    nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_search"), nil, 
	{
		terminal_name = "adventure_friend_search_search", 
		terminal_state = 0, 
		input_editbox = inputBox,
        friend_list = friendList,
		isPressedActionEnabled = true
	}, 
	nil, 0)
    ccui.Helper:seekWidgetByName(root, "Text_shousuo"):setString(_string_piece_info[393]) 
end

function AdventureFriendSearch:updateSearchFriendString(text)
    local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Text_shousuo"):setString(text)
    
end
function AdventureFriendSearch:updateListView()
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_friend")

    listView:removeAllItems()
    if #_ED.friend_find > 0 then
    local cell = AdventureFirendApplyListCell:createCell()
        cell:init(_ED.friend_find[1], 1, 2)
        listView:addChild(cell)
    end
    
    listView:requestRefreshView()
end
function AdventureFriendSearch:updateCleanListView()
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_friend")

    listView:removeAllItems()
    listView:requestRefreshView()
    
end

function AdventureFriendSearch:onExit()
	state_machine.remove("adventure_friend_search_close")
	state_machine.remove("adventure_friend_search_search")
end