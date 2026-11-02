----------------------------------------------------------------------------------------------------
-- 特殊道具类的封装(金钱,砖石,荣誉等等..)
----------------------------------------------------------------------------------------------------
propMoneyInfo = class("propMoneyInfoClass", Window)

function propMoneyInfo:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.types = nil		-- 当前要绘制的道具实例数据对对象
	app.load("client.cells.prop.prop_money_new_icon")
	
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_prop_money_info_cell_terminal()
		local prop_money_info_cell_terminal = {
            _name = "prop_money_info_cell",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(prop_money_info_cell_terminal)
		
        state_machine.init()
	end
	init_prop_money_info_cell_terminal()
end

function propMoneyInfo:onUpdateDraw()
	local root = self.roots[1]
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_djxx_tx")
	local name = ccui.Helper:seekWidgetByName(root, "Text_djxx_name")
	local describe = ccui.Helper:seekWidgetByName(root, "Text_djxx_ms")
	local Text_have_n = ccui.Helper:seekWidgetByName(root, "Text_have_n")
	local cell = propMoneyNewIcon:createCell()
	cell:init(self.types)
	headPanel:addChild(cell)
	if self.types == "1" then			--银币(钢铝)
		name:setString(_All_tip_string_info._fundName)
		describe:setString(_All_tip_string_info_description._fundNameDescription)
		if nil ~= Text_have_n then
			Text_have_n:setString(_ED.user_info.user_silver)
		end
	elseif self.types == "2" then		--金币(砖石)
		name:setString(_All_tip_string_info._crystalName)
		describe:setString(_All_tip_string_info_description._crystalNameDescription)
		if nil ~= Text_have_n then
			Text_have_n:setString(_ED.user_info.user_gold)
		end
	elseif self.types == "3" then		--声望(威望)
		name:setString(_All_tip_string_info._reputation)
		describe:setString(_All_tip_string_info_description._reputationDescription)
		if nil ~= Text_have_n then
			Text_have_n:setString(_ED.user_info.user_honour)
		end
	elseif self.types == "4" then		--将魂(舰魂)
		name:setString(_All_tip_string_info._hero)
		describe:setString(_supernaturalSoul)
	elseif self.types == "5" then		--魂玉(水雷魂)
		name:setString(_All_tip_string_info._juexingsuipian)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			describe:setString(_All_tip_string_info_description._AwakeningDebrisDescription)
			if nil ~= Text_have_n then
				Text_have_n:setString(_ED.user_info.jade)
			end
		elseif __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge then
			describe:setString(_All_tip_string_info_description._soulJadeNameDescription)
			local quality = 4
			name:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2], color_Type[quality][3]))
		else		
			describe:setString(_All_tip_string_info_description._equip)
		end
	elseif self.types == "6" then		--决斗荣誉(荣誉)
		name:setString(_All_tip_string_info._glories)
		describe:setString(_All_tip_string_info_description._gloriesDescription)
	elseif self.types == "7" then		--叛军战功
		name:setString(_All_tip_string_info._glories)
		describe:setString(_All_tip_string_info_description._exploitDescription)
	elseif self.types == "8" then		--战队经验
		name:setString(_All_tip_string_info._expName)
		describe:setString(_All_tip_string_info_description._expNameDescription)
		if nil ~= Text_have_n then
			Text_have_n:setString(_ED.user_info.user_experience)
		end

	-- 体力
	elseif self.types == "12" then
		name:setString(_All_tip_string_info._energyName)
		describe:setString(_All_tip_string_info_description._energyNameDescription)
		if nil ~= Text_have_n then
			Text_have_n:setString(_ED.user_info.user_food)
		end

	elseif self.types == "18" then --威名
		name:setString(_All_tip_string_info._exploit)
		describe:setString(_All_tip_string_info_description._gloriesDescription)
		if nil ~= Text_have_n then
			Text_have_n:setString(zstring.tonumber(_ED.user_info.all_glories))
		end
	elseif self.types == "28" then
		name:setString(_All_tip_string_info._union_exploit)--
		describe:setString(_All_tip_string_info_description._unionDescription)
		if nil ~= Text_have_n then
			Text_have_n:setString(zstring.tonumber(_ED.union.user_union_info.rest_contribution))
		end
	elseif self.types == "31" then
		name:setString(red_alert_resouce_tip[1][1])--
		describe:setString(red_alert_resouce_tip[1][2])--		--
	elseif self.types == "34" then --天赋点
		name:setString(_my_gane_name[15])--
		describe:setString(_All_tip_string_info_description._talentPointTip)--		--
		if nil ~= Text_have_n then
			Text_have_n:setString(zstring.tonumber(_ED.user_info.talent_point))
		end

	-- VIP经验
	elseif self.types == "39" then
		name:setString(_my_gane_name[17])
		describe:setString(_All_tip_string_info_description._vipExpDescription)
		if nil ~= Text_have_n then
			Text_have_n:setString(_ED.recharge_precious_number)
		end
	elseif self.types == "65" then
		name:setString(_my_gane_name[18])
		describe:setString(_All_tip_string_info_description._mineralDescription)
		if nil ~= Text_have_n then
			Text_have_n:setString(_ED.cross_server_battel_mineral_num)
		end
	elseif self.types == "67" then
		name:setString(_All_tip_string_info._matrix_essence)
		describe:setString(_All_tip_string_info_description._AlloyMatrixJHDescription)
		if nil ~= Text_have_n then
			Text_have_n:setString(_ED.maxtrix_essence_num)
		end

	elseif self.types == "68" then
		name:setString(_All_tip_string_info._explore_money)
		describe:setString(_All_tip_string_info_description._explore_money_description)
		if nil ~= Text_have_n then
			local value = 0 
			if _ED.fileIsland and _ED.fileIsland.searchCoin then
				value = _ED.fileIsland.searchCoin
			end

			Text_have_n:setString(value)
		end

	elseif self.types == "69" then
		name:setString(_All_tip_string_info._holy_essence)
		describe:setString(_All_tip_string_info_description._holy_essence_description)
		if nil ~= Text_have_n then
			local value = 0 
			if _ED.fileIsland and _ED.fileIsland.holy_essence then
				value = _ED.fileIsland.holy_essence
			end

			Text_have_n:setString(value)
		end

	elseif self.types == "75" then
		name:setString(_All_tip_string_info._warOrderExp)
		describe:setString(_All_tip_string_info_description._warorder_exp_description)
		if nil ~= Text_have_n then
			local value = 0 
			local warorderInfo = _ED.active_activity[186]
			if warorderInfo and warorderInfo.user_order_info and warorderInfo.user_order_info.allExp then
				value = warorderInfo.user_order_info.allExp
			end
			Text_have_n:setString(value)
		end

	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
		local Image_djxx = ccui.Helper:seekWidgetByName(root, "Image_djxx")
        local Image_djxx_bg = ccui.Helper:seekWidgetByName(root, "Image_djxx_bg")
        local textRenderSize = describe:getAutoRenderSize() -- 未换行前尺寸
        local VirtualRendererSize = describe:getContentSize() -- 控件本身可渲染尺寸
        local needRowNumber = math.ceil(textRenderSize.width / VirtualRendererSize.width)
        local currRowNumber = VirtualRendererSize.height / textRenderSize.height
        local curHeight = 0
        if needRowNumber > currRowNumber then
        	if verifySupportLanguage(_lua_release_language_en) == true then
				curHeight = (needRowNumber - currRowNumber) * textRenderSize.height+textRenderSize.height*3
			else
				curHeight = (needRowNumber - currRowNumber) * textRenderSize.height
			end
			describe:setContentSize(cc.size(describe:getContentSize().width , describe:getContentSize().height + curHeight))
			Image_djxx:setContentSize(cc.size(Image_djxx:getContentSize().width , Image_djxx:getContentSize().height + curHeight))
			Image_djxx_bg:setContentSize(cc.size(Image_djxx_bg:getContentSize().width , Image_djxx_bg:getContentSize().height + curHeight))
			root:setPosition(cc.p(root:getPositionX() , root:getPositionY() + curHeight))
		end
		local screenSize = cc.Director:getInstance():getWinSize() 
		local rootPos = fwin:convertToWorldSpace(root, cc.p(0, 0))
		if rootPos.y + Image_djxx_bg:getContentSize().height * app.scaleFactor > screenSize.height then
			root:setPositionY(root:getPositionY() - rootPos.y / app.scaleFactor - Image_djxx_bg:getContentSize().height + screenSize.height / app.scaleFactor - 10)
		end
		if rootPos.x + Image_djxx_bg:getContentSize().width * app.scaleFactor / 2 > screenSize.width then
			root:setPositionX(root:getPositionX() - rootPos.x / app.scaleFactor - Image_djxx_bg:getContentSize().width / 2 + screenSize.width / app.scaleFactor - 10 )
		end
		if rootPos.x - Image_djxx_bg:getContentSize().width * app.scaleFactor / 2 < 0 then
			root:setPositionX(root:getPositionX() - rootPos.x / app.scaleFactor + Image_djxx_bg:getContentSize().width / 2)
		end
		if nil == self.widget then
			root:setPosition(cc.p(screenSize.width / app.scaleFactor / 2, screenSize.height / app.scaleFactor / 2 - Image_djxx_bg:getContentSize().height / 2))
		end
	end
