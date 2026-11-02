--------------------------------------------------------------------------------------------------------------
--  说明：羁绊cell
--------------------------------------------------------------------------------------------------------------
HeroFetterChoseeCell = class("HeroFetterChoseeCellClass", Window)
HeroFetterChoseeCell.__size = nil
--创建cell
local hero_fetter_chosee_create_cell_terminal = {
    _name = "hero_fetter_chosee_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local ship_or_equip = params[1]
        local rela_type = params[2]
        local cell = HeroFetterChoseeCell:new()
        cell:init(ship_or_equip,rela_type)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_fetter_chosee_create_cell_terminal)
state_machine.init()

function HeroFetterChoseeCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.ship_or_equip = nil
    self.rela_type = nil
    self.isSelecet = false
	 -- Initialize hero_fetters_chosee_cell state machine.
    local function init_hero_fetters_chosee_cell_terminal()
		
        --选中
        local hero_fetters_chosee_cell_click_terminal = {
            _name = "hero_fetters_chosee_cell_click",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local index = cell.index
                state_machine.excute("hero_fetter_chosee_change_selected",0,cell.ship_or_equip)
                cell.isSelecet = true 
                cell:setSeclected()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(hero_fetters_chosee_cell_click_terminal)
        state_machine.init()
    end
    
    -- call func hero_fetters_cell_click create state machine.
    init_hero_fetters_chosee_cell_terminal()

end

function HeroFetterChoseeCell:updateDraw()
    local root = self.roots[1]
    local Panel_fetter_cell_icon = ccui.Helper:seekWidgetByName(root,"Panel_fetter_cell_icon")
    Panel_fetter_cell_icon:removeAllChildren(true)
    local Text_fetter_cell_fight = ccui.Helper:seekWidgetByName(root,"Text_fetter_cell_fight")
    local cell =  nil
    if self.rela_type == 0 then
        cell = state_machine.excute("hero_icon_create_cell",0,{self.ship_or_equip,4,0})
        Text_fetter_cell_fight:setString(self.ship_or_equip.hero_fight)
    else
        local data = 
        {
            item_value = 1,
            prop_type = 7,
            prop_item = self.ship_or_equip.user_equiment_template
        }
        cell = state_machine.excute("all_resource_create_cell",0,{2,data,self.ship_or_equip,8,0})
        Text_fetter_cell_fight:setString(self.ship_or_equip.equip_fight)
    end
    Panel_fetter_cell_icon:addChild(cell)
end

function HeroFetterChoseeCell:setSeclected()
    local root = self.roots[1]    
    local Image_fetter_cell_light = ccui.Helper:seekWidgetByName(root,"Image_fetter_cell_light")
    if Image_fetter_cell_light == nil then
        return
    end
    Image_fetter_cell_light:setVisible(self.isSelecet)
end

function HeroFetterChoseeCell:onInit() 
    local csbItem = csb.createNode(config_csb.cells.hero.hero_fetter_chosee_cell)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
    self:addChild(root)

    if HeroFetterChoseeCell.__size == nil then
        HeroFetterChoseeCell.__size = root:getContentSize()
    end
    local Image_fetter_cell_1 = ccui.Helper:seekWidgetByName(root,"Image_fetter_cell_1")
    fwin:addTouchEventListener(Image_fetter_cell_1, nil, 
    {
        terminal_name = "hero_fetters_chosee_cell_click", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
	self:updateDraw()
end

function HeroFetterChoseeCell:onEnterTransitionFinish()

end

--清除缓存
function HeroFetterChoseeCell:close()

end

function HeroFetterChoseeCell:init(ship_or_equip,rela_type)
    self.ship_or_equip = ship_or_equip
    self.rela_type = rela_type
	self:onInit()
    self:setContentSize(HeroFetterChoseeCell.__size)
    return self
end

function HeroFetterChoseeCell:onExit()
    local Panel_fetter_cell_icon = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_fetter_cell_icon")
    if Panel_fetter_cell_icon ~= nil then
        Panel_fetter_cell_icon:removeAllChildren(true)
    end
end
