-- ----------------------------------------------------------------------------------------------------
-- 说明：契约界面提示 --因为层级关系所以要抽出来(还有一种比较简单的方式是直接addChild(AdventureMercenaryAgreementChoose))
-------------------------------------------------------------------------------------------------------
AdventureAgreementInfoSee = class("AdventureAgreementInfoSeeClass", Window)
    
function AdventureAgreementInfoSee:ctor()
    self.super:ctor()
    self.roots = {}
	
	self.mould_data = nil
	self.tipString = nil
	self.parentNode = nil
    -- Initialize adventure battle reward state machine.
    local function init_adventure_battle_reward_terminal()

        state_machine.init()
    end
    
    -- call func init adventure battle reward state machine.
    init_adventure_battle_reward_terminal()
end

function AdventureAgreementInfoSee:init(cell)
	self.parentNode = cell
	self._rootWindows = nil
	--print(cell:getPositionX(),cell:getPositionY()," 父节点坐标")
	return self
end

function AdventureAgreementInfoSee:onUpdateDraw()
	local root = self.roots[1]
    local Tip_Text = ccui.Helper:seekWidgetByName(root, "Text_17_0")
    if _ED.user_info.contract_exp == 0  then 
        Tip_Text:setString(tipStringInfo_hero_agreement_states[14])
    else
        Tip_Text:setString(string.format(tipStringInfo_hero_agreement_states[16],_ED.user_info.contract_exp))
    end 
	
end

function AdventureAgreementInfoSee:onEnterTransitionFinish()
	local csbAdventureBattleReward = csb.createNode("utils/qiyue_tips.csb")
    local root = csbAdventureBattleReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBattleReward)
    --print(self._rootWindows:getPositionX()-root:getContentSize().width,self._rootWindows:getPositionY(),"直接点坐标")
    self:setContentSize(root:getContentSize())
	self:onUpdateDraw()
	-- 转换世界坐标系 安卓是有自适应的,所以需要计算缩放因子,游戏是按照 960*640的分辨率来做的,所以IOS 端的缩放因子是1 
	local scaleFactor = app.scaleFactor	
	local beforePos = cc.p(0,0)
	local lastPos = cc.p(0,0)
	self.position = cc.p(0,0)
	--self.parentNode:getContentSize().width - root:getContentSize().width
	--beforePos = fwin:convertToWorldSpace(self.parentNode,cc.p(root:getContentSize().width - self.parentNode:getContentSize().height , self.parentNode:getContentSize().height))
	beforePos = fwin:convertToWorldSpace(self.parentNode,cc.p(-100, self.parentNode:getContentSize().height))
	
	lastPos.x = beforePos.x/ scaleFactor  - fwin._x * scaleFactor
	lastPos.y = beforePos.y / scaleFactor - fwin._y * scaleFactor

	self.position.x = lastPos.x
	self.position.y = lastPos.y

	root:setPosition(self.position)
	
end

function AdventureAgreementInfoSee:onExit()

end