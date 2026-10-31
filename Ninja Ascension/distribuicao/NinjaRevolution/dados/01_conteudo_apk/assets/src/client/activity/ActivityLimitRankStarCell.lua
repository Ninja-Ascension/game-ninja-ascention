-- ----------------------------------------------------------------------------------------------------
-- 说明：数码活动成就类型cell
-------------------------------------------------------------------------------------------------------
ActivityLimitRankStarCell = class("ActivityLimitRankStarCellClass", Window)
    
function ActivityLimitRankStarCell:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.utils.activity_reword_cell")
    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.shop.recharge.RechargeDialog")
    app.load("client.reward.DrawRareReward")
    app.load("client.cells.prop.prop_money_icon")
    app.load("client.l_digital.activity.wonderful.PathGrowth")
    self.example = nil
    self.index = 0
    self.activityType = 0
    self.rewardState = 0

    self.reworld_sorting = {}
    -- Initialize ActivityLimitRankStarCell state machine.
    local function init_ActivityLimitRankStarCell_terminal()
        
        --领取
        local activity_limit_rank_achieve_reward_terminal = {
            _name = "activity_limit_rank_achieve_reward",
            _init = function (terminal) 
                app.load("client.activity.ActivityLimitRank")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.active_activity[143] == nil then
                    return
                end

                local _self = params._datas._cell

                local function callBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- response.node:isDrawedUpdateDraw()
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._ui)
                        state_machine.excute("activity_limit_rank_update",0, _self._type)
                    else
                        local function callBack(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                state_machine.excute("activity_limit_rank_update",0, _self._type)
                            end
                        end
                        protocol_command.get_activity_reward.param_list = "".._ED.active_activity[143].activity_id.."\r\n".. -1 .."\r\n".."1"
                        NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, _self, callBack, false, nil)
                    end
                end
                protocol_command.get_activity_reward.param_list = "".._ED.active_activity[143].activity_id.."\r\n"..(tonumber(_self.actInfo.info.index) - 1).."\r\n".."1"
                NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, _self, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 前往
        local activity_limit_rank_achieve_go_to_terminal = {
            _name = "activity_limit_rank_achieve_go_to",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._cell
                state_machine.excute("shortcut_function_trace", 0, {trace_function_id = 288, _datas = {}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(activity_limit_rank_achieve_reward_terminal)
        state_machine.add(activity_limit_rank_achieve_go_to_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityLimitRankStarCell state machine.
    init_ActivityLimitRankStarCell_terminal()
end

function ActivityLimitRankStarCell:onUpdateDraw()
    local root = self.roots[1]
    local GetButton = ccui.Helper:seekWidgetByName(root, "Button_rec")       -- 领取
    local Image_klq = ccui.Helper:seekWidgetByName(root, "Image_klq")       -- 领取
    local Button_13 = ccui.Helper:seekWidgetByName(root, "Button_go")       -- 前往
    local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_ylq")         -- 已领取
    GetButton:setVisible(false)
    Button_13:setVisible(false)
    Image_13:setVisible(false)
    Image_klq:setVisible(false)
end

function ActivityLimitRankStarCell:updateRewardInfo()
    local root = self.roots[1]

    --星级进度
    local Text_rc_time_limit_star_n = ccui.Helper:seekWidgetByName(root,"Text_rc_time_limit_star_n")

    local actData = zstring.split(self.actInfo.info.activityInfo_need_day, ":")
    local curStars = tonumber(self.actInfo.curProgress)
    local needStars = tonumber(actData[2])

    if curStars >= needStars then
        Text_rc_time_limit_star_n:setColor(cc.c3b(0,128,0))
    else
        Text_rc_time_limit_star_n:setColor(cc.c3b(71,71,71))
    end

    if zstring.tonumber(curStars) > 10000 then
       curStars = math.floor(curStars / 1000) .. string_equiprety_name[40]
    end

    if zstring.tonumber(needStars) > 10000 then
       needStars = math.floor(needStars / 1000) .. string_equiprety_name[40]
    end
    
    Text_rc_time_limit_star_n:setString(curStars .. "/" .. needStars)
    
    -- 活动名称(战力显示)
    local Text_rc_time_limit_lv_t = ccui.Helper:seekWidgetByName(root,"Text_rc_time_limit_lv_t")
    Text_rc_time_limit_lv_t:setString(string.format(tipStringInfo_racing_activity_description_tip[1], needStars))

    --已完成人数
    local Text_rc_time_limit_num = ccui.Helper:seekWidgetByName(root,"Text_rc_time_limit_num")
    local canGetNums = tonumber(actData[4])
    Text_rc_time_limit_num:setString(canGetNums .. "/" .. actData[3])
    if canGetNums == tonumber(actData[3]) then
        Text_rc_time_limit_num:setColor(cc.c3b(255,0,0))
    else
        Text_rc_time_limit_num:setColor(cc.c3b(71,71,71))
    end

    -- 奖励
    local rewards = zstring.splits(self.actInfo.info.activityInfo_reward_select, "|", ",")

    local index = 1
    for i, reward in ipairs(rewards) do
        local Panel_time_limit_icon = ccui.Helper:seekWidgetByName(root,"Panel_time_limit_icon_" .. index)
        local rewardType = zstring.tonumber(reward[1])
        local cell = ActivityRewordCell:createCell()
        if 13 == rewardType then
            local table = {}
            if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
                table.shipStar = tonumber(reward[4])
            end
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1,table)
        else
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1)
        end
        local rewardinfo = {}
        rewardinfo.type = rewardType
        rewardinfo.id = reward[2]
        rewardinfo.number = tonumber(reward[3])
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
        Panel_time_limit_icon:addChild(cell)
    end

    local GetButton = ccui.Helper:seekWidgetByName(root, "Button_rec")       -- 领取
    local Image_klq = ccui.Helper:seekWidgetByName(root, "Image_klq")       -- 领取
    local Button_13 = ccui.Helper:seekWidgetByName(root, "Button_go")       -- 前往
    local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_ylq")         -- 已领取

    -- EL BOTON «Ir» DE ESTA PESTAÑA NACIA MUERTO. Aqui habia dos lineas
    -- (Button_13:setTouchEnabled(false) y setBright(false)) que apagaban el
    -- boton SIEMPRE, antes de mirar el estado, y la rama del estado 1
    -- (progreso sin terminar) solo lo hace visible: se pintaba gris y no
    -- respondia. La celda de la otra pestana (ActivityLimitRankLevelCell
    -- :165-169) no las tiene, y su «Ir» si lleva a la Linea principal.

    -- 进度已完成，可以领取
    if tonumber(self.actInfo.state) == 0 then
        GetButton:setVisible(true)
        GetButton:setBright(true)
        GetButton:setTouchEnabled(true)
        Image_klq:setVisible(true)
        Button_13:setVisible(false)
        Image_13:setVisible(false)
    -- 进度没完成，不能领取
    elseif tonumber(self.actInfo.state) == 1 then
        GetButton:setVisible(false)
        Image_klq:setVisible(false)
        Button_13:setVisible(true)
        Image_13:setVisible(false)
    -- 已经领取
    elseif tonumber(self.actInfo.state) == 2 then
        GetButton:setVisible(false)
        Image_13:setVisible(false)
        Button_13:setVisible(false)
        Image_13:setVisible(true)
    -- 完成进度，可领奖人数是0
    elseif tonumber(self.actInfo.state) == 4 then
        GetButton:setVisible(true)
        GetButton:setBright(false)
        GetButton:setTouchEnabled(false)
        Image_klq:setVisible(true)
        Button_13:setVisible(false)
        Image_13:setVisible(false)
    end
end

function ActivityLimitRankStarCell:onEnterTransitionFinish()

end

function ActivityLimitRankStarCell:onInit()
    local root = cacher.createUIRef("activity/wonderful/time_limit_activity_star_cell.csb", "root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
    self:addChild(root)
    
    self:setContentSize(root:getContentSize())
    
    self:onUpdateDraw()
    self:updateRewardInfo()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rec"), nil, 
        {
            terminal_name = "activity_limit_rank_achieve_reward", 
            terminal_state = 0,
            _cell = self,           
            isPressedActionEnabled = true
        },
        nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil, 
    {
        terminal_name = "activity_limit_rank_achieve_go_to", 
        terminal_state = 0, 
        _cell = self,           
        isPressedActionEnabled = true
    },
    nil,0)
end

function ActivityLimitRankStarCell:clearUIInfo( ... )
    local root = self.roots[1]
    local GetButton = ccui.Helper:seekWidgetByName(root, "Button_rec")       -- 领取
    local Image_klq = ccui.Helper:seekWidgetByName(root, "Image_klq")       -- 领取
    local Button_13 = ccui.Helper:seekWidgetByName(root, "Button_go")       -- 前往
    local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_ylq")         -- 已领取
    local Text_rc_time_limit_star_n = ccui.Helper:seekWidgetByName(root,"Text_rc_time_limit_star_n")
    local Text_rc_time_limit_num = ccui.Helper:seekWidgetByName(root,"Text_rc_time_limit_num")
    if GetButton ~= nil then
        GetButton:setVisible(false)
        Button_13:setVisible(false)
        Image_13:setVisible(false)
        Image_klq:setVisible(false)
        Text_rc_time_limit_star_n:setString("")
        Text_rc_time_limit_num:setString("")
    end
end

function ActivityLimitRankStarCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("activity/wonderful/time_limit_activity_star_cell.csb", self.roots[1])
end

function ActivityLimitRankStarCell:init(params)
    self._type = params._type
    self.actInfo = params.info
    self:onInit()
end

function ActivityLimitRankStarCell:createCell()
    local cell = ActivityLimitRankStarCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end