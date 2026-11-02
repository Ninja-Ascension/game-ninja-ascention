ExplorationLoading = class("ExplorationLoadingClass", Window)

function ExplorationLoading:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.totalNum = 5
	self.basePosX = 0
	self.isLoadExploration= false
	self.isBeginLoad = false
	self.selectIndex = 0
    self.fightType = 0
	local function init_login_loading_terminal()
		
		-- local login_loading_change_name_terminal = {
  --           _name = "login_loading_change_name",
  --           _init = function (terminal) 
                
  --           end,
  --           _inited = false,
  --           _instance = self,
  --           _state = 0,
  --           _invoke = function(terminal, instance, params) 
		-- 		local function responseChangeNameCallback(response)
		-- 			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		-- 				if response.node ~= nil and response.node.roots ~= nil then
		-- 					state_machine.excute("character_create_show_home", 0, response.node)
		-- 				end
		-- 			end
		-- 		end
		-- 		protocol_command.get_random_name.param_list = self.selectIndex
		-- 		local server = _ED.all_servers[_ED.selected_server]
		-- 		NetworkManager:register(protocol_command.get_random_name.code, server.server_link, nil, nil, params, responseChangeNameCallback, false, nil)
  --               return true
  --           end,
  --           _terminal = nil,
  --           _terminals = nil
  --       }
		-- state_machine.add(login_loading_change_name_terminal)
  --       state_machine.init()
    end
    
    init_login_loading_terminal()
end

function ExplorationLoading:init(fightType)  --fightType為218 218為世界boss戰鬥，其餘的佔時為探索戰鬥
	self.fightType = fightType
	self:onInit()
	return self
end

function ExplorationLoading:onInit( ... )
	if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
	-- if config_res._sync_draw_open ~= nil and config_res._sync_draw_open ~= "" and config_res._sync_draw_open == true then
 --    else
 --        cacher.destoryRefPools()
 --    end
 --    fwin:reset(nil)
 --    cacher.cleanSystemCacher()
 --    cacher.cleanActionTimeline()
 --    cacher.removeAllTextures()
 --    cacher.remvoeUnusedArmatureFileInfoes()

	-- self:loadArmature()
    local csbBattleLoadingCell = csb.createNode("utils/donghua_loading.csb")
	local root = csbBattleLoadingCell:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbBattleLoadingCell)

	self.Text_loading_01 = ccui.Helper:seekWidgetByName(root, "Text_loading_01")
	self.Text_loading_02 = ccui.Helper:seekWidgetByName(root, "Text_loading_02")
	self.Text_loading_01:setString(_string_piece_info[376])
	self.Text_loading_02:setString("5/100")

	self.Panel_loading_ing = ccui.Helper:seekWidgetByName(root, "Panel_loading_ing")
	self.basePosX = self.Panel_loading_ing:getPositionX()

	self.loadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_112")

	local width = self.loadingBar:getContentSize().width
    self.Panel_loading_ing:setPositionX(self.basePosX + width * self.totalNum/100)
	
	if tipStringInfo_loading_notice_info ~= nil then
		local count = #tipStringInfo_loading_notice_info
		local id = 1 + math.floor(math.random() * count)
		if id > count then
	        id = count
	    end
	    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		    if tonumber(_ED.scene_current_state[1]) >= 0 then
		    	if tonumber(_ED.npc_state[1]) <= 0 then
		    		id = 1
				elseif tonumber(_ED.npc_state[2]) <= 0 then
					id = 2
				elseif tonumber(_ED.npc_state[3]) <= 0 then
					id = 3
				end
		    end
		end
	    ccui.Helper:seekWidgetByName(root, "Text_tishi"):setString(tipStringInfo_loading_notice_info[id])
	end
	
	local action = csb.createTimeline("utils/donghua_loading.csb")
    table.insert(self.actions, action)

    self:unregisterOnNoteUpdate(self)

    csbBattleLoadingCell:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_close_over" then
        	fwin:close(self)
        	-- state_machine.excute("fight_load_assets_end", 0, nil)
        end
    end)
    action:play("window_open", false)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
		local random = math.ceil(math.random(0, 3))
		if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
			random = math.ceil(math.random(0, 6))
		end
	 	if tonumber(_ED.scene_current_state[1]) >= 0 then
	    	if tonumber(_ED.npc_state[1]) <= 0 then
	    		random = 0
			elseif tonumber(_ED.npc_state[2]) <= 0 then
				random = 2
			elseif tonumber(_ED.npc_state[3]) <= 0 then
				random = 3
			end
	    end
	    Image_1:loadTexture(string.format("images/ui/battle/kaichang/zy_%s.png", random))
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		function blinkOutCallback(sender)
			self.isBeginLoad = true
		end
		self:runAction(cc.Sequence:create(
                        cc.DelayTime:create(1),
                        cc.CallFunc:create(blinkOutCallback)
                        ))
	else
		local Panel_donghua = ccui.Helper:seekWidgetByName(root, "Panel_donghua")
		Panel_donghua:setVisible(true)
		local ArmatureNode_2 = Panel_donghua:getChildByName("ArmatureNode_2")
	    local animation = ArmatureNode_2:getAnimation()
	    
	    local function changeActionCallback( armatureBack )
	        local _self = armatureBack._self
	        local actionIndex = armatureBack._actionIndex
	        armatureBack:pause()
	        if actionIndex == 0 then
	        	_self.isBeginLoad = true
	        elseif actionIndex == 2 then
	        	Panel_donghua:setVisible(false)
	        end
	    end

	    local random = math.ceil(math.random(1, 3))
	    
	    local kcIcon = ccs.Skin:create(string.format("images/ui/battle/kaichang/zy_%s.png", random))
	    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		else
		    ArmatureNode_2:getBone("Layer1"):addDisplay(kcIcon, 0)
		end
	    ArmatureNode_2._invoke = changeActionCallback
	    ArmatureNode_2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	    ArmatureNode_2._self = self
	    -- draw.initArmature(ArmatureNode_2, nil, -1, 0, 1)
	    csb.animationChangeToAction(ArmatureNode_2, 0, 0, false)
	    -- animation:playWithIndex(0, 0, 0)
	end
