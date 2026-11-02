--[[ ----------------------------------------------------------------------------
-- 兑换商店货物list
--]] ----------------------------------------------------------------------------
ChristmasRomanceShopList = class("ChristmasRomanceShopListClass", Window)
ChristmasRomanceShopList.__size = nil

-- 创建Cell实例
local christmas_romance_shop_list_create_terminal = {
    _name = "christmas_romance_shop_list_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if ChristmasRomanceShopList then
            local cell = ChristmasRomanceShopList:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(christmas_romance_shop_list_create_terminal)
state_machine.init()

-- 构造器
function ChristmasRomanceShopList:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._type = nil
    self._infos = nil
    self.prop = nil
    -- 最大可购买次数
    self._maxTimes = nil
    -- 已购买次数
    self._haveTimes = nil
    -- 还可以购买次数
    self._surplusTimes = nil
    -- load lua files.

    -- Initialize christmas romance shop list page state machine.
    local function init_christmas_romance_shop_list_terminal()
        local christmas_romance_shop_buy_terminal = {
            _name = "christmas_romance_shop_buy",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params)
				
				if params then
					state_machine.lock("christmas_romance_shop_buy")
                    local mCell = params._datas.m_cell
                    if mCell.prop.prop_number < 1 then
						TipDlg.drawTextDailog(tipStringInfo_christmas_romance_activity_tips[3])
						state_machine.unlock("christmas_romance_shop_buy")
                        return
                    end
					if mCell._type == 4 then
						--这里添加兑换弹窗
						mCell.form_cell = "christmas_romance_shop_cell"
                        app.load("client.packs.prop.ComExchange")
						state_machine.excute("com_exchange_use_open", 0, mCell)
                    else
						state_machine.excute("christmas_romance_exchange_tip_window_open",0,{mCell})
					end
					state_machine.unlock("christmas_romance_shop_buy")
                end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(christmas_romance_shop_buy_terminal)
        state_machine.init()
    end
    -- call func init christmas romance shop list state machine.
    init_christmas_romance_shop_list_terminal()
end

-- 对象初始化
function ChristmasRomanceShopList:init(params)
    self._type = params.mType
    self._infos = params.infos
    self:onInit(params)
    self:setContentSize(ChristmasRomanceShopList.__size)
    return self
end

function ChristmasRomanceShopList:onUpdateDraw()
    local root = self.roots[1]
    local infos = self._infos
    local rewards = zstring.split(infos.reward, ",")
    -- 道具icon容器
    self.Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
    self.Panel_6:removeAllChildren(true)
    local cell = self:addResourcesIconCell(rewards)
    self.Panel_6:addChild(cell)
    -- 道具名称
    self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    self.Text_name:setString(self.prop.mould_name)
    -- 价格
    self.Text_shuliang = ccui.Helper:seekWidgetByName(root, "Text_shuliang")
    self.Text_shuliang:setString(self.prop.sale_percentage)
    -- 价格图标
    self.Image_icon = ccui.Helper:seekWidgetByName(root, "Image_icon")
    -- 兑换消耗数量
    self.Text_cishu = ccui.Helper:seekWidgetByName(root, "Text_cishu")
    self.Text_cishu:setString(self._haveTimes.."/"..self._maxTimes)
    -- 已售完
    self.Image_black = ccui.Helper:seekWidgetByName(root, "Image_black")
    if self._surplusTimes < 1 then 
        self.Text_cishu:setVisible(false)
        self.Image_black:setVisible(true)
        self.Button_duihuan:setVisible(false)
        self.Image_icon:setVisible(false)
    else
        self.Text_cishu:setVisible(true)
        self.Image_black:setVisible(false)
        self.Button_duihuan:setVisible(true)
        self.Image_icon:setVisible(true)
    end
    
end

function ChristmasRomanceShopList:addResourcesIconCell(propData)
    local cell = ResourcesIconCell:createCell()
    local rewardType = tonumber(propData[1])
    if 13 == rewardType then
        local extraTable = {}
        if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
            extraTable.shipStar = tonumber(propData[4])
        else
            extraTable.shipStar = 0
        end
        cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
    else
        cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1)
    end
    return cell
end

