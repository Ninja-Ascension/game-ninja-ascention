-----------------------------
-- 公会的查找的page
-----------------------------
SmUnionFindPage = class("SmUnionFindPageClass", Window)
SmUnionFindPage.__size = nil

local sm_union_find_page_open_terminal = {
    _name = "sm_union_find_page_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmUnionFindPage:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_find_page_open_terminal)
state_machine.init()

function SmUnionFindPage:ctor()
    self.super:ctor()
    self.roots = {}

    self.prop_list = {}
    app.load("client.l_digital.cells.union.union_join_list_cell")

    local function init_sm_union_find_page_terminal()
		--显示界面
		local sm_union_find_page_show_terminal = {
            _name = "sm_union_find_page_show",
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
		local sm_union_find_page_hide_terminal = {
            _name = "sm_union_find_page_hide",
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

        --搜索工会
        local sm_union_find_page_search_for_terminal = {
            _name = "sm_union_find_page_search_for",
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


        
		state_machine.add(sm_union_find_page_show_terminal)	
        state_machine.add(sm_union_find_page_hide_terminal)
		state_machine.add(sm_union_find_page_search_for_terminal)

        state_machine.init()
    end
    init_sm_union_find_page_terminal()
end

function SmUnionFindPage:onHide()
    self:setVisible(false)
end

function SmUnionFindPage:onShow()
    self:setVisible(true)
end


function SmUnionFindPage:onUpdateDraw()
    local root = self.roots[1]
    local text = ccui.Helper:seekWidgetByName(root, "TextField_legion_id")
    local str = zstring.exchangeTo(text:getString())

    if text:getString() ~= "" then
        local function responseUnionSearchCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots[1] ~= nil then
                    local ListView_legion_2 = ccui.Helper:seekWidgetByName(root, "ListView_legion_2")
                    ListView_legion_2:removeAllItems()
                    for i,v in pairs(_ED.union.union_list_info) do
                        local cell = Unionjoinlistcell:createCell()
                        cell:init(v,1,-1)
                        ListView_legion_2:addChild(cell)
                    end
                    ListView_legion_2:requestRefreshView()
                    ListView_legion_2:jumpToTop()
                end
            end
        end
        _ED.union.union_list_info = nil
        protocol_command.union_search.param_list = str
        NetworkManager:register(protocol_command.union_search.code, nil, nil, nil, self, responseUnionSearchCallback, false, nil)
    end
end

function SmUnionFindPage:onUpdate(dt)
    
end

function SmUnionFindPage:onEnterTransitionFinish()

end

function SmUnionFindPage:onInit( )
    local csbItem = csb.createNode("legion/sm_legion_list_tab_3.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    
    local text = ccui.Helper:seekWidgetByName(root, "TextField_legion_id")
    draw:addEditBox(text, _string_piece_info[341], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Image_30"), 6, cc.KEYBOARD_RETURNTYPE_DONE)

    if SmUnionFindPage.__size == nil then
        SmUnionFindPage.__size = root:getContentSize()
    end
    self:setContentSize(SmUnionFindPage.__size)

    -- 搜索
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_19"), nil, 
    {
        terminal_name = "sm_union_find_page_search_for", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- self:onUpdateDraw()
end

function SmUnionFindPage:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmUnionFindPage:onExit()
    state_machine.remove("sm_union_find_page_show")    
    state_machine.remove("sm_union_find_page_hide")
end


