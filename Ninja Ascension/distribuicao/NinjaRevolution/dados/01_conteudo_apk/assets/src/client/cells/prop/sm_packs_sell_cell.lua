--------------------------------------------------------------------------------------------------------------
--  说明：仓库的全部出售的控件
--------------------------------------------------------------------------------------------------------------
SmPacksSellCell = class("SmPacksSellCellClass", Window)
SmPacksSellCell.__size = nil

--创建cell
local sm_packs_sell_cell_terminal = {
    _name = "sm_packs_sell_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmPacksSellCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_packs_sell_cell_terminal)
state_machine.init()

function SmPacksSellCell:ctor()
	self.super:ctor()
	self.roots = {}

	 -- Initialize sm_packs_sell_cell state machine.
    local function init_sm_packs_sell_cell_terminal()
        
        state_machine.init()
    end 
    -- call func sm_packs_sell_cell create state machine.
    init_sm_packs_sell_cell_terminal()

end

function SmPacksSellCell:updateDraw()
    local root = self.roots[1]
	local prop_mould_id = self.prop.user_prop_template
    --背景
    local Panel_props_quality = ccui.Helper:seekWidgetByName(root, "Panel_props_quality")
    Panel_props_quality:removeBackGroundImage()
    local quality = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.prop_quality)+1
    Panel_props_quality:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
    --图标
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    Panel_props_icon:removeBackGroundImage()
    local pic_index = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.pic_index)
    Panel_props_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", pic_index))
    --底框
    local Panel_props_bg = ccui.Helper:seekWidgetByName(root, "Panel_props_bg")
    Panel_props_bg:removeBackGroundImage()
    local index = 0
    if quality == 1 then
        index = 1
    elseif quality == 2 then
        index = 2
    elseif quality == 3 then
        index = 5
    elseif quality == 4 then
        index = 9
    elseif quality == 5 then
        index = 14
    elseif quality == 6 then
        index = 20
    end
    Panel_props_bg:setBackGroundImage(string.format("images/ui/quality/quality_frame_%d.png", index))

    --数量
    local Text_packs_sell_props_number = ccui.Helper:seekWidgetByName(root, "Text_packs_sell_props_number")
    Text_packs_sell_props_number:setString("x"..self.prop.prop_number)

     --名称
    local Text_packs_sell_props_name = ccui.Helper:seekWidgetByName(root, "Text_packs_sell_props_name")
    local name = dms.string(dms["prop_mould"], self.prop.user_prop_template, prop_mould.prop_name)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        name = setThePropsIcon(self.prop.user_prop_template)[2]
    end
    Text_packs_sell_props_name:setString(name)
    local quality = dms.int(dms["prop_mould"], self.prop.user_prop_template, prop_mould.prop_quality)+1
    Text_packs_sell_props_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))     

end

function SmPacksSellCell:onUpdate(dt)
    
end

function SmPacksSellCell:onInit()
    local root = cacher.createUIRef("packs/sm_warehouse_sell_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
   
    if SmPacksSellCell.__size == nil then
        SmPacksSellCell.__size = root:getContentSize()
    end
    
	self:updateDraw()
end

function SmPacksSellCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function SmPacksSellCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_props_bg = ccui.Helper:seekWidgetByName(root, "Panel_props_bg")
    if Panel_props_bg ~= nil then
        Panel_props_bg:removeBackGroundImage()
    end
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    if Panel_props_icon ~= nil then
        Panel_props_icon:removeBackGroundImage()
    end
    local Panel_props_quality = ccui.Helper:seekWidgetByName(root, "Panel_props_quality")
    if Panel_props_quality ~= nil then
        Panel_props_quality:removeBackGroundImage()
    end
    local Text_packs_sell_props_number = ccui.Helper:seekWidgetByName(root, "Text_packs_sell_props_number")
    if Text_packs_sell_props_number ~= nil then
        Text_packs_sell_props_number:setString("")
    end
    local Text_packs_sell_props_name = ccui.Helper:seekWidgetByName(root, "Text_packs_sell_props_name")
    if Text_packs_sell_props_name ~= nil then
        Text_packs_sell_props_name:setString("")
    end
end

function SmPacksSellCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmPacksSellCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("packs/sm_warehouse_sell_cell.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmPacksSellCell:init(params)
    self.prop = params[1]
	self:onInit()

    self:setContentSize(SmPacksSellCell.__size)
    return self
end

function SmPacksSellCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("packs/sm_warehouse_sell_cell.csb", self.roots[1])
end