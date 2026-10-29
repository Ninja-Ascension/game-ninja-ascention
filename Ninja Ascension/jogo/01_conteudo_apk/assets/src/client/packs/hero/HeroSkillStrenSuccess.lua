-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将天命升级界面
-------------------------------------------------------------------------------------------------------
HeroSkillStrenSuccess = class("HeroSkillStrenSuccessClass", Window)

function HeroSkillStrenSuccess:ctor()
    self.super:ctor()
	self.roots = {}
	self.shipId = 0        --当前武将Id
	self.ship = nil
	self.times = nil
	self.startTime = nil
	self.status = true
    local function init_hero_skill_stren_success_terminal()
		--强化
		local hero_skill_stren_success_close_terminal = {
            _name = "hero_skill_stren_success_close",
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
        state_machine.init()
		state_machine.add(hero_skill_stren_success_close_terminal)	
    end
    init_hero_skill_stren_success_terminal()
end



function HeroSkillStrenSuccess:onUpdateDraw()
	local root = self.roots[1]
	self.ship = fundShipWidthId(self.shipId)
		-- UI 获取
	local Panel_10 = ccui.Helper:seekWidgetByName(root, "Panel_25")
	local Text_77 = ccui.Helper:seekWidgetByName(root, "Text_277")
	
	-- 武将全身像
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local shipCell = LformationChangeHeroCell:createCell()
		shipCell:init(_ED.user_ship[""..self.shipId])
		Panel_10:removeAllChildren(true)
		Panel_10:addChild(shipCell)
	else
		local shipCell = ShipBodyCell:createCell()
		shipCell:init(self.ship, 0)
		Panel_10:addChild(shipCell)
	end
	Text_77:setString(_ED.hero_skillstren_info.level)
	
	local one = ccui.Helper:seekWidgetByName(root, "Text_63_1")
	local two= ccui.Helper:seekWidgetByName(root, "Text_63_2")
	local three = ccui.Helper:seekWidgetByName(root, "Text_63_3")
	local four = ccui.Helper:seekWidgetByName(root, "Text_63_4")
	local nextOne = ccui.Helper:seekWidgetByName(root, "Text_71_1")
	local nextTwo= ccui.Helper:seekWidgetByName(root, "Text_71_2")
	local nextThree = ccui.Helper:seekWidgetByName(root, "Text_71_3")
	local nextFour = ccui.Helper:seekWidgetByName(root, "Text_71_4")
	
	
	local id = tonumber(_ED.hero_skillstren_info.level)
	local addition_percent_life = zstring.tonumber(dms.int(dms["destiny_property_param"], id-1, destiny_property_param.addition_percent_life))
	local addition_percent_attack = zstring.tonumber(dms.int(dms["destiny_property_param"], id-1, destiny_property_param.addition_percent_attack))
	local addition_percent_physical_defence = zstring.tonumber(dms.int(dms["destiny_property_param"], id-1, destiny_property_param.addition_percent_physical_defence))
	local addition_percent_skill_defence = zstring.tonumber(dms.int(dms["destiny_property_param"], id-1, destiny_property_param.addition_percent_skill_defence))
	one:setString("+" .. addition_percent_attack/100 .. "%")
	two:setString("+" .. addition_percent_life/100 .. "%")
	three:setString("+" .. addition_percent_physical_defence/100 .. "%")
	four:setString("+" .. addition_percent_skill_defence/100 .. "%")
	
	local addition_percent_lifes = dms.int(dms["destiny_property_param"], id, destiny_property_param.addition_percent_life)
	local addition_percent_attacks = dms.int(dms["destiny_property_param"], id, destiny_property_param.addition_percent_attack)
	local addition_percent_physical_defences = dms.int(dms["destiny_property_param"], id, destiny_property_param.addition_percent_physical_defence)
	local addition_percent_skill_defences = dms.int(dms["destiny_property_param"], id, destiny_property_param.addition_percent_skill_defence)
	
	nextOne:setString("+" .. addition_percent_attacks/100 .. "%")
	nextTwo:setString("+" .. addition_percent_lifes/100 .. "%")
	nextThree:setString("+" .. addition_percent_physical_defences/100 .. "%")
	nextFour:setString("+" .. addition_percent_skill_defences/100 .. "%")
	local hero_data = dms.element(dms["ship_mould"], self.ship.ship_template_id)
	local skillInfos = zstring.split(dms.atos(hero_data, ship_mould.skill_mould_info),",")
	local nextSkillId = skillInfos[tonumber(_ED.hero_skillstren_info.level)]

	local skillNamesOne = dms.string(dms["skill_mould"], nextSkillId, skill_mould.skill_name)
	local name_table = zstring.split(skillNamesOne,"L")
	ccui.Helper:seekWidgetByName(root, "Text_57_0_1"):setString(name_table[1])
	
	if verifySupportLanguage(_lua_release_language_en) == true then
		ccui.Helper:seekWidgetByName(root, "Text_63_5"):setString(_string_piece_info[6]..(id-1))
		ccui.Helper:seekWidgetByName(root, "Text_71_5"):setString(_string_piece_info[6]..(id))
	else
		ccui.Helper:seekWidgetByName(root, "Text_63_5"):setString((id-1) .. _string_piece_info[6])
		ccui.Helper:seekWidgetByName(root, "Text_71_5"):setString((id) .. _string_piece_info[6])
	end
	
	local zoariumSkill = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.zoarium_skill)
	local temp = nil
	local ser = 0
	local inPreson = {}
	local num = 1
	local step1 = false
	if zoariumSkill ~= nil and zoariumSkill > 0 then
		
		--画是否有合击
		for i,v in pairs(_ED.user_ship) do
			if zstring.tonumber(v.formation_index) > 0 then
				inPreson[num] = v.ship_base_template_id
				num = num + 1
				if tonumber(v.ship_id) == tonumber(self.shipId) then
					step1 = true
				end
			end
		end
		
	
		local person_s = dms.string(dms["skill_mould"], zoariumSkill, skill_mould.release_mould)
		if person_s ~= nil then
			local step_s = zstring.split(person_s,",")
			local number = table.getn(step_s)
			for j,n in pairs(step_s) do
				for i, v in pairs(inPreson) do
					if tonumber(n) == tonumber(v) then
						ser = ser + 1
						break
					end
				end
			end
			if ser > 0 and number > 0 and ser == number and step1 == true then
				local count = 0
				local nextSkillId = zoariumSkill
				local maxSkillLevel = tonumber(dms.string(dms["pirates_config"],276,pirates_config.param))
				for i=1,maxSkillLevel do
					count = count + 1
					if tonumber(_ED.hero_skillstren_info.level) == count then 
						break
					end
					if zoariumSkill == nil then 
						break
					end
					local id = dms.int(dms["skill_mould"],nextSkillId,skill_mould.next_level_skill)
					nextSkillId = id
				end

				if nextSkillId >= 0 then
					local skillName = dms.string(dms["skill_mould"], nextSkillId, skill_mould.skill_name)
					ccui.Helper:seekWidgetByName(root, "Panel_4"):setVisible(true)
					ccui.Helper:seekWidgetByName(root, "Text_57_0_2"):setString(skillName)
					ccui.Helper:seekWidgetByName(root, "Text_63_6"):setString(id-1)
					ccui.Helper:seekWidgetByName(root, "Text_71_6"):setString(id)
				end
			end
		end
		
	end
	
