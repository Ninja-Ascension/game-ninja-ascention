-----------------------------------------------------------------------------------------------------------
-- 说明：宠物商店
-- 创建时间
-- 作者：李潮
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

PetShop = class("PetShopClass", Window)
    
function PetShop:ctor()
    self.super:ctor()
	app.load("client.cells.pet.pet_shop_list_cell")
	app.load("client.shop.ShopUserInformation")
	app.load("client.refinery.RefiningFurnace")
	
	self.roots = {}
	self.propId = nil
	self.surplus = 0
	self.closeType = nil
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.type = nil
	self.isGetServer = false
	self.isAutoSendInit = false
    -- Initialize HeroShop page state machine.
    local function init_pet_shop_terminal()
		--关闭
		local pet_shop_return_page_terminal = {
            _name = "pet_shop_return_page",
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
        --刷新
		local pet_shop_refresh_button_terminal = {
            _name = "pet_shop_refresh_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil then
							local currentType = response.node.closeType
							fwin:close(response.node)
							local awakenShop =  PetShop:new()
							awakenShop:init(1)
							fwin:open(awakenShop, fwin._viewdialog) 
						end
					end
				end
				if self.surplus > 0 then
					NetworkManager:register(protocol_command.pet_shop_refresh.code, nil, nil, nil, instance, recruitCallBack, false, nil)
				else
					TipDlg.drawTextDailog(_string_piece_info[161])
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --获取
		local pet_equiment_resolve_recover_terminal = {
            _name = "pet_equiment_resolve_recover",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 	
	   			
	   			local function responsePetDuplicateCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                		fwin:close(fwin:find("PetShopClass"))    	
                        app.load("client.campaign.battlefield.BattleField")
            			state_machine.excute("battle_field_window_open",0,"")
                    end
                end
                NetworkManager:register(protocol_command.pet_counterpart_init.code, nil, nil, nil, nil, responsePetDuplicateCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local pet_shop_buy_goods_terminal = {
            _name = "pet_shop_buy_goods",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:BuyGoods()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(pet_shop_return_page_terminal)
		state_machine.add(pet_shop_refresh_button_terminal)
		state_machine.add(pet_equiment_resolve_recover_terminal)
		state_machine.add(pet_shop_buy_goods_terminal)
		
		state_machine.init()
    end
    
    -- call func init hom state machine.
    init_pet_shop_terminal()
end

function PetShop:formatTimeString(_time)	--系统时间转换
	local timeString = ""
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
	return timeString
end


function PetShop:onUpdate(dt)
	local root = self.roots[1]
	if root == nil then 
		return
	end
	if self.isGetServer == false then 
		return
	end
	if _ED.pet_shop_init_info.os_time ~= nil then
		local times = os.time()- tonumber(_ED.pet_shop_init_info.os_time)
		local remainTime = 0
		local _refreshTime = ccui.Helper:seekWidgetByName(root, "Text_2")
		if times > _ED.pet_shop_init_info.refresh_time/1000 then -- 当前时间减去登录那一刻的时间大于服务器返回的剩余时间。就说明可以免费招了
			_refreshTime:setString(self:formatTimeString(remainTime))
			local function autoRefreshShopInfo( ... )
				if self ~= nil and self.roots ~= nil and self.roots[1] ~= nil then 
					local function recruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then 

								local currentType = response.node.closeType
								fwin:close(response.node)
								local awakenShop =  PetShop:new()
								awakenShop:init(1)
								fwin:open(awakenShop, fwin._viewdialog) 
							end
						end
					end
					NetworkManager:register(protocol_command.pet_shop_init.code, nil, nil, nil, self, recruitCallBack, false, nil)
				end
			end 
			if self.isAutoSendInit == false then 
				self.isAutoSendInit = true
				local action = cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(autoRefreshShopInfo))  
	    		self:stopAllActions()
				self:runAction(action)
			end
			
		else 
			remainTime =_ED.pet_shop_init_info.refresh_time/1000-times	--剩余刷新的时间
			_refreshTime:setString(self:formatTimeString(remainTime))
		end
	end
end

function PetShop:BuyGoods()
	local _jadeText = ccui.Helper:seekWidgetByName(self.roots[1], "Text_4")
	_jadeText:setString(_ED.user_info.pet_soul)
	state_machine.excute("battle_field_update_soul",0,0)
end

function PetShop:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local count = getPropAllCountByMouldId(3)

	if count == nil then
		count = 0
	end
	local _refreshCount = ccui.Helper:seekWidgetByName(root, "Text_10_0")
	_refreshCount:setString(count)
	--刷新次数
	local VipLv = tonumber(_ED.vip_grade)
	local refreshNumber = tonumber(dms.string(dms["base_consume"],30,tonumber(base_consume.vip_0_value)+VipLv))
	local surplusRefresh = refreshNumber - tonumber(_ED.pet_shop_init_info.refresh_count)
	local _refreshNumber = ccui.Helper:seekWidgetByName(root, "Text_9")
	self.surplus = surplusRefresh
	_refreshNumber:setString(surplusRefresh)

	local CommodityShop = {
		ccui.Helper:seekWidgetByName(root, "Panel_3"),
		ccui.Helper:seekWidgetByName(root, "Panel_4"),
		ccui.Helper:seekWidgetByName(root, "Panel_5"),
		ccui.Helper:seekWidgetByName(root, "Panel_6"),
		ccui.Helper:seekWidgetByName(root, "Panel_7"),
		ccui.Helper:seekWidgetByName(root, "Panel_8")
	}
	for i ,v in pairs(_ED.pet_shop_init_info.goods_info) do 
		if i >= 7 then
			return
		else
			local picCell = PetShopListCell:createCell()
			picCell:init(
			{
				user_prop_template = v.goods_id, 
				mould_id = v.goods_id, 
				prop_number = v.sell_count, 
				buy_type = v.sell_type, 
				picel = v.sell_price
			},
			v.goods_type, v, i)--1：商品类型 2：商品实例 3：商品下标索引
			CommodityShop[i]:removeAllChildren(true)
			CommodityShop[i]:addChild(picCell)	
		end
	end
end

function PetShop:onEnterTransitionFinish()		
    local csbHeroShop = csb.createNode("packs/PetStorage/PetStorage_Shop.csb")
	local action = csb.createTimeline("packs/PetStorage/PetStorage_Shop.csb") 
	
   	action:gotoFrameAndPlay(0, action:getDuration(), false)
    csbHeroShop:runAction(action)
	local root = csbHeroShop:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbHeroShop)
	self.isGetServer = false
	self.isAutoSendInit = false
	local function recruitCallBack(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			--成功
			if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then 
	
				return
			end
			local times = os.time()-_ED.pet_shop_init_info.os_time
			if times > _ED.pet_shop_init_info.refresh_time/1000 then
				TipDlg.drawTextDailog(_string_piece_info[131])
			end
			self.isGetServer = true
			self:onUpdateDraw()
			self:BuyGoods()
		end
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
		{
			terminal_name = "pet_shop_return_page", 
			next_terminal_name = "", 
			but_image = "", 
			terminal_state = 0, 
			cell = self,
			isPressedActionEnabled = true
		}, 
		nil, 2)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, 
		{
			terminal_name = "pet_shop_refresh_button", 
			next_terminal_name = "", 
			but_image = "", 
			terminal_state = 0, 
			cell = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
		{
			terminal_name = "pet_equiment_resolve_recover", 
			next_terminal_name = "", 
			but_image = "", 
			terminal_state = 0, 
			cell = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end
	protocol_command.pet_shop_init.param_list = "1"
	NetworkManager:register(protocol_command.pet_shop_init.code, nil, nil, nil, self, recruitCallBack, false, nil)
end

function PetShop:init(closeType)
	self.closeType = closeType
end

function PetShop:close()

end

function PetShop:onExit()
	state_machine.remove("pet_shop_return_page")
	state_machine.remove("pet_shop_refresh_button")

end


