-----------------------------
--武将进阶
-----------------------------
HeroTalentActivation = class("HeroTalentActivationClass", Window)

local hero_talent_activation_window_open_terminal = {
    _name = "hero_talent_activation_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HeroTalentActivationClass")
        if nil == _Window then
            local ship = params._datas.cell.ship
            fwin:open(HeroTalentActivation:new():init(ship),fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local hero_talent_activation_window_close_terminal = {
    _name = "hero_talent_activation_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroTalentActivationClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_talent_activation_window_open_terminal)
state_machine.add(hero_talent_activation_window_close_terminal)
state_machine.init()

function HeroTalentActivation:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.ship = nil
    self.ship_str = ""
    self.prop_id = ""

    self.need_same_card_count = nil
    self.have_numbers = nil
    --需要的材料ID
    self.need_prop_id = nil
    --需求的材料数量
    self.need_prop_numbers = nil    
    --拥有的材料数量
    self.have_prop_numbers = nil
    --需要的金币
    self.need_silver = nil
    --拥有的金币
    self.have_silver = nil
    self.text_table = {}
    --天赋icon
    self.talent_pic = nil
    --天赋名
    self._talent_name = nil
	
	app.load("client.red_alert.hero.HeroStarActivationProperty")
    -- Initialize hero_talent_activation state machine.
    local function init_hero_talent_activation_terminal()

        --- 升星
        local hero_talent_activation_activa_terminal = {
            _name = "hero_talent_activation_activa",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local ship_id = instance.ship.ship_id
                local star_id = instance.star_id
                local text_table = instance.text_table
                local talent_pic = instance.talent_pic
                local talent_name = instance._talent_name
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("hero_talent_activation_close",0,"")
                        state_machine.excute("hero_main_update_draw",0,"")
                        state_machine.excute("hero_star_up_success_window_open",0,{text_table,talent_pic,talent_name})
                        pushEffect(formatMusicFile("effect", 10011))
                    end
                end
                for i,v in pairs(instance.ship.stars_state) do
                    if tonumber(v.state) == 0 then
                        TipDlg.drawTextDailog(red_alert_all_str[31])
                        return
                    end
                end
                if instance.have_numbers < instance.need_same_card_count or 
                    instance.have_prop_numbers < instance.need_prop_numbers then
                    TipDlg.drawTextDailog(red_alert_all_str[29])
                    return
                end
                if instance.have_silver < instance.need_silver then
                    TipDlg.drawTextDailog(red_alert_all_str[80])
                    return
                end
                protocol_command.ship_grow_up.param_list = ""..instance.ship.ship_id.."\r\n"..self.ship_str.."\r\n"..instance.prop_id.."\r\n".." ".."\r\n"
                NetworkManager:register(protocol_command.ship_grow_up.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 跳转
        local hero_talent_activation_goto_short_terminal = {
            _name = "hero_talent_activation_goto_short",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)    

                local fun_open_tab_id = dms.int(dms["build_mould"],8,build_mould.fun_open_tab_id)
                if funOpenDrawTip(fun_open_tab_id) == true then
                    return
                end
                local function recruitCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("mystery_shop_window_open",0,"")            
                    end
                end
                if _ED.secret_shop_init_info.os_time == nil or _ED.secret_shop_init_info.os_time == "" then
                    NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
                else
                    local times = os.time()- tonumber(_ED.secret_shop_init_info.os_time)
                    local leave_time = _ED.secret_shop_init_info.refresh_time/1000-times
                    if leave_time <= 0 then
                        NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, self, recruitCallBack, false, nil)
                    else
                        recruitCallBack({RESPONSE_SUCCESS = true,PROTOCOL_STATUS = 0})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        local hero_talent_activation_goto_short_the_same_hero_terminal = {
            _name = "hero_talent_activation_goto_short_the_same_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)    
                state_machine.excute("get_the_way_window_open",0,{13,instance.ship.ship_template_id,0,instance.ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        --关闭界面
        local hero_talent_activation_close_terminal = {
            _name = "hero_talent_activation_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onWindowClose()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(hero_talent_activation_activa_terminal)
        state_machine.add(hero_talent_activation_goto_short_terminal)
        state_machine.add(hero_talent_activation_close_terminal)
        state_machine.add(hero_talent_activation_goto_short_the_same_hero_terminal)
        state_machine.init()
    end
    
    -- call func init hero_talent_activation machine.
    init_hero_talent_activation_terminal()
end

function HeroTalentActivation:onUpdateDraw()
    local root = self.roots[1]

    
    local initial_rank_level = dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.initial_rank_level) + 1

    local rank_grow_up_limit = dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.rank_grow_up_limit)
    --临时特殊处理，针对于不能进阶的英雄
    if initial_rank_level > rank_grow_up_limit and rank_grow_up_limit ~= -1 then
        initial_rank_level = initial_rank_level - 1
    end

    if rank_grow_up_limit ~= -1 then
        initial_rank_level = initial_rank_level + 1
    end

    local talent_tab_str = dms.string(dms["ship_mould"],self.ship.ship_template_id,ship_mould.talent_id)
    local talent_tab = zstring.split(talent_tab_str,"|")
    local talent_id_table = talent_tab[initial_rank_level]
    local talent_id = zstring.split(talent_id_table,",")
    talent_id = talent_id[3]

    local talent_mould_data = dms.element(dms["talent_mould"],talent_id)
    local talent_name = dms.atos(talent_mould_data,talent_mould.talent_name)                    --天赋名称
    local talent_star_dec = dms.atos(talent_mould_data,talent_mould.talent_star_dec)            --星级描述
    local talent_describe = dms.atos(talent_mould_data,talent_mould.talent_describe)            --天赋描述
    local base_additional = dms.atos(talent_mould_data,talent_mould.base_additional)            --基本属性加成
    local talent_pic = dms.atoi(talent_mould_data,talent_mould.talent_pic)                      --图片索引
    local talent_star_quality = dms.atoi(talent_mould_data,talent_mould.talent_star_quality)    --星级品质
    
    local Panel_hero_star_activation_icon = ccui.Helper:seekWidgetByName(root,"Panel_hero_star_activation_icon")
    Panel_hero_star_activation_icon:setBackGroundImage("images/ui/talent_icon/talent_icon_".. talent_pic .. ".png")
    local Text_hero_star_activation_name = ccui.Helper:seekWidgetByName(root,"Text_hero_star_activation_name")
    Text_hero_star_activation_name:setString(talent_name)
    Text_hero_star_activation_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[talent_star_quality+1][1],tipStringInfo_quality_color_Type[talent_star_quality+1][2],tipStringInfo_quality_color_Type[talent_star_quality+1][3]))
    local Panel_hero_star_activation_9 = ccui.Helper:seekWidgetByName(root,"Panel_hero_star_activation_9")      --星格附加属性面板
	if Panel_hero_star_activation_9~= nil then
		Panel_hero_star_activation_9:removeAllChildren(true)
		state_machine.excute("hero_star_activation_property_window_open",0,{Panel_hero_star_activation_9,talent_id,true})
	else
		local Text_hero_talent_activation = ccui.Helper:seekWidgetByName(root,"Text_hero_talent_activation")
		Text_hero_talent_activation:setString(talent_describe)
	end

    local required_material_id = dms.string(dms["ship_mould"],self.ship.ship_template_id,ship_mould.required_material_id)
    local ship_grow_requirement_data = dms.element(dms["ship_grow_requirement"], required_material_id)
    local need_prop1 = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_prop1)
    local need_prop1_count = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_prop1_count)
    local need_silver = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_silver)
    local need_same_card_count = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_same_card_count)
    self.need_prop_id = need_prop1
    self.need_same_card_count = need_same_card_count
    self.have_numbers = self:getShipNumber(need_same_card_count)
    self.need_prop_numbers = need_prop1_count    
    self.have_prop_numbers = tonumber(self:getPropNumber(need_prop1))
    self.need_silver = need_silver
    self.have_silver = tonumber(_ED.user_info.user_silver)
    self.talent_pic = talent_pic
    self._talent_name = talent_name
    local Panel_hero_star_material = ccui.Helper:seekWidgetByName(root,"Panel_hero_star_material")
    local Panel_hero_star_hero = ccui.Helper:seekWidgetByName(root,"Panel_hero_star_hero")
    Panel_hero_star_hero:removeAllChildren(true)
    local Text_hero_star_gold_have = ccui.Helper:seekWidgetByName(root,"Text_hero_star_gold_have")
    local Text_hero_star_material_number = ccui.Helper:seekWidgetByName(root,"Text_hero_star_material_number")
        Text_hero_star_material_number:setColor(cc.c3b(shop_buy_color_Type[1][1],shop_buy_color_Type[1][2],shop_buy_color_Type[1][3]))
    local Text_hero_up_star_have = ccui.Helper:seekWidgetByName(root,"Text_hero_up_star_have") -- 拥有丹的数量
    local Text_hero_star_gold_number = ccui.Helper:seekWidgetByName(root,"Text_hero_star_gold_number") -- 需要丹的数量
    if need_silver > 0 then
        Text_hero_star_material_number:setString("x"..need_silver)
        Text_hero_star_gold_have:setVisible(false)
        Panel_hero_star_material:setBackGroundImage("images/ui/icon/icon_gold.png")
    end
    if need_same_card_count > 0 then
        -- local Button_hero_star_dropped = ccui.Helper:seekWidgetByName(root,"Button_hero_star_dropped")
        -- Button_hero_star_dropped:setVisible(true)
        local data = 
        {
            item_value = 1,
            prop_type = 13,
            prop_item = self.ship.ship_template_id
        }
        local cell = state_machine.excute("all_resource_create_cell",0,{7,data,data,8,0,false,false})
        Panel_hero_star_material:removeBackGroundImage()
        cell:setScale(0.5,0.5)
        Panel_hero_star_hero:addChild(cell)
        Text_hero_star_gold_have:setVisible(true)
        Text_hero_star_gold_have:setString(string.format(red_alert_all_str[18],self.have_numbers))
        Text_hero_star_material_number:setString("x"..need_same_card_count)
        Text_hero_star_gold_number:setString("x"..need_prop1_count)
        Text_hero_up_star_have:setString(string.format(red_alert_all_str[18],self.have_prop_numbers))
    else
        Text_hero_up_star_have:setString(string.format(red_alert_all_str[18],self.have_prop_numbers))
        Text_hero_star_gold_number:setString("x"..need_prop1_count)
    end

    self.text_table = {}
    if base_additional ~= "-1" then
        base_additional = zstring.split(base_additional,"|")
        for i,v in ipairs(base_additional) do
            local data = zstring.split(v,",")
            local types = tonumber(data[1]) +1
            local adds = data[2]
            table.insert(self.text_table,attribute[types] .. "+" .. adds)
        end
    end
    if self.have_silver < self.need_silver then
        Text_hero_star_material_number:setColor(cc.c3b(shop_buy_color_Type[2][1],shop_buy_color_Type[2][2],shop_buy_color_Type[2][3]))
    end
