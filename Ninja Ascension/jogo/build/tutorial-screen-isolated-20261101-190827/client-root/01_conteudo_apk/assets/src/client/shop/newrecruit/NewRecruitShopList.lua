--[[ ----------------------------------------------------------------------------
-- 招募商店cell
--]] ----------------------------------------------------------------------------
NewRecruitShopList = class("NewRecruitShopListClass", Window)
NewRecruitShopList.__size = nil
-- Text_1 de cada widget cacheado -> su caja original (ver initDraw). Global para
-- sobrevivir a una recarga del modulo: el widget ya estaria recolocado.
NewRecruitShopList_text1_boxes = NewRecruitShopList_text1_boxes or setmetatable({}, {__mode = "k"})

-- 创建Cell实例
local new_recruit_shop_listt_create_terminal = {
	_name = "new_recruit_shop_listt_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if NewRecruitShopList then
			local cell = NewRecruitShopList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(new_recruit_shop_listt_create_terminal)
state_machine.init()

-- 构造器
function NewRecruitShopList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
    self.state = -1          -- 当前物品显示
	self.stateUI = {}       -- 用于存放状态UI显示
	self.propInfo = {}		-- 当前物品
	self.exchangeInfo = {}	-- 道具内容
	self.exchangeCounts = 0	-- 兑换次数上限
	self.exchangeType = 0	-- 兑换类型
	self.exchangeTerms = 0	-- 兑换条件
	self.exchangeCosts = 0	-- 兑换所消耗的数量
	self.remain_counts = 0	-- 兑换剩余次数
	self.curIdx = -1		-- 当前道具索引
	-- load lua files.
	-- Initialize service carnivalmission list page state machine.
	local function init_new_recruit_shop_listt_terminal()
		-- 购买按钮点击事件
		local new_recruit_shop_listt_buy_terminal = {
			_name = "new_recruit_shop_listt_buy",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local state = params._datas.state
					if state ~= 0 then
						TipDlg.drawTextDailog(new_recruit_shop_str[11])
						return false
					end
					local cell = params._datas.cell
					local prop = cell.prop
					if prop.prop_number == 0 then
						TipDlg.drawTextDailog(new_recruit_shop_str[12])
						return false
					end
					cell.form_cell = "new_recruit_shop_cell"
					app.load("client.packs.prop.ComExchange")
					state_machine.excute("com_exchange_use_open",0,cell)
					
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(new_recruit_shop_listt_buy_terminal)
		state_machine.add()
		state_machine.init()
	end

	-- call func init service carnivalmission list state machine.
	init_new_recruit_shop_listt_terminal()
end

-- 兑换道具信息
function NewRecruitShopList:getConsumeProp()
    local propID = zstring.split(dms.string(dms["play_config"], 256, play_config.param), ",")[2]
    local havePropNum = tonumber(getPropAllCountByMouldId(propID))
    return propID, havePropNum
end


function NewRecruitShopList:initDraw()
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
			self.stateUI[self.state]:setString(string.format(new_recruit_shop_str[5], level) )
		end
	else 
		self.Image_1:setVisible(false)
		self.blackMask:setVisible(false)
	end
	-- 兑换所需数量
	local exchangeInfo = zstring.split(self.exchangeCosts, ",")
	self.Text_cost:setString(exchangeInfo[3].."")
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
	if tonumber(self.exchangeType) == 1 then
		limitText = new_recruit_shop_str[1]
	elseif  tonumber(self.exchangeType) == 2 then
		limitText = new_recruit_shop_str[2]
	elseif  tonumber(self.exchangeType) == 3 then
		limitText = new_recruit_shop_str[3]
	end
	local limitCounts = self.propInfo.exchangeCounts
	self.Text_1:setVisible(true)
	self.Text_1:setString(limitText..self.remain_counts.."/"..limitCounts)
	-- Naruto: la maqueta no trae Text_number y Text_1 es una caja de ancho fijo;
	-- el texto partia en dos lineas y la segunda (la cuenta «1/2») quedaba debajo
	-- de la barra del precio. Una sola linea, encogida al ancho de la celda.
	if self.Text_number == nil then
		-- la celda sale de una cache (cacher): la caja se mide UNA vez por widget
		local box = NewRecruitShopList_text1_boxes[self.Text_1]
		if box == nil then
			-- la caja de la maqueta: su ancho es el tope y su centro el sitio
			local size = self.Text_1:getContentSize()
			local ap = self.Text_1:getAnchorPoint()
			box = {width = size.width,
				x = self.Text_1:getPositionX() + size.width * (0.5 - ap.x)}
			NewRecruitShopList_text1_boxes[self.Text_1] = box
			self.Text_1:setAnchorPoint(cc.p(0.5, ap.y))
			self.Text_1:setPositionX(box.x)
			self.Text_1:ignoreContentAdaptWithSize(true)
		end
		self.Text_1:setScale(1)
		local w = self.Text_1:getContentSize().width
		if box.width > 0 and w > box.width then
			self.Text_1:setScale(box.width / w)
		end
	end
    if self.Text_number ~= nil then
        self.Text_number:setVisible(true)
        self.Image_limit_bg_1:setVisible(true)

        self.Text_1:setString(limitText)
        self.Text_number:setString(self.remain_counts.."/"..limitCounts)
    end

	-- 绘制兑换内容
	-- local exchangeCell = DrawHandle.drawIcon(self.exchangeCosts)
	local propID = tonumber(exchangeInfo[2])
	local picIndex = dms.int(dms["prop_mould"], propID, prop_mould.pic_index)			-- 招募币图标索引
	self.Panel_cost:setVisible(true)
	self.Panel_cost:setBackGroundImage(string.format("image/common/currency/common_currency_%d.png", picIndex))
end

function NewRecruitShopList:initPropData()
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

	local costInfo = zstring.split(self.exchangeCosts, ",")

    -- 价格
    prop.sale_percentage = tonumber(costInfo[3])
    -- 最大可购买次数
    self._maxTimes = self.exchangeCount
    --当前积分可以购买的次数
    local propId, havePropNum = self:getConsumeProp()
    local may_num = math.floor(havePropNum / tonumber(costInfo[3]))
    prop.prop_number = may_num
    if may_num > self.remain_counts then
        prop.prop_number = self.remain_counts
    end
    prop.id = propId
    self.prop = prop


end

-- 对象初始化
function NewRecruitShopList:init(params)
	self.propInfo = params[1]
	self.rewardString = self.propInfo.exchangeInfo	-- 奖励内容
	self.state = self.propInfo.state					-- 兑换状态
	self.exchangeCounts = self.propInfo.exchangeCounts	-- 兑换次数上限
	self.exchangeType = self.propInfo.exchangeType	-- 兑换类型
	self.exchangeTerms = self.propInfo.exchangeTerms	-- 兑换条件
	self.exchangeCosts = self.propInfo.exchangeCosts-- 兑换所消耗的道具
	self.remain_counts = self.propInfo.remain_counts	-- 兑换剩余次数
	self:initPropData()
	self:onInit()
	return self
end

function NewRecruitShopList:onUpdateDraw()
	local root = self.roots[1]
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

	self:initDraw()
end

function NewRecruitShopList:onEnterTransitionFinish()
	
end

function NewRecruitShopList:onInit()
	-- 加载ServiceCarnivalmissionListWindow界面资源.
	-- res.activity.service_carnival.service_carnival_mission_list = res/activity/service_carnival/service_carnival_mission_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/service_carnival/service_carnival_mission_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("shop/new_shop_tab_1_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	
	if NewRecruitShopList.__size == nil then

		NewRecruitShopList.__size = root:getContentSize()
	end

	self:setContentSize(NewRecruitShopList.__size)

	self:clearUIInfo()
	self:onUpdateDraw()
	
	self.Button_buy = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil,
	{
		terminal_name = "new_recruit_shop_listt_buy",
		terminal_state = 0,
		isPressedActionEnabled = true,
		cell = self,
		state = self.state
	}, nil, 0)	


end


function NewRecruitShopList:clearUIInfo( ... )
    local root = self.roots[1]
    if root == nil then
        return
    end
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


function NewRecruitShopList:onExit()
	-- 释放ServiceCarnivalmissionListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef("shop/new_shop_tab_1_cell.csb", root)
	-- ]]
end

-- ~END
-- ----------------------------------------------------------------------------
