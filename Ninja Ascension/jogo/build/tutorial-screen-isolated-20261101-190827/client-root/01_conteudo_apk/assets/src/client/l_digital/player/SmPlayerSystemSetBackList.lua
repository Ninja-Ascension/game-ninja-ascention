-- ----------------------------------------------------------------------------------------------------
-- 说明：数码系统黑名单
-------------------------------------------------------------------------------------------------------
SmPlayerSystemSetBackList = class("SmPlayerSystemSetBackListClass", Window)
local sm_playersystem_set_backList_open_terminal = {
    _name = "sm_playersystem_set_backList_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local _window = fwin:find("SmPlayerSystemSetBackListClass")
        if _window == nil then
            fwin:open(SmPlayerSystemSetBackList:new(),fwin._ui)
        end
    	return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_playersystem_set_backList_open_terminal)
state_machine.init()
    
function SmPlayerSystemSetBackList:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
    app.load("client.l_digital.cells.player.player_system_set_back_list_cell")
	
    local function init_sm_playersystem_set_backList_terminal()
        
        --移除
        local sm_playersystem_set_backList_remove_terminal = {
            _name = "sm_playersystem_set_backList_remove",
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

        --关闭
        local sm_playersystem_set_backList_close_terminal = {
            _name = "sm_playersystem_set_backList_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 恢复好友后刷新好友数据
                NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, instance, nil, false, nil)
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sm_playersystem_set_backList_get_random_name_terminal)
		state_machine.add(sm_playersystem_set_backList_remove_terminal)
        state_machine.add(sm_playersystem_set_backList_close_terminal)
        state_machine.init()
    end
    
    init_sm_playersystem_set_backList_terminal()
end

function SmPlayerSystemSetBackList:checkDel(_id)
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_blacklist")
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

function SmPlayerSystemSetBackList:onUpdataDraw()
	local root = self.roots[1]
	local ListView_blacklist = ccui.Helper:seekWidgetByName(root, "ListView_blacklist")
    ListView_blacklist:removeAllItems()
    if tonumber(_ED.black_user_num) > 0 then
        for i=1, tonumber(_ED.black_user_num) do
            local friendInfo = {
                user_id = _ED.black_user[i].user_id,
                vip_grade = _ED.black_user[i].vip_grade,
                lead_mould_id = _ED.black_user[i].lead_mould_id,
                title = _ED.black_user[i].title,
                name = _ED.black_user[i].name,
                grade = _ED.black_user[i].grade,
                fighting  = _ED.black_user[i].fighting,
                army = _ED.black_user[i].army,
                leave_time =_ED.black_user[i].leave_time,
            }
			-- 新增头像框
            local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
            if fun_is_open == true then
				friendInfo.headFrameID = _ED.black_user[i].headFrameID
				friendInfo.headFrameStage = _ED.black_user[i].headFrameStage
			end
            local cell = PlayerSystemSetBackListCell:createCell()
            cell:init(friendInfo)
            ListView_blacklist:addChild(cell)
        end
        ListView_blacklist:requestRefreshView()
    end
end

function SmPlayerSystemSetBackList:onEnterTransitionFinish()
	local csbUserInfo = csb.createNode("player/role_information_blacklist.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)


    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"),nil, 
    {
        terminal_name = "sm_playersystem_set_backList_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

	self:onUpdataDraw()
end

function SmPlayerSystemSetBackList:onExit()
    state_machine.remove("sm_playersystem_set_backList_remove")
    state_machine.remove("sm_playersystem_set_backList_close")
end
