-- ----------------------------------------------------------------------------------------------------
-- 说明：公会老虎机排行
-------------------------------------------------------------------------------------------------------
SmUnionSlotMachineRank = class("SmUnionSlotMachineRankClass", Window)

local sm_union_slot_machine_rank_open_terminal = {
    _name = "sm_union_slot_machine_rank_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionSlotMachineRankClass")
        if nil == _homeWindow then
            local panel = SmUnionSlotMachineRank:new():init()
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_slot_machine_rank_close_terminal = {
    _name = "sm_union_slot_machine_rank_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionSlotMachineRankClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionSlotMachineRankClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_slot_machine_rank_open_terminal)
state_machine.add(sm_union_slot_machine_rank_close_terminal)
state_machine.init()
    
function SmUnionSlotMachineRank:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.start_up_page = 1
    app.load("client.l_digital.cells.union.union_slot_machine_luck_draw_rank")
    local function init_sm_union_slot_machine_rank_terminal()
        -- 显示界面
        local sm_union_slot_machine_rank_display_terminal = {
            _name = "sm_union_slot_machine_rank_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionSlotMachineRankWindow = fwin:find("SmUnionSlotMachineRankClass")
                if SmUnionSlotMachineRankWindow ~= nil then
                    SmUnionSlotMachineRankWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_slot_machine_rank_hide_terminal = {
            _name = "sm_union_slot_machine_rank_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionSlotMachineRankWindow = fwin:find("SmUnionSlotMachineRankClass")
                if SmUnionSlotMachineRankWindow ~= nil then
                    SmUnionSlotMachineRankWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_slot_machine_rank_display_terminal)
        state_machine.add(sm_union_slot_machine_rank_hide_terminal)

        state_machine.init()
    end
    init_sm_union_slot_machine_rank_terminal()
end

function SmUnionSlotMachineRank:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local function fightingCapacity(a,b)
        local al = zstring.tonumber(a.max_number)
        local bl = zstring.tonumber(b.max_number)
        local a2 = zstring.tonumber(a.get_number)
        local b2 = zstring.tonumber(b.get_number)
        local result = false
        if (al > bl and a2 == b2) or (a1==b1 and a2 > b2) then
            result = true
        end
        return result 
    end



    if _ED.union_slot_machine_rank_list ~= nil and table.nums(_ED.union_slot_machine_rank_list) >= 1 then
        if table.nums(_ED.union_slot_machine_rank_list) > 1 then
            table.sort(_ED.union_slot_machine_rank_list, fightingCapacity)
        end
        ccui.Helper:seekWidgetByName(root,"Text_no_play"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Panel_rank_on"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root,"Text_no_play"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Panel_rank_on"):setVisible(false)
    end
    local ListView_rank_list = ccui.Helper:seekWidgetByName(root,"ListView_rank_list")
    ListView_rank_list:removeAllItems()
    local myDatas = nil
    if _ED.union_slot_machine_rank_list ~= nil then
        for i,v in pairs(_ED.union_slot_machine_rank_list) do
            if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
                myDatas = v
            end
            local cell = unionSlotMachineLuckDrawRank:createCell()
            cell:init(v,i)
            ListView_rank_list:addChild(cell)
        end
    end
    ListView_rank_list:requestRefreshView()
    if myDatas ~= nil then
        local Text_today_reward_n = ccui.Helper:seekWidgetByName(root,"Text_today_reward_n")
        Text_today_reward_n:setString(myDatas.max_number)
        local Text_today_number = ccui.Helper:seekWidgetByName(root,"Text_today_number")
        Text_today_number:setString(myDatas.get_number)
    end
end

function SmUnionSlotMachineRank:init()
    self:onInit()
    return self
end

function SmUnionSlotMachineRank:onInit()
    local csbSmUnionSlotMachineRank = csb.createNode("legion/sm_legion_luck_draw_rank.csb")
    local root = csbSmUnionSlotMachineRank:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionSlotMachineRank)
	
	-- self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_slot_machine_rank_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)
    
    self:onUpdateDraw()
end

function SmUnionSlotMachineRank:onExit()
    state_machine.remove("sm_union_slot_machine_rank_display")
    state_machine.remove("sm_union_slot_machine_rank_hide")
end