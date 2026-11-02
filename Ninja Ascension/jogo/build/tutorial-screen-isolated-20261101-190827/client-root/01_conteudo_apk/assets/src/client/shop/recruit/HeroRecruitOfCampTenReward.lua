--------------------------------------------------------------------------------------------------------------
--  说明：阵营招募十次window
--------------------------------------------------------------------------------------------------------------
HeroRecruitOfCampTenReward = class("HeroRecruitOfCampTenRewardClass", Window)


local hero_recruit_of_camp_reward_open_terminal = {
    _name = "hero_recruit_of_camp_reward_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		state_machine.lock("hero_recruit_of_camp_reward_open")
        local reward_window = HeroRecruitOfCampTenReward:new()
        reward_window:init()
        fwin:open(reward_window,fwin._window)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local hero_recruit_of_camp_reward_close_terminal = {
    _name = "hero_recruit_of_camp_reward_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroRecruitOfCampTenRewardClass"))
		--这个奖励框关闭后，招募十次的才解锁
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_recruit_of_camp_reward_open_terminal)
state_machine.add(hero_recruit_of_camp_reward_close_terminal)
state_machine.init()
function HeroRecruitOfCampTenReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.params = nil
    self.mheight = nil 
    self.mwidth = nil 
	
	 -- Initialize union duplicate seat machine.
    local function init_hero_recruit_of_camp_reward_terminal()
		--打开界面
    end
    -- call func init union duplicate seat machine.
    init_hero_recruit_of_camp_reward_terminal()

end

function HeroRecruitOfCampTenReward:updateDraw()
    local root =self.roots[1]
    if root == nil then
        return 
    end
            -- [[绘制滚动层
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_icon")
    local panel = ccui.Layout:create()
    panel:setContentSize(m_ScrollView:getContentSize())
    
    panel:setPosition(cc.p(0,0))
    panel:removeAllChildren(true)
    m_ScrollView:addChild(panel)
    local sSize = panel:getContentSize()
    local controlSize = m_ScrollView:getInnerContainerSize()
    local cellWidth = sSize.width / 4
    local function addRewardScrollView(_reward, _index)
        -- local tempCell = ResourcesIconCell:createCell()
        -- tempCell:init(6, _reward.reward_count, _reward.reward_id)
        -- panel:addChild(tempCell)
        -- tempCell:showName(_reward.mould_id,self.type_change_array[_reward.type])
        local tempCell = self:getItemCell(_reward.reward_id,nil,_reward.reward_count)
       
        panel:addChild(tempCell)
 
        local cellHeight = self.mheight+20
        local cellWidth1 =self.mwidth

        local row = math.floor((_index - 1) / 4 + 1)
        local col = math.floor((_index - 1) % 4)
        local controlHeight = row * cellHeight
        
        if controlHeight < sSize.height then
            controlSize.height = sSize.height
        else
            controlSize.height = controlHeight + cellHeight
        end
        local pos = nil
        if table.getn(_ED.partner_bounty_get_return_reward) > 16 then
            m_ScrollView:setInnerContainerSize(cc.size(controlSize.width, controlSize.height - cellHeight))
            
            pos = cc.p(cellWidth * col + (cellWidth - cellWidth1)/2,
                sSize.height - cellHeight * row-cellHeight+20)
        else
            m_ScrollView:setInnerContainerSize(cc.size(controlSize.width, controlSize.height))
            
            pos = cc.p(cellWidth * col + (cellWidth - cellWidth1)/2,
                sSize.height - cellHeight * row)
        end
        tempCell:setPosition(pos)
        panel:setPositionY(controlSize.height - sSize.height)
        return tempCell
    end
    for i, v in ipairs(_ED.partner_bounty_get_return_reward) do
        addRewardScrollView(v, i)
    end

end

--道具
function HeroRecruitOfCampTenReward:getItemCell(mid,mtype,count,isCertainly)
    app.load("client.cells.prop.model_prop_icon_cell")
    local cell = ModelPropIconCell:createCell()
    local cellConfig = cell:createConfig()
    cellConfig.mouldId = mid
    cellConfig.isShowName = true
    cellConfig.isDebris = true
    cellConfig.mouldType = mtype
    cellConfig.touchShowType = 1
    cellConfig.count = count
    cellConfig.isCertainly = isCertainly
    cell:init(cellConfig)
    return cell
end

function HeroRecruitOfCampTenReward:onInit()
    
    local HeroRecruitOfCampTenReward = csb.createNode("shop/shop_zhenying_ten.csb") 
    local root = HeroRecruitOfCampTenReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(HeroRecruitOfCampTenReward)

    local action = csb.createTimeline("shop/shop_zhenying_ten.csb")
    action:play("window_open", false)
    HeroRecruitOfCampTenReward:runAction(action)

    local csbItem = csb.createNode("icon/item_big.csb")
    local root2 = csbItem:getChildByName("root")
    root2:removeFromParent(false)
    self.mheight =root2:getContentSize().height 
    self.mwidth =  root2:getContentSize().width 
 

	self:updateDraw()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4_gb"), nil, 
    {
        terminal_name = "hero_recruit_of_camp_reward_close", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zy_close"), nil, 
    {
        terminal_name = "hero_recruit_of_camp_reward_close", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	state_machine.unlock("hero_recruit_of_camp_reward_open")

end

function HeroRecruitOfCampTenReward:onEnterTransitionFinish()

end

function HeroRecruitOfCampTenReward:init()
	self:onInit()
	return self
end

function HeroRecruitOfCampTenReward:onExit()

end