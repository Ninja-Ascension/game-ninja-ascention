LimSummonCellShop = class("LimSummonCellShopClass", Window)
LimSummonCellShop.__size = nil
LimSummonCellShop.__num_show = 10

function LimSummonCellShop:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
    self.index = 0

    self.state = -1         -- 当前物品显示
	self.stateUI = {}       -- 用于存放状态UI显示
	self.propInfo = {}		-- 当前物品
	self.exchangeInfo = {}	-- 道具内容
	self.exchangeCounts = 0	-- 兑换次数上限
	self.exchangeType = 0	-- 兑换类型
	self.exchangeTerms = 0	-- 兑换条件
	self.price = 0			-- 兑换所消耗的数量
	self.remain_counts = 0	-- 兑换剩余次数
	self.curIdx = -1		-- 当前道具索引

    self.params = nil

    local function init_lim_summon_cell_shop_terminal()
        local lim_summon_cell_shop_confirm_terminal = {
            _name = "lim_summon_cell_shop_confirm",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
					local state = params._datas.state
					if state ~= 0 then
						TipDlg.drawTextDailog(tipStringInfo_lim_summon_up[6])
						return false
					end
					local cell = params._datas.cell
					local prop = cell.prop
					if prop.prop_number == 0 then
						TipDlg.drawTextDailog(tipStringInfo_lim_summon_up[7])
						return false
					end

					cell.form_cell = "lim_summon_cell"
					app.load("client.packs.prop.ComExchange")
					state_machine.excute("com_exchange_use_open",0,cell)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(lim_summon_cell_shop_confirm_terminal)
        state_machine.init()
    end

    init_lim_summon_cell_shop_terminal()
end

function LimSummonCellShop:init(params, index)
    self.path_csb = "shop/new_shop_tab_1_cell.csb"
    self.index = index
    if self.index == nil then
        self.index = 0
    end
    self.params = params

    self:initData()

    if nil ~= self.onInit then
        if self.index < LimSummonCellShop.__num_show then
            self:onInit(params)
        end
        self:setContentSize(LimSummonCellShop.__size)
    end

    self:registerOnNodeEvent(self)
    return self
end

function LimSummonCellShop:onInit(params)
    local root = cacher.createUIRef(self.path_csb, "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if LimSummonCellShop.__size == nil then
        LimSummonCellShop.__size = root:getContentSize()
    end

    -- ==========此处定义界面中的按钮点击事件==========

    -- 定义按钮控件
	self.Button_buy = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil,
	{
		terminal_name = "lim_summon_cell_shop_confirm",
		terminal_state = 0,
		isPressedActionEnabled = true,
		cell = self,
		state = self.state
	}, nil, 0)	

    self:onUpdateDraw()
    self:showData()
end

function LimSummonCellShop:onEnterTransitionFinish()

end

function LimSummonCellShop:onUpdateDraw()
    local root = self.roots[1]

    -- 定义除按钮外的其他UI控件
	self.stateUI = {}
	-- 是否含有该数码兽
	self.isHavedCover = ccui.Helper:seekWidgetByName(root, "Text_3")
	table.insert(self.stateUI, self.isHavedCover)
	-- 是否达到等级
	self.levelReach = ccui.Helper:seekWidgetByName(root, "Text_4")
	table.insert(self.stateUI, self.levelReach)
	-- 已售罄
	self.noCounts = ccui.Helper:seekWidgetByName(root, "Text_2")
	table.insert(self.stateUI, self.noCounts)
	-- 不可购买的蒙版
	self.blackMask =  ccui.Helper:seekWidgetByName(root, "Image_2")

	-- 限制类型父节点
	self.Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")

	self.Text_cost = ccui.Helper:seekWidgetByName(root, "Text_8")
	-- 绘制奖励道具容器
	self.Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
	-- 绘制兑换道具容器
	self.Panel_cost = ccui.Helper:seekWidgetByName(root, "Panel_cost")
	-- 绘制兑换道具名字
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_11")
	-- 绘制兑换文本
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    -- 限购次数文本
    self.Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
	-- 限购次数底板
	self.Image_limit_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_limit_bg_1")
end

function LimSummonCellShop:initData()
	self.propInfo = self.params
	self.rewardString = self.propInfo.sItem				-- 奖励内容
	self.state = self.propInfo.state									-- 兑换状态
	self.exchangeCounts = self.propInfo.nLimCount		-- 兑换次数上限
	self.exchangeType = self.propInfo.refreshType		-- 兑换类型
	self.exchangeTerms = self.propInfo.exchangeTerms	-- 兑换条件
	self.price = self.propInfo.price					-- 兑换的价格
	self.remain_counts = self.propInfo.remain_counts	-- 兑换剩余次数
	self.indexProp = self.propInfo.id					-- 商品的序列号
	self:initPropData()
end

function LimSummonCellShop:showData()
	for i, v in ipairs(self.stateUI) do
		v:setVisible(false)
	end
	self.Panel_icon:removeAllChildren()
	if self.state ~= 0 then
		self.Image_1:setVisible(true)
		self.stateUI[self.state]:setVisible(true)
		self.blackMask:setVisible(true)
		if self.state == 2 then
			local levelInfo = zstring.split(self.exchangeTerms, "|")
			local level = tonumber(levelInfo[2])
			self.stateUI[self.state]:setString(string.format(tipStringInfo_lim_summon_up[8], level) )
		end
	else 
		self.Image_1:setVisible(false)
		self.blackMask:setVisible(false)
	end
	-- 兑换所需数量
	self.Text_cost:setString(self.price.."")
	-- 绘制奖励内容
	local rewardInfo = zstring.split(self.rewardString, ",", function ( value ) return tonumber(value) end)
	local type = tonumber(rewardInfo[1])
	self.propInfo.mouldID = tonumber(rewardInfo[2])
	local rewardCell = DrawHandle.drawIcon(self.rewardString)
	self.Panel_icon:setVisible(true)
	self.Panel_icon:addChild(rewardCell)
	local propInfo = getItemNameAndQuality(rewardInfo)
	local name = propInfo[1]
	self.Text_name:setString(name)
	local limitText = ""
	-- 兑换次数上限
	if tonumber(self.exchangeType) == 0 then
		limitText = tipStringInfo_lim_summon_up[4]
	elseif  tonumber(self.exchangeType) == 1 then
		limitText = tipStringInfo_lim_summon_up[5]
	end
	local limitCounts = self.exchangeCounts
	self.Text_1:setVisible(true)
	self.Text_1:setString(limitText..self.remain_counts.."/"..limitCounts)
    if self.Text_number ~= nil then
        self.Text_number:setVisible(true)
        self.Image_limit_bg_1:setVisible(true)

        self.Text_1:setString(limitText)
        self.Text_number:setString(self.remain_counts.."/"..limitCounts)
    end

	-- 绘制兑换内容
	local propID = LimSummonMgr:GetInstance():getIdJifen()
	local picIndex = dms.int(dms["prop_mould"], propID, prop_mould.pic_index)			-- 积分图标索引
	self.Panel_cost:setVisible(true)
	self.Panel_cost:setBackGroundImage(string.format("image/common/currency/common_currency_%d.png", picIndex))
end

function LimSummonCellShop:initPropData()
	local prop_param = zstring.split(self.rewardString, ",")
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

    -- 价格
    prop.sale_percentage = self.price
    -- 最大可购买次数
    self._maxTimes = self.exchangeCount

    --当前积分可以购买的次数
	local propId = LimSummonMgr:GetInstance():getIdJifen()
	local havePropNum = LimSummonMgr:GetInstance():getCountJifen()

    local may_num = math.floor(havePropNum / self.price)
    prop.prop_number = may_num
    if may_num > self.remain_counts then
        prop.prop_number = self.remain_counts
    end
    prop.id = propId
    self.prop = prop
end

function LimSummonCellShop:setActivityId(idActivity)
	self.idActivity = idActivity
end

function LimSummonCellShop:onExit()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(self.path_csb, root)
end

function LimSummonCellShop:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LimSummonCellShop:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef(self.path_csb, root)
    
    self.roots = {}
end

function LimSummonCellShop:clearUIInfo()
	-- 图片绘制容器
	local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
	Panel_icon:removeAllChildren()
	-- 消耗道具容器
	local Panel_cost = ccui.Helper:seekWidgetByName(root, "Panel_cost")
	Panel_cost:removeAllChildren()
	-- 消耗道具数量文本
	local Text_cost = ccui.Helper:seekWidgetByName(root, "Text_8")
	Text_cost:setString("")
	-- 限购期数类型文本
	local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	Text_1:setString("")
	Text_1:setVisible(false)
	-- 道具名称文本
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_11")
	Text_name:setString("")
	-- 商品状态文本标签父节点
	local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
	Image_1:setVisible(false)
	-- 商品不可购买底板
	local Image_block = ccui.Helper:seekWidgetByName(root, "Image_2")
	Image_block:setVisible(false)
	-- 限购条件容器
	local Image_limit = ccui.Helper:seekWidgetByName(root, "Image_limit")
	if Image_limit ~= nil then
	Image_limit:setVisible(false)
	end
	-- 限购条件文本
	local Text_limit = ccui.Helper:seekWidgetByName(root, "Text_limit")
	if Text_limit ~= nil then
	Text_limit:setString("")
	end
	-- 限购次数文本
	local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
	if Text_number ~= nil then
	Text_number:setString("")
	Text_number:setVisible(false)
	end
	-- 限购次数底板
	local Image_limit_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_limit_bg_1")
	if Image_limit_bg_1 ~= nil then
		Image_limit_bg_1:setVisible(false)
	end
end