----------------------------------------------------------------------------------------------------
-- 说明：装备图标列表
-- 创建时间
-- 作者：杨晗
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipIconListView = class("EquipIconListViewClass", Window)
--打开界面
local equip_icon_listView_open_terminal = {
    _name = "equip_icon_listView_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local _EquipIconListView = EquipIconListView:new()
    	_EquipIconListView:init()
    	fwin:open(_EquipIconListView,fwin._viewdialog)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local equip_icon_listView_close_terminal = {
    _name = "equip_icon_listView_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:close(fwin:find("EquipIconListViewClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equip_icon_listView_open_terminal)
state_machine.add(equip_icon_listView_close_terminal)
state_machine.init()
function EquipIconListView:ctor()
    self.super:ctor()
	self.roots = {}

	self.lastcell = nil
	self.equipsort = {}
	self.listview = nil
	self.listviewContainerPosY = nil

	---------------------------------------------------------------------------
    local function init_equip_icon_list_view_terminal()
    	--排序
		local equip_icon_listView_sort_terminal = {
            _name = "equip_icon_listView_sort",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	instance:getSortedEquip()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--设置底框
		local equip_icon_listview_set_index_terminal = {
            _name = "equip_icon_listview_set_index",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	instance:setIconIndex(cell)
            	state_machine.excute("equip_strengthen_refine_strorage_to_change_equip",0,cell.equip_instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--第一次进入时设置底框和listview位置
		local equip_icon_listview_first_set_index_terminal = {
            _name = "equip_icon_listview_first_set_index",
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
        --刷新列表。
        local equip_icon_listview_update_listview_terminal = {
            _name = "equip_icon_listview_update_listview",
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
		state_machine.add(equip_icon_listview_set_index_terminal)
		state_machine.add(equip_icon_listView_sort_terminal)
		state_machine.add(equip_icon_listview_first_set_index_terminal)
		state_machine.add(equip_icon_listview_update_listview_terminal)
        state_machine.init()
    end
    
    init_equip_icon_list_view_terminal()
end

function EquipIconListView:setIconIndex(cell)
	if self.lastcell ~= nil then
		self.lastcell:setSelected(false)
		self.lastcell.isshow = false
	end
	cell:setSelected(true)
	cell.isshow = true
	self.lastcell = cell
end

function EquipIconListView:updatelistIconDraw(equip)
	local items = self.listview:getItems()
	for i,v in pairs(items) do
		-- if v.equip_instance == equip then
			v:onUpdateDraw()
		-- 	break
		-- end
	end
end

function EquipIconListView:firstIconIndex(equip_instance)
	--todo 设置第一次的底框 和listvew位置
	local items = self.listview:getItems()
	local index = 1
	local itemsnumber = #items
	local height = 0
	for i,v in pairs(items) do
		if v.equip_instance == equip_instance then
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

function EquipIconListView:updateDraw()
	local root = self.roots[1]
	local listview = ccui.Helper:seekWidgetByName(root,"ListView_equ_icon_list")
	listview:removeAllItems()
	app.load("client.cells.equip.equip_icon_list_cell")
	for i,v in pairs(self.equipsort) do
		local cell = EquipIconListCell:createCell()
		cell:init(v,i)
		listview:addChild(cell)
	end
	self.listview = listview
	self.listviewContainerPosY = listview:getInnerContainer():getPositionY()
end
function EquipIconListView:getSortedEquip()
	local sortEquip = {}
	local swapSortEquip = {}
	for i, equip in pairs(_ED.user_equiment) do
		if equip.user_equiment_id ~= nil then
			-- dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.rank_level)
			if dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.equipment_type) < 4 then
				local temp = equip
				local pos = 1
				for p, v in pairs(sortEquip) do
					if temp ~= nil and (
					(tonumber(equip.ship_id) > 0 and (
							tonumber(v.ship_id) <=0 or
							(dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) < dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.grow_level)) or 
							(dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.rank_level) < dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.rank_level)) or
							(dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.rank_level) == dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.rank_level)and 
							(tonumber(v.user_equiment_grade) < tonumber(equip.user_equiment_grade)))
						)) or
						(tonumber(v.ship_id) <=0 and ((dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) < dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.grow_level)) or 
					(dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.rank_level)< dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.rank_level)) or 
					((dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.rank_level) == dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.rank_level)) and (tonumber(v.user_equiment_grade) < tonumber(equip.user_equiment_grade)))
					))
					) then
						swapSortEquip[pos] = temp
						pos = pos + 1
						temp = nil
					end
					swapSortEquip[pos] = v
					pos = pos + 1
				end
				if temp ~= nil then
					swapSortEquip[pos] = temp
					temp = nil
				end
				sortEquip = nil
				sortEquip = {}
				for t, s in pairs(swapSortEquip) do
					sortEquip[t] = s
				end
				swapSortEquip = nil
				swapSortEquip = {}
			end	
		end
	end
	self.equipsort = sortEquip
end

function EquipIconListView:onUpdate(dt)
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

function EquipIconListView:onEnterTransitionFinish()
    local csbEquipIconListView = csb.createNode("packs/EquipStorage/equipment_icon_list.csb")
	self:addChild(csbEquipIconListView)

	local root = csbEquipIconListView:getChildByName("root")
	table.insert(self.roots, root)
	state_machine.excute("equip_icon_listView_sort",0,"")
	self:updateDraw()
end
function EquipIconListView:close( ... )
	local root = self.roots[1]
	local listview = ccui.Helper:seekWidgetByName(root,"ListView_equ_icon_list")
	listview:removeAllItems()	
end
function EquipIconListView:init()

end

function EquipIconListView:onExit()
	state_machine.remove("equip_icon_listView_sort")
	state_machine.remove("equip_icon_listview_set_index")
	state_machine.remove("equip_icon_listview_first_set_index")
	state_machine.remove("equip_icon_listview_update_listview")
end
