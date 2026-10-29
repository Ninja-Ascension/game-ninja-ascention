-- ----------------------------------------------------------------------------------------------------
-- 说明：名将首胜 界面
-- 创建时间	
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

PVEChallengeFamousFistReward = class("PVEChallengeFamousFistRewardClass", Window)
    
function PVEChallengeFamousFistReward:ctor()
    self.super:ctor()
	app.load("client.cells.prop.prop_money_icon")
    self.roots = {}
	self.rebelArmyMouldId = nil
    -- Initialize PVEChallengeFamousFistReward page state machine.
    local function init_terminal()
		
		local pve_challenge_famous_fist_reward_close_terminal = {
            _name = "pve_challenge_famous_fist_reward_close",
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

		state_machine.add(pve_challenge_famous_fist_reward_close_terminal)
		
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_terminal()
end
function PVEChallengeFamousFistReward:onUpdateDraw()
	local root = self.roots[1]
	local textName = ccui.Helper:seekWidgetByName(root, "Text_1320")
	local panelNPC = ccui.Helper:seekWidgetByName(root, "Panel_63")
	
	local npcText = ccui.Helper:seekWidgetByName(root, "Text_61")
	
	local panelGoods = ccui.Helper:seekWidgetByName(root, "Panel_64")
	local textGoods  = ccui.Helper:seekWidgetByName(root, "Text_1")

	--npc名字和品质
	local npc_name = dms.string(dms["npc"], self.npcid, npc.npc_name)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local name_info = ""
        local name_data = zstring.split(npc_name, "|")
        for i, v in pairs(name_data) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            name_info = name_info..word_info[3]
        end
        npc_name = name_info
    end
	local npcIconIndex = dms.int(dms["npc"], self.npcid, npc.head_pic) -1000
	--local npcHead = string.format("images/face/card_head/card_head_%d.png", npcIconIndex)
	--local npcIcon = string.format("images/face/big_head/big_head_%d.png", npcHeadPic)
	
	local quality = dms.int(dms["npc"], self.npcid, npc.base_pic) +1
	local npcNameColor = cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3])

	textName:setString(npc_name)
	textName:setColor(npcNameColor)	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	 	npcIconIndex = dms.int(dms["npc"], self.npcid, npc.head_pic)
		local temp_bust_index = npcIconIndex
		local shipPanel = panelNPC
		shipPanel:removeAllChildren(true)
		draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), shipPanel, nil, nil, cc.p(0.5, 0))
		if animationMode == 1 then
			app.load("client.battle.fight.FightEnum")
			local shipSpine = sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        shipSpine:setScaleX(-1)
		    end
		else
			draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", shipPanel, -1, nil, nil, cc.p(0.5, 0))
		end
	else
		local npcIcon = ""
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			npcIcon = string.format("images/face/big_head/big_head_%d.png", npcIconIndex)
		else
			npcIcon = string.format("images/face/card_head/card_head_%d.png", npcIconIndex)
		end
		
		panelNPC:setBackGroundImage(npcIcon)
	end
	npcText:setString(_string_piece_info[362])
	
	-- 奖励
	local cell = propMoneyIcon:createCell()
	cell:init("2",0,nil)
	panelGoods:addChild(cell)
	textGoods:setString(self.gnum..reward_prop_list[2])
end


function PVEChallengeFamousFistReward:onEnterTransitionFinish()
	
	local csbPVEChallengeFamousFistReward = csb.createNode("duplicate/pve_reward_1.csb")	
	self:addChild(csbPVEChallengeFamousFistReward)
	local root = csbPVEChallengeFamousFistReward:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_5"), nil, 
	{
		terminal_name = "pve_challenge_famous_fist_reward_close", 
		terminal_state = 0, 
	}, 
	nil, 0)
end


function PVEChallengeFamousFistReward:init(npcid, gnum)
	self.npcid 	=  npcid
	self.gnum 	=  gnum
end
function PVEChallengeFamousFistReward:createCell()
	local cell = PVEChallengeFamousFistReward:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
function PVEChallengeFamousFistReward:onExit()
	state_machine.remove("pve_challenge_famous_fist_reward_close")
end
