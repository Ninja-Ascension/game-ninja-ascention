-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE  场景介绍信息界面
-------------------------------------------------------------------------------------------------------
PVESecondarySceneInfo = class("PVESecondarySceneInfoClass", Window)

function PVESecondarySceneInfo:ctor()
    self.super:ctor()
    self.roots = {}
	self.sceneID = 0				--场景ID
	
	self.openType = 0 --场景开启类型 -- 0 开启, 1通关
	
	local function init_terminal()
		
		-- 返回
		local duplicate_pve_secondary_scene_info_close_terminal = {
            _name = "duplicate_pve_secondary_scene_info_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.openType == 1 then
					state_machine.excute("duplicate_pve_secondary_scene_back_home", 0, nil) 
				end

				fwin:close(instance)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(duplicate_pve_secondary_scene_info_close_terminal)
		
        state_machine.init()
	end
	
	init_terminal()
	
end


-- 开启
function PVESecondarySceneInfo:openScene()
	local scene_name = dms.string(dms["pve_scene"], self.sceneID, pve_scene.scene_name)
	local access_introduction = dms.string(dms["pve_scene"], self.sceneID, pve_scene.access_introduction)
	ccui.Helper:seekWidgetByName( self.roots[1], "Text_1"):setString(_string_piece_info[2]..self.sceneIndex.._string_piece_info[3])
	ccui.Helper:seekWidgetByName( self.roots[1], "Text_2"):setString(scene_name)
	
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

-- 通关
function PVESecondarySceneInfo:endScene()

	local scene_name = dms.string(dms["pve_scene"], self.sceneID, pve_scene.scene_name)
	local access_introduction = dms.string(dms["pve_scene"], self.sceneID, pve_scene.access_introduction)

	if verifySupportLanguage(_lua_release_language_en) == true then
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_3"):setString(access_introduction)
	else
		local txt = {"Text_3","Text_4","Text_5"}
		local n = 0
		local leng = 17
		for i = 1 ,3 do
			local str = string.sub(access_introduction, 3*leng*n+1, 3*leng*i)
			ccui.Helper:seekWidgetByName( self.roots[1], txt[i]):setString(str)
			n = n + 1
		end
	end

	ccui.Helper:seekWidgetByName( self.roots[1], "Text_1"):setString(_string_piece_info[2]..self.sceneIndex.._string_piece_info[3])
	ccui.Helper:seekWidgetByName( self.roots[1], "Text_2"):setString(scene_name)

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

-----------------------
-- 07/10 确认 章节列表 用 scene_entry_pic , 通关动画和npc场景 用 scene_map_id
-- scene_entry_pic = 7,			--int(11)		场景入口图
-- scene_map_id = 8,			--int(11)		场景地图id
-------------

--绘制背景图
function PVESecondarySceneInfo:drawBgIamgePanel()
	local index = dms.int(dms["pve_scene"], self.sceneID, pve_scene.scene_map_id)
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


function PVESecondarySceneInfo:init(sceneID, sceneIndex, openType)
	self.sceneID = sceneID
	self.sceneIndex = sceneIndex
	self.openType = zstring.tonumber(openType)
end

function PVESecondarySceneInfo:onEnterTransitionFinish()

	local csbPVESecondarySceneInfo = csb.createNode("duplicate/pve_cg.csb")
	
	local root = csbPVESecondarySceneInfo:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPVESecondarySceneInfo)

	self.cacheBgImagePanel = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	
	self:drawBgIamgePanel()
	
	if self.openType == 1 then
		self:endScene()
	else
		self:openScene()
	end

	self.closeBtn = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_2")
	self.closeBtn:setTouchEnabled(false)
	fwin:addTouchEventListener(self.closeBtn, nil, 
	{
		terminal_name = "duplicate_pve_secondary_scene_info_close", 
		terminal_state = 0, 
	},
	nil, 0)
	root:setTouchEnabled(true)
	self:setTouchEnabled(true)
end

function PVESecondarySceneInfo:onExit()
	self.roots[1]:stopAllActions()

	state_machine.remove("duplicate_pve_secondary_scene_info_close")
	
end

