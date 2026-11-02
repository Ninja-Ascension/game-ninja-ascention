-----------------------------
-- 公会的加入的page
-----------------------------
SmUnionJoinPage = class("SmUnionJoinPageClass", Window)
SmUnionJoinPage.__size = nil

local sm_union_join_page_open_terminal = {
    _name = "sm_union_join_page_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmUnionJoinPage:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_join_page_open_terminal)
state_machine.init()

function SmUnionJoinPage:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.l_digital.cells.union.union_join_list_cell")
    self.max_page = 1

    local function init_sm_union_join_page_terminal()
		--显示界面
		local sm_union_join_page_show_terminal = {
            _name = "sm_union_join_page_show",
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
		local sm_union_join_page_hide_terminal = {
            _name = "sm_union_join_page_hide",
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

        --设置翻页
        local sm_union_join_set_page_terminal = {
            _name = "sm_union_join_set_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local page = params._datas._page
                if tonumber(instance.max_page) == 1 then
                    return
                end
                if tonumber(page) == 1 then
                    --左
                    if tonumber(instance.page_number) == 0 then
                        return
                    else
                        instance.page_number = tonumber(instance.page_number) - 1
                        if instance.page_number <= 0 then
                            instance.page_number = 0 
                        end
                    end
                else
                    --右
                    if tonumber(instance.page_number)+1 == tonumber(instance.max_page) then
                        return
                    else
                        instance.page_number = tonumber(instance.page_number) + 1
                    end
                end

                local function responseUnionSearchCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots~=nil  and response.node.roots[1] ~= nil then
                            instance:onUpdateDraw()
                        end
                    end
                end
                _ED.union.union_list_info = nil
                protocol_command.union_list.param_list = instance.page_number
                NetworkManager:register(protocol_command.union_list.code, nil, nil, nil, instance, responseUnionSearchCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --快速加入
        local sm_union_join_page_join_fast_terminal = {
            _name = "sm_union_join_page_join_fast",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseUnionSearchCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil  and response.node.roots[1] ~= nil then
                            local function responseCallback(response)
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                    app.load("client.l_digital.union.UnionTigerGate")
                                    state_machine.excute("Union_open", 0, response.node)
                                end
                            end
                            NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, instance, responseCallback, false, nil)    
                            local function responseUnionFightCallback( response )
                            end
                            if _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
                                protocol_command.unino_fight_init.param_list = _ED.union.union_info.union_id.."\r\n".._ED.user_current_server_number
                                NetworkManager:register(protocol_command.unino_fight_init.code, _ED.union_fight_url, nil, nil, nil, responseUnionFightCallback, false, nil)
                            end
                            TipDlg.drawTextDailog(_new_interface_text[60])
                        end
                    end
                end
                protocol_command.union_one_key_join.param_list = "-1".."\r\n".."0"
                NetworkManager:register(protocol_command.union_one_key_join.code, nil, nil, nil, instance, responseUnionSearchCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        
		state_machine.add(sm_union_join_page_show_terminal)	
        state_machine.add(sm_union_join_page_hide_terminal)
        state_machine.add(sm_union_join_set_page_terminal)
		state_machine.add(sm_union_join_page_join_fast_terminal)

        state_machine.init()
    end
    init_sm_union_join_page_terminal()
end

function SmUnionJoinPage:onHide()
    self:setVisible(false)
end

function SmUnionJoinPage:onShow()
    self:setVisible(true)
end

function SmUnionJoinPage:onUpdateDraw()
    local root = self.roots[1]
    local ListView_join = ccui.Helper:seekWidgetByName(root, "ListView_legion_1")   
    local Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")   
    local asyncIndex = 0
    if _ED.union.union_list_sum == nil or zstring.tonumber(_ED.union.union_list_sum) == 0 then
        Text_tip:setVisible(true)
        ListView_join:setVisible(false)
    else
        Text_tip:setVisible(false)
        ListView_join:setVisible(true)

        ListView_join:removeAllItems()

        for i,v in pairs(_ED.union.union_list_info) do
            local cell = Unionjoinlistcell:createCell()
            cell:init(v,i,self.page_number)
            ListView_join:addChild(cell)
        end
        ListView_join:requestRefreshView()
        ListView_join:jumpToTop()
    end

    local Text_page_n = ccui.Helper:seekWidgetByName(root, "Text_page_n") 
    self.max_page = math.ceil(tonumber(_ED.union.union_max_number)/10)
    Text_page_n:setString((self.page_number+1).."/"..self.max_page)
end

function SmUnionJoinPage:onUpdate(dt)
    
end

function SmUnionJoinPage:onEnterTransitionFinish()

end

function SmUnionJoinPage:onInit( )
    local csbItem = csb.createNode("legion/sm_legion_list_tab_1.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    if SmUnionJoinPage.__size == nil then
        SmUnionJoinPage.__size = root:getContentSize()
    end
    self:setContentSize(SmUnionJoinPage.__size)

    self:onUpdateDraw()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_flip_left"), nil, 
    {
        terminal_name = "sm_union_join_set_page", 
        terminal_state = 0, 
        _page = 1,
        isPressedActionEnabled = true,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_flip_right"), nil, 
    {
        terminal_name = "sm_union_join_set_page", 
        terminal_state = 0, 
        _page = 2,
        isPressedActionEnabled = true,
    }, nil, 0)
    
    --快速加入
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_quickly_join"), nil, 
    {
        terminal_name = "sm_union_join_page_join_fast", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 0)
end

function SmUnionJoinPage:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
    self.page_number = tonumber(params[2])
	self:onInit()
    return self
end

function SmUnionJoinPage:onExit()
    state_machine.remove("sm_union_join_page_show")    
    state_machine.remove("sm_union_join_page_hide")
end


