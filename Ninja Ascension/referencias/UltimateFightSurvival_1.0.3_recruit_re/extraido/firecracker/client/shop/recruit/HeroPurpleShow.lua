-- ----------------------------------------------------------------------------------------------------
-- 说明：紫色武将展示页面 HeroRecruitSuccess.lua
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

HeroPurpleShow = class("HeroPurpleShowClass", Window)
    
function HeroPurpleShow:ctor()
    self.super:ctor()
	app.load("client.cells.ship_picture_cell_ten")
	self.roots = {}
	
	self.ranking = 0
	self.mIndex = 0
	self.nextWindow = nil
	
    -- Initialize HeroPurpleShow page state machine.
    local function init_HeroPurpleShow_terminal()
		local hero_purple_close_terminal = {
            _name = "hero_purple_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                _ED.recruit_success_ship_id = nil
				fwin:open(self.nextWindow,fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(hero_purple_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_HeroPurpleShow_terminal()
end

function HeroPurpleShow:setRanking(ranking,mIndex, nextWindow)
	self.ranking = ranking
	self.mIndex = mIndex
	self.nextWindow = nextWindow
end
function HeroPurpleShow:ShowCard()
	local root = self.roots[1]
	--获取武将信息
	
	--获取对应放置图层
	for i,v in pairs(_ED.user_ship) do
		if _ED.recruit_success_ship_id == v.ship_id then
			self.ship = v.ship_base_template_id
		end
	end
	self.cell = ShipPictureCellTen:createCell(self.ship)
	local Panel_36549_1 = ccui.Helper:seekWidgetByName(root, "Panel_28")
	--> print("1111111111111")
	Panel_36549_1:setVisible(true)
	Panel_36549_1:addChild(self.cell)
	
	
end

function HeroPurpleShow:onEnterTransitionFinish()
    local csbHeroPurpleShow = csb.createNode("shop/recruit_settlement_gaoji.csb")
	local root = csbHeroPurpleShow:getChildByName("root")
	table.insert(self.roots, root)
	
	local action = csb.createTimeline("shop/recruit_settlement_gaoji.csb")
	csbHeroPurpleShow:runAction(action)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	
	
	self.csbHeroPurpleShow = csbHeroPurpleShow
	
	self:addChild(csbHeroPurpleShow)
	local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
	
	fwin:addTouchEventListener(Panel_2, nil, 
		{
			terminal_name = "hero_purple_close", 
			terminal_state = 0, 
			nextWindow = self.nextWindow
		},
		nil,0)
end


function HeroPurpleShow:onUpdate(dt)
	if self.csbHeroPurpleShow ~= nil then
		local action = csb.createTimeline("shop/recruit_settlement_gaoji.csb")
		self.csbHeroPurpleShow:runAction(action)
		
		action:gotoFrameAndPlay(0, action:getDuration(), false)
		action:setFrameEventCallFunc(function (frame)
			if nil == frame then
				return
			end

			local str = frame:getEvent()
			if str == "open" then
			elseif str == "exit_end" then
				-- state_machine.excute("hero_purple_close", 0, "")
				self:ShowCard()
			end
		end)
	
		self.csbHeroPurpleShow = nil
	end
end

function HeroPurpleShow:onExit()
	state_machine.remove("hero_purple_close")
end



