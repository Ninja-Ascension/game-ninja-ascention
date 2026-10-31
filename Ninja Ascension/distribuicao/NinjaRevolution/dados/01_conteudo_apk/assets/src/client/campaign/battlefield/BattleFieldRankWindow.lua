
BattleFieldRankWindow = class("BattleFieldRankWindowClass", Window)
   
local battle_field_rank_window_open_terminal = {
    _name = "battle_field_rank_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("BattleFieldRankWindowClass") then
        	local battleFieldRankWindow = BattleFieldRankWindow:new()
			fwin:open(battleFieldRankWindow, fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_field_rank_window_close_terminal = {
    _name = "battle_field_rank_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleFieldRankWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_field_rank_window_open_terminal)
state_machine.add(battle_field_rank_window_close_terminal)
state_machine.init()


function BattleFieldRankWindow:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.cells.campaign.battleField.battle_field_rank_list_cell")

    -- 列表容器
    self.ListView_ph = nil
    -- 我的排名
	self.Text_me_1 = nil
	-- 历史最高训兽魂
	self.Text_ls_1 = nil
	-- 本场累计训兽魂
	self.Text_bc_1 = nil
	--虚位以待
	self.Text_xwyd = nil

	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = nil

    local function init_battle_field_rank_window_terminal()
		--关闭面板
		local battle_field_rank_close_terminal = {
            _name = "battle_field_rank_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.excute("battle_field_rank_window_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(battle_field_rank_close_terminal)
        state_machine.init()
    end
    
    init_battle_field_rank_window_terminal()
end

function BattleFieldRankWindow:onUpdateDraw( ... )
	self.ListView_ph:removeAllItems()
	local myRank = 0
	if _ED.charts.battle_field_rank_info == nil or table.nums(_ED.charts.battle_field_rank_info) == 0 then
		self.Text_xwyd:setVisible(true)
	else
		for i,v in pairs(_ED.charts.battle_field_rank_info) do
			local battleFieldRankListCell = BattleFieldRankListCell:createCell()
			self.ListView_ph:addChild(battleFieldRankListCell:init(i, v))
			if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
				myRank = v.order
			end
		end
    	self.Text_bc_1:setString("".._ED._pet_battle_filed_info.get_pet_soul)
   		self.Text_ls_1:setString("".._ED._pet_battle_filed_info.history_max_pet_soul)
		self.ListView_ph:requestRefreshView()
		self.currentInnerContainer = self.ListView_ph:getInnerContainer()
		self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	end
	if myRank == 0 then
		self.Text_me_1:setString(_string_piece_info[34])
	else
		self.Text_me_1:setString(_string_piece_info[2] .. myRank .. _string_piece_info[317])
	end
end

function BattleFieldRankWindow:onUpdate(dt)
	if self.ListView_ph ~= nil and self.currentInnerContainer ~= nil then
		local size = self.ListView_ph:getContentSize()
		local posY = self.currentInnerContainer:getPositionY()
		if self.currentInnerContainerPosY == posY then
			return
		end
		self.currentInnerContainerPosY = posY
		local items = self.ListView_ph:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
				v:unload()
			else
				v:reload()
			end
		end
	end
end

function BattleFieldRankWindow:init( ... )
	-- body
end

function BattleFieldRankWindow:onEnterTransitionFinish()
	local csbBattleRankPanel = csb.createNode("campaign/BattleField/BattleField_ranking.csb")
	local action = csb.createTimeline("campaign/BattleField/BattleField_ranking.csb")
	local root = csbBattleRankPanel:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbBattleRankPanel)
	
	csbBattleRankPanel:runAction(action)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	-- action:play("window_open")

	self.ListView_ph = ccui.Helper:seekWidgetByName(root, "ListView_ph")
	self.ListView_ph:removeAllItems()

	self.Text_me_1 = ccui.Helper:seekWidgetByName(root, "Text_me_1")
	self.Text_me_1:setString("")
	
	self.Text_ls_1 = ccui.Helper:seekWidgetByName(root, "Text_ls_1")
	self.Text_ls_1:setString("")

	self.Text_bc_1 = ccui.Helper:seekWidgetByName(root, "Text_bc_1")
	self.Text_bc_1:setString("")

	self.Text_xwyd = ccui.Helper:seekWidgetByName(root, "Text_xwyd")
	self.Text_xwyd:setVisible(false)

	--添加返回点击事件
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), 	nil, 
	{
		terminal_name = "battle_field_rank_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	self:onUpdateDraw()
end

function BattleFieldRankWindow:close()
	self.ListView_ph:removeAllItems()
end

function BattleFieldRankWindow:onExit()
	state_machine.remove("battle_field_rank_close")
end