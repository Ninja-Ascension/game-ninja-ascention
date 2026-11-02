-- ----------------------------------------------------------------------------------------------------
-- 说明：属性信息
-------------------------------------------------------------------------------------------------------
ExploreBookAttributeCellPageInfo = class("ExploreBookAttributeCellPageInfoClass", Window)

local ExploreBookAttributeCellPageInfo_open_terminal = {
    _name = "ExploreBookAttributeCellPageInfo_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ExploreBookAttributeCellPageInfoClass")
        if nil == _homeWindow then
            local panel = ExploreBookAttributeCellPageInfo:new():init(params)
            fwin:open(panel, fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(ExploreBookAttributeCellPageInfo_open_terminal)
state_machine.init()
    
function ExploreBookAttributeCellPageInfo:ctor()
    self.roots = {}

    local ExploreBookAttributeCellPageInfo_close_terminal = {
        _name = "ExploreBookAttributeCellPageInfo_close",
        _init = function (terminal) 
        
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local _homeWindow = fwin:find("ExploreBookAttributeCellPageInfoClass")
            if nil ~= _homeWindow then
                fwin:close(fwin:find("ExploreBookAttributeCellPageInfoClass"))

                local cell = params._datas.cell
                state_machine.excute("explorebook_holy_cell_icon_hide_select_anim", 0, {cell})
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    
    state_machine.add(ExploreBookAttributeCellPageInfo_close_terminal)
    state_machine.init()
end

function ExploreBookAttributeCellPageInfo:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local book_talent_level = 1
    for i, v in pairs(_ED.explore_book_data.telent.information) do
        if v.id ~= nil then       
            if v.id == self.index then 
                book_talent_level = v.level
            end
        else
            book_talent_level = 1
        end
    end

    local book_talent_id_info = dms.searchs(dms["explore_achievement_talent_mould"], 2, self.index)
    local talent_info = {}
    for j, k in pairs(book_talent_id_info) do
        if tonumber(k[3]) == book_talent_level then
            table.insert(talent_info,k)
        end
    end

    local Text_explore_holy_infor_name = ccui.Helper:seekWidgetByName(root, "Text_explore_holy_infor_name")
    local Text_explore_holy_up_top = ccui.Helper:seekWidgetByName(root, "Text_explore_holy_up_top")
    local Panel_explore_holy_icon = ccui.Helper:seekWidgetByName(root, "Panel_explore_holy_icon")
    --local book_icon_name = dms.string(dms["explore_achievement_talent_mould"],(self.index),4)
    --local book_icon_dj = dms.string(dms["explore_achievement_talent_mould"],self.index,3)
    --local word_info = dms.element(dms["word_mould"], book_icon_name)
    local word_info = dms.element(dms["word_mould"], tonumber(talent_info[1][4]))
    Text_explore_holy_infor_name:setString(word_info[3])
    Text_explore_holy_up_top:setString(_new_interface_text[103]..book_talent_level)
    --local book_icon_id = dms.string(dms["explore_achievement_talent_mould"],self.index,9)
    Panel_explore_holy_icon:removeAllChildren(true)

    --local spriteImage = string.format("images/ui/talent_icon/talent_icon_%s.png", ""..book_icon_id)
    local spriteImage = string.format("images/ui/talent_icon/talent_icon_%s.png", ""..tonumber(talent_info[1][9]))
    local currSprite = cc.Sprite:create(spriteImage)
    currSprite:setAnchorPoint(0,0)
    Panel_explore_holy_icon:addChild(currSprite)

    local Text_explore_holy_infor = ccui.Helper:seekWidgetByName(root, "Text_explore_holy_infor")
    --local book_icon_info = dms.string(dms["explore_achievement_talent_mould"],self.index,11)
    --local book_talent_id_info = dms.searchs(dms["explore_achievement_talent_mould"], 2, self.index/2)
    -- local talent_info = {}
    -- for j, k in pairs(book_talent_id_info) do
    --     if tonumber(k[3]) == book_talent_level then
    --         table.insert(talent_info,k)
    --     end
    -- end
    local word_info = dms.element(dms["word_mould"], tonumber(talent_info[1][11]))
    Text_explore_holy_infor:setString(word_info[3])
end

function ExploreBookAttributeCellPageInfo:init(params)
    self.data = params[1]
    self.index = params[2]
    self:onInit()
    return self
end

function ExploreBookAttributeCellPageInfo:onInit()
    local node = csb.createNode("campaign/explore/explore_holy_infor.csb")
    local root = node:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(node)

    self:onUpdateDraw()

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Image_5"), nil, 
    {
        terminal_name = "ExploreBookAttributeCellPageInfo_close", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        cell = self.data.cell
    }, 
    nil, 0)
	
end

function ExploreBookAttributeCellPageInfo:onExit()
    state_machine.remove("ExploreBookAttributeCellPageInfo_close") 
end