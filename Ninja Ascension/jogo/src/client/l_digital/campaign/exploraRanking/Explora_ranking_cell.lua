--------------------------------------------------------------------------------------------------------------
--  说明：探索排行榜cell
--------------------------------------------------------------------------------------------------------------
explora_ranking_cell = class("explora_ranking_cellClass", Window)
explora_ranking_cell.__size = nil

--创建cell
local explora_ranking_cell_terminal = {
    _name = "explora_ranking_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = explora_ranking_cell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(explora_ranking_cell_terminal)
state_machine.init()

function explora_ranking_cell:ctor()
	self.super:ctor()
	self.roots = {}

     local function init_explore_ranking_information_cell_terminal()
        local explore_ranking_ranking_information_cell_check_terminal = {
            _name = "explore_ranking_ranking_information_cell_check",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
                app.load("client.l_digital.union.create.SmUnionInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cells = params._datas.cells
                if not cells.activity.name then
                    return false
                end
                    local function responseShowUserInfoCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                local datainfo = response.node.activity
                                datainfo.icon = response.node.activity.headid
                                datainfo.name = response.node.activity.name
                                datainfo.level = _ED.chat_user_info.grade
                                datainfo.rank = response.node.activity.ranking
                                datainfo.force = _ED.chat_user_info.fighting
                                datainfo.vip = _ED.chat_user_info.vip_grade
                                datainfo.template = {}
                                datainfo.template[1] = _ED.chat_user_info.formation
                                if _ED.chat_user_info.army == "" then
                                    datainfo.arame = "?"
                                else
                                    datainfo.arame = _ED.chat_user_info.army
                                end
                                state_machine.excute("sm_arena_player_info_window_open",0,datainfo)
                            end
                        end
                    end
                    protocol_command.see_user_info.param_list = cells.activity.userid
                    NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, cells, responseShowUserInfoCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(explore_ranking_ranking_information_cell_check_terminal) 
        state_machine.init()
    end 
    init_explore_ranking_information_cell_terminal()
end

function explora_ranking_cell:updateDrawInfo()
    local root = self.roots[1]
    local Text_loke_on_st = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_st") --排名
    local Panel_jjc_ph_st = ccui.Helper:seekWidgetByName(root, "Panel_jjc_ph_st") --排名
    if tonumber(self.activity.ranking) ==1 or  tonumber(self.activity.ranking) == 2 or  tonumber(self.activity.ranking) == 3 then
       Panel_jjc_ph_st:setVisible(true)
       Panel_jjc_ph_st:setBackGroundImage("images/ui/play/arena/jjc_phb_pic_"..self.activity.ranking..".png")
    else
       Panel_jjc_ph_st:setVisible(false)
       Text_loke_on_st:setString(self.activity.ranking)
    end
    
    local Text_loke_on_0 = ccui.Helper:seekWidgetByName(root, "Text_ghm")   --公会名
    if self.activity.unionname then
       Text_loke_on_0:setString(self.activity.unionname)
    end
   
    local Text_loke_on = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_name")   --name
    Text_loke_on:setString(self.activity.name)

    local Text_loke_on_1 = ccui.Helper:seekWidgetByName(root, "Text_7")   --积分
    Text_loke_on_1:setString(self.activity.score)
   
end

function explora_ranking_cell:onUpdate(dt)
    
end

function explora_ranking_cell:onInit()
    local root = cacher.createUIRef("campaign/exploration/exploration_event_ranking_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if explora_ranking_cell.__size == nil then
        explora_ranking_cell.__size = ccui.Helper:seekWidgetByName(root, "Panel_jjc_ph_list"):getContentSize()
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_jjc_ph_list"), nil, 
    {
        terminal_name = "explore_ranking_ranking_information_cell_check", 
        terminal_state = 0, 
        touch_black = true,
        cells = self,
    }, nil, 1)

    self:clearUIInfo()
	self:updateDrawInfo()
end

function explora_ranking_cell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function explora_ranking_cell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_loke_on_st = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_st")  --排名
    local Text_loke_on = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_name") --name
    local Text_loke_on_0 = ccui.Helper:seekWidgetByName(root, "Text_ghm")  --工会名
    local Text_loke_on_1 = ccui.Helper:seekWidgetByName(root, "Text_7")    --积分
    
    
  
    local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_jjc_ph_role") --头像
    if Panel_2 ~= nil then
        Panel_2:removeAllChildren(true)
        Text_loke_on_st:setString("")
        Text_loke_on:setString("")
        Text_loke_on_1:setString("")
        
        fwin:removeTouchEventListener(Panel_2)
    end
end

function explora_ranking_cell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function explora_ranking_cell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/exploration/exploration_event_ranking_cell.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function explora_ranking_cell:init(params)
    self.activity = params[1]
	self:onInit()
    self:setContentSize(explora_ranking_cell.__size)
    return self
end

function explora_ranking_cell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/exploration/exploration_event_ranking_cell.csb", self.roots[1])
end