-- ----------------------------------------------------------------------------------------------------
-- 说明：公会工会副本NPC成员伤害
-------------------------------------------------------------------------------------------------------
SmUnionMemberDamage = class("SmUnionMemberDamageClass", Window)

local sm_union_member_damage_open_terminal = {
    _name = "sm_union_member_damage_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionMemberDamageClass")
        if nil == _homeWindow then
            local panel = SmUnionMemberDamage:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_member_damage_close_terminal = {
    _name = "sm_union_member_damage_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionMemberDamageClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionMemberDamageClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_member_damage_open_terminal)
state_machine.add(sm_union_member_damage_close_terminal)
state_machine.init()
    
function SmUnionMemberDamage:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    app.load("client.l_digital.cells.union.union_npc_hurt_rank_list_cell")
    local function init_sm_union_member_damage_terminal()
        -- 显示界面
        local sm_union_member_damage_display_terminal = {
            _name = "sm_union_member_damage_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionMemberDamageWindow = fwin:find("SmUnionMemberDamageClass")
                if SmUnionMemberDamageWindow ~= nil then
                    SmUnionMemberDamageWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_member_damage_hide_terminal = {
            _name = "sm_union_member_damage_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionMemberDamageWindow = fwin:find("SmUnionMemberDamageClass")
                if SmUnionMemberDamageWindow ~= nil then
                    SmUnionMemberDamageWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_member_damage_display_terminal)
        state_machine.add(sm_union_member_damage_hide_terminal)

        state_machine.init()
    end
    init_sm_union_member_damage_terminal()
end

function SmUnionMemberDamage:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    self.gradListView = ccui.Helper:seekWidgetByName(root, "ListView_ghfb_rule")
    self.gradListView:removeAllItems()
    self.cacheListView = self.gradListView
    self.currentListView = self.cacheListView
    self.currentInnerContainer = self.cacheListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    local index = 0
    local union_position = 0
    table.sort(_ED.union_member_npc_rank_hurt_list, function(c1, c2)
            if c1 ~= nil 
                and c2 ~= nil 
                and zstring.tonumber(c1.user_hurt) > zstring.tonumber(c2.user_hurt) then
                return true
            end
            return false
        end)

    for i, v in pairs(_ED.union_member_npc_rank_hurt_list) do
        index = index + 1
        local cell = UnionNpcHurtRankListCell:createCell()
        cell:init(v,index)
        self.cacheListView:addChild(cell)
        self.cacheListView:requestRefreshView()
    end
end

function SmUnionMemberDamage:init()
    self:onInit()
    return self
end

function SmUnionMemberDamage:onUpdate(dt)

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

function SmUnionMemberDamage:onInit()
    local csbSmUnionMemberDamage = csb.createNode("legion/sm_legion_pve_window_hurt_rank.csb")
    local root = csbSmUnionMemberDamage:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionMemberDamage)
    self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_member_damage_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

end

function SmUnionMemberDamage:onExit()
    state_machine.remove("sm_union_member_damage_display")
    state_machine.remove("sm_union_member_damage_hide")
end