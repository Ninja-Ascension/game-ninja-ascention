-----------------------------
-- 天赋详情界面
-----------------------------
SmTalentDetailInfo = class("SmTalentDetailInfoClass", Window)

--打开界面
local sm_talent_detail_info_open_terminal = {
	_name = "sm_talent_detail_info_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmTalentDetailInfoClass") == nil then
			fwin:open(SmTalentDetailInfo:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_talent_detail_info_close_terminal = {
	_name = "sm_talent_detail_info_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmTalentDetailInfoClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_talent_detail_info_open_terminal)
state_machine.add(sm_talent_detail_info_close_terminal)
state_machine.init()

function SmTalentDetailInfo:ctor()
	self.super:ctor()
	self.roots = {}
	self.table_mould = 0
	self.isLock = false
	self.page = 0 -- 所属进化树
	self.silverIsEnough = true
	self.talentPointIsEnough = true
    
    local function init_sm_battleof_kings_terminal()
		--
		local sm_talent_up_grade_request_terminal = {
            _name = "sm_talent_up_grade_request",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function requestCallBack(response)
		            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		            	if response.node ~= nil and response.node.roots ~= nil then
		        			-- state_machine.excute("sm_talent_main_window_updata",0,"sm_talent_main_window_updata.")
		        			state_machine.excute("sm_talent_main_up_updata",0,"sm_talent_main_up_updata.")
		        			if self.page == 1 then
		        				state_machine.excute("sm_talent_page_one_update",0,"sm_talent_page_one_update.")
		        				state_machine.excute("sm_talent_page_two_update",0,"sm_talent_page_two_update.")
	        				elseif self.page == 2 then
	        					state_machine.excute("sm_talent_page_two_update",0,"sm_talent_page_two_update.")
	        					state_machine.excute("sm_talent_page_three_update",0,"sm_talent_page_three_update.")
        					elseif self.page == 3 then
        						state_machine.excute("sm_talent_page_three_update",0,"sm_talent_page_three_update.")
        						state_machine.excute("sm_talent_page_four_update",0,"sm_talent_page_four_update.")
        					elseif self.page == 4 then
        						state_machine.excute("sm_talent_page_four_update",0,"sm_talent_page_four_update.")
        					end
		        			response.node:onUpdateDraw()
		        			smFightingChange()
		        		else
		        			state_machine.unlock("sm_talent_up_grade_request")
		        		end
		        	else
		        		state_machine.unlock("sm_talent_up_grade_request")
		            end
		        end

		        if self.silverIsEnough == false then
		        	-- app.load("client.utils.SmBuySilverCoins")
		        	-- state_machine.excute("sm_buy_silver_coinsopen", 0, 0)
		        	app.load("client.packs.hero.HeroPatchInformationPageGetWay")
					local fightWindow = HeroPatchInformationPageGetWay:new()
					fightWindow:init(0,6)
					fwin:open(fightWindow, fwin._windows)
		        	return
		        end

		        if self.talentPointIsEnough == false then
		        	-- app.load("client.utils.silver.SilverToGet")
		        	-- state_machine.excute("silver_to_get_open",0,34)
		        	return
		        end
		        state_machine.lock("sm_talent_up_grade_request")
		        protocol_command.ship_talent_level_up.param_list = instance.table_mould
		        NetworkManager:register(protocol_command.ship_talent_level_up.code, nil, nil, nil, instance, requestCallBack, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_talent_up_grade_refresh_terminal = {
			_name = "sm_talent_up_grade_refresh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:onUpdateDraw()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local sm_talent_up_grade_open_one_key_up_windows_terminal = {
			_name = "sm_talent_up_grade_open_one_key_up_windows",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local page = self.page
				local talent_mould = self.table_mould

				-- 金币
				local user_silver = zstring.tonumber(_ED.user_info.user_silver)

				--属性
				local needGroup = dms.searchs(dms["ship_talent_param"], ship_talent_param.need_mould, self.table_mould)

				local currTalent = _ED.digital_talent_already_add[""..self.table_mould]
				local curLvl = 0
				if currTalent == nil then
					curLvl = 0
				else
					curLvl = tonumber(currTalent.level)
				end
				curLvl = curLvl + 1

				local needGoldCoinCount = 0
				local haveEnoughCoin = false

				for _, v in pairs(needGroup) do
					if tonumber(v[3]) >= curLvl then
						local needProp = zstring.splits(v[4] , "|", ",")
						local goldCoinCount = tonumber(needProp[1][3])

						needGoldCoinCount = needGoldCoinCount + goldCoinCount

						if needGoldCoinCount <= user_silver then
							haveEnoughCoin = true
							break
						end
					end
				end

				--  金币足够就跳转一键升级界面
				if haveEnoughCoin then
					state_machine.excute("sm_talent_one_key_up_window_open", 0, {page, talent_mould})
				else
					app.load("client.packs.hero.HeroPatchInformationPageGetWay")
					local fightWindow = HeroPatchInformationPageGetWay:new()
					fightWindow:init(0,6)
					fwin:open(fightWindow, fwin._windows)
				end

				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

        state_machine.add(sm_talent_up_grade_request_terminal)
        state_machine.add(sm_talent_up_grade_refresh_terminal)
        state_machine.add(sm_talent_up_grade_open_one_key_up_windows_terminal)
        state_machine.init()
    end
    init_sm_battleof_kings_terminal()
end

function SmTalentDetailInfo:onUpdateDraw()
    local root = self.roots[1]
    local table_data = dms.element(dms["ship_talent_mould"] , self.table_mould)
    --图标
    local Panel_tf_icon = ccui.Helper:seekWidgetByName(root,"Panel_tf_icon")
    Panel_tf_icon:removeAllChildren(true)
    local imageIndex = dms.atoi(table_data , ship_talent_mould.icon)
    if imageIndex < 10 then
        imageIndex = "0"..imageIndex
    end
    local spriteImage = string.format("images/ui/talent_icon/talent_icon_%s.png", ""..imageIndex)
    local currSprite = cc.Sprite:create(spriteImage)
    currSprite:setAnchorPoint(0,0)
    Panel_tf_icon:addChild(currSprite)
    --名称
    local Text_tf_name = ccui.Helper:seekWidgetByName(root,"Text_tf_name")
    Text_tf_name:setString(dms.atos(table_data , ship_talent_mould.name)) 
    --等级
	local Text_tf_lv_n = ccui.Helper:seekWidgetByName(root,"Text_tf_lv_n")
	local currLv = 0
	local maxLv = dms.atoi(table_data , ship_talent_mould.max_lv)
	local currTalent = _ED.digital_talent_already_add[""..self.table_mould]
    if currTalent == nil then
        currLv = 0
    else
    	currLv = tonumber(currTalent.level)
    end
	Text_tf_lv_n:setString(currLv.."/"..maxLv)
    --属性
	local needGroup = dms.searchs(dms["ship_talent_param"], ship_talent_param.need_mould, self.table_mould)
    local virtueLv = currLv
    if virtueLv > maxLv then
    	virtueLv = maxLv
    end
	local nextData = {}
	for j , k in pairs(needGroup) do
		if tonumber(k[3]) == virtueLv then
			nextData = k
			break
		end
	end
	if #nextData > 0 then
	    local virtue = zstring.split(nextData[ship_talent_param.describe] , "|")
	    for i = 1 , 3 do
	    	local Text_tf_info = ccui.Helper:seekWidgetByName(root,"Text_tf_info_"..i)
	    	if virtue[i] == nil or virtue[i] == "" then
	    		Text_tf_info:setString("")
	    	else
	    		Text_tf_info:setString(virtue[i])
	    	end
	    end
	else
		ccui.Helper:seekWidgetByName(root,"Text_tf_info_1"):setString(_new_interface_text[213])
	end
	local virtueLv = currLv + 1
    if virtueLv > maxLv then
    	virtueLv = maxLv
    end
	local nextData = {}
	for j , k in pairs(needGroup) do
		if tonumber(k[3]) == virtueLv then
			nextData = k
			break
		end
	end
    --是否开启
    local Panel_no_open = ccui.Helper:seekWidgetByName(root,"Panel_no_open")
    local Panel_open = ccui.Helper:seekWidgetByName(root,"Panel_open")
	Panel_open:setVisible(false)
	Panel_no_open:setVisible(false)
	if self.isLock == true then
		display:gray(currSprite)
		Panel_no_open:setVisible(true)
    	local Text_kqtj_1 = ccui.Helper:seekWidgetByName(root,"Text_kqtj_1")
    	local Text_kqtj_2 = ccui.Helper:seekWidgetByName(root,"Text_kqtj_2")
		if _ED.digital_talent_page_is_lock[self.page] == true then
			Text_kqtj_1:setString(_new_interface_text[147])
		else
			local lockString = dms.atos(table_data , ship_talent_mould.unlock_condition)
			local unLockData = zstring.split(lockString ,"|")
			for i , v in pairs(unLockData) do
                local needData = zstring.split(v , ",")
                if tonumber(needData[1]) == 1 then -- 等级判定
                    Text_kqtj_1:setString(string.format( _new_interface_text[148],tonumber(needData[2])))
                    if tonumber(_ED.user_info.user_grade) >= tonumber(needData[2]) then
                        Text_kqtj_1:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
                    end
                else
                	local islock = false
                	local currLv = 0
                	local needLv = tonumber(needData[3])
                    local needTalent = _ED.digital_talent_already_add[""..needData[2]]
                    if needTalent == nil then
                        islock = true
                        currLv = 0
                    else
                    	currLv = tonumber(needTalent.level)
                    	if tonumber(needTalent.level) < tonumber(needData[3]) then
	                        islock = true
	                    end
                    end
                    local name = dms.string(dms["ship_talent_mould"] , tonumber(needData[2]),ship_talent_mould.name)
                    Text_kqtj_2:setString(string.format( _new_interface_text[149], name, needLv, currLv, needLv))
                    if islock == false then
                        Text_kqtj_2:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
                    end
                end
            end
		end
	else
		display:ungray(currSprite)
		Panel_open:setVisible(true)
		--是否满级
		local Text_tf_lv_max = ccui.Helper:seekWidgetByName(root,"Text_tf_lv_max")
		local Panel_btn = ccui.Helper:seekWidgetByName(root,"Panel_btn")
		Text_tf_lv_max:setVisible(false)
		Panel_btn:setVisible(false)
		if currLv >= maxLv then
			Text_tf_lv_max:setVisible(true)
		else
			Panel_btn:setVisible(true)
			--升级消耗
			local Text_jinbi = ccui.Helper:seekWidgetByName(root,"Text_jinbi")
			local Text_tfd = ccui.Helper:seekWidgetByName(root,"Text_tfd")
			local needData = zstring.split(nextData[4] , "|")
			for i = 1 , 2 do
				local need = zstring.split(needData[i] , ",")
				if tonumber(need[1]) == 1 then
					Text_jinbi:setString(need[3])
					if tonumber(need[3]) > zstring.tonumber(_ED.user_info.user_silver) then
						Text_jinbi:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3])) 
						self.silverIsEnough = false
					end
				else
					Text_tfd:setString(need[3])
					if tonumber(need[3]) > zstring.tonumber(_ED.user_info.talent_point) then
						self.talentPointIsEnough = false
						Text_tfd:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
					end
				end
			end 
		end
	end
	state_machine.unlock("sm_talent_up_grade_request")

	local Button_lv_up = ccui.Helper:seekWidgetByName(root,"Button_lv_up")
	local Button_lv_up_0 = ccui.Helper:seekWidgetByName(root,"Button_lv_up_0")

	-- 按钮是否灰化 只需要判断升到下一级的天赋点是否足够
	if self.talentPointIsEnough == false then
		Button_lv_up:setTouchEnabled(false)
		Button_lv_up:setBright(false)

		Button_lv_up_0:setTouchEnabled(false)
		Button_lv_up_0:setBright(false)
	else
		Button_lv_up:setTouchEnabled(true)
		Button_lv_up:setBright(true)

		Button_lv_up_0:setTouchEnabled(true)
		Button_lv_up_0:setBright(true)
	end

	-- 第2
	local unlock_lv = dms.string(dms["ship_talent_group"], 2, ship_talent_group.unlock_lv)
	local gradeStr = zstring.splits(unlock_lv, "|", ",")
	local grade = tonumber(gradeStr[1][2])
	-- 第2个天赋树开启时 开启一键升级
	Button_lv_up_0:setVisible(zstring.tonumber(_ED.user_info.user_grade) >= grade)
end

function SmTalentDetailInfo:init(params)
	self.table_mould = params[1]
	self.page = tonumber(params[2])
	self.isLock = params[3]
	self:setTouchEnabled(true)
	self:onInit()
    return self
end

function SmTalentDetailInfo:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_talent_window.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "sm_talent_detail_info_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_lv_up"), nil, 
    {
        terminal_name = "sm_talent_up_grade_request", 
        terminal_state = 0, 
        touch_black = true,
    }, nil)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_lv_up_0"), nil, 
    {
        terminal_name = "sm_talent_up_grade_open_one_key_up_windows", 
        terminal_state = 0, 
        touch_black = true,
    }, nil)
    
	self:onUpdateDraw()
end

function SmTalentDetailInfo:onEnterTransitionFinish()
    
end


function SmTalentDetailInfo:onExit()
	state_machine.remove("sm_talent_up_grade_request")
	state_machine.remove("sm_talent_up_grade_refresh")
	state_machine.remove("sm_talent_up_grade_open_one_key_up_windows")
end

