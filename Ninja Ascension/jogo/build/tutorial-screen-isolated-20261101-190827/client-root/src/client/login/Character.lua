-- ----------------------------------------------------------------------------------------------------
-- 说明：角色创建界面的角色Q版绘制
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
Character = class("CharacterClass", Window)

function Character:ctor()
    self.super:ctor()
	self.roots = {}
	
	self.nIndex = -1
	
    local function init_Character_terminal()
		-- local _terminal = {
            -- _name = "",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
			
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- state_machine.add()
	
        -- state_machine.init()
    end
    
    init_Character_terminal()
end

function Character:onUpdateDraw()
	
end

function Character:onEnterTransitionFinish()
	
	
    -- 设置角色
	local headId = -1
	local exportJsonId = -1
	if self.nIndex  == 0 then
		headId = 511
		exportJsonId = 1321
	elseif self.nIndex  == 1 then
		headId = 503
		exportJsonId = 56
	elseif self.nIndex  == 2 then
		headId = 501
		exportJsonId = 1
	elseif self.nIndex  == 3 then
		headId = 513
		exportJsonId = 1376
	end
	
	-- 终极一班没有动画，屏蔽
	if __lua_project_id == __lua_project_koone then
		exportJsonId = 0
	end
	
	local armatureName = "spirte_battle_card"

   if exportJsonId > 0 then
		armatureName = "spirte_battle_card_%s"
		armatureName = string.format(armatureName, exportJsonId)
   end

	local armature = ccs.Armature:create(armatureName)
    armature:getAnimation():playWithIndex(0)
   
    local role_names = {
        "role",
        "role_2",
        "role_3",
        "role_4",
    }
    for i, v in pairs(role_names) do
    	local heroIcon = ""
    	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
    		heroIcon = string.format("images/face/big_head/big_head_%s.png", headId)
    	else
    		heroIcon = string.format("images/face/card_head/card_head_%s.png", headId)
    	end
        
        local roleIcon = ccs.Skin:create(heroIcon)
        armature:getBone(v):addDisplay(roleIcon, 0)
    end
	
	self:addChild(armature)
end

function Character:onExit()
end

function Character:init(_index)
	self.nIndex = _index
end

function Character:createCell()
	local cell = Character:new()
	cell:registerOnNodeEvent(cell)
	return cell
end