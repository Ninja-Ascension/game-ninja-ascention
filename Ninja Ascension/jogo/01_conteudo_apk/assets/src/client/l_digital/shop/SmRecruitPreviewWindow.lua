-----------------------------
-- 招募奖励预览
-----------------------------
SmRecruitPreviewWindow = class("SmRecruitPreviewWindowClass", Window)

local sm_recruit_preview_window_open_terminal = {
    _name = "sm_recruit_preview_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("SmRecruitPreviewWindowClass") then
            local panel = SmRecruitPreviewWindow:new():init(params)
            fwin:open(panel, fwin._ui)
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_recruit_preview_window_close_terminal = {
    _name = "sm_recruit_preview_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activityWindow = fwin:find("SmRecruitPreviewWindowClass")
        fwin:close(activityWindow)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_recruit_preview_window_open_terminal)
state_machine.add(sm_recruit_preview_window_close_terminal)
state_machine.init()

function SmRecruitPreviewWindow:ctor()
    self.super:ctor()
    self.roots = {}
    
    -- 定义变量
    self._current_page = 0
    self._page_table = {}

    self._rewards = nil
    self._rewards_r = nil

    -- 加载lua文件
    app.load("client.l_digital.shop.SmRecruitPreviewWindowTab")

    -- 初始化状态机
    local function init_sm_recruit_preview_window_terminal()
        -- 刷新
        local sm_recruit_preview_window_update_draw_terminal = {
            _name = "sm_recruit_preview_window_update_draw",
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
        
        local sm_recruit_preview_window_change_page_terminal = {
            _name = "sm_recruit_preview_window_change_page",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_recruit_preview_window_update_draw_terminal)
        state_machine.add(sm_recruit_preview_window_change_page_terminal)
        state_machine.init()
    end
    init_sm_recruit_preview_window_terminal()
end

function SmRecruitPreviewWindow:getRecruitRewards()
    local result = {}
    local partner_ids = {}          -- 招募模板id
    if self._from_type == 1 then
        -- 金币招募
        partner_ids = {1, 9}
    elseif self._from_type == 2 then
        -- 钻石招募
        partner_ids = {2, 4, 8}
    elseif self._from_type == 3 then
        -- 装备宝箱
        partner_ids = {10, 11}
    end

    local bounty_ids = {}          -- 招募库组id
    for _, v in pairs(partner_ids) do
        local bounty_data = dms.element(dms["partner_bounty_param"], v)
        for i = partner_bounty_param.first_free_group, partner_bounty_param.orang_group do
            local info = zstring.split(dms.atos(bounty_data, i), "|")
            for _, w in pairs(info) do
                for _, id in pairs(zstring.split(w, ",")) do
                    bounty_ids[""..id] = 1
                end
            end
        end
    end

    local props = {}
    for k, v in pairs(bounty_ids) do
        if zstring.tonumber(k) > 0 and zstring.tonumber(v) > 0 then
            local group_id = tonumber(k)
            local bounty_info = dms.searchs(dms["bounty_hero_param"], bounty_hero_param.bounty_group, group_id)
            for j, w in pairs(bounty_info) do
                local info = {}
                local ship_id = dms.atoi(w, bounty_hero_param.prop_mould)
                if ship_id > 0 then
                    info.prop_type = 13
                    info.sign = 9
                    info.mould_id = ship_id
                    info.order = zstring.tonumber(zstring.split(dms.atos(w, bounty_hero_param.rewards), ",")[4])
                else
                    local prop_info = zstring.split(dms.atos(w, bounty_hero_param.rewards), ",")
                    info.prop_type = tonumber(prop_info[1])
                    info.mould_id = tonumber(prop_info[2])
                    info.order = 0
                    info.sign = 9
                    if info.prop_type == 6 then
                        info.order = dms.int(dms["prop_mould"], info.mould_id, prop_mould.trace_scene)
                    end
                end
                if (ship_id <= 0 and dms.int(dms["prop_mould"], info.mould_id, prop_mould.prop_type) == 3) or tonumber(info.prop_type) == 1 then
                else
                    table.insert(props, info)
                end
            end
        end
    end
    -- 库组全部改为策划配置 46，47库组内容合并到其他库组里去
    -- bounty_ids[""..46] = 1
    -- for k, v in pairs(bounty_ids) do
    --     if zstring.tonumber(k) > 0 and zstring.tonumber(v) > 0 then
    --         local group_id = tonumber(k)
    --         local bounty_info = dms.searchs(dms["bounty_hero_param"], bounty_hero_param.bounty_group, group_id)
    --         for j, w in pairs(bounty_info) do
    --             local info = {}
    --             local ship_id = dms.atoi(w, bounty_hero_param.prop_mould)
    --             if ship_id > 0 then
    --                 info.prop_type = 13
    --                 info.sign = 99
    --                 info.mould_id = ship_id
    --                 info.order = zstring.tonumber(zstring.split(dms.atos(w, bounty_hero_param.rewards), ",")[4])
    --             else
    --                 local prop_info = zstring.split(dms.atos(w, bounty_hero_param.rewards), ",")
    --                 info.prop_type = tonumber(prop_info[1])
    --                 info.mould_id = tonumber(prop_info[2])
    --                 info.order = 0
    --                 info.sign = 99
    --                 if info.prop_type == 6 then
    --                     info.order = dms.int(dms["prop_mould"], info.mould_id, prop_mould.trace_scene)
    --                 end
    --             end
    --             if (ship_id <= 0 and dms.int(dms["prop_mould"], info.mould_id, prop_mould.prop_type) == 3) or tonumber(info.prop_type) == 1 then
    --             else
    --                 table.insert(props, info)
    --             end
    --         end
    --     end
    -- end

    -- bounty_ids[""..47] = 1
    -- for k, v in pairs(bounty_ids) do
    --     if zstring.tonumber(k) > 0 and zstring.tonumber(v) > 0 then
    --         local group_id = tonumber(k)
    --         local bounty_info = dms.searchs(dms["bounty_hero_param"], bounty_hero_param.bounty_group, group_id)
    --         for j, w in pairs(bounty_info) do
    --             local info = {}
    --             local ship_id = dms.atoi(w, bounty_hero_param.prop_mould)
    --             if ship_id > 0 then
    --                 info.prop_type = 13
    --                 info.sign = 999
    --                 info.mould_id = ship_id
    --                 info.order = zstring.tonumber(zstring.split(dms.atos(w, bounty_hero_param.rewards), ",")[4])
    --             else
    --                 local prop_info = zstring.split(dms.atos(w, bounty_hero_param.rewards), ",")
    --                 info.prop_type = tonumber(prop_info[1])
    --                 info.mould_id = tonumber(prop_info[2])
    --                 info.order = 0
    --                 info.sign = 999
    --                 if info.prop_type == 6 then
    --                     info.order = dms.int(dms["prop_mould"], info.mould_id, prop_mould.trace_scene)
    --                 end
    --             end
    --             if (ship_id <= 0 and dms.int(dms["prop_mould"], info.mould_id, prop_mould.prop_type) == 3) or tonumber(info.prop_type) == 1 then
    --             else
    --                 table.insert(props, info)
    --             end
    --         end
    --     end
    -- end

    for _, v in pairs(props) do
        local is_same = false
        for _, w in pairs(result) do
            if tonumber(v.prop_type) == tonumber(w.prop_type) and tonumber(v.mould_id) == tonumber(w.mould_id) then
                is_same = true
                break
            end
        end
        if is_same == false then
            table.insert(result, v)
        end
    end

    return result
end

-- 口袋奖励预览
function SmRecruitPreviewWindow:getRecruitRewardNew()
    local result = {}
    local props = {}
    local info = {}
    local num_param = dms.float(dms["play_config"], 127, pirates_config.param)
    for i = 1, (num_param) do
        local bounty_info = dms.searchs(dms["bounty_hero_reward_param"], bounty_hero_reward_param.id, i)
        for j, w in pairs(bounty_info) do
            local info = {}
            -- 金币招募
            if self._from_type == 1 then
                if tonumber(w[2]) == 1 then             
                    info.prop_type = tonumber(w[3])
                    info.mould_id = tonumber(w[4])
                    if tonumber(w[5]) == -1 then
                        info.order = 0
                    else
                        info.order = tonumber(w[5])
                    end
                    if tonumber(w[6]) == 1 then
                       info.sign = 9
                    elseif tonumber(w[6]) == 65 then
                        info.sign = 99
                    elseif tonumber(w[6]) == 85 then
                        info.sign = 999
                    end
                    info.tag = tonumber(w[7])
                    table.insert(props, info)
                end
                -- 钻石招募
            elseif self._from_type == 2 then
                if tonumber(w[2]) == 2 then             
                    info.prop_type = tonumber(w[3])
                    info.mould_id = tonumber(w[4])
                    if tonumber(w[5]) == -1 then
                        info.order = 0
                    else
                        info.order = tonumber(w[5])
                    end
                    if tonumber(w[6]) == 1 then
                       info.sign = 9
                    elseif tonumber(w[6]) == 65 then
                        info.sign = 99
                    elseif tonumber(w[6]) == 85 then
                        info.sign = 999
                    end
                    info.tag = tonumber(w[7])
                    table.insert(props, info)
                end
                -- 装备宝箱
            elseif self._from_type == 3 then
                partner_ids = {10, 11}
                local bounty_ids = {}          -- 招募库组id
                for _, v in pairs(partner_ids) do
                    local bounty_data = dms.element(dms["partner_bounty_param"], v)
                    for i = partner_bounty_param.first_free_group, partner_bounty_param.orang_group do
                        local info = zstring.split(dms.atos(bounty_data, i), "|")
                        for _, w in pairs(info) do
                            for _, id in pairs(zstring.split(w, ",")) do
                                bounty_ids[""..id] = 1
                            end
                        end
                    end
                end

                for k, v in pairs(bounty_ids) do
                    if zstring.tonumber(k) > 0 and zstring.tonumber(v) > 0 then
                        local group_id = tonumber(k)
                        local bounty_info = dms.searchs(dms["bounty_hero_param"], bounty_hero_param.bounty_group, group_id)
                        for j, w in pairs(bounty_info) do
                            local info = {}
                            local ship_id = dms.atoi(w, bounty_hero_param.prop_mould)
                            if ship_id > 0 then
                                info.prop_type = 13
                                info.sign = 9
                                info.mould_id = ship_id
                                info.order = zstring.tonumber(zstring.split(dms.atos(w, bounty_hero_param.rewards), ",")[4])
                            else
                                local prop_info = zstring.split(dms.atos(w, bounty_hero_param.rewards), ",")
                                info.prop_type = tonumber(prop_info[1])
                                info.mould_id = tonumber(prop_info[2])
                                info.order = 0
                                info.sign = 9
                                if info.prop_type == 6 then
                                    info.order = dms.int(dms["prop_mould"], info.mould_id, prop_mould.trace_scene)
                                end
                            end
                            if (ship_id <= 0 and dms.int(dms["prop_mould"], info.mould_id, prop_mould.prop_type) == 3) or tonumber(info.prop_type) == 1 then
                            else
                                table.insert(props, info)
                            end
                        end
                    end
                end
            end
        end
    end

    if self._from_type == 1 or self._from_type == 2 then
        for _, v in pairs(props) do
            table.insert(result, v)
        end
    elseif self._from_type == 3 then
        for _, v in pairs(props) do
            local is_same = false
            for _, w in pairs(result) do
                if tonumber(v.prop_type) == tonumber(w.prop_type) and tonumber(v.mould_id) == tonumber(w.mould_id) then
                    is_same = true
                    --break
                end
            end
            if is_same == false then
                table.insert(result, v)
            end
        end
    end

    return result
end

-- 切换页面
function SmRecruitPreviewWindow:changeSelectPage( page )
    local root = self.roots[1]
    if page == self._current_page then
        return
    end
    self._current_page = page

    for i = 1, 8 do
        local Button_tab = ccui.Helper:seekWidgetByName(root, "Button_tab_"..i)
        if i == page then
            Button_tab:setTouchEnabled(false)
            Button_tab:setHighlighted(true)
        else
            Button_tab:setTouchEnabled(true)
            Button_tab:setHighlighted(false)
        end
        -- DSC重塑
        local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_"..i)
        if __lua_project_id == __lua_project_l_digital and Text_1 then
            if i == page then
                Text_1:setVisible(true)
            else
                Text_1:setVisible(false)
            end
        end
    end

    local Panel_yulan = ccui.Helper:seekWidgetByName(root, "Panel_yulan")
    for k, v in pairs(self._page_table) do
        state_machine.excute("sm_recruit_preview_window_tab_hide", 0, v)
    end

    if self._page_table[""..page] == nil then
        self._page_table[""..page] = state_machine.excute("sm_recruit_preview_window_tab_open", 0, {Panel_yulan, self._from_type, page, self._rewards})

    else
        state_machine.excute("sm_recruit_preview_window_tab_show", 0, self._page_table[""..page])
    end
end

function SmRecruitPreviewWindow:onEnterTransitionFinish()

end

function SmRecruitPreviewWindow:initUI()
    local root = self.roots[1]
    for i = 1, 8 do
        local Button_tab = ccui.Helper:seekWidgetByName(root, "Button_tab_"..i)
        if (self._from_type == 1 and i == 6)
            or (self._from_type == 2 and i <= 5)
            or (self._from_type == 3 and i >= 7)
            then
            Button_tab:setVisible(true)
        else
            Button_tab:setVisible(false)
        end
        -- DSC重塑
        local Text_tab = ccui.Helper:seekWidgetByName(root, "Text_tab_"..i)
        if __lua_project_id == __lua_project_l_digital and Text_tab then
            if (self._from_type == 1 and i == 6)
                or (self._from_type == 2 and i <= 5)
                or (self._from_type == 3 and i >= 7)
                then
                Text_tab:setVisible(true)
            else
                Text_tab:setVisible(false)
            end
        end
    end
end

function SmRecruitPreviewWindow:onInit( )
    local csbItem = csb.createNode("shop/sm_recruit_preview_window.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:initUI()

    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        self._rewards = self:getRecruitRewardNew()
    else
        self._rewards = self:getRecruitRewards()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_recruit_preview_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    for i = 1, 8 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tab_"..i), nil, 
        {
            terminal_name = "sm_recruit_preview_window_change_page", 
            terminal_state = 0, 
            _page = i,
        }, nil, 1)
    end
    
    if self._from_type == 1 then
        self:changeSelectPage(6)
    elseif self._from_type == 2 then
        self:changeSelectPage(1)
    elseif self._from_type == 3 then
        self:changeSelectPage(7)
    end
end

function SmRecruitPreviewWindow:init(params)
    self._from_type = params[1]             -- 1:金币奖励预览，2：钻石奖励预览，3：装备宝箱
    self:onInit()
    return self
end

function SmRecruitPreviewWindow:onExit()
    -- 移除状态机
    state_machine.remove("sm_recruit_preview_window_update_draw")
    state_machine.remove("sm_recruit_preview_window_change_page")
end

function SmRecruitPreviewWindow:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
          sp.SkeletonRenderer:clear()
    end     
    cacher.removeAllTextures()     
    audioUtilUncacheAll() 
end
