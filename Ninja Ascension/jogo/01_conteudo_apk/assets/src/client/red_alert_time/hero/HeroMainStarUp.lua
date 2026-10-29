-----------------------------
--英雄升星子界面
-----------------------------
HeroMainStarUp = class("HeroMainStarUpClass", Window)

--打开界面
local hero_main_star_up_window_open_terminal = {
    _name = "hero_main_star_up_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HeroMainStarUpClass")
        if nil == _Window then
            fwin:open(HeroMainStarUp:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_main_star_up_window_open_terminal)
state_machine.init()

function HeroMainStarUp:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
    app.load("client.red_alert_time.hero.HeroStarActivation")
    app.load("client.red_alert_time.hero.HeroTalentActivation")

    --var
    self.ship = nil
    --是否打开子界面
    self.open_window = false
    --天赋icon
    self._talent_pic = nil 
    --星格附加属性
    self._text_table_talent = {}
    --天赋名
    self._talent_name = nil

    -- Initialize hero_main_grow_up state machine.
    local function init_hero_main_star_up_terminal()
    
        --显示界面
        local hero_main_star_up_window_show_terminal = {
            _name = "hero_main_star_up_window_show",
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
        local hero_main_star_up_window_hide_terminal = {
            _name = "hero_main_star_up_window_hide",
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

        --改变英雄 刷新
        local hero_main_star_up_change_ship_terminal = {
            _name = "hero_main_star_up_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if params ~= "" and params ~= nil then
                    instance.ship = params 
                end
                instance:onUpdateDrawProp()
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --打开星格激活窗口
        local hero_main_star_up_open_upstar_window_terminal = {
            _name = "hero_main_star_up_open_upstar_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params._datas.star_index
                local ship = instance.ship
                state_machine.excute("hero_star_activation_window_open",0,{ship,index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

         --星格激活成功调用动画
        local hero_main_star_up_play_success_action_terminal = {
            _name = "hero_main_star_up_play_success_action",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params[1]
                instance:playStarSuccess(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --星格动画是显示天赋
        local hero_main_star_up_show_attributes_terminal = {
            _name = "hero_main_star_up_show_attributes",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:showAttributesIcon()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        --一键升星
        local hero_main_star_up_one_key_lighten_star_terminal = {
            _name = "hero_main_star_up_one_key_lighten_star",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local ship = instance.ship
                local ship_id = ship.ship_id
                local talent_pic = instance._talent_pic
                local talent_name = instance._talent_name
                local last_rank_level = dms.int(dms["ship_mould"],instance.ship.ship_template_id,ship_mould.initial_rank_level)
                local last_star = ship.stars_state
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local new_ship = _ED.user_ship[""..ship_id]
                        local now_rank_level = dms.int(dms["ship_mould"],new_ship.ship_template_id,ship_mould.initial_rank_level)
                        local now_star = ship.stars_state
                        if last_rank_level < now_rank_level then  --可以升阶
                            if response.node ~= nil and response.node.getAllStarAndTalentAddPro ~= nil then
                                local text_table = instance:getAllStarAndTalentAddPro(last_star)
                                state_machine.excute("hero_star_up_success_window_open",0,{text_table,talent_pic,talent_name})
                            end
                        else        --不能升阶
                            state_machine.excute("hero_main_change_ship",0,"")
                            if response.node ~= nil and response.node.getAllStarAddPro ~= nil then
                                local text_table = instance:getAllStarAddPro(last_star,now_star)
                                state_machine.excute("add_number_window_open",0,{7,text_table})
                            end
                        end
                        playEffect(formatMusicFile("effect", 9998))
                        state_machine.excute("hero_main_update_draw",0,"")
                    end
                end
                protocol_command.one_key_lighten_star.param_list = ship_id.."\r\n"
                NetworkManager:register(protocol_command.one_key_lighten_star.code, nil, nil, nil, instance, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 打开武学信息界面
        local hero_main_star_up_open_talent_look_window_terminal = {
            _name = "hero_main_star_up_open_talent_look_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- app.load("client.red_alert_time.hero.HeroMainSkillsUpWindow")
                -- state_machine.excute("hero_main_skills_up_window_window_open", 0, {params._datas.cell.ship})
                app.load("client.red_alert_time.hero.HeroMainStarUpWindow")
                state_machine.excute("hero_main_star_up_window_window_open", 0, {1, params._datas.cell.ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
 
        state_machine.add(hero_main_star_up_window_show_terminal)   
        state_machine.add(hero_main_star_up_window_hide_terminal)
        state_machine.add(hero_main_star_up_change_ship_terminal)
        state_machine.add(hero_main_star_up_open_upstar_window_terminal)
        state_machine.add(hero_main_star_up_play_success_action_terminal)
        state_machine.add(hero_main_star_up_show_attributes_terminal)
        state_machine.add(hero_main_star_up_one_key_lighten_star_terminal) 
        state_machine.add(hero_main_star_up_open_talent_look_window_terminal) 
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_hero_main_star_up_terminal()
end

-- 一键升星(不能升阶)
function HeroMainStarUp:getAllStarAddPro(last_star,now_star)
    local text_table = {}
    local last_state = 1
    local now_state = 1
    for i,v in pairs(last_star) do
        last_state = v.state
    end
    local table_index = {}
    for i,v in ipairs(now_star) do
        now_state = v.state
        if tonumber(last_state) == 0 and tonumber(now_state) == 1 then 
            table.insert(table_index,i)
            local star_id = v.star_id
            local star_data = dms.element(dms["star_mould"],star_id) 
            local property = dms.atos(star_data,star_mould.property)
            property = zstring.split(property,"|")
            for j,k in ipairs(property) do
                data = zstring.split(k,",")
                types = tonumber(data[1]) +1
                adds = data[2]
                table.insert(text_table,attribute[types] .. "+" .. adds)
            end
        end
    end
    for i,v in ipairs(table_index) do
        state_machine.excute("hero_main_star_up_play_success_action",0,{v})
    end
    return text_table
end

-- 一键升星(可以升阶)
function HeroMainStarUp:getAllStarAndTalentAddPro(last_star)
    local text_table = {}
    for i,v in pairs(self._text_table_talent) do
        table.insert(text_table,v)
    end
    local table_index = {}
    for i,v in pairs(last_star) do
        local star_id = v.star_id
        local star_data = dms.element(dms["star_mould"],star_id) 
        local property = dms.atos(star_data,star_mould.property)
        property = zstring.split(property,"|")
        for j,k in ipairs(property) do
            local data = zstring.split(k,",")
            local types = tonumber(data[1]) +1
            local adds = data[2]
            if tonumber(v.state) == 0 then 
                table.insert(table_index,i)
                table.insert(text_table,attribute[types] .. "+" .. adds)
            end
        end
    end
    for i,v in ipairs(table_index) do
        state_machine.excute("hero_main_star_up_play_success_action",0,{v})
    end
    return text_table
end

function HeroMainStarUp:onHide()
    self:setVisible(false)
end

function HeroMainStarUp:onShow()
    self:setVisible(true)
end

function HeroMainStarUp:playStarSuccess(index)
    local root = self.roots[1]
    local Button_attributes_icon = ccui.Helper:seekWidgetByName(root,"Button_attributes_icon_"..index)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_hero_up_success/effice_hero_up_success.ExportJson")

    local armature = ccs.Armature:create("effice_hero_up_success")
    armature:setPosition(cc.p(Button_attributes_icon:getPositionX(), Button_attributes_icon:getPositionY()))
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)  
    root:addChild(armature)
    armature:getAnimation():playWithIndex(0,0,0)
    armature._invoke = function(armatureBack)
        armature:removeFromParent(true)
    end
end

--刷新天赋等级
function HeroMainStarUp:onUpdateDraw()
    local root = self.roots[1]
    local stars,stars_level = self:getHeroStars()
    local Text_talent = ccui.Helper:seekWidgetByName(root,"Text_talent")        --天赋等级
    -- Text_talent:setString(color_type_to_chinese[stars_level]..red_alert_stars_index[stars])
    Text_talent:setString(self._talent_name)
    Text_talent:setColor(cc.c3b(tipStringInfo_quality_color_Type[stars_level+1][1],tipStringInfo_quality_color_Type[stars_level+1][2],tipStringInfo_quality_color_Type[stars_level+1][3]))
end

--更新画面
function HeroMainStarUp:onUpdateDrawProp()
    local root = self.roots[1]
    local can_up_star = true
    local star_id_tab = self.ship.stars_state
    local Button_attributes_icon_fit = ccui.Helper:seekWidgetByName(root,"Button_attributes_icon_fit")    --天赋按钮
    local Button_one_step = ccui.Helper:seekWidgetByName(root,"Button_one_step")                          --一键升星
    Button_one_step:setVisible(false)
    -- print("=======mould_id",self.ship.ship_template_id)
    local last_ship_mould = tonumber(self.ship.ship_template_id) - 1
    local last_stars_id_table = dms.string(dms["ship_mould"],last_ship_mould,ship_mould.star_id_tab)
    if last_stars_id_table ~= nil then 
        self.last_stars_id_table = zstring.split(last_stars_id_table,",")
    end

    for i,v in pairs(star_id_tab) do
        local star_id = v.star_id
        if zstring.tonumber(star_id) == -1 or zstring.tonumber(star_id) == 0 then
            Button_attributes_icon_fit:setTouchEnabled(false)
            local state = 1
            local star_data = dms.element(dms["star_mould"],self.last_stars_id_table[i])
            local star_pic = dms.atoi(star_data,star_mould.star_pic)
            local star_name = dms.atoi(star_data,star_mould.star_name)
            local property = dms.atos(star_data,star_mould.property)
            local need_prop1 = dms.atoi(star_data,star_mould.need_prop1)
            local need_prop1_count = dms.atoi(star_data,star_mould.need_prop1_count)
            local need_silver1 = dms.atoi(star_data,star_mould.need_silver1)
            local Button_attributes_icon = ccui.Helper:seekWidgetByName(root,"Button_attributes_icon_"..i)      --星格按钮
            local Sprite_attributes_icon = Button_attributes_icon:getChildByName("Sprite_attributes_icon_"..i)  --星格icon
            Sprite_attributes_icon:setTexture("images/ui/skills_icon/skills_icon_".. star_pic .. ".png")
            Button_attributes_icon:setTouchEnabled(true)
            local Panel_can_activate = ccui.Helper:seekWidgetByName(root,"Panel_can_activate_"..i)
            local actions = cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.5,1.05),cc.ScaleTo:create(0.5,1)))
            if tonumber(state) == 1 then
                display:ungray(Sprite_attributes_icon)
                -- Button_attributes_icon:setTouchEnabled(false)
                Button_attributes_icon:stopAllActions()
                Panel_can_activate:setVisible(false)
            end  
        else
            Button_attributes_icon_fit:setTouchEnabled(true)
            local state = v.state
            local star_data = dms.element(dms["star_mould"],star_id)
            local star_pic = dms.atoi(star_data,star_mould.star_pic)
            local star_name = dms.atoi(star_data,star_mould.star_name)
            local property = dms.atos(star_data,star_mould.property)
            local need_prop1 = dms.atoi(star_data,star_mould.need_prop1)
            local need_prop1_count = dms.atoi(star_data,star_mould.need_prop1_count)
            local need_silver1 = dms.atoi(star_data,star_mould.need_silver1)
            local Button_attributes_icon = ccui.Helper:seekWidgetByName(root,"Button_attributes_icon_"..i)      --星格按钮
            local Sprite_attributes_icon = Button_attributes_icon:getChildByName("Sprite_attributes_icon_"..i)  --星格icon
            Sprite_attributes_icon:setTexture("images/ui/skills_icon/skills_icon_".. star_pic .. ".png")
            Button_attributes_icon:setTouchEnabled(true)
            local Panel_can_activate = ccui.Helper:seekWidgetByName(root,"Panel_can_activate_"..i)
            local actions = cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.5,1.05),cc.ScaleTo:create(0.5,1)))
            if tonumber(state) == 1 then
                display:ungray(Sprite_attributes_icon)
                -- Button_attributes_icon:setTouchEnabled(false)
                Button_attributes_icon:stopAllActions()
                Panel_can_activate:setVisible(false)
            else
                can_up_star = false
                display:gray(Sprite_attributes_icon)
                -- Button_attributes_icon:setTouchEnabled(true)
                if self:checkNeedPush(need_prop1,need_prop1_count,need_silver1) == true then
                    Button_attributes_icon:runAction(actions)
                    Panel_can_activate:setVisible(true)
                    Button_one_step:setVisible(true)
                else
                    Button_attributes_icon:stopAllActions()
                    Panel_can_activate:setVisible(false)
                end
            end      
        end
        
    end

    local required_material_id = dms.string(dms["ship_mould"],self.ship.ship_template_id,ship_mould.required_material_id)   --进阶需求索引
    local initial_rank_level = dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.initial_rank_level) + 1      --初始进阶等级
    local rank_grow_up_limit = dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.rank_grow_up_limit)          --进阶等级上限
    --临时特殊处理，针对于不能进阶的英雄
    -- print("=======rank_grow_up_limit==",initial_rank_level,rank_grow_up_limit,rank_grow_up_limit)
    local is_max_rank_level = false
    if initial_rank_level > rank_grow_up_limit and rank_grow_up_limit ~= -1 then
        initial_rank_level = initial_rank_level - 1
        is_max_rank_level = true
    end
    if rank_grow_up_limit ~= -1 then
        initial_rank_level = initial_rank_level + 1
    end

    local talent_tab_str = dms.string(dms["ship_mould"],self.ship.ship_template_id,ship_mould.talent_id)    --天赋模板ID
    -- print("========talent_tab_str",talent_tab_str)
    local talent_tab = zstring.split(talent_tab_str,"|")
    local talent_id_table = talent_tab[initial_rank_level]
    local talent_id = zstring.split(talent_id_table,",")
    talent_id = talent_id[3]
    -- debug.print_r(self.ship)
    -- print("=========talent_id",talent_id)
    local talent_mould_data = dms.element(dms["talent_mould"],talent_id)    
    local talent_name = dms.atos(talent_mould_data,talent_mould.talent_name)        --天赋名称
    local talent_describe = dms.atos(talent_mould_data,talent_mould.talent_describe)--天赋描述
    local base_additional = dms.atos(talent_mould_data,talent_mould.base_additional)--基本属性加成
    local talent_pic = dms.atoi(talent_mould_data,talent_mould.talent_pic)          --图片索引
    self._talent_pic = talent_pic
    self._talent_name = talent_name
    self._text_table_talent = {}
    if base_additional ~= "-1" then
        base_additional = zstring.split(base_additional,"|")
        for i,v in ipairs(base_additional) do
            local data = zstring.split(v,",")
            local types = tonumber(data[1]) +1
            local adds = data[2]
            table.insert(self._text_table_talent,attribute[types] .. "+" .. adds)
        end
    end
    local ship_grow_requirement_data = dms.element(dms["ship_grow_requirement"], required_material_id)

    local star_up_need_prop = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_prop1)                 --需求的材料
    local star_up_need_count = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_prop1_count)          --需求的材料数量
    local star_up_need_silver = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_silver)              --需求的金币
    local need_same_card_count = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_same_card_count)    --需求同ID武将数量
    local Sprite_attributes_icon_fit = Button_attributes_icon_fit:getChildByName("Sprite_attributes_icon_fit")      --天赋icon
    local Panel_can_activate_fit = ccui.Helper:seekWidgetByName(root,"Panel_can_activate_fit")                      --可铭刻动画
    local actions = cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.5,1.05),cc.ScaleTo:create(0.5,1)))
    Sprite_attributes_icon_fit:setTexture("images/ui/talent_icon/talent_icon_".. talent_pic .. ".png")
    display:gray(Sprite_attributes_icon_fit)
    if can_up_star == true and 
        self:checkNeedStarupPush(star_up_need_prop,
                                star_up_need_count,
                                star_up_need_silver,
                                need_same_card_count
                                ) == true then   
        Panel_can_activate_fit:setVisible(true)
        Button_attributes_icon_fit:runAction(actions)
        Button_one_step:setVisible(true)
    else
        Button_attributes_icon_fit:stopAllActions()
        Panel_can_activate_fit:setVisible(false)
    end

    if is_max_rank_level == true then
        display:ungray(Sprite_attributes_icon_fit)
    end

