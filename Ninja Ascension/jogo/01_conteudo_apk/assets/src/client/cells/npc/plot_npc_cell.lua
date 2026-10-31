----------------------------------------------------------------------------------------------------
-- 说明：PVE场景中的NPC
-------------------------------------------------------------------------------------------------------
PlotNPCCell = class("PlotNPCCellClass", Window)

function PlotNPCCell:ctor()
    self.super:ctor()
	
    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.actions = {}
	self.npcId = 0
	self.pass_ccustoms_num = 1							-- 通关星数
	self.npc_name_color    = cc.c4b(255,0,0,255)		-- npc人物的品质
	self.npc_name	   = ""     					-- npc人物名字
	self.npc_attack_state  = 0							-- npc攻击状态  0：打过  1：可攻击
	self.npc_pic = 0
	self.current_type = 0
	self.enum_type = {
		_BETRAY_ARMY_INFORMATION = 1,				-- 进入叛军形象绘制
		_BETRAY_ARMY_DAILY_ACTIVITY_COPY = 2,		-- 进入日常活动副本形象绘制
	}

	app.load("client.cells.ship.ship_body_fizz_cell")

	-- Initialize NPCInformation page state machine.
    local function plot_npc_cell_terminal()	
        -- 请求PVE副本战斗
        local plot_npc_cell_show_infomation_terminal = {
            _name = "plot_npc_cell_show_infomation",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)      
				app.load("client.duplicate.pve.NPCInformation")
				if fwin:find("NPCInformationClass") == nil then
					local NPCInfo = NPCInformation:new()
					NPCInfo:init(params._datas.NPCId)
					fwin:open(NPCInfo, fwin._view)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local plot_npc_cell_show_fizz_terminal = {
            _name = "plot_npc_cell_show_fizz",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local npcCell = params
            	state_machine.excute("ship_body_fizz_cell_show", 0, {npcCell.roots[2]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

       	local plot_npc_cell_hide_fizz_terminal = {
            _name = "plot_npc_cell_hide_fizz",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local npcCell = params
            	state_machine.excute("ship_body_fizz_cell_hide", 0, {npcCell.roots[2]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(plot_npc_cell_show_infomation_terminal)
		state_machine.add(plot_npc_cell_show_fizz_terminal)
		state_machine.add(plot_npc_cell_hide_fizz_terminal)
        state_machine.init()
	end
	
	plot_npc_cell_terminal()
end

function PlotNPCCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_pve = ccui.Helper:seekWidgetByName(root, "Panel_pve") 
	local Text_pve_name = ccui.Helper:seekWidgetByName(root, "Text_pve_name") 
	
	local Panel_5 = ccui.Helper:seekWidgetByName(root, "Panel_5")
	
	local Image_6 = ccui.Helper:seekWidgetByName(root, "Image_6")
	local Image_7 = ccui.Helper:seekWidgetByName(root, "Image_7")
	local Image_8 = ccui.Helper:seekWidgetByName(root, "Image_8")
	local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
	local Panel_card_role = ccui.Helper:seekWidgetByName(root, "Panel_card_role")
	if self.current_type == self.enum_type._BETRAY_ARMY_INFORMATION then
		local quality = dms.int(dms["npc"], self.npcId, npc.base_pic)
		Panel_pve:setVisible(false)
		Panel_5:setVisible(false)
		Image_6:setVisible(false)
		Image_7:setVisible(false)
		Image_8:setVisible(false)
		Image_1:setVisible(false)
		Text_pve_name:setString(self.npc_name)
		Text_pve_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		-- Text_pve_name:setColor(self.npc_name_color)	
		
		Panel_card_role:setBackGroundImage("images/face/big_head/big_head_"..self.npc_pic..".png")
	elseif self.current_type == self.enum_type._BETRAY_ARMY_DAILY_ACTIVITY_COPY then
		Panel_pve:setVisible(false)
		Panel_5:setVisible(false)
		Image_6:setVisible(false)
		Image_7:setVisible(false)
		Image_8:setVisible(false)
		Image_1:setVisible(false)
		
		-- Text_pve_name:setColor(cc.c3b(self.npc_name_color.r, self.npc_name_color.g, self.npc_name_color.b))
		-- Text_pve_name:setString(self.npc_name)
		ccui.Helper:seekWidgetByName(root, "Panel_richang_14"):setBackGroundImage("images/face/big_head/big_head_"..self.npc_pic..".png")
	else
		Text_pve_name:setString(self.npc_name)
		Text_pve_name:setColor(self.npc_name_color)	
		
		if tonumber(self.pass_ccustoms_num) == 1 then
			Image_6:setVisible(true)
		elseif tonumber(self.pass_ccustoms_num) == 2 then
			Image_6:setVisible(true)
			Image_7:setVisible(true)
		
		elseif tonumber(self.pass_ccustoms_num) == 3 then
			Image_6:setVisible(true)
			Image_7:setVisible(true)
			Image_8:setVisible(true)
		end
		
		if tonumber(self.npc_attack_state) == 0 then 
			Panel_5:setVisible(false)
		elseif tonumber(self.npc_attack_state) == 1 then 
			Panel_5:setVisible(true)	
		end
		
		Panel_card_role:setBackGroundImage("images/face/big_head/big_head_"..self.npc_pic..".png")
	end
end

function PlotNPCCell:onEnterTransitionFinish()
	local csbItem = csb.createNode("card/card_role.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	self:onUpdateDraw()
	
    -- 人物的呼吸动画
	local action = csb.createTimeline("card/card_role.csb")
	table.insert(self.actions, action)
    root:runAction(action)
    action:play("Panel_role_dt", true)

    -- 对活的汽泡动画
    local msg = dms.string(dms["npc"], self.npcId, npc.sign_msg)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local word_info = dms.element(dms["word_mould"], zstring.tonumber(msg))
        msg = word_info[3]
    end
    if msg ~= "-1" then
	    local fizzCell = ShipBodyFizzCell:createCell()
	     if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        local word_info = dms.element(dms["word_mould"], zstring.tonumber(dms.string(dms["npc"], self.npcId, npc.sign_msg)))
	        fizzCell:init(word_info[3])
	    else
	        fizzCell:init(dms.string(dms["npc"], self.npcId, npc.sign_msg))
	    end
	    self:addChild(fizzCell)
	    table.insert(self.roots, fizzCell)
	end
	
	if self.current_type == self.enum_type._BETRAY_ARMY_DAILY_ACTIVITY_COPY then
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_role"), nil, 
		{
			terminal_name = "plot_npc_cell_show_infomation", 
			terminal_state = 0, 
			NPCId = self.npcId
		}, nil, 0)
	end	
end

function PlotNPCCell:onExit()
	state_machine.remove("plot_npc_cell_show_infomation")
end

function PlotNPCCell:init(npcId, state,interfaceType)
	self.npcId = npcId
	self.current_type = interfaceType
	-- self.pass_ccustoms_num = _ED.npc_state[npcId]							
	self.pass_ccustoms_num = _ED.npc_state[tonumber(""..npcId)]		-- 通关星数	
	local quality = dms.int(dms["npc"], npcId, npc.base_pic)
	local color = tipStringInfo_quality_color_Type[quality]
	self.npc_name_color    = cc.c4b(color[1],color[2],color[3],255) -- cc.c4b(255,0,0,255)							-- npc人物的品质--difficulty_include_count base_pic
	self.npc_name	   = dms.string(dms["npc"], npcId, npc.npc_name)     	-- npc人物名字
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local name_info = ""
        local name_data = zstring.split(self.npc_name, "|")
        for i, v in pairs(name_data) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            name_info = name_info..word_info[3]
        end
        self.npc_name = name_info
    end
	self.npc_attack_state  = state												-- npc攻击状态  0：打过  1：可攻击
	
	if interfaceType == 1 then
		self.npc_pic = dms.string(dms["rebel_army_mould"], npcId, rebel_army_mould.aram_pic)
	elseif self.current_type == self.enum_type._BETRAY_ARMY_DAILY_ACTIVITY_COPY then
		self.npc_pic = dms.int(dms["npc"], npcId, npc.head_pic) - 1000
	else
		self.npc_pic = dms.int(dms["npc"], npcId, npc.head_pic)
	end
end

function PlotNPCCell:createCell()
	local cell = PlotNPCCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

