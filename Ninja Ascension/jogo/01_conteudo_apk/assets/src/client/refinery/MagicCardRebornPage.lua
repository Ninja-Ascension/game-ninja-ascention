-- ----------------------------------------------------------------------------------------------------
-- 说明：魔陷重生界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MagicCardRebornPage = class("MagicCardRebornPageClass", Window)

function MagicCardRebornPage:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.magic_card_instance = nil
	
	self.Panel_yingxiong = nil
	self.ArmatureNode_yingxiong = nil
	app.load("client.refinery.MagicCardChooseForReborn")
    -- Initialize MagicCardRebornPage page state machine.
    local function init_magic_card_reborn_terminal()
		-- 重生界面初始化，包含清除当前武将处理
        local magic_card_reborn_init_terminal = {
            _name = "magic_card_reborn_init",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:displayTypeChange("no_magic_card")
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 选中武将时调用，显示武将图标，武将信息
		local magic_card_reborn_show_magic_card_info_terminal = {
            _name = "magic_card_reborn_show_magic_card_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:displayTypeChange("show_magic_card")
				
				local root = instance.roots[1]
				local magic_card_pad = ccui.Helper:seekWidgetByName(root, "Panel_20"):getChildByName("Panel_10"):getChildByName("ProjectNode_1"):getChildByName("root")
				
				local heroInstance = params._datas.cell.cardInfo
				instance.magic_card_instance = heroInstance
				-- 绘制全身像
				local magic_card_data = dms.element(dms["magic_trap_card_info"], heroInstance.base_mould)
				local all_icon = dms.atoi(magic_card_data, magic_trap_card_info.pic)
				ccui.Helper:seekWidgetByName(magic_card_pad, "Panel_31_card"):setBackGroundImage(string.format("images/ui/props/props_%d.png", all_icon))
				ccui.Helper:seekWidgetByName(magic_card_pad, "Panel_31_card_0"):setVisible(true)
				local cardType = dms.atoi(magic_card_data, magic_trap_card_info.card_type)
				local magic_card_color = 1
				if cardType == 0 then 
					magic_card_color = 2 
					ccui.Helper:seekWidgetByName(magic_card_pad, "Panel_31_card_0"):setBackGroundImage("images/ui/battle/card_magic.png")
				else
					magic_card_color = 4
					ccui.Helper:seekWidgetByName(magic_card_pad, "Panel_31_card_0"):setBackGroundImage("images/ui/battle/card_trap.png")
				end
				local name_text = ccui.Helper:seekWidgetByName(magic_card_pad, "Text_65")
				name_text:setString(dms.atos(magic_card_data,magic_trap_card_info.card_name))
				name_text:setColor(cc.c3b(color_Type[magic_card_color][1],color_Type[magic_card_color][2],color_Type[magic_card_color][3]))

				local money = dms.int(dms["pirates_config"], 315, pirates_config.param)
				
				ccui.Helper:seekWidgetByName(root, "Text_money_card"):setString(money)

				ccui.Helper:seekWidgetByName(root, "Text_tt_0"):setString(dms.atos(magic_card_data,magic_trap_card_info.current_star))
				ccui.Helper:seekWidgetByName(root, "Text_lv_0_card"):setString("Lv"..heroInstance.strong_level)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 武将重生请求
		local magic_card_reborn_request_reborn_terminal = {
            _name = "magic_card_reborn_request_reborn",
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
						previewWnd:init(6, {response.node.magic_card_instance})
						fwin:open(previewWnd)
					end
				end
				--> print(instance.magic_card_instance.ship_id,"instance.magic_card_instance.ship_id---------------------")
				protocol_command.recycle_init.param_list = "".."6".."\r\n"..instance.magic_card_instance.id
				NetworkManager:register(protocol_command.recycle_init.code, nil, nil, nil, instance, responseGetPreviewCallback, false, nil)
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 选择重生魔陷卡
		local magic_card_reborn_choose_magic_card_terminal = {
            _name = "magic_card_reborn_choose_hero",
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
					fwin:open(MagicCardChooseForReborn:new(), fwin._view)
				else
					TipDlg.drawTextDailog(_magic_card_tip[17])
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--帮助
		local magic_card_reborn_open_helpdlg_terminal = {
            _name = "magic_card_reborn_open_helpdlg",
            _init = function (terminal) 
                app.load("client.refinery.MagicCardInfo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = MagicCardInfo:new()
				cell:init(2)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--重生完毕的刷新
		local magic_card_reborn_over_update_terminal = {
            _name = "magic_card_reborn_over_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				pushEffect(formatMusicFile("effect", 9993))
				
				state_machine.excute("magic_card_reborn_init", 0, "magic_card_reborn_init.")
				state_machine.excute("shop_window_update", 0, "shop_window_update.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(magic_card_reborn_init_terminal)
        state_machine.add(magic_card_reborn_show_magic_card_info_terminal)
        state_machine.add(magic_card_reborn_request_reborn_terminal)
        state_machine.add(magic_card_reborn_choose_magic_card_terminal)
        state_machine.add(magic_card_reborn_open_helpdlg_terminal)
        state_machine.add(magic_card_reborn_over_update_terminal)
        state_machine.init()
    end
    
    init_magic_card_reborn_terminal()
end

function MagicCardRebornPage:sortHerosForReborn()
	local function chooseHero()
		local list = {}
		local j = 1
		for i, v in pairs(_ED.user_magic_trap_info) do
			if _ED.magicCard_formation[zstring.tonumber(v.id)] == nil then 
				--没有上阵
				local startLevel = dms.int(dms["magic_trap_card_info"],v.base_mould,magic_trap_card_info.current_star)

				local cardType = dms.int(dms["magic_trap_card_info"],v.base_mould,magic_trap_card_info.card_type)
				local strongLevel = zstring.tonumber(v.strong_level)
				if cardType ~= nil and (startLevel > 0 or strongLevel > 0) then 
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

function MagicCardRebornPage:displayTypeChange(_type)
	local root = self.roots[1]
	local magic_card_pad =  ccui.Helper:seekWidgetByName(root, "Panel_20"):getChildByName("Panel_10"):getChildByName("ProjectNode_1"):getChildByName("root")

	if _type == "show_magic_card" then
		-- 显示属性面板
		ccui.Helper:seekWidgetByName(root, "Panel_28_0"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_28"):setVisible(false)
		-- 显示名称
		ccui.Helper:seekWidgetByName(magic_card_pad, "Image_26"):setVisible(true)
		-- 隐藏初始面板
		ccui.Helper:seekWidgetByName(root, "Panel_27"):setVisible(false)
		-- 隐藏“+”
		ccui.Helper:seekWidgetByName(magic_card_pad, "Image_33"):setVisible(false)
		ccui.Helper:seekWidgetByName(magic_card_pad, "Panel_2"):getChildByName("ArmatureNode_1"):setVisible(false)
	
	elseif _type == "no_magic_card" then
		-- 清除属性面板
		ccui.Helper:seekWidgetByName(root, "Panel_28_0"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_28"):setVisible(false)
		-- 清除武将
		ccui.Helper:seekWidgetByName(magic_card_pad, "Panel_31"):removeBackGroundImage()
		ccui.Helper:seekWidgetByName(magic_card_pad, "Panel_31_card"):removeBackGroundImage()
		ccui.Helper:seekWidgetByName(magic_card_pad, "Panel_31_card_0"):removeBackGroundImage()
		
		-- 隐藏名称
		ccui.Helper:seekWidgetByName(magic_card_pad, "Image_26"):setVisible(false)
		-- 显示初始面板
		ccui.Helper:seekWidgetByName(root, "Panel_27"):setVisible(true)
		-- 显示“+”
		ccui.Helper:seekWidgetByName(magic_card_pad, "Image_33"):setVisible(true)
		ccui.Helper:seekWidgetByName(magic_card_pad, "Panel_2"):getChildByName("ArmatureNode_1"):setVisible(true)
	end
end

function MagicCardRebornPage:onEnterTransitionFinish()
	local csbmagic_card_reborn = csb.createNode("refinery/refinery_gen_cs.csb")
	self:addChild(csbmagic_card_reborn)
	local root = csbmagic_card_reborn:getChildByName("root")
	table.insert(self.roots, root)
    local magic_card_pad = ccui.Helper:seekWidgetByName(root, "Panel_20"):getChildByName("Panel_10"):getChildByName("ProjectNode_1"):getChildByName("root")
	ccui.Helper:seekWidgetByName(magic_card_pad, "Image_25"):setVisible(false)
	state_machine.excute("magic_card_reborn_init", 0, "magic_card_reborn_init.")
	ccui.Helper:seekWidgetByName(root, "Text_33"):setString(_magic_card_tip[16])
	
	--选择
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(magic_card_pad, "Panel_31"), nil, 
	{
		terminal_name = "magic_card_reborn_choose_hero"
	},
	nil, 0)
	
    --帮助
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_20"), nil, 
	{
		terminal_name = "magic_card_reborn_open_helpdlg", 
		isPressedActionEnabled = true
	},
	nil, 0)
	
	--重生
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_21_card"), nil, 
	{
		terminal_name = "magic_card_reborn_request_reborn", 
		isPressedActionEnabled = true
	},
	nil, 0)
	
end

function MagicCardRebornPage:onExit()
	state_machine.remove("magic_card_reborn_init")
	state_machine.remove("magic_card_reborn_show_magic_card_info")
	state_machine.remove("magic_card_reborn_request_reborn")
	state_machine.remove("magic_card_reborn_choose_hero")
	state_machine.remove("magic_card_reborn_open_helpdlg")
	state_machine.remove("magic_card_reborn_over_update")
end
