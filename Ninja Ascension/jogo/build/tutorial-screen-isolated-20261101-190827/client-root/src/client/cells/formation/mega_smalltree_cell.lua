-- ----------------------------------------------------------------------------------------------------
-- 说明：超进化小阶数cell
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MegaSmalltreeCell = class("MegaSmalltreeCellClass", Window)
    
function MegaSmalltreeCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.isdram =false
end


function MegaSmalltreeCell:onUpdateDraw(curidex)
    self.curidex=curidex
    if not self.roots[1] then return end
    if curidex  >= self.idex then
    	local Image_basis = ccui.Helper:seekWidgetByName(self.roots[1],"Image_basis")
        Image_basis:setVisible(true)
        local jsonFile = "images/ui/effice/spirte_neiyijihuo/spirte_neiyijihuo.json"      --激活光效
	    local atlasFile = "images/ui/effice/spirte_neiyijihuo/spirte_neiyijihuo.atlas"
	    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	    local Panel_evolution_effect = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_evolution_effect")
        Panel_evolution_effect:removeAllChildren(true) 
        Panel_evolution_effect:addChild(animation)
	end
end

function MegaSmalltreeCell:onUpdateSwitch(curidex)
    self._pendingSwitchIndex=curidex
    if not self.roots[1] then return end
	local Image_click = ccui.Helper:seekWidgetByName(self.roots[1],"Image_click")
	local Panel_evolution_effect = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_evolution_effect")
	if curidex == self.idex -1  then
		Image_click:setVisible(true)
		local jsonFile = "images/ui/effice/spirte_neiweijihuoxz/spirte_neiweijihuoxz.json"      --正在激活光效
	    local atlasFile = "images/ui/effice/spirte_neiweijihuoxz/spirte_neiweijihuoxz.atlas"
	    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	    local Panel_evolution_effect = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_evolution_effect")
        Panel_evolution_effect:removeAllChildren(true) 
        Panel_evolution_effect:addChild(animation)
	else
		Image_click:setVisible(false)
		Panel_evolution_effect:removeAllChildren(true) 
	end
end


function MegaSmalltreeCell:onEnterTransitionFinish()
	local csbMegaSmalltreeCell = csb.createNode("packs/HeroStorage/sm_role_evolution_unlock_icon_cell.csb")
    local root = csbMegaSmalltreeCell:getChildByName("root")
    table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)
	self:onUpdateDraw(self.curidex)
    if self._pendingSwitchIndex then self:onUpdateSwitch(self._pendingSwitchIndex) end
end

function MegaSmalltreeCell:onExit()
	
end

function MegaSmalltreeCell:init(curidex,idex)
	self.curidex = curidex
	self.idex = idex
end


function MegaSmalltreeCell:createCell()
	local cell = MegaSmalltreeCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end