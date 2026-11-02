--[[ ----------------------------------------------------------------------------
-- 装备淬炼主界面
--]] ----------------------------------------------------------------------------
SmEquipmentQianghuaTab3Window1 = class("SmEquipmentQianghuaTab3Window1Class", Window)

-- 打开窗口
local sm_equipment_qianghua_tab3_window1_window_open_terminal = {
	_name = "sm_equipment_qianghua_tab3_window1_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmEquipmentQianghuaTab3Window1Class")
        if nil == _homeWindow then
            local panel = SmEquipmentQianghuaTab3Window1:new():init(params)
            fwin:open(panel)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local sm_equipment_qianghua_tab3_window1_window_close_terminal = {
	_name = "sm_equipment_qianghua_tab3_window1_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmEquipmentQianghuaTab3Window1Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_equipment_qianghua_tab3_window1_window_open_terminal)
state_machine.add(sm_equipment_qianghua_tab3_window1_window_close_terminal)
state_machine.init()

-- 构造器
function SmEquipmentQianghuaTab3Window1:ctor()
	self.super:ctor()
	self.roots = {}
	-- var
	self.actions = {}
	self.equip = nil
	self.actionOver = true
	self.aniFalg = false  	-- 属性变更动画标志
	self.entryLevels = {-1,-1,-1}
	self.colorData = nil	-- 非重生的控件原颜色
	self.lastLv = nil      	-- 当前等级,用于动画的播放判断
	-- load lua files.
	app.load("client.packs.EquipStorage.SmEquipmentQianghuaTab3")
	app.load("client.packs.EquipStorage.SmEquipmentQunenchingRule")
	-- Initialize sm equipment qianghua tab3 window1 page state machine.
	local function init_sm_equipment_qianghua_tab3_window1_terminal()
		-- 打开角色创建窗口
		local sm_equipment_qianghua_tab3_window1_open_terminal = {
			_name = "sm_equipment_qianghua_tab3_window1_open",
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
		local sm_equipment_qianghua_tab3_window1_close_terminal = {
			_name = "sm_equipment_qianghua_tab3_window1_close",
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
		local sm_equipment_qianghua_tab3_window1_show_terminal = {
			_name = "sm_equipment_qianghua_tab3_window1_show",
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
		local sm_equipment_qianghua_tab3_window1_hide_terminal = {
			_name = "sm_equipment_qianghua_tab3_window1_hide",
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

		 -- 改变id
		 local sm_equipment_qianghua_tab3_window1_change_ship_terminal = {
            _name = "sm_equipment_qianghua_tab3_window1_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.equip = params
				-- 刷新
				state_machine.excute("sm_equipment_qianghua_tab3_window1_update_draw",0,"")
				--红点
                state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_awakening")
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		-- 刷新
        local sm_equipment_qianghua_tab3_window1_update_draw_terminal = {
            _name = "sm_equipment_qianghua_tab3_window1_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateDraw()
				if fwin:find("SmEquipmentQianghuaTab3Class") then 
					state_machine.excute("sm_equipment_qianghua_tab3_refush",0,{instance.equip})
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		-- 跳转置换界面
        local sm_equipment_qianghua_tab3_window1_substitution_terminal = {
            _name = "sm_equipment_qianghua_tab3_window1_substitution",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params)
				if instance then 
					local equip = instance.equip
					
					if equip.hardsInfo.entryInfos and 0 < #equip.hardsInfo.entryInfos then 
						if equip.hardsInfo.replacedEntries then 
							equip.hardsInfo.replacedEntries = nil
						end
						state_machine.excute("sm_equipment_qianghua_tab3_window_open",0,{equip})
					else
						TipDlg.drawTextDailog(tipStringInfo_equipment_harden[4])
					end
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		-- 点击淬炼
        local sm_equipment_qianghua_tab3_window1_harden_terminal = {
            _name = "sm_equipment_qianghua_tab3_window1_harden",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params)
				if instance and params._datas then 
					state_machine.lock("sm_equipment_qianghua_tab3_window1_harden",0,"")
					local equip = instance.equip
					local type = params._datas.m_type 
					-- 是否可淬炼
    				local shipData = _ED.user_ship[""..equip.ship_id]
					local shipEquip = zstring.split(shipData.equipInfo, "|")
					local newStar = zstring.split(shipEquip[4], ",")
					local awakeLevel = tonumber(newStar[tonumber(equip.m_index)])

					local lv = tonumber(equip.hardsInfo.level)
					local maxLv = dms.int(dms["play_config"], 182, play_config.param)
					if lv >= maxLv then 
						TipDlg.drawTextDailog(tipStringInfo_equipment_harden[6])
						state_machine.unlock("sm_equipment_qianghua_tab3_window1_harden")
						return 
					end
					if dms.int(dms["play_config"], 196, play_config.param) > awakeLevel then 
						-- 未到等级无法觉醒
						TipDlg.drawTextDailog(tipStringInfo_equipment_harden[1])
						state_machine.unlock("sm_equipment_qianghua_tab3_window1_harden")
						return 
					end
					if equip.hardsInfo.entryInfos then 
						instance.lastLv = equip.hardsInfo.level
						for i=1,#equip.hardsInfo.entryInfos do
							local entryInfo = zstring.split(equip.hardsInfo.entryInfos[i],"|")
							-- 词条等级
							local entryInfoLevel = tonumber(entryInfo[1])
							instance.entryLevels[i] = entryInfoLevel
						end
					end
					local function responseEquipmentHardenCallback( response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							instance.aniFalg = true
							state_machine.excute("sm_equipment_qianghua_to_update_equip_icon",0,nil)
							state_machine.excute("sm_equipment_qianghua_tab3_window1_update_draw",0,nil)

							if fwin:find("HeroDevelopClass") ~= nil then
                                state_machine.excute("hero_develop_back_to_update_specific_equip",0,equip.m_index)
								state_machine.excute("hero_develop_page_updata_hero_icon_push",0,".")
								-- 装备淬炼推送
								state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_harden_page_tips") 
							else

                                if fwin:find("SmEquipmentQianghuaClass") == nil then
                                    for i, v in pairs(_ED.user_formetion_status) do
                                        if tonumber(v) == tonumber(equip.ship_id) then
                                            state_machine.excute("formation_set_ship",0,_ED.user_ship[""..equip.ship_id])
                                            break
                                        end
                                    end
                                end
							end
							
							state_machine.excute("formation_update_equip_icon_push",0,"formation_update_equip_icon_push.")
							state_machine.excute("hero_icon_listview_icon_push_updata",0,"")
							-- El temple/reemplazo cambia PC, ATQ, PV y DEF del heroe y el
							-- servidor ya los reenvia (S2C 44/181/128). Repinta la pantalla de
							-- Fortalecimiento, que si no se queda con el valor viejo hasta que
							-- la reabres (SmRoleStrengthenTab.lua:272-307 y :690-700).
							if fwin:find("SmRoleStrengthenTabClass") ~= nil then
								state_machine.excute("sm_role_strengthen_tab_update_ship_info",0,{equip.ship_id})
							end
							smFightingChange()
							state_machine.unlock("sm_equipment_qianghua_tab3_window1_harden")
						else

							state_machine.unlock("sm_equipment_qianghua_tab3_window1_harden")
						end
					end
                	protocol_command.equipment_harden.param_list = equip.ship_id .. "\r\n" ..equip.m_index.. "\r\n"..type.. "\r\n"
                	NetworkManager:register(protocol_command.equipment_harden.code, nil, nil, nil, instance, responseEquipmentHardenCallback,false)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_equipment_qianghua_tab3_window1_open_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_window1_close_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_window1_show_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_window1_hide_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_window1_change_ship_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_window1_update_draw_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_window1_substitution_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_window1_harden_terminal)
		state_machine.init()
	end
	-- call func init sm equipment qianghua tab3 window1 state machine.
	init_sm_equipment_qianghua_tab3_window1_terminal()
end

function SmEquipmentQianghuaTab3Window1:onUpdate(dt)
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

-- 重生后变红
function SmEquipmentQianghuaTab3Window1:setRed(flag)
	local root = self.roots[1]
	local colorList = zstring.split(tipStringInfo_equipment_harden[5],",")
	local color = cc.c3b(tonumber(colorList[1]),tonumber(colorList[2]),tonumber(colorList[3]))
	if not flag then 
		color = self.colorData
	end
	
	self.Text_equ_lv_n:setColor(color)
	for i = 1,2 do 
		local Text_equ_attribute_n_1 = ccui.Helper:seekWidgetByName(root, "Text_equ_attribute_n_"..i)
		Text_equ_attribute_n_1:setColor(color)
	end

	for i = 1,3 do 
		local Text_shuxing_1 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_"..i)
		Text_shuxing_1:setColor(color)
	end

	self.Button_equ_up_zh:setBright(false)
	self.Button_equ_up_zh:setTouchEnabled(false)
end

-- 淬炼动画  1普通2暴击3词条变化
function SmEquipmentQianghuaTab3Window1:hardenAni(type,sender)
	local root = self.roots[1]
	playEffect(formatMusicFile("effect", 9991))

    sender:removeAllChildren(true)

    local jsonFile = "images/ui/effice/effect_equipment_refining/effect_equipment_refining.json"
	local atlasFile = "images/ui/effice/effect_equipment_refining/effect_equipment_refining.atlas"
	local animationName = nil
	local isLoop = false
	if type == 1 then 
		animationName = "animation"
	elseif type == 2 then 
		animationName = "animation2"
	elseif type == 3 then 
		animationName = "animation3"
	else
		animationName = "animation4"
	end
	local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, isLoop, nil)
	sp.initArmature(animation, true)
	animation:setAnimation(0, animationName, isLoop)
	animation:setPosition(cc.p(sender:getContentSize().width/2, sender:getContentSize().height/2))
	sender:addChild(animation)
end

function SmEquipmentQianghuaTab3Window1:onDraw() 
	local root = self.roots[1]

	-- 等级值
	self.Text_equ_lv_n = ccui.Helper:seekWidgetByName(root, "Text_equ_lv_n")

	-- 金币数量
	self.Text_role_up_quality_num_1 = ccui.Helper:seekWidgetByName(root, "Text_role_up_quality_num_1")

	-- 金币图标
	self.Image_role_up_quality_add_1_0 = ccui.Helper:seekWidgetByName(root, "Image_role_up_quality_add_1_0")

	-- 加号图标
	self.Image_role_up_quality_add_1 = ccui.Helper:seekWidgetByName(root, "Image_role_up_quality_add_1")

	-- 道具图标背景图
	self.Image_props_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_props_bg_1")

	-- 经验条底座容器
	self.Image_equ_exp_bg = ccui.Helper:seekWidgetByName(root, "Image_equ_exp_bg")

	-- 置换文本
	self.Text_equ_up_zh = ccui.Helper:seekWidgetByName(root, "Text_equ_up_zh*12")

	-- 快速淬炼容器
	self.Button_equ_up_kscl = ccui.Helper:seekWidgetByName(root, "Button_equ_up_kscl")

	-- 快速淬炼文本
	self.Text_eq_up_kscl = ccui.Helper:seekWidgetByName(root, "Text_eq_up_kscl*12")

	-- 重置前装备名称
	self.Text_equ_name = ccui.Helper:seekWidgetByName(root, "Text_equ_name")

	-- 经验条
	self.LoadingBar_equ_exp = ccui.Helper:seekWidgetByName(root, "LoadingBar_equ_exp")

	-- 经验条数值
	self.Text_exp_number = ccui.Helper:seekWidgetByName(root, "Text_exp_number")

	-- 满级进度条
	self.LoadingBar_equ_exp_max = ccui.Helper:seekWidgetByName(root, "LoadingBar_equ_exp_max")
	self.Text_exp_number_max = ccui.Helper:seekWidgetByName(root, "Text_exp_number_max")

	-- 升级动画1
	self.Panel_cxdh = ccui.Helper:seekWidgetByName(root, "Panel_cxdh")

	-- 装备按钮
	self.Panel_equ_icon = ccui.Helper:seekWidgetByName(root, "Panel_equ_icon")

	-- 升级动画2
	self.Panel_sjdh = ccui.Helper:seekWidgetByName(root, "Panel_sjdh")

	--经验暴击动画
	self.Panel_exp_dh = ccui.Helper:seekWidgetByName(root,"Panel_exp_dh")

	-- DSC重塑   
	if __lua_project_id == __lua_project_l_digital then 
		self.colorData = ccui.Helper:seekWidgetByName(root, "Text_shuxing_1"):getColor()
	else
		self.colorData = self.Text_equ_lv_n:getColor()
	end
end

function SmEquipmentQianghuaTab3Window1:onUpdateDraw()
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

	-- 淬炼信息
	self.equip.hardsInfo = _ED.user_ship[""..ship_id].hardensInfo[tonumber(e_index)]

    --武将装备数据（等级|品质|经验|星级）
    local shipEquip = zstring.split(shipData.equipInfo, "|")
    --形象
    local Panel_equ_icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_equ_icon")
    Panel_equ_icon:removeBackGroundImage()
    local picIndex = dms.int(dms["equipment_mould"], equip_moudl_id, equipment_mould.pic_index)
	Panel_equ_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
	
    --装备名称
    local Text_equ_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_name")
    --获取装备名称索引
    local nameindex = dms.int(dms["equipment_mould"], equip_moudl_id, equipment_mould.equipment_name)
    --通过索引找到word_mould
    local word_info = dms.element(dms["word_mould"], nameindex)
	local name = word_info[3]

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
	Text_equ_name:setString(name)
	-- Text_equ_name no tiene caja (una sola linea, x=137 de la raiz) y la
	-- columna de pestanas del padre (Enhance/Awaken/Temple) lo tapa a partir
	-- de unos 190 px: el ruso Volshebny posoj +5 salia cortado. Se encoge para caber.
	local anchoNombre = Text_equ_name:getContentSize().width
	Text_equ_name:setScale(anchoNombre > 185 and 185 / anchoNombre or 1)

	--星级
    for i=1, 5 do
        local equ_star = ccui.Helper:seekWidgetByName(self.roots[1], "equ_star_"..i)
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
	local maxLv = dms.int(dms["play_config"], 182, play_config.param)
	self.Text_equ_lv_n:setString(lv.."/"..maxLv)

	-- 经验
	local exp = hardsInfo.exp
	local levelMould = SmEquipmentQunenchingHandle.getLevelMould(lv , e_index)
	local levelExp = tonumber(levelMould[1][3])
	self.LoadingBar_equ_exp_max:setVisible(false)
	self.Text_exp_number_max:setVisible(false)
	self.LoadingBar_equ_exp:setVisible(false)
	self.Text_exp_number:setVisible(false)

	-- 金币
	local levelGold = tonumber(levelMould[1][4])
	self.Text_role_up_quality_num_1:setString(levelGold)
	self.Text_role_up_quality_num_1:setVisible(false)
	self.Image_role_up_quality_add_1_0:setVisible(false)
	if lv >= maxLv then 
		-- 满级
		self.LoadingBar_equ_exp_max:setVisible(true)
		self.Text_exp_number_max:setVisible(true)
	else
		self.LoadingBar_equ_exp:setPercent(tonumber(exp)/tonumber(levelExp)*100)
		self.Text_exp_number:setString(exp.."/"..levelExp)
		self.LoadingBar_equ_exp:setVisible(true)
		self.Text_exp_number:setVisible(true)
		self.Text_role_up_quality_num_1:setVisible(true)
		self.Image_role_up_quality_add_1_0:setVisible(true)
	end

	

	-- 道具显示
	local propData = dms.string(dms["play_config"], 182 + e_index, play_config.param)
	local cell = self:addResourcesIconCell(propData)
	self.Panel_role_up_quality_box_1:removeAllChildren(true)
	cell:setAnchorPoint(cc.p(0.5,0.5))
	cell:setPosition(cc.p(self.Panel_role_up_quality_box_1:getContentSize().width/2,self.Panel_role_up_quality_box_1:getContentSize().height/2))
	self.Panel_role_up_quality_box_1:addChild(cell)

	for i=1,2 do
		-- 隐藏属性
		local Panel_shuxing_1 = ccui.Helper:seekWidgetByName(root, "Panel_shuxing_"..i)
		Panel_shuxing_1:setVisible(false)
	end
	
	-- 普通属性
	if hardsInfo.baseProperty then 
		local baseProp = zstring.split(hardsInfo.baseProperty,"|")
		
		for i=1,#baseProp do
			local Panel_shuxing_1 = ccui.Helper:seekWidgetByName(root, "Panel_shuxing_"..i)
			Panel_shuxing_1:setVisible(true)
			local temps = zstring.split(baseProp[i],",")
			local propKey = temps[1]
			local propVal = temps[2]
			local Text_equ_attribute_1 = ccui.Helper:seekWidgetByName(root, "Text_equ_attribute_"..i)
			local Text_equ_attribute_n_1 = ccui.Helper:seekWidgetByName(root, "Text_equ_attribute_n_"..i)
			local name,value = getHardenPropertyNameAndValue(propKey, propVal)
			Text_equ_attribute_1:setString(""..name)
			Text_equ_attribute_n_1:setString(""..value)
		end
	else
		for i=1,2 do
			-- 隐藏属性
			local Text_equ_attribute_n_1 = ccui.Helper:seekWidgetByName(root, "Text_equ_attribute_n_"..i)
			Text_equ_attribute_n_1:setString("0")
		end
	end
	
	--词条属性
	for i = 1,3 do 
		local Panel_citiao_1 = ccui.Helper:seekWidgetByName(root, "Panel_citiao_"..i)
		Panel_citiao_1:setVisible(false)
	end

	if hardsInfo.entryInfos and 0 < #hardsInfo.entryInfos then
		local entryInfos = hardsInfo.entryInfos
		for i=1,#entryInfos do
			local entryInfo = zstring.split(entryInfos[i],"|")
			-- 词条等级
			local entryInfoLevel = tonumber(entryInfo[1])
			local entryInfoPropty = entryInfo[2]

			-- 播放动画
			if self.aniFalg then 
				-- 出现词条
				local levelConfig = zstring.split(dms.string(dms["play_config"], 194, play_config.param),",")
				local Panel_dh_1 = ccui.Helper:seekWidgetByName(root, "Panel_dh_"..i)
				if (tonumber(lv) == tonumber(levelConfig[i]) and self.lastLv ~= tonumber(lv)) or tonumber(self.entryLevels[i]) ~= tonumber(entryInfoLevel) then 
					self.entryLevels[i] = entryInfoLevel
					self:hardenAni(3,Panel_dh_1)
				end 
			end
			-- 词条属性
			local proptys = zstring.split(entryInfoPropty,",")
			local proKey = proptys[1]
			local proVal = proptys[2]
			local Panel_citiao_1 = ccui.Helper:seekWidgetByName(root, "Panel_citiao_"..i)
			Panel_citiao_1:setVisible(true)

			-- 属性
			local name,val = getHardenPropertyNameAndValue(proKey, proVal)
			local Text_shuxing_1 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_"..i)
			Text_shuxing_1:setString(string.format(tipStringInfo_equipment_harden[10],tostring(tonumber(entryInfoLevel) + 1))..name..val)

			-- 范围
			local rangeStr = SmEquipmentQunenchingHandle.getRange(entryInfoLevel, e_index, tonumber(proKey))
			if nil ~= string.find(name..val,"%%") then 
				local range = zstring.split(rangeStr,",")
				local Text_fanwei_1 = ccui.Helper:seekWidgetByName(root, "Text_fanwei_"..i)
				Text_fanwei_1:setString(string.format(tipStringInfo_equipment_harden[7],range[1].."%".."-"..range[2].."%"))
			else
				local range = zstring.replace(rangeStr,",","-")
				local Text_fanwei_1 = ccui.Helper:seekWidgetByName(root, "Text_fanwei_"..i)
				Text_fanwei_1:setString(string.format(tipStringInfo_equipment_harden[7],range))
			end
			
		end
		self.aniFalg = false
	end
	
	if _ED.equipment_hardensInfo_boom ~= nil then 
		if 1 == tonumber(_ED.equipment_hardensInfo_boom) then
			--不暴击
			self:hardenAni(1,self.Panel_sjdh)
		else
			--暴击
			self:hardenAni(2,self.Panel_sjdh)
			self:hardenAni(4,self.Panel_exp_dh)
		end
		_ED.equipment_hardensInfo_boom = nil
	end

	local newStar = zstring.split(shipEquip[4], ",")
	local awakeLevel = tonumber(newStar[tonumber(e_index)])

	if hardsInfo.baseProperty and dms.int(dms["play_config"], 196, play_config.param) > awakeLevel then 
		-- 重生后不生效
		self:setRed(true)
	else
		self:setRed(false)
		self.Button_equ_up_zh:setBright(true)
		self.Button_equ_up_zh:setTouchEnabled(true)
	end
end

-- 添加道具图标
function SmEquipmentQianghuaTab3Window1:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = 6
	local haveNum = 0
	if fundPropWidthId(propData) then 
		haveNum = tonumber(fundPropWidthId(propData).prop_number)
	end
	
	cell:init(rewardType, haveNum, tonumber(propData), nil, nil, true ,true, 1)
	
	return cell
end

function SmEquipmentQianghuaTab3Window1:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow     
    self:onInit()
    return self
end

function SmEquipmentQianghuaTab3Window1:onInit()
	-- 加载SmEquipmentQianghuaTab3Window1Window界面资源.
	-- res.packs.EquipStorage.sm_equipment_qianghua_tab_3_window_1 = res/packs/EquipStorage/sm_equipment_qianghua_tab_3_window_1.csb
	local csbNode = csb.createNode("packs/EquipStorage/sm_equipment_qianghua_tab_3.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭窗口
	self.Button_icon_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_icon_back"), nil,
	{
		terminal_name = "sm_equipment_qianghua_tab3_window1_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 置换按钮
	self.Button_equ_up_zh = ccui.Helper:seekWidgetByName(root, "Button_equ_up_zh")
	fwin:addTouchEventListener(self.Button_equ_up_zh, nil,
	{
		terminal_name = "sm_equipment_qianghua_tab3_window1_substitution",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	
	-- 快速淬炼按钮
	self.Button_equ_up_kscl = ccui.Helper:seekWidgetByName(root, "Button_equ_up_kscl")
	fwin:addTouchEventListener(self.Button_equ_up_kscl, nil,
	{
		terminal_name = "sm_equipment_qianghua_tab3_window1_harden",
		terminal_state = 0,
		m_type = 2,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 普通容器
	self.Panel_role_up_quality_box_1 = ccui.Helper:seekWidgetByName(root, "Panel_role_up_quality_box_1")
	fwin:addTouchEventListener(self.Panel_role_up_quality_box_1, nil,
	{
		terminal_name = "sm_equipment_qianghua_tab3_window1_harden",
		terminal_state = 0,
		m_type = 1,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 规则按钮
	self.Button_rule = ccui.Helper:seekWidgetByName(root, "Button_rule")
	if self.Button_rule then 
		self.Button_rule:setVisible(true)
        fwin:addTouchEventListener(self.Button_rule, nil,
        {
            terminal_name = "equipment_qunenching_window_open",
            terminal_state = 0,
            isPressedActionEnabled = true,
        }, nil, 0)	
    end

	local Panel_cxdh = ccui.Helper:seekWidgetByName(root, "Panel_cxdh")
    Panel_cxdh:removeAllChildren(true)

    local jsonFile = "sprite/sprite_zhuangbei_qh.json"
    local atlasFile = "sprite/sprite_zhuangbei_qh.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    Panel_cxdh:addChild(animation)

	self:onDraw()
	self:onUpdateDraw()
end
function SmEquipmentQianghuaTab3Window1:onEnterTransitionFinish()
	
end

function SmEquipmentQianghuaTab3Window1:onExit()
	-- 释放SmEquipmentQianghuaTab3Window1Window界面资源.
	state_machine.remove("sm_equipment_qianghua_tab3_window1_open")
	state_machine.remove("sm_equipment_qianghua_tab3_window1_close")
	state_machine.remove("sm_equipment_qianghua_tab3_window1_show")
	state_machine.remove("sm_equipment_qianghua_tab3_window1_hide")
	state_machine.remove("sm_equipment_qianghua_tab3_window1_change_ship")
	state_machine.remove("sm_equipment_qianghua_tab3_window1_update_draw")
	state_machine.remove("sm_equipment_qianghua_tab3_window1_substitution")
	state_machine.remove("sm_equipment_qianghua_tab3_window1_harden")
	
end

function SmEquipmentQianghuaTab3Window1:close()
	-- window event : close.
	
end

function SmEquipmentQianghuaTab3Window1:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