end

function HeroTalentActivation:getShipNumber(need_same_card_count)
    local have_numbers = 0
    local ship_str = ""
    for i,ship in pairs(_ED.user_ship) do
        if ship.ship_base_template_id == self.ship.ship_base_template_id and ship.ship_id ~= self.ship.ship_id 
            and zstring.tonumber(ship.formation_index) == 0
            and zstring.tonumber(ship.little_partner_formation_index) == 0
            then
            have_numbers = have_numbers + 1 
            if have_numbers == need_same_card_count then
                ship_str = ship_str.. ship.ship_id
            elseif have_numbers < need_same_card_count then
                ship_str = ship_str.. ship.ship_id .. ","
            end
        end
    end
    self.ship_str = ship_str
    return have_numbers
end

function HeroTalentActivation:getPropNumber(need_prop1)
    for i,prop in pairs(_ED.user_prop) do
        if tonumber(prop.user_prop_template) == need_prop1 then
            self.prop_id = prop.user_prop_id
            return prop.prop_number
        end
    end
    return 0
end

function HeroTalentActivation:onEnterTransitionFinish()

end

-- 关闭天赋界面
function HeroTalentActivation:onWindowClose()
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("window_close", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_close_over" then
            state_machine.excute("hero_talent_activation_window_close", 0, "")
        end
    end)
