--大师训练营预览奖励
TrainigCampRewardPreview = class("TrainigCampRewardPreviewClass", Window)

local training_camp_reward_preview_open_terminal = {
	_name = "training_camp_reward_preview_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("TrainigCampRewardPreviewClass") == nil then
			fwin:open(TrainigCampRewardPreview:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local training_camp_reward_preview_close_terminal = {
	_name = "training_camp_reward_preview_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TrainigCampRewardPreviewClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(training_camp_reward_preview_open_terminal)
state_machine.add(training_camp_reward_preview_close_terminal)
state_machine.init()

function TrainigCampRewardPreview:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.activity.traingcamp.TrainigCampPackage")
    app.load("client.cells.utils.resources_icon_cell")
    local function init_egg_machine_window_terminal()
        local egg_machine_window_update_draw_terminal = {
            _name = "egg_machine_window_update_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
	            	instance:drawMoney()
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(egg_machine_window_update_draw_terminal)
        state_machine.add(egg_machine_window_recruiting_terminal)
        state_machine.init()
    end
    --init_egg_machine_window_terminal()
end

function TrainigCampRewardPreview:onUpdateDraw()
    local info = {}
    local commonrea= {}  --普通奖励
    local sparea= {}  --特殊奖励
    local rewardlv = zstring.split(dms.string(dms["activity_config"], 41, activity_config.param), ",")
  
    for k,v in pairs(rewardlv) do
        -- commonrea =  _ED.training_camp_reward_info
        table.insert(commonrea,_ED.training_camp_reward_info.freeReward[tonumber(v)])
        table.insert(sparea,_ED.training_camp_reward_info.masterReward[tonumber(v)])
    end
  
    local ListView_elite_icon = ccui.Helper:seekWidgetByName(self.roots[1],"ListView_elite_icon")
    ListView_elite_icon:removeAllItems()

    for i, v in pairs(commonrea) do
        local rewards = zstring.split(v,",")
        local rewardType = zstring.tonumber(rewards[1])
        local cell = ResourcesIconCell:createCell()
        if 13 == rewardType then
            local table = {}
            if rewards[4] ~= nil and tonumber(rewards[4]) ~= -1 then
                table.shipStar = tonumber(rewards[4])
            end
            cell:init(rewardType, 0, tonumber(rewards[2]),nil,nil,true,true,1,table)
        else
            cell:init(rewardType, 0, tonumber(rewards[2]),nil,nil,true,true,1)
        end
        ListView_elite_icon:addChild(cell)
     end
        ListView_elite_icon:requestRefreshView()


    local m_ScrollView = ccui.Helper:seekWidgetByName(self.roots[1], "ScrollView_advanced_icon")
    if table.nums(sparea) > 0 then
        m_ScrollView:removeAllChildren(true)
        local horizontalNumber = 7
        local panel = m_ScrollView:getInnerContainer()
        panel:setContentSize(m_ScrollView:getContentSize())
        panel:setPosition(cc.p(0,0))
        panel:removeAllChildren(true)
        local sSize = panel:getContentSize()
        local sHeight = sSize.height
        local sWidth = sSize.width
        local controlSize = m_ScrollView:getInnerContainerSize()
        local nextY = sSize.height
        local nextX = sSize.width
        local tHeight = 0
        local cellHeight = 0
        local tWidth = 0
        local wPosition = sWidth/horizontalNumber
        local Hlindex = 0
        local number = table.nums(sparea)
        local m_number = math.ceil(number/horizontalNumber)
        cellHeight = m_number*(m_ScrollView:getContentSize().width/horizontalNumber)
        sHeight = math.max(sHeight, cellHeight)
        panel:setContentSize(m_ScrollView:getContentSize().width, sHeight + 10)

        local totalRewardCount = 0
        for j, v in pairs(sparea) do
            local rewards = zstring.splits(v,"|",",")
            rewards = rewards[1]
            local rewardType = zstring.tonumber(rewards[1])
            local cell = ResourcesIconCell:createCell()
            if 13 == rewardType then
                local table = {}
                if v[4] ~= nil and tonumber(rewards[4]) ~= -1 then
                    table.shipStar = tonumber(rewards[4])
                end
                cell:init(rewardType, 0, tonumber(rewards[2]),nil,nil,true,true,1,table)
            else
                cell:init(rewardType, 0, tonumber(rewards[2]),nil,nil,true,true,1)
            end
            panel:addChild(cell)
            tWidth = tWidth + wPosition
            if (j-1)%horizontalNumber == 0 then
                Hlindex = Hlindex+1
                tWidth = 0
                tHeight = sHeight - (wPosition + 2)*Hlindex  
            end
            if j <= horizontalNumber then
                tHeight = sHeight - wPosition
            end
            cell:setPosition(cc.p(tWidth, tHeight))

            totalRewardCount = totalRewardCount + 1
        end
        m_ScrollView:jumpToTop()
    end
    self.currentScrollView = m_ScrollView
    self.currentInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()

end


function TrainigCampRewardPreview:onUpdate(dt)
  
end

function TrainigCampRewardPreview:init(params)
    self._rootWindows = params[1]
	self:onInit()
    return self
end

function TrainigCampRewardPreview:onInit()
    local csbItem = csb.createNode("activity/wonderful/training_camp_reward_view.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    self:onUpdateDraw()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil,   --关闭
    {
        terminal_name = "training_camp_reward_preview_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_reward_package"), nil,   --进阶训练营
    {
        terminal_name = "training_camp_package_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
end

function TrainigCampRewardPreview:onEnterTransitionFinish()
end

function TrainigCampRewardPreview:onExit()
	-- state_machine.remove("egg_machine_window_update_draw")
	-- state_machine.remove("egg_machine_window_recruiting")
end

