----------------------------------------------------------------------------------------------------
-- 说明：限时优惠道具
----------------------------------------------------------------------------------------------------
ActivityLimitRechargeIconCell = class("ActivityLimitRechargeIconCellClass", Window)

function ActivityLimitRechargeIconCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._propData = nil
    self._propIndex = 0
    self._haveCounts = 0
    self._propName = ""
    self._growUpValue = 0 --成长值
    self._current_progress = 0
    
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.prop.prop_money_icon")

    local function init_activity_limit_recharge_icon_cell_terminal()
        --购买
        local activity_limit_recharge_icon_cell_buy_terminal = {
            _name = "activity_limit_recharge_icon_cell_buy",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDrawWeekRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(67)
                            local textData = {}
                            local addValue = response.node._growUpValue
                            if response.node._current_progress >= 100 then 
                                addValue = 0
                            end
                            table.insert(textData, {property = _activity_new_tip_string_info[6], value = response.node._growUpValue})
                            table.insert(textData, {property = _activity_new_tip_string_info[7], value = ""})
                            table.insert(textData, {property = _activity_new_tip_string_info[8] .. response.node._propName, value = ""})
                            app.load("client.cells.utils.property_change_tip_info_cell") 
                            local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
                            tipInfo:init(14,str, textData)  
                            fwin:open(tipInfo, fwin._windows)
                            response.node:onUpdateDraw()
                            state_machine.excute("activity_limit_time_coupons_update", 0, 0) 
                        end
                    end
                end
                local cell = params._datas.cell
                protocol_command.limited_recharge_buy.param_list = ""..cell._propData._id
                NetworkManager:register(protocol_command.limited_recharge_buy.code, nil, nil, nil, cell, responseDrawWeekRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_limit_recharge_icon_cell_buy_terminal)
        state_machine.init()
    end
    init_activity_limit_recharge_icon_cell_terminal()
end

function ActivityLimitRechargeIconCell:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    self._current_progress = _ED.limit_recharege_info.current_progress
    self._propData = _ED.limit_recharege_info.props[self._propIndex]
    local propPanel = ccui.Helper:seekWidgetByName(root, "Panel_props")
    propPanel:removeAllChildren(true)
    local limitData = dms.element(dms["limited_prop_mould"],self._propData._id)
    local items = zstring.split(dms.atos(limitData,limited_prop_mould.item_info),",")
    local rewardIcon = ResourcesIconCell:createCell()      
    rewardIcon:init(items[1], items[3], items[2],nil,nil,true)
    self._propName = rewardIcon:showName(zstring.tonumber(items[2]),zstring.tonumber(items[1]))
    propPanel:addChild(rewardIcon)
    local buyPanel = ccui.Helper:seekWidgetByName(root, "Panel_zy")
    local buyButton = ccui.Helper:seekWidgetByName(root, "Button_goumai")
    local buyText = ccui.Helper:seekWidgetByName(root, "Text_jg")
    local yjBuyText = ccui.Helper:seekWidgetByName(root, "Text_ygm")
    self._growUpValue = dms.atoi(limitData,limited_prop_mould.progress)
    buyPanel:removeBackGroundImage()
    local nowItems = zstring.split(dms.atos(limitData,limited_prop_mould.discount_price),",")
    if self._propData._buy_counts > 0 then 
        --不能购买了
        buyButton:setBright(false)
        buyButton:setTouchEnabled(false)
        buyText:setString("")
        yjBuyText:setVisible(true)
    else
        yjBuyText:setVisible(false)
        buyButton:setBright(true)
        buyButton:setTouchEnabled(true)
        
        local newPrice = zstring.tonumber(nowItems[3])
        buyText:setString("" ..newPrice)
        self:onUpdateDrawBuyIcon(buyPanel,zstring.tonumber(nowItems[1]))
        if self._haveCounts > newPrice then 
            --可以购买
            buyText:setColor(cc.c3b(_activity_limit_color[4][1], _activity_limit_color[4][2], _activity_limit_color[4][3])) 
        else
            buyText:setColor(cc.c3b(_activity_limit_color[3][1], _activity_limit_color[3][2], _activity_limit_color[3][3])) 
        end
    end

    local zhekouText = ccui.Helper:seekWidgetByName(root, "Text_zhekou")
    zhekouText:setColor(cc.c3b(255, 255, 255))
    local zhekou = dms.atos(limitData,limited_prop_mould.discount_percent)
    zhekou = zstring.tonumber(zhekou)
    local imageLine = ccui.Helper:seekWidgetByName(root, "Image_1_0")
    if zhekou > 0 then 
        imageLine:setVisible(true)
        zhekouText:setString(zhekou .. _activity_new_tip_string_info[1])
        zhekouText:setVisible(true)
        if zhekou >= 7 then 
            zhekouText:setColor(cc.c3b(_activity_limit_color[2][1], _activity_limit_color[2][2], _activity_limit_color[2][3])) 
        elseif  zhekou <= 6 then 
            zhekouText:setColor(cc.c3b(_activity_limit_color[3][1], _activity_limit_color[3][2], _activity_limit_color[3][3])) 
        end
    else
        imageLine:setVisible(false)
        zhekouText:setVisible(false)
    end
    local beforeItems = zstring.split(dms.atos(limitData,limited_prop_mould.normal_price),",")
    local buyPanel2 = ccui.Helper:seekWidgetByName(root, "Panel_zy_0")
    self:onUpdateDrawBuyIcon(buyPanel2,zstring.tonumber(beforeItems[1]))
    ccui.Helper:seekWidgetByName(root, "Text_yj1"):setString(beforeItems[3])
end

function ActivityLimitRechargeIconCell:onUpdateDrawBuyIcon(panel,buytype)
    if panel == nil then 
        return
    end
    panel:removeBackGroundImage()
    if buytype == 1 then 
        --银币
        panel:setBackGroundImage("images/ui/icon/icon_gold.png")
        self._haveCounts = zstring.tonumber(_ED.user_info.user_silver)
    elseif buytype == 2 then 
        --钻石
        panel:setBackGroundImage("images/ui/icon/icon_gem.png")
        self._haveCounts = zstring.tonumber(_ED.user_info.user_gold)
    elseif buytype == 5 then 
        --将魂
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
            panel:setBackGroundImage("images/ui/icon/icon_jianghun.png")
        else
            panel:setBackGroundImage("images/ui/icon/icon_shumahun.png")
        end
        self._haveCounts = zstring.tonumber(_ED.user_info.jade)
    elseif buytype == 18 then 
        --威望
        panel:setBackGroundImage("images/ui/icon/icon_shengwang_2.png")
        self._haveCounts = zstring.tonumber(_ED.user_info.all_glories)
    elseif buytype == 28 then 
        --军团贡献
        panel:setBackGroundImage("images/ui/icon/icon_juntuan.png")
        self._haveCounts = _ED.limit_recharege_info.union_contribution
    end
end

function ActivityLimitRechargeIconCell:initDraw()
    local csbActivityLimitRechargeIconCell= nil

    csbActivityLimitRechargeIconCell= csb.createNode("activity/wonderful/limited_time_discount_list_1.csb")
  
    local root = csbActivityLimitRechargeIconCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
    table.insert(self.roots, root)
    local Panel_kfjj_list = ccui.Helper:seekWidgetByName(root, "Panel_kfjj_list")
    self:setContentSize(Panel_kfjj_list:getContentSize())

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_goumai"),       nil, 
    {
        terminal_name = "activity_limit_recharge_icon_cell_buy",      
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0):setSwallowTouches(false)
end

function ActivityLimitRechargeIconCell:onEnterTransitionFinish()
    if self.roots[1] ~= nil then
        self:onUpdateDraw()
    end
end

function ActivityLimitRechargeIconCell:onExit()

end

function ActivityLimitRechargeIconCell:init(index,listView)
    self._propIndex = index
    self:initDraw()
    return self
end

function ActivityLimitRechargeIconCell:createCell()
    local cell = ActivityLimitRechargeIconCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end
