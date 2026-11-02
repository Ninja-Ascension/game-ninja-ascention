-- ----------------------------------------------------------------------------------------------------
-- 说明将星录天赋
-------------------------------------------------------------------------------------------------------
CatalogueStorageTalent = class("CatalogueStorageTalentClass", Window)

--打开将星录
local catalogue_storage_talent_window_open_terminal = {
    _name = "catalogue_storage_talent_window_open",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)

        if nil == fwin:find("CatalogueStorageTalentClass") then
            local ship_mould_id = params._datas.cell._ship_mould_id
            fwin:open(CatalogueStorageTalent:new():init(ship_mould_id), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local catalogue_storage_talent_window_close_terminal = {
    _name = "catalogue_storage_talent_window_close",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("CatalogueStorageTalentClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(catalogue_storage_talent_window_open_terminal)
state_machine.add(catalogue_storage_talent_window_close_terminal)
state_machine.init()
function CatalogueStorageTalent:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
    self.panel_talent = nil
    --英雄id
    self._ship_mould_id = nil
    
    --LOAD LUA FILE
    app.load("client.red_alert_time.recruit.CatalogueStorageTalentPanel")
    

end

function CatalogueStorageTalent:onEnterTransitionFinish()


end


function CatalogueStorageTalent:onUpdateDraw()
    local root = self.roots[1]
    self.panel_talent._update_view_size = true
    state_machine.excute("catalogue_storage_talent_panel_window_open",0,{self.panel_talent,self._ship_mould_id})
    --角色动画
    local Panel_head = ccui.Helper:seekWidgetByName(root,"Panel_head")
    Panel_head:removeAllChildren(true)
    app.load("client.battle.fight.FightEnum")
    local temp_bust_index = dms.int(dms["ship_mould"], self._ship_mould_id, ship_mould.bust_index)
    temp_bust_index = 10000 + temp_bust_index
    local armature = sp.spine_sprite(Panel_head, temp_bust_index, _spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_10+1], true, nil, nil, cc.p(0.5, 0))
    armature:setPosition(cc.p(Panel_head:getContentSize().width/2, 0))
    --名字
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    local captain_name = dms.string(dms["ship_mould"], self._ship_mould_id, ship_mould.captain_name)
    local ship_type = dms.int(dms["ship_mould"], self._ship_mould_id, ship_mould.ship_type)
    Text_name:setString(captain_name)
    Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[ship_type+1][1],tipStringInfo_quality_color_Type[ship_type+1][2],tipStringInfo_quality_color_Type[ship_type+1][3]))
    --职业
    local Text_occupation_infor = ccui.Helper:seekWidgetByName(root,"Text_occupation_infor")
    local capacity = dms.int(dms["ship_mould"], self._ship_mould_id, ship_mould.capacity)
    Text_occupation_infor:setString(red_alert_hero_job[capacity])
    --类型 
    local Text_type_infor = ccui.Helper:seekWidgetByName(root,"Text_type_infor")
    Text_type_infor:setString(red_alert_hero_type[capacity]) 
    --资质
    local Text_qualifiction_infor = ccui.Helper:seekWidgetByName(root,"Text_qualifiction_infor")
    local ability = dms.int(dms["ship_mould"], self._ship_mould_id, ship_mould.ability)
    Text_qualifiction_infor:setString(tipStringInfo_hero_ability[ability])
end


function CatalogueStorageTalent:onInit()
    local csbItem = csb.createNode(config_csb.recruit.catalogue_storage_talent)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)


    local Panel_talent = ccui.Helper:seekWidgetByName(root,"Panel_talent")
    self.panel_talent = Panel_talent

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "catalogue_storage_talent_window_close",        
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    self:onUpdateDraw()
end

function CatalogueStorageTalent:init(ship_mould_id)
    self._ship_mould_id = ship_mould_id
    self:onInit()
    return self
end

function CatalogueStorageTalent:onExit()
end