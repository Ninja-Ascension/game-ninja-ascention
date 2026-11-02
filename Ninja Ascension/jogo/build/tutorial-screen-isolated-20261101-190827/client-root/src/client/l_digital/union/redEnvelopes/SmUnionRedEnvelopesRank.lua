-- ----------------------------------------------------------------------------------------------------
-- 说明：公会红包各种排行
-------------------------------------------------------------------------------------------------------
SmUnionRedEnvelopesRank = class("SmUnionRedEnvelopesRankClass", Window)

local sm_union_red_envelopes_rank_open_terminal = {
    _name = "sm_union_red_envelopes_rank_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionRedEnvelopesRankClass")
        if nil == _homeWindow then
            local panel = SmUnionRedEnvelopesRank:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_red_envelopes_rank_close_terminal = {
    _name = "sm_union_red_envelopes_rank_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionRedEnvelopesRankClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionRedEnvelopesRankClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_red_envelopes_rank_open_terminal)
state_machine.add(sm_union_red_envelopes_rank_close_terminal)
state_machine.init()
    
function SmUnionRedEnvelopesRank:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    app.load("client.l_digital.cells.union.redEnvelopes.union_red_envelopes_rank_list_cell")
    local function init_sm_union_red_envelopes_rank_terminal()
        -- 显示界面
        local sm_union_red_envelopes_rank_display_terminal = {
            _name = "sm_union_red_envelopes_rank_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionRedEnvelopesRankWindow = fwin:find("SmUnionRedEnvelopesRankClass")
                if SmUnionRedEnvelopesRankWindow ~= nil then
                    SmUnionRedEnvelopesRankWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_red_envelopes_rank_hide_terminal = {
            _name = "sm_union_red_envelopes_rank_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionRedEnvelopesRankWindow = fwin:find("SmUnionRedEnvelopesRankClass")
                if SmUnionRedEnvelopesRankWindow ~= nil then
                    SmUnionRedEnvelopesRankWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_red_envelopes_rank_display_terminal)
        state_machine.add(sm_union_red_envelopes_rank_hide_terminal)

        state_machine.init()
    end
    init_sm_union_red_envelopes_rank_terminal()
end

function SmUnionRedEnvelopesRank:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local function snatchValueCapacity(a,b)
        local al = zstring.tonumber(a.snatch_value)
        local bl = zstring.tonumber(b.snatch_value)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end

    local function snatchQuotaCapacity(a,b)
        local al = zstring.tonumber(a.snatch_quota)
        local bl = zstring.tonumber(b.snatch_quota)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end

    local ListView_hb_phb = ccui.Helper:seekWidgetByName(root, "ListView_hb_phb")
    ListView_hb_phb:removeAllItems()
    local index = 0
    local myData = nil
    if _ED.union_red_envelopes_snatch_list ~= nil then
        local snatch_list = {}
        for i, v in pairs(_ED.union_red_envelopes_snatch_list) do
            table.insert(snatch_list, v)
        end
        if tonumber(self.m_type) < 10 then
            table.sort(snatch_list, snatchQuotaCapacity)
        else
            table.sort(snatch_list, snatchValueCapacity)
        end
        
        
        for i, v in pairs(snatch_list) do
            index = index + 1
            local arsc = unionRedEnvelopesRankListCell:createCell()
            arsc:init(v, index,self.m_type)
            ListView_hb_phb:addChild(arsc)
            if tonumber(v.id) == tonumber(_ED.user_info.user_id) then
               myData = v 
            end
        end
    end
    
    ListView_hb_phb:requestRefreshView()
    for i=1,5 do
        ccui.Helper:seekWidgetByName(root, "Image_title_"..i):setVisible(false)
    end

    if tonumber(self.m_type) < 10 then
        if tonumber(self.m_type) == -1 then
            ccui.Helper:seekWidgetByName(root, "Text_title_wj"):setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Text_title_wj"):setString(string.format(_new_interface_text[77],self.name))
        else
            ccui.Helper:seekWidgetByName(root, "Text_title_wj"):setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Image_title_"..self.m_type):setVisible(true)
        end
        ccui.Helper:seekWidgetByName(root, "Image_hb_phb_bar_1"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Image_hb_phb_bar_2"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Image_bar_1_title_1"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Image_bar_1_title_2"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Image_gerenjilu_1"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Image_gerenjilu_2"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Text_gr_cishu"):setString("")
        if myData ~= nil then
            ccui.Helper:seekWidgetByName(root, "Text_gr_jiazhi"):setString(myData.snatch_quota)
        else
            ccui.Helper:seekWidgetByName(root, "Text_gr_jiazhi"):setString(0)
        end
    else
        if tonumber(self.m_type) == 10 then
            ccui.Helper:seekWidgetByName(root, "Image_title_4"):setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Image_bar_1_title_2"):setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Image_bar_1_title_1"):setVisible(false)
        else
            ccui.Helper:seekWidgetByName(root, "Image_title_5"):setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Image_bar_1_title_1"):setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Image_bar_1_title_2"):setVisible(false)
        end
        ccui.Helper:seekWidgetByName(root, "Image_hb_phb_bar_1"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Image_hb_phb_bar_2"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Image_gerenjilu_1"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Image_gerenjilu_2"):setVisible(false)
        if myData ~= nil then
            ccui.Helper:seekWidgetByName(root, "Text_gr_cishu"):setString(myData.snatch_number)
            ccui.Helper:seekWidgetByName(root, "Text_gr_jiazhi"):setString(myData.snatch_value)
        else
            ccui.Helper:seekWidgetByName(root, "Text_gr_cishu"):setString(0)
            ccui.Helper:seekWidgetByName(root, "Text_gr_jiazhi"):setString(0)
        end
    end
end

function SmUnionRedEnvelopesRank:init(params)
    self.m_type = params[1]
    self.name = params[2] or nil
    self:onInit()
    return self
end


function SmUnionRedEnvelopesRank:onInit()
    local csbSmUnionRedEnvelopesRank = csb.createNode("legion/sm_legion_red_packet_rank.csb")
    local root = csbSmUnionRedEnvelopesRank:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionRedEnvelopesRank)
    self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_red_envelopes_rank_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

end

function SmUnionRedEnvelopesRank:onExit()
    state_machine.remove("sm_union_red_envelopes_rank_display")
    state_machine.remove("sm_union_red_envelopes_rank_hide")
end