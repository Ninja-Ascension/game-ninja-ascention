-----------------------------
-- 其他人的营地
-----------------------------
SmUnionAllCampsite = class("SmUnionAllCampsiteClass", Window)
SmUnionAllCampsite.__size = nil

local sm_union_all_campsite_open_terminal = {
    _name = "sm_union_all_campsite_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmUnionAllCampsite:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_all_campsite_open_terminal)
state_machine.init()

function SmUnionAllCampsite:ctor()
    self.super:ctor()
    self.roots = {}

    self.prop_list = {}
    self.m_index = 1
    app.load("client.l_digital.cells.union.union_energy_house_member")
    local function init_sm_union_all_campsite_terminal()
		--显示界面
		local sm_union_all_campsite_show_terminal = {
            _name = "sm_union_all_campsite_show",
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
		local sm_union_all_campsite_hide_terminal = {
            _name = "sm_union_all_campsite_hide",
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

        --随机加速
        local sm_union_all_campsite_random_accelerate_terminal = {
            _name = "sm_union_all_campsite_random_accelerate",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local my_data = zstring.split(_ED.union_personal_energy_info,"|")
                local accelerate = zstring.split(my_data[1],",")
                local param = zstring.split(dms.string(dms["union_config"], 25, union_config.param) ,",")
                if tonumber(param[1])-tonumber(accelerate[1]) > 0 then
                    local list = {}
                    for i, v in pairs(_ED.union_member_energy_info) do
                        if tonumber(v.member_id) ~= tonumber(_ED.user_info.user_id) then
                            local my_data = zstring.split(v.member_data,"|")
                            local count_info = zstring.split(my_data[1], ",")
                            if tonumber(param[2]) - tonumber(count_info[2]) > 0 then
                                local max_level = 0 
                                for j, w in pairs(_ED.union.union_member_list_info) do
                                    if tonumber(v.member_id) == tonumber(w.id) then
                                        max_level = tonumber(w.level)
                                        break
                                    end
                                end
                                for j=1, 8 do
                                    local shipData = zstring.split(my_data[2+j],",")
                                    if tonumber(shipData[3]) ~= 0 then
                                        local ability = dms.int(dms["ship_mould"], shipData[4], ship_mould.ability)
                                        local needExp = dms.int(dms["ship_experience_param"], tonumber(shipData[5]) + 1, ability-13+3)
                                        if tonumber(shipData[5]) >= max_level and tonumber(shipData[6]) >= tonumber(needExp) then
                                        else
                                            local datas = {}
                                            datas.id = v.member_id
                                            datas.index = j
                                            datas.shipId = shipData[3]
                                            table.insert(list, datas)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if #list > 0 then
                        local value = math.random(1,#list)
                        local function responseUnionCreateCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                    local add_silver = dms.int(dms["union_config"], 30, union_config.param)
                                    TipDlg.drawTextDailog(string.format(_new_interface_text[192], ""..add_silver))
                                    response.node:updateDrawHelp(list[tonumber(value)].id)
                                end
                            end
                        end
                        protocol_command.union_ship_train_help.param_list = list[tonumber(value)].id.."\r\n".."1".."\r\n"..list[tonumber(value)].index.."\r\n"..list[tonumber(value)].shipId
                        NetworkManager:register(protocol_command.union_ship_train_help.code, nil, nil, nil, instance, responseUnionCreateCallback, false, nil)
                    else
                        TipDlg.drawTextDailog(_new_interface_text[69])
                    end
                else
                    TipDlg.drawTextDailog(_new_interface_text[194])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --刷新界面
        local sm_union_all_campsite_update_terminal = {
            _name = "sm_union_all_campsite_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        
		state_machine.add(sm_union_all_campsite_show_terminal)	
        state_machine.add(sm_union_all_campsite_hide_terminal)
        state_machine.add(sm_union_all_campsite_random_accelerate_terminal)
        state_machine.add(sm_union_all_campsite_update_terminal)

        state_machine.init()
    end
    init_sm_union_all_campsite_terminal()
end

function SmUnionAllCampsite:onHide()
    self:setVisible(false)
end

function SmUnionAllCampsite:onShow()
    self:setVisible(true)
end

function SmUnionAllCampsite:updateDrawHelp(member_id)
    local root = self.roots[1]
    local ListView_cy = ccui.Helper:seekWidgetByName(root,"ListView_cy")
    for k,v in pairs(ListView_cy:getItems()) do
        if tonumber(v.member.member_id) == tonumber(member_id) then
            v:updateDraw()
            break
        end
    end
end

function SmUnionAllCampsite:onUpdateDraw()
    local root = self.roots[1]

    local my_data = zstring.split(_ED.union_personal_energy_info,"|")
    local accelerate = zstring.split(my_data[1],",")
    local param = zstring.split(dms.string(dms["union_config"], 25, union_config.param) ,",")
    --加速次数
    local Text_jscs_n = ccui.Helper:seekWidgetByName(root,"Text_jscs_n")
    Text_jscs_n:setString(tonumber(param[1])-tonumber(accelerate[1]))
    local Text_bdjscs_n = ccui.Helper:seekWidgetByName(root,"Text_bdjscs_n")
    Text_bdjscs_n:setString(tonumber(param[2])-tonumber(accelerate[2]))

    local ListView_cy = ccui.Helper:seekWidgetByName(root,"ListView_cy")

    ListView_cy:removeAllItems()
    for i, v in pairs(_ED.union_member_energy_info) do
        if tonumber(v.member_id) ~= tonumber(_ED.user_info.user_id) then
            local member_data = zstring.split(v.member_data,"|")
            local isneed = false
            for j=3, #member_data do
                local member = zstring.split(member_data[j],",")
                if tonumber(member[1]) > 0 then
                    isneed = true
                    break
                end
            end
            if isneed == true then
                local memberInfo = nil
                for _, member in pairs(_ED.union.union_member_list_info) do
                    if tonumber(v.member_id) == tonumber(member.id) then
                        memberInfo = member
                        break
                    end
                end
                if nil ~= memberInfo then
                    local cell = unionEnergyHouseMember:createCell()
                    cell:init(v, i)
                    ListView_cy:addChild(cell)
                end
            end
        end
    end
    ListView_cy:requestRefreshView()

    --被加速记录
    local ListView_js_xinxi = ccui.Helper:seekWidgetByName(root,"ListView_js_xinxi")
    ListView_js_xinxi:removeAllItems()
    if tonumber(accelerate[2]) > 0 then
        for i , v in pairs(_ED.union_accelerate_energy_info) do
            local cell = self:speedUpTextCreat(v)
            ListView_js_xinxi:addChild(cell)
        end
        ListView_js_xinxi:requestRefreshView()
    end

    local Button_roll_js = ccui.Helper:seekWidgetByName(root, "Button_roll_js")
    if smChechUnionMemberAccelerate() == false then
        Button_roll_js:setTouchEnabled(false)
        Button_roll_js:setBright(false)
    else
        Button_roll_js:setTouchEnabled(true)
        Button_roll_js:setBright(true)
    end
end

function SmUnionAllCampsite:speedUpTextCreat(_name)
    local roots = cacher.createUIRef("legion/sm_legion_energy_house_tab_2_list.csb", "root")
    roots:removeFromParent(true)
    local Text_name = ccui.Helper:seekWidgetByName(roots,"Text_name")
    Text_name:setString(_name)
    local Text_info = ccui.Helper:seekWidgetByName(roots,"Text_info")
    Text_info:setPositionX(Text_name:getPositionX() + Text_name:getAutoRenderSize().width)
    return roots
end

function SmUnionAllCampsite:onUpdate(dt)
    
end

function SmUnionAllCampsite:onEnterTransitionFinish()

end

function SmUnionAllCampsite:onInit( )
    local csbItem = csb.createNode("legion/sm_legion_energy_house_tab_2.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    if SmUnionAllCampsite.__size == nil then
        SmUnionAllCampsite.__size = root:getContentSize()
    end
    self:setContentSize(SmUnionAllCampsite.__size)

    self:onUpdateDraw()

    --随机加速
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_roll_js"), nil, 
    {
        terminal_name = "sm_union_all_campsite_random_accelerate", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        cell = self
    }, 
    nil, 0)

end

function SmUnionAllCampsite:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmUnionAllCampsite:onExit()
    state_machine.remove("sm_union_all_campsite_show")    
    state_machine.remove("sm_union_all_campsite_hide")
    state_machine.remove("sm_union_all_campsite_random_accelerate")
    state_machine.remove("sm_union_all_campsite_update")
end


