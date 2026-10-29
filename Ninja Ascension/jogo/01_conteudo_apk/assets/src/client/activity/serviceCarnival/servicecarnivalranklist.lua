--[[ ----------------------------------------------------------------------------
-- 排行榜列表cell
--]] ----------------------------------------------------------------------------
ServiceCarnivalRankList = class("ServiceCarnivalRankListClass", Window)
ServiceCarnivalRankList.__size = nil

-- 创建Cell实例
local service_carnival_rank_list_create_terminal = {
	_name = "service_carnival_rank_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if ServiceCarnivalRankList then
			local cell = ServiceCarnivalRankList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(service_carnival_rank_list_create_terminal)
state_machine.init()

-- 构造器
function ServiceCarnivalRankList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.index = 1
	self.m_type = 1
	self.ranking = 1				-- 当前排名

	self.isLoad = false			-- 正在加载本控件
	
	self.Text_rank_normalList = {}		-- 排行榜普通文本
	self.Text_rank_exceList = {}		-- 排行榜有名次的文本
	self.rankStateMould = {}		-- 排行榜各阶段模块
	self.activity = {}			-- 玩家信息
	self.curRewardInfos = {}	-- 奖励信息
	-- load lua files.

	-- Initialize service carnival rank list page state machine.
	local function init_service_carnival_rank_list_terminal()
		local service_carnival_ranklist_show_information_terminal = {
            _name = "service_carnival_ranklist_show_information",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cells = params._datas.cells
                local function responseShowUserInfoCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local datainfo = response.node.activity
						--debug.print_r(_ED.chat_user_info, "========_ED.chat_user_info")
                        datainfo.icon = response.node.activity.user_head_id
                        datainfo.name = response.node.activity.nickName
                        datainfo.level = _ED.chat_user_info.grade
                        datainfo.rank = response.node.activity.ranking
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
                protocol_command.see_user_info.param_list = cells.activity.user_id
                NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, cells, responseShowUserInfoCallBack, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(service_carnival_ranklist_show_information_terminal)
		state_machine.init()
	end
	-- call func init service carnival rank list state machine.
	init_service_carnival_rank_list_terminal()
end

function ServiceCarnivalRankList:getRankReward()

	if self.curRewardInfos then
		for i, v in ipairs(self.curRewardInfos) do
			local reward = zstring.split(v , ",")
			local cell = DrawHandle.drawIcon(reward)
			self.ListView_rewards:addChild(cell)
		end
	end
	self.ListView_rewards:requestRefreshView()
end

function ServiceCarnivalRankList:updateUserInfo(params)
	self.activity = params.playerInfo
	
	if self.isLoad then
		
		self:clearUIInfo()
		self:onUpdateDraw()
	end
end

function ServiceCarnivalRankList:initDraw()
	for i = 1 , 3 do
		self.Text_rank_normalList[i]:setVisible(false)
		self.Text_rank_exceList[i]:setVisible(false)
		self.rankStateMould[i]:setVisible(false)
	end
	self.Panel_ph_list:setVisible(true)
	self.Image_rank_normal:setVisible(false)
	self.Text_ph_st:setVisible(false)

	self.ranking = self.activity.ranking
	local name = self.activity.nickName
	local userCounts = self.activity.propNumber
	if self.ranking <= 3 then
		self.rankStateMould[self.ranking]:setVisible(true)
		self.Text_ph_st:setVisible(false)
	else
		self.rankStateMould[1]:setVisible(false)
		self.Text_ph_st:setVisible(true)
		self.Text_ph_st:setString(self.ranking)
		self.Image_rank_normal:setVisible(true)
	end
	
	if self.ranking == 1 then
		self.Text_rank_exceList[self.m_type]:setVisible(true)
	else
		self.Text_rank_normalList[self.m_type]:setVisible(true)
	end
	self.Text_num_stars:setString(userCounts)
	self.Text_jjc_ph_name:setString(name)
	self:getRankReward()
end

-- 对象初始化
function ServiceCarnivalRankList:init(params)
	self.index = params.index
	self.m_type = params.mType
	self.activity = params.playerInfo
	self.curRewardInfos = params.reward
	if self.index <= 4 then
		self:onInit()
	end
	self:setContentSize(ServiceCarnivalRankList.__size)
	return self
end

function ServiceCarnivalRankList:onUpdateDraw()
	local root = self.roots[1]
	self.rankStateMould = {}
	self.Text_rank_normalList = {}
	self.Text_rank_exceList = {}
	-- 星级列表cell
	self.Panel_ph_list = ccui.Helper:seekWidgetByName(root, "Panel_ph_list")

	-- 第一名底板
	self.Image_rank_gold = ccui.Helper:seekWidgetByName(root, "Image_rank_gold")
	table.insert(self.rankStateMould , self.Image_rank_gold)

	-- 第二名底板
	self.Image_rank_silver = ccui.Helper:seekWidgetByName(root, "Image_rank_silver")
	table.insert(self.rankStateMould , self.Image_rank_silver)

	-- 第三名底板
	self.Image_rank_copper = ccui.Helper:seekWidgetByName(root, "Image_rank_copper")
	table.insert(self.rankStateMould , self.Image_rank_copper)
	-- 常规底板
	self.Image_rank_normal = ccui.Helper:seekWidgetByName(root, "Image_rank_normal")
	-- table.insert(self.rankStateMould , self.Image_rank_normal)
	for i = 1 , 3 do
		local Text_normal = ccui.Helper:seekWidgetByName(root , "Text_normal_weneben_"..i)
		table.insert(self.Text_rank_normalList , Text_normal)

		local Text_exce = ccui.Helper:seekWidgetByName(root , "Text_wenbenbiaoti_"..i)
		table.insert(self.Text_rank_exceList , Text_exce)
	end

	-- 排名名次
	self.Text_ph_st = ccui.Helper:seekWidgetByName(root, "Text_ph_st")

	-- 名字
	self.Text_jjc_ph_name = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_name")

	-- 排名獎勵
	self.ListView_rewards = ccui.Helper:seekWidgetByName(root, "ListView_rewards")

	-- 星级数量
	self.Text_num_stars = ccui.Helper:seekWidgetByName(root, "Text_num_stars")

	self.Button_touch_info = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_touch_info"), nil,
	{
		terminal_name = "service_carnival_ranklist_show_information",
		terminal_state = 0,
		isPressedActionEnabled = true,
		cells = self,
	}, nil, 0)	

	self:initDraw()
end

function ServiceCarnivalRankList:onEnterTransitionFinish()
	
end

function ServiceCarnivalRankList:onInit()
	-- 加载ServiceCarnivalRankListWindow界面资源.
	-- res.activity.service_carnival.service_carnival_rank_list.csd = res/activity/service_carnival/service_carnival_rank_list/csd.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/service_carnival/service_carnival_rank_list/csd.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/service_carnival/service_carnival_rank_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)

	if ServiceCarnivalRankList.__size == nil then
		ServiceCarnivalRankList.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function ServiceCarnivalRankList:clearUIInfo()
	local root = self.roots[1]
	if root == nil then
		return
	end
	-- 星级列表cell
	local Panel_ph_list = ccui.Helper:seekWidgetByName(root, "Panel_ph_list")
	Panel_ph_list:setVisible(false)
	-- 第一名底板
	local Image_rank_gold = ccui.Helper:seekWidgetByName(root, "Image_rank_gold")
	Image_rank_gold:setVisible(false)
	-- 第二名底板
	local Image_rank_silver = ccui.Helper:seekWidgetByName(root, "Image_rank_silver")
	Image_rank_silver:setVisible(false)
	-- 第三名底板
	local Image_rank_copper = ccui.Helper:seekWidgetByName(root, "Image_rank_copper")
	Image_rank_copper:setVisible(false)
	-- 常规底板
	local Image_rank_normal = ccui.Helper:seekWidgetByName(root, "Image_rank_normal")
	Image_rank_normal:setVisible(false)

	for i = 1 , 3 do
		local Text_normal = ccui.Helper:seekWidgetByName(root , "Text_normal_weneben_"..i)
		Text_normal:setVisible(false)

		local Text_exce = ccui.Helper:seekWidgetByName(root , "Text_wenbenbiaoti_"..i)
		Text_exce:setVisible(false)
	end
	-- 排名名次
	local Text_ph_st = ccui.Helper:seekWidgetByName(root, "Text_ph_st")
	Text_ph_st:setString("")
	-- 名字
	local Text_jjc_ph_name = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_name")
	Text_jjc_ph_name:setString("")

	-- 排名獎勵
	local ListView_rewards = ccui.Helper:seekWidgetByName(root, "ListView_rewards")
	ListView_rewards:removeAllItems()
	-- 星级数量
	local Text_num_stars = ccui.Helper:seekWidgetByName(root, "Text_num_stars")
	Text_num_stars:setString("")
end

function ServiceCarnivalRankList:onExit()
	-- 释放ServiceCarnivalRankListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/service_carnival/service_carnival_rank_list/csd.csb", root)
	-- ]]
end

function ServiceCarnivalRankList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self.isLoad = true
	self:onInit()
end

function ServiceCarnivalRankList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self.isLoad = false
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/service_carnival/service_carnival_rank_list/csd.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
