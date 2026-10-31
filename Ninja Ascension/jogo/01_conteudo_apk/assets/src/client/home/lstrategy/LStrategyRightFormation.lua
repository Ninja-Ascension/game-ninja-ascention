
LStrategyRightFormation = class("LStrategyRightFormationClass", Window)
    
function LStrategyRightFormation:ctor()
    self.super:ctor()
    self.roots = {}
    self.index = 0
	self.functionId = 0
end

function LStrategyRightFormation:onUpdateDraw()
	local root = self.roots[1]
	local describe = dms.string(dms["function_param"], self.functionId, function_param.describe)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local describeInfo = ""
        local describeData = zstring.split(describe, "|")
        for i, v in pairs(describeData) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            describeInfo = describeInfo .. word_info[3]
        end
        
        describe = describeInfo
    end
	ccui.Helper:seekWidgetByName(root, "Text_miaoshu"):setString(describe)
	if tipStringInfo_strategy_formation ~= nil then
		for k,v in pairs(tipStringInfo_strategy_formation) do
			if tonumber(v[1]) == tonumber(self.functionId) then
				local formations = zstring.split(v[2], "|")
				for i=1,4 do
					local qualityPanel = ccui.Helper:seekWidgetByName(root, "Panel_icon_box_"..i)
					local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_icon_"..i)
					local nameText = ccui.Helper:seekWidgetByName(root, "Text_name_"..i)
					headPanel:setVisible(false)
					qualityPanel:setVisible(false)
					nameText:setVisible(false)
					if i <= #formations then
						local infos = zstring.split(formations[i], ",")
						headPanel:setVisible(true)
						qualityPanel:setVisible(true)
						nameText:setVisible(true)
						nameText:setString(infos[2])
						local quality = tonumber(infos[3]) + 1
						nameText:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
						headPanel:setBackGroundImage(string.format("images/ui/props/props_%d.png", infos[1]))
						if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
							qualityPanel:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
						else
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
								qualityPanel:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
							else
								qualityPanel:setBackGroundImage(string.format("images/ui/quality/icon_hero_%d.png", quality))
							end
						end
					end
				end
			end
		end
	end
end

function LStrategyRightFormation:onEnterTransitionFinish()
	local csbStrategyRightFormation = csb.createNode("system/raiders_xzs_right_list_xr.csb")
	self:addChild(csbStrategyRightFormation)
	local root = csbStrategyRightFormation:getChildByName("root")
	table.insert(self.roots, root)
	self:setContentSize(root:getContentSize())
	self:onUpdateDraw()
end

function LStrategyRightFormation:init(index, functionId)
	self.index = index
	self.functionId = functionId
end

function LStrategyRightFormation:createCell()
	local cell = LStrategyRightFormation:new()
	cell:registerOnNodeEvent(cell)
	return cell
end