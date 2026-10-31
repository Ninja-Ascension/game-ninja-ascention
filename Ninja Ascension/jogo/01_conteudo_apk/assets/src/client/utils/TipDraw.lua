-- ----------------------------------------------------------------------------------------------------
-- 说明：绘制游戏中用到的提示界面
-- -----------------------------------------------------------------------------------------------------
TipDlg = {}

app.load("client.utils.GameTipDialog")

function CC_CONTENT_SCALE_FACTOR()
	return cc.Director:getInstance():getContentScaleFactor()
end

local function graphicsTIP(window, ZOrder)
	ZOrder = ZOrder == nil and 0 or ZOrder
	fwin._scene:addChild(window, ZOrder)
	cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end

function TipDlg.drawTextDailog(text, action)
	if text == _string_piece_info[74] then
		state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
		{
			terminal_name = "shortcut_open_recharge_window", 
			terminal_state = 0, 
			_msg = _string_piece_info[316], 
			_datas= 
			{

			}
		})
	else
		if __lua_project_id == __lua_project_adventure 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
			or __lua_project_id == __lua_project_l_naruto
			then
			local tipWindows = fwin:find("GameTipDialogClass")
			if tipWindows ~= nil  then 
				fwin:close(tipWindows)
			end
		end
		if fwin:find("GameTipDialogClass") == nil then
			local dialog = GameTipDialog:new()
			dialog:init(text)
			fwin:open(dialog, fwin._dialog)
			if nil ~= action then
				dialog:runAction(action)
			else
				if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
					dialog:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.MoveBy:create(0.5, cc.p(0, 100))))
				end
			end
		end
	end
	-- local size = cc.Director:getInstance():getWinSize()
	
	-- local tipWidget = csb.createNode("utils/congratulations_to_btain.csb")
	-- local root = tipWidget:getChildByName("root")
	-- local panel = ccui.Helper:seekWidgetByName(root, "ImageView_bg")
	-- local tipInformation = ccui.Helper:seekWidgetByName(root, "Label_970*")
	-- local tipImage = ccui.Helper:seekWidgetByName(root, "ImageView_bg")
	-- local panel_20 = ccui.Helper:seekWidgetByName(root, "Panel_20")
	-- tipInformation:setString(text)
	
	-- local mid_pos_bg = tipImage:getPositionY() + tipImage:getContentSize().height/2
	-- tipImage:setContentSize(cc.size(tipImage:getContentSize().width,tipImage:getContentSize().height+tipInformation:getContentSize().height))
	-- local mid_pos_bg_after_change = tipImage:getPositionY() + tipImage:getContentSize().height/2
	-- local offset_y = mid_pos_bg_after_change - mid_pos_bg
	-- tipInformation:setPositionY(tipInformation:getPositionY() + offset_y)
	
	-- local textSize = tipInformation:getContentSize()
	-- local tipSize = tipWidget:getContentSize()
	-- local imageSize = tipImage:getContentSize()
	
	-- tipImage:setContentSize(imageSize)
	
		-- -- local tipInformation = cc.Label:createWithTTF(text, tipInformation:getFontName(), 
		-- -- tipInformation:getFontSize(), cc.size(textSize.width, 0), 
		-- -- cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		-- -- panel_20:addChild(tipInformation	)
			
	-- tipWidget:setPosition(cc.p((size.width - tipSize.width)/2, (size.height - tipSize.height)/2))
	
	-- graphicsTIP(tipWidget, 9999999)
	
	-- local function removeTipDialFunN(sender)
		-- tipWidget:removeFromParent(true)
	-- end
	
    -- local seq = cc.Sequence:create(cc.DelayTime:create(1), cc.FadeOut:create(3), cc.CallFunc:create(removeTipDialFunN))
	-- tipWidget:runAction(seq)
end

function TipDlg.drawStorageTipo(storgeIndex)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--新数码去除仓库已满的判断
		return false
	end
	app.load("client.utils.PackTipDlg")
	local indexFour = nil
	local indexThree = nil
	local indexTwo = nil
	local indexOne = nil
	if storgeIndex ~= nil then
		if storgeIndex[4] ~= nil then
			indexFour = zstring.tonumber(storgeIndex[4])
		end
		if storgeIndex[3] ~= nil then
			indexThree = zstring.tonumber(storgeIndex[3])
		end
		if storgeIndex[2] ~= nil then
			indexTwo = zstring.tonumber(storgeIndex[2])
		end				
		indexOne = zstring.tonumber(storgeIndex[1])
		if indexOne == -1 then
			return false
		end
	end
	
	
	if storgeIndex == nil or indexFour == 0 or indexThree == 0 or indexTwo == 0 or indexOne == 0 then
		-- local usedPropStorageNumber = 0
		-- for i, item in pairs(_ED.user_prop) do
			-- local propData = elementAt(propMould, item.user_prop_template)
			-- if propData:atoi(prop_mould.storage_page_index) == 0 then
				-- usedPropStorageNumber = usedPropStorageNumber + 1
			-- end
		-- end
		-- if usedPropStorageNumber >= tonumber(_ED.precious_bag_open) then
			-- local tipStr = _pack_fill_tip.propPackTip
			-- LuaClasses["StorageSkipTipBleachClass"].initData(tipStr, 0)
			-- LuaClasses["MainWindowClass"].openWindow(LuaClasses["StorageSkipTipBleachClass"])	
			-- TipDlg.drawTextDailog("道具包裹已满，请及时清理包裹")
			-- return true
		-- end
	end
	-------------------------------------------------------------------
	if storgeIndex == nil or indexFour == 1 or indexThree == 1 or indexTwo == 1 or indexOne == 1 then
		-- local treasureNumber = 0
		-- for i, equip in pairs(_ED.user_equiment) do
			-- local equipData = elementAt(equipmentMould, tonumber(equip.user_equiment_template))
			-- local equipment_type = equipData:atoi(equipment_mould.equipment_type)
			-- if equipment_type >=4 and equipment_type <= 5 and equip.ship_id == "0" then
				-- treasureNumber = treasureNumber+1
			-- end
		-- end
		-- if treasureNumber >= tonumber(_ED.material_bag_open) then
			-- local tipStr = _pack_fill_tip.treasurePackTip
			-- LuaClasses["StorageSkipTipBleachClass"].initData(tipStr, 1)
			-- LuaClasses["MainWindowClass"].openWindow(LuaClasses["StorageSkipTipBleachClass"])	
			-- TipDlg.drawTextDailog("宝物包裹已满，请及时清理包裹")
			-- return true
		-- end
	end
	---------------------------------------------------------------------------
	if storgeIndex == nil or indexFour == 2 or indexThree == 2 or indexTwo == 2 or indexOne == 2 then
		local equipNumber = 0
		for i, equip in pairs(_ED.user_equiment) do
			if equip.user_equiment_id ~= nil then
				if dms.int(dms["equipment_mould"], tonumber(equip.user_equiment_template), equipment_mould.equipment_type) < 4 then
					equipNumber = equipNumber+1
				end
			end
		end
		if equipNumber >= tonumber(_ED.equiment_bag_open) then
			local cell = PackTipDlg:new()
			cell:init(2)
			fwin:open(cell, fwin._windows)
			--TipDlg.drawTextDailog("装备包裹已满，请及时清理包裹")
			return true
		end
	end
	---------------------------------------------------------------------------
	if storgeIndex == nil or indexFour == 3 or indexThree == 3 or indexTwo == 3 or indexOne == 3 then
		-- local equipPropNumber = 0
		-- for i, prop in pairs(_ED.user_prop) do
			-- if prop.user_prop_id ~= nil then
				-- local propData = elementAt(propMould, tonumber(prop.user_prop_template))
				-- if propData:atoi(prop_mould.storage_page_index) == 3 then
					-- equipPropNumber = equipPropNumber+1
				-- end
			-- end
		-- end
		-- if equipPropNumber >= tonumber(_ED.patch_bag_open) then
			-- local tipStr = _pack_fill_tip.equipFragmentPackTip
			-- LuaClasses["StorageSkipTipBleachClass"].initData(tipStr, 3)
			-- LuaClasses["MainWindowClass"].openWindow(LuaClasses["StorageSkipTipBleachClass"])	
			--TipDlg.drawTextDailog("装备碎片包裹已满，请及时清理包裹")
			-- return true 
		-- end
	end
	-------------------------------------------------------------------------------------
	if storgeIndex == nil or indexFour == 4 or indexThree == 4 or indexTwo == 4 or indexOne == 4 then
		if tonumber(_ED.user_ship_number) >= tonumber(_ED.hero_use) then
			local cell = PackTipDlg:new()
			cell:init(4)
			fwin:open(cell, fwin._windows)	
			--TipDlg.drawTextDailog("战士包裹已满，请及时清理包裹")
			return true
		end
	end
	-------------------------------------------------------------------------------------
	if storgeIndex == nil or indexFour == 7 or indexThree == 7 or indexTwo == 7 or indexOne == 7 then
		-- local fashionNumber = 0
		-- for i, equip in pairs(_ED.user_equiment) do
			-- if equip.user_equiment_id ~= nil then
				-- local equipData = elementAt(equipmentMould, tonumber(equip.user_equiment_template))
				-- local equipment_type = equipData:atoi(equipment_mould.equipment_type)
				-- if equipment_type >=6 and equipment_type <=7 then
					-- fashionNumber = fashionNumber+1
				-- end
			-- end
		-- end
		-- if fashionNumber >= tonumber(_ED.equip_fashion_use) then
			-- local tipStr = _pack_fill_tip.fashionPackTip
			-- LuaClasses["StorageSkipTipBleachClass"].initData(tipStr, 7)
			-- LuaClasses["MainWindowClass"].openWindow(LuaClasses["StorageSkipTipBleachClass"])
			-- TipDlg.drawTextDailog("时装包裹已满，请及时清理包裹")
			-- return true
		-- end
	end
	-------------------------------------------------------------------------------------
	if storgeIndex == nil or indexFour == 8 or indexThree == 8 or indexTwo == 8 or indexOne == 8 then
		-- local powerNumber = 0
		-- for i, power in pairs(_ED.user_powers) do
			-- if power.power_id ~= nil then
				-- if tonumber(power.tag_index) == 0 then
					-- powerNumber = powerNumber+1
				-- end
			-- end
		-- end
		-- if powerNumber >= 150 then
			-- local tipStr = _pack_fill_tip.ghostPackTip
			-- LuaClasses["StorageSkipTipBleachClass"].initData(tipStr, 8)
			-- LuaClasses["MainWindowClass"].openWindow(LuaClasses["StorageSkipTipBleachClass"])
			-- TipDlg.drawTextDailog("鬼道包裹已满，请及时清理包裹")
			-- return true
		-- end
	end

	return false
end


-- function TipDlg.drawTipDialog(tipText, confirmCallback, cancelCallback)
	-- if true then
		-- require "script/transformers/tip/MessageDialog"
		-- LuaClasses["MessageDialogClass"].Draw(tipText, confirmCallback, cancelCallback)
		-- return
	-- end
-- end

function TipDlg.drawFunctionUnopenedTip()
	TipDlg.drawTextDailog(_function_unopened_tip_string)
end
-- END
-- ----------------------------------------------------------------------------------------------------