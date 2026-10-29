--------------------------------------------------------------------------------------------------------------
--  说明：连续登陆的单个控件
--------------------------------------------------------------------------------------------------------------
SmActivityLangingRewordCell = class("SmActivityLangingRewordCellClass", Window)
SmActivityLangingRewordCell.__size = nil

--创建cell
local sm_activity_langing_reword_cell_terminal = {
    _name = "sm_activity_langing_reword_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmActivityLangingRewordCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_activity_langing_reword_cell_check_terminal = {
    _name = "sm_activity_langing_reword_cell_check",
    _init = function (terminal)       
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cells= params._datas.cells
        local function responseGetServerListCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                app.load("client.reward.DrawRareReward")
                local getRewardWnd = DrawRareReward:new()
                getRewardWnd:init(7,nil,cells.reworld_sorting)
                -- getRewardWnd:init(7)
                fwin:open(getRewardWnd, fwin._ui)
                state_machine.excute("sm_activity_langing_reword_window_update_draw", 0, "")
                state_machine.excute("home_update_top_activity_info_state", 0, nil)
            end
        end
        local activityId = _ED.active_activity[24].activity_id
        protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..(tonumber(cells.activity.activityInfo_need_day)-1).."\r\n".."0"
        NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, cells, responseGetServerListCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_langing_reword_cell_check_terminal)
state_machine.add(sm_activity_langing_reword_cell_terminal)
state_machine.init()

function SmActivityLangingRewordCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.reworld_sorting = {}
    app.load("client.cells.utils.resources_icon_cell")
	 -- Initialize sm_activity_langing_reword_cell state machine.
    local function init_sm_activity_langing_reword_cell_terminal()
        
        state_machine.init()
    end 
    -- call func sm_activity_langing_reword_cell create state machine.
    init_sm_activity_langing_reword_cell_terminal()

end

function SmActivityLangingRewordCell:updateDraw()
    local root = self.roots[1]
    local AtlasLabel_login_gift_list_day = ccui.Helper:seekWidgetByName(root,"AtlasLabel_login_gift_list_day")
    AtlasLabel_login_gift_list_day:setString(self.activity.activityInfo_need_day)

    local Image_1 = ccui.Helper:seekWidgetByName(root,"Button_login_gift_list_rec"):getChildByName("Image_1")
    if tonumber(_ED.active_activity[24].activity_login_day) >= tonumber(self.activity.activityInfo_need_day) then
        ccui.Helper:seekWidgetByName(root,"Button_login_gift_list_rec"):setBright(true)
        ccui.Helper:seekWidgetByName(root,"Button_login_gift_list_rec"):setTouchEnabled(true)
        display:ungray(Image_1)
    else
        ccui.Helper:seekWidgetByName(root,"Button_login_gift_list_rec"):setBright(false)
        ccui.Helper:seekWidgetByName(root,"Button_login_gift_list_rec"):setTouchEnabled(false)
        display:gray(Image_1)
    end
    --已领取
    local Image_login_gift_list_rec = ccui.Helper:seekWidgetByName(root,"Image_login_gift_list_rec")
    if tonumber(self.activity.activityInfo_isReward) > 0 then
        Image_login_gift_list_rec:setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_login_gift_list_rec"):setVisible(false)
    else
        Image_login_gift_list_rec:setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_login_gift_list_rec"):setVisible(true)
    end
end

