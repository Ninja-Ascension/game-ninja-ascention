--------------------------------------------------------------------------------------------------------------
--  说明：公会副本npc
--------------------------------------------------------------------------------------------------------------
SmUnionPveNpc = class("SmUnionPveNpcClass", Window)
SmUnionPveNpc.__size = nil
function SmUnionPveNpc:ctor()
	self.super:ctor()
	self.roots = {}
	self.isMove = true
	app.load("client.l_digital.union.duplicate.SmUnionPveBattleWindow")
	app.load("client.l_digital.union.duplicate.SmUnionNpcRank")
	 -- Initialize union rank list cell state machine.
    local function init_sm_union_pve_npc_terminal()
        local sm_union_pve_npc_buy_cell_open_terminal = {
            _name = "sm_union_pve_npc_buy_cell_open",
            _init = function (terminal)
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
        		local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	state_machine.excute("sm_union_pve_battle_window_open", 0, {cell.npc_id,cell.data_id})
                    end
                end
        		protocol_command.union_copy_look_npc_info.param_list = "0".."\r\n"..tonumber(cell.data_id)-1
                NetworkManager:register(protocol_command.union_copy_look_npc_info.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(sm_union_pve_npc_buy_cell_open_terminal)

		local sm_union_pve_npc_buy_cell_to_view_union_rank_terminal = {
            _name = "sm_union_pve_npc_buy_cell_to_view_union_rank",
            _init = function (terminal)
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	state_machine.excute("sm_union_npc_rank_open", 0, "")
                    end
                end
        		protocol_command.union_copy_look_npc_info.param_list = "2".."\r\n"..tonumber(cell.data_id)-1
                NetworkManager:register(protocol_command.union_copy_look_npc_info.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(sm_union_pve_npc_buy_cell_open_terminal)
		state_machine.add(sm_union_pve_npc_buy_cell_to_view_union_rank_terminal)
        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_sm_union_pve_npc_terminal()

end

function SmUnionPveNpc:updateDraw()
	local root = self.roots[1]
	local npcInfo = _ED.union_pve_info[tonumber(self.data_id)]
	--有形象
	local Panel_open_npc = ccui.Helper:seekWidgetByName(root, "Panel_open_npc")

	--无形象
	local Image_no_open_bg = ccui.Helper:seekWidgetByName(root, "Image_no_open_bg")
	if tonumber(self.data_id) ~= 0 then
		Panel_open_npc:setVisible(true)
		Image_no_open_bg:setVisible(false)
	else
		Panel_open_npc:setVisible(false)
		Image_no_open_bg:setVisible(true)
		return
	end

	--npc形象图（还没定）
	local Panel_npc_icon = ccui.Helper:seekWidgetByName(root, "Panel_npc_icon")

	if self.npc_id then 
		local npc_pic = zstring.split(dms.string(dms["npc"], zstring.tonumber(self.npc_id), npc.head_pic),",")[1]

   	 	Panel_npc_icon:removeBackGroundImage()
    	Panel_npc_icon:setBackGroundImage(string.format("images/ui/pve_sn/props_%d.png", npc_pic))
    	-- if __lua_project_id == __lua_project_l_digital then
    	-- 	Panel_npc_icon:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", npc_pic))
    	-- end
    end

	--血量
	local Panel_hp = ccui.Helper:seekWidgetByName(root, "Panel_hp")
	local LoadingBar_hp = ccui.Helper:seekWidgetByName(root, "LoadingBar_hp")
	local Text_hp_n = ccui.Helper:seekWidgetByName(root, "Text_hp_n")
	if tonumber(npcInfo.max_hp) == 0 then
		LoadingBar_hp:setPercent(100)
		Text_hp_n:setString("100%")
	else
		LoadingBar_hp:setPercent(math.ceil(tonumber(npcInfo.current_hp)/tonumber(npcInfo.max_hp)*100*100)/100)
		Text_hp_n:setString((math.ceil(tonumber(npcInfo.current_hp)/tonumber(npcInfo.max_hp)*100*100)/100).."%")
	end

	--完美通关
	local Image_wmtg = ccui.Helper:seekWidgetByName(root, "Image_wmtg")
	if tonumber(npcInfo.status) == 0 then
		Panel_hp:setVisible(true)
		Image_wmtg:setVisible(false)
	else
		Panel_hp:setVisible(false)
		Image_wmtg:setVisible(true)
	end

	--关卡名称
	local Text_npc_name = ccui.Helper:seekWidgetByName(root, "Text_npc_name")
	if self.npc_id then
		local battleNpcName = dms.string(dms["npc"], zstring.tonumber(self.npc_id), npc.npc_name)
		local name_info = ""
	    local name_data = zstring.split(battleNpcName, "|")
	    for i, v in pairs(name_data) do
	        local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
	        name_info = name_info..word_info[3]
	    end
	    battleNpcName = name_info
		Text_npc_name:setString(battleNpcName)
	end
	--关卡编号
	local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
	Text_number:setString(self.data_id)

	local Panel_dh = ccui.Helper:seekWidgetByName(root, "Panel_dh")
	Panel_dh:removeAllChildren(true)
    local jsonFile = "sprite/spirte_npc_bg.json"
    local atlasFile = "sprite/spirte_npc_bg.atlas"
    local animation1 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    Panel_dh:addChild(animation1)

    local Panel_dh_2 = ccui.Helper:seekWidgetByName(root, "Panel_dh_2")
	Panel_dh_2:removeAllChildren(true)
    local jsonFile2 = "sprite/spirte_npc_di.json"
    local atlasFile2 = "sprite/spirte_npc_di.atlas"
    local animation2 = sp.spine(jsonFile2, atlasFile2, 1, 0, "animation", true, nil)
    Panel_dh_2:addChild(animation2)

    local Text_buff = ccui.Helper:seekWidgetByName(root, "Text_buff")
    if tonumber(self.data_id) == #_ED.union_pve_info then
    	if _ED.union_pve_attribute_bonus == 0 then
    		Text_buff:setString("")
    	else
    		Text_buff:setString(string.format(_new_interface_text[73], _ED.union_pve_attribute_bonus).."%")
    	end
    else
    	Text_buff:setString("")
    end
end

function SmUnionPveNpc:onInit()
    local root = cacher.createUIRef("legion/sm_legion_pve_npc.csb", "root")
    table.insert(self.roots, root)
	
    self:addChild(root)
	if SmUnionPveNpc.__size == nil then
		SmUnionPveNpc.__size = root:getChildByName("Panel_npc"):getContentSize()
	end	

	--查看排行
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank"), nil, 
    {
        terminal_name = "sm_union_pve_npc_buy_cell_to_view_union_rank",
        terminal_state = 0,
        touch_black = true,
        cell = self,
        isPressedActionEnabled = true
    },
    nil,0)

	--进入
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_open_npc"), nil, 
    {
        terminal_name = "sm_union_pve_npc_buy_cell_open",
        terminal_state = 0,
        touch_black = true,
        cell = self,
        isPressedActionEnabled = true
    },
    nil,0)

    self._npc = ccui.Helper:seekWidgetByName(root,"Panel_open_npc")
    local Image_gk_dec = ccui.Helper:seekWidgetByName(root,"Image_gk_dec")
    if Image_gk_dec ~= nil then
    	self._npc = Image_gk_dec
    end
    if self._npc._y == nil then
		self._npc._y = self._npc:getPositionY()
	end
	self._npc:setPositionY(self._npc._y)

	local npcInfo = _ED.union_pve_info[tonumber(self.data_id)]
	if npcInfo ~= nil then

		-- DSC重塑
		local widget = ccui.Helper:seekWidgetByName(root,"Panel_npc_icon")
		if __lua_project_id == __lua_project_l_digital then
			widget = ccui.Helper:seekWidgetByName(root,"Panel_red")
		end

		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_duplicate_npc_status",
	        _widget = widget,
	        _invoke = nil,
	        _interval = 0.5,
	        npc_index = npcInfo.index,})
	end
	
	self:updateDraw()
