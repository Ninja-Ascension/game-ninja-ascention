--[[ ----------------------------------------------------------------------------
-- 救助排名页面
--]] ----------------------------------------------------------------------------
RescueStationRank = class("RescueStationRankClass", Window)

-- 打开窗口
local rescue_station_rank_window_open_terminal = {
	_name = "rescue_station_rank_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RescueStationRankClass") then
			fwin:open(RescueStationRank:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local rescue_station_rank_window_close_terminal = {
	_name = "rescue_station_rank_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RescueStationRankClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rescue_station_rank_window_open_terminal)
state_machine.add(rescue_station_rank_window_close_terminal)
state_machine.init()

-- 构造器
function RescueStationRank:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    app.load("client.cells.activity.rescue_station_rank_list")
	local function init_rescue_station_rank_terminal()
		-- 打开角色创建窗口
		local rescue_station_rank_open_terminal = {
			_name = "rescue_station_rank_open",
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
		local rescue_station_rank_close_terminal = {
			_name = "rescue_station_rank_close",
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
		local rescue_station_rank_show_terminal = {
			_name = "rescue_station_rank_show",
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
		local rescue_station_rank_hide_terminal = {
			_name = "rescue_station_rank_hide",
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

		 --请求排行榜
        local rescue_station_rank_check_enter_terminal = {
            _name = "rescue_station_rank_check_enter",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- La ventana pudo cerrarse antes de que llegara la respuesta.
                        if instance ~= nil and instance.onUpdateDraw ~= nil then
                            instance:onUpdateDraw()
                            instance:DrawMyinfo()
                        end
                    end
                end
                instance.starting_point = 1
                instance.end_point = 10
                protocol_command.activity_pockmon_rescue_get_cross_rank.param_list =instance.starting_point.."\r\n"..instance.end_point
                NetworkManager:register(protocol_command.activity_pockmon_rescue_get_cross_rank.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
         --刷新排行榜
        local rescue_station_update_rank_terminal = {
            _name = "rescue_station_update_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            instance.starting_point = instance.starting_point+10
                            instance.end_point = instance.end_point+10
                            instance:addnewlistCell()
                        end
                    end
                end
                
                if  tonumber(_ED.rescue_station_rank_info.size) >= 10 then
                    protocol_command.activity_pockmon_rescue_get_cross_rank.param_list = (instance.starting_point+10).."\r\n"..(instance.end_point+10)
                    NetworkManager:register(protocol_command.activity_pockmon_rescue_get_cross_rank.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --查看详情
		local rescue_station_rank_cell_check_terminal = {
            _name = "rescue_station_rank_cell_check",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
                app.load("client.l_digital.union.create.SmUnionInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cells = params._datas.cells
                if  tonumber(_ED.rescue_station_rank_info.size) == 0 then
                    return false
                end
                    local function responseShowUserInfoCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                local datainfo = response.node.activity
                                datainfo.icon = response.node.activity.headid
                                datainfo.name = response.node.activity.name
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
                    end
                    protocol_command.see_user_info.param_list = _ED.rescue_station_rank_info.rankInfo[1].info.userInfo
                    NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, cells, responseShowUserInfoCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(rescue_station_rank_open_terminal)
		state_machine.add(rescue_station_rank_close_terminal)
		state_machine.add(rescue_station_rank_show_terminal)
		state_machine.add(rescue_station_rank_hide_terminal)
        state_machine.add(rescue_station_rank_cell_check_terminal)
        state_machine.add(rescue_station_rank_check_enter_terminal)
        state_machine.add(rescue_station_update_rank_terminal)
		state_machine.init()
	end
	init_rescue_station_rank_terminal()
end

-- 对象初始化
function RescueStationRank:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RescueStationRank:onUpdateDraw()
	local root = self.roots[1]
	-- 列表
	self.Panel_league_table = ccui.Helper:seekWidgetByName(root, "Panel_league_table")
    self.Panel_league_table:removeAllItems()

    for k,v in pairs(_ED.rescue_station_rank_info.rankInfo) do
    	local cell =  state_machine.excute("rescue_station_rank_list_create",0,{v})
    	self.Panel_league_table:addChild(cell)
    end

    self.Panel_league_table:requestRefreshView()
    self.Panel_league_table:jumpToTop()
	-- 第一名头像
	self.Panel_station_rank_best_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_station_rank_best_player_icon")
    self.Panel_station_rank_best_player_icon:removeAllChildren(true)
    if  tonumber(_ED.rescue_station_rank_info.size) == 0 then
    	return
    end
    self.Panel_station_rank_best_player_icon:addChild(self:onHeadDraw(_ED.rescue_station_rank_info.rankInfo[1].info.headPic, _ED.rescue_station_rank_info.rankInfo[1].info.vipLevel))
	-- 第一名ID
	self.Text_station_rank_top_a = ccui.Helper:seekWidgetByName(root, "Text_station_rank_top_a")
    self.Text_station_rank_top_a:setString(_ED.rescue_station_rank_info.rankInfo[1].info.nickname)
	-- 第一名等级
	self.Text_station_rank_top_b = ccui.Helper:seekWidgetByName(root, "Text_station_rank_top_b")
    self.Text_station_rank_top_b:setString(_new_interface_text[103].._ED.rescue_station_rank_info.rankInfo[1].info.level)
	-- 第一名公会
	self.Text_station_rank_top_c = ccui.Helper:seekWidgetByName(root, "Text_station_rank_top_c")
    self.Text_station_rank_top_c:setString(_new_interface_text[104].._ED.rescue_station_rank_info.rankInfo[1].info.unionName)

end

function RescueStationRank:DrawMyinfo()
	local root = self.roots[1]
    
    local Image_my_rank_no = ccui.Helper:seekWidgetByName(root, "Image_my_rank_no")  --未上榜
    local Text_my_raning = ccui.Helper:seekWidgetByName(root, "Text_my_raning")  --自己排名
    
    local info =  json.decode(_ED.active_activity[159].activity_params)

    self.Text_my_ranking_info_b = ccui.Helper:seekWidgetByName(root, "Text_my_ranking_info_b") -- 自己服务器
    self.Text_my_ranking_info_b:setString(info.server_name)

    local Text_my_ranking_info_c =  ccui.Helper:seekWidgetByName(root, "Text_my_ranking_info_c") -- 自己积分

    if _ED.rescue_station_rank_info.myRank then
    	Text_my_raning:setString(_ED.rescue_station_rank_info.myRank.rank) 
    	Text_my_ranking_info_c:setString(_ED.rescue_station_rank_info.myRank.info.score)
        Image_my_rank_no:setVisible(false)
        Text_my_raning:setVisible(true)
    else
        Image_my_rank_no:setVisible(true)
        Text_my_ranking_info_c:setString(0)
        Text_my_raning:setVisible(false)
    end

   -- 自己角色名
	self.Text_my_ranking_info_a = ccui.Helper:seekWidgetByName(root, "Text_my_ranking_info_a")
	self.Text_my_ranking_info_a:getParent():removeChildByName("_richText2")
	self.Text_my_ranking_info_a:removeAllChildren(true)
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)
    local _width = self.Text_my_ranking_info_a:getContentSize().width == 0 and tonumber(self.Text_my_ranking_info_a:getFontSize())*7 or self.Text_my_ranking_info_a:getContentSize().width
    _richText2:setContentSize(cc.size(_width, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        color_Type_1 = cc.c3b(71,71,71)
        color_Type_2 = cc.c3b(71,71,71)
    else
        color_Type_1 = cc.c3b(255, 255, 0)
        color_Type_2 = cc.c3b(255, 255, 0)
    end
    local char_str = _ED.user_info.user_name
    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    char_str, 
    color_Type_1,
    color_Type_2,
    0, 
    0, 
    self.Text_my_ranking_info_a:getFontName(), 
    self.Text_my_ranking_info_a:getFontSize(),
    chat_rich_text_color)
    _richText2:formatTextExt()
    local rsize = _richText2:getContentSize()

    _richText2:setPosition(cc.p(self.Text_my_ranking_info_a:getPositionX() - _richText2:getContentSize().width / 2, self.Text_my_ranking_info_a:getPositionY() + _richText2:getContentSize().height / 2))
    _richText2:setName("_richText2")
    self.Text_my_ranking_info_a:getParent():addChild(_richText2)
end


function RescueStationRank:onHeadDraw(headIndex, vipLevel)
    -- local csbItem = csb.createNode("icon/item.csb")
    -- local roots = csbItem:getChildByName("root")
    local roots = cacher.createUIRef("icon/item.csb", "root")
    table.insert(self.roots, roots)
    roots:removeFromParent(true)
    -- self.item_order_level = ccui.Helper:seekWidgetByName(roots, "Label_l-order_level")--右下角等级
    -- if self.item_order_level._x == nil then
    --     self.item_order_level._x = self.item_order_level:getPositionX()
    -- end

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

function RescueStationRank:addnewlistCell()  --给排行榜添加
    local ListView_rank_list = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_league_table")
    local info = _ED.rescue_station_rank_info.rankInfo
    
    for i= 1,10 do   
        if info[i] ~= nil then
            local temp = {}
            temp = info[i]
            local cell = state_machine.excute("rescue_station_rank_list_create",0,{temp})
            ListView_rank_list:addChild(cell)
        end
    end
    ListView_rank_list:requestRefreshView()
end

function RescueStationRank:onEnterTransitionFinish()
	-- 加载RescueStationRankWindow界面资源.
	-- res.activity.rescue_station_rank = res/activity/rescue_station_rank.csb
	local csbNode = csb.createNode("activity/rescue_station/rescue_station_rank.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 查看详情按钮
	self.Button_station_rank_details = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_station_rank_details"), nil,
	{
		terminal_name = "rescue_station_rank_cell_check",
		terminal_state = 0,
		isPressedActionEnabled = true,
		cells = self,
	}, nil, 0)	

	-- 关闭
	self.Button_phb_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_phb_back"), nil,
	{
		terminal_name = "rescue_station_rank_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
    
    -- 刷新
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_re"), nil,
    {
        terminal_name = "rescue_station_rank_check_enter",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    state_machine.excute("rescue_station_rank_check_enter",0,nil)
		
	--排行榜
    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.bounceBottom then--6
            --滑到头
           state_machine.excute("rescue_station_update_rank", 0,nil)
        end
    end
    local Panel_league_table = ccui.Helper:seekWidgetByName(root, "Panel_league_table")
    Panel_league_table:addScrollViewEventListener(scrollViewEvent)
	
end

function RescueStationRank:onExit()
	-- 释放RescueStationRankWindow界面资源.
	state_machine.remove("rescue_station_rank_open")
	state_machine.remove("rescue_station_rank_close")
	state_machine.remove("rescue_station_rank_show")
	state_machine.remove("rescue_station_rank_hide")
end

function RescueStationRank:close()
	-- window event : close.
	
end

function RescueStationRank:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
