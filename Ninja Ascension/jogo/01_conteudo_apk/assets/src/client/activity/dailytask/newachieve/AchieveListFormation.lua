-- ----------------------------------------------------------------------------------------------------
-- 说明：成就新版
-- 创建时间	2015-11-25
-- 作者：yanghan
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

AchieveListFormation = class("AchieveListFormationClass", Window)
function AchieveListFormation:ctor()
    self.super:ctor()
	self.roots = {}
    self.list_view = nil
    self.list_view_posY = nil

    self.sort_datas = {} --排序后的数据
    self.achieve_type = nil
    -- Initialize EmailManager page state machine.
    local function init_achieve_list_formation_terminal()
        local achieve_list_formation_sort_terminal = {
            _name = "achieve_list_formation_sort",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:getSort()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local achieve_list_formation_remove_one_item_terminal = {
            _name = "achieve_list_formation_remove_one_item",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:removeOneItem(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(achieve_list_formation_sort_terminal)
        state_machine.add(achieve_list_formation_remove_one_item_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_achieve_list_formation_terminal()
end
function AchieveListFormation:removeOneItem(cell)
    local _cell = cell
    _cell:retain()
    self.list_view:removeItem(self.list_view:getIndex(cell))
    self.list_view:addChild(_cell)
    _cell:release()

    self.list_view:requestRefreshView()
end
function AchieveListFormation:getSort()
    local tables = _ED.all_achieve_data[self.achieve_type]
    --dms.searchs(dms["achieve"], achieve.open_level,self.achieve_type)
    -- print("====================",_ED.all_achieve)

    for i ,v in pairs(tables) do
        local achieveid = dms.atoi(v,achieve.id)
        local nowpersent = tonumber(_ED.all_achieve[achieveid])
        -- print("==============",_ED.all_achieve[achieveid])
        local maxpersent = 0
        local data = 
        {
            achieve_data = v,
            achieve_id = achieveid,
            state = 0,--0已领取 1 未达成 2 可领取
            persent = nowpersent,
            maxper = 0 ,
        }
        
        if  nowpersent ==  -1 then
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
            if nowpersent >= maxpersent then
                data.state = 2 
            else
                data.state = 1
            end
        end

        table.insert(self.sort_datas,data)
    end

    local function sortTable( a, b )
        return tonumber(a.state) > tonumber(b.state)
            or tonumber(a.state) == tonumber(b.state) and tonumber(a.achieve_id) < tonumber(b.achieve_id)
    end

    table.sort(self.sort_datas,sortTable)
end
function AchieveListFormation:onInit()
	local csbItem = csb.createNode("activity/DailyTasks/achieve_listview.csb")
	local root = csbItem:getChildByName("root")
	table.insert(self.roots,root)
    self:addChild(csbItem)
    state_machine.excute("achieve_list_formation_sort",0,"")
	self:onUpdateDraw()
end

function AchieveListFormation:onUpdate()
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
function AchieveListFormation:onUpdateDraw()
    local root = self.roots[1]
    local ListView_cj_list = ccui.Helper:seekWidgetByName(root,"ListView_cj_list")
    ListView_cj_list:removeAllItems()
    for i , v in pairs(self.sort_datas) do
        local cell = AchievementListCellNew:createCell()
        cell:init(self.achieve_type,v,i)
        ListView_cj_list:addChild(cell)
    end
    ListView_cj_list:requestRefreshView()
    self.list_view = ListView_cj_list
    self.list_view_posY = ListView_cj_list:getInnerContainer():getPositionY()
end
function AchieveListFormation:init(achieve_type)
    self.achieve_type = achieve_type
	self:onInit()
end
function AchieveListFormation:onEnterTransitionFinish()

end

function AchieveListFormation:onExit()
    state_machine.remove("achieve_list_formation_sort") 
    state_machine.remove("achieve_list_formation_remove_one_item")
end