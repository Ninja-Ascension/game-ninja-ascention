-- ----------------------------------------------------------------------------------------------------
-- 说明：技能合体技查看界面
-------------------------------------------------------------------------------------------------------
AdventureSkillFitDescription = class("AdventureSkillFitDescriptionClass", Window)
    
function AdventureSkillFitDescription:ctor()
    self.super:ctor()
    self.roots = {}
	self.current_type = 0
	self.mould_data = nil
	self.number = 0
	self.hookShow = 0
	app.load("client.adventure.utils.AdventureSkillFitCell")
    -- Initialize adventure battle reward state machine.
    local function init_adventure_battle_reward_terminal()

        state_machine.init()
    end
    
    -- call func init adventure battle reward state machine.
    init_adventure_battle_reward_terminal()
end

function AdventureSkillFitDescription:init(interfaceType,skill,cell,hookShow)
	self.current_type = interfaceType
	self.skill = skill
	self.mould_data = skill.mould_data or dms.element(dms["skill_mould"], self.skill.id)
	self._rootWindows = cell

	self.hookShow = hookShow or 0 
	return self
end

function AdventureSkillFitDescription:onUpdateDraw()
	local root = self.roots[1]
	local heroList = dms.atos(self.mould_data, skill_mould.release_mould)
	local config = zstring.split(heroList, ",")
	for i=1,#config do
		if (i-1)%2 == 0 then
			self.number = self.number + 1
		end
	end
	local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
	local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
	Image_1:setContentSize(cc.size(root:getContentSize().width, root:getContentSize().height*(self.number)))
	Panel_2:setContentSize(cc.size(root:getContentSize().width, root:getContentSize().height*(self.number)))
	root:setPosition(cc.p(self._rootWindows:getPositionX()-root:getContentSize().width,self._rootWindows:getPositionY()-root:getContentSize().height-(root:getContentSize().height/2*(self.number-1))))
	local sSize = Panel_2:getContentSize()
	local sWidth = sSize.width
	local sHeight = sSize.height-(root:getContentSize().height/2*(self.number-1))-(sSize.height/10)
	local tWidth = 0
	local tHeight = 0
	local wPosition = sWidth/2
	local Hlindex = 0
	local cellHeight = 0
	sHeight = math.max(sHeight, cellHeight)
	for j = 1,#config do
		local cell = AdventureSkillFitCell:createCell()
		cell:init(0, {ship_template_id = config[j]}, j)
		Panel_2:addChild(cell)
		tWidth = tWidth + wPosition
		if (j-1)%2 ==0 then
			Hlindex = Hlindex+1
			tWidth = (sSize.height/20)
			tHeight = sHeight - cell:getContentSize().height*Hlindex-(sSize.height/10)
		end
		if j<= 2 then
			tHeight = sHeight - cell:getContentSize().height-(sSize.height/10)
		end
		cell:setPosition(cc.p(tWidth,tHeight))
	end
	
end

function AdventureSkillFitDescription:onEnterTransitionFinish()
	local csbAdventureBattleReward = csb.createNode("utils/skill_tips_heti.csb")
    local root = csbAdventureBattleReward:getChildByName("root")
    table.insert(self.roots, root)
    self:setContentSize(root:getContentSize())
    self:addChild(csbAdventureBattleReward)
	self:onUpdateDraw()
	if self.hookShow == 1  then 
		local pos = cc.p(self:getPosition())
		pos.y = pos.y - self._rootWindows.roots[1]:getContentSize().height
		self:setPosition(pos)
	end
	--print(self:getPositionX(),self:getPositionY(),"合体技坐标")
	
	
end

function AdventureSkillFitDescription:onExit()

end