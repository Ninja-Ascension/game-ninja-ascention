-----------------------------
-- 兽魂觉醒
-----------------------------
RacecourseSoulUp = class("RacecourseSoulUpClass", Window)
--打开
local racecourse_soul_up_window_open_terminal = {
    _name = "racecourse_soul_up_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _RacecourseSoulUpWindow = fwin:find("RacecourseSoulUpClass")
        if nil == _RacecourseSoulUpWindow then
            local horse_spilits = params[1]
            local index = params[2]
            fwin:open(RacecourseSoulUp:new():init(horse_spilits,index), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local racecourse_soul_up_window_close_terminal = {
    _name = "racecourse_soul_up_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RacecourseSoulUpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(racecourse_soul_up_window_open_terminal)
state_machine.add(racecourse_soul_up_window_close_terminal)
state_machine.init()

function RacecourseSoulUp:ctor()
    self.super:ctor()
    self.roots = {}
    -- 兽魂id
    self._horse_spilits = nil
    -- 兽魂在珍兽上的位置
    self._index = nil
    -- 觉醒增加属性
    self._text_table = {}

    local function init_racecourse_soul_up_terminal()

        -- 觉醒
        local racecourse_soul_up_awakening_terminal = {
            _name = "racecourse_soul_up_awakening",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("racecourse_ride_update_draw", 0, {response.node._index})
                            state_machine.excute("add_number_window_open",0,{29,response.node._text_table})
                            state_machine.excute("racecourse_attribute_window_close", 0, nil)
                            state_machine.excute("racecourse_soul_up_window_close", 0, nil)
                        end
                    end
                end
                protocol_command.horse_spirit_awaken.param_list = instance._horse_spilits.id
                NetworkManager:register(protocol_command.horse_spirit_awaken.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(racecourse_soul_up_awakening_terminal)
        state_machine.init()
    end
    init_racecourse_soul_up_terminal()
end 

function RacecourseSoulUp:onUpdateDraw()
    local root = self.roots[1]
    -- 获取觉醒对应后兽魂id
    -- 1获取当前兽魂总经验
    -- 2读表获取觉醒后兽魂初始id
    -- 3减去觉醒后兽魂初始所需经验获得可用于升级经验
    -- 4获取觉醒对应后兽魂id
    local make_exp = dms.int(dms["horse_spirit_mould"], self._horse_spilits.mould_id, horse_spirit_mould.make_exp)
    local now_experience = make_exp + self._horse_spilits.now_exp   -- 当前兽魂总经验
    local awakening_id = dms.int(dms["horse_spirit_mould"], self._horse_spilits.mould_id, horse_spirit_mould.awakening_id)-- 觉醒后兽魂初始id
    local awakening_make_exp = dms.string(dms["horse_spirit_mould"], awakening_id, horse_spirit_mould.make_exp)
    now_experience = now_experience - awakening_make_exp
    awakening_id = self:checkLevelUp(now_experience, 0, awakening_id)   -- 觉醒对应后兽魂id
    -- 兽魂icon
    local Panel_treasure_piece = ccui.Helper:seekWidgetByName(root, "Panel_treasure_piece")     
    local icon = dms.int(dms["horse_spirit_mould"], awakening_id, horse_spirit_mould.icon)
    Panel_treasure_piece:removeBackGroundImage()
    Panel_treasure_piece:setBackGroundImage(string.format("images/ui/enchant/enchant_%d.png", icon))  
    -- 兽魂名称      
    local Text_treasure_piece_name = ccui.Helper:seekWidgetByName(root, "Text_treasure_piece_name")     
    local name = dms.string(dms["horse_spirit_mould"], awakening_id, horse_spirit_mould.horse_spirit_name)
    local quality = dms.int(dms["horse_spirit_mould"], awakening_id, horse_spirit_mould.quality)
    Text_treasure_piece_name:setString(name)
    Text_treasure_piece_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    
    -- 觉醒后升级消耗经验
    local upgrade_cost_exp = dms.int(dms["horse_spirit_mould"], awakening_id, horse_spirit_mould.upgrade_cost_exp)
    
    -- 觉醒后兽魂拥有经验
    local ungrade_total_experience = dms.int(dms["horse_spirit_mould"], awakening_id, horse_spirit_mould.ungrade_total_experience)
    local awake_exp = now_experience - ungrade_total_experience
    -- 兽魂经验
    local LoadingBar_experience = ccui.Helper:seekWidgetByName(root, "LoadingBar_experience")           -- 兽魂经验百分比
    local Text_treasure_expreience = ccui.Helper:seekWidgetByName(root, "Text_treasure_expreience")     -- 兽魂经验值
    Text_treasure_expreience:setString(awake_exp.."/"..upgrade_cost_exp)
    LoadingBar_experience:setPercent(tonumber(awake_exp)/upgrade_cost_exp * 100)
    -- 属性
    local Text_attribute_infor = ccui.Helper:seekWidgetByName(root, "Text_attribute_infor")             -- 属性名
    local Text_attribute_n = ccui.Helper:seekWidgetByName(root, "Text_attribute_n")                     -- 属性值
    local attributes = dms.string(dms["horse_spirit_mould"], awakening_id, horse_spirit_mould.attributes)
    local attributes_info = zstring.split(attributes, ",")
    Text_attribute_infor:setString(attribute[tonumber(attributes_info[1]) + 1])
    local is_handred = false
    for i,v in pairs(attribute_hundred) do
        if tonumber(attributes_info[1]) == v then
            is_handred = true
        end
    end
    local attributes_data = nil
    if is_handred == true then
        Text_attribute_n:setString()
        attributes_data = "+"..attributes_info[2].."%"
    else
        attributes_data = "+"..attributes_info[2]
    end
    Text_attribute_n:setString(attributes_data)
    local add_attributes_data = attribute[tonumber(attributes_info[1]) + 1] .. attributes_data
    table.insert(self._text_table,add_attributes_data)

    local Panel_por_icon = ccui.Helper:seekWidgetByName(root, "Panel_por_icon")                         -- 所需材料icon
    -- 所需材料数量
    local Text_por_n = ccui.Helper:seekWidgetByName(root, "Text_por_n")                                 
    local need_numbers = 0
    local quality = dms.int(dms["horse_spirit_mould"], awakening_id, horse_spirit_mould.quality)
    if quality == 5 then
        need_numbers = dms.int(dms["horse_config"], 14, horse_config.param)
    elseif quality == 6 then 
        need_numbers = dms.int(dms["horse_config"], 15, horse_config.param)
    end
    Text_por_n:setString("x"..need_numbers)
    local Text_hero_star_gold_have = ccui.Helper:seekWidgetByName(root, "Text_hero_star_gold_have")     -- 当前拥有材料数量
    Text_hero_star_gold_have:setString(string.format(red_alert_all_str[18],_ED.user_info.horse_spirits_patch))

end

--检测升级状态
function RacecourseSoulUp:checkLevelUp(get_exp,now_exp,now_mould_id)
    local up_need_exp = dms.int(dms["horse_spirit_mould"],now_mould_id,horse_spirit_mould.upgrade_cost_exp)
    local leave_exp = 0
    --如果获得经验和拥有经验大于等于升级所需经验
    if get_exp + now_exp >= up_need_exp then
        local next_mould_id = dms.int(dms["horse_spirit_mould"],now_mould_id,horse_spirit_mould.next_level_id)
        --如果已达到最大等级返回当前等级id
        if next_mould_id == -1 then
            return now_mould_id
        else --如果未达到最大等级返回剩下经验值下一级附魔id
            leave_exp = get_exp + now_exp - up_need_exp
            return self:checkLevelUp(leave_exp,0,next_mould_id)
        end
    else  --如果获得经验和拥有经验小于升级所需经验返回当前等级id
        return now_mould_id    
    end
end

function RacecourseSoulUp:onInit()
    local csbItem = csb.createNode(config_csb.horse.treasure_soul_up)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "racecourse_soul_up_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)

    -- 觉醒
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_soul_up"), nil, 
    {
        terminal_name = "racecourse_soul_up_awakening", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)

    self:onUpdateDraw()
end

function RacecourseSoulUp:init(horse_spilits,index)
    self._horse_spilits = horse_spilits
    self._index = index
	self:onInit()
    return self
end

function RacecourseSoulUp:onExit()
end