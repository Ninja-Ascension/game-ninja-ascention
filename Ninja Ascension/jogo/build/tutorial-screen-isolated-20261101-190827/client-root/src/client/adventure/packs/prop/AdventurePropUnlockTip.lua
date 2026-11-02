-- ----------------------------------------------------------------------------------------------------
-- 说明：道具仓库解锁提示界面
-------------------------------------------------------------------------------------------------------
AdventurePropUnlockTip = class("AdventurePropUnlockTipClass", Window)
    
function AdventurePropUnlockTip:ctor()
    self.super:ctor()
    self.roots = {}
    -- Initialize adventure battle reward state machine.
    local function init_adventure_prop_unlock_tip_terminal()
		local adventure_prop_unlock_tip_unlock_terminal = {
            _name = "adventure_prop_unlock_tip_unlock",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				local function responseBattleInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("adventure_prop_storage_update_prop", 0, params)
						fwin:close(fwin:find("AdventurePropUnlockTipClass"))
					end
				end
				protocol_command.basic_consumption.param_list = "6\r\n0,0"
				NetworkManager:register(protocol_command.basic_consumption.code, nil, nil, nil, nil, responseBattleInitCallback, true, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_prop_unlock_tip_unlock_terminal)
        state_machine.init()
    end
    
    -- call func init adventure battle reward state machine.
    init_adventure_prop_unlock_tip_terminal()
end

function AdventurePropUnlockTip:init()
	return self
end

function AdventurePropUnlockTip:onUpdateDraw()
	local root = self.roots[1]
	local propBagExtend	= dms.searchs(dms["prop_bag_extend"], prop_bag_extend.bag_size, zstring.tonumber(_ED.precious_bag_open))
	
	local indexs = zstring.tonumber(propBagExtend[1][1])
	local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
	local strs = _string_piece_info[390]
	local str_s = string.gsub(strs,"x",dms.int(dms["prop_bag_extend"], indexs+1, prop_bag_extend.bag_size)-zstring.tonumber(_ED.precious_bag_open))
	local contt = dms.int(dms["prop_bag_extend"], indexs+1, prop_bag_extend.bag_size)
	if contt == nil then 
		return
	end
	Text_2:setString(str_s)
	local _width = 0
	local _nCount = 0
	
	local ListView_huode = ccui.Helper:seekWidgetByName(root, "ListView_prop")
	ListView_huode:removeAllItems()
	if dms.int(dms["prop_bag_extend"], indexs, prop_bag_extend.need_prop1) > 0 and dms.int(dms["prop_bag_extend"], indexs, prop_bag_extend.need_prop1_count) then
		local cell = adventureNewSmallPropIconCell:createCell()
		cell:init(0, {mould_id = dms.int(dms["prop_bag_extend"], indexs, prop_bag_extend.need_prop1)} ,
			 "" .. getResourceValueToStringForAdventure(dms.int(dms["prop_bag_extend"], indexs, prop_bag_extend.need_prop1_count)), 
			 nil, 0, 0, nil, {show_quantity = true})

		--interfaceType, prop, numbers, drawType,getprop,isdrawNumber,parent
		ListView_huode:addChild(cell)
		_width = cell:getContentSize().width
		_nCount = _nCount + 1
	end
	
	if dms.int(dms["prop_bag_extend"], indexs, prop_bag_extend.need_prop2) > 0 and dms.int(dms["prop_bag_extend"], indexs, prop_bag_extend.need_prop2_count) then
		local cell = adventureNewSmallPropIconCell:createCell()
		cell:init(0, {mould_id = dms.int(dms["prop_bag_extend"], indexs, prop_bag_extend.need_prop2)} , "" .. getResourceValueToStringForAdventure(dms.int(dms["prop_bag_extend"], indexs, prop_bag_extend.need_prop2_count)), 
			nil, 0, 0, nil, {show_quantity = true})
		ListView_huode:addChild(cell)
		_width = cell:getContentSize().width
		_nCount = _nCount + 1
	end
	
	if dms.int(dms["prop_bag_extend"], indexs, prop_bag_extend.need_prop3) > 0 and dms.int(dms["prop_bag_extend"], indexs, prop_bag_extend.need_prop3_count) then
		local cell = adventureNewSmallPropIconCell:createCell()
		cell:init(0, {mould_id = dms.int(dms["prop_bag_extend"], indexs, prop_bag_extend.need_prop3)} , "" .. getResourceValueToStringForAdventure(dms.int(dms["prop_bag_extend"], indexs, prop_bag_extend.need_prop3_count)), 
			nil, 0, 0, nil, {show_quantity = true})
		ListView_huode:addChild(cell)
		_width = cell:getContentSize().width
		_nCount = _nCount + 1
	end
	
	if dms.int(dms["prop_bag_extend"], indexs, prop_bag_extend.need_prop4) > 0 and dms.int(dms["prop_bag_extend"], indexs, prop_bag_extend.need_prop4_count) then
		local cell = adventureNewSmallPropIconCell:createCell()
		cell:init(0, {mould_id = dms.int(dms["prop_bag_extend"], indexs, prop_bag_extend.need_prop4)} , "" .. getResourceValueToStringForAdventure(dms.int(dms["prop_bag_extend"], indexs, prop_bag_extend.need_prop3_count)), 
			nil, 0, 0, nil, {show_quantity = true})
		ListView_huode:addChild(cell)
		_width = cell:getContentSize().width
		_nCount = _nCount + 1
	end
	
	
	ListView_huode:requestRefreshView()		
	if ListView_huode._x == nil then
		ListView_huode._x = ListView_huode:getPositionX()
	end
	ListView_huode:setPositionX(ListView_huode._x - (_width + ListView_huode:getItemsMargin()) * (_nCount - 1) / 2)
end

function AdventurePropUnlockTip:onEnterTransitionFinish()
	local csbAdventureBattleReward = csb.createNode("duplicate/beibao_unlock.csb")
    local root = csbAdventureBattleReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBattleReward)
	self:onUpdateDraw()
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventurePropUnlockTipClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventurePropUnlockTipClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	
	-- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
    {
        terminal_name = "adventure_prop_unlock_tip_unlock",   
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventurePropUnlockTip:onExit()

end