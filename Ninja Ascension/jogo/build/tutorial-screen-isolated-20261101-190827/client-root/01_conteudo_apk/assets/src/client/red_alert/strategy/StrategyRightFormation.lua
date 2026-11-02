--------------------------------------------------
--攻略非跳转子界面
--------------------------------------------------
StrategyRightFormation = class("StrategyRightFormationClass", Window)
    
function StrategyRightFormation:ctor()
    self.super:ctor()
    self.roots = {}
    self.index = 0
end

function StrategyRightFormation:onUpdateDraw()
	local root = self.roots[1]
	-- 名字
	local fun_param_id = dms.string(dms["strategy_param"], self.index, strategy_param.fun_param_id)
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	Text_name:setString(fun_param_id)
	-- 星级
	local pic = dms.int(dms["strategy_param"], self.index, strategy_param.pic)
	local Image_star_5 = ccui.Helper:seekWidgetByName(root, "Image_star_5")
	local Panel_star_5 = ccui.Helper:seekWidgetByName(root, "Panel_star_5")
	Image_star_5:setVisible(false)
	Panel_star_5:setVisible(false)
	if tonumber(pic) == 2 then 
		Panel_star_5:setVisible(true)
	elseif tonumber(pic) == 3 then
		Image_star_5:setVisible(true)
	end
	local dialogue = dms.string(dms["strategy_param"], self.index, strategy_param.dialogue)		--Icon,名字,品质
	local formations = zstring.split(dialogue, "|")
	for v=1,5 do
		local qualityPanel = ccui.Helper:seekWidgetByName(root, "Panel_icon_box_"..v)
		local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_icon_"..v)
		local nameText = ccui.Helper:seekWidgetByName(root, "Text_name_"..v)
		headPanel:setVisible(false)
		qualityPanel:setVisible(false)
		nameText:setVisible(false)
		if v <= #formations then
			local infos = zstring.split(formations[v], ",")
			headPanel:setVisible(true)
			qualityPanel:setVisible(true)
			nameText:setVisible(true)
			nameText:setString(infos[2])
			local quality = tonumber(infos[3]) + 1
			nameText:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
			headPanel:setBackGroundImage(string.format("images/ui/props/props_%d.png", infos[1]))
			qualityPanel:setBackGroundImage(string.format("images/ui/quality/hero_icon_quality_%d.png", quality - 1))
		end
	end
end

function StrategyRightFormation:onEnterTransitionFinish()
	local csbStrategyRightFormation = csb.createNode(config_csb.system.raiders_xzs_right_list_xr)
	self:addChild(csbStrategyRightFormation)
	local root = csbStrategyRightFormation:getChildByName("root")
	table.insert(self.roots, root)
	self:setContentSize(root:getContentSize())
	self:onUpdateDraw()
end

function StrategyRightFormation:init(index)
	self.index = index
end

function StrategyRightFormation:createCell()
	local cell = StrategyRightFormation:new()
	cell:registerOnNodeEvent(cell)
	return cell
end