end

function HeroSkillStrenSuccess:onUpdate(dt)
	local times = math.ceil(os.time() - self.times)
	if times > 0 and self.startTime == times and self.status == true then
		self.status = false
		local csbGeneralsTianming = csb.createNode("packs/HeroStorage/generals_tianming_success.csb")
		local root = csbGeneralsTianming:getChildByName("root")
		root:removeFromParent(true)
		table.insert(self.roots, root)
		self:addChild(root)
		self:onUpdateDraw()
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			local action = csb.createTimeline("packs/HeroStorage/generals_tianming_success.csb")
		    self:runAction(action)
		    action:play("window_open", false)
		    action:setFrameEventCallFunc(function (frame)
		        if nil == frame then
		            return
		        end
		        local str = frame:getEvent()
		        if str == "open" then
		        elseif str == "window_open_over" then
		            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_30"), nil, {func_string = [[state_machine.excute("hero_skill_stren_success_close", 0, "click hero_skill_stren_success_close.'")]]}, nil, 0)

		        end
		        
		    end)
		else
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_30"), nil, {func_string = [[state_machine.excute("hero_skill_stren_success_close", 0, "click hero_skill_stren_success_close.'")]]}, nil, 0)
		end
	end
end

function HeroSkillStrenSuccess:onEnterTransitionFinish()
	self.times = os.time()
	self.startTime = math.ceil(os.time() - self.times) + 1
	
end
function HeroSkillStrenSuccess:close()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if fwin:find("HeroSkillStrenPageClass") ~= nil then
			fwin:find("HeroSkillStrenPageClass").levelup = false
		end
	end
end
function HeroSkillStrenSuccess:onExit()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		fwin:find("HeroSkillStrenPageClass").levelup = false
	end
	state_machine.remove("hero_skill_stren_success_close")

end

function HeroSkillStrenSuccess:init(shipId)
	self.shipId = shipId
end