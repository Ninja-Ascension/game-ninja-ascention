-- ----------------------------------------------------------------------------------------------------
-- 说明：三国无双选择加成属性
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
AdditionSelect = class("AdditionSelectClass", Window)
    
function AdditionSelect:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.selectIndex = {} --当前所选的属性加成选项索引
    -- Initialize AdditionSelect page state machine.
    local function init_guan_qia_terminal()
		--属性加成
		local addition_select_back_activity_terminal = {
            _name = "addition_select_back_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
				-- _ED.three_kingdoms_view.current_max_stars = tonumber(_ED.three_kingdoms_view.current_max_stars) - tonumber(params[1])
				local Text_star_n_2 = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_star_n_2")
				Text_star_n_2:setString(_ED.three_kingdoms_view.current_max_stars)			
				local selectdata = {}
				selectdata.store_id = dms.int(dms["three_kingdoms_attribute"], params[2], three_kingdoms_attribute.store_id)
				selectdata.id = params[2]
				selectdata.shipid = params[3]
				table.insert(instance.selectIndex, selectdata)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local addition_select_close_window_terminal = {
            _name = "addition_select_close_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
            	local buffData = zstring.split(dms.string(dms["three_kingdoms_config"], tonumber(_ED.integral_current_index), three_kingdoms_config.attribute_add_id), "|")
				local buff_need = zstring.split(buffData[2],",")
				local buff_info = zstring.split(buffData[1],",")
				local needIndex = {}
				-- for i,v in pairs(instance.selectIndex) do
				-- 	if tonumber(v) == 1 then
				-- 		needIndex[1]=v
				-- 	elseif tonumber(v) == 2 then
				-- 		needIndex[2]=v
				-- 	elseif tonumber(v) == 3 then
				-- 		needIndex[3]=v
				-- 	end
				-- end
				local indexs = 0
				for j,w in pairs(buff_info) do
					indexs = indexs + 1
					local isTheSame = false
					for i,v in pairs(instance.selectIndex) do
						if tonumber(w) == tonumber(v.store_id) then
							isTheSame = true
							break
						end
					end
					if isTheSame == false then
						if tonumber(buff_need[indexs]) <= tonumber(_ED.three_kingdoms_view.current_max_stars) then
							app.load("client.l_digital.union.meeting.SmUnionTipsWindow")
							state_machine.excute("sm_union_tips_window_open", 0, {_new_interface_text[126],3,instance.selectIndex})
							return
						end
					end
				end

				for j,w in pairs(buff_info) do
	            	local isOver = false
	            	for i,v in pairs(instance.selectIndex) do
	            		if tonumber(w) == tonumber(v.store_id) then
	            			isOver = true
	            		end
	            	end
	            	if isOver == false then
	            		local store = {}
	            		store.store_id = w
	            		store.shipid = -1
	            		store.id = -1
	            		table.insert(instance.selectIndex, store)
	            	end
            	end

            	local function responseGetServerListCallback(response)
            		state_machine.unlock("addition_select_close_window")
	                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	                	state_machine.excute("trial_tower_insert_new_cell_data",0,"0")
	                	state_machine.excute("sm_trial_tower_update_buff_info",0,"")
	                	if nil ~= response.node and nil ~= response.node.roots and nil ~= response.node.roots[1] then
							fwin:close(response.node)
						end
	                end
	            end

	            local buff_info = ""
	            table.sort(instance.selectIndex, function(c1, c2)
					if c1 ~= nil 
			            and c2 ~= nil 
			            and zstring.tonumber(c1.store_id) < zstring.tonumber(c2.store_id) then
						return true
					end
					return false
				end)
				local index = 0
	            for i,v in pairs(instance.selectIndex) do
	            	if tonumber(v.id) > 0 then
		            	local list = zstring.split( dms.string(dms["three_kingdoms_attribute"], v.id, three_kingdoms_attribute.attribute_value),",")
		            	--战前处理的血量和怒气的加成
		            	if tonumber(list[1]) == 4 or tonumber(list[1]) == 41 or tonumber(list[1]) == 999 then
		            		if tonumber(list[1]) == 4 then
		            			--加血
		            			if tonumber(v.shipid) == -1 then
		            				for j,w in pairs(_ED.user_try_ship_infos) do
		            					--满血的就不管了
		            					if tonumber(w.maxHp) < 100 then
		            						--计算出加成后的血量百分比
		            						w.maxHp = tonumber(w.maxHp) + tonumber(list[2])
		            						if tonumber(w.maxHp) > 100 then
		            							w.maxHp = 100
		            						end
		            						_ED.user_try_ship_infos[""..w.id].newHp = tonumber(_ED.user_ship[""..w.id].ship_health)*(tonumber(w.maxHp)/100)
		            					end
		            				end
		            			else
		            				_ED.user_try_ship_infos[""..v.shipid].maxHp = tonumber(_ED.user_try_ship_infos[""..v.shipid].maxHp) + tonumber(list[2])
		            				if tonumber(_ED.user_try_ship_infos[""..v.shipid].maxHp) > 100 then
		            					_ED.user_try_ship_infos[""..v.shipid].maxHp = 100
		            				end
		            				_ED.user_try_ship_infos[""..v.shipid].newHp = tonumber(_ED.user_ship[""..v.shipid].ship_health)*(tonumber(_ED.user_try_ship_infos[""..v.shipid].maxHp)/100)
		            			end
		            		elseif tonumber(list[1]) == 41 then	
		            			--加怒
		            			local fightParams = zstring.split(dms.string(dms["fight_config"], 5 ,user_config.param),",")
		            			if tonumber(v.shipid) == -1 then
		            				for j,w in pairs(_ED.user_try_ship_infos) do
		            					if tonumber(w.newanger) < tonumber(fightParams[4]) then
		            						w.newanger = tonumber(w.newanger) + tonumber(list[2])
		            						if tonumber(w.newanger) > tonumber(fightParams[4]) then
		            							w.newanger = tonumber(fightParams[4])
		            						end 
		            						_ED.user_try_ship_infos[""..w.id].newanger = tonumber(w.newanger)
		            					end
		            				end
		            			else
		            				_ED.user_try_ship_infos[""..v.shipid].newanger = tonumber(_ED.user_try_ship_infos[""..v.shipid].newanger) + tonumber(list[2])
		            				if tonumber(_ED.user_try_ship_infos[""..v.shipid].newanger) > tonumber(fightParams[4]) then
		            					_ED.user_try_ship_infos[""..v.shipid].newanger = tonumber(fightParams[4])
		            				end
		            			end
	            			elseif tonumber(list[1]) == 999 then
	            				--复活
	            				_ED.user_try_ship_infos[""..v.shipid].maxHp = tonumber(_ED.user_try_ship_infos[""..v.shipid].maxHp) + tonumber(list[2])
	            				_ED.user_try_ship_infos[""..v.shipid].newHp = tonumber(_ED.user_ship[""..v.shipid].ship_health)*(tonumber(_ED.user_try_ship_infos[""..v.shipid].maxHp)/100)
		            		end
		            	end
	            	end
	            	if tonumber(v.shipid) < 0 then
	            		index = index + 1
		            	if index == 1 then
		            		buff_info = tonumber(v.id)..":"..tonumber(v.shipid)
		            	else
		            		buff_info = buff_info .."|"..tonumber(v.id)..":"..tonumber(v.shipid)
		            	end
	            	end
	            end

	            local strs = ""
	            for j, w in pairs(_ED.user_try_ship_infos) do
	        		if strs ~= "" then
            			strs = strs.."|"..w.id..":"..w.newHp..","..w.newanger..","..(zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
            		else
            			strs = w.id..":"..w.newHp..","..w.newanger..","..(zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
            		end
	            end

	            state_machine.lock("addition_select_close_window")

	            protocol_command.three_kingdoms_launch.param_list = "54".."\r\n"..dms.string(dms["play_config"], 26, play_config.param).."\r\n".."0".."\r\n".."0".."\r\n".."0".."\r\n"..
	            _ED.integral_current_index.."\r\n"..strs.."\r\n"..buff_info.."\r\n".."".."\r\n".."0"
	            NetworkManager:register(protocol_command.three_kingdoms_launch.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
				--清除记录
		    	cc.UserDefault:getInstance():setStringForKey(getKey("GuanBattleIndex"), "-1")
		    	cc.UserDefault:getInstance():flush()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(addition_select_back_activity_terminal)
		state_machine.add(addition_select_close_window_terminal)
        state_machine.init()
    end
    
    -- call func init guan qia state machine.
    init_guan_qia_terminal()
end


function AdditionSelect:onUpdateDraw()
	local root = self.roots[1]
	
	local buffData = zstring.split(dms.string(dms["three_kingdoms_config"], tonumber(_ED.integral_current_index), three_kingdoms_config.attribute_add_id), "|")
	local buff_info = zstring.split(buffData[1],",")
	local buff_need = zstring.split(buffData[2],",")
	for i=1, 3 do
		local Panel_sxxz = ccui.Helper:seekWidgetByName(root,"Panel_sxxz_"..i)
		Panel_sxxz:removeAllChildren(true)
		local cell = state_machine.excute("sm_trial_tower_Addition_cell", 0, {buff_info[i],buff_need[i],i})
		Panel_sxxz:addChild(cell)
	end

	local Text_star_n_2 = ccui.Helper:seekWidgetByName(root,"Text_star_n_2")
	Text_star_n_2:setString(_ED.three_kingdoms_view.current_max_stars)
end


function AdditionSelect:initData()
	
end

function AdditionSelect:updateSelectIndex(index)

	local starI = self.starQ[index]
	if tonumber(_ED.three_kingdoms_view.left_stars) < starI[1] then
		TipDlg.drawTextDailog(tipStringInfo_trialTower[12])
		return
	end

	self.selectIndex = index
	-- self.selectQueue = {
		-- {atype=nil, img = nil},
		-- {atype=nil, img = nil},
		-- {atype=nil, img = nil},
	-- }
	local data = self.selectQueue[index]
	for i=1,3 do
		self.selectQueue[i].img:setVisible(false)
	end
	self.selectQueue[index].img:setVisible(true)
end

function AdditionSelect:onEnterTransitionFinish()
    local csbCampaign = csb.createNode("campaign/TrialTower/trial_tower_Addition.csb")	
    self:addChild(csbCampaign)
	local root = csbCampaign:getChildByName("root")
	table.insert(self.roots, root)
	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, {
		func_string = [[state_machine.excute("addition_select_close_window", 0, "addition_select_close_window.")]],
		isPressedActionEnabled = true,
	}, nil, 3)

	self:onUpdateDraw()
end

-- 
function AdditionSelect:init()
	--self.index = index
end


function AdditionSelect:onExit()
	state_machine.remove("addition_select_close_window")
	state_machine.remove("trial_tower_challenge")
	state_machine.remove("trial_tower_formation")
	
end
