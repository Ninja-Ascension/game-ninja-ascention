-- ----------------------------------------------------------------------------------------------------
-- 说明：副本菜单LIST
-- 创建时间
-- 作者：胡文轩
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
DuplicateList = class("DuplicateListClass", Window)
    

	
function DuplicateList:ctor()
    self.super:ctor()
    self.roots = {}
    -- Initialize DuplicateList page state machine.
    local function init_duplicate_list_terminal()	
		-- 进入名将副本集
		local duplicate_list_enter_game_plot_carbon_terminal = {
            _name = "duplicate_list_enter_game_plot_carbon",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)    
				app.load("client.duplicate.common.GameComon")
				fwin:open(GameComon:new(), fwin._ui)
				fwin:close(fwin:find("DuplicateClass"))
				fwin:close(instance)			
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 进入主线副本集
		local duplicate_list_enter_game_elite_terminal = {
            _name = "duplicate_list_enter_game_elite",
            _init = function (terminal)          
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.duplicate.elite.GameElite")
				local theClass = GameElite:new()
				GameElite:initData(params[1], params[2]) 
				fwin:open(theClass, fwin._view)			
				fwin:close(fwin:find("DuplicateClass"))
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
	
		state_machine.add(duplicate_list_enter_game_plot_carbon_terminal)
		state_machine.add(duplicate_list_enter_game_elite_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_duplicate_list_terminal()
end

local function goodsButtonCallback(sender, eventType)
	if eventType == ccui.TouchEventType.ended then
		app.load("client.duplicate.elite.GameElite")
		GameElite:createCell(sender._item,sender.munber)
		fwin:open(GameElite:new(), fwin._view)				
		fwin:close(fwin:find("DuplicateClass"))
		fwin:close(instance)
	elseif eventType == ccui.TouchEventType.began then
	end
end

function DuplicateList:onEnterTransitionFinish()
	table.insert(self.roots, csbTrialTowerJuese_root)
	local csbDuplicate = csb.createNode("duplicate/pve_list.csb")
    self:addChild(csbDuplicate)
	local root1 = csbDuplicate:getChildByName("root")
	local ScrollView_1 = ccui.Helper:seekWidgetByName(root1, "ScrollView_1")
	
	
	local index = 0
	local maxSceneCount = 9 						--当前已开启的关卡总数
	local tCount = math.ceil(maxSceneCount / 4)		--当前的地图拼接数量（向上取整）
	local mCount = maxSceneCount % 4				--取多出的余数
	local mHit = 340
	local itmeH = 60
	
	if maxSceneCount < 4 then						-- 如果当前关卡小于4 ，就不让地图滑动
		tCount = 1
		mHit = 0
	else
		if mCount == 0 then							--如果当前关卡是4的倍数就默认在上面多拼一张地图
			tCount = tCount+1						
		end
	end
	
	local ZOrder = 999
	local cells = {}
	for i = 1,tCount do
		local csbDuplicateList = csb.createNode("duplicate/pve_bg.csb")
		local root = csbDuplicateList:getChildByName("root")
		local cell = ccui.Helper:seekWidgetByName(root, "Panel_2")
		table.insert(cells, cell)
		csbDuplicateList:setLocalZOrder(ZOrder)
		ZOrder = ZOrder - 1
		ScrollView_1:addChild(csbDuplicateList)
		csbDuplicateList:setPosition(cc.p(0,index*cell:getContentSize().height))
		index = index + 1
	end
	
	for i = 1 , maxSceneCount do
		local curN = i - 4 * math.floor(i / 4)
		if curN == 0 then
			curN = 4
		end	
		
		local cell_index = math.ceil(i / 4)
		local ProjectNode = cells[cell_index]:getChildByName(string.format("ProjectNode_%d", curN))
		ProjectNode:setVisible(true)
		
		local cur_root = ProjectNode:getChildByName("root")
		local rootItem = ccui.Helper:seekWidgetByName(cur_root, "Panel_2"):getChildByName("ProjectNode_1"):getChildByName("root")
		
		local name = dms.string(dms["pve_scene"], i, pve_scene.scene_name)
		local icon = dms.string(dms["pve_scene"], i, pve_scene.scene_entry_pic)
		local isMaxStarOver = true
		local curStar = "1"
		local starStr = curStar.."/"..dms.string(dms["pve_scene"], i, pve_scene.total_star)
		
		ccui.Helper:seekWidgetByName(rootItem, "Text_5"):setString(name)
		ccui.Helper:seekWidgetByName(rootItem, "Text_5_0"):setString(starStr)
		ccui.Helper:seekWidgetByName(rootItem, "Panel_7"):setBackGroundImage(string.format("images/ui/pve_sn/pve_name_%s.png", icon))
		
		if i == maxSceneCount then
			ccui.Helper:seekWidgetByName(cur_root, "Panel_1"):setVisible(false)
			isMaxStarOver = false
		else
			ccui.Helper:seekWidgetByName(rootItem, "Panel_106"):setVisible(false)
		end
		
		local lingpai = ccui.Helper:seekWidgetByName(cur_root, "Panel_2"):getChildByName("icon_lingpai")
		if isMaxStarOver == true then
			lingpai:setVisible(true)
		else
			lingpai:setVisible(false)
		end
		
		--TODO
		local enterBtn = ccui.Helper:seekWidgetByName(cur_root, "Panel_2"):getChildByName("Button_1")
		enterBtn:setTouchEnabled(true)
		enterBtn:setSwallowTouches(false)
		local function openDuplicateCallback(sender, eventType)
			state_machine.excute("duplicate_list_enter_game_elite", 0, {name, i})
		end
		
		fwin:addTouchEventListener(enterBtn, openDuplicateCallback, nil, nil, 0)
	end
	
	ScrollView_1:setInnerContainerSize(cc.size(640,(index-1)*cells[1]:getContentSize().height+(cells[1]:getContentSize().height/4)*mCount+mHit))
	ScrollView_1:jumpToBottom()
end

function DuplicateList:onExit()
	state_machine.remove("duplicate_list_enter_game_plot_carbon")
	state_machine.remove("duplicate_list_enter_game_elite")
end