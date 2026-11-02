-----------------------------
--星格
-----------------------------
HeroStarActivation = class("HeroStarActivationClass", Window)

--打开星格界面
local hero_star_activation_window_open_terminal = {
    _name = "hero_star_activation_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("hero_star_activation_window_close",0,"")
        local _Window = fwin:find("HeroStarActivationClass")
        if nil == _Window then
            local ship = params[1]
            local index = params[2]
            fwin:open(HeroStarActivation:new():init(ship,index),fwin._ui)
        end
        state_machine.excute("hero_star_activation_window_show",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭星格界面
local hero_star_activation_window_close_terminal = {
    _name = "hero_star_activation_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroStarActivationClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_star_activation_window_open_terminal)
state_machine.add(hero_star_activation_window_close_terminal)
state_machine.init()

function HeroStarActivation:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- load lua file
    app.load("client.red_alert.hero.HeroStarActivationProperty")
    
    --var
    --npcid
    self.ship = nil
    self.index = nil
    --星格需求道具数量
    self.need_prop_numbers = nil
    --星格需求道具拥有数量
    self.have_prop_numbers = nil
    --星格需求金币
    self.need_silver_numbers = nil
    --角色拥有金币总数
    self.have_silver_numbers = nil
    --星格附加属性
    self.text_table = {}
    --星格需求道具
    self.prop_mould_id = nil
    self.need_prop_numbers = nil
    -- Initialize hero_star_activation state machine.
    local function init_hero_star_activation_terminal()

        --- 激活
        local hero_star_activation_activa_terminal = {
            _name = "hero_star_activation_activa",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local ship_id = self.ship.ship_id
                local star_id = self.star_id
                local text_table = self.text_table
                local index = self.index
                -- debug.print_r(text_table)
                -- print("=========index======",index)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- TipDlg.drawTextDailog(red_alert_all_str[28])
                        state_machine.excute("hero_star_activation_close",0,"")

                        state_machine.excute("hero_main_change_ship",0,"")
                        state_machine.excute("add_number_window_open",0,{index,text_table})
                        state_machine.excute("hero_main_star_up_play_success_action",0,{index})
                        playEffect(formatMusicFile("effect", 9998))
                    end
                end
                if instance.have_prop_numbers < instance.need_prop_numbers then
                    TipDlg.drawTextDailog(red_alert_all_str[29])
                    return
                end
                if instance.have_silver_numbers <  instance.need_silver_numbers then
                    TipDlg.drawTextDailog(red_alert_all_str[80])
                    return
                end
                protocol_command.lighten_star.param_list = ship_id.."\r\n"..star_id
                NetworkManager:register(protocol_command.lighten_star.code, nil, nil, nil, nil, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --- 跳转
        local hero_star_activation_goto_short_terminal = {
            _name = "hero_star_activation_goto_short",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local  prop = fundPropWidthId(instance.prop_mould_id)
                if prop == nil then
                    item_value = 0
                else
                    item_value= prop.prop_number
                end
                state_machine.excute("get_the_way_window_open",0,{6,instance.prop_mould_id,item_value})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        --显示界面
        local hero_star_activation_window_show_terminal = {
            _name = "hero_star_activation_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --隐藏界面
        local hero_star_activation_window_hide_terminal = {
            _name = "hero_star_activation_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --刷新界面
        local hero_star_activation_updatedraw_terminal = {
            _name = "hero_star_activation_updatedraw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --关闭界面
        local hero_star_activation_close_terminal = {
            _name = "hero_star_activation_close",
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

        state_machine.add(hero_star_activation_activa_terminal)
        state_machine.add(hero_star_activation_goto_short_terminal)
        state_machine.add(hero_star_activation_window_show_terminal)
        state_machine.add(hero_star_activation_window_hide_terminal)
        state_machine.add(hero_star_activation_updatedraw_terminal)
        state_machine.add(hero_star_activation_close_terminal)
        state_machine.init()
    end
    
    -- call func init hero_star_activation machine.
    init_hero_star_activation_terminal()
end

--更新星格界面
function HeroStarActivation:onUpdateDraw()
    local root = self.roots[1]

    local star_id = self.star_id
    local star_data = dms.element(dms["star_mould"],star_id)                    --星格配置
    local star_pic = dms.atoi(star_data,star_mould.star_pic)                    --星格图标
    local star_name = dms.atos(star_data,star_mould.star_name)                  --星格名称
    local property = dms.atos(star_data,star_mould.property)                    --星格附加属性
    local need_prop1 = dms.atoi(star_data,star_mould.need_prop1)                --星格需求道具
    local need_prop1_count = dms.atoi(star_data,star_mould.need_prop1_count)    --星格需求道具数量
    local need_silver1 = dms.atoi(star_data,star_mould.need_silver1)            --星格需求金币
    local star_quality = dms.atoi(star_data,star_mould.star_quality)            --星格品质
    self.prop_mould_id = need_prop1
    self.need_prop_numbers = need_prop1_count
    local Text_hero_star_activation_name = ccui.Helper:seekWidgetByName(root,"Text_hero_star_activation_name")  --星格名称
    Text_hero_star_activation_name:setString(star_name)
    Text_hero_star_activation_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[star_quality+1][1],tipStringInfo_quality_color_Type[star_quality+1][2],tipStringInfo_quality_color_Type[star_quality+1][3]))

    local Text_hero_star_material_number = ccui.Helper:seekWidgetByName(root,"Text_hero_star_material_number")   --星格需求道具数量
    Text_hero_star_material_number:setString("x"..need_prop1_count)

    local Text_hero_star_gold_number_0 = ccui.Helper:seekWidgetByName(root,"Text_hero_star_gold_number_0")       --星格需求道具拥有数量
    local prop_numbers = 0  
    for i,prop in pairs(_ED.user_prop) do
        if tonumber(prop.user_prop_template) == need_prop1 then
            prop_numbers = prop.prop_number
            break
        end
    end 

    self.need_prop_numbers = need_prop1_count
    self.have_prop_numbers = tonumber(prop_numbers)
    self.need_silver_numbers = need_silver1
    self.have_silver_numbers = tonumber(_ED.user_info.user_silver)
    local Panel_hero_star_material = ccui.Helper:seekWidgetByName(root,"Panel_hero_star_material")              --星格需求道具图标
    local pic_index = dms.int(dms["prop_mould"],need_prop1,prop_mould.pic_index)
    Panel_hero_star_material:setBackGroundImage("images/ui/props/props_".. pic_index .. ".png" )
    Text_hero_star_gold_number_0:setString(string.format(red_alert_all_str[18],prop_numbers))
    local Text_hero_star_gold_number = ccui.Helper:seekWidgetByName(root,"Text_hero_star_gold_number")          --星格需求金币
    Text_hero_star_gold_number:setString(need_silver1)
    Text_hero_star_gold_number:setColor(cc.c3b(shop_buy_color_Type[1][1],shop_buy_color_Type[1][2],shop_buy_color_Type[1][3]))
    local Panel_hero_star_activation_icon = ccui.Helper:seekWidgetByName(root,"Panel_hero_star_activation_icon")--星格图标
    Panel_hero_star_activation_icon:setBackGroundImage("images/ui/skills_icon/skills_icon_".. star_pic .. ".png")

    local Panel_hero_star_activation_9 = ccui.Helper:seekWidgetByName(root,"Panel_hero_star_activation_9")      --星格附加属性面板
    Panel_hero_star_activation_9:removeAllChildren(true)
    state_machine.excute("hero_star_activation_property_window_open",0,{Panel_hero_star_activation_9,star_id})

    property = zstring.split(property,"|")
    self.text_table = {}
    for i,v in ipairs(property) do
        local data = zstring.split(v,",")
        local types = tonumber(data[1]) +1
        local adds = data[2]
        table.insert(self.text_table,attribute[types] .. "+" .. adds)
    end
    if self.have_silver_numbers < self.need_silver_numbers then
        Text_hero_star_gold_number:setColor(cc.c3b(shop_buy_color_Type[2][1],shop_buy_color_Type[2][2],shop_buy_color_Type[2][3]))
    end
end

function HeroStarActivation:onEnterTransitionFinish()

end

--隐藏界面
function HeroStarActivation:onHide()
    self:setVisible(false)
end

--显示界面
function HeroStarActivation:onShow()
    self:setVisible(true)
end

-- 关闭星格界面
function HeroStarActivation:onWindowClose()
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("window_close", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_close_over" then
            state_machine.excute("hero_star_activation_window_close", 0, "")
        end
    end)
end

--初始化星格界面
function HeroStarActivation:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_star_activation)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.hero.hero_star_activation)
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
        terminal_name = "hero_star_activation_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_hero_star_activation_1"), nil, 
    {
        terminal_name = "hero_star_activation_close", 
        terminal_state = 0, 
    }, nil, 0)

    --激活
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_star_activation_back"), nil, 
    {
        terminal_name = "hero_star_activation_activa", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    
    
    -- 跳转获取材料  
    local Button_hero_star_material_dropped = ccui.Helper:seekWidgetByName(root,"Button_hero_star_material_dropped")
    Button_hero_star_material_dropped:setVisible(false)
    if funOpenDrawTip(101,false) == false then 
        Button_hero_star_material_dropped:setVisible(true)
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_star_material_dropped"), nil, 
    {
        -- func_string = [[funOpenDrawTip(101)]],
        terminal_name = "hero_star_activation_goto_short", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    self:onUpdateDraw()
end

--初始化
function HeroStarActivation:init(ship,index)
    self.ship = ship
    self.index = index
    self.star_id = self.ship.stars_state[index].star_id
    self:onInit()
    return self
end

--移除状态机
function HeroStarActivation:onExit()
    state_machine.remove("hero_star_activation_activa")
    state_machine.remove("hero_star_activation_goto_short")
    state_machine.remove("hero_star_activation_window_show")
    state_machine.remove("hero_star_activation_window_hide")
    state_machine.remove("hero_star_activation_updatedraw")
    state_machine.remove("hero_star_activation_close")
end
