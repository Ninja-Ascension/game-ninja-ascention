----------------------------------------------------------------------------------------------------
-- 说明：角色呼吸动画
-- 创建时间
-- 作者
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MineAttackTerritoryRole = class("MineAttackTerritoryRoleClass", Window)
    
function MineAttackTerritoryRole:ctor()
    self.super:ctor()

	app.load("client.campaign.mine.MineAttackTerritoryRoleBiaoQing")
	app.load("client.campaign.mine.MineAttackTerritoryRoleQiPao")

    self.roots = {}
    self.show_type = nil --关卡中显示
    self.base_pic = 0 --背景底框
	
	--state_machine.excute("mine_manager_manor_patrol_dialogue", 0, {index = self.index, cell = self.cell}) 
	 local function init_mine_manager_patrol_terminal()
		
		local mine_manager_manor_patrol_dialogue_terminal = {
            _name = "mine_manager_manor_patrol_dialogue",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params.cell
				if nil ~= cell then
					cell:startNPCDialogue()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(mine_manager_manor_patrol_dialogue_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
   init_mine_manager_patrol_terminal()
end



function MineAttackTerritoryRole:onUpdateDraw()
	local root = self.roots[1]

	local npcPanel = ccui.Helper:seekWidgetByName(root, "Panel_role_20")
	
	if nil ~= npcPanel and nil ~= self.iconIndex then
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_yugioh 
			then
			if self.show_type == 1 then
				if __lua_project_id == __lua_project_pokemon 
					then
					local Panel_donghua = ccui.Helper:seekWidgetByName(root, "Panel_donghua")
					app.load("client.battle.fight.FightEnum")
					Panel_donghua:removeAllChildren(true)
					npcPanel:removeBackGroundImage()
					local atlasFile = string.format("sprite/big_head_%s.atlas", self.iconIndex)
					local jsonFile = string.format("sprite/big_head_%s.json", self.iconIndex)
					if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
						isAddHeadEffect = true
						local spArmature = sp.spine(jsonFile, atlasFile, 1, 0, 
	                		spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)
			            Panel_donghua:addChild(spArmature)
			            spArmature:setPosition(cc.p(Panel_donghua:getContentSize().width/2, 0))
					else
						npcPanel:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", self.iconIndex))
					end
				else
					npcPanel:setBackGroundImage(string.format("images/ui/props/props_%d.png", self.iconIndex +1000))
					local qualityPanel = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
					qualityPanel:removeBackGroundImage()
					qualityPanel:setBackGroundImage(string.format("images/ui/quality/pve_fuben_%d.png", zstring.tonumber(self.base_pic)))
				end
			else
				npcPanel:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", self.iconIndex))
			end
		elseif __lua_project_id == __lua_project_rouge then
			npcPanel:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", self.iconIndex))
		else
			npcPanel:setBackGroundImage(string.format("images/face/card_head/card_head_%d.png", self.iconIndex))
		end
		self._role_action:play("Panel_role_20_ing", true)
	end
end

function MineAttackTerritoryRole:setGrayRole()
	local root = self.roots[1]

	local npcPanel = ccui.Helper:seekWidgetByName(root, "Panel_role_20")
	
	if nil ~= npcPanel and nil ~= self.iconIndex then
		npcPanel:setColor(cc.c3b(50, 50, 50))
	end
end


function MineAttackTerritoryRole:onEnterTransitionFinish()
    local csbMineAttackTerritoryRole = csb.createNode("campaign/MineManager/attack_territory_role.csb")
	local action = csb.createTimeline("campaign/MineManager/attack_territory_role.csb")
    csbMineAttackTerritoryRole:runAction(action)
	self._role_action = action
	self:addChild(csbMineAttackTerritoryRole)
	
   	local root = csbMineAttackTerritoryRole:getChildByName("root")
	table.insert(self.roots, root)
	
	self.panel_qipao = ccui.Helper:seekWidgetByName(root, "Panel_10_qipao")
	
	self.panel_biaoqing = ccui.Helper:seekWidgetByName(root, "Panel_20_biaoqin")
	
	
	self:onUpdateDraw()
end

function MineAttackTerritoryRole:showNPCDialogue(index)
	
	
	
	-- 当前显示的是第几个废话npc
	self.rIndex = index
	
	-- 根据文字内容,判定是气泡还是表情泡
	-- 取出 该npc的可用废话表
	local data = dms["npc_dialogue"]
	local list = {}
	for i = 1 , #data do
		if tonumber(self.npcIconID) == dms.int(dms["npc_dialogue"], i, npc_dialogue.npc) then
			table.insert(list, dms.string(dms["npc_dialogue"], i, npc_dialogue.dialogue))
		end
	end
	
	-- 废话取出完毕
	self.dialogueList = list
	self.dialogueIndex = 1
	
	-- 启动废话
	self:startNPCDialogue()
end


function MineAttackTerritoryRole:startNPCDialogue()

	
	if self.dialogueIndex > table.getn(self.dialogueList) then
		self.dialogueIndex = 1
	end

	local str = self.dialogueList[self.dialogueIndex]
	self.dialogueIndex = self.dialogueIndex +1

	-- 判定类型 决定是气泡还是表情
	local f,e = string.find(str, "/%d+|")
	if nil ~= f and nil ~= e then
		-- 表情
		local id = tonumber(string.sub(str, f+1, e-1))
		self:showBiaoQing(id)
	else
		-- 非表情
		self:showQiPao(str, self.isLeft)
	end
end

-- qipao  
function MineAttackTerritoryRole:showQiPao(str, isLeft)
	self.isLeft = isLeft
	if tonumber(self.dialogueIndex) == nil then
		self.dialogueIndex = 1
	end
	
	if tonumber(self.dialogueList) == nil then
		self.dialogueList = {str}
	end
	
	local qipao = MineAttackTerritoryRoleQiPao:createCell()
	qipao:init(str, self.rIndex, self, isLeft)
	
	self.panel_qipao:removeAllChildren(true)
	self.panel_qipao:addChild(qipao)
end


-- 表情
function MineAttackTerritoryRole:showBiaoQing(id)

	local icon = MineAttackTerritoryRoleBiaoQing:createCell()
	icon:init(id, self.rIndex, self)
	
	self.panel_biaoqing:addChild(icon)
end

function MineAttackTerritoryRole:init(iconIndex)
	self.iconIndex = tonumber(iconIndex)
	
end


function MineAttackTerritoryRole:initNPC(npcIconID,showType)
	self.npcIconID = npcIconID
	self.iconIndex = dms.int(dms["npc"], npcIconID, npc.head_pic) -1000
	self.base_pic = dms.int(dms["npc"], npcIconID, npc.base_pic)
	self.show_type = showType or nil
end

function MineAttackTerritoryRole:initShip(mid)
	self.iconIndex = dms.int(dms["ship_mould"], mid, ship_mould.All_icon)
end

function MineAttackTerritoryRole:onExit()
	--state_machine.remove("mine_manager_manor_patrol_dialogue")
end

function MineAttackTerritoryRole:createCell()
	local cell = MineAttackTerritoryRole:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

