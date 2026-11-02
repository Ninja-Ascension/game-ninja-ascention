--------------------------------------------------------------------------------------------------------------
--  说明：羁绊cell
--------------------------------------------------------------------------------------------------------------
HeroFettersCell = class("HeroFettersCellClass", Window)
HeroFettersCell.__size = nil
--创建cell
local hero_fetters_create_cell_terminal = {
    _name = "hero_fetters_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local id = params[1]
        local states = params[2]
        local index = params[3]
        local isShowPush = params[4]
        local cell = HeroFettersCell:new()
        cell:init(id, states, index, isShowPush)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_fetters_create_cell_terminal)
state_machine.init()

function HeroFettersCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.id = nil
    self.states = nil
    self.index = nil
    self.isSelecet = false
    self.isShowPush = false
	 -- Initialize hero_fetters_cell_click state machine.
    local function init_hero_fetters_cell_terminal()
		
        --选中
        local hero_fetters_cell_click_terminal = {
            _name = "hero_fetters_cell_click",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local index = cell.index
                state_machine.excute("hero_fetters_update_rela",0,{index})
                state_machine.excute("hero_fetters_unsetselect",0,"")
                state_machine.excute("other_players_hero_fetters_update_rela",0,{index})
                state_machine.excute("other_players_hero_fetters_unsetselect",0,"")
                cell.isSelecet = true 
                cell:setSeclected()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(hero_fetters_cell_click_terminal)
        state_machine.init()
    end
    
    -- call func hero_fetters_cell_click create state machine.
    init_hero_fetters_cell_terminal()

end

function HeroFettersCell:updateDraw()
    local root = self.roots[1]
    local rela_data = dms.element(dms["fate_relationship_mould"],self.id)
    local name = dms.atos(rela_data,fate_relationship_mould.relation_name)
    local pic_index = dms.atoi(rela_data,fate_relationship_mould.pic_index)
    local isLighted = true
    for i,v in pairs(self.states) do
        if tonumber(v) < 0 then
            isLighted = false
            break
        end
    end
    -- debug.print_r(self.states)
    --是否羁绊成功
    local Image_fetter_effect_success = ccui.Helper:seekWidgetByName(root,"Image_fetter_effect_success")
    Image_fetter_effect_success:setVisible(false)
    if isLighted == true then
        Image_fetter_effect_success:setVisible(true)
    end
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

function HeroFettersCell:onUpdate()
    local root = self.roots[1]
    local Image_point = ccui.Helper:seekWidgetByName(root,"Image_point")
    Image_point:setVisible(false)
    if self.isShowPush == false then
        return
    end
    for i,v in pairs(self.states) do
        local relationship_data = dms.element(dms["fate_relationship_mould"],self.id)
        local mould_id = dms.atoi(relationship_data,fate_relationship_mould.relation_need1+(i-1)*2)
        local rele_type = dms.atoi(relationship_data,fate_relationship_mould.relation_need1_type+(i-1)*2)
        local numbers = 0
        if rele_type == 0 then
            for i,ship in pairs(_ED.user_ship) do
                if tonumber(ship.ship_base_template_id) == tonumber(mould_id) and 
                    -- ship.ship_id ~= self.ship.ship_id and 
                    zstring.tonumber(ship.formation_index) == 0 and
                    zstring.tonumber(ship.little_partner_formation_index) == 0
                    then
                    numbers = numbers + 1
                    break
                end
            end
        else
            for i,equip in pairs(_ED.user_equiment) do
                if tonumber(equip.user_equiment_template) == tonumber(mould_id) and 
                    zstring.tonumber(equip.ship_id) == 0 and
                    zstring.tonumber(equip.rela_state) == 0 
                    then
                    numbers = numbers + 1
                    break
                end
            end
        end
        if numbers > 0 and tonumber(v) == -1 then
            Image_point:setVisible(true)
            break
        end
    end
end
function HeroFettersCell:setSeclected()
    local root = self.roots[1]    
    local Image_fetter_effect_select = ccui.Helper:seekWidgetByName(root,"Image_fetter_effect_select")
    if Image_fetter_effect_select == nil then
        return
    end
    Image_fetter_effect_select:setVisible(self.isSelecet)
end

function HeroFettersCell:onInit() 
    local csbItem = csb.createNode(config_csb.cells.hero.hero_fetters_cell)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
    self:addChild(root)
    if HeroFettersCell.__size == nil then
        HeroFettersCell.__size = root:getContentSize()
    end
    local Image_fetter_effect_box = ccui.Helper:seekWidgetByName(root,"Image_fetter_effect_box")
    Image_fetter_effect_box:setSwallowTouches(false)
    fwin:addTouchEventListener(Image_fetter_effect_box, nil, 
    {
        terminal_name = "hero_fetters_cell_click", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
	self:updateDraw()
end

function HeroFettersCell:onEnterTransitionFinish()

end

function HeroFettersCell:init(id, states,index, isShowPush)
    self.id = id
    self.states = states
    self.index = index
    if isShowPush == nil then
        isShowPush = false
    end
    self.isShowPush = isShowPush
	self:onInit()
    self:setContentSize(HeroFettersCell.__size)
end
