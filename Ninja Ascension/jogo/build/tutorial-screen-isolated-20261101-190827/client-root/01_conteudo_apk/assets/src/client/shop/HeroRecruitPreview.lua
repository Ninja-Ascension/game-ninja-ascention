-----HeroRecruitPreview.lua-----------------------------------------------------------------------------------------------------------
-- 说明：招募预览界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
-- require "src/client/loader/LocalDatas"

HeroRecruitPreview = class("HeroRecruitPreviewClass", Window)
    
function HeroRecruitPreview:ctor()
    self.super:ctor()
	self.roots = {}
	self.types = nil
	self.group = {}
	app.load("client.shop.HeroRecruitPreviewOne")
	app.load("client.shop.HeroRecruitPreviewTwo")
	app.load("client.shop.HeroRecruitPreviewThree")
	app.load("client.shop.HeroRecruitPreviewFour")
    -- Initialize HeroRecruitPreview page state machine.
    local function init_HeroRecruitPreview_terminal()
		--返回招募界面
		local hero_recruit_preview_return_shop_hero_page_terminal = {
            _name = "hero_recruit_preview_return_shop_hero_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local pageOne = fwin:find("HeroRecruitPreviewOneClass")
				local pageTwo = fwin:find("HeroRecruitPreviewTwoClass")
				local pageThree = fwin:find("HeroRecruitPreviewThreeClass")
				local pageFour = fwin:find("HeroRecruitPreviewFourClass")
				fwin:close(pageOne)
				fwin:close(pageTwo)
				fwin:close(pageThree)
				fwin:close(pageFour)
				fwin:close(instance)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--魏国战将显示
		local hero_recruit_preview_chick_weiguo_terminal = {
            _name = "hero_recruit_preview_chick_weiguo",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateDrawOne()
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_041"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_042"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_043"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_044"):setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--蜀国战将显示
		local hero_recruit_preview_chick_shuguo_terminal = {
            _name = "hero_recruit_preview_chick_shuguo",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateDrawTwo()
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_042"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_041"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_043"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_044"):setVisible(false)
            end,
            _terminal = nil,
            _terminals = nil
        }

		--吴国战将显示
		local hero_recruit_preview_chick_wuguo_terminal = {
            _name = "hero_recruit_preview_chick_wuguo",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateDrawThree()
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_043"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_042"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_041"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_044"):setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--群雄战将显示
		local hero_recruit_preview_chick_qunxiong_terminal = {
            _name = "hero_recruit_preview_chick_qunxiong",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateDrawFour()
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_044"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_042"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_043"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_041"):setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--查看武将信息
		local hero_recruit_preview_show_info_terminal = {
            _name = "hero_recruit_preview_show_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				app.load("client.packs.hero.HeroPatchInformation")
				local cell = HeroPatchInformation:new()
				cell:init(params._datas._id, nil , nil, 2)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--武将状态机
		local hero_recruit_preview_button_mananger_terminal = {
			_name = "hero_recruit_preview_button_mananger",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			
				if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end
				if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    if tonumber(params._datas.current_button_type) == 1 then
						instance:onUpdateDrawOne()
					elseif tonumber(params._datas.current_button_type) == 2 then
						instance:onUpdateDrawTwo()
					elseif tonumber(params._datas.current_button_type) == 3 then
						instance:onUpdateDrawThree()
					elseif tonumber(params._datas.current_button_type) == 4 then
						instance:onUpdateDrawFour()
					end
                end
				instance:hideSelectImage()
                return true
            end,
            _terminal = nil,
            _terminals = nil
		
		}

		state_machine.add(hero_recruit_preview_return_shop_hero_page_terminal)
		state_machine.add(hero_recruit_preview_chick_weiguo_terminal)
		state_machine.add(hero_recruit_preview_chick_shuguo_terminal)
		state_machine.add(hero_recruit_preview_chick_wuguo_terminal)
		state_machine.add(hero_recruit_preview_chick_qunxiong_terminal)
		state_machine.add(hero_recruit_preview_show_info_terminal)
		if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			state_machine.add(hero_recruit_preview_button_mananger_terminal)
		end
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_HeroRecruitPreview_terminal()
end


function HeroRecruitPreview:onUpdateDrawOne()
	local root = self.roots[1]
	if self.group[2] ~= nil then
		self.group[2]:setVisible(false)
	end
	
	if self.group[3] ~= nil then
		self.group[3]:setVisible(false)
	end
	
	if self.group[4] ~= nil then
		self.group[4]:setVisible(false)
	end
	
	if self.group[1] == nil then
		local cell = HeroRecruitPreviewTwo:createCell()
		cell:init(self.types)
		ccui.Helper:seekWidgetByName(root, "Panel_206"):addChild(cell)
		self.group[1] = cell
	else
		self.group[1]:setVisible(true)
	end

	
end

function HeroRecruitPreview:onUpdateDrawTwo()
	local root = self.roots[1]

	if self.group[1] ~= nil then
		self.group[1]:setVisible(false)
	end
	
	if self.group[3] ~= nil then
		self.group[3]:setVisible(false)
	end
	
	if self.group[4] ~= nil then
		self.group[4]:setVisible(false)
	end
	
	if self.group[2] == nil then
		local cell = HeroRecruitPreviewOne:createCell()
		cell:init(self.types)
		ccui.Helper:seekWidgetByName(root, "Panel_206"):addChild(cell)
		self.group[2] = cell
	else
		self.group[2]:setVisible(true)
	end
	
end

function HeroRecruitPreview:onUpdateDrawThree()
	local root = self.roots[1]
	if self.group[1] ~= nil then
		self.group[1]:setVisible(false)
	end
	
	if self.group[2] ~= nil then
		self.group[2]:setVisible(false)
	end
	
	if self.group[4] ~= nil then
		self.group[4]:setVisible(false)
	end
	
	if self.group[3] == nil then
		local cell = HeroRecruitPreviewThree:createCell()
		cell:init(self.types)
		ccui.Helper:seekWidgetByName(root, "Panel_206"):addChild(cell)
		self.group[3] = cell
	else
		self.group[3]:setVisible(true)
	end
	
end

function HeroRecruitPreview:onUpdateDrawFour()
	local root = self.roots[1]
	if self.group[1] ~= nil then
		self.group[1]:setVisible(false)
	end
	
	if self.group[2] ~= nil then
		self.group[2]:setVisible(false)
	end
	
	if self.group[3] ~= nil then
		self.group[3]:setVisible(false)
	end
	
	if self.group[4] == nil then
		local cell = HeroRecruitPreviewFour:createCell()
		cell:init(self.types)
		ccui.Helper:seekWidgetByName(root, "Panel_206"):addChild(cell)
		self.group[4] = cell
	else
		self.group[4]:setVisible(true)
	end
	
end

function HeroRecruitPreview:hideSelectImage()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	ccui.Helper:seekWidgetByName(root, "Image_044"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_042"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_043"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_041"):setVisible(false)
end

function HeroRecruitPreview:onEnterTransitionFinish()
	-- [[-------------------------------------
	-- add map for trial tower
    local csbHeroRecruitPreview = csb.createNode("shop/merchants_will_preview.csb")
	local root = csbHeroRecruitPreview:getChildByName("root")
	table.insert(self.roots, root)
	
	local action = csb.createTimeline("shop/merchants_will_preview.csb")
    csbHeroRecruitPreview:runAction(action)
	--action:gotoFrameAndPlay(0, action:getDuration(), false)
	action:play("window_open", false)
	
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "over" then
			if __lua_project_id ~= __lua_project_warship_girl_b and __lua_project_id ~= __lua_project_digimon_adventure	and __lua_project_id ~= __lua_project_pokemon
				and __lua_project_id ~= __lua_project_rouge and __lua_project_id ~= __lua_project_yugioh then 
				state_machine.excute("hero_recruit_preview_chick_weiguo", 0, "click .'")
			end
			
        end
        
    end)
	
    self:addChild(csbHeroRecruitPreview)
	local return_home = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_colose"), nil, 
	{
		func_string = [[state_machine.excute("hero_recruit_preview_return_shop_hero_page", 0, "click .'")]],
		isPressedActionEnabled = true
	}, nil, 2)
	
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_god"),       nil, 
	    {
	        terminal_name = "hero_recruit_preview_button_mananger",     
	        current_button_name = "Button_god",  
	        current_button_type = 1 ,      
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	
	    local heian = ccui.Helper:seekWidgetByName(root, "Button_good_will")
		heian:setHighlighted(false)
		heian:setTouchEnabled(true)
		
		local doushi = ccui.Helper:seekWidgetByName(root, "Button_troopers")
		doushi:setHighlighted(false)
		doushi:setTouchEnabled(true)
		
		local qimo = ccui.Helper:seekWidgetByName(root, "Button_troopers_0")
		qimo:setHighlighted(false)
		qimo:setTouchEnabled(true)
    	--黑暗
		fwin:addTouchEventListener(heian,       nil, 
		{
			terminal_name = "hero_recruit_preview_button_mananger",     
			current_button_name = "Button_good_will",  
			current_button_type = 2 ,      
			terminal_state = 0, 
			isPressedActionEnabled = false
		}, 
		nil, 0)
		--斗士
		fwin:addTouchEventListener(doushi,       nil, 
		{
			terminal_name = "hero_recruit_preview_button_mananger",     
			current_button_name = "Button_troopers",  
			current_button_type = 3 ,      
			terminal_state = 0, 
			isPressedActionEnabled = false
		}, 
		nil, 0)
		--七魔
		fwin:addTouchEventListener(qimo,       nil, 
		{
			terminal_name = "hero_recruit_preview_button_mananger",     
			current_button_name = "Button_troopers_0",  
			current_button_type = 4 ,      
			terminal_state = 0, 
			isPressedActionEnabled = false
		}, 
		nil, 0)
		state_machine.excute("hero_recruit_preview_button_mananger", 0, 
			{_datas ={
				current_button_name = "Button_god",        
				current_button_type = 1 ,      
				terminal_state = 0, 
				isPressedActionEnabled = true
			}}
			)
	else
		-- 魏国
		local weiguo = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_god"), nil, 
		{
			func_string = [[state_machine.excute("hero_recruit_preview_chick_weiguo", 0, "click .'")]],
			isPressedActionEnabled = true
		}, nil, 0)
		-- 蜀国
		local shuguo = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_good_will"), nil, 
		{
			func_string = [[state_machine.excute("hero_recruit_preview_chick_shuguo", 0, "click .'")]],
			isPressedActionEnabled = true
		}, nil, 0)
		-- 吴国
		local wuguo = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_troopers"), nil, 
		{
			func_string = [[state_machine.excute("hero_recruit_preview_chick_wuguo", 0, "click .'")]],
			isPressedActionEnabled = true
		}, nil, 0)
		-- 群雄
		local qunxiong = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_troopers_0"), nil, 
		{
			func_string = [[state_machine.excute("hero_recruit_preview_chick_qunxiong", 0, "click .'")]],
			isPressedActionEnabled = true
		}, nil, 0)
	end
	
end


function HeroRecruitPreview:init(types)
	self.types = types
end

function HeroRecruitPreview:onExit()
	state_machine.remove("hero_recruit_preview_return_shop_hero_page")
	state_machine.remove("hero_recruit_preview_chick_weiguo")
	state_machine.remove("hero_recruit_preview_chick_shuguo")
	state_machine.remove("hero_recruit_preview_chick_wuguo")
	state_machine.remove("hero_recruit_preview_chick_qunxiong")
	state_machine.remove("hero_recruit_preview_show_info")
end

--return HeroRecruitPreview:new()