-----------------------------
-- 我的营地
-----------------------------
SmUnionMyCampsite = class("SmUnionMyCampsiteClass", Window)
SmUnionMyCampsite.__size = nil

local sm_union_my_campsite_open_terminal = {
    _name = "sm_union_my_campsite_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmUnionMyCampsite:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_my_campsite_open_terminal)
state_machine.init()

function SmUnionMyCampsite:ctor()
    self.super:ctor()
    self.roots = {}

    self.prop_list = {}
    self.m_index = 1
    self.isUpdate = false
    self.my_time = os.time() - 60
    self.update_time = 0
    app.load("client.l_digital.cells.union.union_energy_house_position_cell")
    self.cell_group = {}
    self.drawEnd = false

    local function init_sm_union_my_campsite_terminal()
		--显示界面
		local sm_union_my_campsite_show_terminal = {
            _name = "sm_union_my_campsite_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--隐藏界面
		local sm_union_my_campsite_hide_terminal = {
            _name = "sm_union_my_campsite_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        --刷新
        local sm_union_my_campsite_update_draw_cell_terminal = {
            _name = "sm_union_my_campsite_update_draw_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = tonumber(params)
                if ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_weizhi_"..index):getChildByTag(500+index) ~= nil then
                    local my_data = zstring.split(_ED.union_personal_energy_info,"|")
                    local open_data = zstring.split(my_data[2],",")
                    ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_weizhi_"..index):getChildByTag(500+index).openData = tonumber(open_data[index])
                    ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_weizhi_"..index):getChildByTag(500+index).training_info = my_data[2+index]
                    ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_weizhi_"..index):getChildByTag(500+index):updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

		state_machine.add(sm_union_my_campsite_show_terminal)	
        state_machine.add(sm_union_my_campsite_hide_terminal)
        state_machine.add(sm_union_my_campsite_update_draw_cell_terminal)

        state_machine.init()
    end
    init_sm_union_my_campsite_terminal()
end

function SmUnionMyCampsite:onHide()
    self:setVisible(false)
end

function SmUnionMyCampsite:onShow()
    self:setVisible(true)
end

function SmUnionMyCampsite:onUpdateDraw()
    local root = self.roots[1]
    local my_data = zstring.split(_ED.union_personal_energy_info,"|")
    for i=1, 8 do
        local cell = unionEnergyHousePositionCell:createCell()
        cell:init(i, tonumber(_ED.user_info.user_id))
        local shipData = zstring.split(my_data[2+i],",")
        table.insert(self.cell_group , cell)
        if tonumber(shipData[3]) > 0 then
            self.isUpdate = true
        end
        cell:setTag(500+i)
        ccui.Helper:seekWidgetByName(root,"Panel_weizhi_"..i):removeAllChildren(true)
        ccui.Helper:seekWidgetByName(root,"Panel_weizhi_"..i):addChild(cell)

        local exp = tonumber(_ED.union.union_energyhouse_exp_up[i])
        if exp and exp > 0 then
            cell.expText:setString(string.format(_new_interface_text[8] , exp))
            local function action1()
                cell.expText:setVisible(true)
            end

            local action2 = cc.MoveBy:create(0.8, cc.p(0, 80))

            local function action3()
                cell.expText:setVisible(false)
            end

            local action4 = cc.MoveBy:create(0.1, cc.p(0, -80))

            cell.expText:runAction(cc.Sequence:create(
                cc.DelayTime:create(0.8),
                cc.CallFunc:create(action1),
                action2,
                cc.CallFunc:create(action3),
                action4))
        end

    end
    self.drawEnd = true

    if self.isUpdate == true then
        self:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function ()
            cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onUpdate1), 60, false)
        end)))
    end
end

function SmUnionMyCampsite:onUpdate1(dt)
    local function responseUnionCreateCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            --加经验
            if response.node ~= nil and response.node.roots ~= nil then
                for i = 1 , 8 do
                    state_machine.excute("union_energy_house_position_cell_add_exp_show",0,response.node.cell_group[i])
                end
            end
        end
    end
    protocol_command.union_ship_train_check.param_list = "-1".."\r\n".."-1"
    NetworkManager:register(protocol_command.union_ship_train_check.code, nil, nil, nil, self, responseUnionCreateCallback, false, nil)
end

function SmUnionMyCampsite:onEnterTransitionFinish()

end

function SmUnionMyCampsite:onInit( )
    local csbItem = csb.createNode("legion/sm_legion_energy_house_tab_1.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    if SmUnionMyCampsite.__size == nil then
        SmUnionMyCampsite.__size = root:getContentSize()
    end
    self:setContentSize(SmUnionMyCampsite.__size)

    if __lua_project_id == __lua_project_l_naruto then
        --scrollview适配
        local scroll_view = ccui.Helper:seekWidgetByName(root,"ScrollView_bg")
        local scroll_size = scroll_view:getContentSize()
        local win_width = (fwin._width - app.baseOffsetX)
        local left_width = self._rootWindows:getPositionX() - SmUnionMyCampsite.__size.width/2

        local new_scroll_size = win_width - left_width
        scroll_view:setContentSize(cc.size(new_scroll_size, scroll_size.height))
    end

    self:onUpdateDraw()

end

function SmUnionMyCampsite:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmUnionMyCampsite:onExit()
    state_machine.remove("sm_union_my_campsite_show")    
    state_machine.remove("sm_union_my_campsite_hide")
end


