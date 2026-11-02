-- ----------------------------------------------------------------------------------------------------
-- 说明：成员的训练信息界面
-------------------------------------------------------------------------------------------------------
SmUnionEnergyHouseMemberWindow = class("SmUnionEnergyHouseMemberWindowClass", Window)

local sm_union_energy_house_member_window_open_terminal = {
    _name = "sm_union_energy_house_member_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionEnergyHouseMemberWindowClass")
        if nil == _homeWindow then
            local panel = SmUnionEnergyHouseMemberWindow:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_energy_house_member_window_close_terminal = {
    _name = "sm_union_energy_house_member_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionEnergyHouseMemberWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionEnergyHouseMemberWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_energy_house_member_window_open_terminal)
state_machine.add(sm_union_energy_house_member_window_close_terminal)
state_machine.init()
    
function SmUnionEnergyHouseMemberWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.tSortedHeroes = {}
    -- app.load("client.l_digital.union.heaven.UnionHeaven")
    -- app.load("client.l_digital.union.heaven.SmUnionInstituteDonate")
    app.load("client.l_digital.cells.union.union_energy_house_position_cell")
    local function init_sm_union_energy_house_member_window_terminal()
        -- 显示界面
        local sm_union_energy_house_member_window_display_terminal = {
            _name = "sm_union_energy_house_member_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionEnergyHouseMemberWindowWindow = fwin:find("SmUnionEnergyHouseMemberWindowClass")
                if SmUnionEnergyHouseMemberWindowWindow ~= nil then
                    SmUnionEnergyHouseMemberWindowWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_energy_house_member_window_hide_terminal = {
            _name = "sm_union_energy_house_member_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionEnergyHouseMemberWindowWindow = fwin:find("SmUnionEnergyHouseMemberWindowClass")
                if SmUnionEnergyHouseMemberWindowWindow ~= nil then
                    SmUnionEnergyHouseMemberWindowWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_energy_house_member_window_display_terminal)
        state_machine.add(sm_union_energy_house_member_window_hide_terminal)
        state_machine.init()
    end
    init_sm_union_energy_house_member_window_terminal()
end


function SmUnionEnergyHouseMemberWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local Text_member_name = ccui.Helper:seekWidgetByName(root,"Text_member_name")
    Text_member_name:setString(self.member.memberInfo.name)

    local my_data = zstring.split(self.member.member_data,"|")
    for i=1, 8 do
        local cell = unionEnergyHousePositionCell:createCell()
        cell:init(i, self.member.member_id)
        cell:setTag(500+i)
        ccui.Helper:seekWidgetByName(root,"Panel_member_weizhi_"..i):removeAllChildren(true)
        ccui.Helper:seekWidgetByName(root,"Panel_member_weizhi_"..i):addChild(cell)
    end
end

function SmUnionEnergyHouseMemberWindow:init(params)
    self.member = params
    self:onInit()
    return self
end

function SmUnionEnergyHouseMemberWindow:onInit()
    local csbSmUnionEnergyHouseMemberWindow = csb.createNode("legion/sm_legion_energy_house_member_window.csb")
    local root = csbSmUnionEnergyHouseMemberWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionEnergyHouseMemberWindow)

    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_energy_house_member_window_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)
    
end

function SmUnionEnergyHouseMemberWindow:onExit()
    state_machine.remove("sm_union_energy_house_member_window_display")
    state_machine.remove("sm_union_energy_house_member_window_hide")
end