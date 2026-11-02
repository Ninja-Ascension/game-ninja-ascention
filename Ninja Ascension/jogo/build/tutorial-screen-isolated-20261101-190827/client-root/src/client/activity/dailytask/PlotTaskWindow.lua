-- ----------------------------------------------------------------------------------------------------
-- 说明：主线任务窗口
-------------------------------------------------------------------------------------------------------
PlotTaskWindow = class("PlotTaskWindowClass", Window)

local plot_task_window_open_terminal = {
    _name = "plot_task_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("PlotTaskWindowClass") then
            fwin:open(PlotTaskWindow:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local plot_task_window_close_terminal = {
    _name = "plot_task_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlotTaskWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(plot_task_window_open_terminal)
state_machine.add(plot_task_window_close_terminal)
state_machine.init()

function PlotTaskWindow:ctor()
    self.super:ctor()
	self.roots = {}
    self.actions = {}

    -- load lua files
    app.load("client.activity.dailytask.newachieve.achievement_list_cell_new")

    -- var
    self.list_view = nil
    self.list_view_posY = nil

    self.sort_datas = {} --排序后的数据
    self.tsort_datas = {} --临时存储数据

    -- Initialize init window state machine
    local function init_plot_task_window_terminal()
        state_machine.init()
    end
    
    -- The call func init window state machine.
    init_plot_task_window_terminal()
end

function PlotTaskWindow:init(params)
    return self
end

function PlotTaskWindow:onUpdate()
    if self.list_view ~= nil then
        local size = self.list_view:getContentSize()
        local posY = self.list_view:getInnerContainer():getPositionY()
        if self.list_view_posY == posY then
            return
        end
        self.list_view_posY = posY
        local items = self.list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function PlotTaskWindow:onUpdateDraw()
    self:getSort()

    local root = self.roots[1]
    local ListView_cj_list = ccui.Helper:seekWidgetByName(root,"ListView_cj_list")
    ListView_cj_list:jumpToTop()
    ListView_cj_list:removeAllItems()
    local index = 1
    for i , v in pairs(self.sort_datas) do
        if 0 ~= v.state then
            local beforeId = dms.atos(v.achieve_data, achieve.before_id)
            local beforeTask = self.tsort_datas[beforeId]
            if nil == beforeTask or 0 == beforeTask.state then
                local cell = AchievementListCellNew:createCell()
                cell:init(self.achieve_type,v,index)
                ListView_cj_list:addChild(cell)
                index = index + 1
            end
        end
    end
    ListView_cj_list:requestRefreshView()
    self.list_view = ListView_cj_list
    self.list_view_posY = ListView_cj_list:getInnerContainer():getPositionY()
    -- 无任务时,添加提示
    state_machine.excute("daily_task_empty_list",0,{mSender = ListView_cj_list})
end

function PlotTaskWindow:getSort()
    self.sort_datas = {} --排序后的数据
    self.tsort_datas = {} --临时存储数据


    -- print("=============",os.clock())
    for k, t in pairs(_ED.all_achieve_data) do
        for i ,v in pairs(t) do
            local groupId = dms.atoi(v,achieve.group_id)
            if groupId == 0 then
                local achieveid = dms.atoi(v,achieve.id)
                local nowpersent = tonumber(_ED.all_achieve[achieveid])
                local maxpersent = 0
                local data = 
                {
                    achieve_data = v,
                    achieve_id = achieveid,
                    state = 0,--0已领取 1 未达成 2 可领取
                    persent = nowpersent,
                    maxper = 0 ,
                }
                
                data.progress = 0

                if nowpersent ==  -1 then
                    data.state = 0 
                else
                    local param2 = dms.atoi(v,achieve.param2) 
                    local param3 = dms.atoi(v,achieve.param3) 
                    
                    if param3 ~= -1 then
                        maxpersent = param3
                    else 
                        maxpersent = param2
                    end
                    data.maxper = maxpersent
                    data.progress = nowpersent / maxpersent
                    if nowpersent >= maxpersent then
                        data.state = 2 
                    else
                        data.state = 1
                    end
                end

                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    local achieveTaskTrace = dms.atoi(v, achieve.track_address)
                    -- local openFunctionId = dms.int(dms["function_param"], achieveTaskTrace, function_param.open_function)
                    -- if nil == openFunctionId or openFunctionId > 0 and funOpenDrawTip(openFunctionId, false) == false then
                    --     table.insert(self.sort_datas,data)
                    --     self.tsort_datas["" .. achieveid] = data
                    -- end

                    local opened = true
                    if achieveTaskTrace > 0 then
                        local open_function = dms.int(dms["function_param"], achieveTaskTrace, function_param.open_function)
                        local open_leve=dms.int(dms["function_param"], achieveTaskTrace, function_param.open_leve)
                        local sceneId=dms.int(dms["function_param"], achieveTaskTrace, function_param.open_scene)
                        local npcId=dms.int(dms["function_param"], achieveTaskTrace, function_param.open_npc)
                        local by_open_vip=dms.int(dms["function_param"], achieveTaskTrace, function_param.by_open_vip)
                            
                        if dms.int(dms["achieve"],achieveid,achieve.achive_type) == 1 then
                            if open_leve > zstring.tonumber(_ED.user_info.user_grade)
                                or by_open_vip > tonumber(_ED.vip_grade)
                                or funOpenDrawTip(open_function, false)
                                then
                                opened = false
                            end
                        else
                            if open_leve > zstring.tonumber(_ED.user_info.user_grade)
                                or by_open_vip > tonumber(_ED.vip_grade)
                                or funOpenDrawTip(open_function, false)
                                or (nil ~= sceneId and sceneId > 0 and tonumber(_ED.scene_current_state[sceneId]) < 0)
                                or (nil ~= npcId and npcId > 0 and tonumber(_ED.npc_state[npcId]) <= 0)
                                then
                                opened = false
                            end
                        end
                    end
                    if true == opened then
                        table.insert(self.sort_datas, data)
                        self.tsort_datas["" .. achieveid] = data
                    end
                else
                    table.insert(self.sort_datas,data)
                    self.tsort_datas["" .. achieveid] = data
                end
            end
        end
    end 
    -- print("=============",os.clock())
    local function sortTable( a, b )
        return tonumber(a.state) > tonumber(b.state)
            -- or (tonumber(a.state) == tonumber(b.state) and (a.progress > b.progress or tonumber(a.achieve_id) > tonumber(b.achieve_id)))
            or (tonumber(a.state) == tonumber(b.state) and (a.progress > b.progress or (a.progress == b.progress and tonumber(a.achieve_id) > tonumber(b.achieve_id))))
    end

    table.sort(self.sort_datas,sortTable)
end

function PlotTaskWindow:onEnterTransitionFinish()
    local csbItem = csb.createNode("activity/DailyTasks/achieve_listview.csb")
    local root = csbItem:getChildByName("root")
    table.insert(self.roots,root)
    self:addChild(csbItem)

    self:onUpdateDraw()
end

function PlotTaskWindow:onExit()
end
-- ~END
-- ----------------------------------------------------------------------------------------------------