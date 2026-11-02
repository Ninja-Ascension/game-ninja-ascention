-- ----------------------------------------------------------------------------------------------------
-- 说明：商城招募按钮界面 
-- 创建时间
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ShopRecruitList = class("ShopRecruitListClass", Window)

function ShopRecruitList:ctor()
    self.super:ctor()

	app.load("client.shop.hero.ShopHeroPage")
	app.load("client.shop.RecruitInformation")
	app.load("client.shop.HeroRecruitPreview")
	app.load("client.shop.HeroRecruitSuccess")
	app.load("client.shop.HeroRecruitSuccessTen")
	
	self.roots = {}
    
	-- Initialize shop_window page state machine.
    local function init_shop_recruit_terminal()	
	
		--战将招募
		local shop_window_chick_battle_recruit_terminal = {
            _name = "shop_window_chick_battle_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)  
				--terminal._state   1战将招募  2神将招募  3三国对应阵营将招募
				local obj = ShopHeroPage:new()
				obj:setRanking(terminal._state )
				fwin:open(obj,fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

		--势力招募排期界面显示
		local shop_window_chick_shu_recruit_info_terminal = {
            _name = "shop_window_chick_shu_recruit_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(RecruitInformation:new(),fwin._ui)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		
		--招一次
		local shop_hero_page_chick_recruit_one_terminal = {
            _name = "shop_hero_page_chick_recruit_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if fwin:find("HeroRecruitSuccessClass") ~= nil then
							fwin:close(fwin:find("HeroRecruitSuccessClass"))
						end
						if fwin:find("ShopHeroPageClass") ~= nil then
							fwin:close(fwin:find("ShopHeroPageClass"))
						end
						
						local obj = HeroRecruitSuccess:new()
						obj:setRanking(terminal._state )
						fwin:open(obj,fwin._ui)
						fwin:find("ShopUserInformationClass"):UIInitInfo()
						fwin:find("ShopRecruitListClass"):UserInitInfo()
						-- local Panel_20 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_20")
					end
				end
				protocol_command.ship_bounty.param_list = terminal._state
				NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, nil, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--招十次
		local shop_hero_page_chick_recruit_ten_terminal = {
            _name = "shop_hero_page_chick_recruit_ten",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

				local function tenrecruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if fwin:find("HeroRecruitSuccessTenClass") ~= nil then
							fwin:close(fwin:find("HeroRecruitSuccessTenClass"))
						end
						if fwin:find("ShopHeroPageClass") ~= nil then
							fwin:close(fwin:find("ShopHeroPageClass"))
						end
						local obj = HeroRecruitSuccessTen:new()
						obj:setRanking(terminal._state )
						fwin:open(obj,fwin._ui)
						fwin:find("ShopUserInformationClass"):UIInitInfo()
						fwin:find("ShopRecruitListClass"):UserInitInfo()
						
					end
				end
				protocol_command.ship_batch_bounty.param_list = terminal._state
				NetworkManager:register(protocol_command.ship_batch_bounty.code, nil, nil, nil, nil, tenrecruitCallBack, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(shop_hero_page_chick_recruit_one_terminal)
		state_machine.add(shop_hero_page_chick_recruit_ten_terminal)
		state_machine.add(shop_window_chick_battle_recruit_terminal)
		state_machine.add(shop_window_chick_shu_recruit_info_terminal)	
        -- state_machine.init()
    end
    
    -- call func init hom state machine.
    init_shop_recruit_terminal()
end

--UI
function ShopRecruitList:ShowUI()
	local csbShopRecruitList = csb.createNode("shop/shop.csb")
	local action = csb.createTimeline("shop/shop.csb")
	action:gotoFrameAndPlay(0, action:getDuration(), false)
    csbShopRecruitList:runAction(action)
	
	local csbShopRecruitList_root = csbShopRecruitList:getChildByName("root")
	table.insert(self.roots, csbShopRecruitList_root)
	self:addChild(csbShopRecruitList)
end

local function formatTimeString(_time)	--系统时间转换
	local timeString = ""
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
	return timeString
end
	
--战将招募信息初始化
function ShopRecruitList:ZhanJiangInitInfo()
	self.EveryDayFreeTime = tonumber(_ED.free_info[1].surplus_free_number) or 0				-- 每日免费次数
	self.ZhanjiangFreeTime = tonumber(_ED.free_info[1].next_free_time) or 0					-- 战将免费抽取倒计时
	
	local Panel_32 		= ccui.Helper:seekWidgetByName(self.roots[1], "Panel_32")
	local Panel_33 		= ccui.Helper:seekWidgetByName(self.roots[1], "Panel_33")
	local Panel_34 		= ccui.Helper:seekWidgetByName(self.roots[1], "Panel_34")
	
	local Text_cishu	 = ccui.Helper:seekWidgetByName(Panel_34, "Text_cishu")
	local Text_shijian_1 = ccui.Helper:seekWidgetByName(Panel_33, "Text_shijian_1")
	
	local function step1(dt)														-- 战将免费抽取倒计时
		-- -- if ShopHeroPageClass._uiLayer ~= nil then
			local zhanjiang_passedTime = tonumber(os.time()) - tonumber((_ED.free_info[1].free_start) or 0)
			remainTime1 = - (tonumber(_ED.free_info[1].next_free_time) or 0)/1000 - zhanjiang_passedTime

			self.remainTime  =  remainTime1
			timeUp = remainTime1 <= 0 and true or false
			if timeUp == true then	
				remainTime2 = 0	
			else
				Text_shijian_1:setString(formatTimeString(remainTime1))
			end
		-- -- end
	end
	step1()
	
	if zstring.tonumber(self.EveryDayFreeTime) > 0 then
		if zstring.tonumber(self.remainTime) > 0 then
			Panel_32:setVisible(false)
			Panel_33:setVisible(true)
			Panel_34:setVisible(false)
			step1()
			self:scheduler("step1",step1,1)
		else
			Panel_32:setVisible(false)
			Panel_33:setVisible(false)
			Panel_34:setVisible(true)
			Text_cishu:setString(self.EveryDayFreeTime)
		end
		
	elseif zstring.tonumber(self.EveryDayFreeTime) <= 0 then 
		Panel_32:setVisible(true)
		Panel_33:setVisible(false)
		Panel_34:setVisible(false)
	end
	
	

end

--神将招募信息初始化
function ShopRecruitList:ShenJiangInitInfo()	
	self.shengjiang_FirstState = tonumber(_ED.free_info[2].first_satus)	or 0		--首次必得橙将
	local Panel_32_1 		= ccui.Helper:seekWidgetByName(self.roots[1], "Panel_32_1")
	local Panel_32_0_0 		= ccui.Helper:seekWidgetByName(self.roots[1], "Panel_32_0_0")
	local Text_518 			= ccui.Helper:seekWidgetByName(Panel_32_1, "Text_518")
	local Text_55 			= ccui.Helper:seekWidgetByName(Panel_32_0_0, "Text_55")
	
	if self.shengjiang_FirstState == 0 then
		Panel_32_1:setVisible(false)
		Panel_32_0_0:setVisible(true)
		Text_55:setString(_string_piece_info[15])
	else
		local function step2(dt)									-- 神将免费抽取倒计时
			-- -- if ShopHeroPageClass._uiLayer ~= nil then
				local shenjiang_passedTime = tonumber (os.time()) - tonumber(_ED.free_info[2].free_start)
				remainTime2 = tonumber(_ED.free_info[2].next_free_time)/1000 - shenjiang_passedTime
				timeUp = remainTime2 <= 0 and true or false
				if timeUp == true then
					Panel_32_1:setVisible(false)
					Panel_32_0_0:setVisible(true)	
					remainTime2 = 0	
				else
					Panel_32_1:setVisible(true)
					Panel_32_0_0:setVisible(false)
					Text_518:setString(formatTimeString(remainTime2))
				end
			-- -- end
		end	
		step2()
		self:scheduler("step2",step2,1)
	end
	
end

--对应阵营武将招募初始化
function ShopRecruitList:ZhenyingJiangInitInfo()
	local SpendGod = dms.string(dms["partner_bounty_param"], 4, partner_bounty_param.spend_god) -- 招募时消耗的元宝 80  ???

	local Panel_32_1_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_32_1_0")
	local Text_515 = ccui.Helper:seekWidgetByName(Panel_32_1_0, "Text_515")
	local Text_516 = ccui.Helper:seekWidgetByName(Panel_32_1_0, "Text_516")

	Text_516:setString("80")	

	--_ED.native_time
	local function step3(dt)																-- 群雄阵营切换倒计时
		-- -- if ShopHeroPageClass._uiLayer ~= nil then
			local qunxiong_passedTime = tonumber (os.time()) - tonumber(_ED.free_info[3].free_start)
			remainTime3 = tonumber(_ED.free_info[3].next_free_time)/1000 - qunxiong_passedTime
			timeUp = remainTime3 <= 0 and true or false
			if timeUp == true then
				remainTime3 = 0	
			else
				Text_515:setString(formatTimeString(remainTime3))
			end
		-- -- end
	end	
	step3(dt)
	self:scheduler("step3",step3,1)
end

--用户道具初始化
function ShopRecruitList:UserInitInfo()
	
	local pMouID = 51					--神将令模板ID
	local zhanjiangling = getPropAllCountByMouldId(pMouID)
	local shenjiangling = getPropAllCountByMouldId(pMouID)
	
	local Text_1_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_1_1")
	Text_1_1:setString(zhanjiangling)
	local Text_1_1_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_1_1_0")
	Text_1_1_0:setString(shenjiangling)
end

function ShopRecruitList:onEnterTransitionFinish()
	self:ShowUI()
	self:UserInitInfo()
	self:ZhanJiangInitInfo()
	self:ShenJiangInitInfo()
	self:ZhenyingJiangInitInfo()
	
	local battle_recruit 	= fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_15"), nil, {terminal_name = "shop_window_chick_battle_recruit", terminal_state = 1, touch_scale = true, 
									isPressedActionEnabled = true}, nil, 0)
	local sprit_recruit 	= fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_16"), nil, {terminal_name = "shop_window_chick_battle_recruit", terminal_state = 2, touch_scale = true, 
									isPressedActionEnabled = true}, nil, 0)
	local shu_recruit 		= fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_17"), nil, {terminal_name = "shop_window_chick_battle_recruit", terminal_state = 3, touch_scale = true, 
									isPressedActionEnabled = true}, nil, 0)
	local recruit_info	 	= fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_18"), nil, {func_string = [[state_machine.excute("shop_window_chick_shu_recruit_info", 0, "click shop_window_chick_shu_recruit.'")]],isPressedActionEnabled = true}, nil, 0)
end

function ShopRecruitList:ChangeInfo(dt)
	
end

function ShopRecruitList:onExit()
	state_machine.remove("shop_window_chick_battle_recruit")
	state_machine.remove("shop_window_chick_shu_recruit_info")
	state_machine.remove("shop_hero_page_chick_recruit_one")
	state_machine.remove("shop_hero_page_chick_recruit_ten")
end
