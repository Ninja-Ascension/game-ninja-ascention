-- ----------------------------------------------------------------------------------------------------
-- 说明：公会工会副本NPC工会排行榜
-------------------------------------------------------------------------------------------------------
SmUnionNpcRank = class("SmUnionNpcRankClass", Window)

local sm_union_npc_rank_open_terminal = {
    _name = "sm_union_npc_rank_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionNpcRankClass")
        if nil == _homeWindow then
            local panel = SmUnionNpcRank:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_npc_rank_close_terminal = {
    _name = "sm_union_npc_rank_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionNpcRankClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionNpcRankClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_npc_rank_open_terminal)
state_machine.add(sm_union_npc_rank_close_terminal)
state_machine.init()
    
function SmUnionNpcRank:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    app.load("client.cells.ship.hero_icon_list_cell")
    app.load("client.l_digital.cells.union.union_npc_battle_rank_list_cell")
    local function init_sm_union_npc_rank_terminal()
        -- 显示界面
        local sm_union_npc_rank_display_terminal = {
            _name = "sm_union_npc_rank_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionNpcRankWindow = fwin:find("SmUnionNpcRankClass")
                if SmUnionNpcRankWindow ~= nil then
                    SmUnionNpcRankWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_npc_rank_hide_terminal = {
            _name = "sm_union_npc_rank_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionNpcRankWindow = fwin:find("SmUnionNpcRankClass")
                if SmUnionNpcRankWindow ~= nil then
                    SmUnionNpcRankWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_npc_rank_display_terminal)
        state_machine.add(sm_union_npc_rank_hide_terminal)

        state_machine.init()
    end
    init_sm_union_npc_rank_terminal()
end

function SmUnionNpcRank:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    self.gradListView = ccui.Helper:seekWidgetByName(root, "ListView_ghfbphb")
    self.gradListView:removeAllItems()
    self.cacheListView = self.gradListView
    self.currentListView = self.cacheListView
    self.currentInnerContainer = self.cacheListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    local index = 0
    local union_position = 0
    -- local function sortFunc( a,b )
    --     return tonumber(a.new_hp) < tonumber(b.new_hp) 
    --         or (tonumber(a.new_hp) == tonumber(b.new_hp) and tonumber(a.kill_time) < tonumber(b.kill_time))
    -- end
    -- table.sort(_ED.union_battle_rank_list, sortFunc)

    local time = 0
    for i, v in pairs(_ED.union_battle_rank_list) do
        if tonumber(v.new_hp) == 0 and tonumber(v.max_hp) > 0 then
            index = index + 1
            local cell = UnionNpcBattleRankListCell:createCell()
            cell:init(v,index)
            self.cacheListView:addChild(cell)
            self.cacheListView:requestRefreshView()
        end
        if tonumber(v.union_id) == tonumber(_ED.union.union_info.union_id) then
            union_position = i
            time = v.kill_time
        end
    end

    local Text_wdgh_pm = ccui.Helper:seekWidgetByName(root, "Text_wdgh_pm")

    local Text_wdgh_name = ccui.Helper:seekWidgetByName(root, "Text_wdgh_name")
    Text_wdgh_name:setString(_ED.union.union_info.union_name)

    local Text_wdgh_time = ccui.Helper:seekWidgetByName(root, "Text_wdgh_time")
    if union_position == 0 then
        Text_wdgh_time:setString("")
        Text_wdgh_pm:setString(#_ED.union_battle_rank_list + 1)
    else
        if zstring.tonumber(time) == -1 then
            Text_wdgh_time:setString("")
        else
            Text_wdgh_time:setString(os.date("%Y".."-".."%m".."-".."%d".." ".."%H"..":".."%m", zstring.tonumber(time)/1000))
        end
        Text_wdgh_pm:setString(union_position)
    end
end

function SmUnionNpcRank:init()
    self:onInit()
    return self
end

function SmUnionNpcRank:onUpdate(dt)

    if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentListView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentListView:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function SmUnionNpcRank:onInit()
    local csbSmUnionNpcRank = csb.createNode("legion/sm_legion_pve_window_rank.csb")
    local root = csbSmUnionNpcRank:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionNpcRank)
    self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_npc_rank_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

end

function SmUnionNpcRank:onExit()
    state_machine.remove("sm_union_npc_rank_display")
    state_machine.remove("sm_union_npc_rank_hide")
end