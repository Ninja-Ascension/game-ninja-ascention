-- ----------------------------------------------------------------------------------------------------
-- 说明：英雄副本-地图-英雄层-
-- 创建时间：2015-10-06
-- 作者：杨晗
-- 修改记录：界面呈现 功能实现
-------------------------------------------------------------------------------------------------------

LPVEMapGeneralCell = class("LPVEMapGeneralCellClass", Window)
    
function LPVEMapGeneralCell:ctor()
    self.super:ctor()
    self.roots = {}
	
	self.npcid = 0
	self.npcStates = 0
	self.index = 0
    -- Initialize ReviewOpponentInfoSeatCell page state machine.
    local function init_lpvemap_general_cell_terminal()
	
		-- local arena_back_activity_terminal = {
            -- _name = "arena_back_activity",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params) 
                
				-- fwin:open(Campaign:new(), fwin._view)
				-- fwin:close(instance)

                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- state_machine.add(arena_back_activity_terminal)
        -- state_machine.add(arena_back_activity_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_lpvemap_general_cell_terminal()
end

function LPVEMapGeneralCell:initDraw()
	local root = self.roots[1]
	local npcid = self.npcid -- npc id 
	local npcStates = self.npcStates -- npc state
	local index = self.index -- npc index
	
	local Panel_yx_gx = ccui.Helper:seekWidgetByName(root, "Panel_yx_gx")--光效
	local Panel_yx_qipao = ccui.Helper:seekWidgetByName(root, "Panel_yx_qipao")--气泡
	local Text_yx_pve_name = ccui.Helper:seekWidgetByName(root, "Text_yx_pve_name")--英雄名字
	
	if npcStates == 1 then
	   Panel_yx_gx:setVisible(true)
	else
	   Panel_yx_gx:setVisible(false)
	end
	Panel_yx_qipao:setVisible(false)--不要气泡
	local npcname = dms.string(dms["npc"], npcid, npc.npc_name)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local name_info = ""
        local name_data = zstring.split(npcname, "|")
        for i, v in pairs(name_data) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            name_info = name_info..word_info[3]
        end
        npcname = name_info
    end
	--print(npcid,npcStates,npcname)
	Text_yx_pve_name:setString(npcname)
	Text_yx_pve_name:setVisible(true)
	
	if index == 1 then
		Text_yx_pve_name:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3])) -- 绿
	elseif index == 2 then
		Text_yx_pve_name:setColor(cc.c3b(color_Type[3][1], color_Type[3][2], color_Type[3][3])) -- 蓝
	elseif index == 3 then
		Text_yx_pve_name:setColor(cc.c3b(color_Type[4][1], color_Type[4][2], color_Type[4][3])) -- 紫
	elseif index == 4 then
		Text_yx_pve_name:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3])) -- 橙
	end
end

function LPVEMapGeneralCell:onEnterTransitionFinish()
	
    local csbLPVEMapGeneralCell = csb.createNode("duplicate/pve_duplicate_yx_gx.csb")
	local root = csbLPVEMapGeneralCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)
	
	local action = csb.createTimeline("duplicate/pve_duplicate_yx_gx.csb") 
    self:runAction(action)
	action:play("qipao",true)
	
	self:initDraw()
end

function LPVEMapGeneralCell:init(_npcid,_npcStates,_index)
	self.npcid = _npcid
	self.npcStates = _npcStates
	self.index = _index
end

function LPVEMapGeneralCell:createCell()
    local effect_paths = "images/ui/effice/effice_ui_npc_2/effice_ui_npc_2.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)		
	local cell = LPVEMapGeneralCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function LPVEMapGeneralCell:onExit()

end
