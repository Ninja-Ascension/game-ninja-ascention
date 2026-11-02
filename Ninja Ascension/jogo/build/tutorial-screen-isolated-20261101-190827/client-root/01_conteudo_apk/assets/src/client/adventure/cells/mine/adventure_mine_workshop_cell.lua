----------------------------------------------------------------------------------------------------
-- 说明：矿山作坊
----------------------------------------------------------------------------------------------------
AdventureMineWorkshopCell = class("AdventureMineWorkshopCellClass", Window)

function AdventureMineWorkshopCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	 self.pick = false
	self.index = 0
	self.times = nil
	-- Initialize adventure mine tile cell state machine.
	local function init_adventure_mine_workshop_cell_terminal()
		 -- 打开闲置的工坊
        local adventure_mine_workshop_work_open_terminal = {
            _name = "adventure_mine_workshop_work_open",
            _init = function (terminal)
				app.load("client.adventure.campaign.mine.AdventureMineWorkshopAddWork")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				fwin:open(AdventureMineWorkshopAddWork:new():init(cell), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 解锁工坊
        local adventure_mine_workshop_work_unlock_terminal = {
            _name = "adventure_mine_workshop_work_unlock",
            _init = function (terminal)
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				local function responseMineExploitCallback(response)
					-- print(response.resouce)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("adventure_mine_workshop_update_listview", 0, "adventure_mine_workshop_update_listview.")
					end
				end
				NetworkManager:register(protocol_command.mineral_add_workspace.code, nil, nil, nil, cell, responseMineExploitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 完成工程
        local adventure_mine_workshop_work_over_terminal = {
            _name = "adventure_mine_workshop_work_over",
            _init = function (terminal)
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				local function responseMineExploitCallback(response)
					-- print(response.resouce)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("adventure_mine_workshop_update_listview", 0, "adventure_mine_workshop_update_listview.")
						app.load("client.adventure.reward.AdventureTipReward")
						fwin:open(AdventureTipReward:new():init(getSceneReward(58)), fwin._ui)
					end
				end
				protocol_command.mineral_reward_gain.param_list = cell.index
				NetworkManager:register(protocol_command.mineral_reward_gain.code, nil, nil, nil, cell, responseMineExploitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(adventure_mine_workshop_work_open_terminal)
        state_machine.add(adventure_mine_workshop_work_unlock_terminal)
        state_machine.add(adventure_mine_workshop_work_over_terminal)
		
        state_machine.init()
	end

	-- call func init adventure mine tile cell state machine.
	init_adventure_mine_workshop_cell_terminal()
end

function AdventureMineWorkshopCell:onEnterTransitionFinish()

end

function AdventureMineWorkshopCell:onUpdate(dt)
	if self.index <= zstring.tonumber(_ED.mine_work_open_number) then
		if self.index <= zstring.tonumber(_ED.mine_work_number) then
			if self.pick == false then
				local interval = (zstring.tonumber(_ED.mine_work_info[self.index].mine_time) + zstring.tonumber(_ED.mine_work_info[self.index].workshop_surplus_time)) - os.time()
			   if self.interval ~= interval then
					self.interval = interval
					if self.interval <= 0 then
						self.pick = true
						self:updateDraw()
					else
						local timeTabel = formatTime(interval)
						local str = timeTabel.hour
						str = str .. string.format(":%02d", timeTabel.minute)
						str = str .. string.format(":%02d", timeTabel.second)
						self.times:setString(str)
					end
				end
			end
		end
	end
end

function AdventureMineWorkshopCell:updateDraw()
	local root = self.roots[1]
	if self.index <= zstring.tonumber(_ED.mine_work_open_number) then
		if self.index <= zstring.tonumber(_ED.mine_work_number) then
			ccui.Helper:seekWidgetByName(root, "Panel_dibao"):setVisible(true)
			for i=1,4 do
				if zstring.tonumber(_ED.mine_work_info[self.index].workshop_depth) == i then
					ccui.Helper:seekWidgetByName(root, "Image_db_"..i):setVisible(true)
				else
					ccui.Helper:seekWidgetByName(root, "Image_db_"..i):setVisible(false)
				end
			end
			ccui.Helper:seekWidgetByName(root, "Button_new"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_kong"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_dbname"):setVisible(true)
			local strs = dms.string(dms["mine_depth_param"], _ED.mine_work_info[self.index].workshop_depth, mine_depth_param.depth_name).."L".._ED.mine_work_info[self.index].workshop_time
			ccui.Helper:seekWidgetByName(root, "Text_dbname"):setString(strs)
			if zstring.tonumber(_ED.mine_work_info[self.index].workshop_surplus_time) == 0 then
				ccui.Helper:seekWidgetByName(root, "Button_over"):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Text_time"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Image_cd"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Text_time_0"):setVisible(false)
			elseif zstring.tonumber(_ED.mine_work_info[self.index].workshop_surplus_time) == -1 then
				ccui.Helper:seekWidgetByName(root, "Button_over"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Text_time"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Image_cd"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Text_time_0"):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Text_time_0"):setString(_string_piece_info[377])
			else
				ccui.Helper:seekWidgetByName(root, "Button_over"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Text_time"):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Image_cd"):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Text_time_0"):setVisible(false)
			end
		else
			ccui.Helper:seekWidgetByName(root, "Button_new"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_kong"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Image_cd"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_time"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_dbname"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Panel_4"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_over"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Panel_dibao"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_time_0"):setVisible(false)
		end
	else
		ccui.Helper:seekWidgetByName(root, "Button_new"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_kong"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_cd"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_time"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_dbname"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_4"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Button_over"):setVisible(false)
		local config = zstring.split(dms.string(dms["pirates_config"], 300, pirates_config.param), ",")
		ccui.Helper:seekWidgetByName(root, "Text_sui_num"):setString(config[self.index])
	end
end

function AdventureMineWorkshopCell:onInit()
	local csbAdventureMineTileCell = csb.createNode("list/list_kggongfang_1.csb")
 	local root = csbAdventureMineTileCell:getChildByName("root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
 	self:addChild(root)
	self:setContentSize(ccui.Helper:seekWidgetByName(root, "Panel_5"):getContentSize())
	root:setSwallowTouches(false)
 	self:updateDraw()
	
	self.times = ccui.Helper:seekWidgetByName(root, "Text_time")
	if self.index <= zstring.tonumber(_ED.mine_work_open_number) then
		if self.index <= zstring.tonumber(_ED.mine_work_number) then
			self.interval = (zstring.tonumber(_ED.mine_work_info[self.index].mine_time) + zstring.tonumber(_ED.mine_work_info[self.index].workshop_surplus_time)) - os.time()
			if self.interval <= 0 then
				self.pick = true
			end
		end
    end
	
	--打开闲置的工坊 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_new"), nil, 
    {
        terminal_name = "adventure_mine_workshop_work_open", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	--解锁工坊
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jiesuo"), nil, 
    {
        terminal_name = "adventure_mine_workshop_work_unlock", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	--完成工程
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_over"), nil, 
    {
        terminal_name = "adventure_mine_workshop_work_over", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureMineWorkshopCell:onExit()

end

function AdventureMineWorkshopCell:init(index)
	self.index = index

	self:onInit()
	return self
end

function AdventureMineWorkshopCell:createCell()
	local cell = AdventureMineWorkshopCell:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell)
	return cell
end

