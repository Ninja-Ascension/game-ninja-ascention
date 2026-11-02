--[[ ----------------------------------------------------------------------------
-- 置换窗口
--]] ----------------------------------------------------------------------------
SmEquipmentQianghuaTab3 = class("SmEquipmentQianghuaTab3Class", Window)

-- 打开窗口
local sm_equipment_qianghua_tab3_window_open_terminal = {
	_name = "sm_equipment_qianghua_tab3_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SmEquipmentQianghuaTab3Class") then
			fwin:open(SmEquipmentQianghuaTab3:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local sm_equipment_qianghua_tab3_window_close_terminal = {
	_name = "sm_equipment_qianghua_tab3_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmEquipmentQianghuaTab3Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_equipment_qianghua_tab3_window_open_terminal)
state_machine.add(sm_equipment_qianghua_tab3_window_close_terminal)
state_machine.init()

-- 构造器
function SmEquipmentQianghuaTab3:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.equip = nil
	self.eIndexList = {-1,-1,-1}	-- 装备锁定情况  -1未开 0未锁定 1锁定
	self.actionOver = true
	-- load lua files.
	app.load("client.packs.EquipStorage.SmEquipmentQianghuaTab3Window2")
	
	-- Initialize sm equipment qianghua tab3 page state machine.
	local function init_sm_equipment_qianghua_tab3_terminal()
		-- 打开角色创建窗口
		local sm_equipment_qianghua_tab3_open_terminal = {
			_name = "sm_equipment_qianghua_tab3_open",
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

		-- 关闭角色创建窗口
		local sm_equipment_qianghua_tab3_close_terminal = {
			_name = "sm_equipment_qianghua_tab3_close",
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

		-- 显示窗口
		local sm_equipment_qianghua_tab3_show_terminal = {
			_name = "sm_equipment_qianghua_tab3_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local sm_equipment_qianghua_tab3_hide_terminal = {
			_name = "sm_equipment_qianghua_tab3_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local sm_equipment_qianghua_tab3_refush_terminal = {
			_name = "sm_equipment_qianghua_tab3_refush",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance then 
					instance.equip = params[1]
					instance:onUpdateDraw()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 置换
		local sm_equipment_qianghua_tab3_substitution_click_terminal = {
			_name = "sm_equipment_qianghua_tab3_substitution_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance then 
					state_machine.lock("sm_equipment_qianghua_tab3_substitution_click",0,"")
					local equip = instance.equip
					local flagNum = 0 
					local lockId = -1
					local entryNum = #equip.hardsInfo.entryInfos
					for i=1,3 do
						if instance.eIndexList[i] == 1 then
							flagNum = flagNum + 1
							lockId = i
						end
					end

					if entryNum <= flagNum then 
						-- 不存在未锁定词条
						TipDlg.drawTextDailog(tipStringInfo_equipment_harden[4])
						state_machine.unlock("sm_equipment_qianghua_tab3_substitution_click")
						return
					end

					local prop_mould_id = dms.int(dms["play_config"], 189, pirates_config.param)
					local haveNum = 0
					if fundPropWidthId(prop_mould_id) then 
						haveNum = tonumber(fundPropWidthId(prop_mould_id).prop_number)
					end

					-- 锁定石消耗完毕
					if haveNum < flagNum then 
                		function showConfirmTip(instance,n)
							local function responseEquipmentStartLockCallback(response)
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									state_machine.excute("sm_equipment_qianghua_to_update_equip_icon",0,nil)
									state_machine.excute("sm_equipment_qianghua_tab3_window1_update_draw",0,nil)
									state_machine.unlock("sm_equipment_qianghua_tab3_lock_click")
								else
		
									state_machine.unlock("sm_equipment_qianghua_tab3_lock_click")
								end
							end
							protocol_command.equipment_harden_locking.param_list = equip.ship_id .. "\r\n" ..equip.m_index.. "\r\n"..lockId.. "\r\n".."2".. "\r\n"
							NetworkManager:register(protocol_command.equipment_harden_locking.code, nil, nil, nil, instance, responseEquipmentStartLockCallback,false)
                		end
                		app.load("client.utils.ConfirmTip")
                		local tip = ConfirmTip:new()
                		tip:init(instance, showConfirmTip, tipStringInfo_equipment_harden[8])
						fwin:open(tip,fwin._ui)
						state_machine.unlock("sm_equipment_qianghua_tab3_substitution_click")
						return 
					end


					local function responseEquipmentChangeCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							state_machine.excute("sm_equipment_qianghua_to_update_equip_icon",0,nil)
							state_machine.excute("sm_equipment_qianghua_tab3_window1_update_draw",0,nil)
							-- El temple/reemplazo cambia PC, ATQ, PV y DEF del heroe y el
							-- servidor ya los reenvia (S2C 44/181/128). Repinta la pantalla de
							-- Fortalecimiento, que si no se queda con el valor viejo hasta que
							-- la reabres (SmRoleStrengthenTab.lua:272-307 y :690-700).
							if fwin:find("SmRoleStrengthenTabClass") ~= nil then
								state_machine.excute("sm_role_strengthen_tab_update_ship_info",0,{equip.ship_id})
							end
							smFightingChange()
							state_machine.unlock("sm_equipment_qianghua_tab3_substitution_click")
						else
							state_machine.unlock("sm_equipment_qianghua_tab3_substitution_click")
						end
					end
                	protocol_command.equipment_harden_replace.param_list = equip.ship_id .. "\r\n" ..equip.m_index.. "\r\n"
                	NetworkManager:register(protocol_command.equipment_harden_replace.code, nil, nil, nil, instance, responseEquipmentChangeCallback,false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 锁定相关
		local sm_equipment_qianghua_tab3_lock_click_terminal = {
			_name = "sm_equipment_qianghua_tab3_lock_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				if instance then 
					state_machine.lock("sm_equipment_qianghua_tab3_lock_click",0,"")
					instance.equip.lockIndex = params._datas.m_type
					instance.equip.lockType = params._datas.lock_type 
					local equip = instance.equip 
					
					if instance.equip.lockType == 1 then	-- 上锁
						local prop_mould_id = dms.int(dms["play_config"], 189, pirates_config.param)
						local haveNum = 0
						if fundPropWidthId(prop_mould_id) then 
							haveNum = tonumber(fundPropWidthId(prop_mould_id).prop_number)
						end
						if haveNum <= 0 then 
							TipDlg.drawTextDailog(tipStringInfo_equipment_harden[9])
							state_machine.unlock("sm_equipment_qianghua_tab3_lock_click")
							return 
						end
						local flag = false
						
						for i = 1,3 do
							if instance.eIndexList[i] == 1 then 
								flag = true
							end
						end

						if flag then 
							local function responseEquipmentStartLockCallback(response)
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									state_machine.excute("sm_equipment_qianghua_to_update_equip_icon",0,nil)
									state_machine.excute("sm_equipment_qianghua_tab3_window1_update_draw",0,nil)
									state_machine.unlock("sm_equipment_qianghua_tab3_lock_click")
								else
		
									state_machine.unlock("sm_equipment_qianghua_tab3_lock_click")
								end
							end
							protocol_command.equipment_harden_locking.param_list = equip.ship_id .. "\r\n" ..equip.m_index.. "\r\n"..equip.lockIndex.. "\r\n".."1".. "\r\n"
							NetworkManager:register(protocol_command.equipment_harden_locking.code, nil, nil, nil, instance, responseEquipmentStartLockCallback,false)
						else
							state_machine.excute("sm_equipment_qianghua_tab3_window2_window_open",0,{equip})
						end
						state_machine.unlock("sm_equipment_qianghua_tab3_lock_click")
					elseif instance.equip.lockType == 2 then --解锁
						local function responseEquipmentStartLockCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								state_machine.excute("sm_equipment_qianghua_to_update_equip_icon",0,nil)
								state_machine.excute("sm_equipment_qianghua_tab3_window1_update_draw",0,nil)
								state_machine.unlock("sm_equipment_qianghua_tab3_lock_click")
							else
	
								state_machine.unlock("sm_equipment_qianghua_tab3_lock_click")
							end
						end
						protocol_command.equipment_harden_locking.param_list = equip.ship_id .. "\r\n" ..equip.m_index.. "\r\n"..equip.lockIndex.. "\r\n".."2".. "\r\n"
						NetworkManager:register(protocol_command.equipment_harden_locking.code, nil, nil, nil, instance, responseEquipmentStartLockCallback,false)
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(sm_equipment_qianghua_tab3_open_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_close_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_show_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_hide_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_substitution_click_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_lock_click_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_refush_terminal)
		state_machine.init()
	end
	-- call func init sm equipment qianghua tab3 state machine.
	init_sm_equipment_qianghua_tab3_terminal()
end

-- 对象初始化
function SmEquipmentQianghuaTab3:init(params)
	self.equip = params[1]
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function SmEquipmentQianghuaTab3:onUpdate(dt)
    if self.actionOver == true then
        self.actionOver = false
        local function executeMoveFunc()
            local function executeMoveHeroOverFunc()
                self.actionOver = true
            end
            if self.roots[1] ~= nil then
                ccui.Helper:seekWidgetByName(self.roots[1], "Panel_equ_icon"):runAction(cc.Sequence:create(
                    cc.MoveTo:create(1, cc.p(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_equ_icon"):getPositionX() , ccui.Helper:seekWidgetByName(self.roots[1], "Panel_equ_icon"):getPositionY() - 10)),
                    cc.CallFunc:create(executeMoveHeroOverFunc)
                ))
            end
        end
        if self.roots[1] ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_equ_icon"):runAction(cc.Sequence:create(
                cc.MoveTo:create(1, cc.p(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_equ_icon"):getPositionX() , ccui.Helper:seekWidgetByName(self.roots[1], "Panel_equ_icon"):getPositionY() + 10)),
                cc.CallFunc:create(executeMoveFunc)
            ))
        end
    end
end

function SmEquipmentQianghuaTab3:onDraw()
	local root = self.roots[1]

	-- 等级
	self.Text_level_number = ccui.Helper:seekWidgetByName(root, "Text_level_number")

	-- 道具容器
	self.Panel_equ_up_quality_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_equ_up_quality_icon_1")

	self.Panel_equ_up_quality_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_equ_up_quality_icon_2")


end

function SmEquipmentQianghuaTab3:onUpdateDraw()
	local root = self.roots[1]
    if root == nil then 
        return
    end
    if self.equip == nil then
        return
	end

	--装备基础数据
	--模板id
	local equip_moudl_id = self.equip.user_equiment_template
	--所属战船
    local ship_id = self.equip.ship_id
    local shipData = _ED.user_ship[""..ship_id]
    --装备位
    local e_index = self.equip.m_index

    --武将装备数据（等级|品质|经验|星级）
    local shipEquip = zstring.split(shipData.equipInfo, "|")
    --形象
    local Panel_equ_icon = ccui.Helper:seekWidgetByName(root, "Panel_equ_icon")
    Panel_equ_icon:removeBackGroundImage()
    local picIndex = dms.int(dms["equipment_mould"], equip_moudl_id, equipment_mould.pic_index)
	Panel_equ_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
	
    --装备名称
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    --获取装备名称索引
    local nameindex = dms.int(dms["equipment_mould"], equip_moudl_id, equipment_mould.equipment_name)
    --通过索引找到word_mould
    local word_info = dms.element(dms["word_mould"], nameindex)
	local name = word_info[3]

	--装备位
	local e_index = self.equip.m_index
	local newGrade = zstring.split(shipEquip[2], ",")

	--获取装备名称索引
	local nameindex = 0
	if i == 2 then
		nameindex = dms.int(dms["equipment_mould"], newEquip.user_equiment_template, equipment_mould.equipment_name)
	else
		nameindex = dms.int(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.equipment_name)
	end
	--通过索引找到word_mould
	local word_info = dms.element(dms["word_mould"], nameindex)
	local name = word_info[3]

	if getShipNameOrder(tonumber(newGrade[tonumber(e_index)])) > 0 then
		name = name.."+"..getShipNameOrder(tonumber(newGrade[tonumber(e_index)]))
	end
	Text_name:setString(name)

	--星级
    for i=1, 5 do
        local equ_star = ccui.Helper:seekWidgetByName(root, "equ_star_"..i)
        local equData = zstring.split(shipEquip[4], ",")
        if tonumber(equData[tonumber(e_index)]) >= i then
            equ_star:setVisible(true)
        else
            equ_star:setVisible(false)
        end
    end

	-- 淬炼信息
	local hardsInfo = self.equip.hardsInfo

	-- 等级
	local lv = hardsInfo.level
	local maxLv = dms.string(dms["play_config"], 182, play_config.param)
	self.Text_level_number:setString(lv.."/"..maxLv)

	-- 道具显示
	local propId = dms.string(dms["play_config"], 190, play_config.param)
	local cell = self:addResourcesIconCell(propId)
	self.Panel_equ_up_quality_icon_1:removeAllChildren(true)
	cell:setAnchorPoint(cc.p(0.5,0.5))
	cell:setPosition(cc.p(self.Panel_equ_up_quality_icon_1:getContentSize().width/2,self.Panel_equ_up_quality_icon_1:getContentSize().height/2))
	self.Panel_equ_up_quality_icon_1:addChild(cell)
	
	-- 锁定石数量
	local prop_mould_id = dms.int(dms["play_config"], 189, pirates_config.param)
	local prop_name = dms.string(dms["prop_mould"], prop_mould_id, prop_mould.prop_name)
	prop_name = setThePropsIcon(prop_mould_id)[2]
	local lockCell = self:addResourcesIconCell(prop_mould_id)
	self.Panel_equ_up_quality_icon_2:removeAllChildren(true)
	lockCell:setAnchorPoint(cc.p(0.5,0.5))
	lockCell:setPosition(cc.p(self.Panel_equ_up_quality_icon_2:getContentSize().width/2,self.Panel_equ_up_quality_icon_2:getContentSize().height/2))
	self.Panel_equ_up_quality_icon_2:addChild(lockCell)

	

	--词条属性
	for i = 1,3 do 
		local Panel_citiao_1 = ccui.Helper:seekWidgetByName(root, "Panel_citiao_"..i)
		Panel_citiao_1:setVisible(false)
		local Image_arrow_1 = ccui.Helper:seekWidgetByName(root, "Image_arrow_"..i)
		Image_arrow_1:setVisible(false)
		local Panel_citiao_1_1 = ccui.Helper:seekWidgetByName(root, string.format("Panel_citiao_%d_1",i))
		Panel_citiao_1_1:setVisible(false)
		local Panel_citiao_1_2 = ccui.Helper:seekWidgetByName(root, string.format("Panel_citiao_%d_2",i))
		Panel_citiao_1_2:setVisible(false)
		local Image_xiantiao_1 = ccui.Helper:seekWidgetByName(root, "Image_xiantiao_"..i)
		Image_xiantiao_1:setVisible(false)
	end

	for i = 1,6 do 
		local Panel_dh_1 = ccui.Helper:seekWidgetByName(root, "Panel_dh_"..i)
		--Panel_dh_1:setVisible(false)
		Panel_dh_1:setSwallowTouches(false)
	end


	if hardsInfo.entryInfos and 0 < #hardsInfo.entryInfos then
		local entryInfos = hardsInfo.entryInfos
		local replacedEntries = hardsInfo.replacedEntries
		for i=1,#entryInfos do
			local entryInfo = zstring.split(entryInfos[i],"|")
			-- 词条等级
			local entryInfoLevel = tonumber(entryInfo[1])
			local entryInfoPropty = entryInfo[2]
			-- 词条属性
			local proptys = zstring.split(entryInfoPropty,",")
			local proKey = proptys[1]
			local proVal = proptys[2]
			local Panel_citiao_1 = ccui.Helper:seekWidgetByName(root, "Panel_citiao_"..i)
			Panel_citiao_1:setVisible(true)

			-- 是否重置
			if replacedEntries and replacedEntries[i] and (_ED.equipment_hardensInfo_lock == nil or (_ED.equipment_hardensInfo_lock and _ED.equipment_hardensInfo_lock ~= i)) then 
				local replaceInfo = zstring.split(replacedEntries[i],"|")
				-- 词条等级
				local replaceInfoLevel = tonumber(replaceInfo[1])
				local replaceInfoPropty = replaceInfo[2]
				-- 词条属性
				local replaceProptys = zstring.split(replaceInfoPropty,",")
				local replaceProKey = replaceProptys[1]
				local replaceProVal = replaceProptys[2]

				local Panel_citiao_1_1 = ccui.Helper:seekWidgetByName(root, string.format("Panel_citiao_%d_1",i))
				Panel_citiao_1_1:setVisible(true)
				-- 前属性
				local name,val = getHardenPropertyNameAndValue(replaceProKey, replaceProVal)
				local Text_shuxing_1 = Panel_citiao_1_1:getChildByName("Text_shuxing_"..i)
				Text_shuxing_1:setString(string.format(tipStringInfo_equipment_harden[10],tostring(tonumber(entryInfoLevel) + 1))..name..val)

				-- 前范围
				local rangeStr = SmEquipmentQunenchingHandle.getRange(replaceInfoLevel, e_index, tonumber(replaceProKey))
				if nil ~= string.find(name..val,"%%") then 
					local range = zstring.split(rangeStr,",")
					local Text_fanwei_1 = ccui.Helper:seekWidgetByName(root, string.format("Text_fanwei_%d_1",i))
					Text_fanwei_1:setString(string.format(tipStringInfo_equipment_harden[7],range[1].."%".."-"..range[2].."%"))
				else
					local range = zstring.replace(rangeStr,",","-")
					local Text_fanwei_1 = ccui.Helper:seekWidgetByName(root, string.format("Text_fanwei_%d_1",i))
					Text_fanwei_1:setString(string.format(tipStringInfo_equipment_harden[7],range))
				end

				-- 动画
				self:hardenAni(2 * i - 1)

				-- 显示删除线
				local Image_xiantiao_1 = ccui.Helper:seekWidgetByName(root, "Image_xiantiao_"..i)
				Image_xiantiao_1:setVisible(true)

				local Panel_citiao_1_2 = ccui.Helper:seekWidgetByName(root, string.format("Panel_citiao_%d_2",i))
				Panel_citiao_1_2:setVisible(true)
				-- 后属性
				local name,val = getHardenPropertyNameAndValue(proKey, proVal)
				local Text_shuxing_2 = Panel_citiao_1_2:getChildByName("Text_shuxing_"..i)
				Text_shuxing_2:setString(string.format(tipStringInfo_equipment_harden[10],tostring(tonumber(entryInfoLevel) + 1))..name..val)

				-- 后范围
				local rangeStr = SmEquipmentQunenchingHandle.getRange(entryInfoLevel, e_index, tonumber(proKey))
				if nil ~= string.find(name..val,"%%") then 
					local range = zstring.split(rangeStr,",")
					local Text_fanwei_2 = ccui.Helper:seekWidgetByName(root, string.format("Text_fanwei_%d_2",i))
					Text_fanwei_2:setString(string.format(tipStringInfo_equipment_harden[7],range[1].."%".."-"..range[2].."%"))
				else
					local range = zstring.replace(rangeStr,",","-")
					local Text_fanwei_2 = ccui.Helper:seekWidgetByName(root, string.format("Text_fanwei_%d_2",i))
					Text_fanwei_2:setString(string.format(tipStringInfo_equipment_harden[7],range))
				end
				

				local Image_arrow_1 = ccui.Helper:seekWidgetByName(root, "Image_arrow_"..i)
				Image_arrow_1:setVisible(true)
			else 
				local Panel_citiao_1_1 = ccui.Helper:seekWidgetByName(root, string.format("Panel_citiao_%d_1",i))
				Panel_citiao_1_1:setVisible(true)
				-- 属性
				local name,val = getHardenPropertyNameAndValue(proKey, proVal)
				local Text_shuxing_1 = Panel_citiao_1_1:getChildByName("Text_shuxing_"..i)
				Text_shuxing_1:setString(string.format(tipStringInfo_equipment_harden[10],tostring(tonumber(entryInfoLevel) + 1))..name..val)

				-- 范围
				local rangeStr = SmEquipmentQunenchingHandle.getRange(entryInfoLevel, e_index, tonumber(proKey))
				if nil ~= string.find(name..val,"%%") then 
					local range = zstring.split(rangeStr,",")
					local Text_fanwei_1 = ccui.Helper:seekWidgetByName(root, string.format("Text_fanwei_%d_1",i))
					Text_fanwei_1:setString(string.format(tipStringInfo_equipment_harden[7],range[1].."%".."-"..range[2].."%"))
				else
					local range = zstring.replace(rangeStr,",","-")
					local Text_fanwei_1 = ccui.Helper:seekWidgetByName(root, string.format("Text_fanwei_%d_1",i))
					Text_fanwei_1:setString(string.format(tipStringInfo_equipment_harden[7],range))
				end
				
			end
		end
	end

	-- 锁
	local lockIndex = hardsInfo.lockIndex 
	self.eIndexList = {-1,-1,-1}
	_ED.equipment_hardensInfo_lock = nil

	for i=1,3 do
		local Button_suo_1 = ccui.Helper:seekWidgetByName(root, "Button_suo_"..i)
		Button_suo_1:setBright(false)
		-- 解锁
		if nil ~= lockIndex and i == tonumber(lockIndex + 1) then 
			Button_suo_1:setBright(true)
			self.eIndexList[i] = 1
			fwin:addTouchEventListener(Button_suo_1, nil,
			{
				terminal_name = "sm_equipment_qianghua_tab3_lock_click",
				terminal_state = 0,
				m_type = i,
				lock_type = 2,
				isPressedActionEnabled = true,
			}, nil, 0)
			_ED.equipment_hardensInfo_lock = i
		else
			-- 上锁
			fwin:addTouchEventListener(Button_suo_1, nil,
			{
				terminal_name = "sm_equipment_qianghua_tab3_lock_click",
				terminal_state = 0,
				m_type = i,
				lock_type = 1,
				isPressedActionEnabled = true,
			}, nil, 0)
		end
			
	end

end

-- 属性变更/跳动词条出现的特殊光效动画动画  
function SmEquipmentQianghuaTab3:hardenAni(type)

	local root = self.roots[1]

	local Panel_dh_1 = ccui.Helper:seekWidgetByName(root, "Panel_dh_"..type)
    Panel_dh_1:removeAllChildren(true)

    local jsonFile = "images/ui/effice/effect_equipment_refining/effect_equipment_refining.json"
	local atlasFile = "images/ui/effice/effect_equipment_refining/effect_equipment_refining.atlas"
	local isLoop = false
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation3", isLoop, nil)
	sp.initArmature(animation, true)
	animation:setAnimation(0, "animation3", isLoop)
	animation:setPosition(cc.p(Panel_dh_1:getContentSize().width/2, Panel_dh_1:getContentSize().height/2))
	Panel_dh_1:addChild(animation)
end

-- 添加道具图标
function SmEquipmentQianghuaTab3:addResourcesIconCell(propId)
	local cell = ResourcesIconCell:createCell()
	local rewardType = 6
	local haveNum = 0
	if fundPropWidthId(propId) then 
		haveNum = tonumber(fundPropWidthId(propId).prop_number)
	end
	cell:init(rewardType, haveNum, tonumber(propId), nil, nil, true ,true, 1)
	
	return cell
end

function SmEquipmentQianghuaTab3:onInit()
	-- 加载SmEquipmentQianghuaTab3Window界面资源.
	local csbNode = csb.createNode("packs/EquipStorage/sm_equipment_qianghua_tab_3_window_1.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 置换按钮
	self.Button_equ_up_sp = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_equ_up_sp"), nil,
	{
		terminal_name = "sm_equipment_qianghua_tab3_substitution_click",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭窗口
	self.Button_icon_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_icon_back"), nil,
	{
		terminal_name = "sm_equipment_qianghua_tab3_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 规则窗口
	self.Button_rule = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rule"), nil,
	{
		terminal_name = "equipment_qunenching_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	

	local Panel_cxdh = ccui.Helper:seekWidgetByName(root, "Panel_cxdh")
    Panel_cxdh:removeAllChildren(true)

    local jsonFile = "sprite/sprite_zhuangbei_qh.json"
    local atlasFile = "sprite/sprite_zhuangbei_qh.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	Panel_cxdh:addChild(animation)
	self:onDraw()
	self:onUpdateDraw()
end

function SmEquipmentQianghuaTab3:onExit()
	-- 释放SmEquipmentQianghuaTab3Window界面资源.
	state_machine.remove("sm_equipment_qianghua_tab3_open")
	state_machine.remove("sm_equipment_qianghua_tab3_close")
	state_machine.remove("sm_equipment_qianghua_tab3_show")
	state_machine.remove("sm_equipment_qianghua_tab3_hide")
	state_machine.remove("sm_equipment_qianghua_tab3_substitution_click")
	state_machine.remove("sm_equipment_qianghua_tab3_lock_click")
	state_machine.remove("sm_equipment_qianghua_tab3_refush")
	
end

function SmEquipmentQianghuaTab3:close()
	-- window event : close.
	
end

function SmEquipmentQianghuaTab3:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
