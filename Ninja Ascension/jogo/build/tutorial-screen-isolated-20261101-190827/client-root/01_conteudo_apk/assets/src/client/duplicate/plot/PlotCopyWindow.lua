-- ----------------------------------------------------------------------------------------------------
-- 说明：主线副本窗口
-------------------------------------------------------------------------------------------------------
PlotCopyWindow = class("PlotCopyWindowClass", Window)

function PlotCopyWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.maxMapCount = 0
    self.openSceneList = {}
	
	app.load("client.cells.copy.plot_copy_group_cell")
    -- Initialize PlotCopyWindow page state machine.
    local function init_plot_copy_window_list_terminal()	
		-- 控制进入pve副本地图
		local plot_copy_window_into_pve_scene_terminal = {
            _name = "plot_copy_window_into_pve_scene",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)		
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(plot_copy_window_into_pve_scene_terminal)
        state_machine.init()
    end
    
    -- call func init PlotCopyWindow state machine.
    init_plot_copy_window_list_terminal()
end

function PlotCopyWindow:init()
    local sCountCurrent = 0 --用于记录当前有多少条场景
    local normalScene = {}
    local sCount = 0
    local maxCount = 0
    local bLastScene = false
    
    local function getOpenSceneList()
        for i=1,table.getn(_ED.scene_current_state) do
            local _scene_type = dms.int(dms["pve_scene"], i, pve_scene.scene_type) --tonumber(elementAtToString(pveScene,i,pve_scene.scene_type))
            --> print(_scene_type)
			if _scene_type == 0 then
                if _ED.scene_current_state[i]==nil or _ED.scene_current_state[i]=="" then
                    return
                end
                if tonumber(_ED.scene_current_state[i]) < 0 then
                    return
                end
                sCount = sCount + 1
                sCountCurrent = sCount
                normalScene[sCount] = i
            end
        end
    end
    getOpenSceneList()
                
    maxCount = sCount

    self.maxMapCount = sCount
    self.openSceneList = normalScene
end

function PlotCopyWindow:onUpdateDraw()
	-- 实现对主线副本列表窗口的绘制
	local root = self.roots[1]
    local maxSceneCount = self.maxMapCount                         	--当前已开启的关卡总数
	local maxSceneCountTeam = math.ceil((maxSceneCount - 1) / 4) + 1			--四个关卡一组，组数
	local isMultiple = maxSceneCount % 4							--是否为4的倍数
	local ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_1") --需要添加cells到的 ScrollView
	local allCellsHight = 0   										--初始高度
	local index = 1
	
    for i = 1,maxSceneCountTeam do
		local cell 	= PlotGroupCopyCell:createCell()
		cell:init({
		self.openSceneList[index], 
		self.openSceneList[index + 1], 
		self.openSceneList[index + 2], 
		self.openSceneList[index + 3]})
		ScrollView:addChild(cell)
		local cellHight = cell:getContentSize().height         --该组件高度
		cell:setPosition(cc.p(0,allCellsHight))
		allCellsHight = allCellsHight + cellHight
	end
end

function PlotCopyWindow:onEnterTransitionFinish()
	local csbPveList = csb.createNode("duplicate/pve_list.csb")
	local root = csbPveList:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPveList)

    self:onUpdateDraw()
end

function PlotCopyWindow:onExit()
    state_machine.remove("plot_copy_window_into_pve_scene")
end