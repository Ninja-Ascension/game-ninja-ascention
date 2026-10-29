----------------------------------------------------------------------------------------------------
-- 说明：限时优惠道具
----------------------------------------------------------------------------------------------------
ActivityLevelGiftListCell = class("ActivityLevelGiftListCellClass", Window)

function ActivityLevelGiftListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._propData = nil
    self._paramId = 0 -- level_gift_bag_param ID
    self._mouldId = 0 -- level_gift_bag_mould ID
    self._index = 0 --索引
    self._button_get = nil -- 领取奖励按钮
    self._button_buy = nil -- 购买按钮
    self._remainTimes = 0 --剩余购买次数

    
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.prop.prop_money_icon")
    
    local function init_activity_level_gift_list_cell_cell_terminal()
        --购买
        local activity_level_gift_list_cell_cell_buy_terminal = {
            _name = "activity_level_gift_list_cell_cell_buy",
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
                            getRewardWnd:init(68)
                            fwin:open(getRewardWnd,fwin._ui)
                          response.node:onUpdateDraw()
                        end
                    end
                end
                local cell = params._datas.cell
                protocol_command.level_gift_buy.param_list = "".. cell._paramId .. "\r\n" ..  cell._mouldId .. "\r\n" .. "1" .. "\r\n" .. "1"
                NetworkManager:register(protocol_command.level_gift_buy.code, nil, nil, nil, cell, responseDrawWeekRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --领取奖励
        local activity_level_gift_list_cell_get_terminal = {
            _name = "activity_level_gift_list_cell_get",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDrawWeekRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(68)
                            fwin:open(getRewardWnd,fwin._ui)
                        end
                    end
                end
                local cell = params._datas.cell
                protocol_command.level_gift_buy.param_list = "".. cell._paramId .. "\r\n" ..  cell._mouldId .. "\r\n" .. "1" .. "\r\n" .. "0"
                NetworkManager:register(protocol_command.level_gift_buy.code, nil, nil, nil, cell, responseDrawWeekRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(activity_level_gift_list_cell_cell_buy_terminal)
        state_machine.add(activity_level_gift_list_cell_get_terminal)
        state_machine.init()
    end
    init_activity_level_gift_list_cell_cell_terminal()
end

function ActivityLevelGiftListCell:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local current_showBtn = nil --当前显示的操作按钮
    local current_showText = ""
    local goods_type = dms.atoi(self._propData,level_gift_bag_mould.gift_type)
    self._mouldId = dms.atoi(self._propData,level_gift_bag_mould.id)
    if goods_type == 0 then 
        --领取
        self._button_buy:setVisible(false)
        self._button_get:setVisible(true)
        current_showBtn = self._button_get 
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
            current_showText = _string_piece_info[431]
        else
            current_showText = _string_piece_info[389]
        end
    else
        --购买
        self._button_buy:setVisible(true)
        self._button_get:setVisible(false)
        current_showBtn = self._button_buy 
        current_showText = _string_piece_info[372]
    end
    local items = zstring.split(dms.atos(self._propData,level_gift_bag_mould.goods_type),",")
    local rewardIcon = ResourcesIconCell:createCell()      
    rewardIcon:init(items[1], items[3], items[2],nil,nil,true)
    local propPanel = ccui.Helper:seekWidgetByName(root, "Panel_6")
    propPanel:removeAllChildren(true)
    propPanel:addChild(rewardIcon)
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    Text_name:setString(rewardIcon.propName)
    Text_name:setColor(cc.c3b(color_Type[rewardIcon.quality + 1][1],color_Type[rewardIcon.quality + 1][2],color_Type[rewardIcon.quality + 1][3]))

    local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    Panel_icon:removeBackGroundImage()
    local buytype = dms.atos(self._propData,level_gift_bag_mould.buy_type)
    if buytype ~= "-1" then 
        local buys = zstring.split(buytype,",")
        self:onUpdateDrawBuyIcon(Panel_icon,zstring.tonumber(buys[1]))
        ccui.Helper:seekWidgetByName(root, "Text_5"):setString("".. buys[3])
    end
    
    local zhekouText = ccui.Helper:seekWidgetByName(root, "Text_zhekou")
    zhekouText:setColor(cc.c3b(255, 255, 255))
    local zhekou = dms.atoi(self._propData,level_gift_bag_mould.discount)

    if zhekou > 0 then 
        zhekouText:setString(zhekou .. _activity_new_tip_string_info[1])
        zhekouText:setVisible(true)
        if zhekou >= 7 then 
            zhekouText:setColor(cc.c3b(_activity_limit_color[2][1], _activity_limit_color[2][2], _activity_limit_color[2][3])) 
        elseif  zhekou <= 6 then 
            zhekouText:setColor(cc.c3b(_activity_limit_color[3][1], _activity_limit_color[3][2], _activity_limit_color[3][3])) 
        end
    else
        zhekouText:setVisible(false)
    end
    local Text_gmcs = ccui.Helper:seekWidgetByName(root, "Text_gmcs")
    local propStates = _ED.Level_gift_init_status[self._paramId]
    local max_count = dms.atoi(self._propData,level_gift_bag_mould.buy_times)
    local need_level = dms.int(dms["level_gift_bag_param"] , self._paramId,level_gift_bag_param.level_limit)

    if propStates ~= nil then 
        --计算购买次数--服务器数据
        local buyCounts = zstring.split("" ..propStates.buy_times , "," )[self._index] -- 已经购买了的次数
        self._remainTimes = max_count - buyCounts 
        if self._remainTimes > 0 then 
            --可以购买/领取
            current_showBtn:setTouchEnabled(true)
            current_showBtn:setColor(cc.c3b(255,255,255))
        else
            current_showBtn:setTouchEnabled(false)
            current_showBtn:setColor(cc.c3b(150,150,150))
        end
        Text_gmcs:setString(string.format(current_showText,self._remainTimes))
    end
    local user_level = zstring.tonumber(_ED.user_info.user_grade)
    if need_level > user_level then 
        current_showBtn:setVisible(false)
    end 
end

function ActivityLevelGiftListCell:onUpdateDrawBuyIcon(panel,buytype)
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
        panel:setBackGroundImage("images/ui/icon/icon_shumahun.png")
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

function ActivityLevelGiftListCell:initDraw()
    local csbActivityLevelGiftListCell= nil

    csbActivityLevelGiftListCell= csb.createNode("activity/wonderful/list_Levelpacks.csb")
  
    local root = csbActivityLevelGiftListCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
    table.insert(self.roots, root)
    local Panel_5 = ccui.Helper:seekWidgetByName(root, "Panel_5")
    self:setContentSize(Panel_5:getContentSize())
    
    self._button_get = ccui.Helper:seekWidgetByName(root, "Button_lq") -- 领取奖励按钮
    self._button_buy = ccui.Helper:seekWidgetByName(root, "Button_2") -- 购买按钮
    self:onUpdateDraw()
    ---购买
    fwin:addTouchEventListener(self._button_buy,       nil, 
    {
        terminal_name = "activity_level_gift_list_cell_cell_buy",      
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    ---领取
    fwin:addTouchEventListener(self._button_get,       nil, 
    {
        terminal_name = "activity_level_gift_list_cell_get",      
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    
end

function ActivityLevelGiftListCell:onEnterTransitionFinish()
   
end

function ActivityLevelGiftListCell:onExit()

end

function ActivityLevelGiftListCell:init(id,data,index)
    self._paramId = id
    self._propData = data
    self._index = index
    self:initDraw()
    return self
end

function ActivityLevelGiftListCell:createCell()
    local cell = ActivityLevelGiftListCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end