end

--显示天赋Icon
function HeroMainStarUp:showAttributesIcon()
    local root = self.roots[1]
    local Button_attributes_icon_fit = ccui.Helper:seekWidgetByName(root,"Button_attributes_icon_fit")          --天赋按钮
    local Panel_can_activate_fit = ccui.Helper:seekWidgetByName(root,"Panel_can_activate_fit")                  --可铭刻动画
    Button_attributes_icon_fit:stopAllActions()
    Panel_can_activate_fit:setVisible(false)
    local Sprite_attributes_icon_fit = Button_attributes_icon_fit:getChildByName("Sprite_attributes_icon_fit")  --天赋icon
    Sprite_attributes_icon_fit:setTexture("images/ui/talent_icon/talent_icon_".. self._talent_pic .. ".png")
    display:ungray(Sprite_attributes_icon_fit)
end

--检查是否需要启动天赋动画
function HeroMainStarUp:checkNeedStarupPush(prop_mould_id , need_count ,need_silver,need_ship_numbers)
    local now_have_prop = false
    for i,prop in pairs(_ED.user_prop) do
        if tonumber(prop.user_prop_template) == prop_mould_id then
            if tonumber(prop.prop_number) >= need_count and tonumber(_ED.user_info.user_silver) >= need_silver then
                now_have_prop = true
            else
                return false
            end
        end
    end

    if now_have_prop == false then
        return false
    end
    
    local ship_numbers = 0
    for i,ship in pairs(_ED.user_ship) do
        if ship.ship_base_template_id == self.ship.ship_base_template_id and ship.ship_id ~= self.ship.ship_id
            and zstring.tonumber(ship.formation_index) == 0
            and zstring.tonumber(ship.little_partner_formation_index) == 0
            then
            ship_numbers = ship_numbers + 1
        end
    end
    if ship_numbers >= need_ship_numbers then
    else
        return false
    end
    return true
