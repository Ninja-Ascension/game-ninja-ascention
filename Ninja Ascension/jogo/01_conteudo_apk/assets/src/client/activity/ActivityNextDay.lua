-- ----------------------------------------------------------------------------------------------------
-- 说明：首冲活动
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityNextDay = class("ActivityNextDayClass", Window)
    
function ActivityNextDay:ctor()
    self.super:ctor()
	self.roots = {}
	self.loaded = false
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	
    --Initialize ActivityNextDay state machine.
    local function init_ActivityNextDay_terminal()

		--领取
		local activity_next_day_go_to_lingqu_button_terminal = {
            _name = "activity_next_day_go_to_lingqu_button",
            _init = function (terminal) 
                
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local cell = params._datas.cell
				cell:openReward()
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新
		local activity_next_day_refresh_button_terminal = {
            _name = "activity_next_day_refresh_button",
            _init = function (terminal) 
                
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local win = params._datas.cell
				if nil ~= win then
					win:onUpdateRefresh()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(activity_next_day_refresh_button_terminal)
		state_machine.add(activity_next_day_go_to_lingqu_button_terminal)

        state_machine.init()
    end
    
    -- call func init ActivityNextDay state machine.
    init_ActivityNextDay_terminal()

    self._load_over = false
end

function ActivityNextDay:openReward()
	app.load("client.reward.ActivityNextDayBigBoxRewad")
	local win = ActivityNextDayBigBoxRewad:new()
	win:init(self.heroList, self)
	fwin:open(win, fwin._windows)
end

function ActivityNextDay:getShipCell(mid)
	app.load("client.cells.prop.model_prop_icon_cell")
	local iconCell = ModelPropIconCell:createCell()
	local config = iconCell:createConfig(mid, 1, true, 1, 13)
	config.isDebris = true
	iconCell:init(config)
	return iconCell
end

function ActivityNextDay:onUpdateDraw()
	if self.loaded == false then
		return
	end
	local root = self.roots[1]

	local views = {
		ccui.Helper:seekWidgetByName(root, "Panel_70_1"),
		ccui.Helper:seekWidgetByName(root, "Panel_70_2"),
		ccui.Helper:seekWidgetByName(root, "Panel_70_3"),
		ccui.Helper:seekWidgetByName(root, "Panel_70_4")
	}
	
	local activeItem = _ED.active_activity[48]
	if nil == views[1] or nil == activeItem then
		return
	end
	
	local list = zstring.split(activeItem.heroList, ",") 
	self.heroList = list -- 可领取的战船(a,b,c,d)
	local activity_isReward = activeItem.activity_isReward -- 领取状态(0:不可领取1:可领取)
	for i = 1, #views do
		local v = list[i]
		if nil ~= v then
			views[i]:removeAllChildren(true)
			local cell = self:getShipCell(v)
			views[i]:addChild(cell)
		end
	end

	ccui.Helper:seekWidgetByName(root, "Text_23223_1"):setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activeItem.activity_over_time)/1000)))
	ccui.Helper:seekWidgetByName(root, "Text_23223_1_0"):setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activeItem.activity_draw_over_time)/1000)))
	
	if __lua_project_id == __lua_project_yugioh then
		local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
		Panel_role:removeAllChildren(true)
		local jsonFile = string.format("sprite/spirte_battle_card_%s.json", _next_day_spine_index[1])
        local atlasFile = string.format("sprite/spirte_battle_card_%s.atlas", _next_day_spine_index[1])
        app.load("client.battle.fight.FightEnum")
        local spArmature = sp.spine(jsonFile, atlasFile, 1, 0, 
            spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)

        spArmature:setPosition(cc.p(Panel_role:getContentSize().width/2, 0))
        spArmature.animationNameList = spineAnimations
        sp.initArmature(spArmature, true)
        Panel_role:addChild(spArmature)
	end

	self:onUpdateRefresh()
end
function ActivityNextDay:onUpdateRefresh()
	local root = self.roots[1]
	local buttonRE = ccui.Helper:seekWidgetByName(root, "Button_chengse_lingqu")
	
	local activeItem = _ED.active_activity[48]

	if buttonRE == nil or nil == activeItem then
		return
	end
	
	local Image_7 = ccui.Helper:seekWidgetByName(root, "Image_8")
	
	buttonRE:setVisible(false)
	Image_7:setVisible(false)
	
	if tonumber(activeItem.activity_isReward) == 1 then -- 领取状态(0:不可领取1:可领取)
		buttonRE:setVisible(true)
	elseif tonumber(activeItem.activity_isReward) == 0 then 
		buttonRE:setVisible(true)
		buttonRE:setBright(false)
		buttonRE:setTouchEnabled(false)
	else
		Image_7:setVisible(true)
	end
end

function ActivityNextDay:lazy()
	local root = self.roots[1]
	local buttonRE = ccui.Helper:seekWidgetByName(root, "Button_chengse_lingqu")
	if nil == buttonRE then
		-- 为空的时候重置
		self:unload()
	end
	
	if self.loaded == true then
		return
	end
	self.loaded = true
	self:onInit()
end

function ActivityNextDay:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
end

function ActivityNextDay:onEnterTransitionFinish()
end

function ActivityNextDay.onImageLoaded(texture)
	
end

function ActivityNextDay:onArmatureDataLoad(percent)
	
end

function ActivityNextDay:onArmatureDataLoadEx(percent)
end

function ActivityNextDay:onLoad()

end

function ActivityNextDay:onInit()
    local csbActivityNextDay = csb.createNode("activity/wonderful/activity_chengse.csb")
    local root = csbActivityNextDay:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbActivityNextDay)
	
	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chengse_lingqu"), nil, 
	{
		terminal_name = "activity_next_day_go_to_lingqu_button", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		cell = self
	},
	nil,0)

end

function ActivityNextDay:onExit()
	state_machine.remove("activity_next_day_refresh_button")
	state_machine.remove("activity_next_day_go_to_lingqu_button")
end

function ActivityNextDay:init()
end


function ActivityNextDay:createCell()
	local cell = ActivityNextDay:new()
	cell:registerOnNodeEvent(cell)
	return cell
end