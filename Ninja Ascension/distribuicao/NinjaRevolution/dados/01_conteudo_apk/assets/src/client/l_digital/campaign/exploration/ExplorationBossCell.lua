----------------------------------------------------------------------------------------------------
-- 说明：文件岛Boss cell
----------------------------------------------------------------------------------------------------
ExplorationBossCell = class("ExplorationBossCellClass", Window)
ExplorationBossCell.__size = nil

function ExplorationBossCell:ctor()
    self.super:ctor()
	self.roots = {}
end

function ExplorationBossCell:onUpdateDraw()
	local root = self.roots[1]
	self.Text_explor_find_name_1:setString(self.taskData.otherUserInfo.nickName)
	self.Text_explor_find_name_2:setString(self.taskData.otherUserInfo.nickName)

	if self.taskData.uid == tonumber(_ED.user_info.user_id) then
		self.Image_explor_boss:setVisible(true)
	end

	local npcData = dms.element(dms["npc"], self.taskData.npcId)
	local nickId = dms.atos(npcData, npc.npc_name)
	local nick = dms.element(dms["word_mould"], nickId)
	self.Text_explor_find_role_name_1:setString(nick[3])
	self.Text_explor_find_role_name_2:setString(nick[3])

	if self.taskData.isChallenged == 1 then
		self.Image_explor_boss_challenged:setVisible(true)
	end

end

