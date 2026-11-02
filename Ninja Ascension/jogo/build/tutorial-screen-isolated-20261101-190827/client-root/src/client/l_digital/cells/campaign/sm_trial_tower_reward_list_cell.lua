--------------------------------------------------------------------------------------------------------------
--  说明：数码试炼积分奖励控件
--------------------------------------------------------------------------------------------------------------
SmTrialTowerRewardListCell = class("SmTrialTowerRewardListCellClass", Window)
SmTrialTowerRewardListCell.__size = nil

--创建cell
local sm_trial_tower_reward_list_cell_terminal = {
    _name = "sm_trial_tower_reward_list_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmTrialTowerRewardListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        -- cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(sm_trial_tower_reward_list_cell_terminal)
state_machine.init()

function SmTrialTowerRewardListCell:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.cells.utils.resources_icon_cell")
    self.reward_state = 0
    self.reworld_sorting = {}
	 -- Initialize sm_trial_tower_reward_list_cell state machine.
    local function init_sm_trial_tower_reward_list_cell_terminal()
        local sm_trial_tower_reward_list_cell_reward_request_terminal = {
            _name = "sm_trial_tower_reward_list_cell_reward_request",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                if cell.reward_state == 0 then
                    -- TipDlg.drawTextDailog(_new_interface_text[40])
                elseif cell.reward_state == 1 then
                    local function recruitCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("sm_trial_tower_reward_all_get_update" , 0 , cell.index)
                            if response.node ~= nil and response.node.roots[1] ~= nil then
                                response.node:updateDraw()
                            end

                            -- 刷新一键领取按钮的状态
                            state_machine.excute("sm_trial_tower_reward_refresh_one_key_button", 0, 0)

                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(37,nil,cell.reworld_sorting)
                            -- getRewardWnd:init(37)
                            fwin:open(getRewardWnd, fwin._windows)
                            fwin:close("propInformationClass")
                            fwin:close("propMoneyInfoClass")
                        else
                            state_machine.unlock("sm_trial_tower_reward_list_cell_reward_request", 0, "")
                        end
                    end
                    state_machine.lock("sm_trial_tower_reward_list_cell_reward_request", 0, "")
                    protocol_command.three_kingdoms_draw_score_reward.param_list = ""..cell.index
                    NetworkManager:register(protocol_command.three_kingdoms_draw_score_reward.code, nil, nil, nil, cell, recruitCallBack, false, nil)
                else
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_trial_tower_reward_list_cell_reward_request_terminal)
        state_machine.init()
    end 
    -- call func sm_trial_tower_reward_list_cell create state machine.
    init_sm_trial_tower_reward_list_cell_terminal()

end

function SmTrialTowerRewardListCell:updateDraw()
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Image_jifen_icon"):setVisible(true)
    local Panel_reward_bg = ccui.Helper:seekWidgetByName(root, "Panel_reward_bg")
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    else
        Panel_reward_bg:setBackGroundImage("images/ui/text/SL_res/shilian_30.png")
    end
    local reworlds = dms.string(dms["three_kingdoms_score_reward_param"], self.index, three_kingdoms_score_reward_param.rewards)
    local reward = zstring.split(reworlds, "|")
    local index = 1
    for i=1,4 do
        local Panel_reward = ccui.Helper:seekWidgetByName(root, "Panel_reward_"..i)
        Panel_reward:removeAllChildren(true)
        local data = zstring.split( reward[i], ",") 
        -- local cell = ResourcesIconCell:createCell()
        -- cell:init(data[1], data[3], data[2],nil,nil,nil,true,true)
        -- Panel_reward:addChild(cell)
        local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{data[1],data[2],data[3]},false,true,false,true})
        Panel_reward:addChild(cell)
        local rewardinfo = {}
        rewardinfo.type = data[1]
        rewardinfo.id = data[2]
        rewardinfo.number = data[3]
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
    end

    local Text_jifen_to = ccui.Helper:seekWidgetByName(root, "Text_jifen_to")
    local integral = dms.int(dms["three_kingdoms_score_reward_param"], self.index, three_kingdoms_score_reward_param.need_integral)
    Text_jifen_to:setString(string.format(_new_interface_text[118],zstring.tonumber(integral)))

    local Panel_received = ccui.Helper:seekWidgetByName(root, "Panel_received")
    local Panel_dh = ccui.Helper:seekWidgetByName(root, "Panel_dh")
    Panel_received:setVisible(false)
    Panel_dh:removeAllChildren(true)
    -- DSC重塑
    local Button_Collectable = ccui.Helper:seekWidgetByName(root, "Button_Collectable")
    if __lua_project_id == __lua_project_l_digital then
        if Button_Collectable then 
            Button_Collectable:setVisible(false)
        end
    end
    self.reward_state = 0

    if _ED.user_try_highest_score_reward_state[""..self.index] ~= nil then
        Panel_received:setVisible(true)
        self.reward_state = 2
    else
        if integral <= _ED.user_try_highest_integral then
            self.reward_state = 1
            if __lua_project_id == __lua_project_l_digital then
                if Button_Collectable then 
                    Button_Collectable:setVisible(true)
                end
            else
                local jsonFile = "sprite/spirte_arena_gx.json"
                local atlasFile = "sprite/spirte_arena_gx.atlas"
                local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                Panel_dh:addChild(animation)
            end
        end
    end
end

function SmTrialTowerRewardListCell:onUpdate(dt)
    
end

function SmTrialTowerRewardListCell:onInit()
    local root = cacher.createUIRef("campaign/TrialTower/sm_trial_tower_reward_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmTrialTowerRewardListCell.__size == nil then
        SmTrialTowerRewardListCell.__size = root:getContentSize()
    end
    local Panel_reward_bg = ccui.Helper:seekWidgetByName(root, "Panel_reward_bg")
    
    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then
        local Button_Collectable = ccui.Helper:seekWidgetByName(root, "Button_Collectable")
        if Button_Collectable then 
            Panel_reward_bg = Button_Collectable
        end
    end

    fwin:addTouchEventListener(Panel_reward_bg, nil, 
    {
        terminal_name = "sm_trial_tower_reward_list_cell_reward_request", 
        terminal_state = 0, 
        touch_black = true,
		cells = self,
    }, nil, 1)

	self:updateDraw(self.current_index)
end

function SmTrialTowerRewardListCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function SmTrialTowerRewardListCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_dh = ccui.Helper:seekWidgetByName(root, "Panel_dh")
    if Panel_dh ~= nil then
        Panel_dh:removeAllChildren(true)
        for i=1,4 do
            local Panel_reward = ccui.Helper:seekWidgetByName(root, "Panel_reward_"..i)
            Panel_reward:removeAllChildren(true)
        end
    end
end

function SmTrialTowerRewardListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    -- self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmTrialTowerRewardListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    fwin:close(fwin:find("propInformationClass"))
    fwin:close(fwin:find("propMoneyInfoClass"))
	self:clearUIInfo()
    cacher.freeRef("campaign/TrialTower/sm_trial_tower_reward_list.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmTrialTowerRewardListCell:init(params)
    self.index = params[1]
    self.loadMinIndex = params[2]
    -- self.current_index = params[2]
    if tonumber(self.loadMinIndex) <= 3 then
        self:onInit()
    end
    self:setContentSize(SmTrialTowerRewardListCell.__size)
    return self
end

function SmTrialTowerRewardListCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/TrialTower/sm_trial_tower_reward_list.csb", self.roots[1])
end