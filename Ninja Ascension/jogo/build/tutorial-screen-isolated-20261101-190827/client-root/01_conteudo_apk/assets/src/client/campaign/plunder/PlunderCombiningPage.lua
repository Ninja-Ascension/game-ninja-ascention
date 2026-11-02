-- ----------------------------------------------------------------------------------------------------
-- 说明：夺宝——合成宝物子界面
-- 创建时间	2015-03-06
-- 作者：胡文轩
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
PlunderCombiningPage = class("PlunderCombiningPageClass", Window)
    
function PlunderCombiningPage:ctor()
    self.super:ctor()
	self.roots = {}
	self.panels = {}			-- 存放所有层
	self.treasureTem = nil		-- 存放要合成的宝物模板ID
	self.grabRankLink = nil     -- 抢夺索引值
	self.need_prop = {}     	-- 抢夺需要道具1 2 3 4 5 6
	self.formation = 0			-- 摆放位子
	self.action = nil
	self.cacheTreasureNameText = nil	--缓存宝物名称显示的text
	self._armature = nil
	self.formationEnumType = 	-- 摆放位子枚举
	{
		_THREE_FRAGMENT = 3,
		_FOUR_FRAGMENT = 4,
		_FIVE_FRAGMENT = 5,
		_SIX_FRAGMENT = 6,
	}
	
	self.formationEnumPos = { -- 摆放位子位置
		_THREE_FRAGMENT = {},
		_FOUR_FRAGMENT = {},
		_FIVE_FRAGMENT = {},
		_SIX_FRAGMENT = {},
	}	
	
	self.types = nil
	
	app.load("client.campaign.plunder.TreasurePorpIcon")
    -- Initialize PlunderCombiningPage page state machine.
    local function init_plunder_combining_page_terminal()
	-- 夺宝信息初始化
		local plunder_combining_page_update_treasure_terminal = {
            _name = "plunder_combining_page_update_treasure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				params.action:play("window_open", false)
				params:onUpdataProcessing()
				params:onUpdataDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local plunder_combining_page_open_info_terminal = {
            _name = "plunder_combining_page_open_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				params._datas.cell: openInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local plunder_combining_page_action_terminal = {
            _name = "plunder_combining_page_action",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				local function startAction()
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						if params == nil or params.roots == nil then
							return
						end
					end
					local Panel_1035 = ccui.Helper:seekWidgetByName(params.roots[1], "Panel_1035")
					Panel_1035:setVisible(true)
					-- self.cacheFightArmature = ccui.Helper:seekWidgetByName(params.roots[1], "Panel_1035"):getChildByName("ArmatureNode_9")
					-- self.cacheFightArmature:getAnimation():playWithIndex(0)
					
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						local function changeActionCallback(armatureBack)
							local armature = armatureBack
							if armature ~= nil then
								armature:removeFromParent(true)
								state_machine.excute("plunder_combining_page_ready_over", 0, "plunder_combining_page_ready_over.")
							end
						end
						local armature = ccs.Armature:create("effect_ui_85")
				        draw.initArmature(armature, nil, -1, 0, 1)
						Panel_1035:addChild(armature)
						armature._invoke = nil
						armature._actionIndex = 0
						armature:getAnimation():playWithIndex(0)
						armature._invoke = changeActionCallback
					else
						local function changeActionCallback(armatureBack)
							local armature = armatureBack
							if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
								or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
								if armature:isVisible() == true then 
									armature:setVisible(false)
									state_machine.excute("plunder_combining_page_ready_over", 0, "plunder_combining_page_ready_over.")
								end
							else
								if armature ~= nil then
									state_machine.excute("plunder_combining_page_ready_over", 0, "plunder_combining_page_ready_over.")
								end	
							end						
						end
						if params._armature == nil then
							params._armature = ccui.Helper:seekWidgetByName(params.roots[1], "Panel_1035"):getChildByName("ArmatureNode_9")
							if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
								or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
								draw.initArmature(params._armature, nil, -1, 0, 1)
    							csb.animationChangeToAction(params._armature, 0, 0, false)
								params._armature:setVisible(true)
							else
								draw.initArmature(params._armature, nil, 1, nil, nil)	
							end
							params._armature._show = false
						else
							if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
								or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
								draw.initArmature(params._armature, nil, -1, 0, 1)
    							csb.animationChangeToAction(params._armature, 0, 0, false)
								params._armature:setVisible(true)
							end
						end
						params._armature._invoke = nil
						params._armature._actionIndex = 0
						params._armature:getAnimation():playWithIndex(0)
						params._armature._invoke = changeActionCallback
					end
				end

				if params.types == 3 then
					
					params.action:setFrameEventCallFunc(function (frame)
						if nil == frame then
							return
						end

						local str = frame:getEvent()
						if str == "compound_1_over" then
							startAction()
						end
					end)
					params.action:play("compound_1", false)
				elseif params.types == 4 then
					params.action:play("compound_2", false)
					params.action:setFrameEventCallFunc(function (frame)
						if nil == frame then
							return
						end

						local str = frame:getEvent()
						if str == "compound_2_over" then
							startAction()
						end
					end)
				elseif params.types == 5 then
					params.action:play("compound_3", false)
					params.action:setFrameEventCallFunc(function (frame)
						if nil == frame then
							return
						end

						local str = frame:getEvent()
						if str == "compound_3_over" then
							startAction()
						end
					end)
				elseif params.types == 6 then
					params.action:play("compound_4", false)
					params.action:setFrameEventCallFunc(function (frame)
						if nil == frame then
							return
						end

						local str = frame:getEvent()
						if str == "compound_4_over" then
							startAction()
						end
					end)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(plunder_combining_page_open_info_terminal)
		state_machine.add(plunder_combining_page_update_treasure_terminal)
		state_machine.add(plunder_combining_page_action_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_plunder_combining_page_terminal()
end

-- 数据处理
function PlunderCombiningPage:onUpdataProcessing()
	self.need_prop =
	{
		tonumber(dms.int(dms["grab_rank_link"], self.grabRankLink, grab_rank_link.need_prop1)),
		tonumber(dms.int(dms["grab_rank_link"], self.grabRankLink, grab_rank_link.need_prop2)),
		tonumber(dms.int(dms["grab_rank_link"], self.grabRankLink, grab_rank_link.need_prop3)),
		tonumber(dms.int(dms["grab_rank_link"], self.grabRankLink, grab_rank_link.need_prop4)),
		tonumber(dms.int(dms["grab_rank_link"], self.grabRankLink, grab_rank_link.need_prop5)),
		tonumber(dms.int(dms["grab_rank_link"], self.grabRankLink, grab_rank_link.need_prop6))
	}
end

-- 刷新界面
function PlunderCombiningPage:onUpdataDraw()
	self.formation = 0		--记录需要碎片个数
	for i = 1,6 do
		if	self.need_prop[i] ~= -1 then
			self.formation = self.formation + 1
		end
	end
	-- 摆放方式不一样
	if self.formation == self.formationEnumType._THREE_FRAGMENT then			--3
		for i = 1, self.formationEnumType._THREE_FRAGMENT do
			local cell = TreasurePorpIcon:createCell()
			cell:init(self.need_prop[i])
			local item = self.formationEnumPos._THREE_FRAGMENT
			local panel = ccui.Helper:seekWidgetByName(self.roots[1], item[i])
			panel:removeAllChildren(true)
			panel:addChild(cell)
		end
		self.types = 3
	elseif self.formation == self.formationEnumType._FOUR_FRAGMENT then				--4
		for i = 1, self.formationEnumType._FOUR_FRAGMENT do
			local cell = TreasurePorpIcon:createCell()
			cell:init(self.need_prop[i])
			local item = self.formationEnumPos._FOUR_FRAGMENT
			local panel = ccui.Helper:seekWidgetByName(self.roots[1], item[i])
			panel:removeAllChildren(true)
			panel:addChild(cell)
		end
		self.types = 4
	elseif self.formation == self.formationEnumType._SIX_FRAGMENT then				--6
		for i = 1, self.formationEnumType._SIX_FRAGMENT do
			local cell = TreasurePorpIcon:createCell()
			cell:init(self.need_prop[i])
			local item = self.formationEnumPos._SIX_FRAGMENT
			local panel = ccui.Helper:seekWidgetByName(self.roots[1], item[i])
			panel:removeAllChildren(true)
			panel:addChild(cell)
		end
		self.types = 6
	elseif self.formation == self.formationEnumType._FIVE_FRAGMENT then					--5
		for i = 1, self.formationEnumType._FIVE_FRAGMENT do
			local cell = TreasurePorpIcon:createCell()
			cell:init(self.need_prop[i])
			local item = self.formationEnumPos._FIVE_FRAGMENT
			local panel = ccui.Helper:seekWidgetByName(self.roots[1], item[i])
			panel:removeAllChildren(true)
			panel:addChild(cell)
		end
		self.types = 5
	end
	
	--设置当前欲抢夺宝物的icon
	picIndex = tonumber(dms.string(dms["equipment_mould"], self.treasureTem, equipment_mould.All_icon))
	self.panel_baowu:setBackGroundImage(string.format("images/ui/big_props/big_props_%d.png", picIndex))
	
	--显示宝物的名称
	local equipName = dms.string(dms["equipment_mould"], self.treasureTem, equipment_mould.equipment_name)
	self.cacheTreasureNameText:setString(equipName)
	
	local equipment_type = dms.int(dms["equipment_mould"], self.treasureTem, equipment_mould.equipment_type) 
	self.panel_baiwuneixin:setBackGroundImage(string.format("images/ui/quality/zb_leixing_%d.png", equipment_type))

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local equipment_grow_level =tonumber(dms.int(dms["equipment_mould"], self.treasureTem, equipment_mould.grow_level))
		if equipment_grow_level == 0 then
			self.cacheTreasureNameText:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
		elseif equipment_grow_level == 1 then
			self.cacheTreasureNameText:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
		elseif equipment_grow_level == 2 then
			self.cacheTreasureNameText:setColor(cc.c3b(color_Type[3][1], color_Type[3][2], color_Type[3][3]))
		elseif equipment_grow_level == 3 then
			self.cacheTreasureNameText:setColor(cc.c3b(color_Type[4][1], color_Type[4][2], color_Type[4][3]))
		elseif equipment_grow_level == 4 then
			self.cacheTreasureNameText:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
		elseif equipment_grow_level == 5 then
			self.cacheTreasureNameText:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
		end
	end
end

			
function PlunderCombiningPage:openInfo()
	local page = EquipFragmentInfomation:createCell()
	page:init(self.treasureTem, 2 ,3)
	fwin:open(page, fwin._view)
end

function PlunderCombiningPage:loadDraw()
	local root = self.roots[1]
    if root ~= nil then
        return
    end
	self:initDraw()
end

--重新绘制，与loadDraw有不同，不用移除
function PlunderCombiningPage:reloadDraw()
	self:onUpdataDraw()
	state_machine.excute("plunder_update_pageview_check_reward",0,"")
end

function PlunderCombiningPage:removeDraw()
	local root = self.roots[1]
    if root == nil then
        return
    end
    for k,v in pairs(self.formationEnumPos) do
		for k1,v1 in pairs(v) do
			local panel = ccui.Helper:seekWidgetByName(root, v1)
			panel:removeAllChildren(true)
		end
	end
    cacher.freeRef("campaign/Snatch/snatch.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
	self._armature = nil
	self.action = nil
end

function PlunderCombiningPage:initDraw()

	local root = cacher.createUIRef("campaign/Snatch/snatch.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

	table.insert(self.roots, root)
	
	local action = csb.createTimeline("campaign/Snatch/snatch.csb")
	action:play("window_open", false)
	root:runAction(action)
	self.action = action
	local panelTemp = ccui.Helper:seekWidgetByName(root, "Panel_baiwuneixin")		--宝物类型
	local name = ccui.Helper:seekWidgetByName(root, "Label_3101")				--宝物名字
	
	--宝物图片容器
	self.panel_baowu = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_baowu")
	self.panel_baowu:setSwallowTouches(false)
	self.panel_baowu:setTouchEnabled(true)
	
	--宝物类型容器
	self.panel_baiwuneixin = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_baiwuneixin")
	
	fwin:addTouchEventListener(self.panel_baowu, nil, 
	{
		terminal_name = "plunder_combining_page_open_info", 
		cell = self,
		terminal_state = nil,
	},
	nil, 1)	

	
	self.formationEnumPos = { -- 摆放位子位置
		_THREE_FRAGMENT = {"Panel_3070", "Panel_3072","Panel_3074"},
		_FOUR_FRAGMENT = {"Panel_3070", "Panel_3077", "Panel_3073", "Panel_3076"},
		_FIVE_FRAGMENT = {"Panel_3070","Panel_3071","Panel_3072","Panel_3074","Panel_3075"},
		_SIX_FRAGMENT = {"Panel_3070","Panel_3071","Panel_3072","Panel_3073","Panel_3074","Panel_3075"},
	}

	for k,v in pairs(self.formationEnumPos) do
		for k1,v1 in pairs(v) do
			local panel = ccui.Helper:seekWidgetByName(root, v1)
			panel:removeAllChildren(true)
		end
	end
	--缓存宝物名称显示的text
	self.cacheTreasureNameText = ccui.Helper:seekWidgetByName(root, "Label_3101")
	
	-- 夺宝初始化
	self:onUpdataProcessing()
	self:onUpdataDraw()
end




function PlunderCombiningPage:onEnterTransitionFinish()
    -- local csbPlunderCombining = csb.createNode("campaign/Snatch/snatch.csb")
   	-- local root = csbPlunderCombining:getChildByName("root")
	-- root:removeFromParent(true)
    -- self:addChild(root)
	-- table.insert(self.roots, root)
	
	-- local action = csb.createTimeline("campaign/Snatch/snatch.csb")
    -- action:play("window_open", false)
	-- root:runAction(action)
	-- self.action = action
	-- local panelTemp = ccui.Helper:seekWidgetByName(root, "Panel_baiwuneixin")		--宝物类型
	-- local name = ccui.Helper:seekWidgetByName(root, "Label_3101")				--宝物名字
	
	-- --宝物图片容器
	-- self.panel_baowu = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_baowu")
	-- self.panel_baowu:setSwallowTouches(false)
	-- self.panel_baowu:setTouchEnabled(true)
	
	-- --宝物类型容器
	-- self.panel_baiwuneixin = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_baiwuneixin")
	
	-- fwin:addTouchEventListener(self.panel_baowu, nil, 
	-- {
		-- terminal_name = "plunder_combining_page_open_info", 
		-- cell = self,
		-- terminal_state = nil,
	-- },
	-- nil, 1)	

	
	-- self.formationEnumPos = { -- 摆放位子位置
		-- _THREE_FRAGMENT = {"Panel_3070", "Panel_3072","Panel_3074"},
		-- _FOUR_FRAGMENT = {"Panel_3070", "Panel_3077", "Panel_3073", "Panel_3076"},
		-- _FIVE_FRAGMENT = {"Panel_3070","Panel_3071","Panel_3072","Panel_3074","Panel_3075"},
		-- _SIX_FRAGMENT = {"Panel_3070","Panel_3071","Panel_3072","Panel_3073","Panel_3074","Panel_3075"},
	-- }
	-- --缓存宝物名称显示的text
	-- self.cacheTreasureNameText = ccui.Helper:seekWidgetByName(root, "Label_3101")
	
	-- -- 夺宝初始化
	-- self:onUpdataProcessing()
	-- self:onUpdataDraw()
end

function PlunderCombiningPage:close( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or
		__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		local root = self.roots[1]
		for k,v in pairs(self.formationEnumPos) do
			for k1,v1 in pairs(v) do
				local panel = ccui.Helper:seekWidgetByName(root, v1)
				panel:removeAllChildren(true)
			end
		end
	end
end

function PlunderCombiningPage:onExit()	
	cacher.freeRef("campaign/Snatch/snatch.csb", self.roots[1])
	--state_machine.remove("plunder_combining_page_update_treasure")
	--state_machine.remove("plunder_combining_page_open_info")
	-- state_machine.remove("plunder_combining_page_action")
	
end

function PlunderCombiningPage:init(tem)	
	self.treasureTem = tem							--传入的模板ID
	--> print("self.treasureTem", grab_rank_link.equipment_mould, self.treasureTem)
	local datas = dms.searchs(dms["grab_rank_link"], grab_rank_link.equipment_mould, self.treasureTem)		--取到对应的数据集合(应该只有一个值)
	self.grabRankLink = datas[1][grab_rank_link.id]															--抢夺关系表里面的对应id
	
end

function PlunderCombiningPage:createCell()
	local cell = PlunderCombiningPage:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
