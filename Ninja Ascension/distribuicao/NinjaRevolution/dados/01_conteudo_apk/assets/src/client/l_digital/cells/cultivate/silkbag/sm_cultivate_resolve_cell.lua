---------------------------------
---锦囊分解cell
---------------------------------
SmCultivateResolvecell = class("SmCultivateResolvecellClass", Window)
SmCultivateResolvecell.__size = nil

function SmCultivateResolvecell:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self._silkInfo = nil
	self._isSelect = false

    local function init_sm_cultivate_resolve_cell_terminal()
    end
    
    init_sm_cultivate_resolve_cell_terminal()
end


function SmCultivateResolvecell:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self.CheckBox_xuanze = ccui.Helper:seekWidgetByName(root, "CheckBox_xuanze")
	self.Panel_renju = ccui.Helper:seekWidgetByName(root, "Panel_renju")
	-- 名称
	local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	local silkbag_name_id = dms.int(dms["ship_silk_bag_mould"], self._silkInfo.info.silkBagMouldId, ship_silk_bag_mould.silkbag_name)
    local silkbag_name_word = dms.element(dms["word_mould"], silkbag_name_id)
    local name = silkbag_name_word[3]
	Text_1:setString(name)
	-- 基础属性
	local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
	local Text_5_0 = ccui.Helper:seekWidgetByName(root, "Text_5_0")
	local Text_5_1 = ccui.Helper:seekWidgetByName(root, "Text_5_1")
	local baseContral = {Text_5,Text_5_0,Text_5_1}
	local property_info = self._silkInfo.info.addBaseProperty
	if nil ~= property_info then
        local add_property_info = zstring.split(property_info, "|")
        for i = 1, table.nums(add_property_info) do
            local add_property_per = zstring.split(add_property_info[i], ",")
            if nil ~= add_property_per then
				local property_value = add_property_per[2]
				if baseContral[i] then 
					baseContral[i]:setString(property_value)
				end
            end
        end
    end
end


function SmCultivateResolvecell:refreshCheckBox()
	local function onOpenTouchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			if self._isSelect then 
				-- 不选
				self.CheckBox_xuanze:setSelected(true)
				self._isSelect = false
			else
				-- 选中
				self.CheckBox_xuanze:setSelected(false)
				self._isSelect = true
			end
			state_machine.excute("silkbag_fast_resolve_select_refresh",0,{self._silkInfo.info.id,self._isSelect})
        end
	end

	if self._isSelect == true then 
		self.CheckBox_xuanze:setSelected(true)
	else
		self.CheckBox_xuanze:setSelected(false)
	end
	
	self.CheckBox_xuanze:addTouchEventListener(onOpenTouchEvent)
end

--锦囊图标的绘制
function SmCultivateResolvecell:drawSilkIcon()
    self.Panel_renju:removeAllChildren(true)
    local cell = ResourcesIconCell:createCell()
    local level = self._silkInfo.info.level
    local property_info = self._silkInfo.info.addBaseProperty
    local silkMouldId = self._silkInfo.info.silkBagMouldId
    local basePropertyList = {}
    if nil ~= property_info then
        local add_property_info = zstring.split(property_info, "|")
        for i = 1, table.nums(add_property_info) do
            local add_property_per = zstring.split(add_property_info[i], ",")
            if nil ~= add_property_per then
                local a = tipStringInfo_rescue_silkbag_property["0"]
                local baseProperty = {}
                baseProperty.property_name = tipStringInfo_rescue_silkbag_property[tostring(add_property_per[1])]
                baseProperty.property_value = add_property_per[2]
                basePropertyList[i] = baseProperty
            end
        end
    end

    cell:init(71, -1, silkMouldId, nil, nil, true, true, 0, {basePropertyList, level})
    self.Panel_renju:addChild(cell)
end


function SmCultivateResolvecell:onEnterTransitionFinish()

end

function SmCultivateResolvecell:onInit()
	local root = cacher.createUIRef("cultivate/silk_bag_break_down_cell.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if SmCultivateResolvecell.__size == nil then
 		SmCultivateResolvecell.__size = root:getContentSize()
 	end

 	
	self:onUpdateDraw()
	self:refreshCheckBox()
	self:drawSilkIcon()
end

function SmCultivateResolvecell:clearUIInfo( ... )
	local root = self.roots[1]
	local Panel_renju = ccui.Helper:seekWidgetByName(root, "Panel_renju")
	if Panel_renju ~= nil then
		Panel_renju:removeAllChildren(true)
	end
end

function SmCultivateResolvecell:onExit()
	self:clearUIInfo()
	cacher.freeRef("cultivate/silk_bag_break_down_cell.csb", self.roots[1])
end

function SmCultivateResolvecell:init(_silkInfo, index)

	self._silkInfo = _silkInfo
	
	self.index = index
	self._isSelect = self._silkInfo.selectState
	if index ~= nil and index < 11 then
		self:onInit()
	end
	self:setContentSize(SmCultivateResolvecell.__size)
	return self
end

function SmCultivateResolvecell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmCultivateResolvecell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("cultivate/silk_bag_break_down_cell.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

function SmCultivateResolvecell:createCell()
	local cell = SmCultivateResolvecell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end