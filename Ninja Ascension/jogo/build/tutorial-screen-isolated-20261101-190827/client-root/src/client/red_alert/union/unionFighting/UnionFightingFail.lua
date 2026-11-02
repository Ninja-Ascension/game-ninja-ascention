UnionFightingFail = class("UnionFightingFailClass", Window)

local union_fighting_fail_open_terminal = {
	_name = "union_fighting_fail_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("UnionFightingFailClass") == nil then
            fwin:open(UnionFightingFail:new():init(params), fwin._ui)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_fail_close_terminal = {
	_name = "union_fighting_fail_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionFightingFailClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_fail_open_terminal)
state_machine.add(union_fighting_fail_close_terminal)
state_machine.init()

function UnionFightingFail:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
end

function UnionFightingFail:onInit(params)
	local csbUnion = csb.createNode(config_csb.big_map.map_legion_battle_fail)
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_record_sure"), nil, 
    {
        terminal_name = "union_fighting_fail_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    local Text_record_describe = ccui.Helper:seekWidgetByName(root, "Text_record_describe")
    local Text_record_enemy = ccui.Helper:seekWidgetByName(root, "Text_record_enemy")
    local Text_record_even_cut = ccui.Helper:seekWidgetByName(root, "Text_record_even_cut")
    local Text_record_troops = ccui.Helper:seekWidgetByName(root, "Text_record_troops")
    local Text_record_glory = ccui.Helper:seekWidgetByName(root, "Text_record_glory")

    Text_record_describe:removeAllChildren(true)
    Text_record_describe:setString("")
    local fontSize = Text_record_describe:getFontSize()
    local fontName = Text_record_describe:getFontName()

    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)
    _richText2:setContentSize(cc.size(440, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))

    local info1 = _ED.union_fight_city_user_hp_info.user_name
    local rtre1 = ccui.RichElementText:create(1, union_fight_report_color[13], 255, info1, fontName, fontSize)
    _richText2:pushBackElement(rtre1)

    local info2 = tipStringInfo_union_str[118]
    local rtre2 = ccui.RichElementText:create(1, union_fight_report_color[12], 255, info2, fontName, fontSize)
    _richText2:pushBackElement(rtre2)

    local city_name = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],_ED.union_fight_city_user_hp_info.city_id,warfare_map_mould.city_name)
    local info3 = "["..city_name.."]"
    local rtre3 = ccui.RichElementText:create(1, union_fight_report_color[13], 255, info3, fontName, fontSize)
    _richText2:pushBackElement(rtre3)

    local info4 = tipStringInfo_union_str[119]
    local rtre4 = ccui.RichElementText:create(1, union_fight_report_color[12], 255, info4, fontName, fontSize)
    _richText2:pushBackElement(rtre4)

    _richText2:setPositionX(-250)
    Text_record_describe:addChild(_richText2)

    Text_record_enemy:setString(_ED.union_fight_city_user_hp_info.kill_count)
    Text_record_even_cut:setString(_ED.union_fight_city_user_hp_info.win_times)
    Text_record_troops:setString(_ED.union_fight_city_user_hp_info.total_hurt)
    Text_record_glory:setString(_ED.union_fight_city_user_hp_info.union_resource)
end

function UnionFightingFail:onEnterTransitionFinish()
end

function UnionFightingFail:init(params)
    self:onInit(params)
	return self
end

function UnionFightingFail:onExit()

end
