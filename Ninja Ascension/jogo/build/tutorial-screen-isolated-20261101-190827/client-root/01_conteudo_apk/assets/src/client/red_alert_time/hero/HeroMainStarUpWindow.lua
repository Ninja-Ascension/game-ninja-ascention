-----------------------------
--英雄 升星/突破 技能预览界面
-----------------------------
HeroMainStarUpWindow = class("HeroMainStarUpWindowClass", Window)
-- 打开
local hero_main_star_up_window_window_open_terminal = {
    _name = "hero_main_star_up_window_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HeroMainStarUpWindowClass")
        if nil == _Window then
            fwin:open(HeroMainStarUpWindow:new():init(params),fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
-- 关闭
local hero_main_star_up_window_window_close_terminal = {
    _name = "hero_main_star_up_window_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroMainStarUpWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_main_star_up_window_window_open_terminal)
state_machine.add(hero_main_star_up_window_window_close_terminal)
state_machine.init()

function HeroMainStarUpWindow:ctor()
    self.super:ctor()
    self.roots = {}
    --var
    self._choose_type = 0       -- 1 升星预览; 2 突破预览
    self._ship = nil            -- 英雄实例数据

    self._list_view = nil       -- 技能列表
    self._list_view_poy = nil   -- 技能列表Y轴坐标

    -- load lua file
    app.load("client.red_alert_time.cells.hero.hero_main_star_up_cell")
    app.load("client.red_alert_time.cells.hero.hero_main_talent_up_cell")

    local function init_hero_main_star_up_terminal()
        
    end
    
    init_hero_main_star_up_terminal()
end

function HeroMainStarUpWindow:onHide( ... )
    self:setVisible(false)
end

function HeroMainStarUpWindow:onShow( ... )
    self:setVisible(true)
end

function HeroMainStarUpWindow:onUpdateDraw()
    local root = self.roots[1]
    self._list_view = ccui.Helper:seekWidgetByName(root,"ListView_preview")         -- 技能列表
    local Text_title_1 = ccui.Helper:seekWidgetByName(root,"Text_title_1")          -- 升星预览
    local Text_title_2 = ccui.Helper:seekWidgetByName(root,"Text_title_2")          -- 突破预览
    local Text_tip_1 = ccui.Helper:seekWidgetByName(root,"Text_tip_1")              -- 经脉预览
    local Text_tip_2 = ccui.Helper:seekWidgetByName(root,"Text_tip_2")              -- 天赋预览
    local Text_skill_name = ccui.Helper:seekWidgetByName(root,"Text_skill_name")    -- 英雄技能名称
    local Text_skill_info = ccui.Helper:seekWidgetByName(root,"Text_skill_info")    -- 英雄技能描述
    local Image_skill_bg = ccui.Helper:seekWidgetByName(root,"Image_skill_bg")
    local Sprite_skill_icon = Image_skill_bg:getChildByName("Sprite_skill_icon")    -- 英雄技能icon

    self._list_view:removeAllItems()

    Text_title_1:setVisible(false)
    Text_title_2:setVisible(false)
    Text_tip_1:setVisible(false)
    Text_tip_2:setVisible(false)
    Text_skill_name:setString("")
    Text_skill_info:setString("")

    local talent_data = nil
    -- 如果是查看升星预览
    if self._choose_type == 1 then
        Text_title_1:setVisible(true)
        Text_tip_1:setVisible(true)
        -- 获取经脉详情数据 创建cell
        local index = 0     -- 经脉数量
        for i,v in pairs(self._ship.talents) do
            local data = dms.element(dms["talent_mould"], v.talent_id)
            local base_additional = dms.atos(data,talent_mould.base_additional)
            if tonumber(base_additional) == -1 then
                talent_data = data
            else
                index = index + 1
                local cell = state_machine.excute("hero_main_star_up_create_cell",0,{v.talent_id,v.is_activited,self._ship,index})
                self._list_view:addChild(cell)
            end
        end
        
    else    -- 如果是查看突破预览
        Text_title_2:setVisible(true)
        Text_tip_2:setVisible(true)
        -- 获取天赋详情数据 创建cell
        for i,v in pairs(self._ship.talents) do
            local data = dms.element(dms["talent_mould"], v.talent_id)
            local base_additional = dms.atos(data,talent_mould.base_additional)
            if tonumber(base_additional) == -1 then
                talent_data = data
            end
        end

        local ship_mould_id = self._ship.ship_template_id or self._ship.ship_mould_id
        local shipSkillGrowUpParam = dms.string(dms["ship_mould"], ship_mould_id, ship_mould.skill_grow_up_param)
        shipSkillGrowUpParam = zstring.split(shipSkillGrowUpParam, "|")

        for i, v in pairs(shipSkillGrowUpParam) do
            local params = zstring.split(v, ",")
            local talentId = params[1]          -- 天赋ID
            local resourceNeedId = params[2]    -- 资源消耗ID
            local isAlive = self._ship.skill_grow_up_states[i] == "1"   -- 天赋是否已经激活
            local cell = state_machine.excute("hero_main_talent_up_cell_create", 0, {self._ship, talentId, resourceNeedId, isAlive})
            self._list_view:addChild(cell)
        end
    end

    if talent_data ~= nil then
        -- 获取技能名称、技能详情描述、技能iconID
        local talent_name = dms.atos(talent_data,talent_mould.talent_name)
        local talent_describe = dms.atos(talent_data,talent_mould.talent_describe)
        local talent_pic = dms.atoi(talent_data,talent_mould.talent_pic)
        Text_skill_name:setString(talent_name)
        Text_skill_info:setString(talent_describe)
        Sprite_skill_icon:setTexture("images/ui/talent_icon/talent_icon_".. talent_pic .. ".png")
    end

    self._list_view:requestRefreshView()
    self._list_view:jumpToTop()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function HeroMainStarUpWindow:onUpdate(dt) 
    if self._list_view ~= nil and self._choose_type == 1 then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
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

function HeroMainStarUpWindow:onEnterTransitionFinish()

end

function HeroMainStarUpWindow:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_main_star_up_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_star_up_window_close"), nil, 
    {
        terminal_name = "hero_main_star_up_window_window_close", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self:onUpdateDraw() 
end

function HeroMainStarUpWindow:init(params)
    self._choose_type = params[1]
    self._ship = params[2]
    self:onInit()
    return self
end

function HeroMainStarUpWindow:onExit()

end
