--------------------------------------------------------------------------------------------------------------
--  说明：节日红包小排行榜cell
--------------------------------------------------------------------------------------------------------------
world_boss_ranking_cell = class("world_boss_ranking_cellClass", Window)
world_boss_ranking_cell.__size = nil

--创建cell
local world_boss_ranking_cell_terminal = {
    _name = "world_boss_ranking_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = world_boss_ranking_cell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(world_boss_ranking_cell_terminal)
state_machine.init()

function world_boss_ranking_cell:ctor()
	self.super:ctor()
	self.roots = {}
    self.activity = {}
    
    app.load("client.l_digital.union.create.SmUnionInfoWindow")
    app.load("client.l_digital.cells.union.union_logo_icon_cell")

    local function init_union_npc_membership_progress_list_cell_terminal()

        local world_boss_ranking_cell_see_user_terminal = {
            _name = "world_boss_ranking_cell_see_user",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local userInfo = params._datas.userInfo
            	local cell = params._datas.cell
                local type = params._datas.type
				-- DSC统一玩家详情界面
                if __lua_project_id == __lua_project_l_digital then
                    if type == 1 then
                        local userID = userInfo.userId
                        OpenOtherUserInformation(userID, nil, nil)
                    else
                        local unionId = userInfo.unionId
                        local function responseShowUnionInfoCallBack(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                _ED.union_see_info.union_kuang = 1
                                state_machine.excute("sm_union_info_window_window_open", 0, _ED.union_see_info)
                            end
                        end
                        protocol_command.see_union_info.param_list = unionId
                        NetworkManager:register(protocol_command.see_union_info.code, nil, nil, nil, cell, responseShowUnionInfoCallBack, false, nil)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(world_boss_ranking_cell_see_user_terminal)
        state_machine.init()
    end
    init_union_npc_membership_progress_list_cell_terminal()
end

function world_boss_ranking_cell:updateDrawInfo()
    if not self.activity then
        return
    end
    local root = self.roots[1]
  
    local Text_boss_rank_player_name = ccui.Helper:seekWidgetByName(root, "Text_boss_rank_player_name") --name
    
    local Text_boss_rank_player_rank = ccui.Helper:seekWidgetByName(root, "Text_boss_rank_player_rank") --排名
    Text_boss_rank_player_rank:setString(self.ranking)
    local Panel_top_rank = ccui.Helper:seekWidgetByName(root, "Panel_top_rank") --排名
    Panel_top_rank:removeBackGroundImage()
    if tonumber(self.ranking) <=3  then
       Panel_top_rank:setBackGroundImage(string.format("images/ui/text/GHZ_res/gh_rank_%d.png", self.ranking))
    end
    
    local Text_boss_rank_player_hurt = ccui.Helper:seekWidgetByName(root, "Text_boss_rank_player_hurt")   --伤害
    Text_boss_rank_player_hurt:setString(self.activity.score)
    if self.types == 1 then
       Text_boss_rank_player_name:setString(self.activity.nickName)
    else
       Text_boss_rank_player_name:setString(self.activity.unionName)
    end 
   
end

function world_boss_ranking_cell:onUpdate(dt)
    
end

function world_boss_ranking_cell:onInit()
    local root = cacher.createUIRef("campaign/world_boss/world_boss_rank_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if world_boss_ranking_cell.__size == nil then
        world_boss_ranking_cell.__size = root:getContentSize()
    end
    
    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "world_boss_ranking_cell_see_user",
        terminal_state = 0,
        userInfo = self.activity,
        type = self.types,
        cell = self
    },
    nil,0)
    self:clearUIInfo()
	self:updateDrawInfo()
end

function world_boss_ranking_cell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function world_boss_ranking_cell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_boss_rank_player_rank = ccui.Helper:seekWidgetByName(root, "Text_boss_rank_player_rank")
    local Text_boss_rank_player_name = ccui.Helper:seekWidgetByName(root, "Text_boss_rank_player_name")
    local Text_boss_rank_player_hurt = ccui.Helper:seekWidgetByName(root, "Text_boss_rank_player_hurt") 
    local Panel_top_rank = ccui.Helper:seekWidgetByName(root, "Panel_top_rank") 
    if Panel_top_rank then
        Panel_top_rank:removeAllChildren(true)
        Text_boss_rank_player_rank:setString("")
        Text_boss_rank_player_name:setString("")
        Text_boss_rank_player_hurt:setString("")
    end
end

function world_boss_ranking_cell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function world_boss_ranking_cell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef("campaign/world_boss/world_boss_rank_cell.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function world_boss_ranking_cell:init(params)
    self.activity = params[1]
    self.ranking =  params[2]
    self.types =  params[3]
	self:onInit()
    self:setContentSize(world_boss_ranking_cell.__size)
    return self
end

function world_boss_ranking_cell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/world_boss/world_boss_rank_cell.csb", self.roots[1])
end