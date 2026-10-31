-- ----------------------------------------------------------------------------------------------------
-- 说明：选择签订契约,英雄列表
-------------------------------------------------------------------------------------------------------
AdventureMercenaryAgreementChooseList = class("AdventureMercenaryAgreementChooseListClass", Window)

local Chane_label_index = 4
local Change_show_index = 0 --全部 -- 1合约佣兵
function AdventureMercenaryAgreementChooseList:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.chane_label = nil
    self.currentScrollView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    --app.load("client.loader.formula")
    app.load("client.adventure.mercenary.agreement.AdventureMercenaryAgreementSort")
    -- Initialize adventure hero awaken state machine.
    local function init_adventure_mercenary_agreement_terminal()
        -- --弹出选择佣兵列表
        local adventure_mercenary_agreement_choose_list_close_terminal = {
            _name = "adventure_mercenary_agreement_choose_list_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)                
                fwin:close(fwin:find("AdventureMercenaryAgreementChooseListClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --打开排序界面
        local adventure_mercenary_agreement_choose_list_sort_terminal = {
            _name = "adventure_mercenary_agreement_choose_list_sort",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)                
                fwin:open(AdventureMercenaryAgreementSort:new():init(Chane_label_index,Change_show_index), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --排序更新
        local adventure_mercenary_agreement_choose_list_sort_update_terminal = {
            _name = "adventure_mercenary_agreement_choose_list_sort_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)                
                
                Chane_label_index = zstring.tonumber(params._datas._showType)
            
                self:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --点击选择需要签约的英雄弹出确认框
        local adventure_mercenary_hero_agreement_list_open_confirm_terminal = {
            _name = "adventure_mercenary_hero_agreement_list_open_confirm",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)   
                fwin:open(AdventureMercenaryHeroBattleConfirm:new():init(3, 0,0, params._datas.cell.hero), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        

        state_machine.add(adventure_mercenary_agreement_choose_list_close_terminal)
        state_machine.add(adventure_mercenary_agreement_choose_list_sort_terminal)
        state_machine.add(adventure_mercenary_agreement_choose_list_sort_update_terminal)
        state_machine.add(adventure_mercenary_hero_agreement_list_open_confirm_terminal)
    
        state_machine.init()
    end
    
    -- call func init adventure hero awaken state machine.
    init_adventure_mercenary_agreement_terminal()
end

function AdventureMercenaryAgreementChooseList:init(hero)
    -- self.hero = hero
    -- self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
    return self
end

function AdventureMercenaryAgreementChooseList:updateDraw()
    local root = self.roots[1]

end

function AdventureMercenaryAgreementChooseList:showlist(index)
    local root = self.roots[1]
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_role")
    m_ScrollView:removeAllChildren(true)
    local panel = m_ScrollView:getInnerContainer()
    panel:setContentSize(m_ScrollView:getContentSize())
    panel:setPosition(cc.p(0,0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = m_ScrollView:getInnerContainerSize()
    local nextY = sSize.height
    local nextX = sSize.width
    local tHeight = 0
    local cellHeight = 0
    local tWidth = 0
    local wPosition = sWidth/5
    local Hlindex = 0
    local hero_info = {}
    cellHeight = (zstring.tonumber(_ED.user_ship_number)/5+1)*(m_ScrollView:getContentSize().width/5)
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    local first = nil
    for j, v in pairs(self:getSortedHeroes(index)) do
        local isBim = false
        local cell = AdventureHeroIconCell:createCell()
        if index == 0 then
            cell:init(10, v, 1, 0, nil, v.hero_fight, nil, nil, j)
        elseif index == 1 then
            cell:init(10, v, 1, 0, nil, nil, nil, dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.initial_rank_level), j)
        elseif index == 2 then
            cell:init(10, v, 1, 0, nil, v.hero_fight, nil, nil, j)
        elseif index == 3 then
            cell:init(10, v, 1, 0, nil, nil, v.ship_grade, nil, j)
        elseif index == 4 then 
            cell:init(10, v, 1, 0, nil, nil, nil, nil, j,v.agreementStates)
        end
        
        panel:addChild(cell)
        if j == 1 then
            first = cell
        end
        tWidth = tWidth + wPosition
        if (j-1)%5 ==0 then
            Hlindex = Hlindex+1
            tWidth = 0
            tHeight = sHeight - wPosition*Hlindex  
        end
        if j<= 5 then
            tHeight = sHeight - wPosition
        end
        cell:setPosition(cc.p(tWidth,tHeight))
    end
    m_ScrollView:jumpToTop()
    -- if first ~= nil then
    --     AdventureHeroIconCell.__ware_house_choose_cell = nil
    --     state_machine.excute("adventure_hero_icon_cell_show_hero_warehouse_larger", 0, {_datas={cell = first}})
    -- end
    
    self.currentScrollView = m_ScrollView
    self.currentInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function AdventureMercenaryAgreementChooseList:onUpdateDraw()
    local root = self.roots[1]
    self:showlist(Chane_label_index)
    self:onUpdateChane_label(Chane_label_index)
    --state_machine.excute("adventure_mercenary_package_sort_update_attribute_info", 0, self.heroList[self.choiceIndex])
end

-- 刷新变更排序提示标签
function AdventureMercenaryAgreementChooseList:onUpdateChane_label(Chane_label_index)
    local label_index = Chane_label_index
    if label_index == 0 then
        self.chane_label:setString(tipStringInfo_hero_sort[1]) 
    elseif label_index == 1 then
        self.chane_label:setString(tipStringInfo_hero_sort[2])
    elseif label_index == 2 then
        self.chane_label:setString(tipStringInfo_hero_sort[3])
    elseif label_index == 3 then
        self.chane_label:setString(tipStringInfo_hero_sort[4])
    elseif label_index == 4 then
        self.chane_label:setString(tipStringInfo_hero_sort[5])
    end
end

function AdventureMercenaryAgreementChooseList:onUpdate(dt)
    if self.currentScrollView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentScrollView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentScrollView:getChildren()
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

function AdventureMercenaryAgreementChooseList:getSortedHeroes(indexs)
    local function fightingCapacity(a,b)
        local al = tonumber(a.hero_fight)
        local bl = tonumber(b.hero_fight)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end
    
    local function lvCapacity(a,b)
        local al = tonumber(a.ship_grade)
        local bl = tonumber(b.ship_grade)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end
    local function agreementCapacity(a ,b)
        local al = tonumber(a.agreementStates)
        local bl = tonumber(b.agreementStates)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end

    local function awakenCapacity(a,b)
        local shipData1 = dms.element(dms["ship_mould"], a.ship_template_id)
        local shipData2 = dms.element(dms["ship_mould"], b.ship_template_id)
        local al = dms.atoi(shipData1, ship_mould.initial_rank_level)
        local bl = dms.atoi(shipData2, ship_mould.initial_rank_level)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end

    local tSortedHeroes = {}
    -- 各星级武将数组
    local arrStarLevelHeroesWhite = {}--白
    local arrStarLevelHeroesGreen = {}--绿
    local arrStarLevelHeroesKohlrabiblue= {}--蓝
    local arrStarLevelHeroesPurple = {}--紫
    local arrStarLevelHeroesOrange = {}--橙
    local arrStarLevelHeroesRed = {}--红
    local arrStarLevelHeroesPink = {} --粉
    -- 主角放在第一位
    for i, ship in pairs(_ED.user_ship) do
        if ship.ship_id ~= nil and zstring.tonumber(ship.captain_type) ~=0 then
            
            local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
            if dms.atoi(shipData, ship_mould.ship_type) == 0 then
                table.insert(arrStarLevelHeroesWhite, ship)
            elseif dms.atoi(shipData, ship_mould.ship_type) == 1 then
                table.insert(arrStarLevelHeroesGreen, ship)
            elseif dms.atoi(shipData, ship_mould.ship_type) == 2 then
                table.insert(arrStarLevelHeroesKohlrabiblue, ship)
            elseif dms.atoi(shipData, ship_mould.ship_type) == 3 then
                table.insert(arrStarLevelHeroesPurple, ship)
            elseif dms.atoi(shipData, ship_mould.ship_type) == 4 then
                table.insert(arrStarLevelHeroesOrange, ship)
            elseif dms.atoi(shipData, ship_mould.ship_type) == 5 then
                table.insert(arrStarLevelHeroesRed, ship)
            elseif dms.atoi(shipData, ship_mould.ship_type) == 6 then
                table.insert(arrStarLevelHeroesPink, ship)
            end 
        end
    end
    -- table.sort(arrStarLevelHeroesWhite, fightingCapacity)
    for i=1, #arrStarLevelHeroesPink do
        table.insert(tSortedHeroes, arrStarLevelHeroesPink[i])
    end
    for i=1, #arrStarLevelHeroesRed do
        table.insert(tSortedHeroes, arrStarLevelHeroesRed[i])
    end
    for i=1, #arrStarLevelHeroesOrange do
        table.insert(tSortedHeroes, arrStarLevelHeroesOrange[i])
    end
    for i=1, #arrStarLevelHeroesPurple do
        table.insert(tSortedHeroes, arrStarLevelHeroesPurple[i])
    end
    for i=1, #arrStarLevelHeroesKohlrabiblue do
        table.insert(tSortedHeroes, arrStarLevelHeroesKohlrabiblue[i])
    end
    for i=1, #arrStarLevelHeroesGreen do
        table.insert(tSortedHeroes, arrStarLevelHeroesGreen[i])
    end
    for i=1, #arrStarLevelHeroesWhite do
        table.insert(tSortedHeroes, arrStarLevelHeroesWhite[i])
    end
    if indexs == 1 then  -- 觉醒等级排序
        table.sort(tSortedHeroes, awakenCapacity)
    elseif indexs == 2 then -- 战力等级排序
        table.sort(tSortedHeroes, fightingCapacity)
    elseif indexs == 3 then -- 等级排序
        table.sort(tSortedHeroes, lvCapacity)
    elseif indexs == 4 then 
        table.sort(tSortedHeroes, agreementCapacity)
    end
    self.heroList = tSortedHeroes
    return tSortedHeroes
end

function AdventureMercenaryAgreementChooseList:onEnterTransitionFinish()
    local csbAdventureHeroAwaken = csb.createNode("packs/Mercenary/yongbing_qiyuelist.csb")
    local root = csbAdventureHeroAwaken:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureHeroAwaken)
    self.chane_label = ccui.Helper:seekWidgetByName(root, "Text_16")
    self.chane_label:setVisible(true)
    Chane_label_index = 4

    self.alreadyAgreementAnimation = nil -- 已经签约动画
    self.agreementSuccessAnimation = nil -- 签约成功动画
    
    self:onUpdateDraw()
    -- 点击选择
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        terminal_name = "adventure_mercenary_agreement_choose_list_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --弹出排序
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_choose"),       nil, 
    {
        terminal_name = "adventure_mercenary_agreement_choose_list_sort",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:updateDraw()
end

function AdventureMercenaryAgreementChooseList:onExit()
    state_machine.remove("adventure_mercenary_agreement_choose_liset_close")
    state_machine.remove("adventure_mercenary_agreement_choose_list_sort")    
    state_machine.remove("adventure_mercenary_agreement_choose_list_sort_update")    
end
