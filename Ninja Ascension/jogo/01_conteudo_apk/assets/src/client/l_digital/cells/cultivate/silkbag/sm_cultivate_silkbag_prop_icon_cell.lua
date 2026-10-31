
-- 说明：锦囊图标绘制
----------------------------------------------------------------------------------------------------
SmCultivateSilkbagPropIconCell = class("SmCultivateSilkbagPropIconCellClass", Window)

function SmCultivateSilkbagPropIconCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.mould_id = nil
	self.show_number = nil
	self.isSelcet = false
	self.tempor_id = nil
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.l_digital.cultivate.silkbag.SilkBagDecompose")
	-- Initialize adventure hero icon cell state machine.
	local function init_silkbag_prop_icon_cell_terminal()
		--打开锦囊详细介绍
		local silkbag_prop_icon_selected_terminal = {
            _name = "init_silkbag_prop_icon_selected",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("silk_bag_decompose_window_open",0,{params._datas.mould_id,params._datas.tempor_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--清除该锦囊
		local silkbag_prop_icon_unload_terminal = {
            _name = "silkbag_prop_icon_unload",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(silkbag_prop_icon_selected_terminal)
		state_machine.add(silkbag_prop_icon_unload_terminal)
        state_machine.init()
	end

	-- call func init adventure hero icon cell state machine.
	init_silkbag_prop_icon_cell_terminal()
end

function SmCultivateSilkbagPropIconCell:updateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local Panel_bg = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	local silkbagQuality = self.quality 
	local cell= ResourcesIconCell:createCell()
	local basePropertyList = {}
	if nil ~= self.property_info then
		local add_property_info = zstring.split(self.property_info,"|")
		for i = 1,table.nums(add_property_info) do
			local add_property_per = zstring.split(add_property_info[i],",")
			if nil ~= add_property_per then
				local a = tipStringInfo_rescue_silkbag_property["0"]
				local baseProperty ={}
				baseProperty.property_name = tipStringInfo_rescue_silkbag_property[tostring(add_property_per[1])]
				baseProperty.property_value = add_property_per[2]
				basePropertyList[i] = baseProperty
			end
		end
	end
	
	cell:init(71,self.show_number,self.mould_id,nil,nil,true,true,0,{basePropertyList,self.level})
	cell:setAnchorPoint(cc.p(0.5, 0.5))
	cell:setPosition(cc.p(Panel_bg:getContentSize().width / 2, Panel_bg:getContentSize().height / 2))


	Panel_bg:addChild(cell)

end

function SmCultivateSilkbagPropIconCell:onInit()
	self.roots = {}
	local root = cacher.createUIRef("icon/item.csb", "root")
 	table.insert(self.roots, root)
	self:addChild(root)
	self:clearUIInfo()
	ccui.Helper:seekWidgetByName(root, "Panel_prop"):setTouchEnabled(true)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"),nil, 
	{
	    terminal_name = "init_silkbag_prop_icon_selected",
	    cell = self,
	    mould_id = self.mould_id,
	    tempor_id = self.tempor_id,       
	    terminal_state = 0, 
	    isPressedActionEnabled = true
	}, 
	nil, 0)
		
	self:updateDraw()
end

function SmCultivateSilkbagPropIconCell:onExit()
	state_machine.remove("init_silkbag_prop_icon_selected")
	state_machine.remove("silkbag_prop_icon_unload")
	self:clearUIInfo()
	cacher.freeRef("icon/item.csb", self.roots[1])
	self.roots = {}
end

function SmCultivateSilkbagPropIconCell:setSelectState(isSelcet)
	self.isSelcet = isSelcet
	self:updateDraw()
end

-- /**
--初始化
-- */
function SmCultivateSilkbagPropIconCell:init(show_number,mould_id,tempor_id,prop_Info)
	self.mould_id = mould_id
	self.show_number = show_number
	self.tempor_id = tempor_id or nil
	self.property_info = prop_Info.addBaseProperty or nil
	self.level = prop_Info.level
	self:onInit()

	return self
end

function SmCultivateSilkbagPropIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmCultivateSilkbagPropIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("icon/item.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

function SmCultivateSilkbagPropIconCell:clearUIInfo( ... )
	local root = self.roots[1]
	local Panel_bg = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	if Panel_bg ~= nil then
		Panel_bg:removeAllChildren(true)
	end
end

function SmCultivateSilkbagPropIconCell:createCell()
	local cell = SmCultivateSilkbagPropIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

