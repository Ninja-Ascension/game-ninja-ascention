-- ----------------------------------------------------------------------------------------------------
-- 说明：装备出售按品质选择界面
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

EquipSellChooseByQuality = class("EquipSellChooseByQualityClass", Window)
if __lua_project_id == __lua_project_gragon_tiger_gate
	or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	or __lua_project_id == __lua_project_red_alert 
	or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
	or __lua_project_id == __lua_project_pokemon 
	or __lua_project_id == __lua_project_rouge 
	or __lua_project_id == __lua_project_warship_girl_b 
	then
	EquipSellChooseByQuality.white = false
	EquipSellChooseByQuality.blue = false
	EquipSellChooseByQuality.green = false
end
function EquipSellChooseByQuality:ctor()
    self.super:ctor()
	self.roots = {}
    self.white = false
	self.blue = false
	self.green = false
	self.sort = {}
    -- Initialize Home page state machine.
    local function init_equip_sell_choose_by_quality_terminal()
		local equip_sell_choose_by_quality_return_back_terminal = {
            _name = "equip_sell_choose_by_quality_return_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            		or __lua_project_id == __lua_project_red_alert 
            		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
            		or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
            		or __lua_project_id == __lua_project_warship_girl_b 
            		then
	               EquipSellChooseByQuality.white = instance.white
				   EquipSellChooseByQuality.blue = instance.blue
				   EquipSellChooseByQuality.green = instance.green
				end
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_sell_choose_sure_terminal = {
            _name = "equip_sell_choose_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            		or __lua_project_id == __lua_project_red_alert 
            		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
            		or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
            		or __lua_project_id == __lua_project_warship_girl_b 
            		then
	               EquipSellChooseByQuality.white = instance.white
				   EquipSellChooseByQuality.blue = instance.blue
				   EquipSellChooseByQuality.green = instance.green
				end
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local equip_sell_choose_white_terminal = {
            _name = "equip_sell_choose_white",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local status = false
				for i,v in pairs(self.sort) do
					if dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) == 0 then
						status = true
					end
				end
				if status == true then
					if instance.white == false then
						instance.white = true
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_19"):setVisible(true)
						state_machine.excute("equip_sell_batch_sell", 0, {_datas = {quality = 0,status = true}})
					else
						instance.white = false
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_19"):setVisible(false)
						state_machine.excute("equip_sell_batch_sell", 0, {_datas = {quality = 0,status = false}})
					end
				else
					TipDlg.drawTextDailog(_string_piece_info[110])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_sell_choose_green_terminal = {
            _name = "equip_sell_choose_green",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local status = false
				for i,v in pairs(self.sort) do
					if dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) == 1 then
						status = true
					end
				end
				if status == true then
					if instance.green == false then
						instance.green = true
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_15"):setVisible(true)
						state_machine.excute("equip_sell_batch_sell", 0, {_datas = {quality = 1,status = true}})
					else
						instance.green = false
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_15"):setVisible(false)
						state_machine.excute("equip_sell_batch_sell", 0, {_datas = {quality = 1,status = false}})
					end
				else
					TipDlg.drawTextDailog(_string_piece_info[110])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_sell_choose_blue_terminal = {
            _name = "equip_sell_choose_blue",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local status = false
				for i,v in pairs(self.sort) do
					if dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) == 2 then
						status = true
					end
				end
				if status == true then
					if instance.blue == false then
						instance.blue = true
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_17"):setVisible(true)
						state_machine.excute("equip_sell_batch_sell", 0, {_datas = {quality = 2,status = true}})
					else
						instance.blue = false
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_17"):setVisible(false)
						state_machine.excute("equip_sell_batch_sell", 0, {_datas = {quality = 2,status = false}})
					end
				else
					TipDlg.drawTextDailog(_string_piece_info[110])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(equip_sell_choose_by_quality_return_back_terminal)
		state_machine.add(equip_sell_choose_sure_terminal)
        state_machine.add(equip_sell_choose_white_terminal)
		state_machine.add(equip_sell_choose_green_terminal)
		state_machine.add(equip_sell_choose_blue_terminal)

        state_machine.init()
    end
    
    init_equip_sell_choose_by_quality_terminal()
end


function EquipSellChooseByQuality:onEnterTransitionFinish()
    local csbEquipSell = csb.createNode("packs/EquipStorage/equipment_sell_grade.csb")
	local action = csb.createTimeline("packs/EquipStorage/equipment_sell_grade.csb")
	csbEquipSell:runAction(action)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
    self:addChild(csbEquipSell)
	local root = csbEquipSell:getChildByName("root")
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {func_string = [[state_machine.excute("equip_sell_choose_by_quality_return_back", 0, "click equip_sell_choose_by_quality_return_back.'")]], 
									isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, {func_string = [[state_machine.excute("equip_sell_choose_sure", 0, "click equip_sell_choose_sure.'")]], 
									isPressedActionEnabled = true}, nil, 0)	

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_12"), nil, {func_string = [[state_machine.excute("equip_sell_choose_white", 0, "click equip_sell_choose_white.'")]]}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_10"), nil, {func_string = [[state_machine.excute("equip_sell_choose_green", 0, "click equip_sell_choose_green.'")]]}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_11"), nil, {func_string = [[state_machine.excute("equip_sell_choose_blue", 0, "click equip_sell_choose_blue.'")]]}, nil, 0)

   -- EquipSellChooseByQuality.white = false
   -- EquipSellChooseByQuality.blue = false
   -- EquipSellChooseByQuality.green = false
    if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	   	ccui.Helper:seekWidgetByName(self.roots[1], "Image_15"):setVisible(EquipSellChooseByQuality.green)
	   	self.green = EquipSellChooseByQuality.green

	    ccui.Helper:seekWidgetByName(self.roots[1], "Image_17"):setVisible(EquipSellChooseByQuality.blue)
	   	self.blue = EquipSellChooseByQuality.blue

	    ccui.Helper:seekWidgetByName(self.roots[1], "Image_19"):setVisible(EquipSellChooseByQuality.white)
	   	self.white = EquipSellChooseByQuality.white
	elseif __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
	   	ccui.Helper:seekWidgetByName(self.roots[1], "Image_15"):setVisible(EquipSellChooseByQuality.green)
	   	self.green = EquipSellChooseByQuality.green

	    ccui.Helper:seekWidgetByName(self.roots[1], "Image_17"):setVisible(EquipSellChooseByQuality.blue)
	   	self.blue = EquipSellChooseByQuality.blue
	end
end


function EquipSellChooseByQuality:init(sorts)
	self.sort = sorts
end

function EquipSellChooseByQuality:onExit()
	state_machine.remove("equip_sell_choose_by_quality_return_back")
	state_machine.remove("equip_sell_choose_sure")
    state_machine.remove("equip_sell_choose_white")
	state_machine.remove("equip_sell_choose_green")
	state_machine.remove("equip_sell_choose_blue")
end
