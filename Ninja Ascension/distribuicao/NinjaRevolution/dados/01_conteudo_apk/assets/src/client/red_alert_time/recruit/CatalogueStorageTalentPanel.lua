-----------------------------
--英雄技能子界面
-----------------------------
CatalogueStorageTalentPanel = class("CatalogueStorageTalentPanelClass", Window)

local catalogue_storage_talent_panel_window_open_terminal = {
    _name = "catalogue_storage_talent_panel_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("CatalogueStorageTalentPanelClass") then
            fwin:open(CatalogueStorageTalentPanel:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(catalogue_storage_talent_panel_window_open_terminal)
state_machine.init()

function CatalogueStorageTalentPanel:ctor()
    self.super:ctor()
    self.roots = {}
    self.scroll_view = nil
    self.scroll_view_poy = nil
    self.ship_mould_id = nil

    -- load lua file
    app.load("client.red_alert_time.cells.hero.hero_main_skills_up_cell")
    app.load("client.red_alert_time.packs.herostorage.HeroStarSkillsIconInfor")
    app.load("client.red_alert_time.packs.herostorage.HeroStarSkillsInforProperty")
end


function CatalogueStorageTalentPanel:onUpdateDraw()
    local root = self.roots[1]
    local ScrollView_skills_talent = ccui.Helper:seekWidgetByName(root,"ScrollView_skills_talent")
    ScrollView_skills_talent:removeAllChildren(true)
    if nil ~= self._rootWindows._update_view_size then
        ScrollView_skills_talent:setContentSize(self._rootWindows:getContentSize())
    end
    local csb_temp = csb.createNode(config_csb.cells.hero.hero_main_skills_up_cell)
    local temp_root = csb_temp:getChildByName("root")
    local temp_height = temp_root:getContentSize().height

    local talent_table = {}
    local talent_str = dms.string(dms["ship_mould"],self.ship_mould_id,ship_mould.talent_id)
    talent_str = zstring.split(talent_str,"|")
    for i,v in pairs(talent_str) do
        local talent_id_tab = zstring.split(v,",")
        local talent_id_t = talent_id_tab[3]    
        local data = 
        {
            talent_id = talent_id_t,
            is_activited = 1
        }
        table.insert(talent_table,data)
    end


    local all_numbers = #talent_str -- 所有的个数
    local col_numbers = 2 --每列多少个
    local width = ScrollView_skills_talent:getContentSize().width
    local height = ScrollView_skills_talent:getContentSize().height
    local scroll_height = 0
    if all_numbers % col_numbers == 0 then
        scroll_height = all_numbers / col_numbers
    else
        scroll_height = math.floor(all_numbers / col_numbers) + 1
    end 

    if scroll_height*temp_height > height then
        height = scroll_height*temp_height
    end    
    local ship = {
        ship_type = dms.int(dms["ship_mould"],self.ship_mould_id,ship_mould.ship_type)
    }
    for i,v in pairs(talent_table) do
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
        local cell = state_machine.excute("hero_main_skills_up_create_cell",0,{v.talent_id,1,ship,height_n})
        cell:setAnchorPoint(cc.p(0,1))
        cell:setPosition(cc.p((wight_n-1)*(width/col_numbers),height - (height_n-1)*temp_height))
        ScrollView_skills_talent:addChild(cell)
    end
    ScrollView_skills_talent:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_skills_talent:jumpToTop() 

    self.scroll_view = ScrollView_skills_talent
    self.scroll_view_poy = ScrollView_skills_talent:getInnerContainer():getPositionY()
end

function CatalogueStorageTalentPanel:onUpdate(dt) 
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

function CatalogueStorageTalentPanel:onEnterTransitionFinish()

end

function CatalogueStorageTalentPanel:onInit( )
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

function CatalogueStorageTalentPanel:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.ship_mould_id = params[2]
    self:onInit()
    return self
end

function CatalogueStorageTalentPanel:onExit()

end
