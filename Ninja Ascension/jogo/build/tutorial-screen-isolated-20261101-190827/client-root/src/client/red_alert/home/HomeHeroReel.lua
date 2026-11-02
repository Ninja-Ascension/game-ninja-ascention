--------------------------------------------------------------------------------------------------------------
--  说明：聚贤庄
--------------------------------------------------------------------------------------------------------------
HomeHeroReel = class("HomeHeroReelClass", Window)
-- 打开
local home_hero_reel_window_open_terminal = {
    _name = "home_hero_reel_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(51) == true then
            return
        end 
        local _Window = fwin:find("HomeHeroReelClass")
        if nil == _Window then
            fwin:open(HomeHeroReel:new():init(), fwin._ui)
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
-- 关闭
local home_hero_reel_window_close_terminal = {
    _name = "home_hero_reel_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HomeHeroReelClass"))

        state_machine.excute("main_window_open",0,"")
        state_machine.excute("player_resource_window_show",0,"")   
        state_machine.excute("home_button_for_action_window_show",0,"")  
        state_machine.excute("chat_view_window_show",0,"")
        state_machine.excute("duplicate_title_window_show",0,"")
        
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(home_hero_reel_window_open_terminal)
state_machine.add(home_hero_reel_window_close_terminal)
state_machine.init()

function HomeHeroReel:ctor()
    self.super:ctor()
    self.roots = {}
    self._selectIndex = 0

    local function init_home_hero_reel_terminal()
        -- 切换按钮
        local home_hero_reel_choose_tab_terminal = {
            _name = "home_hero_reel_choose_tab",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:chooseTab(params._datas.chooseIndex)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 引荐
        local home_hero_reel_get_reward_terminal = {
            _name = "home_hero_reel_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(home_hero_reel_choose_tab_terminal)
        state_machine.add(home_hero_reel_get_reward_terminal)
        state_machine.init()
    end
    
    init_home_hero_reel_terminal()
end
-- 切换选中按钮
function HomeHeroReel:chooseTab( chooseIndex )
    if self._selectIndex == chooseIndex then
        return
    end
    self._selectIndex = chooseIndex
    self:onUpdateDraw()
end

function HomeHeroReel:onUpdateDraw()
    local root = self.roots[1]
    -- 任务名
    local Text_title_2 = ccui.Helper:seekWidgetByName(root, "Text_title_2")
    -- Text_title_2:setString("")
    -- 侠客描述
    local Text_info = ccui.Helper:seekWidgetByName(root, "Text_info")
    -- Text_info:setString("")
    -- 奖励
    local ListView_reward = ccui.Helper:seekWidgetByName(root, "ListView_reward")
    ListView_reward:removeAllItems()

    -- 开启条件
    local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv")
    -- Text_lv:setString("")
    -- 引荐
    local Button_recommended = ccui.Helper:seekWidgetByName(root, "Button_recommended")
    -- 已引荐
    local Text_over = ccui.Helper:seekWidgetByName(root, "Text_over")

    -- 侠客信息
    -- local ship_mould_id = self.ship.ship_template_id
    -- local temp_bust_index = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.bust_index)            
    local Panel_hero_cg_role = ccui.Helper:seekWidgetByName(root,"Panel_hero_cg_role")
    Panel_hero_cg_role:removeAllChildren(true)
    -- Panel_hero_cg_role:setBackGroundImage("images/face/card_hero/card_hero_"..temp_bust_index..".png")  
    -- 侠客动画
    local Panel_hero_spine_role = ccui.Helper:seekWidgetByName(root,"Panel_hero_spine_role")            
    Panel_hero_spine_role:removeAllChildren(true)
    -- local jsonPath = "images/face/big_head/big_head_" .. temp_bust_index .. ".json"
    -- local atlasPath = "images/face/big_head/big_head_" .. temp_bust_index .. ".atlas"
    -- if cc.FileUtils:getInstance():isFileExist(jsonPath) == true then
    --     local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
    --     animation:setPosition(cc.p(Panel_hero_spine_role:getContentSize().width/2,Panel_hero_spine_role:getContentSize().height/2))
    --     Panel_hero_spine_role:addChild(animation)
    -- end
    
    for i=1,3 do
        -- 选中状态
        local Image_select = ccui.Helper:seekWidgetByName(root, "Image_select_"..i)
        Image_select:setVisible(false)
        if i == self._selectIndex then
            Image_select:setVisible(true)
        end
        -- 完成状态
        local Image_icon = ccui.Helper:seekWidgetByName(root, "Image_icon_"..i)
        Image_icon:setVisible(false)
        -- 侠客icon
        local Panel_quality_box = ccui.Helper:seekWidgetByName(root, "Panel_quality_box_"..i)
        local Panel_head_icon = ccui.Helper:seekWidgetByName(root, "Panel_head_icon_"..i)
        Panel_head_icon:removeAllChildren(true)
        -- local cell = state_machine.excute("hero_icon_union_team_fight_create_cell", 0, {ship_mould_id})
        -- Panel_head_icon:addChild(cell)
        -- 任务名
        local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name_"..i)
        -- Text_name:setString("")
        
    end
end

function HomeHeroReel:onInit( )
    local csbItem = csb.createNode(config_csb.hero_reel.hero_reel)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_reel_close"), nil, 
    {
        terminal_name = "home_hero_reel_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    -- 引荐
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recommended"), nil, 
    {
        terminal_name = "home_hero_reel_get_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    for i=1,3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_hero_"..i), nil, 
        {
            terminal_name = "home_hero_reel_choose_tab", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            chooseIndex = i,
        }, nil, 0)
    end

    self:chooseTab(1) 
end

function HomeHeroReel:init()
	self:onInit()
    return self
end

function HomeHeroReel:onExit()
    state_machine.remove("home_hero_reel_choose_tab")
end