-- 资源初始化
function ChristmasRomanceShopList:initData()
    local prop_param = zstring.split(self._infos.reward, ",")
    local prop = {}
    -- 商品类型
    prop.type = tonumber(prop_param[1])
    -- 类型对应的模板id
    prop.mould_id = tonumber(prop_param[2])
    -- 商品数量
    prop.number = tonumber(prop_param[3])
    
    local propInfo = getItemNameAndQuality(prop_param)
    prop.mould_name = propInfo[1]
    prop.prop_quality = propInfo[2]


    local stateInfos = _ED.active_activity[181].activity_data.shopState[self._type].haveTimesList
    local pageHaveTime = _ED.active_activity[181].activity_data.shopState[self._type].userAllBuyNumber
    local pageTotalTime = self:getPageTime()
    local haveBuyTime = tonumber(stateInfos[self._infos.id])
    local totalBuyTimes = self._infos.canBuyTimes
    local price = self._infos.price

    -- 价格
    prop.sale_percentage = price
    -- 最大可购买次数
    self._maxTimes = totalBuyTimes == -1 and pageTotalTime or totalBuyTimes
    -- 已购买次数
    self._haveTimes = haveBuyTime
    -- 还可以购买的次数
    local surplusPageTime = pageTotalTime - pageHaveTime
    local surplusGoodsTime = self._maxTimes - self._haveTimes
    self._surplusTimes = surplusGoodsTime > surplusPageTime and surplusPageTime or surplusGoodsTime
    --当前积分可以购买的次数
    local propId, havePropNum = self:getConsumeProp()
    local may_num = math.floor(havePropNum / price)
    prop.prop_number = may_num
    if may_num > self._surplusTimes then
        prop.prop_number = self._surplusTimes
    end
    prop.id = propId
    self.prop = prop
end

function ChristmasRomanceShopList:getPageTime()
    local infos = zstring.split(dms.string(dms["activity_config"], 95, activity_config.param), "|")[self._type]
    local total = tonumber(zstring.split(infos, ",")[2])
    return total
end
-- 兑换道具
function ChristmasRomanceShopList:getConsumeProp()
    local propID = zstring.split(dms.string(dms["activity_config"], 96, activity_config.param), ",")[2]
    local havePropNum = tonumber(getPropAllCountByMouldId(propID))
    return propID, havePropNum
end

function ChristmasRomanceShopList:onEnterTransitionFinish()
end

function ChristmasRomanceShopList:onInit(params)
    -- 加载ChristmasRomanceShopListWindow界面资源.
    -- res.activity.christmas_romance.christmas_romance_shop_list = res/activity/christmas_romance/christmas_romance_shop_list.csb
    --[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/christmas_romance/christmas_romance_shop_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
    -- [[ 使用缓存创建
    local root = cacher.createUIRef("activity/christmas_romance/christmas_romance_shop_list.csb", "root")
    -- ]]
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if ChristmasRomanceShopList.__size == nil then
        ChristmasRomanceShopList.__size = root:getContentSize()
    end
    self:clearUIInfo()
    -- 购买
    self.Button_duihuan =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_duihuan"),
        nil,
        {
            terminal_name = "christmas_romance_shop_buy",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_cell = self
        },
        nil,
        0
    )

    self:initData()
    self:onUpdateDraw()
end

function ChristmasRomanceShopList:onExit()
    -- 释放ChristmasRomanceShopListWindow界面资源.

    -- [[ 释放缓存
    local root = self.roots[1]
    cacher.freeRef("activity/christmas_romance/christmas_romance_shop_list.csb", root)
    -- ]]
end

function ChristmasRomanceShopList:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ChristmasRomanceShopList:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef("activity/christmas_romance/christmas_romance_shop_list.csb", root)

    self.roots = {}
end

function ChristmasRomanceShopList:clearUIInfo(...)
    local root = self.roots[1]
    if root == nil then
        return
    end

    -- 道具icon容器
    ccui.Helper:seekWidgetByName(root, "Panel_6"):removeAllChildren(true)
    -- 道具名称
    ccui.Helper:seekWidgetByName(root, "Text_name"):setString("")
    -- 兑换消耗数量
    ccui.Helper:seekWidgetByName(root, "Text_cishu"):setString("")
    ccui.Helper:seekWidgetByName(root, "Text_shuliang"):setString("")
    ccui.Helper:seekWidgetByName(root, "Button_duihuan"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_icon"):setVisible(false)
end

-- ~END
-- ----------------------------------------------------------------------------
