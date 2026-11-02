-- ----------------------------------------------------------------------------------------------------
-- 说明：出击顶部用户初略信息
-- 创建时间
-- 作者：胡文轩
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
UserInformationForDuplicate = class("UserInformationForDuplicateClass", Window, true)
    
function UserInformationForDuplicate:ctor()
    self.super:ctor()
	self.roots = {}
	self.userSilver = _ED.user_info.user_silver
	self.userGold = _ED.user_info.user_gold
	self.userFood = _ED.user_info.user_food
	self.maxUserFood=_ED.user_info.max_user_food
	self.userGrade= _ED.user_info.user_grade
	self.userExperience= _ED.user_info.user_experience
	self.userGradeNeedNxperience= _ED.user_info.user_grade_need_experience

	self._pveGold = nil
	self._pveSycee = nil
	self._pvePhysical = nil
	self._level = nil
	self._loadingBar = nil
	
	app.load("client.player.PlayerInfomation")
    -- Initialize EquipPlayerInfomation page state machine.
    local function init_user_information_for_duplicate_terminal()
        local equip_player_infomation_button_terminal = {
            _name = "equip_player_infomation_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				
				fwin:open(PlayerInfomation:new(),fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(equip_player_infomation_button_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_user_information_for_duplicate_terminal()
	
end

function UserInformationForDuplicate:onUpdateDraw()
	-- 在这里完成对副本界面中用户基础信息的绘制
	local root = self.roots[1]
	
	local _pveGold = ccui.Helper:seekWidgetByName(root, "Label_529_1")
	local _pveSycee = ccui.Helper:seekWidgetByName(root, "Label_528_1")
	local _pvePhysical = ccui.Helper:seekWidgetByName(root, "Label_55831")
	local level = ccui.Helper:seekWidgetByName(root, "Label_528_2") 
	local loadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_exp")

	self._pveGold = _pveGold
	self._pveSycee = _pveSycee
	self._pvePhysical = _pvePhysical
	self._level = level
	self._loadingBar = loadingBar
	
	_pveGold:setString(self.userSilver)										--银币
	_pveSycee:setString(self.userGold)										--元宝
	
	if tonumber( self.userFood) > 10000  then
		_pvePhysical:setString(math.floor(self.userFood/1000)..string_equiprety_name[40] .."/"..self.maxUserFood)
	else
		_pvePhysical:setString(self.userFood.."/"..self.maxUserFood)	--体力
	end

	if verifySupportLanguage(_lua_release_language_en) == true then
		level:setString(_string_piece_info[6]..self.userGrade)
	else
		level:setString(self.userGrade.._string_piece_info[6])					--等级
	end
	loadingBar:setPercent((self.userExperience/self.userGradeNeedNxperience) *100)	--经验条
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_bar_top"), nil, {func_string = [[state_machine.excute("equip_player_infomation_button", 0, "equip_player_infomation_button.'")]]}, nil, 0)
end

function UserInformationForDuplicate:onEnterTransitionFinish()
	local csbInformation = csb.createNode("utils/public_information_2.csb")
	local root = csbInformation:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbInformation)
	self:onUpdateDraw()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_zuanshi_add"), nil, 
	    {
	        terminal_name = "activity_home_recharge_button", 
	        terminal_state = 0, 
	        touch_black = true,
	    }, nil, 0)
	    app.load("client.utils.SmBuySilverCoins")
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_jinbi_add"), nil, 
	    {
	        terminal_name = "sm_buy_silver_coinsopen", 
	        terminal_state = 0, 
	        touch_black = true,
	    }, nil, 0)
	    app.load("client.utils.SmBuyPhysical")
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tili_add"), nil, 
	    {
	        terminal_name = "sm_buy_physicalopen", 
	        terminal_state = 0, 
	        touch_black = true,
	    }, nil, 0)
	end
end

function UserInformationForDuplicate:onExit()

end

function UserInformationForDuplicate:onUpdate(dt)
	if self.roots == nil or self.roots[1] == nil then
		return
	end
	if self.userSilver ~= _ED.user_info.user_silver then
		self.userSilver = _ED.user_info.user_silver
		self._pveGold:setString(self.userSilver)
	end
	
	if self.userGold ~= _ED.user_info.user_gold then
		self.userGold = _ED.user_info.user_gold
		self._pveSycee:setString(self.userGold)
	end
	
	if self.userFood ~= _ED.user_info.user_food then
		self.userFood = _ED.user_info.user_food
		if tonumber( self.userFood) > 10000  then
			self._pvePhysical:setString(math.floor(self.userFood/1000)..string_equiprety_name[40] .."/"..self.maxUserFood)
		else
			self._pvePhysical:setString(self.userFood.."/"..self.maxUserFood)	--体力
		end
	end
	
	if self.maxUserFood ~= _ED.user_info.max_user_food then
		self.maxUserFood = _ED.user_info.max_user_food
		if tonumber( self.userFood) > 10000  then
			self._pvePhysical:setString(math.floor(self.userFood/1000)..string_equiprety_name[40] .."/"..self.maxUserFood)
		else
			self._pvePhysical:setString(self.userFood.."/"..self.maxUserFood)	--体力
		end
	end
	
	if self.userGrade ~= _ED.user_info.user_grade then
		self.userGrade = _ED.user_info.user_grade
		self._level:setString(self.userGrade)
	end
	
	if self.userExperience ~= _ED.user_info.user_experience then
		self.userExperience = _ED.user_info.user_experience
		self._loadingBar:setPercent(self.userExperience /self.userGradeNeedNxperience * 100)
	end
	
	if self.userGradeNeedNxperience ~= _ED.user_info.user_grade_need_experience then
		self.userGradeNeedNxperience = _ED.user_info.user_grade_need_experience
		self._loadingBar:setPercent(self.userExperience /self.userGradeNeedNxperience * 100)
	end
	
end
