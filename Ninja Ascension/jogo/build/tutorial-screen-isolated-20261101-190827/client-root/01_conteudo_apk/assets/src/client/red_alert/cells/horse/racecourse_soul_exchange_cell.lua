
RaceCourseSoulExchangeCell = class("RaceCourseSoulExchangeCellClass", Window)
RaceCourseSoulExchangeCell.__size = nil

local racecource_soul_exchange_create_cell_terminal = {
    _name = "racecource_soul_exchange_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return RaceCourseSoulExchangeCell:new():init(params)
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(racecource_soul_exchange_create_cell_terminal)
state_machine.init()

function RaceCourseSoulExchangeCell:ctor()
	self.super:ctor()
	self.roots = {}
    self._index = 0
    self._recharge_id = 0
    self._horse_recharge_id = 0
    self._recharge_infos = ""
    
    local function init_racecource_soul_exchange_cell_terminal()
        local racecource_soul_exchange_terminal = {
            _name = "racecource_soul_exchange",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local function respondCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("racecource_soul_exchange_refreash", 0, nil)
                        state_machine.excute("racecourse_scrollview_on_update_all", 0, nil)
                        state_machine.excute("reward_obtain_window_open",0,{75})
                        state_machine.excute("racecourse_update_draw", 0, nil)
                        state_machine.excute("racecourse_ride_update_draw", 0, nil)
                    end
                end
                protocol_command.horse_spirit_pay.param_list = ""..cell._recharge_id
                NetworkManager:register(protocol_command.horse_spirit_pay.code, nil, nil, nil, cell, respondCallBack, false, nil)           
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(racecource_soul_exchange_terminal)
        state_machine.init()
    end
    
    init_racecource_soul_exchange_cell_terminal()
end

function RaceCourseSoulExchangeCell:updateDraw()
    local root = self.roots[1]
    --附魔icon
    local Panel_soul_picture = ccui.Helper:seekWidgetByName(root, "Panel_soul_picture")
    local icon = dms.int(dms["horse_spirit_mould"], self._horse_recharge_id, horse_spirit_mould.icon)
    Panel_soul_picture:setBackGroundImage(string.format("images/ui/enchant/enchant_%d.png", icon))

    --附魔名称
    local Text_soul_name = ccui.Helper:seekWidgetByName(root, "Text_soul_name")
    local horse_spirit_name = dms.string(dms["horse_spirit_mould"], self._horse_recharge_id, horse_spirit_mould.horse_spirit_name)
    Text_soul_name:setString(horse_spirit_name)

    --附魔等级
    local Text_soul_lv = ccui.Helper:seekWidgetByName(root, "Text_soul_lv")
    local level = dms.int(dms["horse_spirit_mould"], self._horse_recharge_id, horse_spirit_mould.level)
    Text_soul_lv:setString(string.format(red_alert_all_str[117], ""..level))

    --属性
    local Text_soul_use = ccui.Helper:seekWidgetByName(root, "Text_soul_use")
    local Text_soul_use_number = ccui.Helper:seekWidgetByName(root, "Text_soul_use_number")
    local attributes = dms.string(dms["horse_spirit_mould"], self._horse_recharge_id, horse_spirit_mould.attributes)
    local attributes_info = zstring.split(attributes, ",")
    Text_soul_use:setString(attribute[tonumber(attributes_info[1]) + 1])
    local is_handred = false
    for i,v in pairs(attribute_hundred) do
        if tonumber(attributes_info[1]) == v then
            is_handred = true
        end
    end
    if is_handred == true then
        Text_soul_use_number:setString("+"..attributes_info[2].."%")
    else
        Text_soul_use_number:setString("+"..attributes_info[2])
    end
    --需要碎片
    local Text_need_piece_number = ccui.Helper:seekWidgetByName(root, "Text_need_piece_number")
    local recharge_infos = zstring.split(self._recharge_infos, ",")
    Text_need_piece_number:setString(""..recharge_infos[3])

end

function RaceCourseSoulExchangeCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.racecourse.racecourse_soul_exchange_cell)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    if RaceCourseSoulExchangeCell.__size == nil then
        RaceCourseSoulExchangeCell.__size = root:getContentSize()
    end

    -- 兑换
    local Button_exchange = ccui.Helper:seekWidgetByName(root, "Button_exchange")
    if missionIsOver() == true then
        Button_exchange:setSwallowTouches(false)
        local function panelTouchListener( sender, eventType )
            local __spoint = sender:getTouchBeganPosition()
            local __mpoint = sender:getTouchMovePosition()
            local __epoint = sender:getTouchEndPosition()

            if eventType == ccui.TouchEventType.began then
            elseif eventType == ccui.TouchEventType.moved then
            elseif eventType == ccui.TouchEventType.canceled then
            elseif eventType == ccui.TouchEventType.ended then
                if math.abs(__spoint.x - __epoint.x) <= 3 and math.abs(__spoint.y - __epoint.y) <= 3 then
                    state_machine.excute("racecource_soul_exchange", 0, {_datas = {cell = self}})
                end
            end
        end
        Button_exchange:addTouchEventListener(panelTouchListener)
    else
        fwin:addTouchEventListener(Button_exchange, nil, 
        {
            terminal_name = "racecource_soul_exchange", 
            terminal_state = 0, 
            cell = self, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 2) 
    end

	self:updateDraw()
end

function RaceCourseSoulExchangeCell:onEnterTransitionFinish()

end

function RaceCourseSoulExchangeCell:init(params)
    self._index = params[1]
    self._recharge_id = params[2]
    self._horse_recharge_id = params[3]
    self._recharge_infos = params[4]
	self:onInit()
    self:setContentSize(RaceCourseSoulExchangeCell.__size)
    return self
end

function RaceCourseSoulExchangeCell:onExit()

end