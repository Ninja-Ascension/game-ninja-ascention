--------------------------------------------------------------------------------------------------------------
--  说明：数码数码兽的控件
--------------------------------------------------------------------------------------------------------------
SmTrialTowerChangeWindowListCell = class("SmTrialTowerChangeWindowListCellClass", Window)
SmTrialTowerChangeWindowListCell.__size = nil

--创建cell
local sm_trial_tower_change_window_list_cell_terminal = {
    _name = "sm_trial_tower_change_window_list_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmTrialTowerChangeWindowListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(sm_trial_tower_change_window_list_cell_terminal)
state_machine.init()

function SmTrialTowerChangeWindowListCell:ctor()
	self.super:ctor()
	self.roots = {}
	 -- Initialize sm_trial_tower_change_window_list_cell state machine.
    local function init_sm_trial_tower_change_window_list_cell_terminal()

        local sm_trial_tower_change_window_go_battle_terminal = {
            _name = "sm_trial_tower_change_window_go_battle",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cells = params._datas.cells
                state_machine.excute("guan_qia_formation", 0, {cells.pages,cells.m_ship.ship_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_trial_tower_change_window_buff_use_terminal = {
            _name = "sm_trial_tower_change_window_buff_use",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cells = params._datas.cells
                state_machine.excute("sm_trial_tower_buff_select_add_ship_buff", 0, cells.m_ship.ship_id)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_trial_tower_change_window_go_battle_terminal)
        state_machine.add(sm_trial_tower_change_window_buff_use_terminal)

        state_machine.init()
    end 
    -- call func sm_trial_tower_change_window_list_cell create state machine.
    init_sm_trial_tower_change_window_list_cell_terminal()

end

function SmTrialTowerChangeWindowListCell:createHeadHead(ship, objectType, is_mould, ship_grade)
    app.load("client.cells.ship.ship_head_new_cell")
    local cell = ShipHeadNewCell:createCell()
    cell:init(ship,objectType, is_mould, {showNum = ship_grade})
    return cell
end

function SmTrialTowerChangeWindowListCell:updateDraw()
    local root = self.roots[1]
    --画头像
    local heroIcon = ccui.Helper:seekWidgetByName(root, "Panel_wujiang")
    heroIcon:removeAllChildren(true)
    local picCell = nil

    --画名称
    local heroName = ccui.Helper:seekWidgetByName(root, "Text_dengji")
    local rankLevelFront = dms.int(dms["ship_mould"], self.m_ship.ship_template_id, ship_mould.initial_rank_level)
    local str = ""
    if rankLevelFront ~= 0 then
        str = " +"..rankLevelFront
    end
    --进化形象
    local evo_image = dms.string(dms["ship_mould"], self.m_ship.ship_template_id, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    -- local ship_evo = zstring.split(self.m_ship.evolution_status, "|")
    -- local evo_mould_id = evo_info[tonumber(ship_evo[1])]
    local evo_mould_id = smGetSkinEvoIdChange(self.m_ship)
    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
    local word_info = dms.element(dms["word_mould"], name_mould_id)
    _name = word_info[3]
    heroName:setString(_name .. str)
    local quality = 1
    quality = shipOrEquipSetColour(tonumber(self.m_ship.Order))
    local color_R = tipStringInfo_quality_color_Type[quality][1]
    local color_G = tipStringInfo_quality_color_Type[quality][2]
    local color_B = tipStringInfo_quality_color_Type[quality][3]
    heroName:setColor(cc.c3b(color_R, color_G, color_B))

    --战力
    local Text_fighting_n = ccui.Helper:seekWidgetByName(root, "Text_fighting_n")
    Text_fighting_n:setString(self.m_ship.hero_fight)

    local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye")
    Panel_strengthen_stye:removeBackGroundImage()
    local camp_preference = dms.int(dms["ship_mould"], self.m_ship.ship_template_id, ship_mould.camp_preference)
    if camp_preference> 0 and camp_preference <=3 then
        Panel_strengthen_stye:setBackGroundImage(string.format("images/ui/icon/type_icon_%d.png", camp_preference))
    end

    local shipInfo = _ED.user_try_ship_infos[""..self.m_ship.ship_id]
    
    --血
    local LoadingBar_hp = ccui.Helper:seekWidgetByName(root, "LoadingBar_hp")
    if nil ~= shipInfo then
        LoadingBar_hp:setPercent(tonumber(shipInfo.maxHp))
    end

    --怒气
    local LoadingBar_mp = ccui.Helper:seekWidgetByName(root, "LoadingBar_mp") 
    local fightParams = zstring.split(dms.string(dms["fight_config"], 5 ,user_config.param),",")
    if nil ~= shipInfo then
        LoadingBar_mp:setPercent(tonumber(shipInfo.newanger)/tonumber(fightParams[4])*100)
    end

    --死了
    local Image_dead = ccui.Helper:seekWidgetByName(root, "Image_dead")
    
    --等级不够
    local Image_lvbz = ccui.Helper:seekWidgetByName(root, "Image_lvbz")

    ccui.Helper:seekWidgetByName(root, "Button_shangzhen"):setVisible(true)

    --print("--------self.m_ship.ship_grade-------"..self.m_ship.ship_grade)


    -- 等级不够
    if tonumber(self.m_ship.ship_grade) < dms.int(dms["play_config"], 24, play_config.param) then
        Image_lvbz:setVisible(true)
        Image_dead:setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Button_shangzhen"):setVisible(false)
        --picCell = self:createHeadHead(self.m_ship, 2, self.m_ship.ship_grade)
        picCell = self:createHeadHead(self.m_ship, 2, false, self.m_ship.ship_grade)
        heroIcon:addChild(picCell)
    else
        -- 等级足够
        Image_lvbz:setVisible(false)
        if nil ~= shipInfo and tonumber(_ED.user_try_ship_infos[self.m_ship.ship_id].newHp) <= 0 then
            Image_dead:setVisible(true)
            picCell = self:createHeadHead(self.m_ship, 2, false, self.m_ship.ship_grade)
            heroIcon:addChild(picCell)
            ccui.Helper:seekWidgetByName(root, "Button_shangzhen"):setVisible(false)
        else
            picCell = self:createHeadHead(self.m_ship, 2, true, self.m_ship.ship_grade)
            heroIcon:addChild(picCell)
            Image_dead:setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Button_shangzhen"):setVisible(true)
        end
    end

    ccui.Helper:seekWidgetByName(picCell.roots[1], "Image_3"):setVisible(false)
    for i = 1, 6 do
        local shipId = zstring.tonumber(_ED.user_formetion_status[i])
        if tonumber(self.m_ship.ship_id) == shipId then
            ccui.Helper:seekWidgetByName(root, "Button_shangzhen"):setVisible(false)
            ccui.Helper:seekWidgetByName(picCell.roots[1], "Image_3"):setVisible(true)
            break
        end
    end
end

function SmTrialTowerChangeWindowListCell:onUpdate(dt)

end

function SmTrialTowerChangeWindowListCell:onInit()
    local root = cacher.createUIRef("campaign/TrialTower/sm_trial_tower_change_window_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmTrialTowerChangeWindowListCell.__size == nil then
        SmTrialTowerChangeWindowListCell.__size = root:getContentSize()
    end

    --上阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shangzhen"), nil, 
    {
        terminal_name = "sm_trial_tower_change_window_go_battle", 
        terminal_state = 0, 
        touch_black = true,
		cells = self,
    }, nil, 1)

    --加buff
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok"), nil, 
    {
        terminal_name = "sm_trial_tower_change_window_buff_use", 
        terminal_state = 0, 
        touch_black = true,
        cells = self,
    }, nil, 1)

    if tonumber(self.pages) == 0 then
        ccui.Helper:seekWidgetByName(root, "Button_shangzhen"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Button_ok"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root, "Button_shangzhen"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Button_ok"):setVisible(false)
    end

	self:updateDraw(self.current_index)
end

function SmTrialTowerChangeWindowListCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function SmTrialTowerChangeWindowListCell:clearUIInfo( ... )
    local root = self.roots[1]
    
end

function SmTrialTowerChangeWindowListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmTrialTowerChangeWindowListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/TrialTower/sm_trial_tower_change_window_list.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmTrialTowerChangeWindowListCell:init(params)
    self.m_index = tonumber(params[1])
    self.m_ship = params[2]
    self.pages = params[3]
    if tonumber(self.pages) == 0 then
        self.buff_type = params[4]
    end
    if self.m_index < 6 then
    	self:onInit()
    end
    
    self:setContentSize(SmTrialTowerChangeWindowListCell.__size)
    return self
end

function SmTrialTowerChangeWindowListCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/TrialTower/sm_trial_tower_change_window_list.csb", self.roots[1])
end