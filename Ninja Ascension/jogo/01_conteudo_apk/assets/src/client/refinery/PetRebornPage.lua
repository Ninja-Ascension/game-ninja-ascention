-- ----------------------------------------------------------------------------------------------------
-- 说明：宠物重生界面
-- 创建时间
-- 作者：李潮：
-------------------------------------------------------------------------------------------------------
PetRebornPage = class("PetRebornPageClass", Window)

function PetRebornPage:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.hero_instance = nil
	
	self.Panel_yingxiong = nil
	self.ArmatureNode_yingxiong = nil
	
    -- Initialize PetRebornPage page state machine.
    local function init_pet_reborn_terminal()
		-- 重生界面初始化，包含清除当前宠物处理
        local pet_reborn_init_terminal = {
            _name = "pet_reborn_init",
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
		local pet_reborn_show_pet_info_terminal = {
            _name = "pet_reborn_show_pet_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:displayTypeChange("show_pet")
				
				local root = instance.roots[1]
				local hero_pad = ccui.Helper:seekWidgetByName(root, "Panel_8"):getChildByName("ProjectNode_1"):getChildByName("root")
				
				local heroInstance = params._datas.cell.heroInstance
				instance.hero_instance = heroInstance
				-- 绘制全身像
				local hero_data = dms.element(dms["ship_mould"], heroInstance.ship_template_id)
				local all_icon = dms.atoi(hero_data, ship_mould.All_icon)
				
				ccui.Helper:seekWidgetByName(hero_pad, "Panel_21"):setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", all_icon))
				
				-- 绘制名称、突破等级
				local hero_color = dms.atoi(hero_data, ship_mould.ship_type)
				local name_text = ccui.Helper:seekWidgetByName(hero_pad, "Text_33")
				local level_text = ccui.Helper:seekWidgetByName(root, "Text_qh_0")
				level_text:setString("".. heroInstance.ship_grade)
				ccui.Helper:seekWidgetByName(root, "Text_jl_0"):setString(""..heroInstance.train_level .._string_piece_info[46])
				
				name_text:setString(heroInstance.captain_name)
				name_text:setColor(cc.c3b(color_Type[hero_color+1][1],color_Type[hero_color+1][2],color_Type[hero_color+1][3]))

				local jinjieLevel = dms.atoi(hero_data,ship_mould.initial_rank_level)
			    for i=1,5 do
			        local starImage = ccui.Helper:seekWidgetByName(root, "Image_x_"..i)
			        starImage:setVisible(false)
			        if i <= jinjieLevel then 
			            starImage:setVisible(true)
			        end
			    end
			    local xiaohao = dms.int(dms["pirates_config"], 324, pirates_config.param)
			    ccui.Helper:seekWidgetByName(root, "Text_money_1"):setString(""..xiaohao)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 宠物重生请求
		local pet_reborn_request_reborn_terminal = {
            _name = "pet_reborn_request_reborn",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- 请求打开重生预览
				local function responseGetPreviewCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						
						local previewWnd = ResolveReturnPreview:new()
						previewWnd:init(8, {response.node.hero_instance})
						fwin:open(previewWnd)
					end
				end
				protocol_command.recycle_init.param_list = "".."8".."\r\n"..instance.hero_instance.ship_id
				NetworkManager:register(protocol_command.recycle_init.code, nil, nil, nil, instance, responseGetPreviewCallback, false, nil)
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 选择重生宠物
		local pet_reborn_choose_hero_terminal = {
            _name = "pet_reborn_choose_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local status = false
				for i,v in ipairs(self:sortHerosForReborn()) do
					status = true
				end
				if status == true then
					app.load("client.refinery.PetChooseForReborn")
					fwin:open(PetChooseForReborn:new(), fwin._view)
				else
					TipDlg.drawTextDailog(_pet_tipString_info[18])
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--重生完毕的刷新
		local pet_reborn_over_update_terminal = {
            _name = "pet_reborn_over_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				pushEffect(formatMusicFile("effect", 9993))
				
				state_machine.excute("pet_reborn_init", 0, "pet_reborn_init.")
				state_machine.excute("shop_window_update", 0, "shop_window_update.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(pet_reborn_init_terminal)
        state_machine.add(pet_reborn_show_pet_info_terminal)
        state_machine.add(pet_reborn_request_reborn_terminal)
        state_machine.add(pet_reborn_choose_hero_terminal)
        state_machine.add(pet_reborn_over_update_terminal)
        state_machine.init()
    end
    
    init_pet_reborn_terminal()
end

function PetRebornPage:sortHerosForReborn()
	local function chooseHero()
		local list = {}
		local j = 1
		for i, v in pairs(_ED.user_ship) do
			local shipId = zstring.tonumber(v.ship_id)
			local shipData = dms.element(dms["ship_mould"], v.ship_template_id)
			local shipQuality = dms.atoi(shipData, ship_mould.ship_type)
			local shipRankLevel = dms.atoi(shipData, ship_mould.initial_rank_level) 
			local captain_type = dms.atoi(shipData, ship_mould.captain_type) 
			
			if captain_type == 3 then 
			--宠物
				if shipId ~= _ED.formation_pet_id 
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
		if a_quality < b_quality then
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

function PetRebornPage:displayTypeChange(_type)
	local root = self.roots[1]
	local hero_pad =  ccui.Helper:seekWidgetByName(root, "Panel_8"):getChildByName("ProjectNode_1"):getChildByName("root")
	

	if _type == "show_pet" then
		-- 显示属性面板
		ccui.Helper:seekWidgetByName(root, "Panel_29"):setVisible(true)
		-- 显示名称
		ccui.Helper:seekWidgetByName(hero_pad, "Image_20"):setVisible(true)
		-- 隐藏初始面板
		ccui.Helper:seekWidgetByName(root, "Panel_27"):setVisible(false)
		-- 隐藏“+”
		ccui.Helper:seekWidgetByName(hero_pad, "Image_21"):setVisible(false)
	elseif _type == "no_pet" then
		
		-- 清除属性面板
		ccui.Helper:seekWidgetByName(root, "Panel_29"):setVisible(false)
		-- 清除武将
		ccui.Helper:seekWidgetByName(hero_pad, "Panel_21"):removeBackGroundImage()
		-- 隐藏名称
		ccui.Helper:seekWidgetByName(hero_pad, "Image_20"):setVisible(false)
		-- 显示初始面板
		ccui.Helper:seekWidgetByName(root, "Panel_27"):setVisible(true)
		-- 显示“+”
		ccui.Helper:seekWidgetByName(hero_pad, "Image_21"):setVisible(true)
	end
end

function PetRebornPage:onEnterTransitionFinish()
	local csbpet_reborn = csb.createNode("packs/PetStorage/PetStorage_chongsheng.csb")
	self:addChild(csbpet_reborn)
	local root = csbpet_reborn:getChildByName("root")
	table.insert(self.roots, root)
    local hero_pad = ccui.Helper:seekWidgetByName(root, "Panel_8"):getChildByName("ProjectNode_1"):getChildByName("root")
	
	state_machine.excute("pet_reborn_init", 0, "pet_reborn_init.")

	--选择
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(hero_pad, "Panel_21"), nil, 
	{
		terminal_name = "pet_reborn_choose_hero"
	},
	nil, 0)
	
	--重生
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_21_1"), nil, 
	{
		terminal_name = "pet_reborn_request_reborn", 
		isPressedActionEnabled = true
	},
	nil, 0)
end

function PetRebornPage:onExit()
	state_machine.remove("pet_reborn_init")
	state_machine.remove("pet_reborn_show_pet_info")
	state_machine.remove("pet_reborn_request_reborn")
	state_machine.remove("pet_reborn_choose_hero")
	state_machine.remove("pet_reborn_over_update")
end
