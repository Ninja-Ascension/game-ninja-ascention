-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE  场景介绍信息界面 教学事件用
-------------------------------------------------------------------------------------------------------
PrologueScreenInfo = class("PrologueScreenInfoClass", Window)

function PrologueScreenInfo:ctor()
    self.super:ctor()
    self.roots = {}
	self.sceneID = 0				--场景ID
	
	self.openType = 0 --场景开启类型 -- 0 开启, 1通关
	
	local function init_terminal()
		
		-- 返回
		local prologue_screen_info_close_terminal = {
            _name = "prologue_screen_info_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				local current_mission = cell.current_mission
				local openType = cell.openType
				
				fwin:close(cell)
				
				if zstring.tonumber(openType) == 1 then

					state_machine.excute("duplicate_pve_secondary_scene_back_home", 0, nil) 
				end
				
				-- 可能存在触发教学
				if nil ~= current_mission then
					missionLock = false
					saveExecuteEvent(current_mission, true, false)
				end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(prologue_screen_info_close_terminal)
		
        state_machine.init()
	end
	
	init_terminal()
	
end


-- 开启
function PrologueScreenInfo:openScene()
	local scene_name = dms.string(dms["pve_scene"], self.sceneID, pve_scene.scene_name)
	local brief_introduction = dms.string(dms["pve_scene"], self.sceneID, pve_scene.brief_introduction)
	if tonumber(self.sceneIndex) == 0 then 
		self.sceneIndex = dms.string(dms["pve_scene"], self.sceneID, pve_scene.scene_id)
	end
	ccui.Helper:seekWidgetByName( self.roots[1], "Text_1"):setString(_string_piece_info[2]..self.sceneIndex.._string_piece_info[98])
	ccui.Helper:seekWidgetByName( self.roots[1], "Text_2"):setString(scene_name)

	if __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		local Text_1 = ccui.Helper:seekWidgetByName( self.roots[1], "Text_1")
		local Text_2 = ccui.Helper:seekWidgetByName( self.roots[1], "Text_2")
		Text_1:setString(_string_piece_info[2]..self:numberToStringFunc(self.sceneIndex).._string_piece_info[98])
		Text_1:setMaxLineWidth(1)
		Text_2:setMaxLineWidth(1)
		Text_1:setPosition(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_a"):getPosition())
		Text_2:setPosition(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_b"):getPosition())
		Text_1:setContentSize(cc.size(100, 120))
		Text_2:setContentSize(cc.size(100, 120))
		if verifySupportLanguage(_lua_release_language_en) == true then
			ccui.Helper:seekWidgetByName(self.roots[1], "Text_3"):setString(brief_introduction)
		else
			local n = 0
			local leng = 10
			for i = 1, 9 do
				local str = string.sub(brief_introduction, 3*leng*n+1, 3*leng*i)
				local text = ccui.Helper:seekWidgetByName(self.roots[1], "Text_"..(2 + i))
				if text ~= nil then
					text:setMaxLineWidth(1)
					text:setString(str)
					n = n + 1
				end
			end
		end
	end

	local action = csb.createTimeline("duplicate/pve_cg.csb")
    self.roots[1]:runAction(action)
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()

        if str == "zhangjieing_over" then
        	self.closeBtn:setTouchEnabled(true)
        end
    end)
    action:play("zhangjieing", false)
end

function PrologueScreenInfo:numberToStringFunc( _input )
	local input_number = zstring.tonumber(_input)
	local function getNumberLessThan100(temp1)
		local need = temp1 % 100
		local output = ""
		if need <= 0 then
			return output
		end
		
		if need <= 10 then
			output = numberToStringArg[need]
		elseif need < 20 then
			output = numberToStringArg[10] .. numberToStringArg[need - 10]
		elseif need < 100 then
			output = numberToStringArg[math.floor(need / 10)] .. numberToStringArg[10]
			if need % 10 ~= 0 then
				output = output .. numberToStringArg[need % 10]
			end		
		end
		return output
	end
	
	local function getNumberLessThan1000(temp2)
		local need = temp2 % 1000
		local output = ""
		if need <= 0 then
			return output
		end
		output = numberToStringArg[math.floor(need / 100)] .. numberToStringArg[11]
		if need % 100 < 10 and need % 100 > 0 then
			output = output .. numberToStringArg[13]
		end
		local tmpStr = getNumberLessThan100(temp2)
		output = output .. tmpStr
		return output
	end
	
	local function getNumberLessThan10000(temp3)
		local need = temp3 % 10000
		local output = ""
		output = numberToStringArg[math.floor(need / 1000)] .. numberToStringArg[12]
		if need % 1000 < 100 and need % 100 > 0 then
			output = output .. numberToStringArg[13]
		end
		local tmpStr = ""
		if need % 1000 < 100 then
			tmpStr = getNumberLessThan100(temp3)
		else
			tmpStr = getNumberLessThan1000(temp3)
		end
		output = output .. tmpStr
		return output
	end
	
	local output_string = ""
	if input_number < 100 then
		output_string = getNumberLessThan100(input_number)
	elseif input_number < 1000 then
		output_string = getNumberLessThan1000(input_number)
	elseif input_number < 10000 then
		output_string = getNumberLessThan10000(input_number)
	end
	return output_string
end

-- 通关
function PrologueScreenInfo:endScene()
	local scene_name = dms.string(dms["pve_scene"], self.sceneID, pve_scene.scene_name)
	local access_introduction = dms.string(dms["pve_scene"], self.sceneID, pve_scene.access_introduction)
	if tonumber(self.sceneIndex) == 0 then 
		self.sceneIndex = dms.string(dms["pve_scene"], self.sceneID, pve_scene.scene_id)
	end
	ccui.Helper:seekWidgetByName( self.roots[1], "Text_1"):setString(_string_piece_info[2]..self.sceneIndex.._string_piece_info[98])
	ccui.Helper:seekWidgetByName( self.roots[1], "Text_2"):setString(scene_name)

	if verifySupportLanguage(_lua_release_language_en) == true then
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_3"):setString(access_introduction)
	else
		local n = 0
		local leng = 17
		if __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			then
			local Text_1 = ccui.Helper:seekWidgetByName( self.roots[1], "Text_1")
			local Text_2 = ccui.Helper:seekWidgetByName( self.roots[1], "Text_2")
			Text_1:setString(_string_piece_info[2]..self:numberToStringFunc(self.sceneIndex).._string_piece_info[98])
			Text_1:setMaxLineWidth(1)
			Text_2:setMaxLineWidth(1)
			Text_1:setPosition(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_a"):getPosition())
			Text_2:setPosition(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_b"):getPosition())
			Text_1:setContentSize(cc.size(100, 120))
			Text_2:setContentSize(cc.size(100, 120))
			leng = 10
		end
		for i = 1, 9 do
			local str = string.sub(access_introduction, 3*leng*n+1, 3*leng*i)
			local text = ccui.Helper:seekWidgetByName(self.roots[1], "Text_"..(2 + i))
			if text ~= nil then
				if __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					text:setMaxLineWidth(1)
				end
				text:setString(str)
				n = n + 1
			end
		end
	end

	local action = csb.createTimeline("duplicate/pve_cg.csb")
    self.roots[1]:runAction(action)
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()

        if str == "wenziing_over" then
        	self.closeBtn:setTouchEnabled(true)
        end
    end)
    action:play("wenziing", false)
end

--绘制背景图
function PrologueScreenInfo:drawBgIamgePanel()
	local index = dms.int(dms["pve_scene"], self.sceneID, pve_scene.scene_map_id)
	if __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		index = dms.int(dms["pve_scene"], self.sceneID, pve_scene.scene_id)
	end
	--local index =  dms.int(dms["pve_scene"], self.sceneID, pve_scene.scene_entry_pic)
	local bgImage = string.format("images/ui/pve_sn/pve_cg_bg_%d.jpg", index)
	if cc.FileUtils:getInstance():isFileExist(bgImage) == true then
		self.cacheBgImagePanel:setBackGroundImage(bgImage)
	end
	local Panel_4 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4")
	if Panel_4 ~= nil then
        local function changeActionCallback( armatureBack )
            csb.animationChangeToAction(armatureBack, 1, 1, false)
        end
		local ArmatureNode_book = Panel_4:getChildByName("ArmatureNode_book")
		if ArmatureNode_book ~= nil then
			draw.initArmature(ArmatureNode_book, nil, -1, 0, 1)
	        ArmatureNode_book._invoke = changeActionCallback
	        ArmatureNode_book:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
			local book_pic = string.format("images/ui/bg/pve_book_pic_%d.png", index)
	        local jiachengIcon = ccs.Skin:create(book_pic)
	        ArmatureNode_book:getBone("zhangjie"):addDisplay(jiachengIcon, 0)
	        csb.animationChangeToAction(ArmatureNode_book, 0, 0, false)
	    end
	end
end


function PrologueScreenInfo:init(sceneID, sceneIndex, openType,current_mission)
	self.sceneID = sceneID
	self.sceneIndex = sceneIndex
	self.openType = zstring.tonumber(openType)
	self.current_mission = current_mission
end

function PrologueScreenInfo:onEnterTransitionFinish()

	local csbPrologueScreenInfo = csb.createNode("duplicate/pve_cg.csb")
	
	local root = csbPrologueScreenInfo:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPrologueScreenInfo)

	self.cacheBgImagePanel = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	
	self:drawBgIamgePanel()
	
	if self.openType == 1 then
		self:endScene()
	else
		self:openScene()
	end

	self.closeBtn = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_2")
	self.closeBtn:setTouchEnabled(false)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, 
	{
		terminal_name = "prologue_screen_info_close", 
		terminal_state = 0, 
		cell = self
	},
	nil, 0)
	root:setTouchEnabled(true)
	self:setTouchEnabled(true)
end

function PrologueScreenInfo:onExit()
	self.roots[1]:stopAllActions()

	state_machine.remove("prologue_screen_info_close")
	
end

