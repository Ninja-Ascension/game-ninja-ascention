----------------------------------------------------------------------------------------------------
-- 说明：武将强化专属列表 --强化锻造
----------------------------------------------------------------------------------------------------
AdventureHeroListStrengthCell = class("AdventureHeroListCellClass", Window)
AdventureHeroListStrengthCell.__size = nil

app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
app.load("client.adventure.cells.skill.adventure_skill_icon_cell")
app.load("client.adventure.mercenary.formation.AdventureFateStrengthen")
app.load("client.adventure.mercenary.formation.AdventureStrengthenManager")

function AdventureHeroListStrengthCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.hero = nil
	self.mould_data = nil
	self.drawIndex = 0
    self.updateButton = nil
    self.autoSendMessage = {}
    self.shipId = nil
    self.qianghuaButton = nil
    self.isHaveBaoju = nil
    self.pressTime = 0 
	
	-- Initialize adventure hero list cell state machine.
	local function init_adventure_hero_list_update_cell_terminal()
		-- 强化
        local adventure_hero_list_cell_strengthen_terminal = {
            _name = "adventure_hero_list_cell_strengthen",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                local cell = params._datas.cell
                local hero = cell.hero
                if tonumber(hero.captain_type) == 0 then -- 主角宿命武器
                    fwin:open(AdventureFateStrengthen:new():init(hero, cell,"adventure_hero_list_cell_update_info"), fwin._ui)
                else -- 武具、宝具强化
                    fwin:open(AdventureStrengthenManager:new():init(hero, cell,"adventure_hero_list_cell_update_info"), fwin._ui)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 锻造
        local adventure_hero_list_cell_equipment_strengthen_terminal = {
            _name = "adventure_hero_list_cell_equipment_strengthen",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local hero = cell.hero
                if tonumber(hero.captain_type) == 0 then -- 主角宿命武器
                    fwin:open(AdventureFateStrengthen:new():init(hero, cell), fwin._ui)
                else -- 武具、宝具强化
                    fwin:open(AdventureStrengthenManager:new():init(hero, cell), fwin._ui)
                    state_machine.excute("adventure_strengthen_manager_manager", 0, 
                        {_datas = {
                            terminal_name = "adventure_strengthen_manager_manager",     
                            next_terminal_name = "adventure_strengthen_manager_open_treasure_strengthen",      
                            current_button_name = "Button_tab_baoju",        
                            but_image = "",   
                            terminal_state = 0, 
                            isPressedActionEnabled = false
                        }}
                    )
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

      
        -- 刷新显示信息
        local adventure_hero_list_cell_update_info_terminal = {
            _name = "adventure_hero_list_cell_update_info",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if fwin:find("AdventureHeroListCellClass")  then
                    fwin:find("AdventureHeroListCellClass"):updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开英雄信息
        local adventure_hero_list_cell_open_hero_info_terminal = {
            _name = "adventure_hero_list_cell_open_hero_info",
            _init = function (terminal)
                app.load("client.adventure.packs.hero.AdventureHeroInformation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                
                fwin:open(AdventureHeroInformation:new():init(cell.hero, cell), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_hero_list_cell_strengthen_terminal)
        state_machine.add(adventure_hero_list_cell_equipment_strengthen_terminal)
        state_machine.add(adventure_hero_list_cell_open_hero_info_terminal)
        
        state_machine.init()
	end

	-- call func init adventure hero list cell state machine.
	init_adventure_hero_list_update_cell_terminal()
end

function AdventureHeroListStrengthCell:playAction()
	-- local action = self.actions[1]
	-- action:play("upgrade", false)

    -- local pos = self:convertToWorldSpaceAR(cc.p(self:getPosition()))
    -- pos.x = pos.x + app.baseOffsetX / 2
    -- -- pos.y = pos.y + self:getContentSize().height
    -- app.load("client.adventure.packs.hero.AdventureHeroLevelUpAction")
    -- fwin:open(AdventureHeroLevelUpAction:new():init(pos.x,pos.y, self))
    if self.actions ~= nil and self.actions[1] ~= nil then 
        self.actions[1]:play("level_up",false)
    end
end

function AdventureHeroListStrengthCell:updateDraw()
	local root = self.roots[1]

    if root == nil then 
         -- 玩家在很快 拖动时候,会不停的reload,unload
        return false
    end
    -- 绘制品质底框
    local hero_mould_data = _ED.user_ship["" .. self.shipId]

    self.mould_data = hero_mould_data.mould_data or dms.element(dms["ship_mould"], hero_mould_data.ship_template_id)

    quality = dms.atoi(self.mould_data, ship_mould.ship_type)
    local qualityImage = string.format("images/ui/quality/icon_hero_%d.png", quality+1)
    ccui.Helper:seekWidgetByName(root, "Panel_pingzhi_di"):setBackGroundImage(qualityImage)

   -- 绘制图像
   local picIndex = dms.atos(self.mould_data, ship_mould.head_icon)
   local headImage = string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(picIndex))
   
   ccui.Helper:seekWidgetByName(root, "Panel_role"):setBackGroundImage(headImage)
    
    -- 绘制等级
    local level = zstring.tonumber(self.hero.ship_grade)
    ccui.Helper:seekWidgetByName(root, "Text_role_dj"):setString("" .. level)

    -- 突破等级
    local advanceLevel, maxAdvanceLevel = getShipAwakenLv2(self.hero.ship_template_id, self.hero.ship_base_template_id)
    local advancePanel = ccui.Helper:seekWidgetByName(root, "Panel_pingzhi")
    for i = 1, 5 do
        local cell = advancePanel:getChildByName("Image_pz_" .. i)
        if i > maxAdvanceLevel then
            cell:setVisible(false)
        else
            cell:setVisible(true)
            if i > advanceLevel then
                cell:setColor(cc.c3b(150, 150, 150))
            else
                cell:setColor(cc.c3b(255, 255, 255))
            end
        end
    end

    -- 绘制武将名称
    local Text_rolename = ccui.Helper:seekWidgetByName(root, "Text_rolename")
    Text_rolename:setColor(cc.c3b(hero_name_color_Type[quality+1][1],hero_name_color_Type[quality+1][2],hero_name_color_Type[quality+1][3]))
    if tonumber(self.hero.captain_type) == 0 then
        Text_rolename:setString(_ED.user_info.user_name)
        if ___is_open_leadname == true then
            Text_rolename:setFontName("")
            Text_rolename:setFontSize(Text_rolename:getFontSize())
        end
    else
        Text_rolename:setString(self.hero.captain_name)
    end

    -- 绘制武将的战力
    local Text_zhanli_all = ccui.Helper:seekWidgetByName(root, "Text_zhanli_all")
    Text_zhanli_all:setString(getResourceValueToStringForAdventure(self.hero.hero_fight))

    local maxStrengthenLevel = 0
    if tonumber(self.hero.captain_type) == 0 then
        maxStrengthenLevel = #dms["destiny_strength_param"]
    else
        maxStrengthenLevel = #dms["ship_rank_up_param"]
    end

    local equipment_strengthen_level = zstring.tonumber(self.hero.equipment_strengthen_level)
    local Button_duanzhao = ccui.Helper:seekWidgetByName(root, "Button_duanzhao")
    local Button_qianghua = ccui.Helper:seekWidgetByName(root, "Button_qianghua")
    
    if equipment_strengthen_level < maxStrengthenLevel then
        Button_duanzhao:setVisible(false)
        Button_qianghua:setVisible(true)
        -- 强化-战力加成
        local Text_zhanlibi = ccui.Helper:seekWidgetByName(root, "Text_zhanlibi")
        -- 提升前的战力提升
        if tonumber(self.hero.captain_type) == 0 then
            --主角
            local currentLevel = zstring.tonumber(self.hero.equipment_strengthen_level)
            local currentDestinyStrengthParam = dms.element(dms["destiny_strength_param"], (currentLevel))
    
            local showZhanli = "" .. (dms.atoi(currentDestinyStrengthParam, destiny_strength_param.property_add_rate) or 0) .."%"

            Text_zhanlibi:setString("+" .. showZhanli)
        else
            Text_zhanlibi:setString("+" .. zstring.tonumber(dms.string(dms["ship_rank_up_param"], equipment_strengthen_level, ship_rank_up_param.add_power)) .. "%")
        end
        

        -- 强化-等级信息
        local Text_qianghua = ccui.Helper:seekWidgetByName(root, "Text_qianghua")
        Text_qianghua:setString("" .. equipment_strengthen_level .. "/" .. maxStrengthenLevel)
    else
        Button_qianghua:setVisible(false)
    end
    -- 锻造
    local treasure_strengthen_level = zstring.tonumber(self.hero.treasure_strengthen_level)
    local tslOpenLevel = dms.int(dms["pirates_config"], 312, pirates_config.param)
    if equipment_strengthen_level >= tslOpenLevel and treasure_strengthen_level <= 0 then
        Button_duanzhao:setVisible(true)

        local skillMouldId = dms.atoi(self.mould_data, ship_mould.treasureSkill)
        local equipInfo = dms.element(dms["equipment_mould"], skillMouldId)
        local picIndex = dms.atos(equipInfo, equipment_mould.pic_index)
        if equipInfo == nil then 
            self.isHaveBaoju = false
            Button_duanzhao:setVisible(false)
        else
            self.isHaveBaoju = true
        end
        local Panel_prop = ccui.Helper:seekWidgetByName(Button_duanzhao, "Panel_prop")
        Panel_prop:setBackGroundImage(string.format("images/face/hero_head/bg_skill_skill_%d.png", zstring.tonumber(picIndex)))
    else
        Button_duanzhao:setVisible(false)
    end

end

function AdventureHeroListStrengthCell:onUpdate(dt)
   
end

function AdventureHeroListStrengthCell:onUpdateUpStates()
    local root = self.roots[1]
    if root == nil then
        return
    end
  
   
end

function AdventureHeroListStrengthCell:onInit()
	self.roots = {}
    self.actions = {}
	local root = cacher.createUIRef("list/list_team_zhanli_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
    root:setSwallowTouches(false)
    -- 刷新的时候移到前面来,放置玩家在拖动的时候,程序很快的 reload unreLoad 可能影响不大
    self:updateDraw()

    local action = csb.createTimeline("list/list_team_zhanli_1.csb")
    table.insert(self.actions, action)
    root:runAction(action)
    
	if AdventureHeroListStrengthCell.__size == nil then
		AdventureHeroListStrengthCell.__size = root:getContentSize()
	end

    -- 强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qianghua"),       nil, 
    {
        terminal_name = "adventure_hero_list_cell_strengthen",       
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_pingzhi_di")
    Panel_role:setTouchEnabled(true)
    --Panel_role:setSwallowTouches(false)
    --打开英雄信息界面
    fwin:addTouchEventListener(Panel_role,       nil, 
    {
        terminal_name = "adventure_hero_list_cell_open_hero_info",       
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 锻造
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_duanzhao"),       nil, 
    {
        terminal_name = "adventure_hero_list_cell_equipment_strengthen",       
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureHeroListStrengthCell:onExit()
	cacher.freeRef("list/list_team_zhanli_1.csb", self.roots[1])
    self.roots = {}
    state_machine.remove("adventure_hero_list_cell_strengthen")
    state_machine.remove("adventure_hero_list_cell_equipment_strengthen")
    
end

function AdventureHeroListStrengthCell:init(hero,shipid, drawIndex)
	self.hero = hero
    self.shipId = shipid
	self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
	self.drawIndex = drawIndex

	if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	end

	self:setContentSize(AdventureHeroListStrengthCell.__size)
	return self
end

function AdventureHeroListStrengthCell:reload()
	local root = self.roots[1]
    self.pressTime = 0 
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureHeroListStrengthCell:unload()
	local root = self.roots[1]
    self.pressTime = 0 
	if root == nil then
		return
	end
    if self.actions[1] ~= nil then 
        self.actions[1]:stop()
        self.actions = nil
    end
	cacher.freeRef("list/list_team_zhanli_1.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()

	root:removeFromParent(false)
	self.roots = {}
end

function AdventureHeroListStrengthCell:createCell()
	local cell = AdventureHeroListStrengthCell:new()
	cell:registerOnNodeEvent(cell)
    if missionIsOver() == true then
        cell:registerOnNoteUpdate(cell)
    end
	return cell
end

