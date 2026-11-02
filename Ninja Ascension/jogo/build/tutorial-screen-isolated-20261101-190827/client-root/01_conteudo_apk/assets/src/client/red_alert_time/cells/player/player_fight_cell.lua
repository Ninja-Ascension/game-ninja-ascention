----------------------------------------------------------------------------------------------------
-- 说明：用户战力提升途径
-------------------------------------------------------------------------------------------------------
PlayerFightCell = class("PlayerFightCellClass", Window)
PlayerFightCell.__size = nil

local player_fight_create_cell_terminal = {
    _name = "player_fight_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PlayerFightCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(player_fight_create_cell_terminal)
state_machine.init()

function PlayerFightCell:ctor()
    self.super:ctor()
	self.roots = {}		

	self._index = 0
    self._info = nil

    self._need_legion = false

    app.load("client.red_alert_time.build_up.BuildUpBbuildQuickly")
    app.load("client.red_alert_time.player.PlayerFightTip")
 	local function init_player_fight_cell_terminal()
        -- 查看详情
        local player_fight_cell_infor_terminal = {
            _name = "player_fight_cell_infor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local cell = params._datas.cell
                state_machine.excute("player_fight_tip_open",0,{cell._info.dec})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 前往
        local player_fight_cell_goto_terminal = {
            _name = "player_fight_cell_goto",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell._need_legion == true then
                    TipDlg.drawTextDailog(tipString_fight_upgrade[21])
                    return
                end
                state_machine.excute("short_cut_go_to_other_window",0,{cell._info.short_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(player_fight_cell_infor_terminal)
        state_machine.add(player_fight_cell_goto_terminal)
        state_machine.init()
    end
	init_player_fight_cell_terminal()        	
end

function PlayerFightCell:onUpdateDraw()
	local root = self.roots[1]
    -- icon
	local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    local Panel_props_que_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_que_icon")
    local Panel_attribute_icon = ccui.Helper:seekWidgetByName(root, "Panel_attribute_icon")
    Panel_props_icon:removeBackGroundImage()
    Panel_props_que_icon:removeBackGroundImage()
    Panel_attribute_icon:removeBackGroundImage()

    local pic_index = _ED.strategy_combat_info[""..self._index].pic
    Panel_props_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
    Panel_props_que_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[2]))
    Panel_attribute_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[6]))

    -- name
    local Text_fight_up_name = ccui.Helper:seekWidgetByName(root, "Text_fight_up_name")
    Text_fight_up_name:setString(self._info.name)

    -- 百分比
    local LoadingBar_up_ing = ccui.Helper:seekWidgetByName(root, "LoadingBar_up_ing")
    local Text_up_ing_n = ccui.Helper:seekWidgetByName(root, "Text_up_ing_n")

    local Button_infor = ccui.Helper:seekWidgetByName(root,"Button_infor")
    Button_infor:setBright(true)
    Button_infor:setTouchEnabled(true)

    local progress = 0
    local text_progress = "0%"
    -- local describe_1 = ""
    -- local describe_2 = ""
    -- local describe_3 = ""
    -- local describe_4 = ""
    -- local describe_5 = ""
    -- local quality_1 = 1
    -- local quality_2 = 1
    -- local quality_3 = 1
    -- local quality_4 = 1
    -- local quality_5 = 1
    -- local fun_open = true
    self._need_legion = false

    if self._index == 1 then        -- 统率等级
        -- describe_1 = tipString_fight_upgrade[1]
        -- local prop_id = dms.int(dms["prop_config"], 12, prop_config.param)
        -- describe_2 = zstring.tonumber(getPropAllCountByMouldId(prop_id))
        -- quality_1 = 1
        -- quality_2 = 2
        progress = 100 * zstring.tonumber(_ED.user_info.command_level) / zstring.tonumber(_ED.user_info.user_grade)
        text_progress = math.floor(progress) .."%"

    elseif self._index == 2 then    -- 技能等级
        -- describe_1 = tipString_fight_upgrade[2]
        -- local prop_id = dms.int(dms["prop_config"], 9, prop_config.param)
        -- describe_2 = zstring.tonumber(getPropAllCountByMouldId(prop_id))
        -- quality_1 = 1
        -- quality_2 = 6
        local total_level = 0
        for k, v in pairs(_ED.base_skill_info) do
            local level = zstring.tonumber(_ED.majesty_info[v.index])
            total_level = total_level + level
        end
        progress =(100 * total_level / zstring.tonumber(_ED.user_info.user_grade))/table.nums(_ED.base_skill_info)
        text_progress = math.ceil(progress) .."%"

    elseif self._index == 3 then    -- 配件品质
        local grow_level = 0
        local grow_level_1 = 0
        local grow_level_2 = 0
        local grow_level_3 = 0
        local grow_level_4 = 0
        local grow_level_5 = 0
        for k, v in pairs(_ED.user_equiment) do
            if v.armor_type == 0 then
                if tonumber(v.is_equiped) == 0 then
                    if v.grow_level == 1 then
                        grow_level_1 = grow_level_1 + 1
                    elseif v.grow_level == 2 then
                        grow_level_2 = grow_level_2 + 1
                    elseif v.grow_level == 3 then
                        grow_level_3 = grow_level_3 + 1
                    elseif v.grow_level == 4 then
                        grow_level_4 = grow_level_4 + 1
                    else
                        grow_level_5 = grow_level_5 + 1
                    end
                else
                    grow_level = grow_level + v.grow_level
                end
            end
        end
        if grow_level_5 > 0 then 
            describe_2 = grow_level_5
        elseif grow_level_4 > 0 then 
            describe_2 = grow_level_4
        elseif grow_level_3 > 0 then 
            describe_2 = grow_level_3
        elseif grow_level_2 > 0 then 
            describe_2 = grow_level_2
        elseif grow_level_1 > 0 then 
            describe_2 = grow_level_1
        else
            describe_2 = 0
        end
        progress = 100 * grow_level / 128
        text_progress = math.floor(progress) .."%"

        -- if funOpenDrawTip(156,false) == true then
        --     fun_open = false
        --     describe_1 = tipString_fight_upgrade[12]
        --     quality_1 = 7
        --     describe_2 = ""
        -- else
        --     describe_1 = tipString_fight_upgrade[3]
        --     quality_2 = 2
        -- end

    elseif self._index == 4 then    -- 配件升级
        -- if funOpenDrawTip(156,false) == true then
        --     fun_open = false
        --     describe_1 = tipString_fight_upgrade[12]
        --     quality_1 = 7
        -- else
        --     describe_1 = tipString_fight_upgrade[4]
        --     quality_1 = 2
        -- end
        local upgrade_level = 0 
        for k, v in pairs(_ED.user_equiment) do
            if v.armor_type == 0 then
                upgrade_level = upgrade_level + v.upgrade_level
            end
        end
        local need_level_info = zstring.split(dms.string(dms["equipment_config"], 7, equipment_config.param), "|")
        need_level_info = zstring.split(need_level_info[1],",")
        local counts = 0
        for k,v in pairs(need_level_info) do
            if tonumber(_ED.user_info.user_grade) >= tonumber(v) then
                counts = counts + 1
            end
        end
        counts = counts * 4
        if counts > 0 then
            progress = 100 * upgrade_level / (zstring.tonumber(_ED.user_info.user_grade)*counts)
        else
            progress = 0
        end
        text_progress = math.floor(progress) .."%"

    elseif self._index == 5 then    -- 配件改造
        -- if funOpenDrawTip(156,false) == true then
        --     fun_open = false
        --     describe_1 = tipString_fight_upgrade[12]
        --     quality_1 = 7
        -- else
        --     describe_1 = tipString_fight_upgrade[5]
        --     quality_1 = 2
        -- end
        local rank_up_level = 0 
        for k, v in pairs(_ED.user_equiment) do
            if v.armor_type == 0 then
                rank_up_level = rank_up_level + v.rank_up_level
            end
        end
        local counts = 0
        local need_level_info = zstring.split(dms.string(dms["equipment_config"], 7, equipment_config.param), "|")
        need_level_info = zstring.split(need_level_info[1],",")
        for k,v in pairs(need_level_info) do
            if tonumber(_ED.user_info.user_grade) >= tonumber(v) then
                counts = counts + 1
            end
        end
        counts = counts * 4 * 5
        if counts > 0 then
            progress = 100 * rank_up_level / counts
        else
            progress = 0
        end
        text_progress = math.floor(progress) .."%"

    elseif self._index == 6 then    -- 科技升级
        -- if funOpenDrawTip(153,false) == true then
        --     fun_open = false
        --     describe_1 = tipString_fight_upgrade[12]
        --     quality_1 = 7
        -- else
        --     describe_1 = tipString_fight_upgrade[6]
        --     quality_1 = 2
        -- end
        
        local barrack_level = 0
        for k,v in pairs(_ED.base_barracks_info) do
            if _ED.barracks_info[""..k] ~= nil then
                if v.order <= 8 then
                    v.barrack_level = zstring.tonumber(_ED.barracks_info[""..k].barrack_level)
                    barrack_level = barrack_level + v.barrack_level
                end
            end
        end
        progress = 100 * barrack_level / (zstring.tonumber(_ED.user_info.user_grade)*8)
        text_progress = math.floor(progress) .."%"

    elseif self._index == 7 then    -- 主力部队
        local factory_level = tonumber(_ED.home_build["9"].level)
        if _ED.home_build["10"] ~= nil and tonumber(_ED.home_build["10"].level) > factory_level then
            factory_level = tonumber(_ED.home_build["10"].level)
        end
        local next_tank_id = 0
        local next_boatyard_level = 0
        for i = 1, 100 do
            local boatyard_level = dms.int(dms["ship_mould"], i, ship_mould.boatyard_level)        -- 开启等级
            if boatyard_level > 0 and boatyard_level <= factory_level then
                if next_boatyard_level == 0  or boatyard_level > next_boatyard_level then
                    next_boatyard_level = boatyard_level
                    next_tank_id = i
                end
            end
        end
        local tank_name = dms.string(dms["ship_mould"], next_tank_id, ship_mould.captain_name)        -- 名称
        local current_count = 0
        for k, v in pairs(_ED.user_ship) do
            if tonumber(v.ship_template_id) == next_tank_id then
                current_count = current_count + tonumber(v.ship_count) - tonumber(v.lose_ship_count)
            end
        end
        local max_count = 6 * tonumber(_ED.user_info.soldier)
        local count = max_count - current_count
        if count < 0 then
            count = 0
        end
        
        progress = math.min(100,100 * current_count / max_count)
        text_progress = math.floor(progress) .."%"
        -- if progress >= 100 then
        --     describe_1 = tipString_fight_upgrade[15]
        --     quality_1 = 7
        -- else
        --     describe_1 = tipString_fight_upgrade[7]
        --     quality_1 = 2
        --     describe_2 = tank_name
        --     quality_2 = 6
        --     describe_3 = tipString_fight_upgrade[8]
        --     quality_3 = 2
        --     describe_4 = count
        --     quality_4 = 6
        --     describe_5 = tipString_fight_upgrade[9]
        --     quality_5 = 2
        -- end
    elseif self._index == 8 then    -- 部队满编
        local vip_count = dms.int(dms["base_consume"], 81, tonumber(_ED.vip_grade) + 4)
        local max_count = vip_count * 6 * tonumber(_ED.user_info.soldier)
        local current_count = 0
        for k, v in pairs(_ED.user_ship) do
            if tonumber(v.camp_preference) ~= 0 then
                current_count = current_count + tonumber(v.ship_count) - tonumber(v.lose_ship_count)
            end
        end
        local count = max_count - current_count
        if count < 0 then
            count = 0
        end

        progress = math.min(100,100 * current_count / max_count)
        text_progress = math.floor(progress) .."%"

        -- if progress >= 100 then
        --     describe_1 = tipString_fight_upgrade[15]
        --     quality_1 = 7
        -- else
        --     describe_1 = tipString_fight_upgrade[10]
        --     quality_1 = 2
        --     describe_2 = count
        --     quality_2 = 6
        --     describe_3 = tipString_fight_upgrade[11]
        --     quality_3 = 2
        -- end

    elseif self._index == 9 then    -- 军团科技
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            then
            -- describe_1 = tipString_fight_upgrade[12]
            -- quality_1 = 7
            -- fun_open = false
            self._need_legion = true
        else
            local open_level = dms.int(dms["union_science_mould"], 10, union_science_mould.open_level)
            local legion_level = tonumber(_ED.union.union_info.union_grade)
            if legion_level < open_level then
                -- describe_1 = tipString_fight_upgrade[12]
                -- quality_1 = 7
                -- fun_open = false
            else
                local total_level = 0
                for i = 10, 13 do
                    total_level = total_level + tonumber(_ED.union_science_info[""..i].level)
                end
                progress = math.floor((total_level * 100) / (legion_level * 4))
                text_progress = math.floor(progress) .."%"

                -- local times_info = zstring.split(_ED.union_science_donate_times, ",")
                -- local max_times = dms.int(dms["base_consume"], 91, base_consume.vip_0_value + tonumber(_ED.vip_grade))
                -- local can_donate = false
                -- for i = 1, 5 do
                --     if tonumber(times_info[i]) < max_times then
                --         can_donate = true
                --         break
                --     end
                -- end 
                -- if can_donate == true then
                --     describe_1 = tipString_fight_upgrade[16]
                --     quality_1 = 2
                --     fun_open = true
                -- else
                --     describe_1 = tipString_fight_upgrade[17]
                --     quality_1 = 2
                --     fun_open = false
                -- end
            end
        end
    elseif self._index == 10 then   -- 繁荣度战力
        progress = 100 * zstring.tonumber(_ED.user_info.booming)/zstring.tonumber(_ED.user_info.forage)
        text_progress = math.floor(progress) .."%"
        -- if progress < 100 then
        --     describe_1 = tipString_fight_upgrade[14]
        --     quality_1 = 2
        -- else
        --     describe_1 = tipString_fight_upgrade[13]
        --     quality_1 = 7
        -- end

    elseif self._index == 11 then   -- 装甲品质
        local grow_level = 0
        local grow_level_1 = 0
        local grow_level_2 = 0
        local grow_level_3 = 0
        local grow_level_4 = 0
        local grow_level_5 = 0
        for k, v in pairs(_ED.user_equiment) do
            if v.armor_type > 0 then
                if tonumber(v.formation_type) == 0 then
                    if v.grow_level == 0 then
                        grow_level_1 = grow_level_1 + 1
                    elseif v.grow_level == 1 then
                        grow_level_2 = grow_level_2 + 1
                    elseif v.grow_level == 2 then
                        grow_level_3 = grow_level_3 + 1
                    elseif v.grow_level == 3 then
                        grow_level_4 = grow_level_4 + 1
                    else
                        grow_level_5 = grow_level_5 + 1
                    end
                else
                    grow_level = grow_level + (v.grow_level + 1)
                end
            end
        end

        progress = 100 * grow_level / 180
        text_progress = math.floor(progress) .."%"

        -- if grow_level_5 > 0 then 
        --     describe_2 = grow_level_5
        -- elseif grow_level_4 > 0 then 
        --     describe_2 = grow_level_4
        -- elseif grow_level_3 > 0 then 
        --     describe_2 = grow_level_3
        -- elseif grow_level_2 > 0 then 
        --     describe_2 = grow_level_2
        -- elseif grow_level_1 > 0 then 
        --     describe_2 = grow_level_1
        -- else
        --     describe_2 = 0
        -- end
        -- describe_1 = tipString_fight_upgrade[18]
        -- quality_2 = 2

    elseif self._index == 12 then   -- 装甲等级
        -- if funOpenDrawTip(156,false) == true then
        --     fun_open = false
        -- end
        local upgrade_level = 0 
        for k, v in pairs(_ED.user_equiment) do
            if v.armor_type > 0 and v.formation_type > 0 then
                upgrade_level = upgrade_level + tonumber(v.upgrade_level)
            end
        end

        counts = 36
        if counts > 0 then
            progress = 100 * upgrade_level / (zstring.tonumber(_ED.user_info.user_grade)*counts)
        else
            progress = 0
        end
        text_progress = math.floor(progress) .."%"

        -- if upgrade_level == 0 then
        --     fun_open = false
        --     describe_1 = tipString_fight_upgrade[20]
        --     quality_1 = 7
        -- else
        --     describe_1 = tipString_fight_upgrade[19]
        --     quality_1 = 2
        -- end
    end
    LoadingBar_up_ing:setPercent(progress)
    Text_up_ing_n:setString(text_progress)

    -- infor
    -- local Text_up_infor = ccui.Helper:seekWidgetByName(root, "Text_up_infor")
    -- Text_up_infor:removeAllChildren(true)
    -- local fontSize = Text_up_infor:getFontSize()

    -- local _richText = ccui.RichText:create()
    -- _richText:ignoreContentAdaptWithSize(false)       
    -- local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[quality_1][1],color_Type[quality_1][2],color_Type[quality_1][3]),255, describe_1, "fonts/simhei.ttf",fontSize)
    -- _richText:pushBackElement(re1)  
    -- local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[quality_2][1],color_Type[quality_2][2],color_Type[quality_2][3]),255, describe_2, "fonts/simhei.ttf",fontSize)
    -- _richText:pushBackElement(re2)
    -- local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[quality_3][1],color_Type[quality_3][2],color_Type[quality_3][3]),255, describe_3, "fonts/simhei.ttf",fontSize)
    -- _richText:pushBackElement(re3)
    -- local re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[quality_4][1],color_Type[quality_4][2],color_Type[quality_4][3]),255, describe_4, "fonts/simhei.ttf",fontSize)
    -- _richText:pushBackElement(re4)
    -- local re5 = ccui.RichElementText:create(1, cc.c3b(color_Type[quality_5][1],color_Type[quality_5][2],color_Type[quality_5][3]),255, describe_5, "fonts/simhei.ttf",fontSize)
    -- _richText:pushBackElement(re5)
    -- _richText:setPosition(cc.p(Text_up_infor:getContentSize().width/2,Text_up_infor:getContentSize().height/2))
    -- _richText:setContentSize(cc.size(Text_up_infor:getContentSize().width,fontSize))
    -- Text_up_infor:addChild(_richText)
    -- if progress >= 100 
    --     or fun_open == false then
    --     -- Button_infor:setBright(false)
    --     -- Button_infor:setTouchEnabled(false)
    -- end
