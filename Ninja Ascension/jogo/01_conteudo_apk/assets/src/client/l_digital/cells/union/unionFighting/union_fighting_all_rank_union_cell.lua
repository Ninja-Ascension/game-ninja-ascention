--------------------------------------------------------------------------------------------------------------
--  公会战排行公会排行列表cell
--------------------------------------------------------------------------------------------------------------
UnionFightingAllRankUnionCell = class("UnionFightingAllRankUnionCellClass", Window)
UnionFightingAllRankUnionCell.__size = nil

-- 创建cell
local union_fighting_all_rank_union_cell_create_terminal = {
    _name = "union_fighting_all_rank_union_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = UnionFightingAllRankUnionCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_fighting_all_rank_union_cell_create_terminal)
state_machine.init()

function UnionFightingAllRankUnionCell:ctor()
    self.super:ctor()
    self.roots = {}
    
    -- 定义变量
    self._index = 0
    self._info = nil
    self._show_score = false
    
    -- 加载lua文件
    app.load("client.l_digital.union.create.SmUnionInfoWindow")
    -- 初始化状态机
    local function init_union_fighting_all_rank_union_cell_terminal()
        local union_fighting_all_rank_union_cell_update_info_terminal = {
            _name = "union_fighting_all_rank_union_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params.cell
                cell._index = params.index
                cell._info = params.info
                cell._show_score = params.show_score
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
        
        local union_fighting_all_rank_union_cell_see_union_terminal = {
            _name = "union_fighting_all_rank_union_cell_see_union",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- DSC打开公会详情界面
                if __lua_project_id == __lua_project_l_digital then
                    local unionID = params._datas.unionID
                    local cell = params._datas.cell
                    local function responseShowUnionInfoCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            _ED.union_see_info.union_kuang = 1
                            state_machine.excute("sm_union_info_window_window_open", 0, _ED.union_see_info)
                        end
                    end
                    protocol_command.see_union_info.param_list = unionID
                    NetworkManager:register(protocol_command.see_union_info.code, nil, nil, nil, cell, responseShowUnionInfoCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fighting_all_rank_union_cell_update_info_terminal)
        state_machine.add(union_fighting_all_rank_union_cell_see_union_terminal)
        state_machine.init()
    end 
    init_union_fighting_all_rank_union_cell_terminal()
end

-- 刷新
function UnionFightingAllRankUnionCell:updateDraw()
    local root = self.roots[1]
    local Panel_rank_top_3 = ccui.Helper:seekWidgetByName(root,"Panel_rank_top_3")
    local Text_ghz_rank_name = ccui.Helper:seekWidgetByName(root,"Text_ghz_rank_name")
    local Text_ghz_rank_n = ccui.Helper:seekWidgetByName(root,"Text_ghz_rank_n")
    local Image_ghz_rank_k = ccui.Helper:seekWidgetByName(root,"Image_ghz_rank_k")
    local Image_ghz_jf_bg = ccui.Helper:seekWidgetByName(root,"Image_ghz_jf_bg")
    local Text_ghz_jf_n = ccui.Helper:seekWidgetByName(root,"Text_ghz_jf_n")
    Panel_rank_top_3:removeBackGroundImage()
    Image_ghz_jf_bg:setVisible(false)
    Text_ghz_jf_n:setVisible(false)

    local color = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        color = cc.c3b(71, 71, 71)
    end
    if self._info.rank > 3 then
        Text_ghz_rank_n:setString(self._info.rank)
    else
        Text_ghz_rank_n:setString("")
        Panel_rank_top_3:setBackGroundImage(string.format("images/ui/text/SMZB_res/%d.png", self._info.rank + 12))
        color = cc.c3b(union_fighting_rank_text_color[self._info.rank][1], union_fighting_rank_text_color[self._info.rank][2], union_fighting_rank_text_color[self._info.rank][3])
    end
    Text_ghz_rank_name:setColor(color)

    if self._info.union_id > 0 then
        Text_ghz_rank_name:setVisible(true)
        Image_ghz_rank_k:setVisible(false)

        Text_ghz_rank_name:setString(self._info.union_name)

        root:setTouchEnabled(true)

        if self._show_score == true then
            Image_ghz_jf_bg:setVisible(true)
            Text_ghz_jf_n:setVisible(true)
            Text_ghz_jf_n:setString(self._info.score)
        end
    else
        Text_ghz_rank_name:setVisible(false)
        Image_ghz_rank_k:setVisible(true)
        
        root:setTouchEnabled(false)
    end
end 

function UnionFightingAllRankUnionCell:onInit()
    local root = cacher.createUIRef(string.format(config_csb.union_fight.sm_legion_ghz_rank_cell, 1), "root")
    table.insert(self.roots, root)
    self:addChild(root)
    if UnionFightingAllRankUnionCell.__size == nil then
        UnionFightingAllRankUnionCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "union_fighting_all_rank_union_cell_see_union",
        terminal_state = 0,
        unionID = self._info.union_id,
        cell = self
    },
    nil,0)

    self:updateDraw()
end

function UnionFightingAllRankUnionCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function UnionFightingAllRankUnionCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_rank_top_3 = ccui.Helper:seekWidgetByName(root,"Panel_rank_top_3")
    local Text_ghz_rank_name = ccui.Helper:seekWidgetByName(root,"Text_ghz_rank_name")
    local Text_ghz_rank_n = ccui.Helper:seekWidgetByName(root,"Text_ghz_rank_n")
    local Text_ghz_jf_n = ccui.Helper:seekWidgetByName(root,"Text_ghz_jf_n")
    if Panel_rank_top_3 ~= nil then
        Panel_rank_top_3:removeBackGroundImage()
        Text_ghz_rank_name:setString("")
        Text_ghz_rank_n:setString("")
        Text_ghz_jf_n:setString("")
    end
end

function UnionFightingAllRankUnionCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function UnionFightingAllRankUnionCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.union_fight.sm_legion_ghz_rank_cell, 1), root)
    root:removeFromParent(false)
    self.roots = {}
end

function UnionFightingAllRankUnionCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._show_score = params[3]

    if self._index ~= nil and self._index <= 5 then
       self:onInit()
    end
    self:setContentSize(UnionFightingAllRankUnionCell.__size)
    return self
end

function UnionFightingAllRankUnionCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.union_fight.sm_legion_ghz_rank_cell, 1), self.roots[1])
end