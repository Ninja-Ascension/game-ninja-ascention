--[[ ----------------------------------------------------------------------------
-- 招募商店
--]] ----------------------------------------------------------------------------
NewRecruitShop = class("NewRecruitShopClass", Window)

-- 打开窗口
local new_recruit_shop_window_open_terminal = {
	_name = "new_recruit_shop_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("NewRecruitShopClass") then
			fwin:open(NewRecruitShop:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local new_recruit_shop_window_close_terminal = {
	_name = "new_recruit_shop_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("NewRecruitShopClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(new_recruit_shop_window_open_terminal)
state_machine.add(new_recruit_shop_window_close_terminal)
state_machine.init()

-- 构造器
function NewRecruitShop:ctor()
	self.super:ctor()
	self.roots = {}

	-- var
    
	-- load lua files.
	app.load("client.shop.newrecruit.NewRecruitShopList")
	-- Initialize service carnival rule page state machine.
	local function init_new_recruit_shop_terminal()
		-- 打开角色创建窗口
		local new_recruit_shop_open_terminal = {
			_name = "new_recruit_shop_open",
			_init = function (terminal)
				
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
		local new_recruit_shop_close_terminal = {
			_name = "new_recruit_shop_close",
			_init = function (terminal)
				
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

		-- 显示窗口
		local new_recruit_shop_show_terminal = {
			_name = "new_recruit_shop_show",
			_init = function (terminal)
				
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
		local new_recruit_shop_hide_terminal = {
			_name = "new_recruit_shop_hide",
			_init = function (terminal)
				
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

		-- 刷新界面
		local new_recruit_shop_refresh_terminal = {
			_name = "new_recruit_shop_refresh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 刷新界面
				if nil ~= instance then
					instance:initListView()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

       

		state_machine.add(new_recruit_shop_open_terminal)
		state_machine.add(new_recruit_shop_close_terminal)
		state_machine.add(new_recruit_shop_show_terminal)
		state_machine.add(new_recruit_shop_hide_terminal)
		state_machine.add(new_recruit_shop_refresh_terminal)
		state_machine.init()
	end
	-- call func init service carnival rule state machine.
	init_new_recruit_shop_terminal()
end

function NewRecruitShop:updateRewardList()
	local data = _ED.newRecruitInfo
	local result = zstring.split(data.shopRemainInfo, ",")
	-- local result = {{propIdx = 5,remain_counts = 1}, {propIdx = 2,remain_counts = 1}, {propIdx = 3,remain_counts = 2}, {propIdx = 4, remain_counts = 2}}
	result = self:sortListItems(result)
	local nodeList = {}
	for j, v in pairs(result) do
		local cell = state_machine.excute("new_recruit_shop_listt_create", 0, {v})
		table.insert(nodeList, cell)
	end
	addNodeToScrollView(self.ScrollView_1, nodeList, 4, 0)
end



function NewRecruitShop:initListView()
	local root = self.roots[1]
	self.Text_coin:setString(self:getCoinNum())
	local data = _ED.newRecruitInfo

    local cell_size = nil
    local cell_group = {}

	local result = zstring.split(data.shopRemainInfo, ",")
	
	-- local result = {{propIdx = 5,remain_counts = 1}, {propIdx = 2,remain_counts = 1}, {propIdx = 3,remain_counts = 2}, {propIdx = 4, remain_counts = 2}}
	result = self:sortListItems(result)
	local ScrollView_yulan_1 = ccui.Helper:seekWidgetByName(root,"ScrollView_1")
    ScrollView_yulan_1:removeAllChildren(true)

    local cell_size = nil
    local cell_group = {}

    for k, v in pairs(result) do
        local cell = nil
        local cell = state_machine.excute("new_recruit_shop_listt_create", 0, {v})
        ScrollView_yulan_1:addChild(cell)
        table.insert(cell_group, cell)
        if cell_size == nil then
            cell_size = cell:getContentSize()
        end
    end
    local width = ScrollView_yulan_1:getContentSize().width
    local height = ScrollView_yulan_1:getContentSize().height
    local count = #result
    local row_count = 4
    local col_count = math.ceil(count / row_count)

    if count > 0 then
        if cell_size.height * col_count > height then
            height = cell_size.height * col_count
        end
        -- 进行scrollView的绘制
        ScrollView_yulan_1:getInnerContainer():setContentSize(cc.size(width, height + 15))
        for i = 1, count do
            local row = 0
            local col = 0
            local cell = nil
            row = math.floor((i - 1) % row_count)
            col = math.floor((i - 1) / row_count)
            cell = cell_group[i]
            cell:setAnchorPoint(cc.p(0,1))
            cell:setPosition(cc.p(row * (width / row_count), height - col * cell_size.height))
        end
    end

    ScrollView_yulan_1:jumpToTop()
    self.ScrollView_1 = ScrollView_yulan_1
    self.ScrollView_1_posy = self.ScrollView_1:getInnerContainer():getPositionY()
    self._cell_group = cell_group
    self._cell_size = cell_size

	-- if nil ~= cell_size then
    --     local InnerHeight = math.max(cell_size.width * col_count, self.ScrollView_1:getContentSize().width)
    --     local InnerWidth = self.ScrollView_1:getInnerContainer():getContentSize().width
    --     self.ScrollView_1:getInnerContainer():setContentSize(cc.size(InnerWidth, InnerHeight))
    -- end

end

function NewRecruitShop:onUpdate(dt)
    -- if self.ScrollView_1 ~= nil then
    --     local posY = self.ScrollView_1:getInnerContainer():getPositionY()
    --     if posY == self.ScrollView_1_posy then
    --         return
    --     end
    --     self.ScrollView_1_posy = posY

    --     local size = self.ScrollView_1:getContentSize()
    --     local items = self._cell_group
    --     local itemSize = self._cell_size
    --     for i, v in pairs(items) do
    --         if v ~= nil and tolua.isnull(v) == false then
    --             if v ~= nil then
    --                 local tempY = v:getPositionY() + posY
    --                 if tempY + itemSize.height < 0 or tempY > size.height + itemSize.height then
    --                     v:unload()
    --                 else
    --                     v:reload()
    --                 end
    --             end
    --         end
    --     end
    -- end
end

function NewRecruitShop:initDraw()
	
end

-- 返回招募币信息
function NewRecruitShop:getCoinID()
	local propInfo = dms.string(dms["play_config"], 256, play_config.param)
	propInfo = zstring.split(propInfo, ",")
	
	local propID = tonumber(propInfo[2])
	return propID
end

-- 返回招募币数量
function NewRecruitShop:getCoinNum()
	local propID = self:getCoinID()
	local havePropNum = tonumber(getPropAllCountByMouldId(propID))
	return havePropNum
end

-- 对商品内容按照状态进行排序
function NewRecruitShop:sortListItems(items)
    local result = {}
    local openItems = {}             -- 可兑换
    local isHavedItems = {}          -- 是否已拥有
    local levelItems = {}            -- 是否达到等级
    local isCompleteItems = {}       -- 已兑换完毕

    for k, v in pairs(items) do
        local idx = k
        local level = 0
        local state = 1     -- 0代表可兑换，1代表没有数码兽，2代表未达到等级，3代表没有兑换次数
		local itemInfo = {}
		-- local propString = dms.atos(dms[""], idx)	-- 该道具信息  返回某一行的数据
		local exchangeInfo = dms.string(dms["new_draw_card_shop"], idx, new_draw_card_shop.reward)	-- 兑换道具内容
		local exchangeCounts = dms.int(dms["new_draw_card_shop"], idx, new_draw_card_shop.times)	-- 兑换次数上限
		local exchangeType = dms.int(dms["new_draw_card_shop"], idx, new_draw_card_shop.type)	-- 购买类型 
		local exchangeTerms = dms.string(dms["new_draw_card_shop"], idx, new_draw_card_shop.exchangeCondition)	-- 兑换条件
		local exchangeCosts = dms.string(dms["new_draw_card_shop"], idx, new_draw_card_shop.cost)	-- 兑换所消耗的内容
		itemInfo.exchangeInfo = exchangeInfo
		itemInfo.exchangeCounts = exchangeCounts
		itemInfo.idx = k
		itemInfo.remain_counts = tonumber(v)
		itemInfo.exchangeType = exchangeType
		itemInfo.exchangeTerms = exchangeTerms
		itemInfo.exchangeCosts = exchangeCosts

		state = getNewShopRecruitmentListState(itemInfo)
		itemInfo.state = state
		-- 判断该商品属于什么展示类型
        if state == 0 then
            table.insert(openItems, itemInfo)
        elseif state == 1 then
            table.insert(isHavedItems, itemInfo)
		elseif state == 2 then
			table.insert(levelItems, itemInfo)
        else
            table.insert(isCompleteItems, itemInfo)
        end
    end

    for k, v in pairs(openItems) do
        table.insert(result, v)
    end
    for k, v in pairs(isHavedItems) do
        table.insert(result, v)
    end
    for k, v in pairs(levelItems) do
        table.insert(result, v)
    end
    for k, v in pairs(isCompleteItems) do
        table.insert(result, v)
    end

    return result
end

function NewRecruitShop:onUpdateDraw()
	local root = self.roots[1]
	self.buttonList = {}
	local propID = self:getCoinID()
	local picIndex = dms.int(dms["prop_mould"], propID, prop_mould.pic_index)			-- 物品图标索引
	self.Panel_cost:removeBackGroundImage()
	self.Panel_cost:setBackGroundImage(string.format("image/common/currency/common_currency_%d.png", picIndex))
    -- self:updateRewardList()
	self:initListView()
end

-- 对象初始化
function NewRecruitShop:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end


function NewRecruitShop:onEnterTransitionFinish()
	-- 加载NewRecruitShopWindow界面资源.
	-- shop/new_recruit_shop = shop/new_recruit_shop.csb
    local csbNode = csb.createNode("shop/new_recruit_shop.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	self.ScrollView_1 = ccui.Helper:seekWidgetByName(root, "ScrollView_1")

	self.Text_coin = ccui.Helper:seekWidgetByName(root, "Text_16")
	-- 招募币图标icon
	self.Panel_cost = ccui.Helper:seekWidgetByName(root, "Panel_cost")

	self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil,
	{
		terminal_name = "new_recruit_shop_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)


	self:onUpdateDraw()
end

function NewRecruitShop:onExit()
	-- 释放NewRecruitShopWindow界面资源.
	state_machine.remove("new_recruit_shop_open")
	state_machine.remove("new_recruit_shop_close")
	state_machine.remove("new_recruit_shop_show")
	state_machine.remove("new_recruit_shop_hide")
	state_machine.remove("new_recruit_shop_refresh")
	
end

function NewRecruitShop:close()
	-- window event : close.
	
end

function NewRecruitShop:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
