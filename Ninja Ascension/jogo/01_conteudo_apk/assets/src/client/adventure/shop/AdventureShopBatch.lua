-- ----------------------------------------------------------------------------------------------------
-- 说明：批量购买
-------------------------------------------------------------------------------------------------------
AdventureShopBatch = class("AdventureShopBatchClass", Window)
    
app.load("client.adventure.cells.shop.adventure_shop_list_cell")

function AdventureShopBatch:ctor()
    self.super:ctor()
    self.roots = {}

    self.currentListView = nil
    self.buyCounts = 1 
    self.Text_buyCount = nil
    self.item_name = nil
    self.item_consumeCount = nil
    self.propInfo = nil
    self.Text_consumeCount = nil 
    self.Button_reduction = nil --减少按钮
    self.Button_add = nil --增加按钮
    self.click_time = nli
    self.item_id = nil 
    self.ShopBuyType = 1 --1 炸弹 2 矿工包 3 商店 4 VIP
    self.vip_node = nil
    -- Initialize adventure shop state machine.
    local function init_adventure_shop_terminal()
    	-- 确定购买
        local adventure_shop_batch_true_terminal = {
            _name = "adventure_shop_batch_true",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseBuyPropCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if tonumber(instance.item_id) == 303 then 
                            state_machine.excute("adventure_mine_manager_mine_update_bomb",0,0)
                        end
                        if zstring.tonumber(instance.ShopBuyType) == 4 then 
                            state_machine.excute("adventure_shop_prop_buy_list_refush",0,instance.vip_node)
                        end

                        if zstring.tonumber(instance.ShopBuyType) == 3 then 
                            state_machine.excute("adventure_shop_list_cell_buy_update",0,{node = instance.vip_node,buyNum = instance.buyCounts}) 
                        end
                        fwin:close(fwin:find("AdventureShopBatchClass"))
                        app.load("client.adventure.reward.AdventureTipReward")
                        local reward = getSceneReward(11)
                        if reward ~= nil then 
                            fwin:open(AdventureTipReward:new():init(reward), fwin._ui)
                        end
                        
                        local windows = fwin:find("AdventureMinePackageClass")
                        if windows ~= nil then 
                            state_machine.excute("adventure_mine_package_miners_package",0,0)
                        end
                    else

                        fwin:close(fwin:find("AdventureShopBatchClass"))
                    end
                end
                if params._datas.cell.ShopBuyType ~= 3 and params._datas.cell.ShopBuyType ~= 4 then
                    protocol_command.bomb_purchase.param_list = params._datas.cell.propInfo.shop_prop_instance .. "\r\n" ..params._datas.cell.buyCounts.. "\r\n" .. "0"
                    NetworkManager:register(protocol_command.bomb_purchase.code, nil, nil, nil, nil, responseBuyPropCallback, false, nil)
                else
                    protocol_command.prop_purchase.param_list = params._datas.cell.propInfo.shop_prop_instance .. "\r\n" ..params._datas.cell.buyCounts.. "\r\n" .. "0"
                    NetworkManager:register(protocol_command.prop_purchase.code, nil, nil, nil, nil, responseBuyPropCallback, false, nil)
                end
                 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --减少
        local adventure_shop_batch_reduction_terminal = {
            _name = "adventure_shop_batch_reduction",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            
                instance:onReductionBuyCounts()
                    
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --增加
        local adventure_shop_batch_add_terminal = {
            _name = "adventure_shop_batch_add",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onAddBuyCounts()
            
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }        

        -- state_machine.add(adventure_shop_batch_add_terminal)
        -- state_machine.add(adventure_shop_batch_reduction_terminal)
        state_machine.add(adventure_shop_batch_true_terminal)
        state_machine.init()
    end
    
    -- call func init adventure shop state machine.
    init_adventure_shop_terminal()
end

function AdventureShopBatch:init(info,shopType,vipnode)
    self.propInfo = info
    self.ShopBuyType = shopType
    self.vip_node = vipnode or nil
	return self
end

function AdventureShopBatch:onUpdate(dt)
    -- 长按升级按钮 自动升级
    if self.Button_reduction ~= nil and self.Button_reduction:isHighlighted() == true then
        self.click_time = self.click_time + dt
        if self.click_time > 0.2 then 
            self:onReductionBuyCounts()
            self.click_time = 0
        end
    end

    if self.Button_add ~= nil and self.Button_add:isHighlighted() == true then
        self.click_time = self.click_time + dt
        if self.click_time > 0.2 then 
            self.click_time = 0
            self:onAddBuyCounts()
        end 
    end
end

--减少数量
function AdventureShopBatch:onReductionBuyCounts()
    if zstring.tonumber(self.ShopBuyType) == 4 then 
        return
    end
    if self.buyCounts <= 1 then 
        return
    end
    self.buyCounts = self.buyCounts - 1
    self.Text_consumeCount:setString("".. self.buyCounts *  self.item_consumeCount)
    self.Text_buyCount:setString("" .. self.buyCounts)
end


function AdventureShopBatch:onAddBuyCounts()
    if zstring.tonumber(self.ShopBuyType) == 4 then 
        return
    end

    if self.buyCounts >= 100 then 
        return
    end
    self.buyCounts = self.buyCounts + 1

    self.Text_consumeCount:setString("".. self.buyCounts *  self.item_consumeCount)
    self.Text_buyCount:setString("" .. self.buyCounts)
end

function AdventureShopBatch:onEnterTransitionFinish()
	local csbAdventureShop = csb.createNode("shop/diamondshop/shop_piliang_buy.csb")
    local root = csbAdventureShop:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureShop)
    local Text_name  = ccui.Helper:seekWidgetByName(root, "Text_prop_name")
    self.Text_buyCount = ccui.Helper:seekWidgetByName(root, "Text_number_buy")
    self.Text_consumeCount = ccui.Helper:seekWidgetByName(root, "Text_num_xz")
    self.Text_buyCount:setString("1")
    self.item_consumeCount = tonumber(self.propInfo.original_cost)
    self.Text_consumeCount:setString("".. self.buyCounts *  self.item_consumeCount)
    Text_name:setString(self.propInfo.mould_name)
    self.item_id = tonumber(self.propInfo.shop_prop_instance)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
		func_string = [[fwin:close(fwin:find("AdventureShopBatchClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureShopBatchClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
    {
		terminal_name = "adventure_shop_batch_true",        
     	terminal_state = 0, 
        cell = self,
		isPressedActionEnabled = true
    }, 
    nil, 0)

    local function addTouchListener(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            self.click_time = 0
        elseif eventType == ccui.TouchEventType.moved then 
            self.isItemMove = true
        elseif eventType == ccui.TouchEventType.ended then 
            self:onAddBuyCounts()
        else 
        end
    end

    local function reductionTouchListener(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            self.click_time = 0
        elseif eventType == ccui.TouchEventType.moved then 
            self.isItemMove = true
        elseif eventType == ccui.TouchEventType.ended then 
            self:onReductionBuyCounts()
        else 
        end
    end

    self.Button_reduction = ccui.Helper:seekWidgetByName(root, "Button_reduction")
    self.Button_add = ccui.Helper:seekWidgetByName(root, "Button_add")
    self.Button_add:addTouchEventListener(addTouchListener)
    self.Button_reduction:addTouchEventListener(reductionTouchListener)

end

function AdventureShopBatch:onExit()

    state_machine.remove("adventure_shop_batch_reduction")
end