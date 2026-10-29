-- ----------------------------------------------------------------------------------------------------
-- 说明：矿区工坊工作选择区
-------------------------------------------------------------------------------------------------------
AdventureMineWorkshopAddWork = class("AdventureMineWorkshopAddWorkClass", Window)
    
function AdventureMineWorkshopAddWork:ctor()
    self.super:ctor()
    self.roots = {}
	app.load("client.adventure.cells.mine.adventure_mine_workshop_cell")
	app.load("client.adventure.cells.prop.adventure_new_prop_small_icon_cell")
	self.workshoplist = nil
	self.depthId = 1
	self.timesId = 1
	-- 显示耐力的Panel
	self.Panel_1 = nil
	-- 耐力Panel的X坐标
	self.posx = 0
	
	--需求耐力
	self.needEndurance = 0
    -- Initialize adventure mine workshop state machine.
    local function init_adventure_mine_workshop_add_terminal()
	
		-- 建立工坊工程
        local adventure_mine_workshop_establish_engineering_terminal = {
            _name = "adventure_mine_workshop_establish_engineering",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				if zstring.tonumber(_ED.user_info.endurance) < zstring.tonumber(self.needEndurance) then
					app.load("client.adventure.campaign.mine.AdventureMineTip")
					fwin:open(AdventureMineTip:new():init(), fwin._view)
					fwin:close(fwin:find("AdventureMineWorkshopAddWorkClass"))
					return
				end
				local function responseMineExploitCallback(response)
					-- print(response.resouce)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						fwin:close(fwin:find("AdventureMineWorkshopAddWorkClass"))
						----刷新
						state_machine.excute("adventure_mine_workshop_update_listview", 0, "adventure_mine_workshop_update_listview.")
						state_machine.excute("adventure_mine_manager_update_basics", 0, "adventure_mine_manager_update_basics.")
						
					end
				end
				protocol_command.mineral_new_project.param_list = self.depthId.. "\r\n" ..self.timesId
				NetworkManager:register(protocol_command.mineral_new_project.code, nil, nil, nil, cell, responseMineExploitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_mine_workshop_establish_engineering_terminal)

        state_machine.init()
    end
    
    -- call func init adventure mine workshop state machine.
    init_adventure_mine_workshop_add_terminal()
end

function AdventureMineWorkshopAddWork:init()

	return self
end

function AdventureMineWorkshopAddWork:onUpdateDraw()
	local root = self.roots[1]
	if dms.int(dms["mine_depth_param"], self.depthId, mine_depth_param.gain_prop1) > 0 then
		local cell = adventureNewSmallPropIconCell:createCell()
		cell:init(0, {mould_id = dms.int(dms["mine_depth_param"], self.depthId, mine_depth_param.gain_prop1)} ,nil,nil,0)
		ccui.Helper:seekWidgetByName(root, "Panel_prop_1"):removeAllChildren(true)
		ccui.Helper:seekWidgetByName(root, "Panel_prop_1"):addChild(cell)
	end
	if dms.int(dms["mine_depth_param"], self.depthId, mine_depth_param.gain_prop2) > 0 then
		local cell = adventureNewSmallPropIconCell:createCell()
		cell:init(0, {mould_id = dms.int(dms["mine_depth_param"], self.depthId, mine_depth_param.gain_prop2)} ,nil,nil,0)
		ccui.Helper:seekWidgetByName(root, "Panel_prop_1_0"):removeAllChildren(true)
		ccui.Helper:seekWidgetByName(root, "Panel_prop_1_0"):addChild(cell)
	end
	if dms.int(dms["mine_depth_param"], self.depthId, mine_depth_param.gain_prop3) > 0 then
		local cell = adventureNewSmallPropIconCell:createCell()
		cell:init(0, {mould_id = dms.int(dms["mine_depth_param"], self.depthId, mine_depth_param.gain_prop3)} ,nil,nil,0)
		ccui.Helper:seekWidgetByName(root, "Panel_prop_1_1"):removeAllChildren(true)
		ccui.Helper:seekWidgetByName(root, "Panel_prop_1_1"):addChild(cell)
	end
	ccui.Helper:seekWidgetByName(root, "Text_db_name"):setString(dms.string(dms["mine_depth_param"], self.depthId, mine_depth_param.depth_name).."L"..self.timesId)
	local str = _string_piece_info[375]
	local strinfo = nil
	-- 选择挖掘深度的编号 (1  0. 2 35.  3 120. 4  250)
	if self.depthId == 1 then
		local str_s = string.gsub(str,"z",dms.string(dms["mine_time_param"], self.timesId, mine_time_param.prop_amount_min1))
		local str_z = string.gsub(str_s,"y",dms.string(dms["mine_time_param"], self.timesId, mine_time_param.prop_amount_max1))
		strinfo = str_z
	elseif self.depthId == 2 then
		local str_s = string.gsub(str,"z",dms.string(dms["mine_time_param"], self.timesId, mine_time_param.prop_amount_min2))
		local str_z = string.gsub(str_s,"y",dms.string(dms["mine_time_param"], self.timesId, mine_time_param.prop_amount_max2))
		strinfo = str_z
	elseif self.depthId == 3 then
		local str_s = string.gsub(str,"z",dms.string(dms["mine_time_param"], self.timesId, mine_time_param.prop_amount_min3))
		local str_z = string.gsub(str_s,"y",dms.string(dms["mine_time_param"], self.timesId, mine_time_param.prop_amount_max3))
		strinfo = str_z
	elseif self.depthId == 4 then
		local str_s = string.gsub(str,"z",dms.string(dms["mine_time_param"], self.timesId, mine_time_param.prop_amount_min4))
		local str_z = string.gsub(str_s,"y",dms.string(dms["mine_time_param"], self.timesId, mine_time_param.prop_amount_max4))
		strinfo = str_z	
	end
	ccui.Helper:seekWidgetByName(root, "Text_kshi"):setString(strinfo)
	local needEndurance = 0
	local needPropCount = 0	
	local needPropID = 0
	local rowData = dms.element(dms["mine_depth_param"], self.depthId)
	-- 选择挖掘时间编号(1 60. 2 120. 3 240)
	if (tonumber(self.timesId) == 1) then
		needEndurance = dms.atoi(rowData, mine_depth_param.cost_endurance1)
		needPropCount = dms.atoi(rowData, mine_depth_param.cost_prop_amount1)
		needPropID = dms.atoi(rowData, mine_depth_param.cost_prop_id1)
	elseif(self.timesId == 2) then
		needEndurance = dms.atoi(rowData, mine_depth_param.cost_endurance2)
		needPropCount = dms.atoi(rowData, mine_depth_param.cost_prop_amount2)
		needPropID = dms.atoi(rowData, mine_depth_param.cost_prop_id2)
	elseif(self.timesId == 3) then
		needEndurance = dms.atoi(rowData, mine_depth_param.cost_endurance3)
		needPropCount = dms.atoi(rowData, mine_depth_param.cost_prop_amount3)
		needPropID = dms.atoi(rowData, mine_depth_param.cost_prop_id3)
	end
	ccui.Helper:seekWidgetByName(root, "Panel_prop_xh_2"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_prop_xh_1"):removeAllChildren(true)
	-- 显示耐力数量
	local cell = adventureNewSmallPropIconCell:createCell()
	-- 显示炸弹数量
	local targetNumber = 0
	for i, v in pairs(_ED.user_prop) do
			if zstring.tonumber(v.user_prop_template) == needPropID then
				targetNumber = zstring.tonumber(v.prop_number)
				break	
			end
	end
	-- 炸弹数为0时将消耗耐力放中间
	if tonumber(needPropCount) <= 0 then
		self.Panel_1:setPositionX(self.posx + 70)
	else
		self.Panel_1:setPositionX(self.posx)
	end
	self.needEndurance = needEndurance
	cell:init(0, {mould_id = 1} ,_ED.user_info.endurance.."/"..zstring.tonumber(needEndurance),-1,0)
	self.Panel_1:removeAllChildren(true)
	self.Panel_1:addChild(cell)

	if needPropCount > 0 then
		local cellProp = adventureNewSmallPropIconCell:createCell()
		cellProp:init(0, {mould_id = 303} ,targetNumber.."/"..zstring.tonumber(needPropCount),nil,0)
		local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_prop_xh_2")
		Panel_2:removeAllChildren(true)
		Panel_2:addChild(cellProp)
	end


	-- if dms.int(dms["mine_depth_param"], self.depthId, 8+self.timesId*2+(self.timesId-1)) > 0 then
		
	-- 	local cell = adventureNewSmallPropIconCell:createCell()
	-- 	cell:init(0, {mould_id = 1} ,math.min(dms.int(dms["mine_depth_param"], self.depthId, 8+self.timesId*2+(self.timesId-1)),zstring.tonumber(_ED.user_info.endurance)).."/"..zstring.tonumber(_ED.user_info.max_endurance),-1,0)
	-- 	ccui.Helper:seekWidgetByName(root, "Panel_prop_xh_1"):removeAllChildren(true)
	-- 	ccui.Helper:seekWidgetByName(root, "Panel_prop_xh_1"):addChild(cell)
	-- end
	-- -- if dms.int(dms["mine_depth_param"], self.depthId, 8+self.timesId*2+(self.timesId)) > 0 then
	-- 	local cell = adventureNewSmallPropIconCell:createCell()
	-- 	local targetNumber = 0
	-- 	for i, v in pairs(_ED.user_prop) do
	-- 		if zstring.tonumber(v.user_prop_template) == dms.int(dms["mine_depth_param"], self.depthId, 8+self.timesId*2+(self.timesId)) then
	-- 			targetNumber = zstring.tonumber(v.prop_number)
	-- 			break	
	-- 		end
	-- 	end
	-- 	local needNumber = math.max(dms.int(dms["mine_depth_param"], self.depthId, 8+self.timesId*2+(self.timesId)),0)
	-- 	cell:init(0, {mould_id = 303} ,needNumber.."/"..targetNumber,nil,0)
	-- 	ccui.Helper:seekWidgetByName(root, "Panel_prop_xh_2"):removeAllChildren(true)
	-- 	ccui.Helper:seekWidgetByName(root, "Panel_prop_xh_2"):addChild(cell)
	-- end
	
	
end

function AdventureMineWorkshopAddWork:updateSelectOne(indexs)
	local root = self.roots[1]
	self.depthId = indexs
	if indexs == 1 then
		ccui.Helper:seekWidgetByName(root, "CheckBox_1"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_2"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_3"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_4"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_2"):setSelected(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_3"):setSelected(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_4"):setSelected(false)
	elseif indexs == 2 then
		ccui.Helper:seekWidgetByName(root, "CheckBox_2"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_1"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_3"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_4"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_1"):setSelected(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_3"):setSelected(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_4"):setSelected(false)
	elseif indexs == 3 then
		ccui.Helper:seekWidgetByName(root, "CheckBox_3"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_1"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_2"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_4"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_1"):setSelected(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_2"):setSelected(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_4"):setSelected(false)
	elseif indexs == 4 then
		ccui.Helper:seekWidgetByName(root, "CheckBox_4"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_1"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_2"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_3"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_1"):setSelected(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_2"):setSelected(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_3"):setSelected(false)
	end
	self:onUpdateDraw()
end

function AdventureMineWorkshopAddWork:updateSelectTwo(indexs)
	local root = self.roots[1]
	self.timesId = indexs
	if indexs == 1 then
		ccui.Helper:seekWidgetByName(root, "CheckBox_1_0"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_2_0"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_3_0"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_2_0"):setSelected(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_3_0"):setSelected(false)
	elseif indexs == 2 then
		ccui.Helper:seekWidgetByName(root, "CheckBox_2_0"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_1_0"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_3_0"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_1_0"):setSelected(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_3_0"):setSelected(false)
	elseif indexs == 3 then
		ccui.Helper:seekWidgetByName(root, "CheckBox_3_0"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_1_0"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_2_0"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_1_0"):setSelected(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_2_0"):setSelected(false)
	end
	self:onUpdateDraw()
end

function AdventureMineWorkshopAddWork:onEnterTransitionFinish()
	local csbAdventureMineWorkshop = csb.createNode("campaign/Mining/wakang_project_add.csb")
    local root = csbAdventureMineWorkshop:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMineWorkshop)
	self.Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_prop_xh_1")
	self.posx = self.Panel_1:getPositionX()
	for i=1, 4 do
		if i == 1 then
			ccui.Helper:seekWidgetByName(root, "Image_23"):getChildByName("Text_21"):setString(dms.string(dms["mine_depth_param"], i, mine_depth_param.depth))
		else
			ccui.Helper:seekWidgetByName(root, "Image_23_"..(i-2)):getChildByName("Text_21"):setString(dms.string(dms["mine_depth_param"], i, mine_depth_param.depth))
		end
	end
	
	for j=1,3 do
		if j==1 then
			ccui.Helper:seekWidgetByName(root, "Image_23_3"):getChildByName("Text_21"):setString(dms.int(dms["mine_time_param"], j, mine_time_param.cost_time)/60)
		else
			ccui.Helper:seekWidgetByName(root, "Image_23_"..(j-2).."_0"):getChildByName("Text_21"):setString(dms.int(dms["mine_time_param"], j, mine_time_param.cost_time)/60)
		end
	end
	
	local function onOpenTouchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
		elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			self:updateSelectOne(sender.types)
		end
    end
	
	local function onOpenTouchEventtwo(sender, eventType)
		if eventType == ccui.TouchEventType.began then
		elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			self:updateSelectTwo(sender.types)
		end
    end
	self:updateSelectOne(1)
	self:updateSelectTwo(1)
	ccui.Helper:seekWidgetByName(root, "CheckBox_1").types = 1
	ccui.Helper:seekWidgetByName(root, "CheckBox_2").types = 2
	ccui.Helper:seekWidgetByName(root, "CheckBox_3").types = 3
	ccui.Helper:seekWidgetByName(root, "CheckBox_4").types = 4
	ccui.Helper:seekWidgetByName(root, "CheckBox_1"):addTouchEventListener(onOpenTouchEvent)
	ccui.Helper:seekWidgetByName(root, "CheckBox_2"):addTouchEventListener(onOpenTouchEvent)
	ccui.Helper:seekWidgetByName(root, "CheckBox_3"):addTouchEventListener(onOpenTouchEvent)
	ccui.Helper:seekWidgetByName(root, "CheckBox_4"):addTouchEventListener(onOpenTouchEvent)
	ccui.Helper:seekWidgetByName(root, "CheckBox_1_0").types = 1
	ccui.Helper:seekWidgetByName(root, "CheckBox_2_0").types = 2
	ccui.Helper:seekWidgetByName(root, "CheckBox_3_0").types = 3
	ccui.Helper:seekWidgetByName(root, "CheckBox_1_0"):addTouchEventListener(onOpenTouchEventtwo)
	ccui.Helper:seekWidgetByName(root, "CheckBox_2_0"):addTouchEventListener(onOpenTouchEventtwo)
	ccui.Helper:seekWidgetByName(root, "CheckBox_3_0"):addTouchEventListener(onOpenTouchEventtwo)
	self:onUpdateDraw()
	
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMineWorkshopAddWorkClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	-- 关闭2
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMineWorkshopAddWorkClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	
	--建立工坊工程
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"), nil, 
    {
        terminal_name = "adventure_mine_workshop_establish_engineering", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
end

function AdventureMineWorkshopAddWork:onExit()
    
end