end

function HeroTalentActivation:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_talent_activation)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.hero.hero_talent_activation)
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("window_open", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        if frame == "window_open_over" then
            
        end
    end)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_star_activation_close"), nil, 
    {
        terminal_name = "hero_talent_activation_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_hero_star_activation_1"), nil, 
    {
        terminal_name = "hero_talent_activation_close", 
        terminal_state = 0, 
    }, nil, 0)

    --激活
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_star_activation_back"), nil, 
    {
        terminal_name = "hero_talent_activation_activa", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    
    
    -- 跳转获取材料  
    local Button_hero_star_material_dropped_1 = ccui.Helper:seekWidgetByName(root,"Button_hero_star_material_dropped_1")
    Button_hero_star_material_dropped_1:setVisible(false)
    -- local Button_hero_star_dropped = ccui.Helper:seekWidgetByName(root,"Button_hero_star_dropped")
    -- Button_hero_star_dropped:setVisible(false)
    if funOpenDrawTip(101,false) == false then 
        Button_hero_star_material_dropped_1:setVisible(true)
        -- Button_hero_star_dropped:setVisible(true)
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_star_material_dropped_1"), nil, 
    {
        -- func_string = [[funOpenDrawTip(101)]],
        terminal_name = "hero_talent_activation_goto_short",
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)   

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_star_dropped"), nil, 
    {
        -- func_string = [[funOpenDrawTip(101)]],
        terminal_name = "hero_talent_activation_goto_short_the_same_hero",
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    
    self:onUpdateDraw()
end

function HeroTalentActivation:init(ship)
    self.ship = ship
    self:onInit()
    return self
end

function HeroTalentActivation:onExit()
    state_machine.remove("hero_talent_activation_activa")
    state_machine.remove("hero_talent_activation_goto_short")
    state_machine.remove("hero_talent_activation_close")
    state_machine.remove("hero_talent_activation_goto_short_the_same_hero")
end
