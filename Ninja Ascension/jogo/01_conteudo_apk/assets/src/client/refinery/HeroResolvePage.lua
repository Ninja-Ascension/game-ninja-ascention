-- ----------------------------------------------------------------------------------------------------
-- 说明：武将分解界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
HeroResolvePage = class("HeroResolvePageClass", Window)

function HeroResolvePage:ctor()
    self.super:ctor()
    
	self.roots = {}
	self.action = nil
	self.needShipInfo = {}
	self.panel_Hero = {}	--武将的五个层
	self.panel_Add	= {}	--加号的五个层
	
	self.isDropping = false
	
	self.Panel_898 = nil
	self.ArmatureNode_wujiangfenjie = nil
    -- Initialize HeroResolvePage page state machine.
    local function init_hero_resolve_terminal()
        --自动添加
		local hero_resolve_open_ex_terminal = {
            _name = "hero_resolve_open_ex",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.isDropping == false then
					state_machine.excute("hero_resolve_clean", 0, "hero_resolve_clean.")
					self.needShipInfo = {}
					for i, v in ipairs(instance:getSortedHeroes()) do
						table.insert(self.needShipInfo, v)
						if #self.needShipInfo == 5 then
							break
						end	
					end
					
					if #self.needShipInfo <= 0 then
						TipDlg.drawTextDailog(_string_piece_info[87])
						return
					end
					
					instance:onUpdateDraw()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--清除操作
		local hero_resolve_clean_terminal = {
            _name = "hero_resolve_clean",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.needShipInfo = {}
				--> print("jinru","qingchu")
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--分解
		local hero_resolve_do_terminal = {
            _name = "hero_resolve_do",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				state_machine.lock("hero_resolve_do")
				if cell.isDropping == false then
					local function responseGetPreviewCallback(response)	
						local win = fwin:find("HeroResolvePageClass")
						if nil == win then
							state_machine.unlock("hero_resolve_do")
							return
						end
						
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							local previewWnd = ResolveReturnPreview:new()
							previewWnd:init(1, cell.needShipInfo)
							fwin:open(previewWnd, fwin._windows)
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
							else
								state_machine.unlock("hero_resolve_do")
							end
						else
							state_machine.unlock("hero_resolve_do")							
						end
					end
					
					local str = ""
					for i, v in pairs(cell.needShipInfo) do
						if v ~= nil then
							str = str .. v.ship_id .. ","
						end	
					end
					if str == nil or str == "" then 
						TipDlg.drawTextDailog(_string_piece_info[88].._string_piece_info[33])
						state_machine.unlock("hero_resolve_do")
						return
					end
					
					protocol_command.recycle_init.param_list = "".."0".."\r\n"..str
					NetworkManager:register(protocol_command.recycle_init.code, nil, nil, nil, nil, responseGetPreviewCallback, false, nil)
				else
					state_machine.unlock("hero_resolve_do")
                end
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--接收选择列表传来的数据
		local hero_resolve_update_info_terminal = {
            _name = "hero_resolve_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.needShipInfo = params._datas.needShipInfo
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--进入选择英雄列表
		local hero_resolve_enter_choose_hero_terminal = {
            _name = "hero_resolve_enter_choose_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.isDropping == false then
					local choose_hero_list = HeroChooseForResolve:new()
					choose_hero_list:init(instance.needShipInfo)
					fwin:open(choose_hero_list, fwin._view)
				end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--取消一个升级材料的选择
		local hero_resolve_cancel_one_terminal = {
            _name = "hero_resolve_cancel_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.isDropping == false then
					-- local _ship_id = params._datas._ship_id
					-- local pos = nil
					-- for i, v in pairs(instance.needShipInfo) do
						-- if v.ship_id == _ship_id then
							-- pos = i 
							-- break
						-- end
					-- end
					-- local heroPanel = instance.panel_Hero[pos]
					-- local addPanel = instance.panel_Add[pos]
					-- addPanel:setVisible(true)
					-- heroPanel:removeAllChildren(true)
					-- instance.needShipInfo[pos] = nil
					local _ship_id = params._datas._ship_id
					local pos = nil
					local ShipInfotable = {}
					for i, v in pairs(instance.needShipInfo) do
						if v.ship_id ~= _ship_id then
							table.insert(ShipInfotable, v)
						end
					end
					
					instance.needShipInfo = {}
					for i, v in pairs(ShipInfotable) do
						table.insert(instance.needShipInfo, v)
						if #instance.needShipInfo == 5 then
							break
						end	
					end			
					instance:onUpdateDraw()
					
				end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--分解前，去除所有武将头上的叉叉
		local hero_resolve_remove_hero_x_terminal = {
            _name = "hero_resolve_remove_hero_x",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				for i, v in pairs(instance.needShipInfo) do
					local heroPanel = instance.panel_Hero[i]
					ccui.Helper:seekWidgetByName(heroPanel, "Button_1"):setVisible(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--分解完毕的刷新
		local hero_resolve_over_update_terminal = {
            _name = "hero_resolve_over_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- instance.action = csb.createTimeline("refinery/refinery_generals.csb")
				-- instance.roots[1]:runAction(instance.action)
				
				playEffect(formatMusicFile("effect", 9990))
				
				instance.action:play("fenjie", false)
				instance.action:setFrameEventCallFunc(function (frame)
					if nil == frame then
						return
					end

					local str = frame:getEvent()
					if str == "over" then
						-- 更新用户银币信息
						state_machine.excute("shop_window_update", 0, "shop_window_update.")
						
						-- 更新将魂
						ccui.Helper:seekWidgetByName(instance.roots[1], "Text_jianghun_0"):setString(_ED.user_info.jade) 
						-- 移除材料
						state_machine.excute("hero_resolve_clean", 0, "hero_resolve_clean.")
					end
				end)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--神将商店跳转
		local hero_resolve_goto_hero_shop_terminal = {
            _name = "hero_resolve_goto_hero_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					local function recruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							app.load("client.shop.hero.HeroShop")
							local cell = HeroShop:new()
							cell:init(1)
							fwin:open(cell, fwin._view) 				
						end
					end
					NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
				else
					app.load("client.shop.hero.HeroShop")
					local cell = HeroShop:new()
					cell:init(1)
					fwin:open(cell, fwin._view) 
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--帮助
		local hero_resolve_open_helpdlg_terminal = {
            _name = "hero_resolve_open_helpdlg",
            _init = function (terminal) 
                app.load("client.refinery.TreasureInfo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = TreasureInfo:new()
				cell:init(1)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_resolve_update_jade_terminal = {
            _name = "hero_resolve_update_jade",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	self:updateJade()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --分解动画播放
        local hero_resolve_amiation_play_terminal = {
            _name = "hero_resolve_amiation_play",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil then
            		instance:playHeroAnimation()
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(hero_resolve_open_ex_terminal)
        state_machine.add(hero_resolve_clean_terminal)
        state_machine.add(hero_resolve_do_terminal)
        state_machine.add(hero_resolve_update_info_terminal)
        state_machine.add(hero_resolve_enter_choose_hero_terminal)
        state_machine.add(hero_resolve_goto_hero_shop_terminal)
        state_machine.add(hero_resolve_open_helpdlg_terminal)
        state_machine.add(hero_resolve_cancel_one_terminal)
        state_machine.add(hero_resolve_over_update_terminal)
        state_machine.add(hero_resolve_remove_hero_x_terminal)
        state_machine.add(hero_resolve_update_jade_terminal)
        state_machine.add(hero_resolve_amiation_play_terminal)
        state_machine.init()
    end
    
    init_hero_resolve_terminal()
end
function HeroResolvePage:playHeroAnimation()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local function changeActionCallback(armatureBack)
			armatureBack:getParent():setVisible(false)
		end
		local view_pad = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_18")
		local heroes_pad = view_pad:getChildByName("ProjectNode_1"):getChildByName("root")
		local activePan = ccui.Helper:seekWidgetByName(heroes_pad, "Panel_898")
		activePan:setVisible(true)
		if self.ArmatureNode_wujiangfenjie == nil then
			self.ArmatureNode_wujiangfenjie = ccs.Armature:create("effect_yxfj")
			draw.initArmature(self.ArmatureNode_wujiangfenjie, nil, -1, 0, 1)
			activePan:addChild(self.ArmatureNode_wujiangfenjie)
			self.ArmatureNode_wujiangfenjie:getAnimation():playWithIndex(0, 0, 0)
			self.ArmatureNode_wujiangfenjie._invoke = changeActionCallback
		else
			csb.animationChangeToAction(self.ArmatureNode_wujiangfenjie, 0, 0, nil)
		end
	else
		self.ArmatureNode_wujiangfenjie:getParent():setVisible(true)
		csb.animationChangeToAction(self.ArmatureNode_wujiangfenjie, 0, 0, nil)
	end
end

function HeroResolvePage:getSortedHeroes()
	local function chooseHero()
		local list = {}
		local j = 1
		for i, v in pairs(_ED.user_ship) do
			local shipId = v.ship_id
			local shipData = dms.element(dms["ship_mould"], v.ship_template_id)
			local shipQuality = dms.atoi(shipData, ship_mould.ship_type)
			local shipRankLevel = dms.atoi(shipData, ship_mould.initial_rank_level) 
			if tonumber(v.ship_base_template_id) < 1148 or tonumber(v.ship_base_template_id) > 1150 then
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					local _captain_type = tonumber( dms.atoi(shipData, ship_mould.captain_type))
					--print("-----------",_captain_type)
					if _captain_type == 2 then
					else
						if shipQuality >= 1 and shipQuality < 4 and (zstring.tonumber(v.formation_index) == 0)
						  and (zstring.tonumber(v.little_partner_formation_index) == 0) and v.inResourceFromation ~= true then
							list[j] = v
							j = j+1
						end
					end	
				else
					local _captain_type = tonumber( dms.atoi(shipData, ship_mould.captain_type))
					if _captain_type == 2 or _captain_type == 3 then
					else

						if shipQuality >= 1 and shipQuality < 4 and (zstring.tonumber(v.formation_index) == 0)
						  and (zstring.tonumber(v.little_partner_formation_index) == 0) then
							list[j] = v
							j = j+1
						end
					end
				end
			end
		end
		return list
	end
	
	local function compare(a, b)
		local a_quality = dms.int(dms["ship_mould"], a.ship_template_id, ship_mould.ship_type)
		local b_quality = dms.int(dms["ship_mould"], b.ship_template_id, ship_mould.ship_type)
		if a_quality > b_quality then
			return false
		elseif a_quality == b_quality then
			if tonumber(a.ship_grade) > tonumber(b.ship_grade) then
				return false
			end
		end
		return true
	end
	
	local function sortList(list)
		local count = #list
		
		for i=1, count do
			for j=1, count-i do
				if compare(list[j], list[j+1]) == false then
					list[j], list[j+1] = list[j+1], list[j]
				end
			end
		end
		return list
	end
	
	return sortList(chooseHero())
end

function HeroResolvePage:onUpdateDraw()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self:onUpdateTigerDraw()
		return
	end
	local view_pad = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_18")
	local heroes_pad = view_pad:getChildByName("ProjectNode_1"):getChildByName("root")
	for i = 1,5 do
		local heroPanel = self.panel_Hero[i]
		local addPanel = self.panel_Add[i]
		if self.needShipInfo[i] ~= nil then
			-- addPanel:setVisible(false)
			heroPanel:removeAllChildren(true)
			local shipCell = HeroRefineryIcon:createCell()
			shipCell:init(1, self.needShipInfo[i].ship_template_id, self.needShipInfo[i].ship_id)
			heroPanel:addChild(shipCell)
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_legendary_game 
				then			--龙虎门项目控制
				ccui.Helper:seekWidgetByName(heroes_pad, string.format("Panel_jiahao_%d", i)):setVisible(false)
			end
		else
			addPanel:setVisible(true)
			heroPanel:removeAllChildren(true)
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_legendary_game 
				then			--龙虎门项目控制
				ccui.Helper:seekWidgetByName(heroes_pad, string.format("Panel_jiahao_%d", i)):setVisible(true)
			end
		end
	end
end

function HeroResolvePage:onUpdateTigerDraw()
	local view_pad = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_18")
	local heroes_pad = view_pad:getChildByName("ProjectNode_1"):getChildByName("root")
	for i = 1,5 do
		local heroPanel = self.panel_Hero[i]
		heroPanel:removeAllChildren(true)
		local addPanel = self.panel_Add[i]
		local add_btn_panel = ccui.Helper:seekWidgetByName(heroes_pad, string.format("Panel_jiahao_%d", i))
		add_btn_panel:removeAllChildren(true)
		local armature = ccs.Armature:create("effect_16")
    	draw.initArmature(armature, nil, -1, 0, 1)
    	add_btn_panel:addChild(armature)
		if self.needShipInfo[i] ~= nil then
			local shipCell = HeroRefineryIcon:createCell()
			shipCell:init(1, self.needShipInfo[i].ship_template_id, self.needShipInfo[i].ship_id)
			heroPanel:addChild(shipCell)
			add_btn_panel:setVisible(false)
		else
			addPanel:setVisible(true)
			add_btn_panel:setVisible(true)
		end
	end
end

function HeroResolvePage:updateJade()
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_jianghun_0"):setString(_ED.user_info.jade) 
end
function HeroResolvePage:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self:onLoad()
	end

	local csbhero_resolve = csb.createNode("refinery/refinery_gen_fj.csb")
	self:addChild(csbhero_resolve)
	local root = csbhero_resolve:getChildByName("root")
	table.insert(self.roots, root)

	self.action = csb.createTimeline("refinery/refinery_generals.csb")
	self.action:play("window_open", false)
    csbhero_resolve:runAction(self.action)
	
	local view_pad = ccui.Helper:seekWidgetByName(root, "Panel_18")
	local heroes_pad = view_pad:getChildByName("ProjectNode_1"):getChildByName("root")
	local activePan = ccui.Helper:seekWidgetByName(heroes_pad, "Panel_4")
	local activePan2 = ccui.Helper:seekWidgetByName(activePan, "Panel_16")
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		local activePan3 = ccui.Helper:seekWidgetByName(activePan2, "Panel_274")
		local csbhero_resolve2 = activePan3:getChildByName("ProjectNode_1"):getChildByName("root")
		local action2 = csb.createTimeline("refinery/refinery_generals_window.csb")
		action2:play("window_open", false)
		csbhero_resolve2:runAction(action2)
	end
	
	table.insert(self.roots, heroes_pad)
	
	for i = 1, 5 do
		local hero_panel = ccui.Helper:seekWidgetByName(heroes_pad, string.format("Panel_wj_%d", i))
		table.insert(self.panel_Hero, hero_panel)
	end
	
	self.panel_Add	= {
		ccui.Helper:seekWidgetByName(heroes_pad, "Panel_18_2"),
		ccui.Helper:seekWidgetByName(heroes_pad, "Panel_18_3"),
		ccui.Helper:seekWidgetByName(heroes_pad, "Panel_18"),
		ccui.Helper:seekWidgetByName(heroes_pad, "Panel_18_0"),
		ccui.Helper:seekWidgetByName(heroes_pad, "Panel_18_1")
	}
	
	--显示将魂
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_jianghun_0"):setString(_ED.user_info.jade) 
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local function delayEndFuncN( _sender )
            if _sender ~= nil then
                _sender:onUpdateTigerDraw()
            end
        end
        local actions = {}
        table.insert(actions, cc.DelayTime:create(0.5))
        table.insert(actions, cc.CallFunc:create(delayEndFuncN))
        local seq = cc.Sequence:create(actions)
        self:runAction(seq)
	else
		self:onUpdateDraw()
	end
	
	for i, v in ipairs(self.panel_Hero) do
		fwin:addTouchEventListener(v, nil, 
		{
			terminal_name = "hero_resolve_enter_choose_hero", 
			_ships = self.needShipInfo, 
		}, 
		nil, 0)
	end
	
	--自动添加
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_17"), nil, 
	{
		terminal_name = "hero_resolve_open_ex", 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	--分解
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_18"), nil, 
	{
		terminal_name = "hero_resolve_do", 
		isPressedActionEnabled = true,
		cell = self
	},
	nil, 0)
	
	--神将商店
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_16"), nil, 
	{
		terminal_name = "hero_resolve_goto_hero_shop", 
		isPressedActionEnabled = true
	},
	nil, 0)
	
	--帮助
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_19"), nil, 
	{
		terminal_name = "hero_resolve_open_helpdlg", 
		isPressedActionEnabled = true
	},
	nil, 0)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		-- 动画
		-- local function changeActionCallback(armatureBack)
		-- 	armatureBack:getParent():setVisible(false)
		-- end
		
		-- self.Panel_898=ccui.Helper:seekWidgetByName(activePan2, "Panel_898")
		-- self.ArmatureNode_wujiangfenjie = self.Panel_898:getChildByName("ArmatureNode_wujiangfenjie")

		-- draw.initArmature(self.ArmatureNode_wujiangfenjie, nil, -1, 0, 1)
		-- self.ArmatureNode_wujiangfenjie:getAnimation():playWithIndex(0, 0, 0)
		-- self.ArmatureNode_wujiangfenjie._invoke = changeActionCallback	
	end
end

function HeroResolvePage:onExit()
	-- local effect_paths = "images/ui/effice/effect_16/effect_16.ExportJson"
 --    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
    local effect_paths = "images/ui/effice/effect_yxfj/effect_yxfj.ExportJson"
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
	state_machine.remove("hero_resolve_open_ex")
	state_machine.remove("hero_resolve_clean")
	state_machine.remove("hero_resolve_do")
	state_machine.remove("hero_resolve_update_info")
	state_machine.remove("hero_resolve_enter_choose_hero")
	state_machine.remove("hero_resolve_goto_hero_shop")
	state_machine.remove("hero_resolve_open_helpdlg")
	state_machine.remove("hero_resolve_cancel_one")
	state_machine.remove("hero_resolve_over_update")
	state_machine.remove("hero_resolve_remove_hero_x")
	state_machine.remove("hero_resolve_update_jade")
	state_machine.remove("hero_resolve_amiation_play")
end

function HeroResolvePage:onLoad()
    -- local effect_paths = "images/ui/effice/effect_16/effect_16.ExportJson"
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    effect_paths = "images/ui/effice/effect_yxfj/effect_yxfj.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
end