function ExplorationBossCell:onInit()
    local root = cacher.createUIRef("campaign/exploration/exploration_boss_cell.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	-- -- 背景按钮
	self.Button_explor_find = ccui.Helper:seekWidgetByName(root, "Button_explor_find")
	self.Button_explor_find:loadTextureNormal("images/ui/text/TS/btn_ts_boss_1.png")
	self.Button_explor_find:loadTexturePressed("images/ui/text/TS/btn_ts_boss_1.png")

	self.Panel_explor_find_1 = ccui.Helper:seekWidgetByName(root, "Panel_explor_find_1")
	self.Panel_explor_find_1:setVisible(true)
	self.Panel_explor_find_2 = ccui.Helper:seekWidgetByName(root, "Panel_explor_find_2")
	self.Panel_explor_find_2:setVisible(false)

	local callback = function (sender, evenType)

        if evenType == ccui.TouchEventType.began then
        elseif evenType == ccui.TouchEventType.moved then
        elseif evenType == ccui.TouchEventType.ended then
        	self.Button_explor_find:loadTextureNormal("images/ui/text/TS/btn_ts_boss_2.png")
        	self.Button_explor_find:loadTexturePressed("images/ui/text/TS/btn_ts_boss_2.png")
        	self.Panel_explor_find_1:setVisible(false)
        	self.Panel_explor_find_2:setVisible(true)

        	if self.explorationBoss.selectIndex == self.index then
        		return
        	end

        	self.explorationBoss.listView:getItem(self.explorationBoss.selectIndex - 1).Button_explor_find:loadTextureNormal("images/ui/text/TS/btn_ts_boss_1.png")
        	self.explorationBoss.listView:getItem(self.explorationBoss.selectIndex - 1).Button_explor_find:loadTexturePressed("images/ui/text/TS/btn_ts_boss_1.png")
        	self.explorationBoss.listView:getItem(self.explorationBoss.selectIndex - 1).Panel_explor_find_1:setVisible(true)
        	self.explorationBoss.listView:getItem(self.explorationBoss.selectIndex - 1).Panel_explor_find_2:setVisible(false)

        	self.explorationBoss.selectIndex = self.index
        	state_machine.excute("exploration_boss_refresh_boss_info", 0, self.index) 
        end
    end
    self.Button_explor_find:addTouchEventListener(callback)

	if self.explorationBoss.selectIndex == self.index then
		self.Button_explor_find:loadTextureNormal("images/ui/text/TS/btn_ts_boss_2.png")
        self.Button_explor_find:loadTexturePressed("images/ui/text/TS/btn_ts_boss_2.png")
        self.Panel_explor_find_1:setVisible(false)
        self.Panel_explor_find_2:setVisible(true)
	else
		self.Button_explor_find:loadTextureNormal("images/ui/text/TS/btn_ts_boss_1.png")
        self.Button_explor_find:loadTexturePressed("images/ui/text/TS/btn_ts_boss_1.png")
        self.Panel_explor_find_1:setVisible(true)
        self.Panel_explor_find_2:setVisible(false)
	end

	-- 玩家名
	self.Text_explor_find_name_1 = ccui.Helper:seekWidgetByName(root, "Text_explor_find_name_1")
	self.Text_explor_find_name_2 = ccui.Helper:seekWidgetByName(root, "Text_explor_find_name_2")
	-- boss名
	self.Text_explor_find_role_name_1 = ccui.Helper:seekWidgetByName(root, "Text_explor_find_role_name_1")
	self.Text_explor_find_role_name_2 = ccui.Helper:seekWidgetByName(root, "Text_explor_find_role_name_2")
	-- 时间
	self.Text_explor_find_time_1 = ccui.Helper:seekWidgetByName(root, "Text_explor_find_time_1")
	self.Text_explor_find_time_2 = ccui.Helper:seekWidgetByName(root, "Text_explor_find_time_2")
	-- 我的boss
	self.Image_explor_boss = ccui.Helper:seekWidgetByName(root, "Image_explor_boss")
	self.Image_explor_boss:setVisible(false)
	-- 已挑战
	self.Image_explor_boss_challenged = ccui.Helper:seekWidgetByName(root, "Image_explor_boss_challenged")
	self.Image_explor_boss_challenged:setVisible(false)

	local panel_size = root:getContentSize()
	self:onUpdateDraw()

	self:setContentSize(panel_size)
	if ExplorationBossCell.__size == nil then
		ExplorationBossCell.__size = panel_size
	end

	self:registerOnNoteUpdate(self, 1)
end

function ExplorationBossCell:onUpdate(dt)
	local root = self.roots[1]
    if root == nil then
        return
    end

    if self.taskData == nil or self.taskData.endTime == nil then
        return
    end

    local lastCDTime = self.taskData.endTime
    if lastCDTime and lastCDTime > 0 then
        local current = _ED.system_time + (os.time() - _ED.native_time)
        local surplus_time = lastCDTime - current

        if self.Text_explor_find_time_1 and self.Text_explor_find_time_2 then
            self.Text_explor_find_time_1:setString(getRedAlertTimeActivityFormat(surplus_time))
            self.Text_explor_find_time_2:setString(getRedAlertTimeActivityFormat(surplus_time))
        end
    end
end

function ExplorationBossCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end

    self:onInit()
end

function ExplorationBossCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()

    cacher.freeRef("campaign/explore/explore_boss_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function ExplorationBossCell:clearUIInfo()
    local root = self.roots[1]

    local Text_explor_find_name_1 = ccui.Helper:seekWidgetByName(root, "Text_explor_find_name_1")
	local Text_explor_find_name_2 = ccui.Helper:seekWidgetByName(root, "Text_explor_find_name_2")
	local Text_explor_find_role_name_1 = ccui.Helper:seekWidgetByName(root, "Text_explor_find_role_name_1")
	local Text_explor_find_role_name_2 = ccui.Helper:seekWidgetByName(root, "Text_explor_find_role_name_2")
	local Text_explor_find_time_1 = ccui.Helper:seekWidgetByName(root, "Text_explor_find_time_1")
	local Text_explor_find_time_2 = ccui.Helper:seekWidgetByName(root, "Text_explor_find_time_2")

    if Text_explor_find_name_1 then
    	Text_explor_find_name_1:setString("")
    end

    if Text_explor_find_name_2 then
    	Text_explor_find_name_2:setString("")
    end
    
    if Text_explor_find_role_name_1 then
    	Text_explor_find_role_name_1:setString("")
    end
    
    if Text_explor_find_role_name_2 then
    	Text_explor_find_role_name_2:setString("")
    end

    if Text_explor_find_time_1 then
    	Text_explor_find_time_1:setString("")
    end
	
	if Text_explor_find_time_2 then
		Text_explor_find_time_2:setString("")
	end
end

function ExplorationBossCell:onExit()
	self:clearUIInfo()

    cacher.freeRef("campaign/explore/explore_boss_cell.csb", self.roots[1])
end

function ExplorationBossCell:initData()

end

function ExplorationBossCell:init(params, index, boss)
	self.taskData = params or {}
	self:initData()

	self.explorationBoss = boss
	self.index = index

	if index and index < 9 then
		self:onInit()
	end

	if ExplorationBossCell.__size then
		self:setContentSize(ExplorationBossCell.__size)
	end
end

function ExplorationBossCell:createCell()
	local cell = ExplorationBossCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


