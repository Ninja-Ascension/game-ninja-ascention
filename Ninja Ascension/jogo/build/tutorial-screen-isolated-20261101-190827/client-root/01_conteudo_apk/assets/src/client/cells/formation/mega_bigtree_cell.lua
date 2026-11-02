-- ----------------------------------------------------------------------------------------------------
-- 说明：超进化大阶数cell
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MegaBigtreeCell = class("MegaBigtreeCellClass", Window)
    
function MegaBigtreeCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.isdram =false
end


function MegaBigtreeCell:onUpdateDraw(curpage,num,curidex)
    self._pendingDraw={curpage,num}
    if curidex then self.curidex=curidex end
    if not self.roots[1] then return end
	local Panel_evolution_lock = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_evolution_lock")
	if curidex then
	   self.curidex = curidex
	end
    if self.curidex then
    	local Panel_evolution_schedule = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_evolution_schedule")
        Panel_evolution_schedule:setVisible(true)
        self.circleProgressBar:setPercentage(self.curidex*10)
	    local jsonFile = "images/ui/effice/spirte_yijihuo/spirte_yijihuo.json"      --激活光效
	    local atlasFile = "images/ui/effice/spirte_yijihuo/spirte_yijihuo.atlas"
	    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		Panel_evolution_schedule:removeAllChildren(true) 
		Panel_evolution_schedule:addChild(animation)
		Panel_evolution_lock:setBackGroundImage(string.format("images/ui/text/evolution/number_evolution_0%d.png", self.page))
	 else
	    Panel_evolution_lock:setBackGroundImage("images/ui/text/evolution/icon_lock.png")
	end
	if not curpage then
		return
	end
	if self.page == curpage + 1 and self.page <= num then
		local Panel_evolution_schedule = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_evolution_schedule")
        Panel_evolution_schedule:setVisible(true)
	    local jsonFile = "images/ui/effice/spirte_yijihuo/spirte_yijihuo.json"      --激活光效
	    local atlasFile = "images/ui/effice/spirte_yijihuo/spirte_yijihuo.atlas"
	    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		Panel_evolution_schedule:removeAllChildren(true) 
		Panel_evolution_schedule:addChild(animation)
	end
end


function MegaBigtreeCell:onUpdateSwitch(switchpage)
    self._pendingSwitchPage=switchpage
    if not self.roots[1] then return end
	local Image_click = ccui.Helper:seekWidgetByName(self.roots[1],"Image_click")
	local Panel_evolution_schedule_open = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_evolution_schedule_open")
	if switchpage == self.page  then
		Image_click:setVisible(true)
		Panel_evolution_schedule_open:setVisible(true)
		local jsonFile = "images/ui/effice/spirte_weijihuoxz/spirte_weijihuoxz.json"      --待激活光效
	    local atlasFile = "images/ui/effice/spirte_weijihuoxz/spirte_weijihuoxz.atlas"
	    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	          Panel_evolution_schedule_open:removeAllChildren(true) 
	          Panel_evolution_schedule_open:addChild(animation)
	else
		Image_click:setVisible(false)
		Panel_evolution_schedule_open:removeAllChildren(true) 
	end
end


function MegaBigtreeCell:onEnterTransitionFinish()
	local csbMegaBigtreeCell = csb.createNode("packs/HeroStorage/sm_role_evolution_activation_icon_cell.csb")
    local root = csbMegaBigtreeCell:getChildByName("root")
    table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)

    local Panel_light_ing = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_light_ing") 
    Panel_light_ing:setVisible(true)
    local Sprite_light_ing =  Panel_light_ing:getChildByName("Sprite_light_ing")
    Sprite_light_ing:setVisible(false)
    self.circleProgressBar = cc.ProgressTimer:create(Sprite_light_ing)
    --设置类型
    self.circleProgressBar:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    self.circleProgressBar:setAnchorPoint(cc.p(0.5, 0.5))
    self.circleProgressBar:setPosition(50,50)
    Panel_light_ing:addChild(self.circleProgressBar)  
	self.circleProgressBar:setPercentage(0)
	
	local jsonFile = "images/ui/effice/spirte_weijihuo/spirte_weijihuo.json"      --未激活光效
    local atlasFile = "images/ui/effice/spirte_weijihuo/spirte_weijihuo.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    local Panel_evolution_schedule = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_evolution_schedule") 
          Panel_evolution_schedule:removeAllChildren(true) 
          Panel_evolution_schedule:addChild(animation)
	self:onUpdateDraw(self._pendingDraw and self._pendingDraw[1],self._pendingDraw and self._pendingDraw[2])
    if self._pendingSwitchPage then self:onUpdateSwitch(self._pendingSwitchPage) end
end

function MegaBigtreeCell:onExit()
	
end

function MegaBigtreeCell:init(curidex,page)
	self.curidex = curidex
	self.page = page
end


function MegaBigtreeCell:createCell()
	local cell = MegaBigtreeCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end