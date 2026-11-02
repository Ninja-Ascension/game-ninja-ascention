-- ----------------------------------------------------------------------------------------------------
-- 说明：魔陷卡分解界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MagicCardResolvePage = class("MagicCardResolvePageClass", Window)

function MagicCardResolvePage:ctor()
    self.super:ctor()
    
	self.roots = {}
	self.action = nil
	self.needShipInfo = {}
	self.panel_Hero = {}	--武将的五个层
	self.panel_Add	= {}	--加号的五个层
	
	self.isDropping = false
	
	self.Panel_898 = nil
	self.ArmatureNode_wujiangfenjie = nil
	app.load("client.cells.magicCard.magic_trup_card_icon_cell")
	app.load("client.refinery.MagicCardRefineryIcon")
    -- Initialize MagicCardResolvePage page state machine.
    local function init_magic_card_resolve_terminal()
        --自动添加
		local magic_card_resolve_open_ex_terminal = {
            _name = "magic_card_resolve_open_ex",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.isDropping == false then
					state_machine.excute("magic_card_resolve_clean", 0, "magic_card_resolve_clean.")
					self.needShipInfo = {}
					for i, v in ipairs(instance:getSortedHeroes()) do
						table.insert(self.needShipInfo, v)
						if #self.needShipInfo >= 5 then 
							break
						end
					end
					
					if #self.needShipInfo <= 0 then
						TipDlg.drawTextDailog(_magic_card_tip[13])
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
		local magic_card_resolve_clean_terminal = {
            _name = "magic_card_resolve_clean",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.needShipInfo = {}
	
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--分解
		local magic_card_resolve_do_terminal = {
            _name = "magic_card_resolve_do",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				state_machine.lock("magic_card_resolve_do")
				if cell.isDropping == false then
					local function responseGetPreviewCallback(response)	
						local win = fwin:find("MagicCardResolvePageClass")
						if nil == win then
							state_machine.unlock("magic_card_resolve_do")
							return
						end
						
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							local previewWnd = ResolveReturnPreview:new()
							previewWnd:init(5, cell.needShipInfo)
							fwin:open(previewWnd, fwin._windows)
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
							else
								state_machine.unlock("magic_card_resolve_do")
							end
						else
							state_machine.unlock("magic_card_resolve_do")							
						end
					end
					
					local str = ""
					for i, v in pairs(cell.needShipInfo) do
						if v ~= nil then
							str = str .. v.id .. ","
						end	
					end
					if str == nil or str == "" then 
						TipDlg.drawTextDailog(_string_piece_info[88].._magic_card_tip[3])
						state_machine.unlock("magic_card_resolve_do")
						return
					end
					
					protocol_command.recycle_init.param_list = "".."5".."\r\n"..str
					NetworkManager:register(protocol_command.recycle_init.code, nil, nil, nil, nil, responseGetPreviewCallback, false, nil)
				else
					state_machine.unlock("magic_card_resolve_do")
                end
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--接收选择列表传来的数据
		local magic_card_resolve_update_info_terminal = {
            _name = "magic_card_resolve_update_info",
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
		
		--进入选择魔陷卡列表
		local magic_card_resolve_enter_choose_hero_terminal = {
            _name = "magic_card_resolve_enter_choose_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.isDropping == false then
					app.load("client.refinery.MagicCardChooseForResolve")
					local choose_magic_list = MagicCardChooseForResolve:new()
					choose_magic_list:init(instance.needShipInfo)
					fwin:open(choose_magic_list, fwin._view)
				end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--取消一个升级材料的选择
		local magic_card_resolve_cancel_one_terminal = {
            _name = "magic_card_resolve_cancel_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.isDropping == false then
					local _ship_id = params._datas.cardId
					local pos = nil
					local ShipInfotable = {}
					for i, v in pairs(instance.needShipInfo) do
						if zstring.tonumber(v.id) ~= zstring.tonumber(_ship_id) then
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
		local magic_card_resolve_remove_hero_x_terminal = {
            _name = "magic_card_resolve_remove_hero_x",
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
		local magic_card_resolve_over_update_terminal = {
            _name = "magic_card_resolve_over_update",
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
						state_machine.excute("magic_card_resolve_clean", 0, "magic_card_resolve_clean.")
					end
				end)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--神将商店跳转
		local magic_card_resolve_goto_hero_shop_terminal = {
            _name = "magic_card_resolve_goto_hero_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
          
				app.load("client.shop.hero.HeroShop")
				local cell = HeroShop:new()
				cell:init(1)
				fwin:open(cell, fwin._view) 
			
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--帮助
		local magic_card_resolve_open_helpdlg_terminal = {
            _name = "magic_card_resolve_open_helpdlg",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.refinery.MagicCardInfo")
				local cell = MagicCardInfo:new()
				cell:init(1)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local magic_card_resolve_update_jade_terminal = {
            _name = "magic_card_resolve_update_jade",
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
        local magic_card_resolve_amiation_play_terminal = {
            _name = "magic_card_resolve_amiation_play",
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
        state_machine.add(magic_card_resolve_open_ex_terminal)
        state_machine.add(magic_card_resolve_clean_terminal)
        state_machine.add(magic_card_resolve_do_terminal)
        state_machine.add(magic_card_resolve_update_info_terminal)
        state_machine.add(magic_card_resolve_enter_choose_hero_terminal)
        state_machine.add(magic_card_resolve_goto_hero_shop_terminal)
        state_machine.add(magic_card_resolve_open_helpdlg_terminal)
        state_machine.add(magic_card_resolve_cancel_one_terminal)
        state_machine.add(magic_card_resolve_over_update_terminal)
        state_machine.add(magic_card_resolve_remove_hero_x_terminal)
        state_machine.add(magic_card_resolve_update_jade_terminal)
        state_machine.add(magic_card_resolve_amiation_play_terminal)
        state_machine.init()
    end
    
    init_magic_card_resolve_terminal()
end
function MagicCardResolvePage:playHeroAnimation()
	
	self.ArmatureNode_wujiangfenjie:getParent():setVisible(true)
	csb.animationChangeToAction(self.ArmatureNode_wujiangfenjie, 0, 0, nil)

end

function MagicCardResolvePage:getSortedHeroes()
	local function chooseHero()
		local list = {}
		local j = 1
		for i, v in pairs(_ED.user_magic_trap_info) do
			if _ED.magicCard_formation[zstring.tonumber(v.id)] == nil then 
				--没有上阵
				local startLevel = dms.int(dms["magic_trap_card_info"],v.base_mould,magic_trap_card_info.current_star)
				local cardType = dms.int(dms["magic_trap_card_info"],v.base_mould,magic_trap_card_info.card_type)
				local strongLevel = zstring.tonumber(v.strong_level)
				if startLevel == 0 and strongLevel == 0 then 
					v.card_type = cardType
					table.insert(list,v)
					
				end
			end
			
		end
		return list
	end
	
	local function compare(a, b)
		return a.card_type > b.card_type
	end
	local cardList = chooseHero()
	table.sort( cardList, compare)
	return cardList
end

function MagicCardResolvePage:onUpdateDraw()

	local view_pad = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_18")
	local heroes_pad = view_pad:getChildByName("ProjectNode_1"):getChildByName("root")
	for i = 1,5 do
		local heroPanel = self.panel_Hero[i]
		local addPanel = self.panel_Add[i]
		if self.needShipInfo[i] ~= nil then
			heroPanel:removeAllChildren(true)
			local cardCell = MagicCardRefineryIcon:createCell()
			cardCell:init(self.needShipInfo[i].base_mould,self.needShipInfo[i].id)
			heroPanel:addChild(cardCell)
		else
			addPanel:setVisible(true)
			heroPanel:removeAllChildren(true)
		end
	end
end

function MagicCardResolvePage:updateJade()
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_jianghun_0"):setString(_ED.user_info.jade) 
end
function MagicCardResolvePage:onEnterTransitionFinish()

	local csbmagic_card_resolve = csb.createNode("refinery/refinery_gen_fj.csb")
	self:addChild(csbmagic_card_resolve)
	local root = csbmagic_card_resolve:getChildByName("root")
	table.insert(self.roots, root)

	self.action = csb.createTimeline("refinery/refinery_generals.csb")
	self.action:play("window_open", false)
    csbmagic_card_resolve:runAction(self.action)
	
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
		local csbmagic_card_resolve2 = activePan3:getChildByName("ProjectNode_1"):getChildByName("root")
		local action2 = csb.createTimeline("refinery/refinery_generals_window.csb")
		action2:play("window_open", false)
		csbmagic_card_resolve2:runAction(action2)
	end
	
	ccui.Helper:seekWidgetByName(root, "Text_31"):setString(_magic_card_tip[12])
	table.insert(self.roots, heroes_pad)
	ccui.Helper:seekWidgetByName(heroes_pad, "Image_137"):setVisible(false)
	for i = 1, 5 do
		local hero_panel = ccui.Helper:seekWidgetByName(heroes_pad, string.format("Panel_wj_%d", i))
		table.insert(self.panel_Hero, hero_panel)
	end
	ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wj"):setVisible(false)
	self.panel_Add	= {
		ccui.Helper:seekWidgetByName(heroes_pad, "Panel_18_2"),
		ccui.Helper:seekWidgetByName(heroes_pad, "Panel_18_3"),
		ccui.Helper:seekWidgetByName(heroes_pad, "Panel_18"),
		ccui.Helper:seekWidgetByName(heroes_pad, "Panel_18_0"),
		ccui.Helper:seekWidgetByName(heroes_pad, "Panel_18_1")
	}
	
	--显示将魂
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_jianghun_0"):setString(_ED.user_info.jade) 
	self:onUpdateDraw()
	
	for i, v in ipairs(self.panel_Hero) do
		fwin:addTouchEventListener(v, nil, 
		{
			terminal_name = "magic_card_resolve_enter_choose_hero", 
			_ships = self.needShipInfo, 
		}, 
		nil, 0)
	end
	
	--自动添加
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_17"), nil, 
	{
		terminal_name = "magic_card_resolve_open_ex", 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	--分解
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_18"), nil, 
	{
		terminal_name = "magic_card_resolve_do", 
		isPressedActionEnabled = true,
		cell = self
	},
	nil, 0)

	
	--帮助
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_19"), nil, 
	{
		terminal_name = "magic_card_resolve_open_helpdlg", 
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

function MagicCardResolvePage:onExit()
	-- local effect_paths = "images/ui/effice/effect_16/effect_16.ExportJson"
 --    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
    local effect_paths = "images/ui/effice/effect_yxfj/effect_yxfj.ExportJson"
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
	state_machine.remove("magic_card_resolve_open_ex")
	state_machine.remove("magic_card_resolve_clean")
	state_machine.remove("magic_card_resolve_do")
	state_machine.remove("magic_card_resolve_update_info")
	state_machine.remove("magic_card_resolve_enter_choose_hero")
	state_machine.remove("magic_card_resolve_goto_hero_shop")
	state_machine.remove("magic_card_resolve_open_helpdlg")
	state_machine.remove("magic_card_resolve_cancel_one")
	state_machine.remove("magic_card_resolve_over_update")
	state_machine.remove("magic_card_resolve_remove_hero_x")
	state_machine.remove("magic_card_resolve_update_jade")
	state_machine.remove("magic_card_resolve_amiation_play")
end

function MagicCardResolvePage:onLoad()
    -- local effect_paths = "images/ui/effice/effect_16/effect_16.ExportJson"
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    effect_paths = "images/ui/effice/effect_yxfj/effect_yxfj.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
end
