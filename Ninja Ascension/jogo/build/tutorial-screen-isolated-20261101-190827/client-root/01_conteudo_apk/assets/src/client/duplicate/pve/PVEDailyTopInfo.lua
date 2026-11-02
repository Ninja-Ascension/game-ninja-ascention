-- ----------------------------------------------------------------------------------------------------
-- 说明：日常顶部用户信息
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
PVEDailyTopInfo = class("PVEDailyTopInfoClass", Window, true)

local pve_daily_top_info_open_terminal = {
    _name = "pve_daily_top_info_open",
    _init = function (terminal) 
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
		local cell = PVEDailyTopInfo:new()
		cell:init()
		fwin:open(cell,fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(pve_daily_top_info_open_terminal)
state_machine.init()
function PVEDailyTopInfo:ctor()
    self.super:ctor()
	self.roots = {}
	self.user_food 		= 0			--当前体力
	self.max_user_food 	= 0	--体力上限
	self.user_silver = 0
	self.user_gold = 0
	self.user_grade = 0

	self._Text_15 = nil
	self._Text_15_0 = nil
	self._Text_15_0_0 = nil
	
    local function init_user_topinfo_a_terminal()
		-- 用户信息显示
		local pve_daily_top_info_show_terminal = {
            _name = "pve_daily_top_info_show",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local pve_daily_top_info_hide_terminal = {
            _name = "pve_daily_top_info_hide",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_daily_top_info_close_terminal = {
            _name = "pve_daily_top_info_close",
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
		state_machine.add(pve_daily_top_info_show_terminal)
		state_machine.add(pve_daily_top_info_hide_terminal)
		state_machine.add(pve_daily_top_info_close_terminal)
        state_machine.init()
    end
    
    init_user_topinfo_a_terminal()
end

function PVEDailyTopInfo:onInit()
	local csb_public_information = csb.createNode("duplicate/pve_duplicate_richang.csb")
	local root = csb_public_information:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csb_public_information)
	
	self.user_food 		= _ED.user_info.user_food or 0			--当前体力
	self.max_user_food 	= _ED.user_info.max_user_food or 0	--体力上限
	self.user_silver = _ED.user_info.user_silver
	self.user_gold = _ED.user_info.user_gold
	
	local Text_15 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_15")
	local Text_15_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_15_0")
	local Text_15_0_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_15_0_0")

	self._Text_15 = Text_15
	self._Text_15_0 = Text_15_0
	self._Text_15_0_0 = Text_15_0_0
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		self.max_user_food = dms.int(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.combatFoodCapacity)
	end
	if tonumber( self.user_food ) > 10000  then
		Text_15:setString(math.floor(self.user_food /1000)..string_equiprety_name[40] .."/"..self.max_user_food)
	else
		Text_15:setString(self.user_food  .. "/" ..self.max_user_food)
	end

	-- if tonumber( self.user_silver) > 100000000 then
	-- 	Text_15_0:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
	-- else
	if tonumber( self.user_silver)> 10000 then
		Text_15_0:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
	else
		Text_15_0:setString(self.user_silver)
	end

	-- if tonumber(self.user_gold) > 100000000 then
	-- 	Text_15_0_0:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
	-- else
	if tonumber( self.user_gold)> 1000000 then
		Text_15_0_0:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
	else
		Text_15_0_0:setString(self.user_gold)
	end
	
end

function PVEDailyTopInfo:onUpdate(dt)
	if self.roots == nil or self.roots[1] == nil then
		return
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		if self.user_grade ~= _ED.user_info.user_grade then
			self.user_grade = _ED.user_info.user_grade
			self.max_user_food = dms.int(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.combatFoodCapacity)
		end
	end
	
	if self.user_food ~= _ED.user_info.user_food then
		self.user_food = _ED.user_info.user_food
		if tonumber( self.user_food ) > 10000  then
			self._Text_15:setString(math.floor(self.user_food /1000)..string_equiprety_name[40] .."/"..self.max_user_food)
		else
			self._Text_15:setString(self.user_food  .. "/" ..self.max_user_food)
		end
	end
	
	if self.user_silver ~= _ED.user_info.user_silver then
		self.user_silver = _ED.user_info.user_silver
		-- if tonumber( self.user_silver) > 100000000 then
		-- 	self._Text_15_0:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
		-- else
		if tonumber( self.user_silver)> 10000 then
			self._Text_15_0:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
		else
			self._Text_15_0:setString(self.user_silver)
		end
	end
	
	if self.user_gold ~= _ED.user_info.user_gold then
		self.user_gold = _ED.user_info.user_gold
		-- if tonumber(self.user_gold) > 100000000 then
		-- 	self._Text_15_0_0:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
		-- else
		if tonumber( self.user_gold)> 1000000 then
			self._Text_15_0_0:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
		else
			self._Text_15_0_0:setString(self.user_gold)
		end
	end
	
end
function PVEDailyTopInfo:init()
	self:onInit()
end
function PVEDailyTopInfo:onExit()
	state_machine.remove("pve_daily_top_info_show")
	state_machine.remove("pve_daily_top_info_hide")
	state_machine.remove("pve_daily_top_info_close")
end