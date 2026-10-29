--------------------------------------------------------------------------------------------------------------
--  国战排行榜信息
--------------------------------------------------------------------------------------------------------------
NationalRankCell = class("NationalRankCellClass", Window)
NationalRankCell.__size = nil
NationalRankCell.__fontName = ""
--创建cell
local national_rank_cell_create_terminal = {
    _name = "national_rank_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = NationalRankCell:new()
        local data = params[1]
        local index = params[2]
        cell:init(data,index)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_rank_cell_create_terminal)
state_machine.init()

function NationalRankCell:ctor()
    -- 初始化调用参数
    self.super:ctor()
    self.roots = {}

    -- load
    app.load("client.red_alert.cells.player_head_cell")

    -- var
    self.data = nil
end

function NationalRankCell:onUpdateDraw()
    local pageIndex = self.data.pageIndex
    local honour_bonus = self.data.rank_point
    local name = self.data.rank_name
    local index = tonumber(self.data.rank_order)
    local mycamp = self.data.mycamp
    local sex = self.data.rank_sex
    local level = self.data.rank_lv

    if index == nil then
        return
    end

    -- 更新对应数据
    local root = self.roots[1]

    -- 自身数据
    local Image_national_rank_cell_right = ccui.Helper:seekWidgetByName(root, "Image_national_rank_cell_right")
    Image_national_rank_cell_right:setVisible(true)
    if mycamp then
        Image_national_rank_cell_right:setVisible(false)
    end

    local Text_national_rank_stand = ccui.Helper:seekWidgetByName(root, "Text_national_rank_stand")
    Text_national_rank_stand:setString("")

    -- 添加名次
    for i=1,3 do
         local Image_national_rank_cell_right = ccui.Helper:seekWidgetByName(root, "Image_national_rank_cell_right_"..i)
         Image_national_rank_cell_right:setVisible(false)
    end

    local stand = {
        [1] = function()    -- for case 1 1st
            local Image_national_rank_cell_right_1 = ccui.Helper:seekWidgetByName(root, "Image_national_rank_cell_right_1")
            Image_national_rank_cell_right_1:setVisible(true)
        end,
        [2] = function()    -- for case 2 2nd
            local Image_national_rank_cell_right_2 = ccui.Helper:seekWidgetByName(root, "Image_national_rank_cell_right_2")
            Image_national_rank_cell_right_2:setVisible(true)
        end,
        [3] = function()    -- for case 3 3rd
            local Image_national_rank_cell_right_3 = ccui.Helper:seekWidgetByName(root, "Image_national_rank_cell_right_3")
            Image_national_rank_cell_right_3:setVisible(true)
        end,
        [4] = function()    -- for case 4 other
            Text_national_rank_stand:setString(tonumber(index))
        end
    }
    local stand_func_index = 0
    if index < 4 then 
        stand_func_index = index
    elseif index < 50 then
        stand_func_index = 4
    end
    local stand_func = stand[stand_func_index]
    if (stand_func) then
        stand_func()
    else
        Text_national_rank_stand:setString(red_alert_all_str[43])
    end

    -- 添加头像模块
    local Panel_national_rank_cell_right_icon = ccui.Helper:seekWidgetByName(root, "Panel_national_rank_cell_right_icon")
    Panel_national_rank_cell_right_icon:removeAllChildren(true)
    local headCell = state_machine.excute("player_head_cell_create", 0, self.data)
    headCell:removeFromParent(true)
    Panel_national_rank_cell_right_icon:addChild(headCell)

    -- 添加阵营icon
    local Panel_national_rank_cell_right_camp = ccui.Helper:seekWidgetByName(root, "Panel_national_rank_cell_right_camp")
    Panel_national_rank_cell_right_camp:removeAllChildren(true)
    local image = cc.Sprite:create("images/ui/quality/camp_icon_" .. pageIndex .. ".png")
    Panel_national_rank_cell_right_camp:addChild(image)

    -- 添加名字
    local Text_national_rank_cell_right_name = ccui.Helper:seekWidgetByName(root, "Text_national_rank_cell_right_name")
    if NationalRankCell.__fontName == "" then 
        NationalRankCell.__fontName = Text_national_rank_cell_right_name:getFontName()
    end
    if ___is_open_leadname == true then 
        Text_national_rank_cell_right_name:setFontName("")   
        Text_national_rank_cell_right_name:setFontSize(Text_national_rank_cell_right_name:getFontSize())
    end
    Text_national_rank_cell_right_name:setString("")
    Text_national_rank_cell_right_name:setString(name)
    -- 添加奖励数值
    local Text_national_rank_cell_right_value = ccui.Helper:seekWidgetByName(root, "Text_national_rank_cell_right_value")
    Text_national_rank_cell_right_value:setString("")
    Text_national_rank_cell_right_value:setString(honour_bonus)
end


function NationalRankCell:onInit()
    -- 绘图初始化
    local root = cacher.createUIRef(config_csb.cells.campaign.nationalwar.nationalwar_rank_cell_right, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if NationalRankCell.__size == nil then
        NationalRankCell.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end

function NationalRankCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function NationalRankCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.campaign.nationalwar.nationalwar_rank_cell_right, root)
    root:removeFromParent(false)
    self.roots = {}
end

function NationalRankCell:init(data,index)
    -- 参数赋值
    self.data = data
    if index ~= nil and index < 7 then
        self:onInit()
    end
    self:setContentSize(NationalRankCell.__size)
    return self
end

function NationalRankCell:onExit()
    cacher.freeRef(config_csb.cells.campaign.nationalwar.nationalwar_rank_cell_right, self.roots[1])
end