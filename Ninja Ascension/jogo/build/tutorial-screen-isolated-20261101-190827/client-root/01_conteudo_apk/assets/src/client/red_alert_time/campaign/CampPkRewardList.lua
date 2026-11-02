--------------------------------------------------------------------------------------------------------------
--  说明：阵营对决奖励List
--------------------------------------------------------------------------------------------------------------
CampPkRewardList = class("CampPkRewardListClass", Window)

--打开界面
local camp_pk_reward_list_open_terminal = {
	_name = "camp_pk_reward_list_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = CampPkRewardList:new():init(params)
		fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(camp_pk_reward_list_open_terminal)
state_machine.init()

function CampPkRewardList:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._page = 0

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_rebel_reward_arrow_down = nil
    self._Image_rebel_reward_arrow_up = nil

    local function init_camp_pk_reward_list_terminal()
        local camp_pk_reward_list_update_terminal = {
            _name = "camp_pk_reward_list_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(camp_pk_reward_list_update_terminal)
        state_machine.init()
    end
    
    init_camp_pk_reward_list_terminal()
end

function CampPkRewardList:updateDraw()
    local root = self.roots[1]
    local ListView_rebel_reward_rank = ccui.Helper:seekWidgetByName(root, "ListView_rebel_reward_rank")
    self._list_view = ListView_rebel_reward_rank
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    if self._page == 1 or self._page == 2 then
        for i = 1, dms.count(dms["camp_duel_reward"]) do
            local answer_data = dms.element(dms["camp_duel_reward"], i)
            local info = {}
            info.min_rank = dms.atoi(answer_data, camp_duel_reward.min_rank)
            info.max_rank = dms.atoi(answer_data, camp_duel_reward.max_rank)
            if self._page == 1 then
                info.rewards = dms.atos(answer_data, camp_duel_reward.feats_rewards)
                info.activation_title = dms.atoi(answer_data, camp_duel_reward.feats_activation_title)
            else
                info.rewards = dms.atos(answer_data, camp_duel_reward.win_rewards)
                info.activation_title = dms.atoi(answer_data, camp_duel_reward.win_activation_title)
            end
            local cell = state_machine.excute("camp_pk_reward_cell_create", 0, {i, info,self._page})
            self._list_view:addChild(cell)
        end
    else
        for i = 1, dms.count(dms["camp_duel_active"]) do
            local answer_data = dms.element(dms["camp_duel_active"], i)
            local info = {
                win_count = dms.atoi(answer_data, camp_duel_active.win_count),
                rewards = dms.atos(answer_data, camp_duel_active.rewards),
            }
            local cell = state_machine.excute("camp_pk_reward_cell_create", 0, {i, info,self._page})
            self._list_view:addChild(cell)
        end
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function CampPkRewardList:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_rebel_reward_arrow_down:setVisible(true)
        else
            self._Image_rebel_reward_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_rebel_reward_arrow_up:setVisible(true)
        else
            self._Image_rebel_reward_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

--初始化
function CampPkRewardList:onInit()
    local csbItem = csb.createNode(config_csb.campaign.camp_pk_tab_3_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_rebel_reward_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_rebel_reward_arrow_down")
    self._Image_rebel_reward_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_rebel_reward_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_rebel_reward_arrow_down:stopAllActions()
    self._Image_rebel_reward_arrow_up:stopAllActions()
    playActions(self._Image_rebel_reward_arrow_down)
    playActions(self._Image_rebel_reward_arrow_up)
    self._Image_rebel_reward_arrow_down:setVisible(false)
    self._Image_rebel_reward_arrow_up:setVisible(false)

    self:updateDraw()
end

function CampPkRewardList:onEnterTransitionFinish()

end

function CampPkRewardList:init(param)
    self._rootWindows = param[1]
    self._page = param[2]
	self:onInit()
    return self
end

function CampPkRewardList:onExit()
    state_machine.remove("camp_pk_reward_list_update")
end