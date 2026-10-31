--[[ ----------------------------------------------------------------------------
-- 一键升级界面
--]] ----------------------------------------------------------------------------
CombinationCardUpgrade = class("CombinationCardUpgradeClass", Window)

-- 打开窗口
local combination_card_upgrade_window_open_terminal = {
    _name = "combination_card_upgrade_window_open",
    _init = function(terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("CombinationCardUpgradeClass") then
            fwin:open(CombinationCardUpgrade:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local combination_card_upgrade_window_close_terminal = {
    _name = "combination_card_upgrade_window_close",
    _init = function(terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("CombinationCardUpgradeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(combination_card_upgrade_window_open_terminal)
state_machine.add(combination_card_upgrade_window_close_terminal)
state_machine.init()

-- 构造器
function CombinationCardUpgrade:ctor()
    self.super:ctor()

    self.roots = {}

    self.allPropTypeMap = {}            -- 所有消耗道具的类型
    self.allLevelConsumePropMap = {}    -- 所有等级消耗道具的内容
    self.propCellMap = {}               -- 所有绘制出的cell

    self.last_solt_id = 0               -- 卡槽ID
    self.curMaxLevel = 0                -- 当前选择升至最大等级
    self.curChooseLevel = 0             -- 当前等级
    self.initLevel = 0                  -- 初始最小等级
    self.disLevel = 0                   -- 等级差值

    app.load("client.l_digital.cultivate.combinationCard.CombinationCardUpgradeCell")

	local function init_combination_card_upgrade_terminal()
        -- 打开角色创建窗口
        local combination_card_upgrade_open_terminal = {
            _name = "combination_card_upgrade_open",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭角色创建窗口
        local combination_card_upgrade_close_terminal = {
            _name = "combination_card_upgrade_close",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 关闭角色创建窗口
                state_machine.excute("combination_card_upgrade_window_close", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示窗口
        local combination_card_upgrade_show_terminal = {
            _name = "combination_card_upgrade_show",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 显示窗口
                if nil ~= instance then
                    instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏窗口
        local combination_card_upgrade_hide_terminal = {
            _name = "combination_card_upgrade_hide",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 隐藏窗口
                if nil ~= instance then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 对等级升级进行"+""-"操作
        local combination_card_upgrade_change_times_terminal = {
            _name = "combination_card_upgrade_change_times",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 对等级升级进行"+""-"操作
                if nil ~= instance then
                    local changeTimes = params._datas.changeTimes
                    local curLevel = instance.curChooseLevel + changeTimes
                    if curLevel < (instance.initLevel + 1) or curLevel > instance.curMaxLevel then
                        return 
                    end
                    state_machine.excute("combination_card_upgrade_update_level_consume", 0, curLevel)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新目标等级
        local combination_card_upgrade_slider_update_terminal = {
            _name = "combination_card_upgrade_slider_update",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 更新目标等级
                if nil ~= instance then
                    local subLevel = instance.curMaxLevel - instance.curChooseLevel
                    local curLevel = math.ceil(subLevel * params / 100)
                    state_machine.excute("combination_card_upgrade_update_level_consume", 0, curLevel)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 绘制升级消耗道具内容
        local combination_card_upgrade_update_level_consume_terminal = {
            _name = "combination_card_upgrade_update_level_consume",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 绘制升级消耗道具内容
                if nil ~= instance then
                    local curLevel = params
                    instance:setSelectNum(curLevel)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求一键升级
        local combination_card_upgrade_request_upgrade_terminal = {
            _name = "combination_card_upgrade_request_upgrade",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 请求一键升级
                if nil ~= instance then
                    
                    local soltId = instance.last_solt_id
                    local soltInfo = CombinationCardHandle.getOneSoltInfoById(soltId)
                    local level = instance.curChooseLevel
                    local groupId = soltInfo.groupId

                    local cardId = instance.ship_mould_id
                    local shipId = soltInfo.shipId
                    local mouldId = 0
                    if _ED.user_ship[""..shipId] then
                        mouldId = _ED.user_ship[""..shipId].ship_template_id
                    end

                    local function responseUpLevelCallBack( response )
                        
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            TipDlg.drawTextDailog(tipStringInfo_combination_card_tip[2])
                            state_machine.excute("combination_card_unlock_window_refresh",0,"")
                            smFightingChange()
                            state_machine.excute("combination_card_upgrade_close", 0, nil)
                        end
                    end
                    protocol_command.combine_ship_one_key_update_slot.param_list = ""..cardId.."\r\n"..(soltId - 1).."\r\n"..mouldId.."\r\n"..level.."\r\n"..groupId
                    NetworkManager:register(protocol_command.combine_ship_one_key_update_slot.code, nil, nil, nil, instance, responseUpLevelCallBack, false, nil)
				
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 滑动进度条滚动刷新
        local combination_card_upgrade_slider_update_level_consume_terminal = {
            _name = "combination_card_upgrade_slider_update_level_consume",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 绘制升级消耗道具内容
                if nil ~= instance then
                    local select_num = math.ceil(tonumber(params[1]) * (instance.curMaxLevel - instance.initLevel) / 100)
                    if select_num <= 0 then
                        select_num = 1
                    end
                    instance:setSelectNum(instance.initLevel + select_num)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(combination_card_upgrade_open_terminal)
        state_machine.add(combination_card_upgrade_close_terminal)
        state_machine.add(combination_card_upgrade_show_terminal)
        state_machine.add(combination_card_upgrade_hide_terminal)
        state_machine.add(combination_card_upgrade_change_times_terminal)
        state_machine.add(combination_card_upgrade_slider_update_terminal)
        state_machine.add(combination_card_upgrade_update_level_consume_terminal)
        state_machine.add(combination_card_upgrade_request_upgrade_terminal)
        state_machine.add(combination_card_upgrade_slider_update_level_consume_terminal)
		
        state_machine.init()
    end
    -- call func init state machine.
    init_combination_card_upgrade_terminal()

end

-- 对消耗道具进行排序
function CombinationCardUpgrade:getSortAllPropType(propTypeMap)
    local allPropTypeMap = {}
    local otherTypeInfo = {}
    local propTypeInfo = {}
    for k, v in pairs(propTypeMap) do
        local propInfo = zstring.split(k, ",", tonumber)
        local propType = propInfo[1]
        local propID = propInfo[2]
        if propType ~= 6 then
            table.insert(otherTypeInfo, k)
        else
            local sortID = dms.int(dms["prop_mould"], propID, prop_mould.trace_scene)
            table.insert(propTypeInfo, {propString = k, sortID = sortID})
        end
    end

    local function sortPropFunc(a, b)
        return a.sortID < b.sortID
    end
    table.sort(propTypeInfo, sortPropFunc)

    for i, v in ipairs(otherTypeInfo) do
        table.insert(allPropTypeMap, v)
    end

    for i, v in ipairs(propTypeInfo) do
        table.insert(allPropTypeMap, v.propString)
    end

    return allPropTypeMap
end

function CombinationCardUpgrade:getPropNums(propInfo)
    local havePropNum = 0
    if propInfo[1] == 1 then
        havePropNum = tonumber(_ED.user_info.user_silver)
    elseif propInfo[1] == 2 then
        havePropNum = tonumber(_ED.user_info.user_gold)
    elseif propInfo[1] == 6 then
        havePropNum = tonumber(getPropAllCountByMouldId(propInfo[2]))
    end

    return havePropNum
end

--self.allLevelConsumePropMap : 每级对应的消耗内容
--self.allPropTypeMap : 所有的消耗种类
-- 初始化消耗道具数据
function CombinationCardUpgrade:initConsumePropData()
    -- 获取玩家当前卡槽的数据
    local soltInfoPer = CombinationCardHandle.getOneSoltInfoById(self.last_solt_id)
    -- 存放道具类型map
    local tempTypeMap = {}
    -- 道具是否足够升级
    local propIsEnough = true
    local groupID = soltInfoPer.groupId
    local slotClass = soltInfoPer.slotClass
    -- 当前等级
    local curLevel = soltInfoPer.slotLevel
    self.curChooseLevel = curLevel + 1
    self.initLevel = curLevel
    -- 该卡槽的满级
    local allDatasInfo = CombinationCardHandle.getAllDatasByGroupID(groupID)

    for i, data in ipairs(allDatasInfo) do
        local consumePropInfo = CombinationCardHandle.getUpgradeConsumePropByData(data, slotClass)
        for j, propData in ipairs(consumePropInfo) do
			local propTypeString = propData[1] .. "," .. propData[2] .. "," .. 0
            if not tempTypeMap[propTypeString] then
                tempTypeMap[propTypeString] = true
            end
        end

        if i >= curLevel and propIsEnough == true then
			self.allLevelConsumePropMap[i] = self.allLevelConsumePropMap[i] or {}
			self.allLevelConsumePropMap[i + 1] = clone(self.allLevelConsumePropMap[i]) or {}
            for k, propInfo in ipairs(consumePropInfo) do
                local propCost = propInfo[3]
                propInfo[3] = 0
				local propString = propInfo[1] .. "," .. propInfo[2] .. "," ..propInfo[3]
                self.allLevelConsumePropMap[i][propString] = self.allLevelConsumePropMap[i][propString] or 0

                local havePropNum = self:getPropNums(propInfo)
                local curNeedNum = self.allLevelConsumePropMap[i][propString] + propCost
                if havePropNum >= curNeedNum then
                    self.allLevelConsumePropMap[i + 1][propString] = curNeedNum
                else
                    -- 当前可升至最大等级
                    self.curMaxLevel = i
					self.allLevelConsumePropMap[i + 1] = nil
                    propIsEnough = false
                    break
                end
            end
        end
    end

    self.curMaxLevel = self.curMaxLevel == 0 and #allDatasInfo or self.curMaxLevel
    self.disLevel = self.curMaxLevel - self.initLevel
    self.allPropTypeMap = self:getSortAllPropType(tempTypeMap)
	-- debug.print_r(self.allLevelConsumePropMap, "===self.allLevelConsumePropMap")
	-- debug.print_r(self.allPropTypeMap, "===self.allPropTypeMap")
	-- print(self.curMaxLevel, "===self.curMaxLevel")
end

function CombinationCardUpgrade:setSelectNum(select_num)
    self.curChooseLevel = select_num
    -- 修改目标等级显示
    self:updateDrawLevel()
    -- 刷新消耗道具的滚动容器
    self:updateDrawScrollView()
end

function CombinationCardUpgrade:initDrawPropScrollView()
    local nodeList = {}
    for _, v in ipairs(self.allPropTypeMap) do
        local cell = state_machine.excute("combination_card_upgrade_cell_create", 0, {propString = v, costNum = 0})
        self.propCellMap[v] = cell
        table.insert(nodeList, cell)
    end

    addNodeToScrollView({targetScrollView = self.ScrollView_icon, nodeList = nodeList, columns = 3})
end

-- 绘制目标等级进度
function CombinationCardUpgrade:updateDrawLevel()
    self.Text_yjsj_1_0:setString(self.curChooseLevel .. "/" .. self.curMaxLevel)
    local addLevel = self.curChooseLevel - self.initLevel
    self.Slider_number:setPercent(addLevel / self.disLevel * 100)
end

function CombinationCardUpgrade:updateDrawScrollView()
    local curConsumeProp = self.allLevelConsumePropMap[self.curChooseLevel]

    -- 先将所有的道具设为初始状态
    local children = self.ScrollView_icon:getChildren()
    for i, v in ipairs(children) do
        v:updateDrawCostNums(0)
        v:updateChoose(false)
    end

    -- 如果为消耗道具，则进行对应操作
    for i, v in pairs(curConsumeProp) do
        -- 设置消耗道具数量
        self.propCellMap[i]:updateDrawCostNums(v)
        -- 设置勾选状态
        if tonumber(v) > 0 then
            self.propCellMap[i]:updateChoose(true)
        end
    end
end

function CombinationCardUpgrade:onUpdate(dt)
    
end

-- 对象初始化
function CombinationCardUpgrade:init(params)
    self.ship_mould_id = params[1]
    self.last_solt_id = params[2]
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CombinationCardUpgrade:onInit(params)
    self:initConsumePropData()
end

function CombinationCardUpgrade:onEnterTransitionFinish()
    local csbNode = csb.createNode("cultivate/Combination_card/Combination_card_upgrade.csb")
    local root = csbNode:getChildByName("root")
    self:addChild(csbNode)
    table.insert(self.roots, root)

    self:drawBtns()
    self:onUpdateDraw()
end


function CombinationCardUpgrade:drawBtns()
    local root = self.roots[1]

    -- 加一等级
    self.Button_add = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"), nil,
	{
		terminal_name = "combination_card_upgrade_change_times",
		terminal_state = 0,
		isPressedActionEnabled = true,
        changeTimes = 1
	}, nil, 0)	
    
    -- 减一等级
    self.Button_reduce = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reduce"), nil,
	{
		terminal_name = "combination_card_upgrade_change_times",
		terminal_state = 0,
		isPressedActionEnabled = true,
        changeTimes = -1
	}, nil, 0)	

    -- 取消按钮
    self.Button_Cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_Cancel"), nil,
	{
		terminal_name = "combination_card_upgrade_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

    -- 确定按钮
    self.Button_confirm = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_confirm"), nil,
	{
		terminal_name = "combination_card_upgrade_request_upgrade",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

    -- 关闭按钮
    self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "combination_card_upgrade_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
end

function CombinationCardUpgrade:onUpdateDraw()
    local root = self.roots[1]
    -- 目标等级文本
    self.Text_yjsj_1_0 = ccui.Helper:seekWidgetByName(root, "Text_yjsj_1_0")

    -- 滑动条
    self.Slider_number = ccui.Helper:seekWidgetByName(root, "Slider_number")

    -- 滑动容器
    self.ScrollView_icon = ccui.Helper:seekWidgetByName(root, "ScrollView_icon")

    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("combination_card_upgrade_slider_update_level_consume", 0, {sender:getPercent()})
        end
    end
    self.Slider_number:addEventListener(percentChangedEvent)

    self:initDrawPropScrollView()
    self:updateDrawLevel()
    self:setSelectNum(self.curChooseLevel)
end

function CombinationCardUpgrade:onExit()
    state_machine.remove("combination_card_upgrade_open")
    state_machine.remove("combination_card_upgrade_close")
    state_machine.remove("combination_card_upgrade_show")
    state_machine.remove("combination_card_upgrade_hide")
    state_machine.remove("combination_card_upgrade_change_times")
    state_machine.remove("combination_card_upgrade_slider_update")
    state_machine.remove("combination_card_upgrade_update_level_consume")
    state_machine.remove("combination_card_upgrade_request_upgrade")
    state_machine.remove("combination_card_upgrade_slider_update_level_consume")
    
end


function CombinationCardUpgrade:close()
	-- window event : close.
	
end

function CombinationCardUpgrade:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
