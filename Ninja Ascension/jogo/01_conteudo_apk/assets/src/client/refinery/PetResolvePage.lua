-- ----------------------------------------------------------------------------------------------------
-- 说明：宠物分解界面
-- 创建时间
-- 作者：李潮：
-------------------------------------------------------------------------------------------------------
PetResolvePage = class("PetResolvePageClass", Window)

function PetResolvePage:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.hero_instance = nil
	
	self.Panel_yingxiong = nil
	self.ArmatureNode_yingxiong = nil
	
    -- Initialize PetResolvePage page state machine.
    local function init_pet_resolve_terminal()
		-- 分解界面初始化，包含清除当前宠物处理
        local pet_resolve_init_terminal = {
            _name = "pet_resolve_init",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:displayTypeChange("no_pet")
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 选中宠物时调用，显示宠物图标，宠物信息
		local pet_resolve_show_pet_info_terminal = {
            _name = "pet_resolve_show_pet_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:displayTypeChange("show_pet")
				
				local root = instance.roots[1]
				local hero_pad = ccui.Helper:seekWidgetByName(root, "Panel_20"):getChildByName("Panel_10"):getChildByName("ProjectNode_1"):getChildByName("root")
				
				local heroInstance = params._datas.cell.heroInstance
				instance.hero_instance = heroInstance
				-- 绘制全身像
				local hero_data = dms.element(dms["ship_mould"], heroInstance.ship_template_id)
				local all_icon = dms.atoi(hero_data, ship_mould.All_icon)
				
				ccui.Helper:seekWidgetByName(hero_pad, "Panel_31"):setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", all_icon))
				
				-- 绘制名称
				local hero_color = dms.atoi(hero_data, ship_mould.ship_type)
				local name_text = ccui.Helper:seekWidgetByName(hero_pad, "Text_65")
				name_text:setString(heroInstance.captain_name)
				name_text:setColor(cc.c3b(color_Type[hero_color+1][1],color_Type[hero_color+1][2],color_Type[hero_color+1][3]))
				local xiaohao = dms.int(dms["pirates_config"], 324, pirates_config.param)
				ccui.Helper:seekWidgetByName(root, "Text_money"):setString(""..xiaohao)
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 宠物分解请求
		local pet_resolve_request_reborn_terminal = {
            _name = "pet_resolve_request_reborn",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- 请求打开分解预览
				local function responseGetPreviewCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					
						local previewWnd = ResolveReturnPreview:new()
						previewWnd:init(9, {response.node.hero_instance})
						fwin:open(previewWnd)
					end
				end
				if instance.hero_instance == nil then 
					TipDlg.drawTextDailog(_pet_tipString_info[20])
					return
				end
				protocol_command.recycle_init.param_list = "".."9".."\r\n"..instance.hero_instance.ship_id
				NetworkManager:register(protocol_command.recycle_init.code, nil, nil, nil, instance, responseGetPreviewCallback, false, nil)
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 选择分解宠物
		local pet_resolve_choose_hero_terminal = {
            _name = "pet_resolve_choose_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local status = false
				local lenghtPet = instance:sortHerosForReborn()
				if #lenghtPet > 0 then 
					status = true
				end
				if status == true then
					app.load("client.refinery.PetChooseForResolve")
					fwin:open(PetChooseForResolve:new(), fwin._view)
				else
					TipDlg.drawTextDailog(_pet_tipString_info[14])
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--分解完毕的刷新
		local pet_resolve_over_update_terminal = {
            _name = "pet_resolve_over_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				pushEffect(formatMusicFile("effect", 9993))
				
				state_machine.excute("pet_resolve_init", 0, "pet_resolve_init.")
				state_machine.excute("shop_window_update", 0, "shop_window_update.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--宠物商店
		local pet_resolve_pet_shop_terminal = {
            _name = "pet_resolve_pet_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
             	local openLevel = dms.int(dms["fun_open_condition"], 55, fun_open_condition.level)
             	local userlevel = tonumber(_ED.user_info.user_grade)
             	if userlevel >= openLevel then 
             		app.load("client.packs.pet.PetShop")				
					local cell = PetShop:new()
					cell:init(1)
					fwin:open(cell, fwin._view)  
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 55, fun_open_condition.tip_info))
             	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(pet_resolve_init_terminal)
        state_machine.add(pet_resolve_show_pet_info_terminal)
        state_machine.add(pet_resolve_request_reborn_terminal)
        state_machine.add(pet_resolve_choose_hero_terminal)
        state_machine.add(pet_resolve_pet_shop_terminal)
        state_machine.add(pet_resolve_over_update_terminal)
        state_machine.init()
    end
    
    init_pet_resolve_terminal()
end

function PetResolvePage:sortHerosForReborn()
	
	local function chooseHero()
		local list = {}
		local j = 1
		for i, v in pairs(_ED.user_ship) do
			local shipId = v.ship_id
			local shipData = dms.element(dms["ship_mould"], v.ship_template_id)
			local shipQuality = dms.atoi(shipData, ship_mould.ship_type)
			local shipRankLevel = dms.atoi(shipData, ship_mould.initial_rank_level) 
			local captain_type = dms.atoi(shipData, ship_mould.captain_type)
			if captain_type == 3 then 
			--上阵宠物不能分解
				if zstring.tonumber(shipId) ~= _ED.formation_pet_id 
					and zstring.tonumber(v.pet_equip_ship_id) == 0
					then
					list[j] = v
					j = j+1
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

function PetResolvePage:displayTypeChange(_type)
	local root = self.roots[1]
	local hero_pad =  ccui.Helper:seekWidgetByName(root, "Panel_20"):getChildByName("Panel_10"):getChildByName("ProjectNode_1"):getChildByName("root")

	if _type == "show_pet" then
		
		-- 显示名称
		ccui.Helper:seekWidgetByName(hero_pad, "Image_26"):setVisible(true)
		
		-- 隐藏“+”
		ccui.Helper:seekWidgetByName(hero_pad, "Image_33"):setVisible(false)
		ccui.Helper:seekWidgetByName(hero_pad, "Panel_2"):getChildByName("ArmatureNode_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_jianghun_0"):setString("".._ED.user_info.pet_soul)
		
		
	elseif _type == "no_pet" then
		self.hero_instance = nil
		ccui.Helper:seekWidgetByName(hero_pad, "Panel_31"):removeBackGroundImage()
		
		-- 隐藏名称
		ccui.Helper:seekWidgetByName(hero_pad, "Image_26"):setVisible(false)
		
		-- 显示“+”
		ccui.Helper:seekWidgetByName(hero_pad, "Image_33"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_money"):setString("0")
		ccui.Helper:seekWidgetByName(hero_pad, "Panel_2"):getChildByName("ArmatureNode_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_jianghun_0"):setString("".._ED.user_info.pet_soul)
	end
end

function PetResolvePage:onEnterTransitionFinish()
	local csbpet_resolve = csb.createNode("refinery/refinery_PetStorage_fj.csb")
	self:addChild(csbpet_resolve)
	local root = csbpet_resolve:getChildByName("root")
	table.insert(self.roots, root)
    local hero_pad = ccui.Helper:seekWidgetByName(root, "Panel_20"):getChildByName("Panel_10"):getChildByName("ProjectNode_1"):getChildByName("root")
	
	state_machine.excute("pet_resolve_init", 0, "pet_resolve_init.")
	
	--选择
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(hero_pad, "Panel_31"), nil, 
	{
		terminal_name = "pet_resolve_choose_hero"
	},
	nil, 0)
	
	--分解
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_21"), nil, 
	{
		terminal_name = "pet_resolve_request_reborn", 
		isPressedActionEnabled = true
	},
	nil, 0)

	--战宠商店
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_16"), nil, 
	{
		terminal_name = "pet_resolve_pet_shop",
		isPressedActionEnabled = true
	},
	nil, 0)

end

function PetResolvePage:onExit()
	state_machine.remove("pet_resolve_init")
	state_machine.remove("pet_resolve_show_pet_info")
	state_machine.remove("pet_resolve_request_reborn")
	state_machine.remove("pet_resolve_choose_hero")
	state_machine.remove("pet_resolve_over_update")
	state_machine.remove("pet_resolve_pet_shop")
end








