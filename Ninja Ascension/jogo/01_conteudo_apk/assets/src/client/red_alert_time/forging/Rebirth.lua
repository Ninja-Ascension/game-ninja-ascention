-----------------------------
--重生
-----------------------------
Rebirth = class("RebirthClass", Window)

--打开重生界面
local rebirth_window_open_terminal = {
    _name = "rebirth_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(97) == true then
            return
        end 
        local _Window = fwin:find("RebirthClass")
        if nil == _Window then
            fwin:open(Rebirth:new():init(), fwin._ui)
        end
        state_machine.excute("home_select_action_window_close",0,"")        
        state_machine.excute("main_window_hide", 0, "")
        state_machine.excute("player_resource_window_hide", 0, "")     
        state_machine.excute("home_button_for_action_window_hide",0,"")
        state_machine.excute("chat_view_window_hide",0,"")  
        state_machine.excute("duplicate_title_window_hide",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭重生界面
local rebirth_window_close_terminal = {
    _name = "rebirth_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RebirthClass"))

        state_machine.excute("main_window_open",0,"")
        state_machine.excute("player_resource_window_show",0,"")   
        state_machine.excute("home_button_for_action_window_show",0,"")  
        state_machine.excute("chat_view_window_show",0,"")
        state_machine.excute("duplicate_title_window_show",0,"")   
        
        -- clear cacher
        cacher.clearWindowCacher()     
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(rebirth_window_open_terminal)
state_machine.add(rebirth_window_close_terminal)
state_machine.init()

function Rebirth:ctor()
    self.super:ctor()
    self.roots = {}
    
    -- load lua file
    app.load("client.red_alert_time.cells.hero.hero_icon_cell")

    --var
    self.page_index = 1 -- 1 英雄 
    self.user_ships = {}
    self.ship_numbers = 0 
    self.will_rebirth_ship = nil

    
    -- Initialize rebirth state machine.
    local function init_rebirth_terminal()

        -- 确认重生
        local rebirth_sure_rebirth_terminal = {
            _name = "rebirth_sure_rebirth",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("rebirth_sure_rebirth")
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open",0,{{16,76}})
                        state_machine.excute("rebirth_update_view",0,"")
                        state_machine.excute("rebirth_updrawleft",0,nil)
                        state_machine.unlock("rebirth_sure_rebirth")
                    else
                        state_machine.unlock("rebirth_sure_rebirth")
                    end
                end
                if instance.will_rebirth_ship == nil then
                    TipDlg.drawTextDailog(red_alert_all_str[123])
                    state_machine.unlock("rebirth_sure_rebirth")
                    return
                end
                protocol_command.ship_rebirth.param_list = instance.will_rebirth_ship.ship_id
                NetworkManager:register(protocol_command.ship_rebirth.code, nil, nil, nil, nil, responseCallback, false, nil)                   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        -- 更新左侧
        local rebirth_updrawleft_terminal = {
            _name = "rebirth_updrawleft",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                self.will_rebirth_ship = params
                instance:onUpdateDrawLeft()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }       
         -- 取消全部选中
        local rebirth_all_set_unselect_terminal = {
            _name = "rebirth_all_set_unselect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:allSetunSelect()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
          -- 刷新列表
        local rebirth_update_view_terminal = {
            _name = "rebirth_update_view",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.user_ships = instance:getSortShips()
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }           
        state_machine.add(rebirth_sure_rebirth_terminal)  
        state_machine.add(rebirth_updrawleft_terminal)  
        state_machine.add(rebirth_all_set_unselect_terminal)  
        state_machine.add(rebirth_update_view_terminal)  
        state_machine.init()
    end
    
    -- call func init rebirth state machine.
    init_rebirth_terminal()
end

-- 取消全部选中
function Rebirth:allSetunSelect()
    local root = self.roots[1]
    local ScrollView_rebirth = ccui.Helper:seekWidgetByName(root,"ScrollView_rebirth")
    for i,cell in pairs(ScrollView_rebirth:getChildren()) do
        if cell.setSelected ~= nil then
            cell.selected = false
            cell:setSelected()
        end
    end
end

-- 更新左侧
function Rebirth:onUpdateDrawLeft()
    local root = self.roots[1]
    -- 侠客icon
    local Panel_hero_header = ccui.Helper:seekWidgetByName(root,"Panel_hero_header")
    Panel_hero_header:removeAllChildren(true)
    -- 侠客名称
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    Text_name:setString("")
    -- 侠客星级
    local Text_talent = ccui.Helper:seekWidgetByName(root,"Text_rebirth_star")
    Text_talent:setString("")
    if self.will_rebirth_ship ~= nil then
        -- 侠客icon
        local herocell = state_machine.excute("hero_icon_create_cell",0,{self.will_rebirth_ship,4,0,false})
        Panel_hero_header:addChild(herocell)
        -- 侠客突破等级
        local skillGrowUpLevel = "+" .. self.will_rebirth_ship.skill_grow_up_level
        local ship_type = self.will_rebirth_ship.ship_type
        -- 侠客名称 + 突破等级
        Text_name:setString(self.will_rebirth_ship.captain_name..skillGrowUpLevel)
        Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[ship_type+1][1],tipStringInfo_quality_color_Type[ship_type+1][2],tipStringInfo_quality_color_Type[ship_type+1][3]))
        -- 侠客星级
        local stars,stars_level = getHeroStars(self.will_rebirth_ship.ship_template_id)
        -- 当侠客0星是不显示,否则显示星级和对应颜色
        if tonumber(stars) == 0 then
            Text_talent:setString("")
        else
            Text_talent:setString(color_type_to_chinese[stars_level]..red_alert_stars_index[stars])
            Text_talent:setColor(cc.c3b(tipStringInfo_quality_color_Type[stars_level+1][1],tipStringInfo_quality_color_Type[stars_level+1][2],tipStringInfo_quality_color_Type[stars_level+1][3]))
        end
    end
    -- debug.print_r(self.will_rebirth_ship)
end


function Rebirth:onUpdate(dt) 
    if self.scroll_view ~= nil then
        local size = self.scroll_view:getContentSize()
        local posY = self.scroll_view:getInnerContainer():getPositionY()
        if self.scroll_view_poy == posY then
            return
        end
        self.scroll_view_poy = posY
        local items = self.scroll_view:getChildren()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end


-- 刷新列表
function Rebirth:onUpdateDraw()
    local root = self.roots[1]
    local ScrollView_rebirth = ccui.Helper:seekWidgetByName(root,"ScrollView_rebirth")
    ScrollView_rebirth:removeAllChildren(true)
    local cell_temp = state_machine.excute("packs_icon_bg_create_cell",0,"")
    local cell_height = cell_temp:getContentSize().height
    local width = ScrollView_rebirth:getContentSize().width
    local height = ScrollView_rebirth:getContentSize().height
    local scroll_height = 0
    local index = 0
    for i = 1,10000 do
        local v = self.user_ships[i]
        index = index + 1
        local wight_n = 1
        local height_n = 1
        if i % 4 == 0 then
            wight_n = 4
        else
            wight_n = i % 4
        end
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end
    if index % 4 == 0 then
        scroll_height = index / 4
    else
        scroll_height = math.floor(index / 4) + 1
    end

    if scroll_height*cell_height > height then
        height = scroll_height*cell_height
    end

    for i = 1,10000 do
        local v = self.user_ships[i]    
        local wight_n = 1
        local height_n = 1
        if i % 4 == 0 then
            wight_n = 4
        else
            wight_n = i % 4
        end

        if i % 4 == 0 then
            height_n = i / 4
        else
            height_n = math.floor(i / 4) + 1
        end
        local cell = nil 
        if v == nil then
            cell = state_machine.excute("packs_icon_bg_create_cell",0,"")
        else
            local data = 
            {   
                item_value = 1,
                prop_type = 13,
                prop_item = v.ship_template_id
            }
            cell = state_machine.excute("all_resource_create_cell",0,{6,data,v,5,height_n})
        end
        cell:setAnchorPoint(cc.p(0,1))
        -- print("============",wight_n,height_n,(wight_n-1)*(width/4),height - (height_n-1)*92)
        cell:setPosition(cc.p((wight_n-1)*(width/4),height - (height_n-1)*cell_height))
        ScrollView_rebirth:addChild(cell)
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end

    ScrollView_rebirth:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_rebirth:jumpToTop()

    self.scroll_view = ScrollView_rebirth
    self.scroll_view_poy = ScrollView_rebirth:getInnerContainer():getPositionY()
end

--播放动画
function Rebirth:playActions()
    local root = self.roots[1]
    local Panel_effice = ccui.Helper:seekWidgetByName(root,"Panel_effice")
    Panel_effice:removeAllChildren(true)
    local jsonPath = "images/ui/effice/effice_forging/effice_forging.json"
    local atlasPath = "images/ui/effice/effice_forging/effice_forging.atlas"
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation_event", true, nil)
    animation:setPosition(cc.p(Panel_effice:getContentSize().width/2,Panel_effice:getContentSize().height/2))
    Panel_effice:addChild(animation)
end

--初始化界面
function Rebirth:onInit( )
    local csbItem = csb.createNode(config_csb.forging.rebirth)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    --阵营背景
    local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
    Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rebirth_close"), nil, 
    {
        terminal_name = "rebirth_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 重生
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rebirth"), nil, 
    {
        terminal_name = "rebirth_sure_rebirth",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    
    self:onUpdateDraw() 
end

-- 获得英雄
function Rebirth:getSortShips()
    self.ship_numbers = 0
    local result = _ED.user_ship
    local all_result = {}
    local in_formation = {}
    local in_raleship = {}
    local gold_ship = {} -- 6
    local red_ship = {}  -- 5
    local orange_ship = {} -- 4
    local purple_ship = {} -- 3
    local blue_ship = {} -- 2 
    local green_ship = {} -- 1
    local white_ship = {} -- 0
    local function sortShipFight( a, b )
        return tonumber(a.hero_fight) > tonumber(b.hero_fight)
    end
    table.sort(result, sortShipFight)
    local canRefiningUnionShips = {}
    if _ED.union.union_info ~= nil 
        and _ED.union.union_info.union_id ~= nil 
        and zstring.tonumber(_ED.union.union_info.union_id) > 0 
        and _ED.union.user_union_info.team_fight_use_ships ~= "" then
        canRefiningUnionShips = zstring.split(_ED.union.user_union_info.team_fight_use_ships, ",")
    end
    for i,ship in pairs(result) do
        -- debug.print_r(ship)
        local isInUnionTeam = false
        for k1,v1 in pairs(canRefiningUnionShips) do
            if tonumber(ship.ship_id) == tonumber(v1) then
                isInUnionTeam = true
            end
        end

        local initial_rank_level = dms.int(dms["ship_mould"],ship.ship_template_id,ship_mould.initial_rank_level)
        local can_rebirth = initial_rank_level > 0
        if false == can_rebirth then
            can_rebirth = ship.skill_grow_up_level > 0
        end
        if false == can_rebirth then
            for i,v in pairs(ship.stars_state) do
                if tonumber(v.state) == 1 then
                    can_rebirth = true
                    break
                end
            end
        end
        if can_rebirth == true 
            and isInUnionTeam == false
            then
            if zstring.tonumber(ship.formation_index) > 0 then
            elseif zstring.tonumber(ship.little_partner_formation_index) >0 then
            else
                --print("====22====name====",can_rebirth,ship.captain_name,initial_rank_level,ship.formation_index,ship.little_partner_formation_index)
                if zstring.tonumber(ship.ship_type) == 6 then
                    table.insert(gold_ship, ship)
                elseif zstring.tonumber(ship.ship_type) == 5 then
                    table.insert(red_ship, ship)
                elseif zstring.tonumber(ship.ship_type) == 4 then
                    table.insert(orange_ship, ship)
                elseif zstring.tonumber(ship.ship_type) == 3 then
                    table.insert(purple_ship, ship)
                elseif zstring.tonumber(ship.ship_type) == 2 then
                    table.insert(blue_ship, ship)
                elseif zstring.tonumber(ship.ship_type) == 1 then
                    table.insert(green_ship, ship)
                elseif zstring.tonumber(ship.ship_type) == 0 then
                    table.insert(white_ship, ship)
                end
            end
        end
    end

    for i,v in pairs(in_formation) do
        self.ship_numbers = self.ship_numbers + 1
        table.insert(all_result,v)
    end
    for i,v in pairs(in_raleship) do
        self.ship_numbers = self.ship_numbers + 1
        table.insert(all_result,v)
    end
    for i,v in pairs(gold_ship) do
        self.ship_numbers = self.ship_numbers + 1
        table.insert(all_result,v)
    end
    for i,v in pairs(red_ship) do
        self.ship_numbers = self.ship_numbers + 1
        table.insert(all_result,v)
    end
    for i,v in pairs(orange_ship) do
        self.ship_numbers = self.ship_numbers + 1
        table.insert(all_result,v)
    end
    for i,v in pairs(purple_ship) do
        self.ship_numbers = self.ship_numbers + 1
        table.insert(all_result,v)
    end
    for i,v in pairs(blue_ship) do
        self.ship_numbers = self.ship_numbers + 1
        table.insert(all_result,v)
    end
    for i,v in pairs(green_ship) do
        self.ship_numbers = self.ship_numbers + 1
        table.insert(all_result,v)
    end    
    for i,v in pairs(white_ship) do
        self.ship_numbers = self.ship_numbers + 1
        table.insert(all_result,v)
    end
    return all_result
end

function Rebirth:init()
    self.user_ships = self:getSortShips()    
    self:onInit()
    self:playActions()
    return self
end

--移除状态机
function Rebirth:onExit()
    state_machine.remove("rebirth_sure_rebirth",0,"")
    state_machine.remove("rebirth_updrawleft",0,"")
    state_machine.remove("rebirth_all_set_unselect",0,"")
    state_machine.remove("rebirth_update_view",0,"")
end
