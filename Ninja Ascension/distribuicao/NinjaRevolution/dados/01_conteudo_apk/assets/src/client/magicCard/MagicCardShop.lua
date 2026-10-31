-- ----------------------------------------------------------------------------------------------------
-- 说明：魔陷商店
-------------------------------------------------------------------------------------------------------

MagicCardShop = class("MagicCardShopClass", Window)
    
function MagicCardShop:ctor()
    self.super:ctor()
    self.roots = {}
	self.rebelArmyMouldId = nil
	app.load("client.cells.prop.prop_icon_new_cell")
    -- Initialize MagicCardShop page state machine.
    local function init_magic_card_shop_terminal()
		
		local magic_card_shop_buy_terminal = {
            _name = "magic_card_shop_buy",
            _init = function (terminal) 
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then 
							response.node:onUpdateDraw()
							app.load("client.reward.DrawRareReward")
							local tempRewardInfo = getSceneReward(36)
							if tempRewardInfo ~= nil then
								local getRewardWnd = DrawRareReward:new()
								getRewardWnd:init(36, tempRewardInfo)
								fwin:open(getRewardWnd,fwin._ui)
							end
						end		
					end
				end
				protocol_command.secret_shopman_exchange.param_list = params._datas.prop_index.."\r\n"
				NetworkManager:register(protocol_command.secret_shopman_exchange.code, nil, nil, nil, instance, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(magic_card_shop_buy_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_magic_card_shop_terminal()
end
function MagicCardShop:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_juese")
	rolePanel:removeAllChildren(true)
	local jsonFile = "sprite/spirte_battle_card_422.json"
    local atlasFile = "sprite/spirte_battle_card_422.atlas"
    app.load("client.battle.fight.FightEnum")
    local spArmature = sp.spine(jsonFile, atlasFile, 1, 0, 
    spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)

    spArmature:setPosition(cc.p(rolePanel:getContentSize().width/2, 0))
    spArmature.animationNameList = spineAnimations
    sp.initArmature(spArmature, true)
    rolePanel:addChild(spArmature)

    local propPanel1 = ccui.Helper:seekWidgetByName(root, "Panel_5")
    propPanel1:removeAllChildren(true)
    local propPanel2 = ccui.Helper:seekWidgetByName(root, "Panel_6")
    propPanel2:removeAllChildren(true)

    local propPanels = {propPanel1,propPanel2}
    local buyButton1 = ccui.Helper:seekWidgetByName(root, "Button_buy_1")
    local buyButton2 = ccui.Helper:seekWidgetByName(root, "Button_buy_2")

    local buyButtons = {buyButton1,buyButton2}

    local priceTexts = {
    	ccui.Helper:seekWidgetByName(root, "Text_222"),
    	ccui.Helper:seekWidgetByName(root, "Text_333"),
    	ccui.Helper:seekWidgetByName(root, "Text_222_0"),
    	ccui.Helper:seekWidgetByName(root, "Text_333_0"),
	}

	local infoTexts = {
    	ccui.Helper:seekWidgetByName(root, "Text_27"),
    	ccui.Helper:seekWidgetByName(root, "Text_28"),
    	ccui.Helper:seekWidgetByName(root, "Text_27_0"),
    	ccui.Helper:seekWidgetByName(root, "Text_28_0"),
	}

	local pricePanels = {
		ccui.Helper:seekWidgetByName(root, "Panel_price_1"),
		ccui.Helper:seekWidgetByName(root, "Panel_price_2"),
		ccui.Helper:seekWidgetByName(root, "Panel_price_3"),
		ccui.Helper:seekWidgetByName(root, "Panel_price_4"),
	}

	local buttonTexts = {
		ccui.Helper:seekWidgetByName(root, "Text_buy"),
		ccui.Helper:seekWidgetByName(root, "Text_buy_0"),
	}
	for i=1,4 do
		priceTexts[i]:setString("")
		infoTexts[i]:setString("")
		pricePanels[i]:removeAllChildren(true)
	end
	
	local counts = 1
    for i,v in pairs(_ED.secret_shopPerson_init_info.goods_info) do
		if zstring.tonumber(goods_type) == 0 then 
			local iconCell = PropIconNewCell:createCell()
			local prop_mouldId = v.goods_mould_id
			iconCell:init(5, {user_prop_template = prop_mouldId,prop_number = v.sell_count })
			propPanels[i]:addChild(iconCell)
			infoTexts[i + 1 *(i-1)]:setString("")
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				infoTexts[i + 1 *(i-1) + 1]:setString(drawPropsDescription(prop_mouldId))
			else
				infoTexts[i + 1 *(i-1) + 1]:setString(dms.string(dms["prop_mould"], prop_mouldId, prop_mould.remarks))
			end
			
			
			if zstring.tonumber(v.remain_times) <= 0 then 
				buyButtons[i]:setTouchEnabled(false)
				buyButtons[i]:setColor(cc.c3b(150, 150, 150))
				buttonTexts[i]:setString(_magic_card_tip[15])
			else
				buttonTexts[i]:setString(_magic_card_tip[14])
			end
			priceTexts[i + 1 *(i-1)]:setString(dms.string(dms["secret_shopman_info"], v.goods_id, secret_shopman_info.price))
			priceTexts[i + 1 *(i-1)+ 1]:setString(dms.string(dms["secret_shopman_info"], v.goods_id, secret_shopman_info.cost_price))
			local priceType = dms.int(dms["secret_shopman_info"],v.goods_id,secret_shopman_info.sell_type)
			if priceType == 1 then
				--金币 
				pricePanels[i + 1 *(i-1)]:setBackGroundImage("images/ui/icon/icon_gem.png")
				pricePanels[i + 1 *(i-1)+ 1]:setBackGroundImage("images/ui/icon/icon_gem.png")
			else
				--魔陷书
				pricePanels[i + 1 *(i-1)]:setBackGroundImage("images/ui/icon/icon_moxianshu.png")
				pricePanels[i + 1 *(i-1)+ 1]:setBackGroundImage("images/ui/icon/icon_moxianshu.png")
			end
		end
    end
end

function MagicCardShop:onEnterTransitionFinish()
	
	local csbMagicCardShop = csb.createNode("duplicate/prompt_shenmishangren.csb")
	self:addChild(csbMagicCardShop)
	local root = csbMagicCardShop:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_1"),       nil, 
    {
        terminal_name = "magic_card_shop_buy",     
        terminal_state = 0, 
        prop_index = 0 ,
        isPressedActionEnabled = false
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_2"),       nil, 
    {
        terminal_name = "magic_card_shop_buy",     
        terminal_state = 0, 
        prop_index = 1 ,
        isPressedActionEnabled = false
    }, 
    nil, 0)

	local function backPlotScene(sender, eventType)				--点击确定
		if eventType == ccui.TouchEventType.ended then
			fwin:close(self)
		elseif eventType == ccui.TouchEventType.began then
			playEffect(formatMusicFile("button", 1))		--加入按钮音效
		end
	end
	ccui.Helper:seekWidgetByName(root, "Panel_13_3"):addTouchEventListener(backPlotScene)
end


function MagicCardShop:init()
	self.rebelArmyMouldId 		=  _ED.rebel_army_mould_id 
	
end

function MagicCardShop:createCell()
	local cell = MagicCardShop:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function MagicCardShop:onExit()

end
