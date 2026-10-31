-----------------------------
--VIP特权
-----------------------------
VipPrivilegeRedAlert = class("VipPrivilegeRedAlertClass", Window)
--打开
local vip_privilege_red_alert_window_open_terminal = {
    _name = "vip_privilege_red_alert_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(98) == true then
            return
        end 
        local panel = nil
        if nil == fwin:find("VipPrivilegeRedAlertClass") then
            panel = VipPrivilegeRedAlert:new():init(params)
            fwin:open(panel)
        end
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local vip_privilege_red_alert_window_close_terminal = {
    _name = "vip_privilege_red_alert_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("VipPrivilegeRedAlertClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(vip_privilege_red_alert_window_open_terminal)
state_machine.add(vip_privilege_red_alert_window_close_terminal)
state_machine.init()

function VipPrivilegeRedAlert:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_choose_vip = 0
    self._now_grade = 0
    -- vip等级上限
    self._vip_max_grade = 12 
    --奖励
    self.all_reward_datas = {}
    self.all_reward_datas.show_reward_list = {}

    app.load("client.red_alert.cells.shop.vip_privileges_cell")

    local function init_vip_privilege_red_alert_terminal()
        --领取
        local vip_privilege_red_alert_to_receive_terminal = {
            _name = "vip_privilege_red_alert_to_receive",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responeCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open",0,{4})
                        if response.node ~= nil and response.node.onUpdateDraw ~= nil then
                            response.node:onUpdateDraw(response.node._current_choose_vip)
                        end
                    end
                end
                local item = _ED.all_shop_info["2"][instance._current_choose_vip]
                if tonumber(item.original_cost) >  tonumber(_ED.user_info.user_gold) then 
                    TipDlg.drawTextDailog(_wonderful_string[3])
                    return
                end
                protocol_command.shop_buy_prop.param_list = ""..item.goods_case_id.."\r\n1\r\n"..item.shop_type
                NetworkManager:register(protocol_command.shop_buy_prop.code, nil, nil, nil, instance, responeCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local vip_privilege_red_alert_change_vip_title_terminal = {
            _name = "vip_privilege_red_alert_change_vip_title",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local vip_privilege_red_alert_refresh_terminal = {
            _name = "vip_privilege_red_alert_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:refresh(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(vip_privilege_red_alert_change_vip_title_terminal)
        state_machine.add(vip_privilege_red_alert_to_receive_terminal)
        state_machine.add(vip_privilege_red_alert_refresh_terminal)
        state_machine.init()
    end
    init_vip_privilege_red_alert_terminal()
end 

function VipPrivilegeRedAlert:refresh( ... )
    self:onUpdateDraw(self._current_choose_vip)
end

function VipPrivilegeRedAlert:onUpdateDraw(choose_index)
    self._current_choose_vip = choose_index
    local root = self.roots[1]
    local Text_vip_level_2 = ccui.Helper:seekWidgetByName(root, "Text_vip_level_2")
    local Text_vip_level_4 = ccui.Helper:seekWidgetByName(root, "Text_vip_level_4")
    local Text_privileges_charge = ccui.Helper:seekWidgetByName(root, "Text_privileges_charge")
    local ListView_privileges_infor = ccui.Helper:seekWidgetByName(root, "ListView_privileges_infor")
    local ListView_reward = ccui.Helper:seekWidgetByName(root, "ListView_reward")
    local Text_original_price_v = ccui.Helper:seekWidgetByName(root, "Text_original_price_v")
    local Text_discount_price_v = ccui.Helper:seekWidgetByName(root, "Text_discount_price_v")
    local Button_buy = ccui.Helper:seekWidgetByName(root, "Button_buy")
    local Text_cannot_buy = ccui.Helper:seekWidgetByName(root, "Text_cannot_buy")
    Text_original_price_v:setString("")
    Text_discount_price_v:setString("")
    Text_cannot_buy:setString("")
    ListView_reward:removeAllItems()
    ListView_privileges_infor:removeAllItems()
    Button_buy:setVisible(false)
    Text_vip_level_2:setString(""..self._current_choose_vip)
    Text_vip_level_4:setString(""..self._current_choose_vip)

    local nextNeedStr = dms.int(dms["base_consume"],8,(tonumber(base_consume.vip_0_value)+self._current_choose_vip-1))
    -- Text_privileges_charge:setString(string.format(red_alert_all_str[173], nextNeedStr/10, nextNeedStr, self._current_choose_vip))
    Text_privileges_charge:setString(string.format(red_alert_all_str[173], nextNeedStr/10, nextNeedStr))

    local text_str = zstring.split(_vip_privilege_info[tonumber(self._current_choose_vip)], "|")
    for i,v in pairs(text_str) do
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)
        local text_str_color = zstring.split(v,";")
        for j,k in pairs(text_str_color) do
            if tonumber(j) == 2 then 
                local re = ccui.RichElementText:create(1, cc.c3b(color_Type[26][1],color_Type[26][2],color_Type[26][3]),255, k, config_res.font.font_name, 20)
                _richText:pushBackElement(re)
            else
                local re = ccui.RichElementText:create(1, cc.c3b(color_Type[25][1],color_Type[25][2],color_Type[25][3]),255, k, config_res.font.font_name, 20)
                _richText:pushBackElement(re)
            end
        end
        _richText:setAnchorPoint(0.5,0.5)
        _richText:setContentSize(cc.size(ListView_privileges_infor:getContentSize().width,20))
        ListView_privileges_infor:addChild(_richText)
    end
    ListView_privileges_infor:requestRefreshView()

    local items = _ED.all_shop_info["2"]
    if items ~= nil then
        local item = items[self._current_choose_vip]
        local openInfos = zstring.split(item.open_info, ",")
        local addition_group_index = dms.string(dms["prop_mould"], item.goods_id, prop_mould.addition_group_index)
        local good_ids = zstring.split(dms.string(dms["scene_reward"], addition_group_index, scene_reward.reward_items), "|")
        for k,v in pairs(good_ids) do
            local info = zstring.split(v, ",")
            local id = info[1]
            local ntype = info[2]
            local count = info[3]
            local data = 
            {
                item_value = tonumber(count),
                prop_type = tonumber(ntype),
                prop_item = tonumber(id),
            }
            local cell = state_machine.excute("all_resource_create_cell",0,{10,data,data,2,0,true,true})
            ListView_reward:addChild(cell)
        end

        Text_original_price_v:setString(item.sell_price)
        Text_discount_price_v:setString(item.original_cost)
        if tonumber(_ED.vip_grade) >= tonumber(openInfos[2]) then
            if tonumber(item.remain_times) == 0 then
                Text_cannot_buy:setString(red_alert_all_str[175])
            else
                Button_buy:setVisible(true)
            end
        else
            Text_cannot_buy:setString(string.format(red_alert_all_str[176], tonumber(openInfos[2])))
        end
    end
    ListView_reward:requestRefreshView()

    local ListView_left = ccui.Helper:seekWidgetByName(root,"ListView_left")
    for k,v in pairs(ListView_left:getItems()) do
        if k == self._current_choose_vip then
            v._isChoose = true
        else
            v._isChoose = false
        end
        v:setUnChooseState()
    end
end

function VipPrivilegeRedAlert:onUpdateList( ... )
    local root = self.roots[1]
    local ListView_left = ccui.Helper:seekWidgetByName(root,"ListView_left")
    ListView_left:removeAllItems()
    for i=1,12 do
        local cell = state_machine.excute("vip_privileges_create_cell", 0, i)
        ListView_left:addChild(cell)
    end
    ListView_left:requestRefreshView()
end

function VipPrivilegeRedAlert:onInit()
    local csbItem = csb.createNode(config_csb.shop.vip_privileges_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --购买
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_buy"), nil, 
    {
        terminal_name = "vip_privilege_red_alert_to_receive", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    
    self:onUpdateList()
    self:onUpdateDraw(1)
end


function VipPrivilegeRedAlert:init(params)
    self._rootWindows = params[1]
	self:onInit()
    return self
end

function VipPrivilegeRedAlert:onExit()
    state_machine.remove("vip_privilege_red_alert_to_receive")
    state_machine.remove("vip_privilege_red_alert_change_vip_title")
    state_machine.remove("vip_privilege_red_alert_refresh")
end