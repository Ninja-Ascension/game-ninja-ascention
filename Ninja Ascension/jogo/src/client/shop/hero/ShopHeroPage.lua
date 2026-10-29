 -- ----------------------------------------------------------------------------------------------------
-- 说明：英雄招募界面
-- 创建时间
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ShopHeroPage = class("ShopHeroPageClass", Window)
    
function ShopHeroPage:ctor()
    self.super:ctor()
	
	app.load("client.shop.HeroRecruitPreview")
	app.load("client.shop.HeroRecruitSuccess")
	app.load("client.shop.HeroRecruitSuccessTen")
	
	self.roots = {}
	
    -- Initialize ShopHeroPage page state machine.
    local function init_ShopHeroPage_terminal()
		--返回shop主界面
		local shop_hero_page_return_show_shop_terminal = {
            _name = "shop_hero_page_return_show_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_pokemon 
            		or __lua_project_id == __lua_project_rouge
            		then
            		state_machine.excute("hero_recruit_list_action_show")
            		instance:removeFromParent(true)
                else
                	fwin:close(instance)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--招募预览界面
		local shop_return_show_hero_recruit_preview_terminal = {
            _name = "shop_return_show_hero_recruit_preview",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = HeroRecruitPreview:new()
				cell:init(2)
				fwin:open(cell, fwin._windows)				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--招募失败
		local shop_hero_page_chick_defult_terminal = {
            _name = "shop_hero_page_chick_defult",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--> debug.log(true,"招募失败")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(shop_hero_page_return_show_shop_terminal)
		state_machine.add(shop_return_show_hero_recruit_preview_terminal)
		state_machine.add(shop_hero_page_chick_defult_terminal)
		
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_ShopHeroPage_terminal()
end

function ShopHeroPage:setRanking(ranking)
	self.ranking = ranking
end

	
--战将招募信息初始化
function ShopHeroPage:ZhanJiangInitInfo()
	self.zhanjiangLin 		= tonumber(getPropAllCountByMouldId(51)) or 0     	--用户拥有战将领
	self.zhanjiangLinTen 	= 10								--用户连抽所需战将令
	self.oneC 				= false								--用户是否可以单抽
	self.tenC 				= false								--用户是否可以十连
	
	local Zhanjiang_Panel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_01")
	local zhengjiangling = ccui.Helper:seekWidgetByName(Zhanjiang_Panel, "Text_8")
	zhengjiangling:setString(self.zhanjiangLin)
	
	local Onlyone = ccui.Helper:seekWidgetByName(Zhanjiang_Panel, "Panel_03_1")
	local OneAndTen = ccui.Helper:seekWidgetByName(Zhanjiang_Panel, "Panel_02_1")
	local Button_one = ccui.Helper:seekWidgetByName(Zhanjiang_Panel, "Button_334213")
	local Button_ten = ccui.Helper:seekWidgetByName(Zhanjiang_Panel, "Button_3342314")
	local Only_Button_one1 = ccui.Helper:seekWidgetByName(Zhanjiang_Panel, "Button_33413")

	if	self.zhanjiangLin > 0 then
		if self.zhanjiangLin >= self.zhanjiangLinTen then
			self.tenC = true
		end
		self.oneC = true
	elseif zstring.tonumber(self.zhanjiangLin) == 0 then
	end

	if self.oneC == true then
		local one = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_334213"), nil, {terminal_name = "shop_hero_page_chick_recruit_one", terminal_state = 1, touch_scale = true,isPressedActionEnabled = true}, nil, 0)
	else
		local one = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_334213"), nil, {terminal_name = "shop_hero_page_chick_defult", terminal_state = 1, touch_scale = true,isPressedActionEnabled = true}, nil, 0)
	end
	if self.tenC == true then
		local ten = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_3342314"), nil, {terminal_name = "shop_hero_page_chick_recruit_ten", terminal_state = 1, touch_scale = true,isPressedActionEnabled = true}, nil, 0)
	else
		local ten = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_3342314"), nil, {terminal_name = "shop_hero_page_chick_defult", terminal_state = 1, touch_scale = true,isPressedActionEnabled = true}, nil, 0)	
	end
end

--神将招募信息初始化
function ShopHeroPage:ShenJiangInitInfo()
	self.shenjiangling = getPropAllCountByMouldId(51) or 0			--用户拥有神将领
	self.user_god = _ED.user_info.user_gold						--用户拥有的金币
	self.max_recruit_Time = 10									--出橙将招募次数
	self.recruit_Time = self.max_recruit_Time - _ED.user_accumulate_buy_god		--招募橙，紫将的次数
	self.recruit_one = dms.string(dms["partner_bounty_param"], 2, partner_bounty_param.spend_gold)	--招募一次需要花的金币
	self.recruit_ten = dms.string(dms["partner_bounty_param"], 4, partner_bounty_param.spend_gold)	--招募十次需要花的金币	

	--> print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz招募紫将：", _ED.user_accumulate_buy_god )	
	
	
	self.shenjiangling_oneC = false				-- 是否可以神将单抽
	self.shenjiangling_tenC = false				-- 是否可以神将十连抽
	
	local Shenjiang_Panel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_02")
	local shenjiangling = ccui.Helper:seekWidgetByName(Shenjiang_Panel, "Text_8_1")
	local user_god = ccui.Helper:seekWidgetByName(Shenjiang_Panel, "Text_8_2")
	local recruit_Time = ccui.Helper:seekWidgetByName(Shenjiang_Panel, "Label_33405")
	local recruit_one = ccui.Helper:seekWidgetByName(Shenjiang_Panel, "Label_33417_0")
	local recruit_ten = ccui.Helper:seekWidgetByName(Shenjiang_Panel, "Label_33417")
	
	shenjiangling:setString(self.shenjiangling)
	user_god:setString(self.user_god)
	recruit_Time:setString(self.recruit_Time)
	recruit_one:setString(self.recruit_one)
	recruit_ten:setString(self.recruit_ten)
	
	
	if zstring.tonumber(self.user_god) >= zstring.tonumber(self.recruit_ten) then
		self.shenjiangling_oneC = true
		self.shenjiangling_tenC = true
	else
		self.shenjiangling_oneC = true
	end
	
	if self.shenjiangling_oneC == true then
		local one = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_33413123"), nil, {terminal_name = "shop_hero_page_chick_recruit_one", terminal_state = 2, touch_scale = true}, nil, 0)
	else
		local one = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_33413123"), nil, {terminal_name = "shop_hero_page_chick_defult", terminal_state = 2, touch_scale = true}, nil, 0)

	end
	
	if self.shenjiangling_tenC == true then
		local one = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_33414"), nil, {terminal_name = "shop_hero_page_chick_recruit_ten", terminal_state = 2, touch_scale = true}, nil, 0)
	else
		local one = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_33414"), nil, {terminal_name = "shop_hero_page_chick_defult", terminal_state = 2, touch_scale = true}, nil, 0)
	end
end

--对应阵营武将招募初始化
function ShopHeroPage:ZhenyingJiangInitInfo()
	self.user_god = _ED.user_info.user_gold							--用户拥有的金币
	self.recruit_Time1 = _ED.user_info.surplus_free_number			--招募橙将的倍率
	self.purple_ship_count = _ED.user_accumulate_buy_god 			--已招募紫将次数
	self.already_recruit_Time = _ED.user_accumulate_camp_god 		--已招募橙将的次数
	--> print("招募橙将：", _ED.user_accumulate_camp_god )
	
	
	-- local costGod = dms.string(dms["partner_bounty_param"], 3, 5)
	self.recruit_one = "80"											--招募一次需要花的金币
	self.Beishu = "1"												--招募橙将的倍数
	
	local ZhenyingJiang_Panel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_03")
	
	local user_god = ccui.Helper:seekWidgetByName(ZhenyingJiang_Panel, "Text_9")
	local recruit_Time1 = ccui.Helper:seekWidgetByName(ZhenyingJiang_Panel, "Label_33403_1")	
	local recruit_one = ccui.Helper:seekWidgetByName(ZhenyingJiang_Panel, "Label_33403_3")
	
	local already_recruit_Time = ccui.Helper:seekWidgetByName(ZhenyingJiang_Panel, "Label_33403_4")
	
	user_god:setString(self.user_god)
	recruit_Time1:setString(self.recruit_Time1)
	recruit_one:setString(self.recruit_one)
	
	already_recruit_Time:setString(self.already_recruit_Time)

	local one = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_354165"), nil, {
		terminal_name = "shop_hero_page_chick_recruit_one", terminal_state = 3, touch_scale = true
	}, nil, 0)
	
end

--UI的初始化
function ShopHeroPage:ShowPage()
	local csbShopHeroPage = csb.createNode("shop/recruit_god.csb")
	local csbShopHeroPage_root = csbShopHeroPage:getChildByName("root")
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		local action = csb.createTimeline("shop/recruit_god.csb")  
	   	action:gotoFrameAndPlay(0, action:getDuration(), false)
	    csbShopHeroPage:runAction(action)
	end

	table.insert(self.roots, csbShopHeroPage_root)
	self:addChild(csbShopHeroPage)
end

--初始化弹出界面的信息
function ShopHeroPage:InfoInit()
	local panel = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_0%d",self.ranking))
	panel:setVisible(true)
	panel:setTouchEnabled(true)
	
	if self.ranking == 1 then
		self:ZhanJiangInitInfo()
		-- HeroRecruitSuccess:setobj()
	elseif self.ranking == 2 then
		self:ShenJiangInitInfo()
	elseif self.ranking == 3 then
		self:ZhenyingJiangInitInfo()
	end
end

function ShopHeroPage:onEnterTransitionFinish()
	self:ShowPage()
	self:InfoInit()
	
	local close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_33401"), nil, {terminal_name = "shop_hero_page_return_show_shop", terminal_state = 0, touch_scale = true}, nil, 2)
	local close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"), nil, {terminal_name = "shop_return_show_hero_recruit_preview", terminal_state = 0, touch_scale = true}, nil, 0)
end



function ShopHeroPage:onExit()
	state_machine.remove("shop_hero_page_return_show_shop")
	state_machine.remove("shop_return_show_hero_recruit_preview")
	state_machine.remove("shop_hero_page_chick_defult")
	
end

