-- ----------------------------------------------------------------------------------------------------
-- 说明：灵力转换的灵源
-------------------------------------------------------------------------------------------------------
AdventureMercenaryTransformServants = class("AdventureMercenaryTransformServantsClass", Window)
    
function AdventureMercenaryTransformServants:ctor()
    self.super:ctor()
    self.roots = {}
	self.hero = nil
	app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
	app.load("client.adventure.mercenary.transform.AdventureMercenaryTransformChoice")
	app.load("client.loader.formula")
    -- Initialize adventure mercenary transform state machine.
    local function init_adventure_mercenary_transform_servants_terminal()
		local adventure_mercenary_transform_servants_open_list_terminal = {
            _name = "adventure_mercenary_transform_servants_open_list",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(AdventureMercenaryTransformChoice:new():init(1, 1), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_mercenary_transform_servants_open_list_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mercenary transform state machine.
    init_adventure_mercenary_transform_servants_terminal()
end

function AdventureMercenaryTransformServants:init(hero, targetNode)
	self.hero = hero
	self.parentNod = targetNode
    return self
end

function AdventureMercenaryTransformServants:onEnterTransitionFinish()
    local csbAdventureMercenaryTransform = csb.createNode("packs/Mercenary/yongbing_xuanly.csb")
    local root = csbAdventureMercenaryTransform:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMercenaryTransform)
	
	local mould_data = dms.element(dms["ship_mould"], self.hero.ship_template_id)
	local has_baoju = dms.atoi(mould_data, ship_mould.treasureSkill) > 0
	
	local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
	Panel_role:removeAllChildren(true)
	local cell = AdventureHeroIconCell:createCell()
	cell:init(0, self.hero, 1, 0, nil, nil, nil, nil, 1)
	
	Panel_role:addChild(cell)
	local Text_rolename = ccui.Helper:seekWidgetByName(root, "Text_rolename")
	Text_rolename:setString(self.hero.captain_name)
	
	
	local Text_dengji_0 = ccui.Helper:seekWidgetByName(root, "Text_dengji_0")
	Text_dengji_0:setString("LV"..self.hero.ship_grade)
	local Text_dengji_0_0 = ccui.Helper:seekWidgetByName(root, "Text_dengji_0_0")
	Text_dengji_0_0:setString("1")
	
	--战力
	local Text_zhanli_0 = ccui.Helper:seekWidgetByName(root, "Text_zhanli_0")
	Text_zhanli_0:setString(self.hero.hero_fight)
	local Text_zhanli_1 = ccui.Helper:seekWidgetByName(root, "Text_zhanli_1")
	if zstring.tonumber(calculate_ship_fight_force(self.hero.ship_template_id,1,0,0)) < zstring.tonumber(self.hero.hero_fight) then
		Text_zhanli_1:setTextColor(cc.c4b(tipStringInfo_property_change_color_Type[6][1], tipStringInfo_property_change_color_Type[6][2], tipStringInfo_property_change_color_Type[6][3],255))
	end
	local basie_data = dms.atoi(mould_data, ship_mould.base_mould)
	Text_zhanli_1:setString(calculate_ship_fight_force(basie_data,1,0,0))
	
	--武具强化等级
	local rank_grow_up_limit = #dms["ship_rank_up_param"]
	local Text_qianghua_0 = ccui.Helper:seekWidgetByName(root, "Text_qianghua_0")
	Text_qianghua_0:setString(self.hero.equipment_strengthen_level.."/"..rank_grow_up_limit)
	local Text_qianghua_1 = ccui.Helper:seekWidgetByName(root, "Text_qianghua_1")
	if zstring.tonumber(self.hero.equipment_strengthen_level)> 0 then
		Text_qianghua_1:setTextColor(cc.c4b(tipStringInfo_property_change_color_Type[6][1], tipStringInfo_property_change_color_Type[6][2], tipStringInfo_property_change_color_Type[6][3],255))
	end
	Text_qianghua_1:setString("0/"..rank_grow_up_limit)
	
	--觉醒
	local Text_juexing_0 = ccui.Helper:seekWidgetByName(root, "Text_juexing_0")
	local CurrentAwakenLv,maxAwakenLv = getShipAwakenLv2(self.hero.ship_template_id,dms.atoi(mould_data, ship_mould.base_mould))
	Text_juexing_0:setString(CurrentAwakenLv.."/"..maxAwakenLv)
	local Text_juexing_1 = ccui.Helper:seekWidgetByName(root, "Text_juexing_1")
	if zstring.tonumber(CurrentAwakenLv) > 1 then
		Text_juexing_1:setTextColor(cc.c4b(tipStringInfo_property_change_color_Type[6][1], tipStringInfo_property_change_color_Type[6][2], tipStringInfo_property_change_color_Type[6][3],255))
	end
	Text_juexing_1:setString("1/"..maxAwakenLv)
	--宝具
	local Text_baoju_0 = ccui.Helper:seekWidgetByName(root, "Text_baoju_0")
	if (has_baoju == false) then
		Text_baoju_0:setString(_transform_equip_text[1])
	elseif	zstring.tonumber(self.hero.treasure_strengthen_level)>0 then
		Text_baoju_0:setString(_transform_equip_text[3])
	elseif zstring.tonumber(self.hero.treasure_strengthen_level)==0 then
		Text_baoju_0:setString(_transform_equip_text[2])
	end
	local Text_baoju_1 = ccui.Helper:seekWidgetByName(root, "Text_baoju_1")
	
	if (has_baoju == false) then
		Text_baoju_1:setString(_transform_equip_text[1])
	else
		Text_baoju_1:setString(_transform_equip_text[2])
	end
	
	--突破
	local Text_tupo_0 = ccui.Helper:seekWidgetByName(root, "Text_tupo_0")
	local curBreakLevel = tonumber(self.hero.ship_breakthrough_level)
	local addValue = get_ship_breakup_add_rate(curBreakLevel)
	
	--local CurrentAwakenLv,maxAwakenLv = getShipAwakenLv(self.hero.ship_template_id,dms.atoi(mould_data, ship_mould.base_mould))
	Text_tupo_0:setString(addValue..'%')
	local Text_tupo_1 = ccui.Helper:seekWidgetByName(root, "Text_tupo_1")
	
	Text_tupo_1:setString('0%')
	
	-- 选择灵源
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"),       nil, 
    {
        terminal_name = "adventure_mercenary_transform_servants_open_list",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	if (self.parentNod ~= nil and self.parentNod.heroServants ~= nil and self.parentNod.heroThemain ~= nil) then
		-- self.parentNod:onUpdateTerminal(self.parentNod.heroThemain)
		state_machine.excute("adventure_mercenary_transform_update_themain", 0, self.parentNod.heroThemain)
	end
end

function AdventureMercenaryTransformServants:onExit()
	
    state_machine.remove("adventure_mercenary_transform_servants_open_list")
end

function AdventureMercenaryTransformServants:createCell()
	local cell = AdventureMercenaryTransformServants:new()
	cell:registerOnNodeEvent(cell)
	return cell
end