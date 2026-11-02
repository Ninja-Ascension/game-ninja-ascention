-- ----------------------------------------------------------------------------------------------------
-- 说明：名人堂人物排行榜
-- 创建时间	2015.4.27
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FameHallShow = class("FameHallShowClass", Window)
    
function FameHallShow:ctor()
    self.super:ctor()
    self.roots = {}
	app.load("client.home.fame.FameHallList")
	
    -- Initialize FameHall page state machine.
    local function init_fame_hall_show_terminal()
		
		local fame_hall_show_sort_by_fighting_terminal = {
            _name = "fame_hall_show_sort_by_fighting",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				
				instance.listViewOne:setVisible(true)
				instance.listViewTwo:setVisible(false)
				
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_4_100"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_5_100"):setVisible(false)
				if instance.isRegisterOne == true then
					if instance.onUpdateDrawOne ~= nil then
						instance:onUpdateDrawOne()
					end
				else
					local function responseStartCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node.onUpdateDrawOne ~= nil then
								response.node:onUpdateDrawOne()
								instance.isRegisterOne = true
							end
							
						end
					end
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						if _ED.charts.force ~= "" and _ED.charts.force ~= nil then
							responseStartCallback({RESPONSE_SUCCESS = true , PROTOCOL_STATUS = 0,node = instance})
						else
							protocol_command.search_order_list.param_list = "2"
							NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, instance, responseStartCallback, false, nil)
						end						
					else
						protocol_command.search_order_list.param_list = "2"
						NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, instance, responseStartCallback, false, nil)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		local fame_hall_show_sort_by_level_terminal = {
            _name = "fame_hall_show_sort_by_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				
				instance.listViewOne:setVisible(false)
				instance.listViewTwo:setVisible(true)
				
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_5_100"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_4_100"):setVisible(false)
				
				if instance.isRegisterTwo == true then
					if instance.onUpdateDrawTwo ~= nil then
						instance:onUpdateDrawTwo()
					end
				else
					local function responseStartCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node.onUpdateDrawTwo ~= nil then
								
								response.node:onUpdateDrawTwo()
								response.node.isRegisterTwo = true
							end
						end
					end
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						if _ED.charts.user_level ~= "" and _ED.charts.user_level ~= nil then
							responseStartCallback({RESPONSE_SUCCESS = true , PROTOCOL_STATUS = 0,node = instance})
						else
							protocol_command.search_order_list.param_list = "3"
							NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, instance, responseStartCallback, false, nil)
						end
					else
						protocol_command.search_order_list.param_list = "3"
						NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, instance, responseStartCallback, false, nil)						
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local fame_hall_ranking_show_close_terminal = {
            _name = "fame_hall_ranking_show_close",
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

		state_machine.add(fame_hall_ranking_show_close_terminal)
		state_machine.add(fame_hall_show_sort_by_fighting_terminal)
		state_machine.add(fame_hall_show_sort_by_level_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_fame_hall_show_terminal()
end

function FameHallShow.loading(texture)
	if FameHallShow.asyncIndex ~= nil and FameHallShow.asyncIndex > #FameHallShow.tSortedHeroes then
		return
	end	

	local myListView = FameHallShow.myListView
	if myListView ~= nil then
		local cell = FameHallList:createCell()
		if FameHallShow.num == 1 then
			cell:init(_ED.charts.force[FameHallShow.asyncIndex],FameHallShow.asyncIndex,FameHallShow.num)
		else
			cell:init(_ED.charts.user_level[FameHallShow.asyncIndex],FameHallShow.asyncIndex,FameHallShow.num)
		end
		myListView:addChild(cell)
		FameHallShow.asyncIndex = FameHallShow.asyncIndex + 1
		myListView:requestRefreshView()
		FameHallShow.checkEmpty = true
	end
end

function FameHallShow:onUpdateDrawOne()
	
	self.showType = 1
	
	local root = self.roots[1]
	local listView = self.listViewOne
	ccui.Helper:seekWidgetByName(root, "Image_7_100"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_7_0"):setVisible(true)
	
	local status = false
	if #listView:getItems() <= 0 then
		listView:removeAllItems()
		listView:requestRefreshView()
		for i, v in pairs(_ED.charts.force) do
			local cell = FameHallList:createCell()
			cell:init(v,i,1,i)
			listView:addChild(cell)
			if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
				status = true
				self.orderOne = v.order
				ccui.Helper:seekWidgetByName(root, "Text_203_0"):setString(_string_piece_info[2] .. v.order .. _string_piece_info[317])
			end
		end
		self.currentListViewOne = listView
		self.currentInnerContainerOne = listView:getInnerContainer()
		self.currentInnerContainerPosYOne = listView:getInnerContainer():getPositionY()
		if status == false then
			ccui.Helper:seekWidgetByName(root, "Text_203_0"):setString(_string_piece_info[151])
		end
	else
		if self.orderOne ~= nil then
			ccui.Helper:seekWidgetByName(root, "Text_203_0"):setString(_string_piece_info[2] .. self.orderOne .. _string_piece_info[317])
		else
			ccui.Helper:seekWidgetByName(root, "Text_203_0"):setString(_string_piece_info[151])
		end
	end
	
	local recommendFight = tonumber(_ED.user_info.fight_capacity)
	if recommendFight >= 10000 then
		recommendFight = math.floor(recommendFight / 10000).._string_piece_info[150]
	end
	ccui.Helper:seekWidgetByName(root, "Text_204"):setString(recommendFight)
end

function FameHallShow:onUpdateDrawTwo()
	self.showType = 2
	
	local root = self.roots[1]
	local listView = self.listViewTwo
	ccui.Helper:seekWidgetByName(root, "Image_7_100"):setVisible(true)
	ccui.Helper:seekWidgetByName(root, "Image_7_0"):setVisible(false)
	local status = false
	if #listView:getItems() <= 0 then
		listView:removeAllItems()
		listView:requestRefreshView()
		for i, v in pairs(_ED.charts.user_level) do
			local cell = FameHallList:createCell()
			cell:init(v,i,2,i)
			listView:addChild(cell)
			if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
				status = true
				self.orderTwo = v.order
				ccui.Helper:seekWidgetByName(root, "Text_203_0"):setString(_string_piece_info[2] .. v.order .. _string_piece_info[317])
			end
		end
		self.currentListViewTwo = listView
		self.currentInnerContainerTwo = listView:getInnerContainer()
		self.currentInnerContainerPosYTwo = listView:getInnerContainer():getPositionY()
		if status == false then
			ccui.Helper:seekWidgetByName(root, "Text_203_0"):setString(_string_piece_info[151])
		end
	else
		if self.orderTwo ~=nil then
			ccui.Helper:seekWidgetByName(root, "Text_203_0"):setString(_string_piece_info[2] .. self.orderTwo .. _string_piece_info[317])
		else
			ccui.Helper:seekWidgetByName(root, "Text_203_0"):setString(_string_piece_info[151])
		end
	end
	ccui.Helper:seekWidgetByName(root, "Text_204"):setString(_ED.user_info.user_grade)
end

function FameHallShow:onUpdate(dt)
	if self.currentListViewOne ~= nil and self.currentInnerContainerOne ~= nil then
		if self.showType == 1 then
			local size = self.currentListViewOne:getContentSize()
			local posY = self.currentInnerContainerOne:getPositionY()
			local items = self.currentListViewOne:getItems()	
			if self.currentInnerContainerPosYOne == posY then
				return
			end
			self.currentInnerContainerPosYOne = posY
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
	
	if self.currentListViewTwo ~= nil and self.currentListViewTwo ~= nil then
		if self.showType == 2 then
			local size = self.currentListViewTwo:getContentSize()
			local posY = self.currentInnerContainerTwo:getPositionY()
			local items = self.currentListViewTwo:getItems()		
			if self.currentInnerContainerPosYTwo == posY then
				return
			end
			self.currentInnerContainerPosYTwo = posY
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
end

function FameHallShow:onEnterTransitionFinish()
	local csbFameHallHead = csb.createNode("system/famous_rank.csb")
	self:addChild(csbFameHallHead)
	local root = csbFameHallHead:getChildByName("root")
	table.insert(self.roots, root)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_138"), nil, 
	{
		terminal_name = "fame_hall_ranking_show_close", 
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	self.listViewOne = ccui.Helper:seekWidgetByName(root, "ListView_104")
	self.listViewTwo = ccui.Helper:seekWidgetByName(root, "ListView_104_1")
	
	local Button_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_298"), nil, {terminal_name = "fame_hall_show_sort_by_fighting", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local Button_3 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_299"), nil, {terminal_name = "fame_hall_show_sort_by_level", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	state_machine.excute("fame_hall_show_sort_by_fighting", 0, "fame_hall_show_sort_by_fighting.")
end


function FameHallShow:onExit()
	if fwin:find("HeroPatchListViewClass") ~= nil then
		HeroPatchListView.myListView = nil
		HeroPatchListView.asyncIndex = 1
	end
	state_machine.remove("fame_hall_ranking_show_close")
	state_machine.remove("fame_hall_show_sort_by_fighting")
	state_machine.remove("fame_hall_show_sort_by_level")
	cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
end

