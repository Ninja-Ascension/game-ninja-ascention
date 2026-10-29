----------------------------------------------------------------------------------------------------
-- 说明：sm商城道具购买单元项
----------------------------------------------------------------------------------------------------
SmSecretShopPropBuyListCell = class("SmSecretShopPropBuyListCellClass", Window)
SmSecretShopPropBuyListCell.__size = nil

function SmSecretShopPropBuyListCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.actions = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.l_digital.shop.SmShopBuy")
	
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_sm_secret_shop_prop_buy_list_cell_terminal()
		--使用按钮的点击
		local sm_secret_shop_prop_buy_list_buy_terminal = {
            _name = "sm_secret_shop_prop_buy_list_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params[1]
            	local root = cell.roots[1]
            	local Image_sell_out = ccui.Helper:seekWidgetByName(root, "Image_sell_out")
            	if Image_sell_out:isVisible() == true then
            	else
            		state_machine.excute("sm_shop_buy_open",0,{cell.prop, cell, cell.index, sm_secret_shop_prop_buy_list_buy_request})
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local sm_secret_shop_prop_buy_list_buy_request_terminal = {
            _name = "sm_secret_shop_prop_buy_list_buy_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params[1]
        		local function responseBuyPropCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if nil ~= response.node and nil ~= response.roots and nil ~= response.roots[1] then
							state_machine.excute("sm_shop_prop_buy_list_refush", 0, response.node)
						end
					end
				end
				protocol_command.mystical_shop_buy.param_list = ""..(instance.index - 1).."\r\n".."1"
				NetworkManager:register(protocol_command.mystical_shop_buy.code, nil, nil, nil, cell, responseBuyPropCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--刷新列表
		local sm_secret_shop_prop_buy_list_refush_terminal = {
            _name = "sm_secret_shop_prop_buy_list_refush",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

            	if params.updateData and params.onUpdateDraw then
            		params:updateData()
            		params:onUpdateDraw()
            	end
            	
            	local root = params.roots[1]
	            local Image_sell_out = ccui.Helper:seekWidgetByName(root, "Image_sell_out")
            	if true == Image_sell_out:isVisible() then
	            	Image_sell_out:setVisible(true)
	            	Image_sell_out:setScale(2)
	            	Image_sell_out:runAction(cc.ScaleTo:create(0.1, 1))
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(sm_secret_shop_prop_buy_list_buy_terminal)
		state_machine.add(sm_secret_shop_prop_buy_list_buy_request_terminal)
		state_machine.add(sm_secret_shop_prop_buy_list_refush_terminal)
        state_machine.init()
	end
	init_sm_secret_shop_prop_buy_list_cell_terminal()
end


function SmSecretShopPropBuyListCell:onUpdateDraw()
	local root = self.roots[1]
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	Text_name:setString(self.prop.mould_name.."x"..self.prop.number)
	local quality = tonumber(self.prop.prop_quality)
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital and dark_text_color then
		Text_name:setColor(cc.c3b(dark_text_color[quality+1][1], dark_text_color[quality+1][2], dark_text_color[quality+1][3]))
	else
		Text_name:setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))
	end
	local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
	Text_5:setString(self.prop.sale_percentage)
	local Image_sell_out = ccui.Helper:seekWidgetByName(root, "Image_sell_out")
	if tonumber(self.prop.buy_times) > 0 then
		Image_sell_out:setVisible(false)
	else
		Image_sell_out:setVisible(true)
	end

	-- image_gem_1   
	-- image_money_1 
	-- image_jjb_1   
	-- image_slb_1   
	-- image_ghb_1   

	local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")

	local cost_image = {
		[1] = "images/ui/icon/zuanshi.png",   		-- 钻石
		[2] = "images/ui/icon/jinbi.png",   		-- 金币
		[3] = "images/ui/icon/qh_pic_jjb.png",   		--竞技币
		[4] = "images/ui/icon/slb.png",   		--试炼币
		[5] = "images/ui/icon/icon_ghb.png",   		--公会币
	}

	Panel_icon:setBackGroundImage(cost_image[tonumber(self.prop.sell_type)])
	Text_5:setString(self.prop.need_count)

	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
	Panel_6:removeAllChildren(true)
	local cell = ResourcesIconCell:createCell()
	if tonumber(self.prop.type) == 7 then
		cell:init(tonumber(self.prop.type),0,tonumber(self.prop.mould_id),nil,nil,nil,nil,nil,{equipQuality = quality})
	else
		cell:init(tonumber(self.prop.type),0,tonumber(self.prop.mould_id))
	end
	Panel_6:addChild(cell)
	local panel = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop")
	panel:setTouchEnabled(false)

	local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
	if Image_1 ~= nil then
		Image_1:setVisible(false)
	end

	-- 折扣
	local Image_sale = ccui.Helper:seekWidgetByName(root, "Image_sale")
	Image_sale:setVisible(true)
	if self.prop.discount_rate ~= "-1" then
		Image_sale:setVisible(true)
		local Text_Sale = ccui.Helper:seekWidgetByName(root, "Text_Sale")
		local _str = string.gsub(_new_interface_text[309], "!x@", self.prop.discount_rate)
		Text_Sale:setString(_str)
	else
		Image_sale:setVisible(false)
	end
end

function SmSecretShopPropBuyListCell:updateData()
	local v = _ED.secret_shop_info.items[self.index]
	local element = dms.element(dms["mystical_shop_info"], v[1], true)
    -- local prop = {
    --     id = element[1], -- id
    --     item_params = element[2], -- string 商品资源类型，资源模板ID，数量|下一个
    --     consume_params = element[3], -- string 购买一次消耗资源类型，资源模板ID，数量|下一个
    --     position = element[4], -- int 库组（代表位置）
    --     weight = element[5], -- int 权重
    --     purchase_limit = element[6], -- 限购次数
    --     need_levels = element[7], -- int[] 出现等级（最小，最大）
    --     discount_rate = element[8], -- 折数
    -- }
    local prop = {}
    local info = zstring.splits(element[mystical_shop_info.item_params], "|", ",")
    prop.type = info[1][1]
    prop.mould_id = info[1][2]
    prop.number = info[1][3]
    
    local name_mould_id = dms.string(dms["prop_mould"], prop.mould_id, prop_mould.prop_name)
    
    prop.buy_times = tonumber(element[mystical_shop_info.purchase_limit]) - tonumber(v[2])

    info = zstring.splits(element[mystical_shop_info.consume_params], "|", ",")
    prop.need_type = tonumber(info[1][1])
    prop.need_mould_id = tonumber(info[1][2])
    prop.need_count = tonumber(info[1][3])
    prop.sale_percentage = prop.need_count
    if prop.need_type == 2 then
        prop.sell_type = 1
    else
        prop.sell_type = 2
    end
    prop.discount_rate = element[mystical_shop_info.discount_rate]--tonumber(element[mystical_shop_info.discount_rate])
    if tonumber(prop.type) == 6 then 
    	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        name = setThePropsIcon(prop.mould_id)[2]
		end
	    --prop.mould_name = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
	    prop.mould_name = name
	    prop.prop_quality = dms.string(dms["prop_mould"], prop.mould_id, prop_mould.prop_quality)
	    prop.mould_remarks = drawPropsDescription(prop.mould_id)
    elseif tonumber(prop.type) == 7 then
	    prop_info = dms.element(dms["equipment_mould"], prop.mould_id)
		prop.mould_name = smEquipWordlFundByIndex(prop.mould_id , 1)
		prop.prop_quality = dms.atoi(prop_info, equipment_mould.trace_npc_index)
		if tonumber(prop.prop_quality) == 0 then
			prop.prop_quality = 3
		end
		prop.mould_remarks = smEquipWordlFundByIndex(prop.mould_id , 2)--描述
	end
    self.prop = prop
end

function SmSecretShopPropBuyListCell:onInit()
	self:updateData()
    local root = cacher.createUIRef("list/list_daoju.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	-- local panel = ccui.Helper:seekWidgetByName(root, "Panel_5")
	local panel_size = root:getContentSize()
	self:onUpdateDraw()
	self:setContentSize(panel_size)
	if SmSecretShopPropBuyListCell.__size == nil then
		SmSecretShopPropBuyListCell.__size = panel_size
	end

	-- self:runAction(cc.Sequence:create({cc.DelayTime:create(0.1), cc.CallFunc:create(function ( sender )
    	-- self:setVisible(true)
 --        sender.roots[1]:runAction(cc.Sequence:create(
 --            cc.ScaleTo:create(0.1, 0.95),
 --            cc.ScaleTo:create(0.05, 1)
 --            ))
 --    end)}))

 	local function PanelTouchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        if ccui.TouchEventType.began == evenType then
        elseif ccui.TouchEventType.moved == evenType then
        elseif ccui.TouchEventType.canceled == evenType then
        elseif ccui.TouchEventType.ended == evenType then
            if math.abs(__epoint.x - __spoint.x) <= 3 
            	and math.abs(__epoint.y - __spoint.y) <= 3 then
                state_machine.excute("sm_secret_shop_prop_buy_list_buy",0,{sender._self})
            end
        end
    end
 	local Image_purchase = ccui.Helper:seekWidgetByName(root, "Image_purchase")
 	Image_purchase._self = self
 	Image_purchase:addTouchEventListener(PanelTouchEvent)
	-- fwin:addTouchEventListener(, nil, 
	-- {
	-- 	terminal_name = "sm_secret_shop_prop_buy_list_buy", 
	-- 	terminal_state = 0, 
	-- 	_cell = self,
	-- }, 
	-- nil, 0)
end

function SmSecretShopPropBuyListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SmSecretShopPropBuyListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("list/list_daoju.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function SmSecretShopPropBuyListCell:clearUIInfo( ... )
    local root = self.roots[1]
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
	local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
	local Image_sale = ccui.Helper:seekWidgetByName(root, "Image_sale")
	if Text_name ~= nil then
		Text_name:setString("")
		Text_5:setString("")
		Panel_6:removeAllChildren(true)
		Panel_icon:removeBackGroundImage()

	end
	if Image_sale ~= nil then
		Image_sale:setVisible(false)
	end
    local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
	if Image_1 ~= nil then
		Image_1:setVisible(false)
	end
end

function SmSecretShopPropBuyListCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("list/list_daoju.csb", self.roots[1])
end

function SmSecretShopPropBuyListCell:init(prop , page , index)
	self.prop = prop
	self.page = page
	self.index = index
	self:onInit()
	self:setContentSize(SmSecretShopPropBuyListCell.__size)
end

function SmSecretShopPropBuyListCell:createCell()
	local cell = SmSecretShopPropBuyListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