function SmActivityLangingRewordCell:updateRewardInfo( ... )
    local root = self.roots[1]
    
    --奖励
    local ListView_login_gift_list = ccui.Helper:seekWidgetByName(root,"ListView_login_gift_list")
    ListView_login_gift_list:removeAllItems()
    local index = 1
    if tonumber(self.activity.activityInfo_silver) ~= 0 then
        --金币
        local cell = ResourcesIconCell:createCell()
        cell:init(1, tonumber(self.activity.activityInfo_silver), -1,nil,nil,true,true,1)
        ListView_login_gift_list:addChild(cell)
        local rewardinfo = {}
        rewardinfo.type = 1
        rewardinfo.id = -1
        rewardinfo.number = tonumber(self.activity.activityInfo_silver)
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
    end
    if tonumber(self.activity.activityInfo_gold) ~= 0 then
        --钻石
        local cell = ResourcesIconCell:createCell()
        cell:init(2, tonumber(self.activity.activityInfo_gold), -1,nil,nil,true,true,1)
        ListView_login_gift_list:addChild(cell)
        local rewardinfo = {}
        rewardinfo.type = 2
        rewardinfo.id = -1
        rewardinfo.number = tonumber(self.activity.activityInfo_gold)
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
    end
    if tonumber(self.activity.activityInfo_food) ~= 0 then
        --体力
        local cell = ResourcesIconCell:createCell()
        cell:init(12, tonumber(self.activity.activityInfo_food), -1,nil,nil,true,true,1)
        ListView_login_gift_list:addChild(cell)
        local rewardinfo = {}
        rewardinfo.type = 12
        rewardinfo.id = -1
        rewardinfo.number = tonumber(self.activity.activityInfo_food)
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
    end
    if tonumber(self.activity.activityInfo_equip_count) ~= 0 then
        --装备
        local equip_data = self.activity.activityInfo_equip_info[1]
        local cell = ResourcesIconCell:createCell()
        cell:init(7, tonumber(equip_data.propMouldCount), equip_data.propMould,nil,nil,true,true,1)
        ListView_login_gift_list:addChild(cell)
        local rewardinfo = {}
        rewardinfo.type = 7
        rewardinfo.id = equip_data.propMould
        rewardinfo.number = tonumber(equip_data.propMouldCount)
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
    end
    if tonumber(self.activity.activityInfo_prop_count) ~= 0 then
        --道具
        for i, v in pairs(self.activity.activityInfo_prop_info) do
            local prop_data = v
            local cell = ResourcesIconCell:createCell()
            cell:init(6, tonumber(prop_data.propMouldCount), prop_data.propMould,nil,nil,true,true,1)
            ListView_login_gift_list:addChild(cell)
            local rewardinfo = {}
            rewardinfo.type = 6
            rewardinfo.id = prop_data.propMould
            rewardinfo.number = tonumber(prop_data.propMouldCount)
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        end
    end
    if tonumber(self.activity.activityInfo_honour) ~= 0 then
        --声望
        local cell = ResourcesIconCell:createCell()
        cell:init(3, tonumber(self.activity.activityInfo_honour), -1,nil,nil,true,true,1)
        ListView_login_gift_list:addChild(cell)
        local rewardinfo = {}
        rewardinfo.type = 3
        rewardinfo.id = -1
        rewardinfo.number = tonumber(self.activity.activityInfo_honour)
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
    end

    local otherRewards = zstring.splits(self.activity.activityInfo_reward_select, "|", ",")
    if #otherRewards > 0 then
        for i, v in pairs(otherRewards) do
            -- 类型、ID、数量、星级
            if #v >= 3 then
                local cell = ResourcesIconCell:createCell()
                local rewardType = tonumber(v[1])
                if 13 == rewardType then
                    local table = {}
                    if v[4] ~= nil and tonumber(v[4]) ~= -1 then
                        table.shipStar = tonumber(v[4])
                    end
                    cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1,table)
                    local ships = fundShipWidthTemplateId(tonumber(v[2]))
                    if ships == nil then
                        local rewardinfo = {}
                        rewardinfo.type = rewardType
                        rewardinfo.id = tonumber(v[2])
                        rewardinfo.number = tonumber(v[3])
                        self.reworld_sorting[index] = rewardinfo
                        index = index + 1
                    else
                        local prop_mlds = dms.int(dms["ship_mould"], tonumber(v[2]), ship_mould.fitSkillOne)
                        local number_info = zstring.split(dms.string(dms["ship_config"], 13, ship_config.param),"!")[tonumber(v[4])]
                        local ability = dms.int(dms["ship_mould"], tonumber(v[2]), ship_mould.ability)
                        local number_data = zstring.split(number_info,"|")[ability-13+1]
                        local m_number = tonumber(zstring.split(number_data,",")[2])
                        
                        -- local prop_mlds = dms.int(dms["ship_mould"], tonumber(v[2]), ship_mould.fitSkillOne)
                        -- local m_number = dms.int(dms["prop_mould"], prop_mlds, prop_mould.split_or_merge_count)
                        local rewardinfo = {}
                        rewardinfo.type = 6
                        rewardinfo.id = prop_mlds
                        rewardinfo.number = m_number
                        self.reworld_sorting[index] = rewardinfo
                        index = index + 1
                    end
                elseif 18 == rewardType then
                    cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1)
                    local rewardinfo = {}
                    rewardinfo.type = rewardType
                    rewardinfo.id = tonumber(v[2])
                    rewardinfo.number = tonumber(v[3])
                    self.reworld_sorting[index] = rewardinfo
                    index = index + 1
                else
                    cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1)
                    local rewardinfo = {}
                    rewardinfo.type = rewardType
                    rewardinfo.id = tonumber(v[2])
                    rewardinfo.number = tonumber(v[3])
                    self.reworld_sorting[index] = rewardinfo
                    index = index + 1
                end
                ListView_login_gift_list:addChild(cell)
            end
        end
    end

    ListView_login_gift_list:requestRefreshView()
end

function SmActivityLangingRewordCell:onUpdate(dt)
    
end

function SmActivityLangingRewordCell:onInit()
    local root = cacher.createUIRef("activity/login_gift_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmActivityLangingRewordCell.__size == nil then
        SmActivityLangingRewordCell.__size = ccui.Helper:seekWidgetByName(root, "Panel_login_gift_list"):getContentSize()
    end
    -- if tonumber(self.m_type) == 0 then
    -- 	--
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_login_gift_list_rec"), nil, 
        {
            terminal_name = "sm_activity_langing_reword_cell_check", 
            terminal_state = 0, 
            touch_black = true,
    		cells = self,
        }, nil, 1)
    -- end

	self:updateDraw()

    self:updateRewardInfo()
end

function SmActivityLangingRewordCell:onEnterTransitionFinish()

end

function SmActivityLangingRewordCell:clearUIInfo( ... )
    local root = self.roots[1]
    local ListView_login_gift_list = ccui.Helper:seekWidgetByName(root,"ListView_login_gift_list")
    if ListView_login_gift_list ~= nil then
        ListView_login_gift_list:removeAllItems()
    end
end

function SmActivityLangingRewordCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmActivityLangingRewordCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/login_gift_list.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmActivityLangingRewordCell:init(params)
    self.activity = params[1]
    self.index = params[2]
    if self.index <= 4 then
	   self:onInit()
    end
    self:setContentSize(SmActivityLangingRewordCell.__size)
    return self
end

function SmActivityLangingRewordCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/login_gift_list.csb", self.roots[1])
end