end

function ExplorationLoading:onUpdate( dt )
	if self.isBeginLoad == false or self._unload == true then
		return
	end
	if self.totalNum >= 100 then
		self:loadingSuccess()
		return
	else
		self:checkExplorationLoading(nil, true)
	end

	local width = self.loadingBar:getContentSize().width
    self.Panel_loading_ing:setPositionX(self.basePosX + width * self.totalNum/100)
	
	self.loadingBar:setPercent(self.totalNum)
	self.Text_loading_02:setString(self.totalNum.."/100")
end

function ExplorationLoading:checkExplorationLoading( baseWindow, loginIn )
	if self.totalNum >= 8 and self.totalNum <= 100 and self.isLoadExploration == false then
		self:loadingExplorationMap()
	end
	self.totalNum = self.totalNum + 1
end
function ExplorationLoading:loadingSuccess( ... )
	self:unregisterOnNoteUpdate(self)
    self:closeUi()
end

function ExplorationLoading:closeUi( ... )
	local action = self.actions[1]
    action:play("window_close", false)
    local root = self.roots[1]
    self.Panel_loading_ing:setVisible(false)
    local Panel_donghua = ccui.Helper:seekWidgetByName(root, "Panel_donghua")
	local ArmatureNode_2 = Panel_donghua:getChildByName("ArmatureNode_2")
	if ArmatureNode_2 ~= nil then
		ArmatureNode_2:resume()
	    csb.animationChangeToAction(ArmatureNode_2, 2, 2, false)
    	-- ArmatureNode_2:getAnimation():playWithIndex(2, 2, 0)
    end
end

function ExplorationLoading:loadingPng( ... )
	self.isLoadPng = true
	local function loaded( ... )
		
	end
	local _pic = {
		"images/ui/play/wonderful_activity/build_discount_bg.png",
		"images/ui/play/wonderful_activity/shouchong_slots_1.png",
		"images/ui/play/wonderful_activity/seven_day/text_1.png",
		"images/ui/play/wonderful_activity/seven_day/text_2.png",
		"images/ui/play/wonderful_activity/seven_day/text_3.png",
		"images/ui/play/wonderful_activity/seven_day/text_4.png",
		"images/ui/play/wonderful_activity/seven_day/text_5.png",
		"images/ui/play/wonderful_activity/seven_day/text_6.png",
		"images/ui/play/wonderful_activity/seven_day/text_7.png",
		"images/ui/play/wonderful_activity/seven_day/text_8.png",
		"images/ui/play/wonderful_activity/seven_day/text_9.png",
		"images/ui/play/wonderful_activity/seven_day/text_10.png",
		"images/ui/play/wonderful_activity/seven_day/text_11.png",
		"images/ui/play/wonderful_activity/seven_day/text_12.png",
		"images/ui/play/wonderful_activity/seven_day/text_13.png",
		"images/ui/play/wonderful_activity/seven_day/text_14.png",
		"images/ui/play/wonderful_activity/seven_day/text_15.png",
		"images/ui/play/wonderful_activity/seven_day/text_16.png",
		"images/ui/home/head_1.png",
		"images/ui/home/head_2.png",
		"images/ui/home/head_3.png",
		"images/ui/home/head_4.png",
		"images/ui/home/head_5.png",
		"images/ui/home/head_6.png",
		"images/ui/home/head_7.png",
		"images/ui/home/head_8.png",
		"images/ui/home/head_9.png",
		"images/ui/home/head_10.png",
		"images/ui/home/head_11.png",
		"images/ui/home/home_add_bg.png",
		"images/ui/home/wanjia_cg_head_1.png",
		"images/ui/home/wanjia_cg_head_2.png",
		"images/ui/slots/jt_paper3_di.png",
		"images/ui/slots/jt_paper3.png",
		"images/ui/bar/bar_11.png",
	}
	local textureCache = cc.Director:getInstance():getTextureCache()
	for k,v in pairs(_pic) do
		-- cc.Director:getInstance():getTextureCache():addImage(v)
		textureCache:addImageAsync(v, loaded, nil, false, true)
	end
