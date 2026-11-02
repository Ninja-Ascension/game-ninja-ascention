-- ----------------------------------------------------------------------------------------------------
-- 说明：公会研究院科技捐赠
-------------------------------------------------------------------------------------------------------
SmUnionInstituteDonate = class("SmUnionInstituteDonateClass", Window)

local sm_union_institute_donate_open_terminal = {
    _name = "sm_union_institute_donate_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionInstituteDonateClass")
        if nil == _homeWindow then
            local panel = SmUnionInstituteDonate:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_institute_donate_close_terminal = {
    _name = "sm_union_institute_donate_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionInstituteDonateClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionInstituteDonateClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_institute_donate_open_terminal)
state_machine.add(sm_union_institute_donate_close_terminal)
state_machine.init()
    
function SmUnionInstituteDonate:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    app.load("client.l_digital.cells.union.union_institute_donate_list_cell")
    local function init_sm_union_institute_donate_terminal()
        -- 显示界面
        local sm_union_institute_donate_display_terminal = {
            _name = "sm_union_institute_donate_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionInstituteDonateWindow = fwin:find("SmUnionInstituteDonateClass")
                if SmUnionInstituteDonateWindow ~= nil then
                    SmUnionInstituteDonateWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_institute_donate_hide_terminal = {
            _name = "sm_union_institute_donate_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionInstituteDonateWindow = fwin:find("SmUnionInstituteDonateClass")
                if SmUnionInstituteDonateWindow ~= nil then
                    SmUnionInstituteDonateWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local sm_union_institute_donate_update_draw_terminal = {
            _name = "sm_union_institute_donate_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_institute_donate_display_terminal)
        state_machine.add(sm_union_institute_donate_hide_terminal)
        state_machine.add(sm_union_institute_donate_update_draw_terminal)
        state_machine.init()
    end
    init_sm_union_institute_donate_terminal()
end

function SmUnionInstituteDonate:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    --科技列表
    local ListView_xm_2 = ccui.Helper:seekWidgetByName(root, "ListView_xm_2")
    ListView_xm_2:removeAllItems()
    local maxIndex = 0
    if self.m_type == 1 then
        maxIndex = 2
    elseif self.m_type == 2 then
        maxIndex = 2
    elseif self.m_type == 3 then
        maxIndex = 3
    else
        maxIndex = 1
    end

    for i=1, maxIndex do
        local index = 0
        if self.m_type == 1 then
            index = i+1
        elseif self.m_type == 2 then
            index = i+3
        elseif self.m_type == 3 then
            index = i+5
        else
            index = i+8
        end
        local cell = unionInstituteDonateListCell:createCell()
        cell:init(index,self.m_type)
        ListView_xm_2:addChild(cell)
    end
    if maxIndex < 3 then
        --暂未开启的
        for i=maxIndex, 3 do
            local cell = unionInstituteDonateListCell:createCell()
            cell:init(0,self.m_type)
            ListView_xm_2:addChild(cell)
        end
    end
    ListView_xm_2:requestRefreshView()

    -- DSC重塑
    if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
        for i = 1, 4 do
            local Image_bar = ccui.Helper:seekWidgetByName(root, "Image_bar_"..i)
            if Image_bar ~= nil then
                Image_bar:setVisible(i == self.m_type)
            end
        end
    else
        --科技图
        local Image_bar_1 = ccui.Helper:seekWidgetByName(root, "Image_bar_1")
        local Image_bar_2 = ccui.Helper:seekWidgetByName(root, "Image_bar_2")
        if self.m_type == 3 then
            if Image_bar_1 ~= nil then
                Image_bar_1:setVisible(false)
            end
            if Image_bar_2 ~= nil then
                Image_bar_2:setVisible(true)
            end
        else
            if Image_bar_1 ~= nil then
                Image_bar_1:setVisible(true)
            end
            if Image_bar_2 ~= nil then
                Image_bar_2:setVisible(false)
            end
        end 
    end


    --玩法说明
    local Text_wfsm_n = ccui.Helper:seekWidgetByName(root, "Text_wfsm_n")
    Text_wfsm_n:setString(union_science_text[(self.m_type-1)*2+1])
    --升级说明
    local Text_sjsm_n = ccui.Helper:seekWidgetByName(root, "Text_sjsm_n")
    Text_sjsm_n:setString(union_science_text[(self.m_type-1)*2+2])

end

function SmUnionInstituteDonate:init(params)
    self.m_type = tonumber(params)
    self:onInit()
    return self
end

function SmUnionInstituteDonate:onInit()
    local csbSmUnionInstituteDonate = csb.createNode("legion/sm_legion_research_institute_donate.csb")
    local root = csbSmUnionInstituteDonate:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionInstituteDonate)
    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_03"), nil, 
    {
        terminal_name = "sm_union_institute_donate_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)
end

function SmUnionInstituteDonate:onExit()
    state_machine.remove("sm_union_institute_donate_display")
    state_machine.remove("sm_union_institute_donate_hide")
end