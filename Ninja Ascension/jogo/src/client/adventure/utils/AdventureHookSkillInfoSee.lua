-- ----------------------------------------------------------------------------------------------------
-- 说明：技能查看界面
-------------------------------------------------------------------------------------------------------
AdventureHookSkillInfoSee = class("AdventureHookSkillInfoSeeClass", Window)
    
function AdventureHookSkillInfoSee:ctor()
    self.super:ctor()
    self.roots = {}
	self.current_type = 0
	self.mould_data = nil
    -- Initialize adventure battle reward state machine.
    local function init_adventure_battle_reward_terminal()

        state_machine.init()
    end
    
    -- call func init adventure battle reward state machine.
    init_adventure_battle_reward_terminal()
end

function AdventureHookSkillInfoSee:init(interfaceType,skill,cell)
	self.current_type = interfaceType
	self.skill = skill
	self.mould_data = skill.mould_data or dms.element(dms["skill_mould"], self.skill.id)
	self._rootWindows = cell
	--print(cell:getPositionX(),cell:getPositionY()," 父节点坐标")
	return self
end

function AdventureHookSkillInfoSee:onUpdateDraw()
	local root = self.roots[1]
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name") 
	Text_name:setString(dms.atos(self.mould_data, skill_mould.skill_name))
	local Text_word = ccui.Helper:seekWidgetByName(root, "Text_word") 
	Text_word:setString(dms.atos(self.mould_data, skill_mould.skill_describe))
	if is_skill_union(self.mould_data) then
		app.load("client.adventure.utils.AdventureSkillFitDescription")
		fwin:open(AdventureSkillFitDescription:new():init(self.current_type,self.skill, self,1), fwin._ui)
	end
end

function AdventureHookSkillInfoSee:onEnterTransitionFinish()
	local csbAdventureBattleReward = csb.createNode("utils/skill_tips.csb")
    local root = csbAdventureBattleReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBattleReward)
    --print(self._rootWindows:getPositionX()-root:getContentSize().width,self._rootWindows:getPositionY(),"直接点坐标")
    
	self:onUpdateDraw()
	root:setPosition(cc.p(self._rootWindows:getPositionX()-root:getContentSize().width,self._rootWindows:getPositionY()-root:getContentSize().height))
	
end

function AdventureHookSkillInfoSee:onExit()

end