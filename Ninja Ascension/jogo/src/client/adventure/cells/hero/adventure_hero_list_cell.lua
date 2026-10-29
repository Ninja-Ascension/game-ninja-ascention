----------------------------------------------------------------------------------------------------
-- 说明：武将强化专属列表
----------------------------------------------------------------------------------------------------
AdventureHeroListCell = class("AdventureHeroListCellClass", Window)
AdventureHeroListCell.__size = nil

app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
app.load("client.adventure.cells.skill.adventure_skill_icon_cell")
app.load("client.adventure.mercenary.formation.AdventureFateStrengthen")
app.load("client.adventure.mercenary.formation.AdventureStrengthenManager")
app.load("client.adventure.mercenary.formation.AdventureHeroChange")
function AdventureHeroListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.hero = nil
	self.mould_data = nil
	self.drawIndex = 0
    self.updateButton = nil
    self.autoSendMessage = {}
    self.shipId = nil
    self.qianghuaButton = nil
    self.isHaveBaoju = nil
    self.pressTime = 0 
    self.is_open_juexing = false
    self.is_open_quick_exp = false
	
	-- Initialize adventure hero list cell state machine.
	local function init_adventure_hero_list_cell_terminal()
		-- 转换
        local adventure_hero_list_cell_exchange_terminal = {
            _name = "adventure_hero_list_cell_exchange",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local hero = cell.hero
                fwin:open(AdventureHeroChage:new():init(cell.hero, cell,"adventure_hero_list_cell_update_info"), fwin._ui)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- -- 锻造
        -- local adventure_hero_list_cell_equipment_strengthen_terminal = {
        --     _name = "adventure_hero_list_cell_equipment_strengthen",
        --     _init = function (terminal)
                
        --     end,
        --     _inited = false,
        --     _instance = self,
        --     _state = 0,
        --     _invoke = function(terminal, instance, params)
        --         local cell = params._datas.cell
        --         local hero = cell.hero
        --         if tonumber(hero.captain_type) == 0 then -- 主角宿命武器
        --             fwin:open(AdventureFateStrengthen:new():init(hero, cell), fwin._ui)
        --         else -- 武具、宝具强化
        --             fwin:open(AdventureStrengthenManager:new():init(hero, cell), fwin._ui)
        --             state_machine.excute("adventure_strengthen_manager_manager", 0, 
        --                 {_datas = {
        --                     terminal_name = "adventure_strengthen_manager_manager",     
        --                     next_terminal_name = "adventure_strengthen_manager_open_treasure_strengthen",      
        --                     current_button_name = "Button_tab_baoju",        
        --                     but_image = "",   
        --                     terminal_state = 0, 
        --                     isPressedActionEnabled = false
        --                 }}
        --             )
        --         end
        --         return true
        --     end,
        --     _terminal = nil,
        --     _terminals = nil
        -- }

        -- 升级
        local adventure_hero_list_cell_level_up_terminal = {
            _name = "adventure_hero_list_cell_level_up",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
                local function responseShipEscalateCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                        	response.node:updateDraw()
                        	response.node:playAction()
                            response.node:showQuickExp()
							state_machine.excute("adventure_hero_storage_update_capacity_", 0, "")
                        else
                            response.node:updateDraw()
                        end
                         state_machine.excute("adventure_hero_storage_update_hero_list_up_states", 0, "")
                    end
                end

                protocol_command.ship_escalate.param_list = "0" .. "\r\n" .. cell.hero.ship_id .. "\r\n" .. "" .. "\r\n" 
                NetworkManager:register(protocol_command.ship_escalate.code, nil, nil, nil, cell, responseShipEscalateCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_hero_list_cell_level_up_quick_terminal = {
            _name = "adventure_hero_list_cell_level_up_quick",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local function responseShipEscalateCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:updateDraw()
                            response.node:showQuickExp()
                            state_machine.excute("adventure_hero_storage_update_capacity_", 0, "")
                        else
                            response.node:updateDraw()
                        end
                         state_machine.excute("adventure_hero_storage_update_hero_list_up_states", 0, "")
                    end
                end

                protocol_command.ship_escalate.param_list = "1" .. "\r\n" .. cell.hero.ship_id .. "\r\n" .. "" .. "\r\n" 
                NetworkManager:register(protocol_command.ship_escalate.code, nil, nil, nil, cell, responseShipEscalateCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 觉醒
        local adventure_hero_list_cell_advance_terminal = {
            _name = "adventure_hero_list_cell_advance",
            _init = function (terminal)
                app.load("client.adventure.mercenary.formation.AdventureHeroAwakenManager")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                 local cell = params._datas.cell
                 fwin:open(AdventureHeroAwakenManager:new():init(cell.hero, cell,1), fwin._ui)
                -- local cell = params._datas.cell
                -- local hero = cell.hero
                -- fwin:open(AdventureHeroChage:new():init(cell.hero, cell,"adventure_hero_list_cell_update_info"), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开突破界面
        local adventure_hero_list_cell_to_po_terminal = {
            _name = "adventure_hero_list_cell_to_po",
            _init = function (terminal)
                app.load("client.adventure.mercenary.formation.AdventureHeroAwakenManager")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                fwin:open(AdventureHeroAwakenManager:new():init(cell.hero, cell,2), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 刷新显示信息
        local adventure_hero_list_cell_update_info_terminal = {
            _name = "adventure_hero_list_cell_update_info",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if fwin:find("AdventureHeroListCellClass")  then
                    fwin:find("AdventureHeroListCellClass"):updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开英雄信息
        local adventure_hero_list_cell_open_hero_info_terminal = {
            _name = "adventure_hero_list_cell_open_hero_info",
            _init = function (terminal)
                app.load("client.adventure.packs.hero.AdventureHeroInformation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                
                fwin:open(AdventureHeroInformation:new():init(cell.hero, cell), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_hero_list_cell_level_up_terminal)
        state_machine.add(adventure_hero_list_cell_advance_terminal)
        state_machine.add(adventure_hero_list_cell_update_info_terminal)
        state_machine.add(adventure_hero_list_cell_to_po_terminal)
        state_machine.add(adventure_hero_list_cell_open_hero_info_terminal)
        state_machine.add(adventure_hero_list_cell_exchange_terminal)
        state_machine.add(adventure_hero_list_cell_level_up_quick_terminal)
    
        state_machine.init()
	end

	-- call func init adventure hero list cell state machine.
	init_adventure_hero_list_cell_terminal()
end

function AdventureHeroListCell:playAction()
	-- local action = self.actions[1]
	-- action:play("upgrade", false)

    -- local pos = self:convertToWorldSpaceAR(cc.p(self:getPosition()))
    -- pos.x = pos.x + app.baseOffsetX / 2
    -- -- pos.y = pos.y + self:getContentSize().height
    -- app.load("client.adventure.packs.hero.AdventureHeroLevelUpAction")
    -- fwin:open(AdventureHeroLevelUpAction:new():init(pos.x,pos.y, self))
    if self.actions ~= nil and self.actions[1] ~= nil then 
        self.actions[1]:play("level_up",false)
    end
end

function AdventureHeroListCell:showQuickExp()
    local root = self.roots[1]

    if root == nil then 
         -- 玩家在很快 拖动时候,会不停的reload,unload
        return false
    end
    local quick_button = ccui.Helper:seekWidgetByName(root, "Button_yijian")
    if self.is_open_juexing == true or self.is_open_quick_exp == false then 
        quick_button:setVisible(false)
        quick_button:setOpacity(255)
        return
    end

    local function delayEndFuncN( _sender )
        if _sender ~= nil then
            _sender:setVisible(false)
            _sender:setTouchEnabled(true)
        end
    end 
    
    quick_button:setVisible(true)
    quick_button:setOpacity(255)
    quick_button:stopAllActions()
    local actions = {}
    table.insert(actions, cc.DelayTime:create(1.2))

    table.insert(actions, cc.FadeOut:create(0.8))
    table.insert(actions, cc.CallFunc:create(delayEndFuncN))
    local seq = cc.Sequence:create(actions)
    quick_button:runAction(seq)
end

function AdventureHeroListCell:updateDraw()
	local root = self.roots[1]

    if root == nil then 
         -- 玩家在很快 拖动时候,会不停的reload,unload
        return false
    end
    -- 绘制品质底框
    local hero_mould_data = _ED.user_ship["" .. self.shipId]


    self.mould_data = hero_mould_data.mould_data or dms.element(dms["ship_mould"], hero_mould_data.ship_template_id)

	quality = dms.atoi(self.mould_data, ship_mould.ship_type)
	local qualityImage = string.format("images/ui/quality/icon_hero_%d.png", quality+1)
	ccui.Helper:seekWidgetByName(root, "Panel_pingzhi_di"):setBackGroundImage(qualityImage)

   -- 绘制图像
   local picIndex = dms.atos(self.mould_data, ship_mould.head_icon)
   local headImage = string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(picIndex))
   
   ccui.Helper:seekWidgetByName(root, "Panel_role"):setBackGroundImage(headImage)
    
	-- 绘制等级
	local level = zstring.tonumber(self.hero.ship_grade)
	ccui.Helper:seekWidgetByName(root, "Text_role_dj"):setString("" .. level)

	-- 突破等级
	local advanceLevel, maxAdvanceLevel = self:getShipAwakenLv2(self.hero.ship_template_id, self.hero.ship_base_template_id)
	local advancePanel = ccui.Helper:seekWidgetByName(root, "Panel_pingzhi")
	for i = 1, 5 do
		local cell = advancePanel:getChildByName("Image_pz_" .. i)
		if i > maxAdvanceLevel then
			cell:setVisible(false)
		else
			cell:setVisible(true)
			if i > advanceLevel then
				cell:setColor(cc.c3b(150, 150, 150))
			else
				cell:setColor(cc.c3b(255, 255, 255))
			end
		end
	end
    
  
	-- 绘制武将名称
	local Text_rolename = ccui.Helper:seekWidgetByName(root, "Text_rolename")
	Text_rolename:setColor(cc.c3b(hero_name_color_Type[quality+1][1],hero_name_color_Type[quality+1][2],hero_name_color_Type[quality+1][3]))
	if tonumber(self.hero.captain_type) == 0 then
		Text_rolename:setString(_ED.user_info.user_name)
        if ___is_open_leadname == true then
            Text_rolename:setFontName("")
            Text_rolename:setFontSize(Text_rolename:getFontSize())
        end
	else
		Text_rolename:setString(self.hero.captain_name)
         if zstring.tonumber(_game_platform_version_type) == 4 then 
            --东南亚版本
            local heroName =  dms.atos(self.mould_data, ship_mould.captain_name)
            Text_rolename:setString(heroName)    
        else
            --正常版本
            Text_rolename:setString(self.hero.captain_name)    
        end
	end

	-- 绘制武将的战力
	local Text_zhanli_all = ccui.Helper:seekWidgetByName(root, "Text_zhanli_all")
	Text_zhanli_all:setString(getResourceValueToStringForAdventure(self.hero.hero_fight))

    local maxStrengthenLevel = 0
    if tonumber(self.hero.captain_type) == 0 then
        maxStrengthenLevel = #dms["destiny_strength_param"]
    else
        maxStrengthenLevel = #dms["ship_rank_up_param"]
    end

    local equipment_strengthen_level = zstring.tonumber(self.hero.equipment_strengthen_level)

    local max_strength_level = dms.atoi(self.mould_data, ship_mould.rank_grow_up_limit)
    local isOpen = max_strength_level > 0  and max_strength_level <= level --是否可以觉醒
    self.is_open_juexing = isOpen
    -- 显示觉醒
    ccui.Helper:seekWidgetByName(root, "Button_juexing"):setVisible(isOpen)
    local ButtonShengji = ccui.Helper:seekWidgetByName(root, "Button_shengji")
    local Buttontupo = ccui.Helper:seekWidgetByName(root, "Button_tupo")
    Buttontupo:setVisible(false)

    local local_exp = 0
    local local_exp_id = 0
    local exp_str_table  = dms.searchs(dms["ship_experience_param"],ship_experience_param.stage,advanceLevel)
    if exp_str_table ~= nil then 
        for i, v in pairs(exp_str_table) do
            --遍历升级所需要的经验 在ship_experience_param 查找
            if tonumber(v[2]) == tonumber(level) then
                local_exp = v[3]
                local_exp_id = v[1] -- 找到当前所需要经验的ID ,计算出一键升级所需要的经验
               break
            end
        end
    end
    local Text_sj_exp_10 = ccui.Helper:seekWidgetByName(root, "Text_5") --一键升级所需要的经验
    local Text_sj_level_10 = ccui.Helper:seekWidgetByName(root, "Text_1") --一键升级的级数
    local Text_sj_zdl_10 = ccui.Helper:seekWidgetByName(root, "Text_3") --一键升级得到的战斗力

    --计算一键升级
    local total_exp = tonumber(_ED.user_info.resource_experience) + tonumber(_ED.user_info.addExperience)
    local add_sum_exp = 0
    local quick_up_num = 0
    if zstring.tonumber(local_exp_id) >= 1 then 
        for i=1,10 do
            local need_exp = dms.int(dms["ship_experience_param"], i + local_exp_id - 1, ship_experience_param.needs_experience)
            if need_exp ~= 0 and need_exp ~= nil then 
                if need_exp + add_sum_exp < total_exp then 
                    quick_up_num = quick_up_num + 1 
                    add_sum_exp = add_sum_exp + need_exp
                else
                    break
                end
            else
                break
            end
        end
        Text_sj_zdl_10:setString("+" .. get_ship_strength_added_fight_force_quick(self.hero,zstring.tonumber(self.hero.ship_grade) + quick_up_num))
    else
        --不能一键升级
        Text_sj_zdl_10:setString("+" .. 0)
    end
    if quick_up_num > 0 then 
        self.is_open_quick_exp = true
    else
        self.is_open_quick_exp = false
    end
     if zstring.tonumber(add_sum_exp) > 1000000000 then
            Text_sj_exp_10:setString("-" .. string.format("%.02f",add_sum_exp/ 1000000000) .. string_equiprety_name[42])
        elseif zstring.tonumber(add_sum_exp)> 1000000 then
            Text_sj_exp_10:setString("-" .. string.format("%.02f",add_sum_exp / 1000000) .. string_equiprety_name[41])
        elseif zstring.tonumber(add_sum_exp)> 1000 then
            Text_sj_exp_10:setString("-" .. string.format("%.02f",add_sum_exp / 1000) .. string_equiprety_name[40])
        else
            Text_sj_exp_10:setString("-" .. add_sum_exp)
    end
    Text_sj_level_10:setString("+" .. quick_up_num)
    
    ButtonShengji:setColor(cc.c3b(255, 255, 255))
    ccui.Helper:seekWidgetByName(root, "Image_7_0"):setColor(cc.c3b(255, 255, 255))
    ccui.Helper:seekWidgetByName(root, "Image_zhanli"):setColor(cc.c3b(255, 255, 255))
    local button_yijian = ccui.Helper:seekWidgetByName(root, "Button_yijian")
    button_yijian:setVisible(false)
    
    if isOpen == true then 
        --取消一键升级按钮
        button_yijian:setVisible(false)
        button_yijian:stopAllActions()
    end
    
    --Text_sj_exp_10:setString("+" .. get_ship_strength_added_fight_force(self.hero))
     local Text_zhanli_sj = ccui.Helper:seekWidgetByName(root, "Text_zhanli_sj")
    Text_zhanli_sj:setString("+" .. get_ship_strength_added_fight_force(self.hero))
    local Text_shengji_exp = ccui.Helper:seekWidgetByName(root, "Text_shengji_exp")
    if isOpen == false then
       
        --　有升级按钮的时候，可以自动长按发送
        self.autoSendMessage._start_send = false
    else
    	-- 觉醒-战力值
    	local Text_zhanli_jx = ccui.Helper:seekWidgetByName(root, "Text_zhanli_jx")
    	Text_zhanli_jx:setString("" .. (get_ship_growup_added_fight_force(self.hero)))

    	-- 觉醒-巨魔像消耗
        local shipGrowRequirement = dms.element(dms["ship_grow_requirement"], advanceLevel)
    	local Text_jumo = ccui.Helper:seekWidgetByName(root, "Text_jumo")
    	Text_jumo:setString("-" .. (dms.atoi(shipGrowRequirement, ship_grow_requirement.need_prop1_count) or 0))
        --觉醒按钮就不能发送
        self.autoSendMessage._start_send = true
        ButtonShengji:setHighlighted(false)
    end
    --判断是否升级满级了 (这个地方应该从ship_rank_up_param表中获取下一级升级经验数)
    if tonumber(max_strength_level) == -1  and tonumber(local_exp) == 0 then
        ButtonShengji:setVisible(false)
    else
        ButtonShengji:setVisible(true)
        local showExt = tonumber(local_exp)
        if zstring.tonumber(showExt) > 1000000000 then
                Text_shengji_exp:setString("-" .. string.format("%.02f",showExt/ 1000000000) .. string_equiprety_name[42])
            elseif zstring.tonumber(showExt)> 1000000 then
                Text_shengji_exp:setString("-" .. string.format("%.02f",showExt / 1000000) .. string_equiprety_name[41])
            elseif zstring.tonumber(showExt)> 1000 then
                Text_shengji_exp:setString("-" .. string.format("%.02f",showExt / 1000) .. string_equiprety_name[40])
            else
                Text_shengji_exp:setString("-" .. showExt)
        end
        if showExt < tonumber(_ED.user_info.resource_experience) + tonumber(_ED.user_info.addExperience) and showExt ~= 0 then 
            --可以升级
            ButtonShengji:setColor(cc.c3b(255, 255, 255))
            ccui.Helper:seekWidgetByName(root, "Image_7_0"):setColor(cc.c3b(255, 255, 255))
            ccui.Helper:seekWidgetByName(root, "Image_zhanli"):setColor(cc.c3b(255, 255, 255))
            ccui.Helper:seekWidgetByName(root, "Image_zhanli"):setColor(cc.c3b(255, 255, 255))
        else
            ButtonShengji:setColor(cc.c3b(150, 150, 150))
            ccui.Helper:seekWidgetByName(root, "Image_7_0"):setColor(cc.c3b(150, 150, 150))
            ccui.Helper:seekWidgetByName(root, "Image_zhanli"):setColor(cc.c3b(150, 150, 150))
        end
    end
    local piratesConfig = dms.element(dms['pirates_config'],308)
    local maxLevel = dms.atoi(piratesConfig,pirates_config.param)
    local Button_zhuanhuan  = ccui.Helper:seekWidgetByName(root, "Button_zhuanhuan")
    local siwei_panel = ccui.Helper:seekWidgetByName(root, "Panel_siwei")
    local siwei_text = ccui.Helper:seekWidgetByName(root, "Text_siwei")
    siwei_text:setString("")
    siwei_panel:removeAllChildren(true)
    local tupo_text = ccui.Helper:seekWidgetByName(root, "Text_tupo_8")
    tupo_text:setString("")
    if tonumber(hero_mould_data.ship_breakthrough_level) >= maxLevel then
        --可以刷新
        Button_zhuanhuan:setVisible(true)
         local siweiIndex ,leavel = getSiweiAttribute(hero_mould_data)
         if siweiIndex == -1 then 

        else
            siwei_text:setString("".. leavel)
            siwei_panel:setBackGroundImage(string.format("images/ui/icon/icon_shuxin_%d.png", siweiIndex))
        end
    else
        Button_zhuanhuan:setVisible(false)

         if advanceLevel >= maxAdvanceLevel and maxAdvanceLevel >= 5 and tonumber(hero_mould_data.captain_type) ~= 0 then  
            Buttontupo:setVisible(true)
            local shipBreakthroughLevel = zstring.tonumber(hero_mould_data.ship_breakthrough_level)
            tupo_text:setString("" .. (dms.string(dms["limit_breached"], shipBreakthroughLevel, limit_breached.add_power) or 0) .. "%")
         end
    end

end

function AdventureHeroListCell:onUpdate(dt)
    -- 长按升级按钮 自动升级
    -- if self.updateButton ~= nil and self.updateButton:isHighlighted() == false then 
    --     self.pressTime = 0 
    -- end

    -- if self.updateButton ~= nil and self.updateButton:isHighlighted() == true then
    --     self.pressTime = self.pressTime + 1 
    --     -- 太敏感了,执行累加3帧的时候,才算长按
    --     if self.pressTime >=3 then 
    --     else
    --         return
    --     end

    --     if self.autoSendMessage._start_send == nil or self.autoSendMessage._start_send == false  then
    --         -- if self.autoSendMessage._start_Time ~= nil and  os.time() - self.autoSendMessage._start_Time < 3 then
    --         --    print(" ====== pduan luoji fasong buxing")
    --         --     print(" ==== 当前时间---",os.time())-- - self.autoSendMessage._start_Time)
    --         --     return
    --         -- end
    --         self.pressTime = 0
    --         self.autoSendMessage._start_send = true
    --         local function responseUpdateCallBack(response)
                --_ED.baseFightingCount = calcTotalFormationFight() 
    --              self.pressTime = 0
    --           if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
    --                 if response.node ~= nil and response.node.roots ~= nil then
                    
    --                     response.node:updateDraw()
    --                     response.node:playAction()
    --                     state_machine.excute("adventure_hero_storage_update_capacity_", 0, "")
                    

    --                     self.autoSendMessage._start_Time = os.time()
    --                     self.autoSendMessage._start_send = false
    --                 end
    --                 --debug.print_r(self.autoSendMessage.startTime)
    --             else
    --                 if response.node ~= nil and response.node.roots ~= nil then 
    --                     self.autoSendMessage._start_send  = true -- 顶级不能长按
    --                 end
    --             end
    --             state_machine.excute("adventure_hero_storage_update_hero_list_up_states", 0, "")
    --         end
    --     protocol_command.ship_escalate.param_list = "0" .. "\r\n" .. self.hero.ship_id .. "\r\n" .. "" .. "\r\n" 
    --     NetworkManager:register(protocol_command.ship_escalate.code, nil, nil, nil, self, responseUpdateCallBack, false, nil)
    --     end
    -- end
end

function AdventureHeroListCell:onUpdateUpStates()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local max_strength_level = dms.atoi(self.mould_data, ship_mould.rank_grow_up_limit)
    local level = zstring.tonumber(self.hero.ship_grade)
    local isOpen = max_strength_level > 0  and max_strength_level <= level
    -- 显示觉醒
    local ButtonShengji = ccui.Helper:seekWidgetByName(root, "Button_shengji")
    ButtonShengji:setColor(cc.c3b(255, 255, 255))
    local image1 = ccui.Helper:seekWidgetByName(root, "Image_7_0")
    image1:setColor(cc.c3b(255, 255, 255))
    local image2 = ccui.Helper:seekWidgetByName(root, "Image_zhanli")
    image2:setColor(cc.c3b(255, 255, 255))
    local advanceLevel, maxAdvanceLevel = self:getShipAwakenLv2(self.hero.ship_template_id, self.hero.ship_base_template_id)
    local local_exp = 0
    local exp_str_table = dms.searchs(dms["ship_experience_param"],ship_experience_param.stage,advanceLevel)
    if exp_str_table ~= nil then 
        for i, v in pairs(exp_str_table) do
            --遍历升级所需要的经验 在ship_experience_param 查找
            if tonumber(v[2]) == tonumber(level) then
                local_exp = v[3]
               break
            end
        end
    end
        
    if tonumber(local_exp) < tonumber(_ED.user_info.resource_experience) + tonumber(_ED.user_info.addExperience) and tonumber(local_exp) ~= 0 then 
    
        --经验够了,可以升级
        ButtonShengji:setColor(cc.c3b(255, 255, 255))
        image1:setColor(cc.c3b(255, 255, 255))
        image2:setColor(cc.c3b(255, 255, 255))
    else
        ButtonShengji:setColor(cc.c3b(150, 150, 150))
        image1:setColor(cc.c3b(150, 150, 150))
        image2:setColor(cc.c3b(150, 150, 150))
    end
end

-- /**
-- *mouldid				模板id
-- *baseMouldid			相同英雄标识id
-- */
function AdventureHeroListCell:getShipAwakenLv2(mouldid,baseMouldid)
	mouldid = zstring.tonumber(mouldid)
	baseMouldid = zstring.tonumber(baseMouldid)
	local theCurrentAwakenLv = dms.string(dms["ship_mould"], mouldid, ship_mould.initial_rank_level)
	local theMaxAwakenLv = dms.string(dms["ship_mould"], mouldid, ship_mould.max_rank_level)
	
	return zstring.tonumber(theCurrentAwakenLv), zstring.tonumber(theMaxAwakenLv)
end

function AdventureHeroListCell:onInit()
	self.roots = {}
    self.actions = {}
	local root = cacher.createUIRef("list/list_team_zhanli_0.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
    root:setSwallowTouches(false)
    self.is_open_quick_exp = false
    -- 刷新的时候移到前面来,放置玩家在拖动的时候,程序很快的 reload unreLoad 可能影响不大
    self:updateDraw()

    local action = csb.createTimeline("list/list_team_zhanli_0.csb")
    table.insert(self.actions, action)
    root:runAction(action)
    
	if AdventureHeroListCell.__size == nil then
		AdventureHeroListCell.__size = root:getContentSize()
	end

    -- 转换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhuanhuan"),       nil, 
    {
        terminal_name = "adventure_hero_list_cell_exchange",       
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_pingzhi_di")
    Panel_role:setTouchEnabled(true)
    --Panel_role:setSwallowTouches(false)
    --打开英雄信息界面
    fwin:addTouchEventListener(Panel_role,       nil, 
    {
        terminal_name = "adventure_hero_list_cell_open_hero_info",       
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    self.updateButton = ccui.Helper:seekWidgetByName(root, "Button_shengji")
    self.updateButton:setHighlighted(false)
    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shengji"),       nil, 
    {
        terminal_name = "adventure_hero_list_cell_level_up",       
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --一键升级
    local function formationTouchListener(sender, eventType)
        if eventType == ccui.TouchEventType.began then
          
        elseif eventType == ccui.TouchEventType.moved then 
          
        elseif eventType == ccui.TouchEventType.ended then 
            if sender._self ~= nil then 
                state_machine.excute("adventure_hero_list_cell_level_up_quick",0,{_datas = {cell = sender._self}})
            end
        else 

        end
    end
    ccui.Helper:seekWidgetByName(root, "Button_yijian")._self = self
    ccui.Helper:seekWidgetByName(root, "Button_yijian"):addTouchEventListener(formationTouchListener)
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yijian"),       nil, 
    -- {
    --     terminal_name = "adventure_hero_list_cell_level_up_quick",       
    --     terminal_state = 0, 
    --     cell = self,
    --     isPressedActionEnabled = false
    -- }, 
    -- nil, 0)
	
    -- -- 觉醒
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_juexing"),       nil, 
    {
        terminal_name = "adventure_hero_list_cell_advance",       
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	-- -- 突破
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tupo"),       nil, 
    {
        terminal_name = "adventure_hero_list_cell_to_po",       
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0) 
end

function AdventureHeroListCell:onExit()
	cacher.freeRef("list/list_team_zhanli_0.csb", self.roots[1])
    self.roots = {}
    
    state_machine.remove("adventure_hero_list_cell_level_up")
    state_machine.remove("adventure_hero_list_cell_advance")
    state_machine.remove("adventure_hero_list_cell_update_info")
    state_machine.remove("adventure_hero_list_cell_to_po")
    state_machine.remove("adventure_hero_list_cell_open_hero_info")
    state_machine.remove("adventure_hero_list_cell_level_up_quick")
end

function AdventureHeroListCell:init(hero,shipid, drawIndex)
	self.hero = hero
    self.shipId = shipid
	self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
	self.drawIndex = drawIndex

	if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	end

	self:setContentSize(AdventureHeroListCell.__size)
	return self
end

function AdventureHeroListCell:reload()
	local root = self.roots[1]
    self.pressTime = 0 
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureHeroListCell:unload()
	local root = self.roots[1]
    self.pressTime = 0 
	if root == nil then
		return
	end
    if self.actions[1] ~= nil then 
        self.actions[1]:stop()
        self.actions = nil
    end

    -- local button_shengji = ccui.Helper:seekWidgetByName(root, "Button_shengji")
    -- if button_shengji ~= nil then 
    --     button_shengji:setHighlighted(false)
    -- end
    -- self.updateButton = nil
	cacher.freeRef("list/list_team_zhanli_0.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()

	root:removeFromParent(false)
	self.roots = {}
end

function AdventureHeroListCell:createCell()
	local cell = AdventureHeroListCell:new()
    cell:unregisterOnNoteUpdate(cell)
	-- cell:registerOnNodeEvent(cell)
 --    if missionIsOver() == true then
 --        cell:registerOnNoteUpdate(cell)
 --    end
	return cell
end

