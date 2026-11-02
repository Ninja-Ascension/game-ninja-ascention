----------------------------------------------------------------------------------------------------
-- 说明：宠物副本中小角色
-------------------------------------------------------------------------------------------------------
BattleFieldMapRoleCell = class("BattleFieldMapRoleCellClass", Window)

function BattleFieldMapRoleCell:ctor()
    self.super:ctor()
	
    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.current_type = 0
	
	self._roleDate = nil --玩家数据
	self._emeny_off = nil  -- 没有打过的
	self._emeny_on = nil  -- 当前
	self._emeny_lose = nil  -- 已经打过了
	self._current_floor = 0 -- 当前层数
	self._current_index = 0 --当前据点
	self._off_animation = nil --未开启动画
	self._on_animation = nil --战胜后播放
	-- -- 初始化事件响应需要使用的状态机
	local function init_battle_field_map_role_cell_terminal()
		
		local battle_field_map_role_cell_click_terminal = {
            _name = "battle_field_map_role_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local role = params._datas._self._roleDate
            	local index = params._datas._self._current_index
            	local state = zstring.tonumber(role._player_attact_state) -- 0未激活 1激活 2击杀
            	if state == 1 then
            		app.load("client.campaign.battlefield.BattleFieldChallenge")
            		state_machine.excute("battle_field_challenge_window_open",0,{role,index})
            	elseif state == 0 then 
            		TipDlg.drawTextDailog(_pet_tipString_info[27])
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(battle_field_map_role_cell_click_terminal)	
			
        state_machine.init()
	end
	init_battle_field_map_role_cell_terminal()
end

function BattleFieldMapRoleCell:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	ccui.Helper:seekWidgetByName(root, "Text_emeny_name_1"):setString(""..self._roleDate._player_nick_name)
	ccui.Helper:seekWidgetByName(root, "Text_emeny_zl_1"):setString("".._string_piece_info[303]..self._roleDate._player_fight)
	ccui.Helper:seekWidgetByName(root, "Text_emeny_lv_1"):setString("".._string_piece_info[16]..self._roleDate._player_level)
	self._emeny_off:removeBackGroundImage()
	self._emeny_on:removeBackGroundImage()
	self._emeny_lose:removeBackGroundImage()
	local infoPanel = ccui.Helper:seekWidgetByName(root, "Panel_information")
	local attackPanel = ccui.Helper:seekWidgetByName(root, "Panel_hp_1")
	infoPanel:setVisible(false)
	attackPanel:setVisible(false)
	local state = zstring.tonumber(self._roleDate._player_attact_state) -- 0未激活 1激活 2击杀
	local attackId = zstring.tonumber(_ED._pet_battle_filed_info.current_attack_npc_id)
	if state == 0 then 
		self._emeny_off:setBackGroundImage(string.format("images/ui/play/battlefield/enemy_off_%s.png", ""..self._current_floor))
		self._off_animation:setVisible(true)
	elseif state == 1 then 
		--infoPanel:setVisible(true)
		self._emeny_on:setBackGroundImage(string.format("images/ui/play/battlefield/enemy_on_%s.png", ""..self._current_floor))
		if attackId == zstring.tonumber(self._roleDate._player_id) then 
			--当前
			attackPanel:setVisible(true)
			local loadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_hp_1")
			persent = self:getAllPlayerPercent()
			if persent >=100 then 
				persent = 100
			end		
			loadingBar:setPercent(persent)
		end
	elseif state == 2 then 
		self._emeny_lose:setBackGroundImage(string.format("images/ui/play/battlefield/enemy_lose_%s.png", ""..self._current_floor))
	end

	local function executeMoveHeroOverFunc()
		
	end
end

--播放胜利动画
function BattleFieldMapRoleCell:playVictoryAnimation()
	csb.animationChangeToAction(self._on_animation, 1, 1, false)
    self._on_animation._invoke = self._on_animation._invoke_w
    self._on_animation:setVisible(true)
    
end

function BattleFieldMapRoleCell:getAllPlayerPercent()
	local percent = 0
	local players = _ED._pet_battle_filed_info.players[zstring.tonumber(self._current_index)]
	local totalPercent = 0
	if players ~= nil then
		local formations = players.formations
		for i=1,6 do
			local formation = formations[i]
			totalPercent = totalPercent + formation._player_remain_hp
		end
	end
	return math.floor(totalPercent/6)
end

function BattleFieldMapRoleCell:onEnterTransitionFinish()
	local csbItem = csb.createNode("campaign/BattleField/BattleField_emeny.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	self._emeny_off = ccui.Helper:seekWidgetByName(root, "Panel_emeny_off")
	self._emeny_on = ccui.Helper:seekWidgetByName(root, "Panel_emeny_on")
	self._emeny_lose = ccui.Helper:seekWidgetByName(root, "Panel_emeny_lose")
	self._emeny_lose:setTouchEnabled(false)
	self._emeny_on:setTouchEnabled(false)
	self._emeny_off:setSwallowTouches(false)
	local emenyPanel = ccui.Helper:seekWidgetByName(root, "Panel_emeny")
	self._off_animation = emenyPanel:getChildByName("ArmatureNode_1")
	self._on_animation = emenyPanel:getChildByName("ArmatureNode_2")
	self._off_animation:setVisible(false)
	self._on_animation:setVisible(false)


    draw.initArmature(self._on_animation, nil, -1, 0, 1)
    csb.animationChangeToAction(self._on_animation, 0, 0, false)
    self._on_animation.__self = self
    self._on_animation._invoke_w = function(armatureBack)
        if armatureBack:isVisible() == true then
            armatureBack:setVisible(false)
            local root = armatureBack.__self.roots[1]
	    	local infoPanel = ccui.Helper:seekWidgetByName(root, "Panel_information")
	        infoPanel:setVisible(true)
        end
    end   

	--点击英雄
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_emeny_off"), nil, 
	{
		terminal_name = "battle_field_map_role_cell_click",
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)
	self:onUpdateDraw()
end

function BattleFieldMapRoleCell:onExit()
end

function BattleFieldMapRoleCell:init(roleDate,floor,index)
	self._roleDate = roleDate
	self._current_floor = floor
	self._current_index = index
end

function BattleFieldMapRoleCell:createCell()
	local cell = BattleFieldMapRoleCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

