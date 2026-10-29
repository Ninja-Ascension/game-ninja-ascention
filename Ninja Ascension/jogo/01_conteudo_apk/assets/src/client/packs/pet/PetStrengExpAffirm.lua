-- ----------------------------------------------------------------------------------------------------
-- 说明：宠物强化经验溢出去人框
-------------------------------------------------------------------------------------------------------

PetStrengExpAffirm = class("PetStrengExpAffirmClass", Window)
   
local pet_streng_exp_affirm_window_open_terminal = {
    _name = "pet_streng_exp_affirm_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("PetStrengExpAffirmClass") then
        	local props = params[1]
        	local needExp = params[2]
        	local getExp = params[3]
        	local shipId = params[4]
        	local affirmWindow = PetStrengExpAffirm:new()
			affirmWindow:init(props,needExp,getExp,shipId)
			fwin:open(affirmWindow, fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local pet_streng_exp_affirm_window_close_terminal = {
    _name = "pet_streng_exp_affirm_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PetStrengExpAffirmClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pet_streng_exp_affirm_window_open_terminal)
state_machine.add(pet_streng_exp_affirm_window_close_terminal)
state_machine.init()
  
function PetStrengExpAffirm:ctor()
    self.super:ctor()
	self.roots = {}
	
	self._props = nil  -- 强化消耗道具
	self._shipId = 0 -- 英雄实例ID
	self._need_exp = 0 -- 需要经验
	self._get_exp = 0 -- 得到经验
    -- Initialize Home page state machine.
    local function init_pet_streng_exp_affirm_terminal()
        --确定升级
        local pet_streng_exp_affirm_streng_terminal = {
            _name = "pet_streng_exp_affirm_streng",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local datas = params._datas
                local parent = datas._self
                local function responseSellHeroCallback(response)
					_ED.baseFightingCount = calcTotalFormationFight() 
					_ED.up_streng_reduce_ship = nil
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						pushEffect(formatMusicFile("effect", 9988))
					
						if response.node == nil or response.node.roots == nil then
							return
						end
						state_machine.excute("pet_strengthen_page_streng_succeed_update", 0, response.node._shipId)
							
						--上层列表项中武将信息刷新
						state_machine.excute("pet_list_view_update_cell", 0, response.node._shipId)
						state_machine.excute("pet_develop_update_pet", 0, response.node._shipId)

						--更新用户银币信息
						state_machine.excute("user_info_hero_storage_update", 0, "user_info_hero_storage_update.")
						
						--移除材料
						state_machine.excute("pet_strengthen_page_clean", 0, "pet_strengthen_page_clean.")
						
						--更新面板
						state_machine.excute("pet_strengthen_page_check_exp", 0, params)
						state_machine.excute("pet_star_up_page_check_update_by_other_page", 0, 0)
						--阵营刷新
						local formatinWindow = fwin:find("FormationClass")
						if formatinWindow ~= nil then 
							state_machine.excute("formation_pet_update_data",0,0)
						end
						fwin:close(fwin:find("PetStrengExpAffirmClass"))
					end
				end
				local AllExp = 0			--可获总经验
				local yellowCount = 0
				local purpleCount = 0
				local blueCount = 0 
				local greenCount = 0 
				for i,v in pairs(parent._props) do
					if v ~= nil and v ~= "" then 
						local prop_quality = dms.int(dms["prop_mould"],v.user_prop_template,prop_mould.prop_quality)
						if prop_quality == 4 then 
							yellowCount = yellowCount + 1
						elseif prop_quality == 3 then 
							purpleCount = purpleCount + 1
						elseif prop_quality == 2 then 
							blueCount = blueCount + 1
						elseif prop_quality == 1 then 
							greenCount = greenCount + 1
						end
					end
				end
				protocol_command.pet_escalate.param_list = ""..parent._shipId.."\r\n"..yellowCount.."\r\n" .. purpleCount.. "\r\n".. blueCount.."\r\n".. greenCount
				NetworkManager:register(protocol_command.pet_escalate.code, nil, nil, nil, parent, responseSellHeroCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(pet_streng_exp_affirm_streng_terminal)
        state_machine.init()
    end
    
    init_pet_streng_exp_affirm_terminal()
end

function PetStrengExpAffirm:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	--升级所需
	local Text_exp_2 = ccui.Helper:seekWidgetByName(root, "Text_exp_2")
	Text_exp_2:setString(""..self._need_exp)

	--当前得到经验
	local Text_exp_4 = ccui.Helper:seekWidgetByName(root, "Text_exp_4")
	Text_exp_4:setString(""..self._get_exp)
end

function PetStrengExpAffirm:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("packs/PetStorage/PetStorage_qianghua_prompt.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)

	self:onUpdateDraw()
	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_103_2"), nil, 
	{
		func_string = [[fwin:close(fwin:find("PetStrengExpAffirmClass"))]],   
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)	
	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_103_0_4"), nil, 
	{
		terminal_name = "pet_streng_exp_affirm_streng", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)	
	
end

function PetStrengExpAffirm:onExit()
	state_machine.remove("pet_streng_exp_affirm_streng")
end

function PetStrengExpAffirm:init(props,needExp,getExp,shipId)
	self._props = props
	self._need_exp = needExp
	self._get_exp = getExp
	self._shipId = shipId
end
