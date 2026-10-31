--------------------------------------------------------------------------------------------------------------
--  国战奖励栏信息
--------------------------------------------------------------------------------------------------------------
NationalRewardCell = class("NationalRewardCellClass", Window)
NationalRewardCell.__size = nil

--创建cell
local national_reward_cell_create_terminal = {
    _name = "national_reward_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = NationalRewardCell:new()
        cell:init(params)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_reward_cell_create_terminal)
state_machine.init()

function NationalRewardCell:ctor()
    -- 初始化调用参数
    self.super:ctor()
    self.roots = {} 
end

function NationalRewardCell:updateDraw(params)
    local index = params._index
    local reward_type = params._type
    local rank_info = params._reward_info
    -- 更新对应数据
    local root = self.roots[1]
    local Panel_national_truce_reward_cell_place = ccui.Helper:seekWidgetByName(root,"Panel_national_truce_reward_cell_place")
    local Image_rank = nil
    -- reward_type 0、国家 1、个人
    if reward_type == 0 then
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
            Image_rank = cc.Sprite:create(string.format(config_img.imagePath.nationalwar_paihang, index))
        else
            Image_rank = cc.Sprite:create(string.format(config_img.imagePath.nationalwar_paihang_jiangli, index))
        end
    elseif reward_type == 1 then
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
            if tonumber(index) >= 2 and tonumber(index) <= 5 then
                index = index + 8
            end
        end
        Image_rank = cc.Sprite:create(string.format(config_img.imagePath.nationalwar_paihang, index))
    end
    Image_rank:setAnchorPoint(cc.p(0,0))
    Panel_national_truce_reward_cell_place:addChild(Image_rank)


    -- 任务奖励读取
    local table_split_reward_element = zstring.split(rank_info, "|")
    -- print("oooooooooooooooooooooooooooo",#table_split_reward_element)
    for i,v in pairs(table_split_reward_element) do
        local table_split_reward_info = zstring.split(v,",")
        local task_reward_type = tonumber(table_split_reward_info[1])
        local task_reward_item = tonumber(table_split_reward_info[2])
        local task_reward_num = tonumber(table_split_reward_info[3])

        -- 任务icon
        local Panel_national_truce_reward_cell_place_icon = ccui.Helper:seekWidgetByName(root, "Panel_national_truce_reward_cell_place_icon_" .. i)
        local data = 
        {
            prop_type = task_reward_type,
            prop_item = task_reward_item,
            item_value = task_reward_num,
        } 
        local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})   
        Panel_national_truce_reward_cell_place_icon:addChild(cell)
    end

    -- -- 奖励1
    -- for i=1,2 do
    --     local Panel_national_truce_reward_cell_place_icon = ccui.Helper:seekWidgetByName(root,"Panel_national_truce_reward_cell_place_icon_" .. i)
    --     local data = 
    --         {
    --             prop_type = 6,
    --             prop_item = 995,
    --             item_value = 100*i,
    --         }
    --     -- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
    --     -- else
    --         local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0})
    --         Panel_national_truce_reward_cell_place_icon:addChild(cell)
    --     -- end
    -- end
end

function NationalRewardCell:init(params)
    -- 成员变量赋值
    self:onInit(params)
    return self
end

function NationalRewardCell:onInit(params)
    -- 绘图初始化
    local csbItem = csb.createNode(config_csb.cells.campaign.nationalwar.nationalwar_reward_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)

    if NationalRewardCell.__size == nil then
        NationalRewardCell.__size = root:getContentSize()
    end

    self:setContentSize(NationalRewardCell.__size)
    self:updateDraw(params)
end


function NationalRewardCell:onExit()

end