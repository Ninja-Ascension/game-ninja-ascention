----------------------------------------------------------------------------------------------------
-- 说明：时装信息界面下滑列(基础信息)
-------------------------------------------------------------------------------------------------------

FashionInfoBasicsListCell = class("FashionInfoBasicsListCellClass", Window)
-- fashion_info_basics_list_cell

function FashionInfoBasicsListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipmentId = nil 
	local function init_fashion_info_basics_list_cell_terminal()

	end
	init_fashion_info_basics_list_cell_terminal()


end

function FashionInfoBasicsListCell:onEnterTransitionFinish()
	local FashionInfoBasicsListCell = csb.createNode("packs/EquipStorage/equipment_information_list_5.csb")
	local root = FashionInfoBasicsListCell:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local MySize = ccui.Helper:seekWidgetByName(root, "Panel_3"):getContentSize()
	self:setContentSize(MySize)


	local equipProperty = dms.string(dms["equipment_mould"],self.equipmentId,equipment_mould.initial_value)
    local initialValue = zstring.split(equipProperty,"|")

  
    for i,v in pairs(initialValue) do
        if i>3 then
            break
        end
        local influenceType = zstring.split(v,",")      --每一种属性
        if table.getn(influenceType) >= 2 then 
            local _pType = tonumber(influenceType[1])
            local _pValue = tonumber(influenceType[2])
            if i==1 then
               ccui.Helper:seekWidgetByName(root, "Text_shuxin_4"):setString(_influence_type[_pType+1])
                if _pType >= 4 then
                    ccui.Helper:seekWidgetByName(root, "Text_shuxin_5"):setString("+".._pValue.."%")
                else
                    ccui.Helper:seekWidgetByName(root, "Text_shuxin_5"):setString("+".._pValue)
                end
            elseif i==2 then
                ccui.Helper:seekWidgetByName(root, "Text_shuxin_6"):setString(_influence_type[_pType+1])
                if _pType >= 4 then
                    ccui.Helper:seekWidgetByName(root, "Text_shuxin_7"):setString("+".._pValue.."%")
                else
                    ccui.Helper:seekWidgetByName(root, "Text_shuxin_7"):setString("+".._pValue)
                end
            end
        end
    end

end

function FashionInfoBasicsListCell:onExit()
end

function FashionInfoBasicsListCell:init(equipmentId)
	self.equipmentId = equipmentId
end

function FashionInfoBasicsListCell:createCell()
	local cell = FashionInfoBasicsListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end