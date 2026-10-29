-----------------------------
--英雄升星子界面
-----------------------------
OtherPlayersHeroMainStarUp = class("OtherPlayersHeroMainStarUpClass", Window)

--打开界面
local other_players_hero_main_star_up_window_open_terminal = {
    _name = "other_players_hero_main_star_up_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("OtherPlayersHeroMainStarUpClass")
        if nil == _Window then
            fwin:open(OtherPlayersHeroMainStarUp:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(other_players_hero_main_star_up_window_open_terminal)
state_machine.init()

function OtherPlayersHeroMainStarUp:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
    app.load("client.red_alert.hero.HeroStarActivation")
    app.load("client.red_alert.hero.HeroTalentActivation")

    --var
    
    self.ship = nil
    --是否打开子界面
    self.open_window = false
    --天赋名
    self._talent_name = nil 

    -- Initialize other_players_hero_main_grow_up state machine.
    local function init_other_players_hero_main_star_up_terminal()
    
        --显示界面
        local other_players_hero_main_star_up_window_show_terminal = {
            _name = "other_players_hero_main_star_up_window_show",
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
        local other_players_hero_main_star_up_window_hide_terminal = {
            _name = "other_players_hero_main_star_up_window_hide",
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
        local other_players_hero_main_star_up_change_ship_terminal = {
            _name = "other_players_hero_main_star_up_change_ship",
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

        -- 打开武学信息界面
        local other_players_hero_main_star_up_open_talent_look_window_terminal = {
            _name = "other_players_hero_main_star_up_open_talent_look_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- app.load("client.red_alert.hero.HeroMainSkillsUpWindow")
                -- state_machine.excute("hero_main_skills_up_window_window_open", 0, {params._datas.cell.ship})
                app.load("client.red_alert.hero.HeroMainStarUpWindow")
                state_machine.excute("hero_main_star_up_window_window_open", 0, {1, params._datas.cell.ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        state_machine.add(other_players_hero_main_star_up_window_show_terminal)   
        state_machine.add(other_players_hero_main_star_up_window_hide_terminal)
        state_machine.add(other_players_hero_main_star_up_change_ship_terminal)
        state_machine.add(other_players_hero_main_star_up_open_talent_look_window_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_other_players_hero_main_star_up_terminal()
end

function OtherPlayersHeroMainStarUp:onHide()
    self:setVisible(false)
end

function OtherPlayersHeroMainStarUp:onShow()
    self:setVisible(true)
end

--刷新天赋等级
function OtherPlayersHeroMainStarUp:onUpdateDraw()
    local root = self.roots[1]
    local stars,stars_level = self:getHeroStars()
    local Text_talent = ccui.Helper:seekWidgetByName(root,"Text_talent")        --天赋等级
    -- Text_talent:setString(color_type_to_chinese[stars_level]..red_alert_stars_index[stars])
    Text_talent:setString(self._talent_name)
    Text_talent:setColor(cc.c3b(tipStringInfo_quality_color_Type[stars_level+1][1],tipStringInfo_quality_color_Type[stars_level+1][2],tipStringInfo_quality_color_Type[stars_level+1][3]))
end

--更新画面
function OtherPlayersHeroMainStarUp:onUpdateDrawProp()
    local root = self.roots[1]
    local can_up_star = true
    local star_id_tab = self.ship.stars_state
    local Button_attributes_icon_fit = ccui.Helper:seekWidgetByName(root,"Button_attributes_icon_fit")    --天赋按钮
    local Panel_can_activate_fit = ccui.Helper:seekWidgetByName(root,"Panel_can_activate_fit")
    Panel_can_activate_fit:setVisible(false)
    -- print("=======mould_id",self.ship.ship_template_id)
    for i,v in pairs(star_id_tab) do
        local star_id = v.star_id
        if zstring.tonumber(star_id) == -1 or zstring.tonumber(star_id) == 0 then
            local Button_attributes_icon = ccui.Helper:seekWidgetByName(root,"Button_attributes_icon_"..i)      --星格按钮
            local Sprite_attributes_icon = Button_attributes_icon:getChildByName("Sprite_attributes_icon_"..i)  --星格icon
            can_up_star = false
            Sprite_attributes_icon:setTexture("images/ui/skills_icon/skills_icon_".. 1 .. ".png")
            local Panel_can_activate = ccui.Helper:seekWidgetByName(root,"Panel_can_activate_"..i)
            Panel_can_activate:setVisible(false)
            display:gray(Sprite_attributes_icon)
            Button_attributes_icon:setTouchEnabled(false)
            Button_attributes_icon_fit:setTouchEnabled(false)
        else
            Button_attributes_icon_fit:setTouchEnabled(true)
            local state = v.state
            local star_data = dms.element(dms["star_mould"],star_id)
            local star_pic = dms.atoi(star_data,star_mould.star_pic)
            local star_name = dms.atoi(star_data,star_mould.star_name)
            local property = dms.atos(star_data,star_mould.property)
            local Button_attributes_icon = ccui.Helper:seekWidgetByName(root,"Button_attributes_icon_"..i)      --星格按钮
            local Sprite_attributes_icon = Button_attributes_icon:getChildByName("Sprite_attributes_icon_"..i)  --星格icon
            Sprite_attributes_icon:setTexture("images/ui/skills_icon/skills_icon_".. star_pic .. ".png")
            Button_attributes_icon:setTouchEnabled(true)
            local Panel_can_activate = ccui.Helper:seekWidgetByName(root,"Panel_can_activate_"..i)
            Panel_can_activate:setVisible(false)
            if tonumber(state) == 1 then
                display:ungray(Sprite_attributes_icon)
            else
                can_up_star = false
                display:gray(Sprite_attributes_icon)
            end      
        end
        
    end

    local required_material_id = dms.string(dms["ship_mould"],self.ship.ship_template_id,ship_mould.required_material_id)   --进阶需求索引
    local initial_rank_level = dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.initial_rank_level) + 1      --初始进阶等级
    local rank_grow_up_limit = dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.rank_grow_up_limit)          --进阶等级上限
    --临时特殊处理，针对于不能进阶的英雄
    if rank_grow_up_limit ~= -1 then
        initial_rank_level = initial_rank_level + 1
    end
    if initial_rank_level > rank_grow_up_limit and rank_grow_up_limit ~= -1 then
        initial_rank_level = initial_rank_level - 1
    end
    local talent_tab_str = dms.string(dms["ship_mould"],self.ship.ship_template_id,ship_mould.talent_id)    --天赋模板ID
    local talent_tab = zstring.split(talent_tab_str,"|")
    local talent_id_table = talent_tab[initial_rank_level]
    local talent_id = zstring.split(talent_id_table,",")
    talent_id = talent_id[3]

    local talent_mould_data = dms.element(dms["talent_mould"],talent_id)    
    local talent_name = dms.atos(talent_mould_data,talent_mould.talent_name)        --天赋名称
    local talent_describe = dms.atos(talent_mould_data,talent_mould.talent_describe)--天赋描述
    local base_additional = dms.atos(talent_mould_data,talent_mould.base_additional)--基本属性加成
    local talent_pic = dms.atoi(talent_mould_data,talent_mould.talent_pic)          --图片索引
    self._talent_name = talent_name

    local Sprite_attributes_icon_fit = Button_attributes_icon_fit:getChildByName("Sprite_attributes_icon_fit")      --天赋icon
    Sprite_attributes_icon_fit:setTexture("images/ui/talent_icon/talent_icon_".. talent_pic .. ".png")
    display:gray(Sprite_attributes_icon_fit)
end

function OtherPlayersHeroMainStarUp:getHeroStars() --下一级的
    local initial_rank_level = dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.initial_rank_level) + 1
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

function OtherPlayersHeroMainStarUp:onEnterTransitionFinish()

end

--初始化界面
function OtherPlayersHeroMainStarUp:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_main_star_up)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    for i=1,6 do
        local function buttonTouchEvent(sender, evenType)
            local __spoint = sender:getTouchBeganPosition()
            if ccui.TouchEventType.began == evenType then
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
            elseif ccui.TouchEventType.moved == evenType then

            elseif ccui.TouchEventType.canceled == evenType then
                self:stopAllActions()
                state_machine.excute("hero_star_skills_icon_infor_window_close", 0, 0)
                
            elseif ccui.TouchEventType.ended == evenType then
                if tonumber(self.ship.stars_state[i].state) == 1 then
                    self:stopAllActions()
                    state_machine.excute("hero_star_skills_icon_infor_window_close", 0, 0)
                    if self.open_window == true then
                        return
                    end
                end
               
            end
        end
        
        local Button_attributes_icon = ccui.Helper:seekWidgetByName(root,"Button_attributes_icon_"..i)
        fwin:addTouchEventListener(Button_attributes_icon, buttonTouchEvent, {
            terminal_name = "",
            star_index = i,
        }, nil, 0)      
            
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_attributes_icon_fit"), nil, 
    {
        terminal_name = "", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 查看武学
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_one_talent_look"), nil, 
    {
        terminal_name = "other_players_hero_main_star_up_open_talent_look_window", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)


    local Button_one_step = ccui.Helper:seekWidgetByName(root,"Button_one_step")  
    Button_one_step:setVisible(false)
    
    self:onUpdateDrawProp()
    self:onUpdateDraw() 
end

--初始化
function OtherPlayersHeroMainStarUp:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.ship = params[2]
    self:onInit()
    return self
end

--移除状态机
function OtherPlayersHeroMainStarUp:onExit()
    state_machine.remove("other_players_hero_main_star_up_window_show")  
    state_machine.remove("other_players_hero_main_star_up_window_hide")
    state_machine.remove("other_players_hero_main_star_up_change_ship")
    state_machine.remove("other_players_hero_main_star_up_open_talent_look_window")
end
