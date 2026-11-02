-----------------------------
--选择援军
-----------------------------
TrialtowerReinforcements = class("TrialtowerReinforcementsClass", Window)

local trialtower_reinforcements_window_open_terminal = {
    _name = "trialtower_reinforcements_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)     
        if nil == fwin:find("TrialtowerReinforcementsClass") then
            local environment_ships = params[1]
            fwin:open(TrialtowerReinforcements:new():init(environment_ships), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local trialtower_reinforcements_window_close_terminal = {
    _name = "trialtower_reinforcements_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TrialtowerReinforcementsClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(trialtower_reinforcements_window_open_terminal)
state_machine.add(trialtower_reinforcements_window_close_terminal)
state_machine.init()

function TrialtowerReinforcements:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
    app.load("client.red_alert.cells.hero.hero_icon_cell")

    --var 
    -- 选择援军
    self.select_index = nil

    --援军id
    self.ship_moulds = nil
    -- Initialize trialtower_reinforcements state machine.
    local function init_trialtower_reinforcements_terminal()
         --选择援军
        local trialtower_reinforcements_select_partner_terminal = {
            _name = "trialtower_reinforcements_select_partner",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params._datas.index
                instance.select_index = index
                instance:setSelectPartner()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        --确认选择
        local trialtower_reinforcements_select_sure_terminal = {
            _name = "trialtower_reinforcements_select_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.select_index == nil then
                    TipDlg.drawTextDailog(red_alert_all_str[121])
                    return
                end
                local choose_ship = instance.environment_ships[instance.select_index]
                state_machine.excute("trialtower_reinforcements_window_close",0,"")
                state_machine.excute("trialtower_hero_attack_move", 0, choose_ship)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        state_machine.add(trialtower_reinforcements_select_partner_terminal)
        state_machine.add(trialtower_reinforcements_select_sure_terminal)
        state_machine.init()
    end
       -- call func trialtower_reinforcements state machine.
    init_trialtower_reinforcements_terminal()
end

function TrialtowerReinforcements:onUpdateDraw()
    local root = self.roots[1]
    
    for i,id in pairs(self.ship_moulds) do
        local Panel = ccui.Helper:seekWidgetByName(root,"Panel_select_"..i)
        local Image_bg = Panel:getChildByName("Image_bg") 
        local Image_window = Panel:getChildByName("Image_window") 
        local Panel_head = Panel:getChildByName("Panel_head") 
        Panel_head:removeAllChildren(true)
        local Text_genral = Panel:getChildByName("Text_genral") 
        
        local capacity = dms.int(dms["ship_mould"],id,ship_mould.capacity)
        local herocell = state_machine.excute("hero_icon_create_cell",0,{id,4,0})

        Image_window:setVisible(false)  
        Panel_head:addChild(herocell)
        Text_genral:setString(red_alert_hero_type_and_dec[capacity])
    end
end

--初始化界面默认选择第一个援军
function TrialtowerReinforcements:updateSelectPartner()
    local root = self.roots[1]
    local Panel = ccui.Helper:seekWidgetByName(root,"Panel_select_1")
    local Image_window = Panel:getChildByName("Image_window")
    Image_window:setVisible(true)
    state_machine.excute("trialtower_reinforcements_select_partner",0,
    {
        _datas = 
        {
            terminal_name = "trialtower_reinforcements_select_partner", 
            terminal_state = 0, 
            index = 1,
        }
    }
    )  
end

function TrialtowerReinforcements:setSelectPartner()
    local root = self.roots[1]
    for i = 1,3 do
        local Panel = ccui.Helper:seekWidgetByName(root,"Panel_select_"..i)
        local Image_window = Panel:getChildByName("Image_window")
        if i == self.select_index then
            Image_window:setVisible(true)
        else
            Image_window:setVisible(false)
        end
    end
end


function TrialtowerReinforcements:onEnterTransitionFinish()

end

function TrialtowerReinforcements:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.trialtower.trialtower_reinforcements)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_2"), nil, 
    {
        terminal_name = "trialtower_reinforcements_window_close", 
        terminal_state = 0, 
        index = 1 
    }, nil, 0)
    for i = 1,3 do
        --选择第i个援军
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_select_"..i), nil, 
        {
            terminal_name = "trialtower_reinforcements_select_partner", 
            terminal_state = 0, 
            index = i 
        }, nil, 0)
    end

    --确认选择
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_choose_hlep"), nil, 
    {
        terminal_name = "trialtower_reinforcements_select_sure", 
        terminal_state = 0, 
        index = 3 
    }, nil, 0)
    
	self:onUpdateDraw()	
    self:updateSelectPartner()   
end

function TrialtowerReinforcements:init(environment_ships)
    self.environment_ships = environment_ships
    self.ship_moulds = {}
    for i,v in pairs(self.environment_ships) do
        local ship_mould_id = dms.int(dms["environment_ship"],v,environment_ship.directing)
        table.insert(self.ship_moulds,ship_mould_id)
    end
	self:onInit()
    return self
end

function TrialtowerReinforcements:onExit()
    state_machine.remove("trialtower_reinforcements_select_partner")
    state_machine.remove("trialtower_reinforcements_select_sure")
end