end

function propMoneyInfo:onEnterTransitionFinish()
	local csbItem = csb.createNode("packs/warehouse_information_1.csb")
	local root = csbItem:getChildByName("root")

	if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
    else
		local action = csb.createTimeline("packs/warehouse_information.csb")
		action:gotoFrameAndPlay(0, action:getDuration(), false)
	    csbItem:runAction(action)
	end

	self:addChild(csbItem)
	table.insert(self.roots, root)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_dj_xx"), nil, {func_string = [[state_machine.excute("prop_money_info_cell", 0, "click prop_money_info_cell.'")]]}, nil, 0)
	self:onUpdateDraw()
	
end

function propMoneyInfo:onExit()
	state_machine.remove("prop_money_info_cell")

end

function propMoneyInfo:init(types, name, widget)
	self.types = types
	self.widget = widget
	if nil ~= self.widget then
		local pos = fwin:convertToWorldSpace(widget, cc.p(0, 0))
		local anchor = widget:getAnchorPoint()
		local size = widget:getContentSize()
		pos.x = pos.x / app.scaleFactor + size.width / 2 -- (size.width * anchor.x)
		-- pos.y = pos.y + (size.height * anchor.y) + 50
		pos.y = pos.y / app.scaleFactor + size.height - 25 * app.scaleFactor
		self:setPosition(pos)
	else
		--self:setPosition(cc.p(fwin._width / 2, fwin._height / 2))
	end
end

function propMoneyInfo:createCell()
	local cell = propMoneyInfo:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

