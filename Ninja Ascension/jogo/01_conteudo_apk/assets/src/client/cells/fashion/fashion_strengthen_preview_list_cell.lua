--------------------------------------------------------------------------------------------------------------
--  说明：时装强化预览list
--------------------------------------------------------------------------------------------------------------
FashionStrengthenPreviewListCell = class("FashionStrengthenPreviewListCellClass", Window)
FashionStrengthenPreviewListCell.__size = nil
-- fashion_strengthen_preview_list_cell

function FashionStrengthenPreviewListCell:ctor()
    self.super:ctor()
	self.roots = {}

	-- Initialize FashionStrengthenPreviewListCell state machine.
    local function init_fashion_strengthen_preview_list_cell_terminal()

    end
    -- -- call func init FashionStrengthenPreviewListCell state machine.
    init_fashion_strengthen_preview_list_cell_terminal()

end


function FashionStrengthenPreviewListCell:onUpdateDraw()
	local  root = self.roots[1]
	if root == nil then
		return
	end 
	local Text_12323 = ccui.Helper:seekWidgetByName(root, "Text_12323")
	local talentId = dms.atoi(self.example,equipment_fashion_talent.talent_id)
	local talentMould = dms.element(dms["talent_mould"],tonumber(talentId))
    local name = dms.atos(talentMould,talent_mould.talent_name)
    local describe = dms.atos(talentMould,talent_mould.talent_describe)
    Text_12323:setString("["..name.."] "..describe)
	-- 
	local equipGrade = tonumber(self.equipGrade)
	if dms.atoi(self.example,equipment_fashion_talent.need_lv) <= equipGrade then
		Text_12323:setColor(cc.c3b(218, 52, 41))
	else
		Text_12323:setColor(cc.c3b(80, 29, 0))
	end
	

end

function FashionStrengthenPreviewListCell:onEnterTransitionFinish()

end

function FashionStrengthenPreviewListCell:onInit()

 	local root = cacher.createUIRef("fashionable_dress/fashionable_qianghua_yl_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	if FashionStrengthenPreviewListCell.__size == nil then
		FashionStrengthenPreviewListCell.__size = root:getChildByName("Panel_2"):getContentSize()
	end	
	self:onUpdateDraw()

end

function FashionStrengthenPreviewListCell:onExit()
	cacher.freeRef("fashionable_dress/fashionable_qianghua_yl_list.csb", self.roots[1])
end

function FashionStrengthenPreviewListCell:init(example,equipGrade,index)
	self.example = example
	self.equipGrade = equipGrade
	self.index = index
	if index < 5 then
		self:onInit()
	end
	self:setContentSize(FashionStrengthenPreviewListCell.__size)
end

function FashionStrengthenPreviewListCell:reload()

	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function FashionStrengthenPreviewListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("fashionable_dress/fashionable_qianghua_yl_list.csb", root)

	root:removeFromParent(false)
	self.roots = {}
end

function FashionStrengthenPreviewListCell:createCell()
	local cell = FashionStrengthenPreviewListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end