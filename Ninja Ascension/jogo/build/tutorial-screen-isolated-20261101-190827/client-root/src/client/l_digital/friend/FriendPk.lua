-----------------------------------------------------------------------------------------------
-- 说明：好友pk界面

-------------------------------------------------------------------------------------------------------

FriendPk = class("FriendPkClass", Window)
    
function FriendPk:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	app.load("client.cells.ship.hero_icon_list_cell")
    -- Initialize ChatWorldPage page state machine.
    local function init_friend_pk_terminal()
		--开始战斗
		local friend_pk_to_battle_terminal = {
            _name = "friend_pk_to_battle",
            _init = function (terminal) 
                app.load("client.battle.BattleStartEffect")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local function recruitSendCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						fwin:cleanView(fwin._windows)
						fwin:freeAllMemeryPool()
						local bse = BattleStartEffect:new()
						bse:init(_enum_fight_type._fight_type_13)
						fwin:open(bse, fwin._windows)
					end
				end
	
                protocol_command.union_fight.param_list = _ED.chat_user_info.user_id .."\r\n"
				NetworkManager:register(protocol_command.union_fight.code, nil, nil, nil, nil, recruitSendCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local friend_pk_close_terminal = {
            _name = "friend_pk_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(friend_pk_to_battle_terminal)
		state_machine.add(friend_pk_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_friend_pk_terminal()
end


function FriendPk:onUpdateDraw()
	local root = self.roots[1]
	--对面信息
	local ListView_zr_2 = ccui.Helper:seekWidgetByName(root, "ListView_zr_2")
	ListView_zr_2:removeAllItems()
	local power = "".._ED.chat_user_info.fighting
	local shipAllData = zstring.split(_ED.chat_user_info.formation, "!")
   	for i, v in pairs(shipAllData) do
   		--模板id:等级:进阶数据:星级:品阶:战力
   		local shipData = zstring.split(v, ":")
   		local cell = HeroIconListCell:createCell()
   		local ship = {}
   		ship.ship_template_id = shipData[1]
   		ship.evolution_status = shipData[3]
   		ship.Order = shipData[5]
   		ship.StarRating = shipData[4]
   		ship.ship_grade = shipData[2]
   		ship.ship_id = -1
   		cell:init(ship, i,true)
   		ListView_zr_2:addChild(cell)
   	end
   	ListView_zr_2:requestRefreshView()
   	local Text_fighting_n_2 = ccui.Helper:seekWidgetByName(root, "Text_fighting_n_2")
   	Text_fighting_n_2:setString(power)
   	--我的信息
   	local Text_fighting_n_1 = ccui.Helper:seekWidgetByName(root, "Text_fighting_n_1")
   	Text_fighting_n_1:setString(_ED.user_info.fight_capacity)
   	local ListView_zr_1 = ccui.Helper:seekWidgetByName(root, "ListView_zr_1")
   	ListView_zr_1:removeAllItems()
   	for i= 1,6 do
		local ship = _ED.user_ship["".._ED.user_formetion_status[i]]
		if ship ~= nil then
			local cell = HeroIconListCell:createCell()
			cell:init(ship, i,false,nil,false)
			ListView_zr_1:addChild(cell)
		end	
	end
   	ListView_zr_1:requestRefreshView()
end

function FriendPk:onEnterTransitionFinish()
    local csbInfo = csb.createNode("friend/sm_friend_tab_list_window_pk.csb")
    self:addChild(csbInfo)
	local root = csbInfo:getChildByName("root")
	table.insert(self.roots, root)
	
	local action = csb.createTimeline("friend/sm_friend_tab_list_window_pk.csb") 
	table.insert(self.actions, action )
	self:runAction(action)
	action:play("window_open", false)

	--关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
	{
		terminal_name = "friend_pk_close",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 2)

	--挑战
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fight"), nil, 
	{
		terminal_name = "friend_pk_to_battle",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 2)
	self:onUpdateDraw()
end


function FriendPk:onExit()
	state_machine.remove("friend_pk_close")
	state_machine.remove("friend_pk_to_battle")
end

function FriendPk:init()
	
end

function FriendPk:createCell()
	local cell = FriendPk:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
