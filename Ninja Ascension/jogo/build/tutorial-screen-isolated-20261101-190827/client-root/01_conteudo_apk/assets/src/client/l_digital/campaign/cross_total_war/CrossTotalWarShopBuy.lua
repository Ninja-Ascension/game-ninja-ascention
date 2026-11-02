-- ----------------------------------------------------------------------------------------------------
-- 说明：跨服矿战商城道具购买界面
-------------------------------------------------------------------------------------------------------

CrossTotalWarShopBuy = class("SCrossTotalWarShopBuyClass", Window)

local cross_total_war_buy_open_terminal = {
    _name = "cross_total_war_buy_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local CrossTotalWarShopBuyWindow = fwin:find("SCrossTotalWarShopBuyClass")
    	if CrossTotalWarShopBuyWindow ~= nil then
    		fwin:close(CrossTotalWarShopBuyWindow)
    	end
    	local page = CrossTotalWarShopBuy:new():init(params)
    	fwin:open(page , fwin._ui)
		return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(cross_total_war_buy_open_terminal)
state_machine.init()

function CrossTotalWarShopBuy:ctor()
    self.super:ctor()
	self.roots = {}
	self.prop = nil
	self.cell = nil
	local function init_cross_total_war_buy_terminal()
		local cross_total_war_buy_confirm_buy_terminal = {
            _name = "cross_total_war_buy_confirm_buy",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
            	local all_money = zstring.tonumber(_ED.cross_arena_shop_info.coin)

            	if tonumber(all_money) < tonumber(cell.prop.sale_percentage) then
            		TipDlg.drawTextDailog(tipStringInfo_cross_total_war_tips[1])
            		return
            	end
            	local function responseBuyPropCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						TipDlg.drawTextDailog(_new_interface_text[92])
						if response.node ~= nil then
							response.node.cell.shopInfo.purchasedTimes = tonumber(response.node.cell.shopInfo.purchasedTimes) + 1
							response.node.cell:initData()
							response.node.cell:onUpdateDraw()
							fwin:close(instance)
						end
					end
				end
				protocol_command.cross_arena_shop_buy.param_list = cell.id
				NetworkManager:register(protocol_command.cross_arena_shop_buy.code, nil, nil, nil, self, responseBuyPropCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--
		local cross_total_war_buy_close_terminal = {
            _name = "cross_total_war_buy_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(cross_total_war_buy_confirm_buy_terminal)
		state_machine.add(cross_total_war_buy_close_terminal)
        state_machine.init()
	end
	init_cross_total_war_buy_terminal()
end

function CrossTotalWarShopBuy:onUpdateDraw()
	local root = self.roots[1]
	local Panel_packs_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_packs_props_icon")
	local image_gem = ccui.Helper:seekWidgetByName(root, "image_gem")
	Panel_packs_props_icon:removeAllChildren(true)
	local cell = ResourcesIconCell:createCell()
	if tonumber(self.prop.type) == 7 then
		local quality = tonumber(self.prop.prop_quality)
		cell:init(tonumber(self.prop.type),0,tonumber(self.prop.mould_id),nil,nil,nil,nil,nil,{equipQuality = quality})
	else
		cell:init(tonumber(self.prop.type),0,tonumber(self.prop.mould_id))
	end
	Panel_packs_props_icon:addChild(cell)

	--名称
	local Text_packs_props_name = ccui.Helper:seekWidgetByName(root, "Text_packs_props_name")
	Text_packs_props_name:setString(self.prop.mould_name)
	--描述
	local Text_props_info = ccui.Helper:seekWidgetByName(root, "Text_props_info")
	Text_props_info:setString(self.prop.mould_remarks)
	--购买数量
	local Text_buy_n = ccui.Helper:seekWidgetByName(root, "Text_buy_n")
	Text_buy_n:removeAllChildren(true)
	Text_buy_n:setString("")

	local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)

    local richTextWidth = Text_buy_n:getContentSize().width
    if richTextWidth == 0 then
        richTextWidth = Text_buy_n:getFontSize() * 6
    end
			    
    _richText2:setContentSize(cc.size(richTextWidth, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))
    local char_str = string.gsub(_new_interface_text[80], "!x@", self.prop.number)
    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    char_str, 
    cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),
    cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),
    0, 
    0, 
    Text_buy_n:getFontName(), 
    Text_buy_n:getFontSize(),
    chat_rich_text_color)
    _richText2:setPositionX(-30)
    local rsize = _richText2:getContentSize()
    _richText2:setPositionY(Text_buy_n:getContentSize().height - 3)
    Text_buy_n:addChild(_richText2)

	--价格
	local Text_price_n = ccui.Helper:seekWidgetByName(root, "Text_price_n")
	Text_price_n:setString(self.prop.sale_percentage)

	--拥有数量
	local Text_have_n = ccui.Helper:seekWidgetByName(root, "Text_have_n")
	local haveNumber = 0
	if tonumber(self.prop.type) == 7 then
		for i, v in pairs(_ED.user_equiment) do
			if v.user_equiment_template == ""..self.prop.mould_id then 
				haveNumber = haveNumber + 1
			end
		end
	else
		haveNumber = getPropAllCountByMouldId(tonumber(self.prop.mould_id))
	end
	Text_have_n:setString(haveNumber)
	-- Text_have_n:removeAllChildren(true)
	-- local _richText = ccui.RichText:create()
 --    _richText:ignoreContentAdaptWithSize(false)       
 --     local re1 = ccui.RichElementText:create(1, cc.c3b(255,255,255),255, haveNumber, Text_have_n:getFontName(),Text_have_n:getFontSize())
 --    _richText:pushBackElement(re1)  
 --     local re2 = ccui.RichElementText:create(1, cc.c3b(225,182,0),255, _new_interface_text[97], Text_have_n:getFontName(),Text_have_n:getFontSize())
 --    _richText:pushBackElement(re2)
 --    _richText:setPosition(cc.p(Text_have_n:getContentSize().width / 2,Text_have_n:getContentSize().height/2 + 3))
 --    _richText:setContentSize(cc.size(Text_have_n:getContentSize().width,18))
 --    Text_have_n:addChild(_richText)

	local cost_image = {
		ccui.Helper:seekWidgetByName(root, "image_gem_3"),		--宝石
		ccui.Helper:seekWidgetByName(root, "image_money_3"),	--银币
		ccui.Helper:seekWidgetByName(root, "image_jjb_3"),		--竞技币
		ccui.Helper:seekWidgetByName(root, "image_slb_3"),		--试炼币
		ccui.Helper:seekWidgetByName(root, "image_ghb_3"),		--公会币
	}
	for i , v in pairs(cost_image) do
		cost_image[i]:setVisible(false)
	end
	local cost_images = {
		[1] = "images/ui/icon/zuanshi.png",   		-- 钻石
		[2] = "images/ui/icon/jinbi.png",   		-- 金币
		[65] = "images/ui/text/cross_service/ico_kuang_s.png" -- 矿石
	}
	cost_image[1]:loadTexture("images/ui/props/props_5376.png")
	cost_image[1]:setVisible(true)
end

function CrossTotalWarShopBuy:onInit()
	local csbSmShopBuy = csb.createNode("shop/sm_shop_purchase_window.csb")
	local root = csbSmShopBuy:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csbSmShopBuy)

    local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
    Image_1:setTouchEnabled(true)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sell"), nil, 
	{
		terminal_name = "cross_total_war_buy_confirm_buy", 
		terminal_state = 0, 
		_cell = self,
	}, 
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		terminal_name = "cross_total_war_buy_close", 
		terminal_state = 0, 
		_cell = self,
	}, 
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, 
	{
		terminal_name = "cross_total_war_buy_close", 
		terminal_state = 0, 
		_cell = self,
	}, 
	nil, 0)
	
	self:onUpdateDraw()
end

function CrossTotalWarShopBuy:init(params)
	self.prop = params[1]
	self.cell = params[2]
	self.id = params[3]
	self:onInit()
	return self
end

function CrossTotalWarShopBuy:onExit()
	state_machine.remove("cross_total_war_buy_confirm_buy")
	state_machine.remove("cross_total_war_buy_close")
end

