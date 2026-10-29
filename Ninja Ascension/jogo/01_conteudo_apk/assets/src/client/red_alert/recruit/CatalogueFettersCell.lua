--------------------------------------------------------------------------------------------------------------
--  说明：羁绊cell
--------------------------------------------------------------------------------------------------------------
CatalogueFettersCell = class("CataLogueFettersCellClass", Window)
CatalogueFettersCell.__size = nil
--创建cell
local catalogue_fetters_create_cell_terminal = {
    _name = "catalogue_fetters_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local id = params[1]
        local states = params[2]
        local index = params[3]
        local cell = CatalogueFettersCell:new()
        cell:init(id, states,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(catalogue_fetters_create_cell_terminal)
state_machine.init()

function CatalogueFettersCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.id = nil
    self.states = nil
    self.index = nil
    self.isSelecet = false
         -- Initialize catalogue_fetters state machine.
    local function init_catalogue_fetters_cell_terminal()
        
        --选中
        local catalogue_fetters_cell_click_terminal = {
            _name = "catalogue_fetters_cell_click",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local index = cell.index
                state_machine.excute("catalogue_fetters_update_rela",0,{index})
                state_machine.excute("catalogue_fetters_unsetselect",0,"")
                cell.isSelecet = true 
                cell:setSeclected()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(catalogue_fetters_cell_click_terminal)
        state_machine.init()
    end
    
    -- call func hero_fetters_cell_click create state machine.
    init_catalogue_fetters_cell_terminal()
end

function CatalogueFettersCell:setSeclected()
    local root = self.roots[1]    
    local Image_fetter_effect_select = ccui.Helper:seekWidgetByName(root,"Image_fetter_effect_select")
    if Image_fetter_effect_select == nil then
        return
    end
    Image_fetter_effect_select:setVisible(self.isSelecet)
end


function CatalogueFettersCell:updateDraw()
    local root = self.roots[1]
    local rela_data = dms.element(dms["fate_relationship_mould"],self.id)
    local name = dms.atos(rela_data,fate_relationship_mould.relation_name)
    local pic_index = dms.atoi(rela_data,fate_relationship_mould.pic_index)
    local isLighted = true
    -- debug.print_r(self.states)
    --是否羁绊成功
    local Image_fetter_effect_success = ccui.Helper:seekWidgetByName(root,"Image_fetter_effect_success")
    Image_fetter_effect_success:setVisible(false)

    -- 羁绊名称
    local Text_fetter_effect_name = ccui.Helper:seekWidgetByName(root,"Text_fetter_effect_name")
    Text_fetter_effect_name:setString(name)

    -- 羁绊图片
    local Panel_fetter_effect_icon = ccui.Helper:seekWidgetByName(root,"Panel_fetter_effect_icon")
    Panel_fetter_effect_icon:removeBackGroundImage()
    Panel_fetter_effect_icon:setBackGroundImage("images/ui/fetters_icon/fetters_icon_".. pic_index .. ".png")

    -- 英雄头像
    local Panel_role_fet_me = ccui.Helper:seekWidgetByName(root,"Panel_fetter_effect_icon")

end

function CatalogueFettersCell:onInit() 
    local csbItem = csb.createNode(config_csb.cells.hero.hero_fetters_cell)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
    self:addChild(root)
    if CatalogueFettersCell.__size == nil then
        CatalogueFettersCell.__size = root:getContentSize()
    end
    local Image_fetter_effect_box = ccui.Helper:seekWidgetByName(root,"Image_fetter_effect_box")
    Image_fetter_effect_box:setSwallowTouches(false)
    fwin:addTouchEventListener(Image_fetter_effect_box, nil, 
    {
        terminal_name = "catalogue_fetters_cell_click", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    self:updateDraw()
end

function CatalogueFettersCell:onEnterTransitionFinish()

end

function CatalogueFettersCell:init(id, states,index)
    self.id = id
    self.states = states
    self.index = index
    self:onInit()
    self:setContentSize(CatalogueFettersCell.__size)
end
