--[[ ----------------------------------------------------------------------------
-- 荣耀榜界面
--]] ----------------------------------------------------------------------------
SmRankingHonor = class("SmRankingHonorClass", Window)

-- 打开窗口
local sm_ranking_honor_window_open_terminal = {
	_name = "sm_ranking_honor_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if funOpenDrawTip(168) == true then
            return false
        end

		if nil == fwin:find("SmRankingHonorClass") then
			fwin:open(SmRankingHonor:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local sm_ranking_honor_window_close_terminal = {
	_name = "sm_ranking_honor_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmRankingHonorClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_ranking_honor_window_open_terminal)
state_machine.add(sm_ranking_honor_window_close_terminal)
state_machine.init()

-- 构造器
function SmRankingHonor:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.playerUIList = {}		-- 玩家UI列表
	self.playerInfoList = {}	-- 玩家信息列表
	self.curUserData = {}		-- 当前玩家信息

	self.SHOWNUMBER = 3			-- 只展示前三名

	-- load lua files.
	app.load("client.l_digital.system.SmRankingMainInterface")
	app.load("client.l_digital.player.SmNewPlayerInfo.lua")
	-- Initialize sm ranking honor page state machine.
	local function init_sm_ranking_honor_terminal()
		-- 打开角色创建窗口
		local sm_ranking_honor_open_terminal = {
			_name = "sm_ranking_honor_open",
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
		local sm_ranking_honor_close_terminal = {
			_name = "sm_ranking_honor_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("sm_ranking_honor_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local sm_ranking_honor_show_terminal = {
			_name = "sm_ranking_honor_show",
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
		local sm_ranking_honor_hide_terminal = {
			_name = "sm_ranking_honor_hide",
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

		-- 打开玩家详情界面
		local sm_ranking_honor_open_player_info_terminal = {
			_name = "sm_ranking_honor_open_player_info",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 打开玩家详情界面
				if nil ~= instance then
					local userData = params._datas.userData
					instance.curUserData = userData
					local userID = userData.user_id
					
					OpenOtherUserInformation(userID, nil, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开完整榜单界面
		local sm_ranking_honor_open_complete_rank_terminal = {
			_name = "sm_ranking_honor_open_complete_rank",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 打开完整榜单界面
				if nil ~= instance then
					-- 需要判断当前王者之战是否有数据
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								state_machine.excute("sm_ranking_main_interface_open", 0, nil)
							end
						end
					end
					
					local m_type = 7
					local number = 1
					protocol_command.order_get_info.param_list = m_type.."\r\n".."1".."\r\n"..number
					NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(sm_ranking_honor_open_terminal)
		state_machine.add(sm_ranking_honor_close_terminal)
		state_machine.add(sm_ranking_honor_show_terminal)
		state_machine.add(sm_ranking_honor_hide_terminal)
		state_machine.add(sm_ranking_honor_open_player_info_terminal)
		state_machine.add(sm_ranking_honor_open_complete_rank_terminal)
		state_machine.init()
	end
	-- call func init sm ranking honor state machine.
	init_sm_ranking_honor_terminal()
end

function SmRankingHonor:initPlayerData()
	self.playerInfoList = {}
	for i = 1, self.SHOWNUMBER do
		local playerInfo = _ED.fight_ranks.other_user[i]
		table.insert(self.playerInfoList, playerInfo)
	end
end

function SmRankingHonor:drawPlayerUI()
	for i, v in ipairs(self.playerUIList) do
		local playerInfo = self.playerInfoList[i]
		v.textName:setString(playerInfo.user_name)
		v.textCr:setString(playerInfo.user_fight)
		
		local titleIndex = zstring.tonumber(playerInfo.user_rank_title_name)
		if nil ~= titleIndex and titleIndex > 0 then
			local titlePicID = dms.string(dms["title_param"], titleIndex, title_param.pic_index)
			local titlePath = string.format("images/ui/text/title/title_%s.png", titlePicID)
			if true == cc.FileUtils:getInstance():isFileExist(titlePath) then
				v.panelTitle:setBackGroundImage(titlePath)
			end
			v.panelTitle:setVisible(true)
		else
			v.panelTitle:setVisible(false)
		end

		local temp_bust_index = playerInfo.imageID
		local jsonFile = string.format("sprite/spirte_%s.json", temp_bust_index)

		if true == cc.FileUtils:getInstance():isFileExist(jsonFile) then
			local armature_hero = sp.spine_sprite(v.panelRole, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			armature_hero:setScaleX(-1)
			armature_hero.animationNameList = spineAnimations
			sp.initArmature(armature_hero, true)
		end
	end
end

-- 对象初始化
function SmRankingHonor:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function SmRankingHonor:drawBtns()
	local root = self.roots[1]

	-- 完整榜单按钮
	self.Button_ranking = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ranking"), nil,
	{
		terminal_name = "sm_ranking_honor_open_complete_rank",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭界面按钮
	self.Button_phb_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_phb_back"), nil,
	{
		terminal_name = "sm_ranking_honor_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
end

function SmRankingHonor:onUpdateDraw()
	local root = self.roots[1]

	-- 特效容器
	self.Panel_effect_1 = ccui.Helper:seekWidgetByName(root, "Panel_effect_1")

	self.playerUIList = {}
	for i = 1, self.SHOWNUMBER do
		local playerUI = {}
		-- panel父节点
		playerUI.panelRank = ccui.Helper:seekWidgetByName(root, "Panel_rank_"..i)
		-- 称号图片容器
		playerUI.panelTitle = ccui.Helper:seekWidgetByName(root, "Panel_title_"..i)
		playerUI.panelTitle:removeBackGroundImage()
		-- 玩家名称文本
		playerUI.textName = ccui.Helper:seekWidgetByName(root, "Text_name_"..i)
		-- 形象容器
		playerUI.panelRole = ccui.Helper:seekWidgetByName(root, "Panel_role_"..i)
		playerUI.panelRole:removeAllChildren(true)
		-- 战斗力文本
		playerUI.textCr = ccui.Helper:seekWidgetByName(root, "Text_cr_"..i)

		fwin:addTouchEventListener(playerUI.panelRole, nil, 
			{
				terminal_name = "sm_ranking_honor_open_player_info",
				terminal_state = 0, 
				isPressedActionEnabled = true,
				userData = self.playerInfoList[i]
			},
		nil,0)
		
		table.insert(self.playerUIList, playerUI)
	end

	self.Panel_effect_1:removeAllChildren(true)
	local jsonFile = "images/ui/effice/effect_ranking_honor/effect_ranking_honor.json"
	local atlasFile = "images/ui/effice/effect_ranking_honor/effect_ranking_honor.atlas"
	if true == cc.FileUtils:getInstance():isFileExist(jsonFile) then 
		local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation:setPosition(cc.p(self.Panel_effect_1:getContentSize().width / 2, self.Panel_effect_1:getContentSize().height / 2))
		self.Panel_effect_1:addChild(animation)
	end
end

function SmRankingHonor:onEnterTransitionFinish()
	-- 加载SmRankingHonorWindow界面资源.
	-- system.sm_ranking_honor = system/sm_ranking_honor.csb
	local csbNode = csb.createNode("system/sm_ranking_honor.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	self:initPlayerData()
	self:drawBtns()
	self:onUpdateDraw()
	self:drawPlayerUI()
end

function SmRankingHonor:onExit()
	-- 释放SmRankingHonorWindow界面资源.
	state_machine.remove("sm_ranking_honor_open")
	state_machine.remove("sm_ranking_honor_close")
	state_machine.remove("sm_ranking_honor_show")
	state_machine.remove("sm_ranking_honor_hide")
	state_machine.remove("sm_ranking_honor_open_player_info")
	state_machine.remove("sm_ranking_honor_open_complete_rank")
	
end

function SmRankingHonor:close()
	-- window event : close.
	
end

function SmRankingHonor:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
