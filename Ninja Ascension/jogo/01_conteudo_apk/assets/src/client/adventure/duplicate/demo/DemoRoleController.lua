DemoRoleController = class("DemoRoleControllerClass", Window)

app.load("client.adventure.duplicate.demo.DemoHero")
app.load("client.adventure.duplicate.demo.DemoMonster")
app.load("client.adventure.cells.utils.adventure_dialogue_bubble_cell")

function DemoRoleController:ctor()
    self.super:ctor()
    self.roots = {}
    self.parent = nil
    self.size = nil
    self.roles = {}
    self.monsters = {}
    self.changeRoleInteval = 5
    self.changeRoleElapse = 0
    self.makeMonsterInteval = 3
    self.makeMonsterElapse = 0
    self.heroTeamFront = 0                      -- 英雄队列最前端
    self.attackAreaX = 0                        -- 攻击区域x坐标
    self.monsterDeadAreaX = 0                   -- 怪物死亡区域x坐标
    self.rolesLineY = 50                        -- 角色y坐标
    self.rolesLineX = 50                        -- 角色x坐标
    self.heroGap = 60                           -- 英雄间的间隔
    self.armatureKnifeLight = nil               -- 刀光特效
    self.armatureExpAddLight = nil              -- 经验增加特效
    self.armaturePosition = nil                 -- 特效播放的位置
    self.armatureSilverAddLight = nil           -- 金币增加特效
    self.dialogueInteval = 10                   -- 对话间隔时间
    self.dialogueElapse = 0                     -- 对话进行时间
    self.curTalkData = nil                      -- 当前对话数据
    self.dialogueCount = 0    
    self.dialogueShowInteval = 2                -- 每个废话显示时间 
    self.dialogueShowElapse = 0                 -- 每个废话显示间隔时间   
    self.dialogueTextIndex = 1
    self.dialogueText = {}
    self.dialogueCells = {}
    self.dialogueCellTime = 2
    self.dialogueCellElapse = 0
    self.lastTalkRoleIndex = 0
	self.monsterIndex = 0

    self.selectSceneId = 1
    self.selectNpcId = 1

    self.bust_index_args = {}                   -- 我方形像索引序列
    self.bust_index_args_close = {}             -- 我方形像索引序列
    self.bust_index_args_open = {}              -- 我方形像索引序列


    self.master_bust_index_args = {}                   -- 敌方形像索引序列
    self.master_bust_index_args_close = {}             -- 敌方形像索引序列
    self.master_bust_index_args_open = {}              -- 敌方形像索引序列

    local function init_world_role_controller_terminal()
        local world_role_controller_play_attack_effect_terminal = {
            _name = "world_role_controller_play_attack_effect",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:playAttackEffect()

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --添加需要使用的状态机到状态机管理器去
        state_machine.add(world_role_controller_play_attack_effect_terminal)
        state_machine.init()
    end
    
    init_world_role_controller_terminal()
end

function DemoRoleController:getHeroHead(headId)
    local nCount = #self.bust_index_args_open
    if nCount > 0 then
        local hIdx = math.random(1, nCount)
        local tempHeadId = self.bust_index_args_open[hIdx]
        if tempHeadId ~= nil and tempHeadId ~= headId then
            table.remove(self.bust_index_args_open, hIdx, 1)
            table.insert(self.bust_index_args_close, tempHeadId)
            for i, v in pairs(self.bust_index_args_close) do
                if v == headId then
                    table.remove(self.bust_index_args_close, i, 1)
                    table.insert(self.bust_index_args_open, headId)
                    break
                end
            end
            return tempHeadId
        end
    end
    return headId
end

function DemoRoleController:getMasterHead()
    local nCount = #self.master_bust_index_args_open
    if nCount > 0 then
        local hIdx = math.random(1, nCount)
        local tempHeadId = self.master_bust_index_args_open[hIdx]
        table.remove(self.master_bust_index_args_open, hIdx, 1)
        table.insert(self.master_bust_index_args_close, tempHeadId)
        return tempHeadId
    end
    return nil
end

function DemoRoleController:resetMasterHead(headId)
    for i, v in pairs(self.master_bust_index_args_close) do
        if v == headId then
            table.remove(self.master_bust_index_args_close, i, 1)
            table.insert(self.master_bust_index_args_open, headId)
            break
        end
    end
end

function DemoRoleController:onEnterTransitionFinish()
    -- for i = 1, 5 do
    --     local role = DemoHero:new():init(self, i)
    --     role:setPosition(cc.p(self.heroTeamFront - i*self.heroGap, self.rolesLineY))
    --     self:addChild(role)

    --     table.insert(self.roles, role)
    -- end

    -- 根据我们当前的阵容来创建场景中的角色
    local currentFormationIndex = 1
	local indexsHero = 0
    for i, v in pairs(_ED.formetion) do
       -- print("--测试..DemoRoleController1创建")
        local shipId = zstring.tonumber(v)
        if i > 1 and shipId > 0 then
			local tempY = 0
			local tempX = 0
            local _ship_mould_id = _ED.user_ship["" .. shipId].ship_template_id
            local temp_bust_index = dms.int(dms["ship_mould"], _ship_mould_id, ship_mould.All_icon)
            table.insert(self.bust_index_args, temp_bust_index)
            if i <= 7 then
				indexsHero = indexsHero+1
				if indexsHero == 2 or indexsHero == 3 then
					tempY = 2*self.heroGap - 10
				elseif indexsHero == 4 then
					tempY = 3*self.heroGap - self.heroGap/12 - 20
                elseif indexsHero == 5 or indexsHero == 6 then
                    tempY = 3*self.heroGap - 10
				end
				if indexsHero == 2 then 
                    tempX = self.rolesLineX*1 + self.rolesLineX / 5
                elseif indexsHero == 3 then
                    tempX = -self.rolesLineX * 1 -  self.rolesLineX / 5
                elseif indexsHero == 5 then 
                    tempX = self.rolesLineX * 2 + self.rolesLineX / 5
                elseif indexsHero == 6 then    
                    tempX = -self.rolesLineX * 2  -  self.rolesLineX / 5               
                elseif indexsHero == 4 then    
                    tempX = 0                
                end
				-- if indexsHero == 2 or indexsHero == 5 then
				-- 	tempX = (self.rolesLineX/2)*i--(self.rolesLineX/2)
				-- elseif indexsHero == 3 or indexsHero == 6 then	
				-- 	tempX = -(self.rolesLineX/2)*(i-1)--+(self.rolesLineX/2)

				-- end
				
                local role = DemoHero:new():init(self, i - 1, temp_bust_index)
				if indexsHero == 2 or indexsHero == 3 then
					role:setScale(1.02)
                    role:setShadowScale(1.02)
				elseif indexsHero == 5 or indexsHero == 6 then
					role:setScale(1.12)
                    role:setShadowScale(1.12)
                elseif indexsHero == 4 then 
                    role:setScale(1.06)
                    role:setShadowScale(1.06)
                elseif indexsHero == 1 then 
                    role:setScale(0.95)
                    role:setShadowScale(0.95)
				end
				if indexsHero == 2 or indexsHero == 4 then
					role:setPosition(cc.p(self.heroTeamFront - tempY, self.rolesLineX + tempX))
				elseif indexsHero == 3 or indexsHero == 5 or indexsHero == 6 then	
					role:setPosition(cc.p(self.heroTeamFront - tempY, self.rolesLineX + tempX))
				else
					role:setPosition(cc.p(self.heroTeamFront - (i - 1)*self.heroGap, self.rolesLineX))
				end
                
                self:addChild(role,200)

                table.insert(self.roles, role)
                table.insert(self.bust_index_args_close, temp_bust_index)
            else
                table.insert(self.bust_index_args_open, temp_bust_index)
            end
        end
    end

    -- 初始化NPC头像队列
    local environment_formationId = dms.int(dms["npc"], self.selectNpcId, npc.environment_formation1)
    local environment_formationMould = dms.element(dms["environment_formation"], environment_formationId)
    local environment_ship_ids = {}
    for i = 1, 9 do
        table.insert(environment_ship_ids, dms.atoi(environment_formationMould, environment_formation.seat_one + i - 1))
    end
    for i = 1, 12 do
        table.insert(environment_ship_ids, dms.atoi(environment_formationMould, environment_formation.seat_10 + i - 1))
    end
    for i, v in pairs(environment_ship_ids) do
        if v > 0 then
            local temp_bust_index = dms.int(dms["environment_ship"], v, environment_ship.bust_index)
            table.insert(self.master_bust_index_args, temp_bust_index)
            table.insert(self.master_bust_index_args_open, temp_bust_index)
        end
    end

    -- 创建刀光
    local armature = ccs.Armature:create("effect_1000")
    armature:setAnchorPoint(cc.p(0, 0.5))
    armature:setPosition(cc.p(self.heroTeamFront - self.heroGap, self.rolesLineY ))
    armature:setVisible(false)

    self:addChild(armature, 199)
    self.armatureKnifeLight = armature
    

    --创建经验增加
    local armature1 = ccs.Armature:create("effect_maoxian2")
    armature1:setAnchorPoint(cc.p(0, 0.5))
    
    armature1:setVisible(false)
    armature1:setRotation(90)
    armature1:setScale(0.9)
    self:addChild(armature1, 200)

    
    self.armatureExpAddLight= armature1
    self.armaturePosition = cc.p(self.heroTeamFront + self.armatureExpAddLight:getContentSize().width, self.armatureExpAddLight:getContentSize().height +  self.armatureExpAddLight:getContentSize().height/2)
    armature1:setPosition(self.armaturePosition)

    --创建金币增加
    local armature2 = ccs.Armature:create("effect_maoxian3")
    armature2:setAnchorPoint(cc.p(0, 0.5))
    armature2:setPosition(self.armaturePosition)
    armature2:setVisible(false)
    armature2:setScale(0.9)
    armature2:setRotation(90)
    self:addChild(armature2, 201)
    self.armatureSilverAddLight = armature2
    self:onUpdateExpAndSilverAnmature()
end

function DemoRoleController:onUpdateExpAndSilverAnmature()
    local randomIndex =  math.random(0, 50)    
    local offx = math.random(-25, 25)
    local offy = math.random(-35, 15)
    local offPos = cc.p(self.armaturePosition.x + offy ,self.armaturePosition.y + offx)
    if randomIndex > 25 then 
        -- 经验
        self.armatureExpAddLight:setVisible(true)
        self.armatureExpAddLight:setPosition(offPos)
        csb.animationChangeToAction(self.armatureExpAddLight, 0, 0, false)
        draw.initArmature(self.armatureExpAddLight, nil, -1, 0, 1)
        self.armatureExpAddLight._invoke = function(armatureBack)
            if armatureBack:isVisible() == true then 
                self.armatureExpAddLight:setVisible(false)
                self:onUpdateExpAndSilverAnmature()
            end
        end
    else
        --金币
        self.armatureSilverAddLight:setVisible(true)
        self.armatureSilverAddLight:setPosition(offPos)
        csb.animationChangeToAction(self.armatureSilverAddLight, 0, 0, false)
        draw.initArmature(self.armatureSilverAddLight, nil, -1, 0, 1)
        self.armatureSilverAddLight._invoke = function(armatureBack)
            if armatureBack:isVisible() == true then 
                self.armatureSilverAddLight:setVisible(false)
                self:onUpdateExpAndSilverAnmature()
            end
        end
    end 
end


function DemoRoleController:playAttackEffect()
    self.armatureKnifeLight:setVisible(true)
    self.armatureKnifeLight:getAnimation():playWithIndex(0, 0, 0)
end

function DemoRoleController:onUpdate(dt)
    -- 对话逻辑
    self.dialogueElapse = self.dialogueElapse + dt
    if self.dialogueElapse >= self.dialogueInteval then
        self.dialogueElapse = 0
		
        -- local talkId = math.random(#dms["talkdata"])
		local talkList = {}
		local number = 0
		for i=1,#dms["talkdata"] do
			if dms.int(dms["talkdata"], i, talkdata.secnenid) == zstring.tonumber(self.selectSceneId) then
				table.insert(talkList, i)
				number = number + 1
			end
		end
		local talkId = math.random(talkList[1],talkList[number])
        self.curTalkData = dms.element(dms["talkdata"], talkId)
        self.dialogueCount = dms.atoi(self.curTalkData, talkdata.count)
        self.dialogueText = zstring.split(dms.atos(self.curTalkData, talkdata.string), "|")
        self.dialogueTextIndex = 1
    end

    if self.dialogueCount > 0 then
        self.dialogueShowElapse = self.dialogueShowElapse + dt
        if self.dialogueShowElapse >= self.dialogueShowInteval then
            self.dialogueShowElapse = 0

            self.dialogueCount = self.dialogueCount - 1

            local cell = AdventureDialogueBubbleCell:createCell()
            cell:init(self.dialogueText[self.dialogueTextIndex])
            -- 将废话框旋转90度
            cell:setRotation(90)
            self.dialogueTextIndex = self.dialogueTextIndex + 1
			local rolesCount = math.max(zstring.tonumber(#self.roles) - 1, 1)
            local roleIndex = math.random(1, rolesCount)
            -- 避免随机到同一个人
            if roleIndex == self.lastTalkRoleIndex then
                roleIndex = roleIndex + 1
                if roleIndex > #self.roles - 1 then
                    roleIndex = 1
                end                
            end
            self.lastTalkRoleIndex = roleIndex
            local x, y = self.roles[roleIndex]:getPosition()
            local roleSize = self.roles[roleIndex]:getContentSize()
            local cellSize = cell:getContentSize()
            -- 更改废话框的位置
            -- cell:setPosition(x , y + roleSize.height + 50)
			-- 这里设置的X ,Y 其实是反向的,因为旋转了90°
            cell:setPosition(x + 65 , y + roleSize.height/2 - 15)
			
            self:addChild(cell,10000)

            table.insert(self.dialogueCells, cell)
        end
    end

    -- 移除第一个对话框
    if #self.dialogueCells > 0 then
        self.dialogueCellElapse = self.dialogueCellElapse + dt
        if self.dialogueCellElapse >= self.dialogueCellTime then
            self.dialogueCellElapse = 0

            local cell = self.dialogueCells[1]
            cell:removeFromParent(false)
            table.remove(self.dialogueCells, 1)
        end
    end

    -- 英雄变身逻辑
    self.changeRoleElapse = self.changeRoleElapse + dt
    if self.changeRoleElapse >= self.changeRoleInteval then
        self.changeRoleElapse = 0

        self:changeRole()
    end

    -- 怪物生成逻辑
    self.makeMonsterElapse = self.makeMonsterElapse + dt
    if self.makeMonsterElapse >= self.makeMonsterInteval then
        self.makeMonsterElapse = 0
        self.makeMonsterInteval = math.random(1, 4)
        
        for i = 1, math.random(1) do 
            local headId = self:getMasterHead()
            if headId ~= nil then
                local monster = DemoMonster:new():init(self, self.rolesLineX, headId)
                monster:setPosition(cc.p(self.size.height+i*self.heroGap + 15, self.rolesLineX))
                self:addChild(monster,100-self.monsterIndex)
				self.monsterIndex = self.monsterIndex + 1
				if self.monsterIndex == 100 then
					self.monsterIndex = 0
				end
                table.insert(self.monsters, monster)
            end
        end
    end

    local deadMonstersIndex = {}            -- 存放死亡怪物在列表中的位置
    for i = 1, #self.monsters do
        local monster = self.monsters[i]
        monster:update(dt)

        -- 死亡加入死亡列表，在下面移除
        if monster:isDead() then
            self:resetMasterHead(monster.headId)
            table.insert(deadMonstersIndex, i)
        end
    end

    -- 移除死亡怪物
    for i = 1, #deadMonstersIndex do
        local index = deadMonstersIndex[#deadMonstersIndex - i + 1]
        local deadMonster = self.monsters[index]

        self:removeChild(deadMonster)
        self:removeChild(deadMonster.shadow)              

        table.remove(self.monsters, index)
    end
end

function DemoRoleController:changeRole()
    local changeIndex = math.random(#self.roles)

    self.roles[changeIndex]:changeRole()
end

function DemoRoleController:onExit()
    state_machine.remove("world_role_controller_play_attack_effect")
end

function DemoRoleController:init(parent, size, sceneId, npcId)
    self.parent = parent
    self:setContentSize(cc.size(size.width, size.height))

    self.selectSceneId = sceneId
    self.selectNpcId = npcId

    self.size = size
    self.heroTeamFront = size.width / 2 
    self.attackAreaX = self.heroTeamFront + 50
    self.monsterDeadAreaX = size.width + 20             -- 超出屏幕的区域

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("effect/effect_1000.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_maoxian2/effect_maoxian2.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_maoxian3/effect_maoxian3.ExportJson")

    return self
end

function DemoRoleController:createCell()
    local cell = DemoRoleController:new()
    cell:registerOnNodeEvent(cell)
    cell:registerOnNoteUpdate(cell)
    return cell
end