end

--检查是否需要启动星格动画
function HeroMainStarUp:checkNeedPush(prop_mould_id , need_count , need_silver)
    for i,prop in pairs(_ED.user_prop) do
        if tonumber(prop.user_prop_template) == prop_mould_id then
            if tonumber(prop.prop_number) >= need_count and tonumber(_ED.user_info.user_silver) >= need_silver then
                return true
            else
                return false
            end
        end
    end
    return false
end

function HeroMainStarUp:getHeroStars() --下一级的
    local initial_rank_level = dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.initial_rank_level) + 1
    if zstring.tonumber(self.ship.stars_state[1].star_id) < 0 then
        initial_rank_level = initial_rank_level -1 
    end
    local stars = 0
    local stars_level = 0
    -- 0 1 2 3 4 5 6 7 8 9 10 11 12 
    if initial_rank_level == 0 then
        return stars , stars_level
    end
    if initial_rank_level % 3 == 0 then
        stars_level = initial_rank_level / 3
        stars = 3
        return stars , stars_level
    else
        stars_level = math.floor(initial_rank_level / 3) + 1
        stars = initial_rank_level % 3
        return stars , stars_level
    end
end

function HeroMainStarUp:onEnterTransitionFinish()

end

--初始化界面
function HeroMainStarUp:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_main_star_up)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local last_ship_mould = tonumber(self.ship.ship_template_id) - 1
    local last_stars_id_table = dms.string(dms["ship_mould"],last_ship_mould,ship_mould.star_id_tab)
    if last_stars_id_table ~= nil then 
        self.last_stars_id_table = zstring.split(last_stars_id_table,",")
    end
    for i=1,6 do
        local function buttonTouchEvent(sender, evenType)
            local __spoint = sender:getTouchBeganPosition()
            if ccui.TouchEventType.began == evenType then
                if zstring.tonumber(self.ship.stars_state[i].star_id) > 0 then
                    local function openOtherWindow( ... )
                        if self.open_window == false then
                            state_machine.excute("hero_star_skills_icon_infor_window_open",0,{self.ship.stars_state[i].star_id,cc.p(__spoint.x,__spoint.y)})
                            self.open_window = true
                        else
                            state_machine.excute("hero_star_skills_icon_infor_window_close", 0, 0)
                        end
                    end
                    if tonumber(self.ship.stars_state[i].state) == 1 then
                        self.open_window = false        
                        local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
                        self:stopAllActions()
                        self:runAction(action)                    
                    end
                else 
                    local function openOtherWindow()
                        if self.open_window == false then
                            state_machine.excute("hero_star_skills_icon_infor_window_open",0,{self.last_stars_id_table[i],cc.p(__spoint.x,__spoint.y)})
                            self.open_window = true
                        else
                            state_machine.excute("hero_star_skills_icon_infor_window_close", 0, 0)
                        end
                    end
                    self.open_window = false        
                    local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
                    self:stopAllActions()
                    self:runAction(action)                    
                end
            elseif ccui.TouchEventType.moved == evenType then

            elseif ccui.TouchEventType.canceled == evenType then
                self:stopAllActions()
                state_machine.excute("hero_star_skills_icon_infor_window_close", 0, 0)
                
            elseif ccui.TouchEventType.ended == evenType then
                if zstring.tonumber(self.ship.stars_state[i].star_id) > 0 then
                    if tonumber(self.ship.stars_state[i].state) == 1 then
                        self:stopAllActions()
                        state_machine.excute("hero_star_skills_icon_infor_window_close", 0, 0)
                        if self.open_window == true then
                            return
                        end
                    else
                        state_machine.excute("hero_main_star_up_open_upstar_window",0,{_datas = {star_index = i }})
                    end
                else
                    self:stopAllActions()
                    state_machine.excute("hero_star_skills_icon_infor_window_close", 0, 0)
                end
            end
        end
        
        local Button_attributes_icon = ccui.Helper:seekWidgetByName(root,"Button_attributes_icon_"..i)
        fwin:addTouchEventListener(Button_attributes_icon, buttonTouchEvent, {
            terminal_name = "",
            star_index = i,
            touch_scale = true,
            touch_scale_xy = 0.95,
        }, nil, 0)      
        
        -- fwin:addTouchEventListener(Button_attributes_icon, nil, 
        -- {
        --     terminal_name = "hero_main_star_up_open_upstar_window", 
        --     terminal_state = 0, 

        -- }, nil, 0)        
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_attributes_icon_fit"), nil, 
    {
        terminal_name = "hero_talent_activation_window_open", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --一键升星
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_one_step"), nil, 
    {
        terminal_name = "hero_main_star_up_one_key_lighten_star", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 查看武学
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_one_talent_look"), nil, 
    {
        terminal_name = "hero_main_star_up_open_talent_look_window", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)

    self:onUpdateDrawProp()
    self:onUpdateDraw() 
end

--初始化
function HeroMainStarUp:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.ship = params[2]
    self:onInit()
    return self
end

--移除状态机
function HeroMainStarUp:onExit()
    state_machine.remove("hero_main_star_up_window_show")  
    state_machine.remove("hero_main_star_up_window_hide")
    state_machine.remove("hero_main_star_up_change_ship")
    state_machine.remove("hero_main_star_up_open_upstar_window")
    state_machine.remove("hero_main_star_up_play_success_action")
    state_machine.remove("hero_main_star_up_show_attributes")
    state_machine.remove("hero_main_star_up_one_key_lighten_star")
    state_machine.remove("hero_main_star_up_open_talent_look_window")
end
