-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE主线副本NPC二级战斗准备界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

PveScene = class("PveSceneClass", Window)
    

function PveScene:ctor()
    self.super:ctor()
    self.roots = {}

	
    -- Initialize GameElite page state machine.
	local function init_pve_scene_npc ()
		--点击关卡信息框
		local game_elite_show_level_terminal = {
            _name = "game_elite_show_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
					--> print("***********************************")
					app.load("client.duplicate.elite.PveTwoScene")
					fwin:open(PveTwoScene:new(), fwin._windows)
					--> print("/////////////")
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(game_elite_show_level_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
	init_pve_scene_npc()
end




function PveScene:onEnterTransitionFinish()
	table.insert(self.roots, root)
	local csbPveMap = csb.createNode("duplicate/pve_map_1.csb")
	csbPveMap:setTag(9000)
	self:addChild(csbPveMap)
	local PveMapRoot 	= csbPveMap:getChildByName("root")
	local npcLength1 = 1
	local intIndex = dms.string(dms["pve_scene"],npcLength1,pve_scene.scene_id)     --得到场景ID
	
	local SceneNpcMunber = dms.string(dms["pve_scene"],intIndex,pve_scene.npcs)		--得到场景记录NPC编号
	local SceneNpcMax = zstring.split(SceneNpcMunber,",")							--分拆字符串

	local npcLength = table.getn(SceneNpcMax)										--取表的长度
	for i=1,npcLength do
		local mNpcName = dms.string(dms["npc"], i, npc.npc_name)   					--npc名字
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        local name_info = ""
	        local name_data = zstring.split(mNpcName, "|")
	        for i, v in pairs(name_data) do
	            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
	            name_info = name_info..word_info[3]
	        end
	        mNpcName = name_info
	    end
		local mHeadPic = dms.string(dms["npc"], i, npc.head_pic)   					--npc图像索引
		local home_button = ccui.Helper:seekWidgetByName(PveMapRoot,string.format("Panel_coordinate_%d", i))
		local csbDuplicateList = csb.createNode("card/card_role.csb")
		local root = csbDuplicateList:getChildByName("root")
		local PanelCard = ccui.Helper:seekWidgetByName(root, "Panel_role")
		local NPCName = ccui.Helper:seekWidgetByName(root, "Text_pve_name")
		NPCName:setString(mNpcName)
		local headPic = string.format("images/face/card_head/props_%s.png",mHeadPic)
		PanelCard:setBackGroundImage(headPic)
		PanelCard:setTouchEnabled(false)
		PanelCard:setSwallowTouches(false)
		home_button:addChild(csbDuplicateList)
		home_button:setTouchEnabled(true)
		fwin:addTouchEventListener(home_button, nil, {func_string = [[state_machine.excute("game_elite_show_level", 0, "click game_elite_show_level.'")]], 
									isPressedActionEnabled = true}, nil, 0)
	end
	-- TODO   副本的宝箱绘制以及副本星数的排行榜  NPC头顶的星星条件开启判断   个人信息的类
end


function PveScene:onExit()
	state_machine.remove("game_elite_show_level")
end
