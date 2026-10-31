-- ----------------------------------------------------------------------------------------------------
-- 说明：武将出售按品质选择界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

HeroSellChooseByQuality = class("HeroSellChooseByQualityClass", Window)
   
function HeroSellChooseByQuality:ctor()
    self.super:ctor()
	self.roots = {}
	self.white = false
	self.blue = false
	self.green = false
	self.sort = {}
	
    local function init_hero_sell_choose_by_quality_terminal()
		local hero_sell_choose_by_quality_return_back_terminal = {
            _name = "hero_sell_choose_by_quality_return_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_sell_choose_sure_terminal = {
            _name = "hero_sell_choose_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_sell_choose_white_terminal = {
            _name = "hero_sell_choose_white",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local status = false
				for i,v in pairs(self.sort) do
					if dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.ship_type) == 0 then
						status = true
					end
				end
				if status == true then
					if instance.white == false then
						instance.white = true
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_19"):setVisible(true)
						state_machine.excute("hero_sell_batch_sell", 0, {_datas = {quality = 0,status = true}})
					else
						instance.white = false
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_19"):setVisible(false)
						state_machine.excute("hero_sell_batch_sell", 0, {_datas = {quality = 0,status = false}})
					end
				else
					TipDlg.drawTextDailog(_string_piece_info[111])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_sell_choose_green_terminal = {
            _name = "hero_sell_choose_green",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local status = false
				for i,v in pairs(self.sort) do
					if dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.ship_type) == 1 then
						status = true
					end
				end
				if status == true then
					if instance.green == false then
						instance.green = true
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_15"):setVisible(true)
						state_machine.excute("hero_sell_batch_sell", 0, {_datas = {quality = 1,status = true}})
					else
						instance.green = false
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_15"):setVisible(false)
						state_machine.excute("hero_sell_batch_sell", 0, {_datas = {quality = 1,status = false}})
					end
				else
					TipDlg.drawTextDailog(_string_piece_info[111])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_sell_choose_blue_terminal = {
            _name = "hero_sell_choose_blue",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local status = false
				for i,v in pairs(self.sort) do
					if dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.ship_type) == 2 then
						status = true
					end
				end
				if status == true then
					if instance.blue == false then
						instance.blue = true
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_17"):setVisible(true)
						state_machine.excute("hero_sell_batch_sell", 0, {_datas = {quality = 2,status = true}})
					else
						instance.blue = false
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_17"):setVisible(false)
						state_machine.excute("hero_sell_batch_sell", 0, {_datas = {quality = 2,status = false}})
					end
				else
					TipDlg.drawTextDailog(_string_piece_info[111])
				end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(hero_sell_choose_by_quality_return_back_terminal)
		state_machine.add(hero_sell_choose_sure_terminal)
		state_machine.add(hero_sell_choose_white_terminal)
		state_machine.add(hero_sell_choose_green_terminal)
		state_machine.add(hero_sell_choose_blue_terminal)

        state_machine.init()
    end
    
    init_hero_sell_choose_by_quality_terminal()
end


function HeroSellChooseByQuality:onEnterTransitionFinish()
    local csbHeroSell = csb.createNode("packs/HeroStorage/generals_sell_grade.csb")
	local action = csb.createTimeline("packs/HeroStorage/generals_sell_grade.csb")
	csbHeroSell:runAction(action)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
    self:addChild(csbHeroSell)
	local root = csbHeroSell:getChildByName("root")
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {func_string = [[state_machine.excute("hero_sell_choose_by_quality_return_back", 0, "click hero_sell_choose_by_quality_return_back.'")]], 
									isPressedActionEnabled = true}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, {func_string = [[state_machine.excute("hero_sell_choose_sure", 0, "click hero_sell_choose_sure.'")]], 
									isPressedActionEnabled = true}, nil, 0)	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_12"), nil, {func_string = [[state_machine.excute("hero_sell_choose_white", 0, "click hero_sell_choose_white.'")]]}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_10"), nil, {func_string = [[state_machine.excute("hero_sell_choose_green", 0, "click hero_sell_choose_green.'")]]}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_11"), nil, {func_string = [[state_machine.excute("hero_sell_choose_blue", 0, "click hero_sell_choose_blue.'")]]}, nil, 0)
end

function HeroSellChooseByQuality:init(sorts)
	self.sort = sorts
end

function HeroSellChooseByQuality:onExit()
	state_machine.remove("hero_sell_choose_by_quality_return_back")
	state_machine.remove("hero_sell_choose_sure")
	state_machine.remove("hero_sell_choose_white")
	state_machine.remove("hero_sell_choose_green")
	state_machine.remove("hero_sell_choose_blue")
end