end

function SmUnionPveNpc:onEnterTransitionFinish()

end

function SmUnionPveNpc:onUpdate(dt)
	if tonumber(self.data_id) == #_ED.union_pve_info then
		if self.isMove == true then
			local function executeMovestar()
		        self.isMove = false
		    end
		    local function executeMoveHeroOverFunc()
		        self.isMove = true
		    end
		    local _pos1 = cc.p(self._npc:getPositionX(), self._npc._y+20)
		    local _pos2 = cc.p(self._npc:getPositionX(), self._npc._y)
		    local _pos3 = cc.p(self._npc:getPositionX(), self._npc._y-20)
			self._npc:runAction(cc.Sequence:create(
					cc.CallFunc:create(executeMovestar),
                    cc.MoveTo:create(1, _pos1),
                    cc.DelayTime:create(0.2),
                    cc.MoveTo:create(1, _pos2),
                    cc.CallFunc:create(executeMoveHeroOverFunc)
                ))
		end
	end
end

function SmUnionPveNpc:init(npc_id,data_id)
	self.npc_id = npc_id
	self.data_id = data_id
	self:onInit()
	self:setContentSize(SmUnionPveNpc.__size)
	return self
end

function SmUnionPveNpc:clearUIInfo( ... )
	local root = self.roots[1]
	local Panel_open_npc = ccui.Helper:seekWidgetByName(root, "Panel_open_npc")
	local Image_no_open_bg = ccui.Helper:seekWidgetByName(root, "Image_no_open_bg")
	local Panel_npc_icon = ccui.Helper:seekWidgetByName(root, "Panel_npc_icon")
	local Panel_hp = ccui.Helper:seekWidgetByName(root, "Panel_hp")
	local Image_wmtg = ccui.Helper:seekWidgetByName(root, "Image_wmtg")
	local LoadingBar_hp = ccui.Helper:seekWidgetByName(root, "LoadingBar_hp")
	local Text_hp_n = ccui.Helper:seekWidgetByName(root, "Text_hp_n")
	local Text_npc_name = ccui.Helper:seekWidgetByName(root, "Text_npc_name")
	local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
	local Panel_dh = ccui.Helper:seekWidgetByName(root, "Panel_dh")
    local Panel_dh_2 = ccui.Helper:seekWidgetByName(root, "Panel_dh_2")
    local Text_buff = ccui.Helper:seekWidgetByName(root, "Text_buff")

    if Panel_open_npc ~= nil then
    	Panel_open_npc:setVisible(false)
    	Image_no_open_bg:setVisible(false)
	    Panel_npc_icon:removeBackGroundImage()
		LoadingBar_hp:setPercent(0)
		Text_hp_n:setString("")
		Image_wmtg:setVisible(false)
		Panel_hp:setVisible(false)
		Text_npc_name:setString("")
		Text_number:setString("")
		Panel_dh:removeAllChildren(true)
		Panel_dh_2:removeAllChildren(true)
		Text_buff:setString("")
	end
end

function SmUnionPveNpc:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmUnionPveNpc:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("legion/sm_legion_pve_npc.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end
function SmUnionPveNpc:onExit()
	self:clearUIInfo()
	cacher.freeRef("legion/sm_legion_pve_npc.csb", self.roots[1])
end

function SmUnionPveNpc:createCell()
	local cell = SmUnionPveNpc:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 0.5)
	return cell
end
