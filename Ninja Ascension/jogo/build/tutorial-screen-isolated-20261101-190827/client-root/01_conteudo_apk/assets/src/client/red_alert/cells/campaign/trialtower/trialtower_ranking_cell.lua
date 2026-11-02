-----------------------------
--无尽之战排名控件
-----------------------------
TrialtowerRankingCell = class("TrialtowerRankingCellClass", Window)
TrialtowerRankingCell.__size = nil

--无尽之战排名列表
local trialtower_ranking_create_cell_terminal = {
    _name = "trialtower_ranking_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local rank_info = params[1]
        local index = params[2]
        local cell = TrialtowerRankingCell:new()
        cell:init(rank_info,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(trialtower_ranking_create_cell_terminal)
state_machine.init()

function TrialtowerRankingCell:ctor()
    self.super:ctor()
    self.roots = {}

    -- var 
    -- 信息
    self.rank_info = nil
    -- load lua file
end

--刷新排名列表
function TrialtowerRankingCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_head = ccui.Helper:seekWidgetByName(root,"Panel_head") -- 头像
    local Panel_national = ccui.Helper:seekWidgetByName(root,"Panel_national") -- 阵营
    local BitmapFontLabel_rank = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_rank") -- 排名
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name") -- 名字
    local Text_office_lv = ccui.Helper:seekWidgetByName(root,"Text_office_lv") -- 官阶
    local Text_progress_inner = ccui.Helper:seekWidgetByName(root,"Text_progress_inner") -- 进度
    Panel_head:removeAllChildren(true)
    local head_icon = state_machine.excute("user_head_icon_create",0,{self.rank_info,3})
    Panel_head:addChild(head_icon)
    BitmapFontLabel_rank:setString("")
    for i = 1,3 do
        local Image_rank = ccui.Helper:seekWidgetByName(root,"Image_rank_"..i)
        Image_rank:setVisible(false)
    end
    for i = 1,4 do
        local Image_bg = ccui.Helper:seekWidgetByName(root,"Image_bg_"..i)
        Image_bg:setVisible(false)
    end
    Panel_national:setBackGroundImage("images/ui/quality/camp_icon_"..self.rank_info.user_camp..".png")
    Text_name:setString(self.rank_info.user_name)
    Text_office_lv:setString(red_alert_officer[tonumber(self.rank_info.user_official)])
    -- print("=======1======",string.format(red_alert_all_str[118],self.rank_info.user_process))
    Text_progress_inner:setString(string.format(red_alert_all_str[118],self.rank_info.user_process))

    if tonumber(self.rank_info.user_rank) < 4 and tonumber(self.rank_info.user_rank) ~= 0 then
        local Image_rank = ccui.Helper:seekWidgetByName(root,"Image_rank_"..self.rank_info.user_rank)
        local Image_bg = ccui.Helper:seekWidgetByName(root,"Image_bg_"..self.rank_info.user_rank)
        Image_rank:setVisible(true)
        Image_bg:setVisible(true)
    else
        local Image_bg = ccui.Helper:seekWidgetByName(root,"Image_bg_4")
        Image_bg:setVisible(true)
        -- print("===2======",self.rank_info.user_rank)
        BitmapFontLabel_rank:setString(self.rank_info.user_rank)
    end

    -- user_id = i,
    -- user_name = "yanghan",
    -- user_camp = math.random(1,3),
    -- user_rank = i,
    -- user_process = math.random(1,100),

end


function TrialtowerRankingCell:onEnterTransitionFinish()

end

--初始化列表
function TrialtowerRankingCell:onInit( )
    local root = cacher.createUIRef(config_csb.cells.campaign.trialtower.trialtower_ranking_cell,"root")
    table.insert(self.roots, root)
    self:addChild(root)

    if TrialtowerRankingCell.__size == nil then
        TrialtowerRankingCell.__size = root:getContentSize()
    end
	self:onUpdateDraw()	
end

--重新加载列表
function TrialtowerRankingCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

--移除列表
function TrialtowerRankingCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local Panel_head = ccui.Helper:seekWidgetByName(root,"Panel_head")
    Panel_head:removeAllChildren(true)
    cacher.freeRef(config_csb.cells.campaign.trialtower.trialtower_ranking_cell)
    root:removeFromParent(false)
    self.roots = {}
end

function TrialtowerRankingCell:init(rank_info,index)
    self.rank_info = rank_info
    if index ~= nil and index < 5 then
	   self:onInit()
    end
    --设置能够包含的实际大小
    self:setContentSize(TrialtowerRankingCell.__size)
    return self
end

--退出
function TrialtowerRankingCell:onExit()
    local Panel_head = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_head")
    if Panel_head ~= nil then
        Panel_head:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.cells.campaign.trialtower.trialtower_ranking_cell,self.roots[1])
end
