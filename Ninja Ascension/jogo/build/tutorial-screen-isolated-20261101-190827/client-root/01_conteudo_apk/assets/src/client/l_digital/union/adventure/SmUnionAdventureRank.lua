-- ----------------------------------------------------------------------------------------------------
-- 说明：公会大冒险排行
-------------------------------------------------------------------------------------------------------
SmUnionAdventureRank = class("SmUnionAdventureRankClass", Window)

local sm_union_adventure_rank_open_terminal = {
    _name = "sm_union_adventure_rank_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionAdventureRankClass")
        if nil == _homeWindow then
            local panel = SmUnionAdventureRank:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_adventure_rank_close_terminal = {
    _name = "sm_union_adventure_rank_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionAdventureRankClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionAdventureRankClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_adventure_rank_open_terminal)
state_machine.add(sm_union_adventure_rank_close_terminal)
state_machine.init()
    
function SmUnionAdventureRank:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.starting_point = 1
    self.end_point = 10
    self.isOver = false
    app.load("client.l_digital.cells.union.adventure.union_adventure_rank_list_cell")

    local function init_sm_union_adventure_rank_terminal()
        -- 显示界面
        local sm_union_adventure_rank_display_terminal = {
            _name = "sm_union_adventure_rank_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionAdventureRankWindow = fwin:find("SmUnionAdventureRankClass")
                if SmUnionAdventureRankWindow ~= nil then
                    SmUnionAdventureRankWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_adventure_rank_hide_terminal = {
            _name = "sm_union_adventure_rank_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionAdventureRankWindow = fwin:find("SmUnionAdventureRankClass")
                if SmUnionAdventureRankWindow ~= nil then
                    SmUnionAdventureRankWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 
        local sm_union_adventure_rank_open_rank_terminal = {
            _name = "sm_union_adventure_rank_open_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.isOver == false then
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            instance.starting_point = instance.starting_point+10
                            instance.end_point = instance.end_point+10
                            instance:addnewlistCell()
                        end
                    end
                    protocol_command.order_get_info.param_list = "6".."\r\n"..(instance.starting_point+10).."\r\n"..(instance.end_point+10)
                    NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_adventure_rank_display_terminal)
        state_machine.add(sm_union_adventure_rank_hide_terminal)
        state_machine.add(sm_union_adventure_rank_open_rank_terminal)
        state_machine.init()
    end
    init_sm_union_adventure_rank_terminal()
end

function SmUnionAdventureRank:addnewlistCell()
    local root = self.roots[1]
    local ListView_rank_list = ccui.Helper:seekWidgetByName(root, "ListView_rank_list")
    for i= self.starting_point,self.end_point do
        if _ED.union_stick_crazy_adventure_progress_rank.other_user[i] ~= nil then
            local cell = state_machine.excute("union_adventure_rank_list_cell_creat",0,{_ED.union_stick_crazy_adventure_progress_rank.other_user[i],i})
            ListView_rank_list:addChild(cell)
        else
            self.isOver = true
        end
    end
    ListView_rank_list:requestRefreshView()
end

function SmUnionAdventureRank:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local ListView_rank_list = ccui.Helper:seekWidgetByName(root,"ListView_rank_list")
    ListView_rank_list:removeAllItems()
    self.starting_point = 1
    self.end_point = 10
    self.isOver = false
    for i, v in ipairs(_ED.union_stick_crazy_adventure_progress_rank.other_user) do 
        local cell = state_machine.excute("union_adventure_rank_list_cell_creat",0,{v,i})
        ListView_rank_list:addChild(cell)
    end
    ListView_rank_list:requestRefreshView()
    if #_ED.union_stick_crazy_adventure_progress_rank.other_user > 0 then
        ccui.Helper:seekWidgetByName(root,"Text_no_play"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Panel_rank_on"):setVisible(true)
    end

    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.bounceBottom then--6
            --滑到头
            state_machine.excute("sm_union_adventure_rank_open_rank", 0, nil)
        end
    end
    ListView_rank_list:addScrollViewEventListener(scrollViewEvent)

    local Text_today_number = ccui.Helper:seekWidgetByName(root,"Text_today_number")
    Text_today_number:setString(_ED.union_stick_crazy_adventure_progress_rank.my_info.number)
end

function SmUnionAdventureRank:init()
    self:onInit()
    return self
end


function SmUnionAdventureRank:onInit()
    local csbSmUnionAdventureRank = csb.createNode("legion/sm_legion_adventure_rank.csb")
    local root = csbSmUnionAdventureRank:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionAdventureRank)

    local Text_no_play = ccui.Helper:seekWidgetByName(root,"Text_no_play")
    Text_no_play:setVisible(true)
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            self:onUpdateDraw()
        end
    end
    protocol_command.order_get_info.param_list = "6".."\r\n"..(self.starting_point).."\r\n"..(self.end_point)
    NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, self, responseCallback, false, nil)
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_adventure_rank_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)
	-- 
end

function SmUnionAdventureRank:onExit()
    state_machine.remove("sm_union_adventure_rank_display")
    state_machine.remove("sm_union_adventure_rank_hide")
end