end

function PlayerFightCell:onEnterTransitionFinish()

end

function PlayerFightCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.player.player_fight_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if PlayerFightCell.__size == nil then
		PlayerFightCell.__size = root:getContentSize()
	end
    -- 前往
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_infor"), nil, 
    {
        terminal_name = "player_fight_cell_goto",
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,
    },
    nil,1)

    -- -- 详情
    -- fwin:addTouchEventListener(root, nil, 
    -- {
    --     terminal_name = "player_fight_cell_infor",
    --     terminal_state = 0,
    --     cell = self,
    --     touch_black = true,
    -- },
    -- nil,1)

	self:onUpdateDraw()
end

function PlayerFightCell:onExit()
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.player.player_fight_cell, self.roots[1])
end

function PlayerFightCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PlayerFightCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    local Text_fight_up_name = ccui.Helper:seekWidgetByName(root, "Text_fight_up_name")
    local LoadingBar_up_ing = ccui.Helper:seekWidgetByName(root, "LoadingBar_up_ing")
    local Text_up_ing_n = ccui.Helper:seekWidgetByName(root, "Text_up_ing_n")
    local Text_up_infor = ccui.Helper:seekWidgetByName(root, "Text_up_infor")
    local Button_infor = ccui.Helper:seekWidgetByName(root,"Button_infor")
    local Panel_props_que_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_que_icon")
    local Panel_attribute_icon = ccui.Helper:seekWidgetByName(root, "Panel_attribute_icon")
    if Panel_props_icon ~= nil then
        Panel_props_icon:removeBackGroundImage()
        Panel_props_que_icon:removeBackGroundImage()
        Panel_attribute_icon:removeBackGroundImage()
        Text_fight_up_name:setString("")
        LoadingBar_up_ing:setPercent(0)
        Text_up_ing_n:setString("")
        Text_up_infor:removeAllChildren(true)
        Button_infor:setBright(true)
        Button_infor:setTouchEnabled(true)
    end
end

function PlayerFightCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.player.player_fight_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function PlayerFightCell:init(params)
    self._index = params[1]
    self._info = params[2]
    -- if self._index <= 6 then
	   self:onInit()
    -- end
	self:setContentSize(PlayerFightCell.__size)
end

