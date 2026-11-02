--[[ ----------------------------------------------------------------------------
-- 列表容器cell
--]] ----------------------------------------------------------------------------
NewRecruitCardRecordList = class("NewRecruitCardRecordListClass", Window)
NewRecruitCardRecordList.__size = nil

-- 创建Cell实例
local new_recruit_card_record_list_create_terminal = {
	_name = "new_recruit_card_record_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if NewRecruitCardRecordList then
			local cell = NewRecruitCardRecordList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(new_recruit_card_record_list_create_terminal)
state_machine.init()

-- 构造器
function NewRecruitCardRecordList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.rewardInfo = {}       -- 奖励内容
    self.remainCounts = 0      -- 剩余购买次数
    self.rewardCoins = 0       -- 获取招募币数量
    self.index = 1

    self.isShow = false
	-- load lua files.

	-- Initialize service carnival reward review list page state machine.
	local function init_new_recruit_card_record_list_terminal()
		
	end
	-- call func init service carnival reward review list state machine.
	init_new_recruit_card_record_list_terminal()
end

function NewRecruitCardRecordList:getProp()
    
end

-- 获取抽奖日期
-- function NewRecruitCardRecordList:drawTime()
    -- local curTime = self.rewardTime / 1000
    -- local timeString = os.date("%Y.%m.%d",curTime)
    -- return timeString
-- end

-- 获取招募币信息
function NewRecruitCardRecordList:getCoinInfo()
	local propInfo = dms.string(dms["play_config"], 256, play_config.param)
	propInfo = zstring.split(propInfo, ",")
	return propInfo
end

function NewRecruitCardRecordList:updateDrawContent()
	local allInfo = zstring.splits(self.rewardInfo, "|", ",", function ( value ) return tonumber(value) end)
	-- 控制双黄背景框的显隐
	if #allInfo == 2 then
		self.Image_double:setVisible(true)
	else
		self.Image_double:setVisible(false)
	end
    -- 奖励背景底图
    self.Image_1:setVisible(self.isShow)
	local info = allInfo[1]
    -- 奖励内容图标
	local propCell = DrawHandle.drawIcon(info)
    local propType = tonumber(info[1])
    local propID = tonumber(info[2])
    self.Panel_Prop:addChild(propCell)
    -- 奖励内容文本
    local propText = ""
    -- local quality = -1
	local propInfo = getItemNameAndQuality(info)
	propText = propInfo[1]
  
    self.Prop_propText_Text:setString(propText)
    -- if quality ~= -1 then
    --     self.Prop_propText_Text:setColor(cc.c3b(recruit_preview_tip_color[quality + 1][1], recruit_preview_tip_color[quality + 1][2], recruit_preview_tip_color[quality + 1][3]))
    -- end
    -- 招募币图标
	local coinInfo = self:getCoinInfo()
	coinInfo[3] = self.rewardCoins..""
	local coinCell = DrawHandle.drawIcon(coinInfo)
	self.Panel_Coin:addChild(coinCell)
	-- local picIndex = dms.int(dms["prop_mould"], coinInfo[2], prop_mould.pic_index)			-- 物品图标索引
	-- self.Panel_Coin:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
    -- 抽奖日期文本
    local timeString = self.rewardTime
    self.Text_time:setString(timeString)
end

-- 对象初始化
function NewRecruitCardRecordList:init(params)
	local record = params[1]
    self.rewardInfo = record.rewardInfo
    self.rewardTime = record.reward_time
    self.rewardCoins = record.reward_coins
    self.index = params[2]
    self.isShow = params[3]
	-- if self.index <= 5 then
        
        self:onInit()
	-- end
	self:setContentSize(NewRecruitCardRecordList.__size)
	return self
end

function NewRecruitCardRecordList:onUpdateDraw()
	local root = self.roots[1]
	self.Prop_propText_Text = ccui.Helper:seekWidgetByName(root, "Text_7")      -- 道具文本
	self.Panel_Prop = ccui.Helper:seekWidgetByName(root, "Panel_role_item")     -- 道具容器 
	self.Panel_Coin = ccui.Helper:seekWidgetByName(root, "Panel_2")             -- 招募币容器
    self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")            -- 招募日期文本
    self.Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")            	-- 底图
	self.Image_double = ccui.Helper:seekWidgetByName(root, "icon_double")      -- 双黄底图
	self:updateDrawContent()
end

function NewRecruitCardRecordList:onEnterTransitionFinish()
	
end

function NewRecruitCardRecordList:onInit()
	-- 加载NewRecruitCardRecordList界面资源.
	-- res.shop.new_recruit_record_cell = res/shop/new_recruit_record_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("shop/new_recruit_record_cell.csb")
	local root = csbNode:getChildBypropText("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("shop/new_recruit_record_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)

	if NewRecruitCardRecordList.__size == nil then
		NewRecruitCardRecordList.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function NewRecruitCardRecordList:clearUIInfo(...)
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Prop_propText_Text = ccui.Helper:seekWidgetByName(root, "Text_7")      -- 道具文本
    Prop_propText_Text:setString("")
	local Panel_Prop = ccui.Helper:seekWidgetByName(root, "Panel_role_item")     -- 道具容器 
    Panel_Prop:removeAllChildren()
	local Panel_Coin = ccui.Helper:seekWidgetByName(root, "Panel_2")             -- 招募币容器
    Panel_Coin:removeAllChildren()
    local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")            -- 招募日期文本
    Text_time:setString("")
    local Image_double = ccui.Helper:seekWidgetByName(root, "icon_double")       -- 双黄底图
	Image_double:setVisible(false)
end

function NewRecruitCardRecordList:onExit()
	-- 释放NewRecruitCardRecordList界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	self:clearUIInfo()
	cacher.freeRef("shop/new_recruit_record_cell.csb", root)
	-- ]]
end

function NewRecruitCardRecordList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function NewRecruitCardRecordList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("shop/new_recruit_record_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
