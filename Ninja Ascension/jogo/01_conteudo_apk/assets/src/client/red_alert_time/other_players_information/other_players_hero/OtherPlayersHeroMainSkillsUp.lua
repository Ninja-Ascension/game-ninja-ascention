-----------------------------
--英雄技能子界面
-----------------------------
OtherPlayersHeroMainSkillsUp = class("OtherPlayersHeroMainSkillsUpClass", Window)

local other_players_hero_main_skills_up_window_open_terminal = {
    _name = "other_players_hero_main_skills_up_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("OtherPlayersHeroMainSkillsUpClass")
        if nil == _Window then
            fwin:open(OtherPlayersHeroMainSkillsUp:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(other_players_hero_main_skills_up_window_open_terminal)
state_machine.init()

function OtherPlayersHeroMainSkillsUp:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship = nil

    self.scroll_view = nil
    self.scroll_view_poy = nil
    -- Initialize other_players_hero_main_grow_up state machine.
    local function init_other_players_hero_main_skills_up_terminal()
    
        --显示界面
        local other_players_hero_main_skills_up_window_show_terminal = {
            _name = "other_players_hero_main_skills_up_window_show",
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
        local other_players_hero_main_skills_up_window_hide_terminal = {
            _name = "other_players_hero_main_skills_up_window_hide",
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

        --改变英雄
        local other_players_hero_main_skills_up_change_ship_terminal = {
            _name = "other_players_hero_main_skills_up_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if params ~= "" and params ~= nil then
                    instance.ship = params 
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        state_machine.add(other_players_hero_main_skills_up_window_show_terminal)   
        state_machine.add(other_players_hero_main_skills_up_window_hide_terminal)
        state_machine.add(other_players_hero_main_skills_up_change_ship_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_other_players_hero_main_skills_up_terminal()
end

function OtherPlayersHeroMainSkillsUp:onHide()
    self:setVisible(false)
end

function OtherPlayersHeroMainSkillsUp:onShow()
    self:setVisible(true)
end

function OtherPlayersHeroMainSkillsUp:onUpdateDraw()
    local root = self.roots[1]
    local ScrollView_skills_talent = ccui.Helper:seekWidgetByName(root,"ScrollView_skills_talent")
    if nil ~= self._rootWindows._update_view_size then
        ScrollView_skills_talent:setContentSize(self._rootWindows:getContentSize())
    end
    ScrollView_skills_talent:removeAllChildren(true)
    local csb_temp = csb.createNode(config_csb.cells.hero.hero_main_skills_up_cell)
    local temp_root = csb_temp:getChildByName("root")
    local temp_height = temp_root:getContentSize().height
    local all_numbers = self.ship.talent_count -- 所有的个数
    local col_numbers = 2 --每列多少个
    local width = ScrollView_skills_talent:getContentSize().width
    local height = ScrollView_skills_talent:getContentSize().height
    local scroll_height = 0
    local _ship = self.ship
    if all_numbers % col_numbers == 0 then
        scroll_height = all_numbers / col_numbers
    else
        scroll_height = math.floor(all_numbers / col_numbers) + 1
    end 

    if scroll_height*temp_height > height then
        height = scroll_height*temp_height
    end    
    for i,v in pairs(self.ship.talents) do
        local wight_n = 1
        local height_n = 1
        if i % col_numbers == 0 then
            wight_n = col_numbers
        else
            wight_n = i % col_numbers
        end

        if i % col_numbers == 0 then
            height_n = i / col_numbers
        else
            height_n = math.floor(i / col_numbers) + 1
        end
        local cell = state_machine.excute("hero_main_skills_up_create_cell",0,{v.talent_id,v.is_activited,_ship,height_n})
        cell:setAnchorPoint(cc.p(0,1))
        cell:setPosition(cc.p((wight_n-1)*(width/col_numbers),height - (height_n-1)*temp_height))
        ScrollView_skills_talent:addChild(cell)
    end
    ScrollView_skills_talent:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_skills_talent:jumpToTop() 

    self.scroll_view = ScrollView_skills_talent
    self.scroll_view_poy = ScrollView_skills_talent:getInnerContainer():getPositionY()
end

function OtherPlayersHeroMainSkillsUp:onUpdate(dt) 
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

function OtherPlayersHeroMainSkillsUp:onEnterTransitionFinish()

end

function OtherPlayersHeroMainSkillsUp:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_main_skills_up)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_pve_map_back"), nil, 
    -- {
    --     terminal_name = "duplicate_title_back_up_floor", 
    --     terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
    -- }, nil, 0)

    self:onUpdateDraw() 
end

function OtherPlayersHeroMainSkillsUp:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.ship = params[2]
    self:onInit()
    return self
end

function OtherPlayersHeroMainSkillsUp:onExit()
    state_machine.remove("other_players_hero_main_skills_up_window_show")  
    state_machine.remove("other_players_hero_main_skills_up_window_hide")
    state_machine.remove("other_players_hero_main_skills_up_change_ship")
end
