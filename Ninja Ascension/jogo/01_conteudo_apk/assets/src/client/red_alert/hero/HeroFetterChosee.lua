-----------------------------
--缘分选择
-----------------------------
HeroFetterChosee = class("HeroFetterChoseeClass", Window)

local hero_fetter_chosee_window_open_terminal = {
    _name = "hero_fetter_chosee_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HeroFetterChoseeClass")
        if nil == _Window then
            local now_ship_id = params[1]
            local rele_id = params[2]
            local rele_type = params[3]
            local data_tables = params[4]
            local ship = params[5]
            local select_rela_index = params[6]
            fwin:open(HeroFetterChosee:new():init(now_ship_id,rele_id,rele_type,data_tables,ship,select_rela_index),fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local hero_fetter_chosee_window_close_terminal = {
    _name = "hero_fetter_chosee_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroFetterChoseeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_fetter_chosee_window_open_terminal)
state_machine.add(hero_fetter_chosee_window_close_terminal)
state_machine.init()

function HeroFetterChosee:ctor()
    self.super:ctor()
    self.roots = {}
    self.now_ship_id = nil
    self.rele_id = nil
    self.rele_type = nil
    self.data_tables = nil  
    self.select_ship_or_equip = nil 
    local function init_hero_fetter_chosee_terminal() 
        --确认绑定
        local hero_fetter_chosee_sure_terminal = {
            _name = "hero_fetter_chosee_sure",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local id = 0 
                if instance.rele_type == 0 then
                    id = self.select_ship_or_equip.ship_id
                else
                    id = self.select_ship_or_equip.user_equiment_id
                end
                local ship = params._datas.ship
                local select_rela_index = params._datas.select_rela_index
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.select_ship_or_equip ~= nil and response.node.rele_type then
                            -- if response.node.rele_type == 0 then
                            --     state_machine.excute("hero_main_remove_list_item",0,response.node.select_ship_or_equip)
                            -- end
                            state_machine.excute("hero_main_update_draw",0,"")
                            state_machine.excute("hero_fetters_update_cell",0,response.node.rele_id)
                            state_machine.excute("hero_main_update_hero_info",0,"")
                        end
                        state_machine.excute("hero_fetters_update_rela",0,"")
                        state_machine.excute("hero_fetter_chosee_window_close",0,"")
                        state_machine.excute("hero_fetters_play_lighted_action",0,"")
                        local sound_index = mainShipSound(ship.ship_template_id)
                        playEffectOld(formatMusicFile("effect", sound_index))
                        playEffect(formatMusicFile("effect", 9999))
                        local index = 0 
                        for i,v in pairs(ship.relationship[select_rela_index].is_activited) do
                            if tonumber(v) >= 0 then
                                index = index + 1
                            end
                        end
                        if index == #ship.relationship[select_rela_index].is_activited then 
                            state_machine.excute("hero_fetters_update_numbers",0,{1})
                        end
                    end
                end
                if instance.now_ship_id == nil then
                    return
                end
                protocol_command.binding_fetter.param_list = instance.now_ship_id.."\r\n"..instance.rele_id.."\r\n"..instance.rele_type.."\r\n"..id
                NetworkManager:register(protocol_command.binding_fetter.code, nil, nil, nil, instance, responseCallback, false, nil)  
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --改变当前选中 
        local hero_fetter_chosee_change_selected_terminal = {
            _name = "hero_fetter_chosee_change_selected",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.select_ship_or_equip = params
                instance:setUnSelect()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(hero_fetter_chosee_sure_terminal)
        state_machine.add(hero_fetter_chosee_change_selected_terminal)
        state_machine.init()
    end
    
    -- call func hero_fetters_cell_click create state machine.
    init_hero_fetter_chosee_terminal()    
end

function HeroFetterChosee:setUnSelect()
    local root = self.roots[1]
    local ListView_hero_fetter_chosee = ccui.Helper:seekWidgetByName(root,"ListView_hero_fetter_chosee")
    for i,cell in pairs(ListView_hero_fetter_chosee:getItems()) do
        cell.isSelecet = false
        cell:setSeclected()
    end
end

function HeroFetterChosee:updateDraw( )
    local root = self.roots[1]
    local ListView_hero_fetter_chosee = ccui.Helper:seekWidgetByName(root,"ListView_hero_fetter_chosee")
    ListView_hero_fetter_chosee:removeAllItems()

    for i,v in pairs(self.data_tables) do
        local cell = state_machine.excute("hero_fetter_chosee_create_cell",0,{v,self.rele_type})
        ListView_hero_fetter_chosee:addChild(cell)
        if i == 1 then
            self.select_ship_or_equip = v
            state_machine.excute("hero_fetters_chosee_cell_click",0,{_datas = {cell = cell}})
        end
    end
    ListView_hero_fetter_chosee:requestRefreshView()
end

function HeroFetterChosee:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_fetter_chosee)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --确认绑定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_fetter_chosee"), nil, 
    {
        terminal_name = "hero_fetter_chosee_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ship = self.ship,
        select_rela_index = self.select_rela_index,
    }, nil, 0)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_hero_fetter_chosee_1"), nil, 
    {
        terminal_name = "hero_fetter_chosee_window_close", 
        terminal_state = 0, 
    }, nil, 0)
    
    self:updateDraw()
end

function HeroFetterChosee:init(now_ship_id,rele_id,rele_type,data_tables,ship,select_rela_index)
    self.now_ship_id = now_ship_id
    self.rele_id = rele_id
    self.rele_type = rele_type
    self.data_tables = data_tables
    self.ship = ship
    self.select_rela_index = select_rela_index
    self:onInit()
    return self
end

function HeroFetterChosee:onExit()
    state_machine.remove("hero_fetter_chosee_sure")
    state_machine.remove("hero_fetter_chosee_change_selected")
end
