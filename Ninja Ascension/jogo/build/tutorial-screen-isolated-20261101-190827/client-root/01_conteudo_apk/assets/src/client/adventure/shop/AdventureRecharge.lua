-- ----------------------------------------------------------------------------------------------------
-- 说明：商店充值
-------------------------------------------------------------------------------------------------------
AdventureRecharge = class("AdventureRechargeClass", Window)
    
function AdventureRecharge:ctor()
    self.super:ctor()
    self.roots = {}
	
	self.nextSceneID = 0
	self.nextTypes = nil
	self._UpGrade = {}
	self.uiCell = nil
	--- 购买成功后需要刷新的节点
	self.updateNode = nil
	
	app.load("client.cells.recharge.recharge_list_cell")
    -- Initialize adventure recharge state machine.
    local function init_adventure_recharge_terminal()
        local adventure_recharge_back_terminal = {
            _name = "adventure_recharge_back",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance.updateNode ~= nil then 
            		--有更新节点,需要更新
            		state_machine.excute("adventure_activity_cumulative_buy_diamond_update", 0, instance.updateNode)
            	end
            	fwin:close(fwin:find("AdventureRechargeClass"))    
            	NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(adventure_recharge_back_terminal)
        state_machine.init()
    end
    
    -- call func init adventure recharge state machine.
    init_adventure_recharge_terminal()
end

function AdventureRecharge:init(updateCell)
	self.updateNode = updateCell
	return self
end


function AdventureRecharge:onUpdateDraw()
	local root = self.roots[1]
	
end	

function AdventureRecharge:loading_month()
	if AdventureRecharge.cacheListView == nil then
		return 
	end
	if __lua_project_id == __lua_project_adventure and zstring.tonumber(_ED.server_review) ~= 0 then 

		return
	end
	if AdventureRecharge.drawMonth[AdventureRecharge.monthIndex] ~= nil then
		local rechargeList = RechargeListCell:createCell()
		rechargeList:init(1,AdventureRecharge.drawMonth[AdventureRecharge.monthIndex],0)
		AdventureRecharge.cacheListView:addChild(rechargeList)
		AdventureRecharge.cacheListView:requestRefreshView()
	end	
	AdventureRecharge.monthIndex = AdventureRecharge.monthIndex + 1
end

function AdventureRecharge:loading_recharge()
	if AdventureRecharge.cacheListView == nil then
		return 
	end
	
	if AdventureRecharge.drawTypes[AdventureRecharge.rechargeIndex] ~= nil then
		local rechargeList = RechargeListCell:createCell()
		rechargeList:init(2,AdventureRecharge.drawTypes[AdventureRecharge.rechargeIndex],0)
		AdventureRecharge.cacheListView:addChild(rechargeList)
		AdventureRecharge.cacheListView:requestRefreshView()
	end	
	AdventureRecharge.rechargeIndex = AdventureRecharge.rechargeIndex + 1
end

function AdventureRecharge:onEnterTransitionFinish()
	local csbAdventureRecharge = csb.createNode("shop/diamondshop/shop_buy_diamond.csb")
    local root = csbAdventureRecharge:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureRecharge)
	
	self:onUpdateDraw()
	local myListView = ccui.Helper:seekWidgetByName(root, "ListView_daoju")
	local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
	local _drawTypes = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 0)
	local rechargeCount = table.getn(_drawTypes)
	local monthCount = 0
	if _drawMonth ~= nil then
		monthCount = table.getn(_drawMonth)
	end
	if #myListView:getItems() > 0 then
		myListView:removeAllItems()
	end
	
	AdventureRecharge.monthIndex = 1
	AdventureRecharge.rechargeIndex = 1
	AdventureRecharge.cacheListView = myListView
	AdventureRecharge.drawMonth = _drawMonth
	AdventureRecharge.drawTypes = _drawTypes
	
	if __lua_project_id == __lua_project_adventure then 
		local hide_numbers = nil
		if _shop_hide_numbers ~= nil then 
			hide_numbers = zstring.split("".._shop_hide_numbers,",")
		end

		if monthCount ~= 0 then
			for i = 1 , monthCount do
				self.loading_month()
			end
		end	
		if rechargeCount ~= 0 then
			for i = 1 , rechargeCount do
				if hide_numbers ~= nil then 
					local isFind = false
					for k,v in pairs(hide_numbers) do
						if tonumber(v) == i then 
							isFind = true
							AdventureRecharge.rechargeIndex = AdventureRecharge.rechargeIndex + 1
							break
						end
					end
					if isFind == false then 
						self.loading_recharge()	
					end
				else
					self.loading_recharge()
				end
			end
		end
	else
		if rechargeCount ~= 0 then
			for i = 1 , rechargeCount do
				-- local rechargeList = RechargeListCell:createCell()
				-- rechargeList:init(2,_drawTypes[i],self.nextSceneID)
				-- myListView:addChild(rechargeList)
				self.loading_recharge()
			end
		end
	end
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
		terminal_name = "adventure_recharge_back",
		terminal_state = 0, 
		cell = self,
		isPressedActionEnabled = true
    }, 
    nil, 2) 
end

function AdventureRecharge:onExit()
    
end