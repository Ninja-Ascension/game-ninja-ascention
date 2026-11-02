----------------------------------------------------------------------------------------------------
-- 说明：矿山瓦片
----------------------------------------------------------------------------------------------------
AdventureMineMineralBagCell = class("AdventureMineMineralBagCellClass", Window)

function AdventureMineMineralBagCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.parent = nil
	self.tileX = 0
	self.tileY = 0
	self.tileType = 0
	self.propid = nil
	self.exampleid = 0
	self.indexs = 0
	self.Button_open1 = nil 
	self.Button_open5 = nil 
	self.Button_buy = nil
	self.batch_item_name = nil
	self.batch_item_consumeCount = nil
	-- 显示初级矿工包的标签背景
	self.image = nil
	-- 显示初级矿工包的标签
 	self.text = nil
 	-- 显示矿工包或矿石包标签
 	self.text_name = nil
 	-- 判定当前是否为初级矿工包
 	self.isminer = false
	app.load("client.adventure.cells.prop.adventure_new_prop_small_icon_cell")
	-- Initialize adventure mine tile cell state machine.
	local function init_adventure_mine_tile_cell_terminal()
		-- 开一个
    	local adventure_mine_mineral_bag_open_terminal = {
            _name = "adventure_mine_mineral_bag_open",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				if tonumber(cell.indexs) ~= 0 then
					local function responseUsePropCallback(response)
						 if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then  --网络连接判断
							cell:updateDraw()
							state_machine.excute("adventure_mine_manager_update_basics", 0, nil)
							if params._datas.cell.isminer == false then
								app.load("client.adventure.reward.AdventureTipReward")
								fwin:open(AdventureTipReward:new():init(getSceneReward(4)), fwin._ui)
							end
							local shopWindows = fwin:find("AdventureMineWorkshopClass")
							if shopWindows ~= nil then 
								state_machine.excute("adventure_mine_workshop_update_listview", 0, "adventure_mine_workshop_update_listview.")
							end
						end
					end
					
					protocol_command.prop_use.param_list = cell.exampleid.."\r\n" .. 1
					NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, cell, responseUsePropCallback,false, nil)
				else
					local strs = _string_piece_info[376]
					local str_s = string.gsub(strs,"x",dms.atos(cell.mould_data, prop_mould.prop_name))
					TipDlg.drawTextDailog(str_s)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 开五个
    	local adventure_mine_mineral_bag_open_five_terminal = {
            _name = "adventure_mine_mineral_bag_open_five",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				if tonumber(cell.indexs) ~= 0 and tonumber(cell.indexs) >= 5 then
					local function responseUsePropCallback(response)
						 if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then  --网络连接判断
							cell:updateDraw()
							state_machine.excute("adventure_mine_manager_update_basics", 0, nil)
							if params._datas.cell.isminer == false then
								app.load("client.adventure.reward.AdventureTipReward")
								local reward = getSceneReward(4)
								if reward ~= nil then 
									fwin:open(AdventureTipReward:new():init(reward), fwin._ui)
								end
								
							end
							local shopWindows = fwin:find("AdventureMineWorkshopClass")
							if shopWindows ~= nil then 
								state_machine.excute("adventure_mine_workshop_update_listview", 0, "adventure_mine_workshop_update_listview.")
							end
						end
					end
					protocol_command.prop_use.param_list = cell.exampleid.."\r\n" .. 5
					NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, cell, responseUsePropCallback,false, nil)
				else
					local strs = _string_piece_info[376]
					local str_s = string.gsub(strs,"x",dms.atos(cell.mould_data, prop_mould.prop_name))
					TipDlg.drawTextDailog(str_s)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 批量购买
    	local adventure_mine_mineral_bag_open_batch_buy_terminal = {
            _name = "adventure_mine_mineral_bag_open_batch_buy",
            _init = function (terminal)
            	app.load("client.adventure.shop.AdventureShopBatch")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(AdventureShopBatch:new():init({mould_name = params._datas.cell.batch_item_name ,original_cost = params._datas.cell.batch_item_consumeCount ,shop_prop_instance = tonumber(params._datas.cell.propid)},2), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_mine_mineral_bag_open_terminal)
		state_machine.add(adventure_mine_mineral_bag_open_five_terminal)
		state_machine.add(adventure_mine_mineral_bag_open_batch_buy_terminal)
        state_machine.init()
	end

	-- call func init adventure mine tile cell state machine.
	init_adventure_mine_tile_cell_terminal()
end

function AdventureMineMineralBagCell:onEnterTransitionFinish()

end

function AdventureMineMineralBagCell:updateDraw()
	local root = self.roots[1]
	local propNumber = 0
	for i, v in pairs(_ED.user_prop) do
		if zstring.tonumber(v.user_prop_template) == tonumber(self.propid) then
				propNumber = v.prop_number
				self.exampleid = zstring.tonumber(v.user_prop_id)
			break
		end
	end
	self.indexs = propNumber
	local cell = adventureNewSmallPropIconCell:createCell()
	cell:init(0, {mould_id = tonumber(self.propid)} ,propNumber,nil,0)
	ccui.Helper:seekWidgetByName(root, "Panel_3"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_3"):addChild(cell)
	local itemName = dms.atos(self.mould_data, prop_mould.prop_name)
	self.text_name:setString(itemName)
	local get_endurace = dms.atoi(self.mould_data, prop_mould.use_of_endurance)

    self.batch_item_name = itemName
    local config = zstring.split(dms.string(dms["pirates_config"], 325, pirates_config.param), "|")
 
    local ids_array = zstring.split(config[1], ",")
    local index = -1
    for k,v in pairs(ids_array) do
    	if tonumber(v) == tonumber(self.propid) then 
    		index = k
    		break
    	end
    end
    if index ~= -1  then 
    	local consume_array = zstring.split(config[2], ",")
    	self.batch_item_consumeCount = tonumber(consume_array[index])
    else
    	self.batch_item_consumeCount = 0
    end
	-- 加耐力物品不弹框
	local isBuy = false
	if get_endurace > 0	then
		self.isminer = true
		self.image:setVisible(true)
		self.text:setVisible(true)
		self.text:setString(_ED.user_info.endurance .. "/" .. _ED.user_info.max_endurance)

	else
		self.isminer = false
		self.image:setVisible(false)
		self.text:setVisible(false)
	
	end
	self.Button_open1:setVisible(tonumber(propNumber) > 0)
	self.Button_open5:setVisible(tonumber(propNumber) > 0)
	self.Button_buy:setVisible(tonumber(propNumber) <= 0)
	ccui.Helper:seekWidgetByName(root, "Text_description"):setString(dms.atos(self.mould_data, prop_mould.remarks))
end

function AdventureMineMineralBagCell:onInit()
	local csbAdventureMineTileCell = csb.createNode("list/list_kuanggongbao.csb")
 	local root = csbAdventureMineTileCell:getChildByName("root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
 	self:addChild(root)
 	self.text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
 	self.image = ccui.Helper:seekWidgetByName(root, "Image_2")
 	self.text =  ccui.Helper:seekWidgetByName(root, "Text_3")
	self:setContentSize(ccui.Helper:seekWidgetByName(root, "Panel_2"):getContentSize())
	self.Button_open1 = ccui.Helper:seekWidgetByName(root, "Button_open_1") 
	self.Button_open5 = ccui.Helper:seekWidgetByName(root, "Button_open_5") 
	self.Button_buy = ccui.Helper:seekWidgetByName(root, "Button_buy_1")
	
 	self:updateDraw()

	--开一个
	fwin:addTouchEventListener(self.Button_open1, nil, 
    {
        terminal_name = "adventure_mine_mineral_bag_open", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	--开五个
	fwin:addTouchEventListener(self.Button_open5, nil, 
    {
        terminal_name = "adventure_mine_mineral_bag_open_five", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --打开购买
	fwin:addTouchEventListener(self.Button_buy, nil, 
    {
        terminal_name = "adventure_mine_mineral_bag_open_batch_buy", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureMineMineralBagCell:onExit()
	state_machine.remove("adventure_mine_mineral_bag_open_five")
	state_machine.remove("adventure_mine_mineral_bag_open")
	state_machine.remove("adventure_mine_mineral_bag_open_batch_buy")
end

function AdventureMineMineralBagCell:init(propid)
	self.propid = propid
	self.mould_data = dms.element(dms["prop_mould"], propid)
	self:onInit()
	return self
end

function AdventureMineMineralBagCell:createCell()
	local cell = AdventureMineMineralBagCell:new()
	-- cell:registerOnNodeEvent(cell)
	return cell
end

