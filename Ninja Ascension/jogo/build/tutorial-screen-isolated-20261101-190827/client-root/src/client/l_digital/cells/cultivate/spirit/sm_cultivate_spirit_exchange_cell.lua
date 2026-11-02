--[[
    author: Rock
    time:2020-06-05 17:05:46
--]]

-----------------------------
-- 数码精神的批量送礼
-----------------------------

SmCultivateSpiritExchangeCell = class("SmCultivateSpiritExchangeCellClass", Window)

--打开界面
local sm_cultivate_spirit_exchange_celle_open_terminal = {
	_name = "sm_cultivate_spirit_exchange_cell_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmCultivateSpiritExchangeCellClass") == nil then
			fwin:open(SmCultivateSpiritExchangeCell:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
--关闭界面
local sm_cultivate_spirit_exchange_cell_close_terminal = {
	_name = "sm_cultivate_spirit_exchange_cell_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmCultivateSpiritExchangeCellClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_cultivate_spirit_exchange_celle_open_terminal)
state_machine.add(sm_cultivate_spirit_exchange_cell_close_terminal)
state_machine.init()

function SmCultivateSpiritExchangeCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.group = {}   -- 礼物列表
    self.showList = {}  -- 数量组
    self._select_num = 1
    self._max_select_num = 1

    app.load("client.cells.utils.resources_icon_cell")
    local function init_sm_cultivate_spirit_exchange_cell_terminal()

        local sm_cultivate_spirit_exchange_cell_update_terminal = {
            _name = "sm_cultivate_spirit_exchange_cell_update",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params[2]
                instance:setSelectSlipNum(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_spirit_exchange_cell_change_num_terminal = {
            _name = "sm_cultivate_spirit_exchange_cell_change_num",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mType = params._datas.m_type 
                local mId = params._datas.m_id
                for i=1,3 do
                    if mId == i then 
                        local maxNum = instance.showList[i].maxNum
                        local curNum = instance.showList[i].curNum
                        curNum = curNum + mType
                        if curNum > maxNum then
                            curNum = maxNum
                        end
                        if curNum <= 0 then
                            curNum = 0
                        end
                        instance.showList[i].curNum = curNum
                    end
                end
                instance:setSelectNum()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_spirit_exchange_cell_use_terminal = {
            _name = "sm_cultivate_spirit_exchange_cell_use",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
               state_machine.lock("sm_cultivate_spirit_exchange_cell_use")
                local function reponseExchange(response)
                    state_machine.unlock("sm_cultivate_spirit_exchange_cell_use")
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then 
                        if response.node ~= nil and response.node.roots ~= nil then 
                            state_machine.excute("sm_cultivate_spirit_object_refush", 0, "")

                            local rewardInfo = getSceneReward(7) 
                            if rewardInfo ~= nil then
                                app.load("client.reward.DrawRareReward")
                                local getRewardWnd = DrawRareReward:new()
                                getRewardWnd:init(nil, rewardInfo)
                                fwin:open(getRewardWnd, fwin._ui)
                            end
                            state_machine.excute("sm_cultivate_spirit_exchange_cell_close", 0 , "")
                        end
                    end
                end
                local showList = instance.showList
                local datas = ""
                for i=1,3 do
                    local num = showList[i].curNum
                    if 1 == i then 
                        datas = datas..tostring(num)
                    else
                        datas =datas.."," ..tostring(num)
                    end 
                end

                getSceneReward(7)
                _ED.show_reward_list_group_ex = {}
                protocol_command.ship_spirit_batch_level_up.param_list = instance.grop_id.."\r\n"..instance.ship_id.."\r\n"..datas
                NetworkManager:register(protocol_command.ship_spirit_batch_level_up.code, nil, nil, nil, self, reponseExchange, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        
        state_machine.add(sm_cultivate_spirit_exchange_cell_update_terminal)
        state_machine.add(sm_cultivate_spirit_exchange_cell_use_terminal)
        state_machine.add(sm_cultivate_spirit_exchange_cell_change_num_terminal)
        state_machine.init()
    end
    init_sm_cultivate_spirit_exchange_cell_terminal()
end

function SmCultivateSpiritExchangeCell:init(params)
    self.group = params[1]
    self.grop_id = params[2]
    self.ship_id = params[3]
    self:onInit()
    return self
end


function SmCultivateSpiritExchangeCell:setSelectSlipNum(index)
    local root = self.roots[1]
    local noNumFlag = true
    for i=1,3 do
        if i == index then
            local Panel_gift = ccui.Helper:seekWidgetByName(root, "Panel_gift_"..i)
            local Slider_number_xz = Panel_gift:getChildByName("Slider_number_xz")
            local maxNum = self.showList[i].maxNum
            local curNum = math.ceil(tonumber(Slider_number_xz:getPercent()) * maxNum / 100)

            if curNum > maxNum then
                curNum = maxNum
            end
            if curNum <= 0 then
                curNum = 0
            else
                noNumFlag = false
            end
            local percent = math.floor(curNum / maxNum*100)
            
            Slider_number_xz:setPercent(percent)
            self.showList[i].curNum = curNum
            --数量
            local Text_packs_sell_n = Panel_gift:getChildByName("Text_packs_sell_n")
            Text_packs_sell_n:setString(curNum.."/"..maxNum)
        else
            if self.showList[i].curNum > 0 then 
                noNumFlag = false
            end
        end
    end

    if noNumFlag then 
        -- 按钮置灰
        self.Button_use:setTouchEnabled(false)
        self.Button_use:setBright(false)
    else
        -- 按钮可点
        self.Button_use:setTouchEnabled(true)
        self.Button_use:setBright(true)
    end
end

function SmCultivateSpiritExchangeCell:setSelectNum()
    local root = self.roots[1]
    local noNumFlag = true
    for i=1,3 do
        local Panel_gift = ccui.Helper:seekWidgetByName(root, "Panel_gift_"..i)
        local Slider_number_xz = Panel_gift:getChildByName("Slider_number_xz")
        local maxNum = self.showList[i].maxNum
        local curNum = self.showList[i].curNum

        if curNum > maxNum then
            curNum = maxNum
        end
        if curNum <= 0 then
            curNum = 0
        else
            noNumFlag = false
        end
        local percent = math.floor(curNum / maxNum*100)
        
        Slider_number_xz:setPercent(percent)
        --数量
        local Text_packs_sell_n = Panel_gift:getChildByName("Text_packs_sell_n")
        Text_packs_sell_n:setString(curNum.."/"..maxNum)
    end

    if noNumFlag then 
        -- 按钮置灰
        self.Button_use:setTouchEnabled(false)
        self.Button_use:setBright(false)
    else
        -- 按钮可点
        self.Button_use:setTouchEnabled(true)
        self.Button_use:setBright(true)
    end
end


function SmCultivateSpiritExchangeCell:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_spirit_gift.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_cultivate_spirit_exchange_cell_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)


    self.Button_use = ccui.Helper:seekWidgetByName(root,"Button_use")
    --兑换道具
    fwin:addTouchEventListener( self.Button_use, nil,
    {
        terminal_name = "sm_cultivate_spirit_exchange_cell_use", 
        terminal_state = 0, 
        touch_black = true,

    }, nil, 0)


    for i=1,3 do
        local propDatas = self.group[i]
        local Panel_gift = ccui.Helper:seekWidgetByName(root, "Panel_gift_"..i)
        -- 加按钮
        fwin:addTouchEventListener(Panel_gift:getChildByName("Button_jia"), nil, 
        {
            terminal_name = "sm_cultivate_spirit_exchange_cell_change_num", 
            m_type = 1,
            m_id = i,
            terminal_state = 0,
            touch_black = true,
        }, nil, 3)

        -- 减按钮
        fwin:addTouchEventListener(Panel_gift:getChildByName("Button_jian"), nil, 
        {
            terminal_name = "sm_cultivate_spirit_exchange_cell_change_num", 
            m_type = -1,
            m_id = i,
            terminal_state = 0,
            touch_black = true,
        }, nil, 3)
        -- 滑动选择
        local Slider_number_xz = Panel_gift:getChildByName("Slider_number_xz")

        --头像
    	local Panel_packs_props_icon = Panel_gift:getChildByName("Panel_packs_props_icon")
    	Panel_packs_props_icon:removeAllChildren(true)
    	--名称
        local Text_packs_props_name = Panel_gift:getChildByName("Text_packs_props_name")
        --数量
        local Text_packs_props_name = Panel_gift:getChildByName("Text_packs_props_name") 

        local propData = zstring.split(propDatas,",")
        local propType = propData[1]
        local propId = propData[2]

        --道具
        local cell = ResourcesIconCell:createCell()
        cell:init(propType,0,propId,nil,nil,false,true,0,nil) 
        local props_number = tonumber(getPropAllCountByMouldId(propId))
        if props_number > 0 then
        else
            gray.setGray(cell)
        end
        cell:setAnchorPoint(0.5,0.5)
        cell:setPosition(cc.p(Panel_packs_props_icon:getContentSize().width/2,Panel_packs_props_icon:getContentSize().height/2))
        Panel_packs_props_icon:addChild(cell)
        --道具名称
        Text_packs_props_name:setString(setThePropsIcon(propId)[2])

        -- 数量
        local curNum = tonumber(getPropAllCountByMouldId(propId))
        -- 最大数量
        local maxNum = tonumber(getPropAllCountByMouldId(propId))

        if 0 >= maxNum then 
            Slider_number_xz:setPercent(0)
            Slider_number_xz:setTouchEnabled(false)
            Slider_number_xz:setBright(false)
        else
            local function percentChangedEvent(sender,eventType)
                if eventType == ccui.SliderEventType.percentChanged then
                    state_machine.excute("sm_cultivate_spirit_exchange_cell_update", 0, {sender:getPercent(),i})
                end
            end
            Slider_number_xz:addEventListener(percentChangedEvent)
        end

        table.insert(self.showList,{
            mType = i, 
            propId = propId,
            curNum = curNum,
            maxNum = maxNum,
        })

    end
    
    self:setSelectNum()
end

function SmCultivateSpiritExchangeCell:onEnterTransitionFinish()
    
end


function SmCultivateSpiritExchangeCell:onExit()
    state_machine.remove("sm_cultivate_spirit_exchange_cell_update")
    state_machine.remove("sm_cultivate_spirit_exchange_cell_use")
    state_machine.remove("sm_cultivate_spirit_exchange_cell_change_num")
end

