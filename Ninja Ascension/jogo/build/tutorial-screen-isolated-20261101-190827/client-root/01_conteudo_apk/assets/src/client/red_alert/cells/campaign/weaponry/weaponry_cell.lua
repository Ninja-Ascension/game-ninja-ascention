-----------------------------
--兵器冢cell
-----------------------------
WeaponryCell = class("WeaponryCellClass", Window)
WeaponryCell.__size = nil

--创建cell
local weaponry_create_cell_terminal = {
    _name = "weaponry_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local weaponry_info = params[1] 
        local cell = WeaponryCell:new()
        cell:init(weaponry_info)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(weaponry_create_cell_terminal)
state_machine.init()

function WeaponryCell:ctor()
    self.super:ctor()
    self.roots = {}

    --var 
    -- 副本信息
    self.weaponry_info = nil

    --load lua file
    app.load("client.red_alert.cells.hero.hero_icon_cell")
    -- Initialize weaponry_cell state machine.
    local function init_weaponry_cell_terminal()
	
        state_machine.init()
    end
    
    -- call func init weaponry_cell state machine.
    init_weaponry_cell_terminal()
end

function WeaponryCell:unSetSelect()
    local root = self.roots[1]
    for i,v in pairs(self.weaponry_info) do
        local Panel_genral = ccui.Helper:seekWidgetByName(root,"Panel_genral_"..i)
        for j,cell in pairs( Panel_genral:getChildren()) do
            cell.isSelecet = false
            state_machine.excute("hero_icon_cell_set_seleceted",0,cell)
        end
    end
end

function WeaponryCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_title = ccui.Helper:seekWidgetByName(root,"Text_title") -- 副本描述
    Text_title:setString(equipment_duplicate_dec[self.weaponry_info[1].difficulty])

    for i,v in pairs(self.weaponry_info) do
        local herocell = state_machine.excute("hero_icon_create_cell",0,{v,5,0,false})
        
        if tonumber(_ED.npc_state[v.npc_id]) == 0 then
            state_machine.excute("hero_icon_cell_click_head",0,{_datas = {cell = herocell,from_type = 5}})
        end
        -- if self.weaponry_info[1].difficulty == 1 then
        --     if i == 1 then
        --         state_machine.excute("hero_icon_cell_click_head",0,{_datas = {cell = herocell,from_type = 5}})
        --     end
        -- end
        local Panel_genral = ccui.Helper:seekWidgetByName(root,"Panel_genral_"..i)
        Panel_genral:removeAllChildren(true)
        Panel_genral:addChild(herocell)
    end
end

function WeaponryCell:onEnterTransitionFinish()

end

function WeaponryCell:onInit( )
    local root = cacher.createUIRef(config_csb.cells.campaign.weaponry.weaponry_cell, "root")
    self:addChild(root)
	
	table.insert(self.roots, root)
    if WeaponryCell.__size == nil then
        WeaponryCell.__size = root:getContentSize()
    end
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_campaign_cell"), nil, 
    -- {
    --     terminal_name = "campaign_click_child_page", 
    --     terminal_state = 0, 
    --     cell = self,
    --     touch_scale = true,
    --     touch_scale_xy = 0.95, 
    -- }, nil, 0)

	self:onUpdateDraw()	
end

function WeaponryCell:close()

end

function WeaponryCell:init(weaponry_info)
    self.weaponry_info = weaponry_info
	self:onInit()
    self:setContentSize(WeaponryCell.__size)
    return self
end

function WeaponryCell:onExit()
    for i,v in pairs(self.weaponry_info) do
        local Panel_genral = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_genral_"..i)
        if Panel_genral ~= nil then
            Panel_genral:removeAllChildren(true)
        end
    end
    cacher.freeRef(config_csb.cells.campaign.weaponry.weaponry_cell, self.roots[1])
end