end
if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
	then
	ExplorationLoading._plist = {
		{
			_png = "images/ui/home/home.png", 
			_plist = "images/ui/home/home.plist"
		}
	}
	localData_list_new_load_next()
else
	ExplorationLoading._plist = {
		{
			_png = "images/ui/home/home.png", 
			_plist = "images/ui/home/home.plist"
		},
		{
			_png = "images/ui/play/wonderful_activity/seven_day/seven_day.png", 
			_plist = "images/ui/play/wonderful_activity/seven_day/seven_day.plist"
		},
		{
			_png = "images/ui/play/wonderful_activity/wonderful_activity.png", 
			_plist = "images/ui/play/wonderful_activity/wonderful_activity.plist"
		},
		{
			_png = "images/ui/play/wonderful_activity/wonderful_activity_1.png", 
			_plist = "images/ui/play/wonderful_activity/wonderful_activity_1.plist"
		}
	}
end
function ExplorationLoading.load_plist()
	
	for k,v in pairs(ExplorationLoading._plist) do
		cc.SpriteFrameCache:getInstance():addSpriteFrames(v._plist)
	end
end

function ExplorationLoading:loadingPlist( ... )
	self.isLoadPlist = true
	local function loaded( ... )
		
	end
	-- local _plist = {
	-- 	{
	-- 		_png = "images/ui/home/home.png", 
	-- 		_plist = "images/ui/home/home.plist"
	-- 	},
	-- 	{
	-- 		_png = "images/ui/play/wonderful_activity/seven_day/seven_day.png", 
	-- 		_plist = "images/ui/play/wonderful_activity/seven_day/seven_day.plist"
	-- 	},
	-- 	{
	-- 		_png = "images/ui/play/wonderful_activity/wonderful_activity.png", 
	-- 		_plist = "images/ui/play/wonderful_activity/wonderful_activity.plist"
	-- 	},
	-- 	{
	-- 		_png = "images/ui/play/wonderful_activity/wonderful_activity_1.png", 
	-- 		_plist = "images/ui/play/wonderful_activity/wonderful_activity_1.plist"
	-- 	}
	-- }
	-- for k,v in pairs(ExplorationLoading._plist) do
	-- 	cc.Director:getInstance():getTextureCache():addImage(v._png)
	-- 	cc.SpriteFrameCache:getInstance():addSpriteFrames(v._plist)
	-- 	cc.Director:getInstance():getTextureCache():getTextureForKey(v._png):retain()
	-- 	-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(v._png)
	-- end
end

function ExplorationLoading:loadingExplorationMap( ... )
	-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	-- 	dms.format("ship_mould")
	-- end
	self.isLoadExploration = true
	if self.fightType == 218 then
		app.load("client.l_digital.campaign.worldboss.WorldBossWindow")
		state_machine.excute("world_boss_window_open", 0, 0)
	else
		app.load("client.l_digital.campaign.exploration.ExplorationMap")
        state_machine.excute("exploration_map_open", 0, "")
	end
	
end

function ExplorationLoading:onEnterTransitionFinish()
	
end

function ExplorationLoading:onExit()

end

function ExplorationLoading:loadArmature( ... )
	local path = "images/ui/effice/effect_kaichang/effect_kaichang.ExportJson"
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
end

function ExplorationLoading:unLoadArmature( ... )
	local path = "images/ui/effice/effect_kaichang/effect_kaichang.ExportJson"
	ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(path)
end