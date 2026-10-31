--------------------------------------------------------------------------------------------------------------
--  说明：数码试炼buff控件
--------------------------------------------------------------------------------------------------------------
SmTrialTowerAdditionCell = class("SmTrialTowerAdditionCellClass", Window)
SmTrialTowerAdditionCell.__size = nil

--创建cell
local sm_trial_tower_Addition_cell_terminal = {
    _name = "sm_trial_tower_Addition_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmTrialTowerAdditionCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(sm_trial_tower_Addition_cell_terminal)
state_machine.init()

function SmTrialTowerAdditionCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.buffShipId = -1
    self._type = 0
	 -- Initialize sm_trial_tower_Addition_cell state machine.
    local function init_sm_trial_tower_Addition_cell_terminal()
        --属性加成
        local sm_trial_tower_Addition_select_back_activity_terminal = {
            _name = "sm_trial_tower_Addition_select_back_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)          
                local cell = params._datas.cells
                if tonumber(_ED.three_kingdoms_view.current_max_stars) >= tonumber(cell.need) then
                    _ED.three_kingdoms_view.current_max_stars = tonumber(_ED.three_kingdoms_view.current_max_stars) - tonumber(cell.need)
                    ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_sxxz"):setTouchEnabled(false)
                    local Image_ygm = ccui.Helper:seekWidgetByName(cell.roots[1], "Image_ygm")
                    -- DSC重塑
                    if __lua_project_id == __lua_project_l_digital then 
                        local Panel_ygm = ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_ygm")
                        if Panel_ygm then 
                            Panel_ygm:setVisible(true)
                        end
                    end
                    Image_ygm:setVisible(true)
                    Image_ygm:setScale(5)
                    local function playOver()
                        if zstring.tonumber(cell._type) == 2 then
                            state_machine.excute("sm_trial_tower_sweep_info_choose_buff", 0, {cell.need, cell.attribute_id, cell.buffShipId})
                        else
                            state_machine.excute("addition_select_back_activity", 0, {cell.need,cell.attribute_id,cell.buffShipId})
                        end
                    end
                    Image_ygm:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15, 1),cc.CallFunc:create(playOver)))
                else
                    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.TrialTowerBuyBuff)
                    -- 是否是自动购买buff
                    local isAuto = params._datas.is_auto    
                    if fun_is_open == true and isAuto then
                        --
                    else
                        TipDlg.drawTextDailog(_new_interface_text[173])
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --选择Buff武将
        local sm_trial_tower_Addition_select_buff_ship_terminal = {
            _name = "sm_trial_tower_Addition_select_buff_ship",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.trialtower.SmTrialTowerBuffSelectWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)          
                local cell = params._datas.cells
                if tonumber(_ED.three_kingdoms_view.current_max_stars) >= tonumber(cell.need) then
                    state_machine.excute("sm_trial_tower_buff_select_window_open", 0, cell)
                    fwin:find("SmTrialTowerBuffSelectWindowClass"):setVisible(false)
                    local tSortedHeroes = {}
                    if fwin:find("SmTrialTowerBuffSelectWindowClass") and SmTrialTowerBuffSelectWindow then 
                        tSortedHeroes = SmTrialTowerBuffSelectWindow.tSortedHeroes
                    end
                    local current_tSortedHeroes = table.nums(tSortedHeroes)
                    if current_tSortedHeroes > 0 then
                        fwin:find("SmTrialTowerBuffSelectWindowClass"):setVisible(true)
                    else
                        state_machine.excute("sm_trial_tower_buff_select_window_close", 0, 0)
                        TipDlg.drawTextDailog(_new_interface_text[305])
                    end
                else
                    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.TrialTowerBuyBuff)
                    -- 是否是自动购买buff
                    local isAuto = params._datas.is_auto
                    if fun_is_open == true and isAuto then
                        --
                    else
                        TipDlg.drawTextDailog(_new_interface_text[173])
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --设置对应加Buff的武将
        local sm_trial_tower_Addition_select_set_up_ship_terminal = {
            _name = "sm_trial_tower_Addition_select_set_up_ship",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)      
                local cell = params[1]
                cell.buffShipId = tonumber(params[2])
                state_machine.excute("sm_trial_tower_Addition_select_back_activity", 0, {_datas = {cells = cell,is_auto = false}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_trial_tower_Addition_select_back_activity_terminal)
        state_machine.add(sm_trial_tower_Addition_select_buff_ship_terminal)
        state_machine.add(sm_trial_tower_Addition_select_set_up_ship_terminal)
        state_machine.init()
    end 
    -- call func sm_trial_tower_Addition_cell create state machine.
    init_sm_trial_tower_Addition_cell_terminal()

end

function SmTrialTowerAdditionCell:updateDraw()
    local root = self.roots[1]

    local store = dms.searchs(dms["three_kingdoms_attribute"], three_kingdoms_attribute.store_id, self.info)
    local max = 0
    for i,v in pairs(store) do
        max = max + tonumber(v[5])
    end
    local m_index = math.random(1,max)
    local index = 0
    max = 0
    for i,v in pairs(store) do
        index = index + 1
        max = max + tonumber(v[5])
        if m_index <= max then
            m_index = index
            break
        end
    end
    self.attribute_id = store[m_index][1]

    --获得加成数据
    local icon = dms.int(dms["three_kingdoms_attribute"], self.attribute_id, three_kingdoms_attribute.attribute_sign_id)
    local list = zstring.split( dms.string(dms["three_kingdoms_attribute"], self.attribute_id, three_kingdoms_attribute.attribute_value),",")
    --名称
    local Image_buff_name = ccui.Helper:seekWidgetByName(root, "Image_buff_name")
    Image_buff_name:loadTexture(string.format("images/ui/text/SL_res/buff_sl_%d.png", tonumber(icon)))

    --图片
    local Image_buff_icon = ccui.Helper:seekWidgetByName(root, "Image_buff_icon")
    Image_buff_icon:loadTexture(string.format("images/ui/text/SL_res/buff_icon_%d.png", tonumber(icon)))
    
    --需要的星星
    local Text_star_n = ccui.Helper:seekWidgetByName(root, "Text_star_n")
    Text_star_n:setString(self.need)
    --加成百分比
    local Text_sx_n = ccui.Helper:seekWidgetByName(root, "Text_sx_n")

    --描述
    local Text_sx_info = ccui.Helper:seekWidgetByName(root, "Text_sx_info")
    local atype = tonumber(list[1])
    local avalue = tonumber(list[2])
    if atype == 5 or atype == 6 or atype == 8 or atype == 10 or atype == 40 or atype == 42 then
        avalue = avalue*100
        list[2] = tonumber(list[2])*100
    end

    if atype == 41 or atype == 4 or atype == 999 then
        Text_sx_n:setString(list[2])
    else
        Text_sx_n:setString(list[2].."%")
    end
    if atype == 999 then
        local vStr = string.format(tipStringInfo_resurrection_info_tips[1][2], avalue)
        Text_sx_info:setString(tipStringInfo_resurrection_info_tips[1][1]..vStr..tipStringInfo_resurrection_info_tips[1][3])
    elseif atype == 4 then
        local vStr = string.format(tipStringInfo_resurrection_info_tips[2][2], avalue)
        Text_sx_info:setString(tipStringInfo_resurrection_info_tips[2][1]..vStr..tipStringInfo_resurrection_info_tips[2][3])
    elseif atype == 41 then
        if tonumber(list[3]) == -1 then
            local vStr = string.format(tipStringInfo_resurrection_info_tips[3][2], avalue)
            Text_sx_info:setString(tipStringInfo_resurrection_info_tips[3][1]..vStr)
        else
            local vStr = string.format(tipStringInfo_resurrection_info_tips[4][2], avalue)
            Text_sx_info:setString(tipStringInfo_resurrection_info_tips[4][1]..vStr)
        end
    else
        local value,name= getTrialtowerAdditionFormatValue(atype, avalue)
        Text_sx_info:setString(skill_attributes_text_tips[atype+1]..value)
    end

    local Panel_sxxz = ccui.Helper:seekWidgetByName(root, "Panel_sxxz")
    Panel_sxxz:setTouchEnabled(true)
    if tonumber(list[3]) >= 0 then
        if _ED.smTrialTower_autoFlag then 
            -- 自动爬塔
            state_machine.excute("sm_trial_tower_Addition_select_buff_ship",0,
            {
                _datas = {
                    terminal_state = 0,
                    touch_black = true,
                    cells = self,
                    is_auto = true,
                }
            })
	    else
            -- 手动
            fwin:addTouchEventListener(Panel_sxxz, nil, 
            {
                terminal_name = "sm_trial_tower_Addition_select_buff_ship", 
                terminal_state = 0,
                touch_black = true,
                cells = self,
                is_auto = false,
            }, nil, 1)
        end
    else
        if _ED.smTrialTower_autoFlag then 
            -- 自动爬塔
            state_machine.excute("sm_trial_tower_Addition_select_back_activity",0,
            {
                _datas = {
                    terminal_state = 0, 
                    touch_black = true,
                    cells = self,
                    is_auto = true,
                }
            })
        else
            -- 手动
            fwin:addTouchEventListener(Panel_sxxz, nil, 
            {
                terminal_name = "sm_trial_tower_Addition_select_back_activity", 
                terminal_state = 0, 
                touch_black = true,
                cells = self,
                is_auto = false,
            }, nil, 1)
        end
    end
end

function SmTrialTowerAdditionCell:onUpdate(dt)
    
end

function SmTrialTowerAdditionCell:onInit()
    local root = cacher.createUIRef("campaign/TrialTower/sm_trial_tower_Addition_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmTrialTowerAdditionCell.__size == nil then
        SmTrialTowerAdditionCell.__size = root:getContentSize()
    end

    self:setContentSize(SmTrialTowerAdditionCell.__size)
	self:updateDraw()
end

function SmTrialTowerAdditionCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function SmTrialTowerAdditionCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Image_ygm = ccui.Helper:seekWidgetByName(root, "Image_ygm")
    local Panel_sxxz = ccui.Helper:seekWidgetByName(root, "Panel_sxxz")
    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then 
        local Panel_ygm = ccui.Helper:seekWidgetByName(root,"Panel_ygm")
        if Panel_ygm then 
            Image_ygm = Panel_ygm
        end
    end
    if Image_ygm ~= nil then
        Image_ygm:setVisible(false)
        Image_ygm:setScale(1)
    end
    if Panel_sxxz ~= nil then
        Panel_sxxz:setTouchEnabled(true)
    end
end

function SmTrialTowerAdditionCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmTrialTowerAdditionCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/TrialTower/sm_trial_tower_Addition_cell.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmTrialTowerAdditionCell:init(params)
    self.info = params[1]
    self.need = params[2]
    self.index = params[3]
    self._type = params[4]
	self:onInit()

    
    return self
end

function SmTrialTowerAdditionCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/TrialTower/sm_trial_tower_Addition_cell.csb", self.roots[1])
end