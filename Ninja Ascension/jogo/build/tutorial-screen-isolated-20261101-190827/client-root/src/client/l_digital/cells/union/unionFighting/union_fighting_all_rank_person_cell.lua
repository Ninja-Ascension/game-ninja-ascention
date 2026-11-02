--------------------------------------------------------------------------------------------------------------
--  公会战排行个人排行列表cell
--------------------------------------------------------------------------------------------------------------
UnionFightingAllRankPersonCell = class("UnionFightingAllRankPersonCellClass", Window)
UnionFightingAllRankPersonCell.__size = nil

-- 创建cell
local union_fighting_all_rank_person_cell_create_terminal = {
    _name = "union_fighting_all_rank_person_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = UnionFightingAllRankPersonCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_fighting_all_rank_person_cell_create_terminal)
state_machine.init()

function UnionFightingAllRankPersonCell:ctor()
    self.super:ctor()
    self.roots = {}
    
    -- 定义变量
    self._index = 0
    self._info = nil
    self._rank_type = 0
    
    -- 加载lua文件
    
    -- 初始化状态机
    local function init_union_fighting_all_rank_person_cell_terminal()
        local union_fighting_all_rank_person_cell_update_info_terminal = {
            _name = "union_fighting_all_rank_person_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params.cell
                cell._index = params.index
                cell._info = params.info
                cell._rank_type = params.rank_type
                if cell._info ~= nil then
                    if cell._index <= 5 then
                        cell:reload()
                        cell:updateDraw()
                    else
                        cell:unload()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local union_fighting_all_rank_person_cell_see_user_terminal = {
            _name = "union_fighting_all_rank_person_cell_see_user",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local userID = params._datas.userId
                
                -- DSC统一玩家详情界面
                if __lua_project_id == __lua_project_l_digital then
                    OpenOtherUserInformation(userID, nil, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fighting_all_rank_person_cell_update_info_terminal)
        state_machine.add(union_fighting_all_rank_person_cell_see_user_terminal)
        state_machine.init()
    end 
    init_union_fighting_all_rank_person_cell_terminal()
end

-- 刷新
function UnionFightingAllRankPersonCell:updateDraw()
    local root = self.roots[1]
    local Panel_rank_top_3 = ccui.Helper:seekWidgetByName(root,"Panel_rank_top_3")
    local Text_ghz_gr_rank_name = ccui.Helper:seekWidgetByName(root,"Text_ghz_gr_rank_name")
    local Text_ghz_gr_legion_name = ccui.Helper:seekWidgetByName(root,"Text_ghz_gr_legion_name")
    local Text_ghz_rank_n = ccui.Helper:seekWidgetByName(root,"Text_ghz_rank_n")
    local Text_ghz_gr_win_n = ccui.Helper:seekWidgetByName(root,"Text_ghz_gr_win_n")
    local Image_ghz_gr_rank_k = ccui.Helper:seekWidgetByName(root,"Image_ghz_gr_rank_k")
    Panel_rank_top_3:removeBackGroundImage()

    local color = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        color = cc.c3b(71, 71, 71)
    end
    if self._info.rank > 3 then
        Text_ghz_rank_n:setString(self._info.rank)
    else
        Text_ghz_rank_n:setString("")
        Panel_rank_top_3:setBackGroundImage(string.format("images/ui/text/GHZ_res/gh_rank_%d.png", self._info.rank))
        color = cc.c3b(union_fighting_rank_text_color[self._info.rank][1], union_fighting_rank_text_color[self._info.rank][2], union_fighting_rank_text_color[self._info.rank][3])
    end
    Text_ghz_gr_rank_name:setColor(color)
    Text_ghz_gr_legion_name:setColor(color)
    Text_ghz_gr_win_n:setColor(color)

    if self._info.user_id > 0 then
        Text_ghz_gr_rank_name:setVisible(true)
        Text_ghz_gr_legion_name:setVisible(true)
        Text_ghz_gr_win_n:setVisible(true)
        Image_ghz_gr_rank_k:setVisible(false)

        root:setTouchEnabled(true)

        Text_ghz_gr_rank_name:setString(self._info.user_name)
        Text_ghz_gr_legion_name:setString(self._info.union_name)
        Text_ghz_gr_win_n:setString(string.format(_new_interface_text[216], self._info.win_times))
    else
        Text_ghz_gr_rank_name:setVisible(false)
        Text_ghz_gr_legion_name:setVisible(false)
        Text_ghz_gr_win_n:setVisible(false)
        Image_ghz_gr_rank_k:setVisible(true)
        
        root:setTouchEnabled(false)
    end
end 

function UnionFightingAllRankPersonCell:onInit()
    local root = cacher.createUIRef(string.format(config_csb.union_fight.sm_legion_ghz_rank_cell, 2), "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if UnionFightingAllRankPersonCell.__size == nil then
        UnionFightingAllRankPersonCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "union_fighting_all_rank_person_cell_see_user",
        terminal_state = 0,
        userId = self._info.user_id,
    },
    nil,0)
    self:updateDraw()
end

function UnionFightingAllRankPersonCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function UnionFightingAllRankPersonCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_rank_top_3 = ccui.Helper:seekWidgetByName(root,"Panel_rank_top_3")
    local Text_ghz_gr_rank_name = ccui.Helper:seekWidgetByName(root,"Text_ghz_gr_rank_name")
    local Text_ghz_gr_legion_name = ccui.Helper:seekWidgetByName(root,"Text_ghz_gr_legion_name")
    local Text_ghz_rank_n = ccui.Helper:seekWidgetByName(root,"Text_ghz_rank_n")
    local Text_ghz_gr_win_n = ccui.Helper:seekWidgetByName(root,"Text_ghz_gr_win_n")
    
    if Panel_rank_top_3 ~= nil then
        Panel_rank_top_3:removeBackGroundImage()
        Text_ghz_gr_rank_name:setString("")
        Text_ghz_gr_legion_name:setString("")
        Text_ghz_rank_n:setString("")
        Text_ghz_gr_win_n:setString("")
    end
end

function UnionFightingAllRankPersonCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function UnionFightingAllRankPersonCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.union_fight.sm_legion_ghz_rank_cell, 2), root)
    root:removeFromParent(false)
    self.roots = {}
end

function UnionFightingAllRankPersonCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._rank_type = params[3]
    if self._index ~= nil and self._index <= 5 then
       self:onInit()
    end
    self:setContentSize(UnionFightingAllRankPersonCell.__size)
    return self
end

function UnionFightingAllRankPersonCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.union_fight.sm_legion_ghz_rank_cell, 2), self.roots[1])
end