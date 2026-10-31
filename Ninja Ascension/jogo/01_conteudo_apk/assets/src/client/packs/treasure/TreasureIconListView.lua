----------------------------------------------------------------------------------------------------
-- 说明：装备图标列表
-- 创建时间
-- 作者：杨晗
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
TreasureIconListView = class("TreasureIconListViewClass", Window)
--打开界面
local treasure_icon_listView_open_terminal = {
    _name = "treasure_icon_listView_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local _TreasureListView = TreasureIconListView:new()
    	_TreasureListView:init()
    	fwin:open(_TreasureListView,fwin._viewdialog)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local treasure_icon_listView_close_terminal = {
    _name = "treasure_icon_listView_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:close(fwin:find("TreasureIconListViewClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(treasure_icon_listView_open_terminal)
state_machine.add(treasure_icon_listView_close_terminal)
state_machine.init()
function TreasureIconListView:ctor()
    self.super:ctor()
	self.roots = {}

	self.lastcell = nil
	self.treasuresort = {}
	self.listview = nil
	self.listviewContainerPosY = nil
	self.pageshowindex = 1
	---------------------------------------------------------------------------
    local function init_treasure_icon_list_view_terminal()
    	--排序
		local treasure_icon_listView_sort_terminal = {
            _name = "treasure_icon_listView_sort",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	instance:getSortedTreasure()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--设置底框
		local treasure_icon_listview_set_index_terminal = {
            _name = "treasure_icon_listview_set_index",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	if tonumber(cell.treasure_instance.equipment_type ) == 8 and ( instance.pageshowindex == 2 or instance.pageshowindex == 3 )then
            		TipDlg.drawTextDailog(_string_piece_info[382])
            		return
            	end
            	instance:setIconIndex(cell)
            	state_machine.excute("treasure_refine_update_for_icon",0,cell.treasure_instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--第一次进入时设置底框和listview位置
		local treasure_icon_listview_first_set_index_terminal = {
            _name = "treasure_icon_listview_first_set_index",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:firstIconIndex(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --得到当前管理类的当前页面，1、信息、2升级、3精炼
        local treasure_icon_listview_get_contropage_terminal = {
            _name = "treasure_icon_listview_get_contropage",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance.pageshowindex = params
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新某个icon状态
        local treasure_icon_listview_update_listview_terminal = {
            _name = "treasure_icon_listview_update_listview",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:updatelistIconDraw(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --移除升级用到的材料
		local treasure_icon_list_view_remove_cell_terminal = {
			_name = "treasure_icon_list_view_remove_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
        		for i, v in pairs(params) do
					instance:removeCellByTreasureId(v.user_equiment_id)
				end	
				state_machine.excute("treasure_icon_listView_sort",0,"")
				return true
			end,
            _terminal = nil,
            _terminals = nil
		}
		state_machine.add(treasure_icon_listview_set_index_terminal)
		state_machine.add(treasure_icon_listView_sort_terminal)
		state_machine.add(treasure_icon_listview_first_set_index_terminal)
		state_machine.add(treasure_icon_listview_update_listview_terminal)
		state_machine.add(treasure_icon_listview_get_contropage_terminal)
		state_machine.add(treasure_icon_list_view_remove_cell_terminal)
        state_machine.init()
    end
    
    init_treasure_icon_list_view_terminal()
end
function TreasureIconListView:removeCellByTreasureId(TreasureId)
	local items = self.listview:getItems()
	for i, v in pairs(items) do
		if v.treasure_instance.user_equiment_id == TreasureId then
			self.listview:removeItem(self.listview:getIndex(v))
		end
	end
	self.listview:requestRefreshView()
end
function TreasureIconListView:setIconIndex(cell)
	if self.lastcell ~= nil then
		self.lastcell:setSelected(false)
		self.lastcell.isshow = false
	end
	cell:setSelected(true)
	cell.isshow = true
	self.lastcell = cell
end

function TreasureIconListView:updatelistIconDraw(treasure)
	local items = self.listview:getItems()
	for i,v in pairs(items) do
		if v.treasure_instance == treasure then
			v:onUpdateDraw()
			break
		end
	end
end

function TreasureIconListView:firstIconIndex(treasure_instance)
	--todo 设置第一次的底框 和listvew位置
	local items = self.listview:getItems()
	local index = 1
	local itemsnumber = #items
	local height = 0
	for i,v in pairs(items) do
		if v.treasure_instance == treasure_instance then
			v:setSelected(true)
			v.isshow = true
			self.lastcell = v
			index = i 
			height = v:getContentSize().height
			break
		end
	end
	self.listview:getInnerContainer():setPositionY((index-1)*height)
end

function TreasureIconListView:updateDraw()
	local root = self.roots[1]
	local listview = ccui.Helper:seekWidgetByName(root,"ListView_equ_icon_list")
	listview:removeAllItems()
	app.load("client.cells.treasure.treasure_icon_list_cell")
	for i,v in pairs(self.treasuresort) do
		local cell = TreasureIconListCell:createCell()
		cell:init(v,i)
		listview:addChild(cell)
	end
	self.listview = listview
	self.listviewContainerPosY = listview:getInnerContainer():getPositionY()
end
function TreasureIconListView:getSortedTreasure()
	local dTreasureArray={}
	--得到宝物数组
	local function getTrArray()
		local pIndex = 1
		for i, trInfo in pairs(_ED.user_equiment) do
			if tonumber(trInfo.equipment_type) > 3  and tonumber(trInfo.equipment_type) < 6 or tonumber(trInfo.equipment_type) == 8 then
				dTreasureArray[pIndex]=trInfo
				pIndex = pIndex + 1
			end
		end
	end
	
	local userTrSortFunc = function(a,b)
		--获取品质
		local aq = dms.int(dms["equipment_mould"], tonumber(a.user_equiment_template), equipment_mould.grow_level)
		local bq = dms.int(dms["equipment_mould"], tonumber(b.user_equiment_template), equipment_mould.grow_level)
		--是否装备
		local ae=tonumber(a.ship_id)
		local be=tonumber(b.ship_id)
		--装备类型
		local at = dms.int(dms["equipment_mould"], tonumber(a.user_equiment_template), equipment_mould.equipment_type)
		local bt = dms.int(dms["equipment_mould"], tonumber(b.user_equiment_template), equipment_mould.equipment_type)
		--获取品级
		local ar = dms.int(dms["equipment_mould"], tonumber(a.user_equiment_template), equipment_mould.rank_level)	
		local br = dms.int(dms["equipment_mould"], tonumber(b.user_equiment_template), equipment_mould.rank_level)	
		--获取等级
		local ag = tonumber(a.user_equiment_grade)
		local bg = tonumber(b.user_equiment_grade)
		
		
		local result = false
		
		if ( ae>0 and 
			(
				((be>0) and (aq>bq)) 
				or (((be > 0) and (aq>bq)) 
				or ((be > 0) and (aq==bq) and (ag > bg)) 
				or ((be > 0) and (aq==bq) and (ag==bg) and (ar > br)) 
				or ((be > 0) and (aq==bq) and (ag==bg) and (ar == br) and (at > bt)) )
				or (be <= 0) 
				or (aq>bq)
				or ((aq==bq)and (ag > bg))
				or ((aq==bq)and (ag==bg) and (ar > br)) 
				or ((aq==bq)and (ag==bg) and (ar == br) and (at > bt)) 
			)
		) then
			result = true
		elseif( ae<=0 and (
			((be <= 0) and (aq>bq))
			or ((be <= 0) and (aq>bq))
			or ((be <= 0) and (aq == bq) and (ag>bg))
			or ((be <= 0) and (aq == bq) and (ag==bg) and (ar>br))
			or ((be <= 0) and (aq == bq) and (ag==bg) and (ar==br) and (at > bt))
		) 
		) then
			result = true
		end
		
		return result 
	end
	
	getTrArray()
	table.sort(dTreasureArray, userTrSortFunc)
	self.treasuresort = dTreasureArray
end

function TreasureIconListView:onUpdate(dt)
	if self.listview ~= nil and self.listviewContainerPosY ~= nil then
		local size = self.listview:getContentSize()
		local posY = self.listview:getInnerContainer():getPositionY()
		if self.listviewContainerPosY == posY then
			return
		end
		self.listviewContainerPosY = posY
		local items = self.listview:getItems()
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

function TreasureIconListView:onEnterTransitionFinish()
    local csbTreasureIconListView = csb.createNode("packs/EquipStorage/equipment_icon_list.csb")
	self:addChild(csbTreasureIconListView)

	local root = csbTreasureIconListView:getChildByName("root")
	table.insert(self.roots, root)
	state_machine.excute("treasure_icon_listView_sort",0,"")
	self:updateDraw()
end

function TreasureIconListView:init()

end

function TreasureIconListView:onExit()
	state_machine.remove("treasure_icon_listView_sort")
	state_machine.remove("treasure_icon_listview_set_index")
	state_machine.remove("treasure_icon_listview_first_set_index")
	state_machine.remove("treasure_icon_listview_update_listview")
	state_machine.remove("treasure_icon_listview_get_contropage")
	state_machine.remove("treasure_icon_list_view_remove_cell")
end
