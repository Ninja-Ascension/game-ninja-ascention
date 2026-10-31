--[[ ----------------------------------------------------------------------------
-- 主界面列表项
--]] ----------------------------------------------------------------------------
LegionAssistanceList = class("LegionAssistanceListClass", Window)
LegionAssistanceList.__size = nil

-- 创建Cell实例
local legion_assistance_list_create_terminal = {
	_name = "legion_assistance_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if LegionAssistanceList then
			local cell = LegionAssistanceList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(legion_assistance_list_create_terminal)
state_machine.init()

-- 构造器
function LegionAssistanceList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.unionData = nil

	-- load lua files.
	app.load("client.cells.utils.sm_item_icon_cell")

	-- Initialize legion assistance list page state machine.
	local function init_legion_assistance_list_terminal()
		-- 打开确认界面
		local legion_assistance_list_open_sure_window_terminal = {
			_name = "legion_assistance_list_open_sure_window",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local askInfo = params._datas.askInfo
				if instance ~= nil and askInfo ~= nil then
					local userId = askInfo.data.userId
					local prop_mould_id = askInfo.data.askPropId
					-- print("legion_assistance_list_open_sure_window userId = ", userId)
					state_machine.excute("legion_assistance_window2_window_open", 0, {userId,prop_mould_id})
				end				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local legion_assistance_list_show_member_info_terminal = {
            _name = "legion_assistance_list_show_member_info",
            _init = function (terminal)
                app.load("client.l_digital.union.meeting.SmUnionPlayerInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local unionData = params._datas.unionData
                unionData.isHideButton = true
                local function responseShowUserInfoCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("sm_union_player_info_window_open", 0, unionData)
                    end
                end
                protocol_command.see_user_info.param_list = unionData.id
                NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, self, responseShowUserInfoCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(legion_assistance_list_open_sure_window_terminal)
		state_machine.add(legion_assistance_list_show_member_info_terminal)

		state_machine.init()
	end
	-- call func init legion assistance list state machine.
	init_legion_assistance_list_terminal()
end

-- 对象初始化
function LegionAssistanceList:init(params)
	self.askInfo = params

	if self.askInfo.index < 9 then
		self:onInit(params)
	end
	self:setContentSize(LegionAssistanceList.__size)
	return self
end

function LegionAssistanceList:onHeadDraw(unionData)
	local quality = tonumber(unionData.quality)
	local headIndex = tonumber(unionData.user_head)
	local vipLevel = tonumber(unionData.vipLevel)

	-- debug.print_r(unionData, "unionData = ")

    local roots = cacher.createUIRef("icon/item.csb", "root")
    table.insert(self.roots, roots)
    roots:removeFromParent(true)

    local picIndex = tonumber(headIndex)
    local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
    local Panel_ditu = ccui.Helper:seekWidgetByName(roots, "Panel_ditu")
    local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
    if Panel_head ~= nil then
        Panel_head:removeAllChildren(true)
        Panel_head:removeBackGroundImage()
    end
    if Panel_kuang ~= nil then
        Panel_kuang:removeAllChildren(true)
        Panel_kuang:removeBackGroundImage()
    end
    if Panel_ditu ~= nil then
        Panel_ditu:removeAllChildren(true)
        Panel_ditu:removeBackGroundImage()
    end
    local quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(quality) + 1)
    local quality_kuang = 1
    if tonumber(vipLevel) > 0 then
        quality_path = string.format("images/ui/quality/icon_enemy_%d.png", 5)
        quality_kuang = string.format("images/ui/quality/quality_frame_%d.png", 14)
    else
        quality_path = string.format("images/ui/quality/icon_enemy_%d.png", 1)
        quality_kuang = string.format("images/ui/quality/quality_frame_%d.png", 1)
    end
    local big_icon_path = nil
    if tonumber(picIndex) < 9 then
        big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(picIndex))
    else
        big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(picIndex))
    end
    Panel_ditu:setBackGroundImage(quality_path)
    Panel_kuang:setBackGroundImage(quality_kuang)
    Panel_head:setBackGroundImage(big_icon_path)
    
    fwin:addTouchEventListener(Panel_head, nil, 
    {
        terminal_name = "legion_assistance_list_show_member_info",
        unionData = unionData,
        terminal_state = 0,
    }, 
    nil, 0)
    return roots
end

function LegionAssistanceList:updateAskList()
	-- "userId": 123456,
	-- "userName": "哈哈哈",
	-- "headPic": 200001,
	-- "askTime": 1577270759007,
	-- "askPropId": 1079,
	-- "gotPropNum": 3

	local userName = self.askInfo.data.userName
	self.Text_player:setString(userName)

	-- 创建头像
	local Panel_player = self.Panel_player
	Panel_player:removeAllChildren(true)

	local unionData = self.askInfo.unionData
	if unionData then
		Panel_player:addChild(self:onHeadDraw(unionData))
	end

	-- 创建道具图标
	local Panel_props_icon_1 = self.Panel_props_icon_1
	Panel_props_icon_1:removeAllChildren(true)

	-- type mould num
	local askPropId = tonumber(self.askInfo.data.askPropId)
	local cell = ResourcesIconCell:createCell()
	cell:init(6, 0, askPropId, nil, nil, true, true, 0)
	Panel_props_icon_1:addChild(cell)

	local gotPropNum = self.askInfo.data.gotPropNum
	self.Text_num_1:setString(gotPropNum)

	local shipMouldId = dms.int(dms["prop_mould"], tonumber(self.askInfo.data.askPropId), prop_mould.use_of_ship)
	local maxCount = 0 
	if shipMouldId > 0 then
		local ability = dms.int(dms["ship_mould"], shipMouldId, ship_mould.ability)
		maxCount = self.askInfo.abilityCountMap[ability]
	else
		maxCount = self.askInfo.abilityCountMap['weapon']
	end
	self.Text_num_2:setString(maxCount)

	-- 碎片进度完成
	local isComplete = tonumber(gotPropNum) >= maxCount
	self.Image_done:setVisible(isComplete)
	self.Button_donate:setVisible(not isComplete)

	if self.Button_donate:isVisible() then
		local havePropId = zstring.tonumber(getPropAllCountByMouldId(askPropId))
		-- print("havePropId = ", havePropId)
		self.Button_donate:setTouchEnabled(havePropId > 0)
		self.Button_donate:setBright(havePropId > 0)
	end

	local userId = tonumber(self.askInfo.data.userId)
	local myUserId = tonumber(_ED.user_info.user_id)
	if userId == myUserId then
		self.Button_donate:setVisible(false)
	end

    -- 捐赠按钮
	fwin:addTouchEventListener(self.Button_donate, nil,
	{
		terminal_name = "legion_assistance_list_open_sure_window",
		terminal_state = 0,
		isPressedActionEnabled = true,
		askInfo = self.askInfo
	}, nil, 0)

	self.LoadingBar_donate:setPercent((gotPropNum/maxCount)*100)
end

function LegionAssistanceList:onUpdateDraw()
	local root = self.roots[1]

	-- 玩家头像容器
	self.Panel_player = ccui.Helper:seekWidgetByName(root, "Panel_player")

	-- 玩家ID
	self.Text_player = ccui.Helper:seekWidgetByName(root, "Text_player")

	-- 玩家等级
	self.Text_lv_n = ccui.Helper:seekWidgetByName(root, "Text_lv_n")

	-- 捐赠的碎片图标
	self.Panel_props_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_1")

	-- 捐赠进度条
	self.LoadingBar_donate = ccui.Helper:seekWidgetByName(root, "LoadingBar_donate")

	-- 已捐赠数
	self.Text_num_1 = ccui.Helper:seekWidgetByName(root, "Text_num_1")

	-- 可捐赠数
	self.Text_num_2 = ccui.Helper:seekWidgetByName(root, "Text_num_2")

	-- 图片：已捐赠
	self.Image_done = ccui.Helper:seekWidgetByName(root, "Image_done")

	-- 捐赠按钮
	self.Button_donate = ccui.Helper:seekWidgetByName(root, "Button_donate")

	self:updateAskList()
end

function LegionAssistanceList:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Panel_player = ccui.Helper:seekWidgetByName(root, "Panel_player")
	self.Panel_player:removeAllChildren(true)

	self.Text_player = ccui.Helper:seekWidgetByName(root, "Text_player")
	self.Text_player:setString("")

	self.Text_lv_n = ccui.Helper:seekWidgetByName(root, "Text_lv_n")
	self.Text_lv_n:setString("")

	self.Panel_props_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_1")
	self.Panel_props_icon_1:removeAllChildren(true)

	self.LoadingBar_donate = ccui.Helper:seekWidgetByName(root, "LoadingBar_donate")
	self.LoadingBar_donate:setPercent(0)

	self.Text_num_1 = ccui.Helper:seekWidgetByName(root, "Text_num_1")
	self.Text_num_1:setString("")

	self.Text_num_2 = ccui.Helper:seekWidgetByName(root, "Text_num_2")
	self.Text_num_1:setString("")
end

function LegionAssistanceList:onEnterTransitionFinish()
	local root = self.roots[1]
end

function LegionAssistanceList:onInit(params)
	-- 加载LegionAssistanceListWindow界面资源.
	-- res.legion.legion_assistance_list = res/legion/legion_assistance_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("legion/legion_assistance_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("legion/legion_assistance_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if LegionAssistanceList.__size == nil then
		LegionAssistanceList.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function LegionAssistanceList:onExit()
	-- 释放LegionAssistanceListWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("legion/legion_assistance_list.csb", root)
	-- ]]
end

function LegionAssistanceList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function LegionAssistanceList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("legion/legion_assistance_list.csb", root)
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
