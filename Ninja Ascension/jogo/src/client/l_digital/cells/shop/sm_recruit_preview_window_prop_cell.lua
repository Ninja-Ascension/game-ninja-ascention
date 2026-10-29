--------------------------------------------------------------------------------------------------------------
--  招募奖励预览道具列表cell
--------------------------------------------------------------------------------------------------------------
SmRecruitPreviewWindowPropCell = class("SmRecruitPreviewWindowPropCellClass", Window)
SmRecruitPreviewWindowPropCell.__size = nil

-- 创建cell
local sm_recruit_preview_window_prop_cell_create_terminal = {
    _name = "sm_recruit_preview_window_prop_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmRecruitPreviewWindowPropCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_recruit_preview_window_prop_cell_create_terminal)
state_machine.init()

function SmRecruitPreviewWindowPropCell:ctor()
    self.super:ctor()
    self.roots = {}
    
    -- 定义变量
    self._index = 0
    self._info = nil
    
    -- 加载lua文件
    
    -- 初始化状态机
    local function init_sm_recruit_preview_window_prop_cell_terminal()

    end 
    init_sm_recruit_preview_window_prop_cell_terminal()

end

-- 刷新
function SmRecruitPreviewWindowPropCell:updateDraw()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    local Text_props_name = ccui.Helper:seekWidgetByName(root,"Text_props_name")

    Panel_props_icon:removeAllChildren(true)
    Text_props_name:setString("")

    local name = ""
    local quality = 0
    if tonumber(self._info.prop_type) == 6 then
        name = smPropWordlFundByIndex(self._info.mould_id, 1)
        quality = dms.int(dms["prop_mould"], self._info.mould_id, prop_mould.prop_quality)
    elseif tonumber(self._info.prop_type) == 7 then
        name = smEquipWordlFundByIndex(self._info.mould_id, 1)
        quality = dms.int(dms["equipment_mould"], self._info.mould_id, equipment_mould.grow_level)
    elseif tonumber(self._info.mould_id) == -1 then
        name = _my_gane_name[self._info.prop_type]
        quality = 2
    end
    Text_props_name:setString(name)
    Text_props_name:setColor(cc.c3b(recruit_preview_tip_color[quality + 1][1], recruit_preview_tip_color[quality + 1][2], recruit_preview_tip_color[quality + 1][3]))

    -- local cell = ResourcesIconCell:createCell()
    -- cell:init(self._info.prop_type, 0, self._info.mould_id, nil, nil, true, true, 0)
    -- Panel_props_icon:addChild(cell)
    
    local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{self._info.prop_type,self._info.mould_id,1},false,false,false,true})
    Panel_props_icon:addChild(cell)
end 

function SmRecruitPreviewWindowPropCell:onInit()
    local csbItem = csb.createNode("shop/sm_recruit_preview_window_tab_2_list.csb")
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbItem)

    -- local root = cacher.createUIRef("shop/sm_recruit_preview_window_tab_2_list.csb", "root")
    -- table.insert(self.roots, root)
    -- self:addChild(root)

    if SmRecruitPreviewWindowPropCell.__size == nil then
        SmRecruitPreviewWindowPropCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function SmRecruitPreviewWindowPropCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function SmRecruitPreviewWindowPropCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    local Text_props_name = ccui.Helper:seekWidgetByName(root,"Text_props_name")

    if Panel_props_icon ~= nil then
        Panel_props_icon:removeAllChildren(true)
        Text_props_name:setString("")
    end
end

function SmRecruitPreviewWindowPropCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SmRecruitPreviewWindowPropCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef("shop/sm_recruit_preview_window_tab_2_list.csb", root)
    root:removeFromParent(false)
    self.roots = {}
end

function SmRecruitPreviewWindowPropCell:init(params)
    self._index = params[1]
    self._info = params[2]

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        if self._index ~= nil and self._index <= 10 then
           self:onInit()
        end
    else
        if self._index ~= nil and self._index <= 15 then
           self:onInit()
        end
    end
    self:setContentSize(SmRecruitPreviewWindowPropCell.__size)
    return self
end

function SmRecruitPreviewWindowPropCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("shop/sm_recruit_preview_window_tab_2_list.csb", self.roots[1])
end