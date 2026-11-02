-- ----------------------------------------------------------------------------------------------------
-- 说明：天空神殿招募主界面
-------------------------------------------------------------------------------------------------------
AdventureRecruitOfLostTemple = class("AdventureRecruitOfLostTempleClass", Window)
    
function AdventureRecruitOfLostTemple:ctor()
    self.super:ctor()
    self.roots = {}
	app.load("client.adventure.shop.recruit.AdventureRecruitOfLostTempHeroList")
	app.load("client.adventure.shop.recruit.AdventureRecruitOfLostTempQuality")
    -- Initialize adventure recruit of lost temple state machine.
    local function init_adventure_recruit_of_lost_temple_terminal()
		local adventure_recruit_of_lost_temple_update_number_terminal = {
            _name = "adventure_recruit_of_lost_temple_update_number",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self:onUpdateDrawConsumption()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_recruit_of_lost_temple_update_number_terminal)
        state_machine.init()
    end
    
    -- call func init adventure recruit of lost temple state machine.
    init_adventure_recruit_of_lost_temple_terminal()
end

function AdventureRecruitOfLostTemple:init()
    return self
end

function AdventureRecruitOfLostTemple:onUpdateDrawConsumption()
	local root = self.roots[1]
	local Text_buyshu = ccui.Helper:seekWidgetByName(root, "Text_buyshu")
	Text_buyshu:setString(_ED.user_info.soul)
end

function AdventureRecruitOfLostTemple:onUpdateDraw()
	local root = self.roots[1]
	local ListView_yongbing = ccui.Helper:seekWidgetByName(root, "ListView_yongbing")
	ListView_yongbing:removeAllItems()
	local indexs = 0
	for j ,v in pairs(_ED.recruit_sky_temple.exchange_data) do
		local qualityCell = AdventureRecruitOfLostTempQuality:createCell()
		qualityCell:init(v[1])
		ListView_yongbing:addChild(qualityCell)
		for i ,w in pairs(_ED.recruit_sky_temple.exchange_data[j]) do 
			indexs = indexs + 1
			local heroCell = AdventureRecruitOfLostTempHeroList:createCell()
			heroCell:init(w,indexs)
			ListView_yongbing:addChild(heroCell)
		end
	end
	self:onUpdateDrawConsumption()
end

function AdventureRecruitOfLostTemple:onEnterTransitionFinish()
    local csbAdventureRecruitOfLostTemple = csb.createNode("shop/heroshop/heroshop_shendian.csb")
    local root = csbAdventureRecruitOfLostTemple:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureRecruitOfLostTemple)

	self:onUpdateDraw()
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureRecruitOfLostTempleClass"))]],
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    local listView = ccui.Helper:seekWidgetByName(root, "ListView_yongbing")
end

function AdventureRecruitOfLostTemple:onExit()
    
end