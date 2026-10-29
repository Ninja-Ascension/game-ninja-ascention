-- ----------------------------------------------------------------------------------------------------
-- 说明：魔陷卡养成 -- 强化，同调
-- 标签页在同一个CSB里面，
-- 只有一个CSB
-------------------------------------------------------------------------------------------------------

MagicCardStrong = class("MagicCardStrongClass", Window)
    
function MagicCardStrong:ctor()
    self.super:ctor()
	self.group = {self}
	self.roots = {}
	self.magic_card_id = 0
	self.magic_card_info = nil
	self.showType = 1 --1强化 2同调
	self.strongPanel = nil --强化
	self.homologuePanel = nil --同调
	self.qh2Button = nil  --去强化按钮
	self.tt2Button = nil  --去同调按钮
	self.ArmatureNode_1 = nil  --动画
	self.ArmatureNodePanel = nil
	self.magic_card_cell = nil --强化列表CELL

	app.load("client.cells.prop.prop_icon_new_cell")
	app.load("client.cells.magicCard.magic_trup_card_icon_cell")
    -- Initialize treasure_storage page state machine.
    local function init_magic_card_strong_terminal()
		--返回主界面
		local magic_card_strong_return_home_page_terminal = {
            _name = "magic_card_strong_return_home_page",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
 
				fwin:close(fwin:find("MagicCardStrongClass"))
		         return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --标签管理
		local magic_card_strong_manager_terminal = {
            _name = "magic_card_strong_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				   -- set select ui button is highlighted
				if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
					terminal.select_button:setHighlighted(false)
					terminal.select_button:setTouchEnabled(true)
				end
				if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
					terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
				end
				if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
					terminal.select_button:setHighlighted(true)
					terminal.select_button:setTouchEnabled(false)
				end
				if terminal.last_terminal_name ~= params._datas.next_terminal_name then
					terminal.last_terminal_name = params._datas.next_terminal_name
					state_machine.excute(params._datas.next_terminal_name, 0, params)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --强化
		local magic_card_strong_storages_tab_terminal = {
            _name = "magic_card_strong_storages_tab",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.showType = 1
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--同调
		local magic_card_strong_homologue_tab_terminal = {
            _name = "magic_card_strong_homologue_tab",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.showType = 2
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --强化请求
		local magic_card_strong_storages_terminal = {
            _name = "magic_card_strong_storages",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseStrongCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
	            			return
	            		end
	            		instance:playSucceedAction()
        				instance:onUpdateDraw()
		            end
				end
		
				local cardId = params._datas._cell.magic_card_id
				protocol_command.magic_trap_escalate.param_list = cardId
				NetworkManager:register(protocol_command.magic_trap_escalate.code, nil, nil, nil, instance, responseStrongCallback, false, nil)
            
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--同调请求
		local magic_card_strong_homologue_terminal = {
            _name = "magic_card_strong_homologue",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseHomologueCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
	            			return
	            		end
						instance:onUpdateDraw()
	            		state_machine.excute("magic_card_trup_remove_card_update",0,0)
	            		state_machine.excute("magic_card_magic_remove_card_update",0,0)
	            		instance:playSucceedAction()
        				_ED.magic_card_remove_ids = ""
		            end
				end
		
				local cardId = params._datas._cell.magic_card_id
				protocol_command.magic_trap_grow_up.param_list = cardId
				NetworkManager:register(protocol_command.magic_trap_grow_up.code, nil, nil, nil, instance, responseHomologueCallback, false, nil)
            
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(magic_card_strong_manager_terminal)
		state_machine.add(magic_card_strong_storages_terminal)
		state_machine.add(magic_card_strong_homologue_terminal)
		state_machine.add(magic_card_strong_return_home_page_terminal)
		state_machine.add(magic_card_strong_storages_tab_terminal)
		state_machine.add(magic_card_strong_homologue_tab_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_magic_card_strong_terminal()
end


function MagicCardStrong:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	self.magic_card_info = fundMagicCardWithId(self.magic_card_id)
	if self.magic_card_info == nil then 
		return
	end
	--魔陷卡数据
	local cardMouldData = dms.element(dms["magic_trap_card_info"], self.magic_card_info.base_mould)
	
	local magicNameText = ccui.Helper:seekWidgetByName(root, "Text_name")
	--消耗材料
	local nameText1 = ccui.Helper:seekWidgetByName(root, "Text_27")
	local countText1 = ccui.Helper:seekWidgetByName(root, "Text_27_0_0")
	local nameText2 = ccui.Helper:seekWidgetByName(root, "Text_27_0")
	local countText2 = ccui.Helper:seekWidgetByName(root, "Text_27_0_0_0")
	local propPanel1 = ccui.Helper:seekWidgetByName(root, "Panel_5")
	local propPanel2 = ccui.Helper:seekWidgetByName(root, "Panel_5_0")
	local levelInfoText1 = ccui.Helper:seekWidgetByName(root, "Text_7")   --当前等级养成描述
	local levelInfoText2 = ccui.Helper:seekWidgetByName(root, "Text_7_2")	--下一级养成描述
	local levelText = ccui.Helper:seekWidgetByName(root, "Text_32_0") 
	propPanel1:removeAllChildren(true)
	propPanel2:removeAllChildren(true)
	nameText1:setString("")
	countText1:setString("")
	nameText2:setString("")
	countText2:setString("")
	
	local dikuangPanel = ccui.Helper:seekWidgetByName(root, "Panel_card") --背景
	local cardPanel = ccui.Helper:seekWidgetByName(root, "Panel_skill") --背景
	local magic_type = dms.atoi(cardMouldData,magic_trap_card_info.card_type)
	local strongLevel = zstring.tonumber(self.magic_card_info.strong_level)
	if magic_type == 0 then 
		dikuangPanel:setBackGroundImage("images/ui/battle/card_magic.png")
	else
		dikuangPanel:setBackGroundImage("images/ui/battle/card_trap.png")
	end

	cardPanel:setBackGroundImage(string.format("images/ui/props/props_%d.png", dms.atoi(cardMouldData, magic_trap_card_info.pic)))
	local skillMouldData = dms.element(dms["skill_mould"], dms.atos(cardMouldData, magic_trap_card_info.skill_mould_id))
	local baseSkillId = dms.atoi(skillMouldData,skill_mould.next_level_skill)
	local currentLevel = 0

	while dms.atoi(skillMouldData,skill_mould.next_level_skill) ~= nil and
	 dms.atoi(skillMouldData,skill_mould.next_level_skill)> 0 and strongLevel > 0 do
		baseSkillId = dms.atoi(skillMouldData,skill_mould.next_level_skill)
		skillMouldData = dms.element(dms["skill_mould"],baseSkillId)
		currentLevel = currentLevel + 1
		if currentLevel >= strongLevel then 
			break
		end
	end
	magicNameText:setString(dms.atos(skillMouldData,skill_mould.skill_name))
	if self.showType == 1 then 
		--强化

		local strongSkills = dms.searchs(dms["skill_mould"], skill_mould.base_mould, dms.atoi(skillMouldData,skill_mould.base_mould))
		
		local nextSkillId = dms.atoi(skillMouldData,skill_mould.next_level_skill)
		
		local desc1 = dms.atos(cardMouldData,magic_trap_card_info.card_desc)
		local desc2 = ""
		local isCanStrong = true
		if zstring.tonumber(self.magic_card_info.strong_level) == 0 then 
			
			if nextSkillId ~= nil and nextSkillId == -1 then 
				--该卡不能强化
				desc2 = _magic_card_tip[4]
				levelText:setString("Lv ".. self.magic_card_info.strong_level)
				isCanStrong = false
			else
				levelText:setString("Lv ".. self.magic_card_info.strong_level .. "/".. (#strongSkills-1))
				desc2 = "" ..dms.atos(cardMouldData,magic_trap_card_info.card_desc) .. "(" .. dms.string(dms["skill_mould"],nextSkillId,skill_mould.skill_describe).. ")"
			end
		else
			desc1 = desc1 .. "(" .. dms.atos(skillMouldData,skill_mould.skill_describe)  .. ")"
			if nextSkillId ~= nil and nextSkillId == -1 then 
				--到满级了
				desc2 = _magic_card_tip[5]
				isCanStrong = false
			else
				desc2 = "".. dms.atos(cardMouldData,magic_trap_card_info.card_desc) .. "(" .. dms.string(dms["skill_mould"],nextSkillId,skill_mould.skill_describe).. ")"
			end
			levelText:setString("Lv ".. self.magic_card_info.strong_level .. "/".. (#strongSkills-1))	
		end
		levelInfoText1:setString(desc1)
		levelInfoText2:setString(desc2)
		if isCanStrong == false then 
			--不能强化了
			ccui.Helper:seekWidgetByName(root, "Text_31"):setString("0")
			self.qh2Button:setTouchEnabled(false)
			self.qh2Button:setColor(cc.c3b(130, 130, 130))	
		else
			self.qh2Button:setTouchEnabled(true)
			--消耗道具
			local strongMouldData = dms.element(dms["magic_escalate_param"], self.magic_card_info.strong_level +1)
			local prop_mouldId = dms.atoi(strongMouldData,magic_escalate_param.use_prop)
			if prop_mouldId ~= nil and prop_mouldId > -1  then 
				local iconCell = PropIconNewCell:createCell()

				iconCell:init(13, prop_mouldId)
				propPanel1:addChild(iconCell)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		            nameText1:setString(setThePropsIcon(mouldId)[2])
		        else
		        	nameText1:setString(dms.string(dms["prop_mould"], prop_mouldId, prop_mould.prop_name))
		        end
				local prop_counts = dms.atoi(strongMouldData,magic_escalate_param.use_prop_count)
				local totalCount = getPropAllCountByMouldId(prop_mouldId)
				countText1:setString("" .. totalCount .."/" .. prop_counts )
				if zstring.tonumber(totalCount) >= zstring.tonumber(prop_counts) then 
					countText1:setColor(cc.c3b(255, 255, 255))
				else
					countText1:setColor(cc.c3b(255, 0, 0))
				end
			end
			if dms.atos(strongMouldData,magic_escalate_param.use_silver) ~= nil then 
				ccui.Helper:seekWidgetByName(root, "Text_31"):setString(dms.atos(strongMouldData,magic_escalate_param.use_silver))
			end
		end
	else
		--同调
		local maxStart = dms.atoi(cardMouldData, magic_trap_card_info.max_star)
		local startLevel = dms.atoi(cardMouldData, magic_trap_card_info.current_star)
	    for i=1,5 do
	        local startImg1 = ccui.Helper:seekWidgetByName(root, "Image_c_".. i)
	        local startImg2 = ccui.Helper:seekWidgetByName(root, "Image_o_".. i)
	        startImg1:setVisible(false)
	        startImg2:setVisible(false)
	        if i <= maxStart then 
	            startImg1:setVisible(true)
	        end
	        if i <= startLevel then 
	            startImg2:setVisible(true)
	        end
    	end
    	local nextStarId = dms.atoi(cardMouldData,magic_trap_card_info.next_star)
    	local isCantongt = true
    	local desc1 = dms.atos(cardMouldData,magic_trap_card_info.card_desc)
    	local desc2 = ""
    	
    	if startLevel == 0 then 	
    		if nextStarId == -1 then 
    			--该卡没有同调属性
    			isCantongt = false
    			desc2 = _magic_card_tip[7]
    		else
    			desc2 = dms.string(dms["magic_trap_card_info"],nextStarId,magic_trap_card_info.card_desc)
    		end
    	else
    		if nextStarId == -1 then 
    			--同调已经满级了
    			isCantongt = false
    			desc2 = _magic_card_tip[6]
    		else
    			desc2 = dms.string(dms["magic_trap_card_info"],nextStarId,magic_trap_card_info.card_desc)
    		end
    	end
    	if zstring.tonumber(self.magic_card_info.strong_level) > 0 then 
    		desc1 = "".. desc1 .. "(" .. dms.atos(skillMouldData,skill_mould.skill_describe) .. ")"
    	end
    	levelInfoText1:setString(desc1)
    	if isCantongt == false then 
    		self.tt2Button:setTouchEnabled(false)
			self.tt2Button:setColor(cc.c3b(130, 130, 130))
			ccui.Helper:seekWidgetByName(root, "Text_31"):setString("0")
		else
			if zstring.tonumber(self.magic_card_info.strong_level) > 0 then 

    			desc2 = "" ..desc2 .. "(" .. dms.atos(skillMouldData,skill_mould.skill_describe) .. ")"
    		end
    		local startId = dms.atoi(cardMouldData,magic_trap_card_info.demand)
    		local upStartMouldData = dms.element(dms["magic_grow_param"], startId)
    		ccui.Helper:seekWidgetByName(root, "Text_31"):setString(dms.atos(upStartMouldData,magic_grow_param.use_silver))
    		local xiaohao1 = dms.atoi(upStartMouldData,magic_grow_param.use_gold)
    		if xiaohao1 ~= nil and xiaohao1 > -1 then 
    			local rewardIcon = ResourcesIconCell:createCell()      
   				rewardIcon:init(2, -1, -1)	
   				propPanel1:addChild(rewardIcon)
   				nameText1:setString(_All_tip_string_info._crystalName)
   				if  zstring.tonumber(_ED.user_info.user_gold) >= xiaohao1 then 
   					countText1:setColor(cc.c3b(255, 255, 255))
   				else
   					countText1:setColor(cc.c3b(255, 0, 0))
   				end
   				countText1:setString("".. xiaohao1)
   				
    		end
    		--消耗道具
    		local xiaohao2 = dms.atoi(upStartMouldData,magic_grow_param.use_same_card)
    		if xiaohao2 ~= nil and xiaohao2 > -1 then 
    			local prop_mouldId = dms.atoi(cardMouldData,magic_trap_card_info.base_mould)
    			local iconCell = MagicTrupCardIconCell:createCell()
				iconCell:init(prop_mouldId)
				propPanel2:addChild(iconCell)
				nameText2:setString(dms.string(dms["magic_trap_card_info"], prop_mouldId, magic_trap_card_info.card_name))
				local totalCount = getMagicCardAllCountByMouldId(prop_mouldId,self.magic_card_id)
				countText2:setString("" .. totalCount .."/" .. xiaohao2 )
				if zstring.tonumber(totalCount) >= zstring.tonumber(xiaohao2) then 
					countText2:setColor(cc.c3b(255, 255, 255))
				else
					countText2:setColor(cc.c3b(255, 0, 0))
				end
    		end
    	end
    	levelInfoText2:setString(desc2)
	end
	self.strongPanel:setVisible(self.showType == 1)
	self.homologuePanel:setVisible(self.showType == 2)
end


--播放动画
function MagicCardStrong:playSucceedAction()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	
	self.ArmatureNodePanel:setVisible(true)
	self.ArmatureNode_1:setVisible(true)
    draw.initArmature(self.ArmatureNode_1, nil, -1, 0, 1)
    csb.animationChangeToAction(self.ArmatureNode_1, 0, 0, false)
    self.ArmatureNode_1._invoke = function(armatureBack)
        if armatureBack:isVisible() == true then
            armatureBack:setVisible(false)
           
        end
    end 
    if self.magic_card_cell ~= nil then 
    	self.magic_card_cell:onUpdateDraw()
    end
end

function MagicCardStrong:onEnterTransitionFinish()
	
    local csbtreasure_storage = csb.createNode("packs/magic_card_strengthen.csb")
	local root = csbtreasure_storage:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbtreasure_storage)
	
	self.strongPanel = ccui.Helper:seekWidgetByName(root, "Panel_qianghua")
	self.homologuePanel = ccui.Helper:seekWidgetByName(root, "Panel_tongtiao")
	self.strongPanel:setVisible(false)
	self.homologuePanel:setVisible(false)
	self.qh2Button = ccui.Helper:seekWidgetByName(root, "Button_qianghua")  --去强化按钮
	self.tt2Button = ccui.Helper:seekWidgetByName(root, "Button_tongtiao")  --去同调按钮
	self.ArmatureNodePanel = ccui.Helper:seekWidgetByName(root, "Panel_2")  
	self.ArmatureNode_1 = self.ArmatureNodePanel:getChildByName("ArmatureNode_2")
 	--强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qianghua2"),       nil, 
    {
        terminal_name = "magic_card_strong_manager",     
        current_button_name = "Button_qianghua2",  
        next_terminal_name = "magic_card_strong_storages_tab",       
        terminal_state = 0, 
        but_image = "", 
        isPressedActionEnabled = false
    }, 
    nil, 0)
	
	--同调
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tongtiao2"),       nil, 
    {
        terminal_name = "magic_card_strong_manager",     
        current_button_name = "Button_tongtiao2",  
        next_terminal_name = "magic_card_strong_homologue_tab",       
        terminal_state = 0, 
        but_image = "", 
        isPressedActionEnabled = false
    }, 
    nil, 0)
	state_machine.excute("magic_card_strong_manager", 0, 
	{
		_datas = {
			terminal_name = "magic_card_strong_manager", 	
			next_terminal_name = "magic_card_strong_storages_tab", 		
			current_button_name = "Button_qianghua2", 		
			terminal_state = 0, 
			but_image = "", 
			isPressedActionEnabled = true
		}
	})
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fanhui"),       nil, 
    {
        terminal_name = "magic_card_strong_return_home_page",     
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)

	
	--请求
	fwin:addTouchEventListener(self.qh2Button,       nil, 
    {
        terminal_name = "magic_card_strong_storages",     
        terminal_state = 0, 
        _cell = self,
        isPressedActionEnabled = false
    }, 
    nil, 0)
	--去同调
	fwin:addTouchEventListener(self.tt2Button,       nil, 
    {
        terminal_name = "magic_card_strong_homologue",     
        terminal_state = 0, 
        _cell = self,
        isPressedActionEnabled = false
    }, 
    nil, 0)

end

function MagicCardStrong:init(cardId,cell)
	self.magic_card_id = cardId
	self.showType = 1
	self.magic_card_cell = cell
end

function MagicCardStrong:onExit()
	state_machine.remove("magic_card_strong_manager")
	state_machine.remove("magic_card_strong_storages")
	state_machine.remove("magic_card_strong_homologue")
	state_machine.remove("magic_card_strong_storages_tab")
	state_machine.remove("magic_card_strong_homologue_tab")
	state_machine.remove("magic_card_strong_return_home_page")
end
