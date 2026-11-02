----------------------------------------------------------------------------------------------------
-- 说明：限时兑换活动选择兑换奖励界面
-------------------------------------------------------------------------------------------------------
ActivityVarietyShopForDrawSelectAward = class("ActivityVarietyShopForDrawSelectAwardClass", Window)
    
function ActivityVarietyShopForDrawSelectAward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.params = 0
    self.selectIndex = -1

    app.load("client.cells.ship.ship_head_cell")

    -- Initialize seven days activity for draw ship page state machine.
    local function init_activity_variety_shop_for_draw_select_award_terminal()
        -- -- 选择要领取的物品
        local activity_variety_shop_for_draw_select_award_select_terminal = {
            _name = "activity_variety_shop_for_draw_select_award_select",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.selectIndex = params._datas.selectIndex

                local but_bgImage = nil
                if terminal.page_name ~= nil then
                    but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
                    if but_bgImage ~= nil then
                        but_bgImage:setVisible(false)
                    end
                end
                terminal.page_name = params._datas.but_image
                but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
                if but_bgImage ~= nil then
                    but_bgImage:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- -- 领取物品
        local activity_variety_shop_for_draw_select_award_request_terminal = {
            _name = "activity_variety_shop_for_draw_select_award_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell.selectIndex < 0 then
                    TipDlg.drawTextDailog(_string_piece_info[304])
                    return
                end
				local index = cell.params._datas._index
				local function responseExchangeCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node[1] ~= nil and response.node[1].roots[1] ~= nil then
							response.node[1]:rewadDraw(response.node[2])              -- 刷新兑换列表界面
							state_machine.excute("activity_variety_shop_for_draw_select_award_close", 0, "")
						end	
                    end
                end
				if TipDlg.drawStorageTipo() == false then
					protocol_command.activity_superchange_exchange.param_list = cell.params._datas._cell.command_param_list.."\r\n"..(cell.selectIndex+1)
					NetworkManager:register(protocol_command.activity_superchange_exchange.code, nil, nil, nil, {cell.params._datas._cell,index}, responseExchangeCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- -- 关闭窗口
        local activity_variety_shop_for_draw_select_award_close_terminal = {
            _name = "activity_variety_shop_for_draw_select_award_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_variety_shop_for_draw_select_award_select_terminal)
        state_machine.add(activity_variety_shop_for_draw_select_award_request_terminal)
        state_machine.add(activity_variety_shop_for_draw_select_award_close_terminal)
        state_machine.init()
    end
    
    -- call func init seven days activity for draw ship state machine.
    init_activity_variety_shop_for_draw_select_award_terminal()
end


function ActivityVarietyShopForDrawSelectAward:onUpdateDraw()
	local root = self.roots[1]
	local count = self.params._datas._cell.maxcount
	for i = 1, count do    					--根据可选择数量显示选择框
        local rewardPad = nil
        -- if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		then
        --     rewardPad = ccui.Helper:seekWidgetByName(root, "Panel_2"..(i - 1))
        -- else
            rewardPad = ccui.Helper:seekWidgetByName(root, "Panel_1"..(i + 1))
        -- end
        rewardPad:setVisible(true)
    end
	
	local info = self.params._datas._cell
	for i, v in ipairs(info.get_info_arg) do   -- 绘制可选择的物品
		if i > 4 then
			return
		end
		local rewardPad = ccui.Helper:seekWidgetByName(root, "Panel_2"..(i - 1))
		if tonumber(v._type) == 1 then                        -- 类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备)
			local cell = propMoneyIcon:createCell()
			cell:init("1",v._count,nil)
			rewardPad:addChild(cell)
		elseif tonumber(v._type) == 2 then
			local cell = propMoneyIcon:createCell()
			cell:init("2",v._count,nil)
			rewardPad:addChild(cell)
		elseif tonumber(v._type) == 3 then
			local cell = propMoneyIcon:createCell()
			cell:init("3",v._count,nil)
			rewardPad:addChild(cell)
		elseif tonumber(v._type) == 4 then
			local cell = propMoneyIcon:createCell()
			cell:init("4", v._count, nil)
			rewardPad:addChild(cell)
		elseif tonumber(v._type) == 5 then
			local cell = propMoneyIcon:createCell()
			cell:init("5", v._count, nil)
			rewardPad:addChild(cell)
		elseif tonumber(v._type) == 6 then
			local cell = PropIconCell:createCell()
			cell:init(26, v._mould, v._count)
			rewardPad:addChild(cell)
		elseif tonumber(v._type) == 7 then
			local cell = EquipIconCell:createCell()
			cell:init(10, nil, v._mould, nil, nil, v._count)
			rewardPad:addChild(cell)
        elseif tonumber(v._type) == 71 then
            local propData = {v._type, v._mould, v._count, nil, v._silkBagId}
            local cell = self:addResourcesIconCell(propData)
            rewardPad:addChild(cell)
		end
	end
end

function ActivityVarietyShopForDrawSelectAward:addResourcesIconCell(propData)
    local cell = ResourcesIconCell:createCell()
    local rewardType = tonumber(propData[1])
    local mouldId = tonumber(propData[2])
    if 13 == rewardType then
        local extraTable = {}
        if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
            extraTable.shipStar = tonumber(propData[4])
        else
            extraTable.shipStar = 0
        end
        cell:init(rewardType, tonumber(propData[3]), mouldId, nil, nil, true, true, 1, extraTable)
    elseif 71 == rewardType then
        local property_info = dms.string(dms["ship_silk_bag_mould"],mouldId,ship_silk_bag_mould.base_property)
        local level = 0
        local silkBagId = propData[5]

        if silkBagId and silkBagId ~= -1 then
            for k, v in pairs(_ED.silkbag_pack_info) do
                if tonumber(silkbagId) == tonumber(v.id) then
                    level = v.level
                    property_info = v.addBaseProperty
                    break
                end
            end
        end
        
        local basePropertyList = {}
        if nil ~= property_info then
            local add_property_info = zstring.split(property_info,"|")
            for i = 1,table.nums(add_property_info) do
                local add_property_per = zstring.split(add_property_info[i],",")
                if nil ~= add_property_per then
                    local a = tipStringInfo_rescue_silkbag_property["0"]
                    local baseProperty ={}
                    baseProperty.property_name = tipStringInfo_rescue_silkbag_property[tostring(add_property_per[1])]
                    baseProperty.property_value = add_property_per[2]
                    basePropertyList[i] = baseProperty
                end
            end
        end
        cell:init(rewardType, tonumber(propData[3]), mouldId, nil, nil, true, true, 0, {basePropertyList, level})
    else
        cell:init(rewardType, tonumber(propData[3]), mouldId, nil, nil, true ,true, 1)
    end
    return cell
end

function ActivityVarietyShopForDrawSelectAward:onEnterTransitionFinish()

    local csbActivityVarietyShopForDrawSelectAward = csb.createNode("utils/select_award.csb")
    self:addChild(csbActivityVarietyShopForDrawSelectAward)

    local root = csbActivityVarietyShopForDrawSelectAward:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("utils/select_award.csb")
    table.insert(self.actions, action)
    csbActivityVarietyShopForDrawSelectAward:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:play("window_open", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "close" then
            fwin:close(self)
        end
        
    end)
    for i = 1, 4 do          ---先隐藏4个选择位置
        local rewardPad = nil
        -- if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		then
        --     rewardPad = ccui.Helper:seekWidgetByName(root, "Panel_2"..(i - 1))
        -- else
            rewardPad = ccui.Helper:seekWidgetByName(root, "Panel_1"..(i + 1))
        -- end
        rewardPad:setVisible(false)
    end
	
	
	self:onUpdateDraw()
    
	local count = self.params._datas._cell.maxcount
    for i = 1, count do          -- 根据物品数量添加响应
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_xy_0"..i),       nil, 
        {
            terminal_name = "activity_variety_shop_for_draw_select_award_select",     
            but_image = "Image_"..(37 + i),
            terminal_state = 0, 
            cell = self,
            selectIndex = i - 1,
            isPressedActionEnabled = false
        }, 
        nil, 0)
    end

   -- 领取奖励的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_10"),       nil, 
    {
        terminal_name = "activity_variety_shop_for_draw_select_award_request",     
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 关闭窗口的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_11"),       nil, 
    {
        terminal_name = "activity_variety_shop_for_draw_select_award_close",     
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function ActivityVarietyShopForDrawSelectAward:onExit()
    state_machine.remove("activity_variety_shop_for_draw_select_award_select")
    state_machine.remove("activity_variety_shop_for_draw_select_award_request")
    state_machine.remove("activity_variety_shop_for_draw_select_award_close")
end

function ActivityVarietyShopForDrawSelectAward:init(params)
    self.params = params
    return self
end

function ActivityVarietyShopForDrawSelectAward:createCell()
    local cell = ActivityVarietyShopForDrawSelectAward:new()
    cell:registerOnNodeEvent(cell)
    return cell
end