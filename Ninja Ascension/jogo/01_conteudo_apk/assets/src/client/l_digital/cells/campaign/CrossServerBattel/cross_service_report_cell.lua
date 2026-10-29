----------------------------------------------------------------------------------------------------
-- 说明：跨服矿战 战报 单元项 / sm商城道具购买单元项
----------------------------------------------------------------------------------------------------
CrossServiceReportCell = class("CrossServiceReportCellClass", Window)
CrossServiceReportCell.__size = nil

function CrossServiceReportCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.actions = {}
	
	-- 初始化道具小图标事件响应需要使用的状态机
	local function cross_server_battel_report_list_cell_terminal()
	--使用按钮的点击
		local cross_server_battel_report_revenge_terminal = {
            _name = "cross_server_battel_report_revenge",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelGrabOtherFormation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if tonumber(_ED.cross_server_battel_map_rob_info.revengeCount.freeTime) <= 0 then
            		local needData = zstring.split(dms.string(dms["gvg_config"], 14, gvg_config.param), ",")
            		local buy_times = zstring.tonumber(_ED.cross_server_battel_map_rob_info.revengeCount.buyCount)
            		local _price = 0
            		if buy_times > #needData then
            			_price = tonumber(needData[#needData])
            		else
            			_price = needData[buy_times + 1]
            		end
            		local callback = "cross_server_battel_report_revenge_buy_confirm"
                   	state_machine.excute("buy_confirm_tip_open", 0, {1, _price, tipStringInfo_cross_server_battel_tips[20], callback, params._datas, tipStringInfo_cross_server_battel_tips[31]})
            	else
            		--进入复仇逻辑
                    state_machine.excute("cross_server_battel_grab_other_formation_open",0, params)
                    
            	end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_report_revenge_buy_confirm_terminal = {
            _name = "cross_server_battel_report_revenge_buy_confirm",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local function responseCrossServerBattelInitCallback(response)
		            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		                TipDlg.drawTextDailog(_string_piece_info[76])
						app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelReport")
						state_machine.excute("cross_server_battel_report_revenge_count_update",0,"")
		            end
		        end
		        protocol_command.cross_mine_buy_loot_or_revenge.param_list = 2
		        NetworkManager:register(protocol_command.cross_mine_buy_loot_or_revenge.code, nil, nil, nil, nil, responseCrossServerBattelInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_report_replay_terminal = {
            _name = "cross_server_battel_report_replay",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell

            	-- 进入回放战斗
                local index = cell.index + 1
                local reportInfo = params._datas._cell.reportInfo
                local is_win = params._datas._cell.is_win
                -- debug.print_r(reportInfo, "进入回放战斗")

                _ED.cross_server_battel_grab_other_formation2 = {}
                _ED.cross_server_battel_grab_other_formation2.index = index

                _ED.cross_server_battel_grab_other_formation2.BattleResult = reportInfo.battleResult
                --失败 胜利场次默认给0
                if not is_win then
                   _ED.cross_server_battel_grab_other_formation2.BattleResult = 0 
                end

                _ED.cross_server_battel_ui_attackers = reportInfo.attackShipInfo
                _ED.cross_server_battel_ui_defenders = reportInfo.byAttackShipInfo

                -- 服务器名称，排行，资源产出速度，抢夺的资源数
                _ED.cross_server_battel_ui_result = {}
                _ED.cross_server_battel_ui_result.serverName1 = _ED.cross_server_battel_all_servers[tonumber(_ED.cross_server_battel_map_info.realServerId)]
                _ED.cross_server_battel_ui_result.serverName2 = _ED.cross_server_battel_all_servers[reportInfo.byLootServerId]
                _ED.cross_server_battel_ui_result.rank1 = reportInfo.lootUserRank
                _ED.cross_server_battel_ui_result.rank2 = reportInfo.byLootUserRank
                _ED.cross_server_battel_ui_result.lootProduction = reportInfo.lootProduction
                _ED.cross_server_battel_ui_result.byLootProduction = reportInfo.byLootProduction
                _ED.cross_server_battel_ui_result.canLootMineNum = reportInfo.lootMineNum

                -- local function callback(response)
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         fwin:cleanView(fwin._windows)
                --         fwin:freeAllMemeryPool()

                --         -- 记录三场的输赢情况
                --         _ED.cross_server_battel_result = {}
                --         table.insert(_ED.cross_server_battel_result, _ED.attackData.isWin)

                --         app.load("client.battle.BattleStartEffect")
                --         app.load("client.battle.fight.FightEnum")

                --         local bse = BattleStartEffect:new()
                --         bse:init(_enum_fight_type._fight_type_214)
                --         fwin:open(bse, fwin._windows)
                --     end
                -- end

                -- protocol_command.cross_mine_load_battle_info.param_list = index .. "\r\n" .. 1
                -- NetworkManager:register(protocol_command.cross_mine_load_battle_info.code, nil, nil, nil, self, callback, false, nil)


                local function callback3(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- print("跨服回放请求完毕")

                        -- 初始第一场的数据
                        _ED.battleData = _ED.crossServer_battleData[1]
                        _ED.attackData = _ED.crossServer_attackData[1]
                        _ED.battleData._battle_start_influence_info = _ED.crossServer_battle_start_influence_info[1]
                        _ED.battleData._battle_round_influence_infos = _ED.crossServer_battle_round_influence_infos[1]
                        _ED.battleData._camp_change_influence_infos = _ED.crossServer_start_influence_info[1]

                        -- 记录三场的输赢情况
                        _ED.cross_server_battel_result = {}
                        table.insert(_ED.cross_server_battel_result, _ED.attackData.isWin)

                        fwin:cleanView(fwin._windows)
                        fwin:freeAllMemeryPool()

                        app.load("client.battle.BattleStartEffect")
                        app.load("client.battle.fight.FightEnum")

                        local bse = BattleStartEffect:new()
                        bse:init(_enum_fight_type._fight_type_214)
                        fwin:open(bse, fwin._windows)

                    end
                end

                local function callback2(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        protocol_command.cross_mine_load_battle_info.param_list = _ED.cross_server_battel_grab_other_formation2.index .. "\r\n" .. 3
                        NetworkManager:register(protocol_command.cross_mine_load_battle_info.code, nil, nil, nil, self, callback3, false, nil)
                    end
                end

                local function callback1(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        protocol_command.cross_mine_load_battle_info.param_list = _ED.cross_server_battel_grab_other_formation2.index .. "\r\n" .. 2
                        NetworkManager:register(protocol_command.cross_mine_load_battle_info.code, nil, nil, nil, self, callback2, false, nil)
                    end
                end

                -- print("开始请求跨服回放")

                -- 清空跨服战的战斗数据缓存
                _ED.crossServer_battleData = {}
                _ED.crossServer_attackData = {}
                _ED.crossServer_battle_start_influence_info = {}
                _ED.crossServer_battle_round_influence_infos = {}
                _ED.crossServer_start_influence_info = {}

                protocol_command.cross_mine_load_battle_info.param_list = _ED.cross_server_battel_grab_other_formation2.index .. "\r\n" .. 1
                NetworkManager:register(protocol_command.cross_mine_load_battle_info.code, nil, nil, nil, self, callback1, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(cross_server_battel_report_revenge_terminal)
		state_machine.add(cross_server_battel_report_revenge_buy_confirm_terminal)
        state_machine.add(cross_server_battel_report_replay_terminal)
        state_machine.init()
	end
	cross_server_battel_report_list_cell_terminal()
end


function CrossServiceReportCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
	local Text_name_lv = ccui.Helper:seekWidgetByName(root, "Text_name_lv")
	local Text_cross_me_n = ccui.Helper:seekWidgetByName(root, "Text_cross_me_n")
	local Text_time = ccui.Helper:seekWidgetByName(root, "Text_cross_service_report_time")
    local Image_win = ccui.Helper:seekWidgetByName(root, "Image_win")
    local Image_lose = ccui.Helper:seekWidgetByName(root, "Image_lose")
    local Image_up = ccui.Helper:seekWidgetByName(root, "Image_up")
    local Image_down = ccui.Helper:seekWidgetByName(root, "Image_down")
    local Text_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rank_n")

	local left_time = (_ED.system_time + (os.time() - _ED.native_time)) - zstring.tonumber(self.reportInfo.lootTimeStemp)/1000
    local time_string = ""
    if math.floor(tonumber(left_time)/3600) >= 1 then
        time_string = math.floor(tonumber(left_time)/3600) .. tipStringInfo_time_info[5]
    end
    time_string = time_string .. math.floor((tonumber(left_time)%3600)/60) .. tipStringInfo_time_info[6]
	
    -- if left_time < 1 then left_time = 1 end
    local user_info = self.is_my and self.reportInfo.lootUserInfo or self.reportInfo.byLootUserInfo
	Panel_player_icon:addChild(self:onHeadDraw(user_info.headPic, user_info.vipLevel))
	Text_name_lv:setString(string.format(tipStringInfo_cross_server_battel_tips[16], tonumber(user_info.level), user_info.nickName))
    local mine_num = self.reportInfo.lootMineNum
    if tonumber(mine_num) > 0 then
        mine_num = self.is_win and mine_num or tonumber(self.reportInfo.lootMineNum)*-1
    end
	Text_cross_me_n:setString(mine_num)
	if tonumber(mine_num) >= 0 then
		Text_cross_me_n:setColor(cc.c3b(0,166,255))
	else
		Text_cross_me_n:setColor(cc.c3b(255,0,0))
	end
	
	Text_time:setString(string.format(tipStringInfo_cross_server_battel_tips[17], time_string))

    Image_win:setVisible(self.is_win)
    Image_lose:setVisible(not self.is_win)
    Image_up:setVisible(self.rank_change > 0)
    Image_down:setVisible(self.rank_change < 0)
    Text_rank_n:setVisible(self.rank_change ~= 0)

    Text_rank_n:setString(self.rank_change)
    if tonumber(self.rank_change) >= 0 then
        Text_rank_n:setColor(cc.c3b(0,166,255))
    else
        Text_rank_n:setColor(cc.c3b(255,0,0))
    end
end

function CrossServiceReportCell:onHeadDraw(headIndex, vipLevel)
    -- local csbItem = csb.createNode("icon/item.csb")
    -- local roots = csbItem:getChildByName("root")
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
    local quality_path = 0
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
    Panel_head:setTouchEnabled(false)
    return roots
end

function CrossServiceReportCell:onInit()
    local root = cacher.createUIRef("campaign/cross_service/cross_service_report_cell.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	-- local panel = ccui.Helper:seekWidgetByName(root, "Panel_5")
	local panel_size = root:getContentSize()
	self:onUpdateDraw()
	self:setContentSize(panel_size)
	if CrossServiceReportCell.__size == nil then
		CrossServiceReportCell.__size = panel_size
	end
    local Button_revenge = ccui.Helper:seekWidgetByName(root, "Button_revenge")
    Button_revenge:setVisible(self.is_my)
	-- 复仇
    fwin:addTouchEventListener(Button_revenge, nil, 
    {
        terminal_name = "cross_server_battel_report_revenge", 
        terminal_state = 0,
        open_type = 2,
        user_info = self.reportInfo,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 回放
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_replay"), nil, 
    {
        terminal_name = "cross_server_battel_report_replay", 
        terminal_state = 0,
        _cell = self, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function CrossServiceReportCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function CrossServiceReportCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/cross_service/cross_service_report_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function CrossServiceReportCell:clearUIInfo( ... )
    local root = self.roots[1]
	local Text_name_lv = ccui.Helper:seekWidgetByName(root, "Text_name_lv")
	local Text_cross_me_n = ccui.Helper:seekWidgetByName(root, "Text_cross_me_n")
	local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
	local Text_time = ccui.Helper:seekWidgetByName(root, "Text_cross_service_report_time")

	if Text_name_lv ~= nil then
		Text_name_lv:setString("")
		Text_cross_me_n:setString("")
		Panel_player_icon:removeAllChildren(true)
		Text_time:setString("")
	end

    local Image_win = ccui.Helper:seekWidgetByName(root, "Image_win")
	if Image_win ~= nil then
		Image_win:setVisible(false)
	end

	local Image_lose = ccui.Helper:seekWidgetByName(root, "Image_lose")
	if Image_lose ~= nil then
		Image_lose:setVisible(false)
	end
end

function CrossServiceReportCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/cross_service/cross_service_report_cell.csb", self.roots[1])
end

function CrossServiceReportCell:init(params)
    self.index = params[1]
	self.reportInfo = params[2]
    self.reportInfo.other_index = self.index
    self.is_win = false
    if tonumber(self.reportInfo.byLootUserInfo.userId) == tonumber(_ED.user_info.user_id)
        and tonumber(self.reportInfo.byLootUserInfo.serverId) == tonumber(self.reportInfo.realServerNumber) then
        self.is_my = true
        if tonumber(self.reportInfo.battleResult) >= 2 then
            self.is_win = false
            self.rank_change = -(tonumber(self.reportInfo.rankChangeNum))
        else
            self.is_win = true
            self.rank_change = (tonumber(self.reportInfo.rankChangeNum))
        end
    else
        self.is_my = false
        if tonumber(self.reportInfo.battleResult) >= 2 then
            self.is_win = true
            self.rank_change = (tonumber(self.reportInfo.rankChangeNum))
        else
            self.is_win = false
            self.rank_change = -(tonumber(self.reportInfo.rankChangeNum))
        end
    end

    self:onInit()
	if CrossServiceReportCell.__size then
		self:setContentSize(CrossServiceReportCell.__size)
	end
end

function CrossServiceReportCell:createCell()
	local cell = CrossServiceReportCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


