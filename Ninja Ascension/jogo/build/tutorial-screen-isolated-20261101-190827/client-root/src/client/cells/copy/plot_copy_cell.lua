----------------------------------------------------------------------------------------------------
-- 说明：主线副本列表元件的绘制及逻辑实现
-------------------------------------------------------------------------------------------------------
PlotCopyCell = class("PlotCopyCellClass", Window)
 
function PlotCopyCell:ctor()
    self.super:ctor()
	self.roots = {}
	
	self.pveSceneID = nil 							-- 关卡ID
	self.curret_state = nil							-- 0:未开启  1：可攻打 2：已通关
	self.nextSceneState = nil						--下一个场景状态
	self.curret_censorship_name = "徐州之战上" 		--当前关卡名字
	self.curret_censorship_maxstart = 30			--当前关卡最大星数
	self.curret_censorship_passstart = 10			--用户通关星数
	self.next_censorship_passstart = 0				--用户next通关星数
	self.curret_censorship_text = ""				--通关描述
	
	self.interfaceType = 0							-- 类型

    local function init_plot_copy_cell_terminal()
		local plot_copy_cell_into_pve_window_terminal = {
            _name = "plot_copy_cell_into_pve_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:removeAll()
				app.load("client.duplicate.pve.PVEScene")
				local pveScene = PVEScene:new()
				local sceneId = params._datas.sceneId
				--> print("==================================-----------",sceneId)
				pveScene:init(sceneId)
				fwin:open(pveScene, fwin._view)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(plot_copy_cell_into_pve_window_terminal)
        state_machine.init()
    end
    
    init_plot_copy_cell_terminal()
end

function PlotCopyCell:onUpdateDraw()
	local root = self.roots[1]
	local ProjectNode_1 = ccui.Helper:seekWidgetByName(root, "Panel_2"):getChildByName("ProjectNode_1")
	
	local root2 = ProjectNode_1:getChildByName("root")
	local Text_5 = ccui.Helper:seekWidgetByName(root2, "Text_5")   			 --name
	
	local Text_5_0 = ccui.Helper:seekWidgetByName(root2, "Text_5_0")		 --start
	local Panel_106 = ccui.Helper:seekWidgetByName(root2, "Panel_106")		 --move
	-- Panel_106:setVisible()

 	local icon_lingpai = ccui.Helper:seekWidgetByName(root, "Panel_2"):getChildByName("icon_lingpai")
	local open_text = ccui.Helper:seekWidgetByName(root, "Panel_2"):getChildByName("Text_3")
	local str = self.curret_censorship_passstart.."/"..self.curret_censorship_maxstart
	
	--> print("通关描述", self.curret_censorship_text)
	Text_5:setString(self.curret_censorship_name)
	Text_5_0:setString(str)
	open_text:setString(self.curret_censorship_text)
	
	-- 0:未开启  1：可攻打 2：已通关
	if tonumber(self.curret_state) == 0 then
		icon_lingpai:setVisible(false)
		Panel_106:setVisible(false)
		ProjectNode_1:setVisible(false)	
	elseif tonumber(self.curret_state) == 1 then
		icon_lingpai:setVisible(false)
		Panel_106:setVisible(false)

	elseif tonumber(self.curret_state) == 2 then
		Panel_106:setVisible(false)
		if self.nextSceneState < 0 then
			Panel_106:setVisible(true)
		else
			Panel_106:setVisible(false)
		end
		
		if self.curret_censorship_passstart == self.curret_censorship_maxstart then
			icon_lingpai:setVisible(true)
		else
			icon_lingpai:setVisible(false)
		end	
	end
	-- 判断关卡是否为通关状态
	-- 如果关卡通关了，插上通关旗帜
	-- 如果关卡未通关提示通关后的事件
	if tonumber(self.curret_censorship_passstart) >= tonumber(self.curret_censorship_maxstart) then
		
	end
end

function PlotCopyCell:PlayAnimtion()
	local csbEquipPatchListCell = csb.createNode(string.format("duplicate/fuben%d.csb", self.interfaceType))
	local action = csb.createTimeline(string.format("duplicate/fuben%d.csb", self.interfaceType))
	csbEquipPatchListCell:runAction(action)
    self:addChild(csbEquipPatchListCell)
	if self.curret_censorship_passstart > 0 then
		if self.curret_state == 2 and self.next_censorship_passstart == 0 then
			action:gotoFrameAndPlay(0, action:getDuration(), false)
		else
			action:gotoFrameAndPlay(action:getDuration(), action:getDuration(), false)
		end
	end
end

function PlotCopyCell:onEnterTransitionFinish()
    local csbEquipPatchListCell = csb.createNode(string.format("duplicate/fuben%d.csb", self.interfaceType))
	local root = csbEquipPatchListCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(true)
	self:addChild(root)	
	--control
	local arena_button 	= fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		terminal_name = "plot_copy_cell_into_pve_window", 
		terminal_state = 0, 
		sceneId = self.pveSceneID,
		isPressedActionEnabled = true,
	}, nil, 0)
	
	-- self:PlayAnimtion()
	--draw
	self:onUpdateDraw()
end

function PlotCopyCell:onExit()
	state_machine.remove("plot_copy_cell_into_pve_window")
end

function PlotCopyCell:init(sceneId, interfaceType)
	self.pveSceneID = sceneId
	--> print("-----------4------", self.pveSceneID, sceneId, interfaceType)
	
	-- 0:未开启  1：可攻打 2：已通关
	local sceneState = tonumber(_ED.scene_current_state[self.pveSceneID])
	local nextSceneState = tonumber(_ED.scene_current_state[self.pveSceneID + 1])
	if sceneState < 0 then
		self.curret_state = 0
	elseif sceneState == 0 then 
		self.curret_state = 1
	elseif sceneState > 0 then 
		self.curret_state = 2
	end 
	
	self.nextSceneState = nextSceneState
	
	--> print("interfaceType",interfaceType)	-- 1
	--> print("sceneState",sceneState)			-- 4
	--> print("nextSceneState",nextSceneState)  -- -1

	-- 获取当前关卡的总星数量
	self.curret_censorship_passstart = tonumber(_ED.get_star_count[self.pveSceneID])
	self.next_censorship_passstart = tonumber(_ED.get_star_count[self.pveSceneID+1])
	-- 获取当前关卡npc的数量
	-- 当前关卡最大星数
	self.curret_censorship_maxstart = dms.string(dms["pve_scene"], self.pveSceneID, pve_scene.total_star)
	-- 当前关卡的名字
	self.curret_censorship_name = dms.string(dms["pve_scene"], self.pveSceneID, pve_scene.scene_name)
	-- 通关描述
	self.curret_censorship_text = dms.string(dms["pve_scene"], self.pveSceneID, pve_scene.open_condition_describe)
	
	self.interfaceType = interfaceType
end

function PlotCopyCell:createCell()
	local cell = PlotCopyCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function PlotCopyCell:isCurretOpen()
	if self.curret_censorship_passstart < self.curret_censorship_maxstart then
		return false
	end
	return true
end