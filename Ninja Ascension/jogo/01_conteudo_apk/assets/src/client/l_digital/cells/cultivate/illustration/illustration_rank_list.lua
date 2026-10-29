--[[ ----------------------------------------------------------------------------
-- 卡册排行榜列表控件
--]] ----------------------------------------------------------------------------
IllustrationRankList = class("IllustrationRankListClass", Window)
IllustrationRankList.__size = nil

-- 创建Cell实例
local illustration_rank_list_create_terminal = {
	_name = "illustration_rank_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if IllustrationRankList then
			local cell = IllustrationRankList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_rank_list_create_terminal)
state_machine.init()

-- 构造器
function IllustrationRankList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._rank_data = nil 
	-- load lua files.

	-- Initialize illustration rank list page state machine.
	local function init_illustration_rank_list_terminal()
		local illustration_ranking_information_cell_check_terminal = {
            _name = "illustration_ranking_information_cell_check",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
                app.load("client.l_digital.union.create.SmUnionInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cells = params._datas.cells
                if not cells._rank_data.nickName then
                    return false
                end
                local userID = tonumber(cells._rank_data.userId)
                
				-- DSC统一玩家详情界面
				if __lua_project_id == __lua_project_l_digital then
                    OpenOtherUserInformation(userID, nil, nil)
				else
					local function responseShowUserInfoCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								local datainfo = response.node._rank_data
								datainfo.icon = response.node._rank_data.headPic
								datainfo.name = response.node._rank_data.nickName
								datainfo.level = _ED.chat_user_info.grade
								datainfo.rank = response.node._rank_data.user_rank
								datainfo.force = _ED.chat_user_info.fighting
								datainfo.vip = _ED.chat_user_info.vip_grade
								datainfo.template = {}
								datainfo.template[1] = _ED.chat_user_info.formation
								if _ED.chat_user_info.army == "" then
									datainfo.arame = "?"
								else
									datainfo.arame = _ED.chat_user_info.army
								end
								state_machine.excute("sm_arena_player_info_window_open",0,datainfo)
							end
						end
					end
					protocol_command.see_user_info.param_list = cells._rank_data.userId
					NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, cells, responseShowUserInfoCallBack, false, nil)
				end

                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		state_machine.add(illustration_ranking_information_cell_check_terminal) 

        state_machine.init()
	end
	-- call func init illustration rank list state machine.
	init_illustration_rank_list_terminal()
end

-- 对象初始化
function IllustrationRankList:init(params)
	self._rank_data = params[1]
	self._rank = params[2]

	if tonumber(self._rank) < 9 then
		self:onInit(params)
	end
	self:setContentSize(IllustrationRankList.__size)
	return self
end

function IllustrationRankList:onUpdateDraw()
	local root = self.roots[1]

	for i=1,3 do
        ccui.Helper:seekWidgetByName(root, "Image_ranking_"..i):setVisible(false)
    end
    local ranks = tonumber(self._rank)
    if ranks <=3 then
        ccui.Helper:seekWidgetByName(root, "Image_ranking_"..ranks):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Text_ranking"):setString("")
    else
        ccui.Helper:seekWidgetByName(root, "Text_ranking"):setString(ranks)
    end
	local userInfo = self._rank_data
	local headPic = userInfo.headPic
	-- 角色头像
	self.Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
	self.Panel_player_icon:removeAllChildren(true)
	self.Panel_player_icon:removeBackGroundImage()
	-- 新增头像框
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
		local headFrameInfo = {}
		if userInfo.headFrame ~= nil and userInfo.headFrame ~= "" then
			headFrameInfo = zstring.split(userInfo.headFrame, ",", tonumber)
		else
			headFrameInfo[1] = -1
			headFrameInfo[2] = -1
		end
		local headIconInfo = {
			headFrameID = headFrameInfo[1],
			headFrameStage = headFrameInfo[2],
			headID = headPic,
		}
		local headIcon = CreateHeadIconCell(headIconInfo)
		if headIcon ~= nil then
			self.Panel_player_icon:addChild(headIcon)
		end
	else
		local big_icon_path = nil
		if tonumber(headPic) < 9 then
			big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(headPic))
		else
			big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(headPic))
		end
		self.Panel_player_icon:setBackGroundImage(big_icon_path)
	end
	
	-- 角色等级
	self.Text_level = ccui.Helper:seekWidgetByName(root, "Text_level")
	self.Text_level:setString(tipStringInfo_illustration_tip[6]..userInfo.userLevel)
	-- 玩家名称
	self.Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
	self.Text_player_name:setString(""..userInfo.nickName)
	-- 玩家公会
	self.Text_legion = ccui.Helper:seekWidgetByName(root, "Text_legion")
	self.Text_legion:setString(""..userInfo.unionName)
	-- 玩家卡册评分
	self.Text_points = ccui.Helper:seekWidgetByName(root, "Text_points")
	self.Text_points:setString(""..userInfo.score)
end

function IllustrationRankList:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Text_ranking = ccui.Helper:seekWidgetByName(root, "Text_ranking")
	self.Text_ranking:setString("")

	self.Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
	self.Panel_player_icon:removeAllChildren(true)
	self.Panel_player_icon:removeBackGroundImage()

	self.Text_level = ccui.Helper:seekWidgetByName(root, "Text_level")
	self.Text_level:setString("")

	self.Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
	self.Text_player_name:setString("")

	self.Text_legion = ccui.Helper:seekWidgetByName(root, "Text_legion")
	self.Text_legion:setString("")

	self.Text_points = ccui.Helper:seekWidgetByName(root, "Text_points")
	self.Text_points:setString("")
end

function IllustrationRankList:onEnterTransitionFinish()
	
end

function IllustrationRankList:onInit(params)
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/illustration/illustration_rank_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if IllustrationRankList.__size == nil then
		IllustrationRankList.__size = root:getContentSize()
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_247"), nil, 
    {
        terminal_name = "illustration_ranking_information_cell_check", 
        terminal_state = 0, 
        touch_black = true,
        cells = self,
    }, nil, 1)
    self:clearUIInfo()
	self:onUpdateDraw()
end

function IllustrationRankList:onExit()
	-- 释放IllustrationRankListWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/illustration/illustration_rank_list.csb", root)
	-- ]]
end

function IllustrationRankList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function IllustrationRankList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/illustration/illustration_rank_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
