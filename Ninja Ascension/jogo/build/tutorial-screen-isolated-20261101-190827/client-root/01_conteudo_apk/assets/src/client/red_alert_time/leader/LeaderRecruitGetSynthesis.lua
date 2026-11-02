--------------------------------------------------------------------------------------------------------------
--  说明：将领合成
--------------------------------------------------------------------------------------------------------------
LeaderRecruitGetSynthesis = class("LeaderRecruitGetSynthesisClass", Window)

--打开界面
local leader_recruit_get_synthesis_window_open_terminal = {
	_name = "leader_recruit_get_synthesis_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(LeaderRecruitGetSynthesis:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local leader_recruit_get_synthesis_window_close_terminal = {
    _name = "leader_recruit_get_synthesis_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LeaderRecruitGetSynthesisClass"))
        _ED.show_reward_list_group = {}
        _ED.show_reward_list_group_ex = {}
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(leader_recruit_get_synthesis_window_open_terminal)
state_machine.add(leader_recruit_get_synthesis_window_close_terminal)
state_machine.init()

function LeaderRecruitGetSynthesis:ctor()
	self.super:ctor()
	self.roots = {}

    self._choose_type = 0

    local function init_leader_recruit_get_synthesis_terminal()
        -- state_machine.init()
    end
    init_leader_recruit_get_synthesis_terminal()
end

function LeaderRecruitGetSynthesis:onUpdateDraw(  )
    local root = self.roots[1]
    
    local Panel_recruit_get_special_icon = ccui.Helper:seekWidgetByName(root, "Panel_recruit_get_special_icon")
    local Image_recruit_get_special_bg = ccui.Helper:seekWidgetByName(root, "Image_recruit_get_special_bg")
    Panel_recruit_get_special_icon:setVisible(true)
    Image_recruit_get_special_bg:setVisible(true)
    function actionCallBack(sender)
        state_machine.excute("leader_recruit_get_synthesis_window_close", 0, "")
    end
    Panel_recruit_get_special_icon:removeBackGroundImage()
    Panel_recruit_get_special_icon:removeAllChildren(true)
    Panel_recruit_get_special_icon:stopAllActions()
    Panel_recruit_get_special_icon:setScale(0.1)

    local reward = getSceneReward(9)
    local get_prop_type = tonumber(reward.show_reward_list[1].prop_type)
    local get_prop_id = tonumber(reward.show_reward_list[1].prop_item)
    local get_prop_num = tonumber(reward.show_reward_list[1].item_value)
    
    Panel_recruit_get_special_icon:removeAllChildren(true)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_leader)
    local armature = ccs.Armature:create("effect_leader")
    armature:getAnimation():playWithIndex(0)
    armature:setPosition(cc.p(Panel_recruit_get_special_icon:getContentSize().width/2,Panel_recruit_get_special_icon:getContentSize().height/2))
    Panel_recruit_get_special_icon:addChild(armature)
    local cell = state_machine.excute("leader_big_head_create_cell", 0, {get_prop_id, get_prop_num, get_prop_type})
    local size = Panel_recruit_get_special_icon:getContentSize()
    cell:setAnchorPoint(cc.p(0.5, 0.5))
    cell:setPosition(cc.p(size.width / 2, size.height / 2))
    Panel_recruit_get_special_icon:addChild(cell)
    
    Panel_recruit_get_special_icon:runAction(cc.Sequence:create(
        cc.ScaleTo:create(0.1, 1),
        cc.DelayTime:create(1.5),
        cc.CallFunc:create(actionCallBack)
        ))
end

function LeaderRecruitGetSynthesis:onInit(params)
    local csbItem = csb.createNode(config_csb.leader.leader_recruit_get_synthesis)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_recruit_get_special_bg"), nil, 
    {
        terminal_name = "leader_recruit_get_synthesis_window_close", 
        terminal_state = 0, 
    }, nil, 3)
    self:onUpdateDraw()
end

function LeaderRecruitGetSynthesis:onEnterTransitionFinish()

end

function LeaderRecruitGetSynthesis:init(params)
    self._choose_type = params[1]
	self:onInit()
    return self
end

function LeaderRecruitGetSynthesis:onExit()
    state_machine.remove("leader_recruit_get_synthesis_sure_recruit")
    state_machine.remove("leader_recruit_get_synthesis_update_draw")
end