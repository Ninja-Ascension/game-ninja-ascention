-- ----------------------------------------------------------------------------------------------------
-- 彩蛋奖励绘制
-- ----------------------------------------------------------------------------------------------------
EasterEggReward = class("EasterEggRewardClass", Window)

function EasterEggReward:ctor()
    self.super:ctor()

    self.roots = {}
    self.actions = {}

    self._rewardType = nil
    self._rewardInfo = nil
    self._eventInfo = nil -- 彩蛋id
    self._rewardPad = {}

    self._isShowDouble = false
    self._needSort = true -- 是否对奖励内容进行排序
    self._callback = nil   -- 领奖后回调
    self._max_draw_count = 5

    self._draw_last_index = 1

    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.utils.sm_item_icon_cell")
    app.load("client.cells.prop.prop_money_icon")
    app.load("client.cells.prop.prop_money_info")
    app.load("client.cells.prop.prop_information")
    app.load("client.packs.hero.SmHeroSynthesisSuccess")
    app.load("client.cells.prop.sm_hero_information")
    app.load("client.cells.ship.hero_icon_list_cell")
    --app.load("client.packs.hero.SmRoleFashionCard")
    -- Initialize EasterEggReward page state machine.
    local function init_hero_reborn_terminal()
        -- local hero_reborn_terminal = {
        -- _name = "EasterEggReward",
        -- _init = function (terminal)

        -- end,
        -- _inited = false,
        -- _instance = self,
        -- _state = 0,
        -- _invoke = function(terminal, instance, params)

        -- return true
        -- end,
        -- _terminal = nil,
        -- _terminals = nil
        -- }

        local easter_egg_reward_close_terminal = {
            _name = "easter_egg_reward_close",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if fwin:find("SmTrialTowerRewardClass") ~= nil then
                    state_machine.unlock("sm_trial_tower_reward_list_cell_reward_request", 0, "")
                end
                instance:onCheckOver()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- state_machine.add(hero_reborn_terminal)
        state_machine.add(easter_egg_reward_close_terminal)
        state_machine.init()
    end

    init_hero_reborn_terminal()
end

function EasterEggReward:onCheckOver()
    if nil ~= self._rewardInfo and tonumber(self._rewardInfo.show_reward_item_count) >= self._draw_last_index then
        if self._rewardSorting ~= nil then
            self._rewardInfo.show_reward_list = rewardDrawSorting(self._rewardInfo.show_reward_list, self._rewardSorting)
        end
        self:onUpdateDraw(self._draw_last_index, self._rewardInfo, self._max_draw_count)
    else
        if self._callback then 
            self._callback()
        end
        fwin:close(self)
    end
end

function EasterEggReward:onUpdateDraw(beginIndex, rewardInfo, drawMaxCount)
    local root = self.roots[1]
	-- 奖励文本
	local perEgg = zstring.split(self._eventInfo.."",",")
    local eggInfo = dms.searchs(dms["easter_event_mould"], easter_egg_mould.ID, perEgg[#perEgg])[1]
	local wordInfo = dms.element(dms["word_mould"], eggInfo[easter_egg_mould.descrip])
	local wordStr = wordInfo[3]
	local Text_reward = ccui.Helper:seekWidgetByName(root, "Text_reward")
	Text_reward:setString(wordStr)

    local rewardInfo_r = rewardInfo.show_reward_list
    local function sortFunc(a, b)
        -- return a.prop_item < b.prop_item
        if a.prop_item < b.prop_item then
            return true
        elseif a.prop_item == b.prop_item then
            return tonumber(a.item_value) < tonumber(b.item_value)
        else
            return false
        end
    end

    if self._needSort == true then
        table.sort(rewardInfo_r, sortFunc)
    end
    local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_reward")
    rewardListView:removeAllItems()
    local nCount = 0

    for i = beginIndex, tonumber(rewardInfo.show_reward_item_count) do
        -- if i > 4 then
        -- 	break
        -- end
        local flag = false
        local rewardList = rewardInfo_r[i]
        local id = rewardList.prop_item
        local cell = nil
        -- 物品1类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点
        -- 11:上阵人数 12:体力 13:武将 14竞技场排名 15:伤害 16:比武积分 17:霸气18威名 19 日常任务积分 20功勋 21战功)
        --如果有钱 29 胜点（排位赛使用） 32 魔陷卡 33 驯兽魂
        if tonumber(rewardList.prop_type) == 1 and tonumber(rewardList.item_value) > 0 and flag == false then
            local quality = 1
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                -- quality = 3
                -- cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1,nil,nil,true,true)
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, -1, rewardList.item_value}, true, true, false, true})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
            end
            -- self._rewardPad[i]:addChild(cell)
            flag = true
            rewardListView:addChild(cell)
           
        end

        --如果有宝石
        if tonumber(rewardList.prop_type) == 2 and tonumber(rewardList.item_value) > 0 and flag == false then
            local quality = 5
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                -- quality = 3
                -- cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1,nil,nil,true,true)
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, -1, rewardList.item_value}, true, true, false, true})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
            end
            -- self._rewardPad[i]:addChild(cell)
            flag = true
            rewardListView:addChild(cell)
           
        end
        --胜点(排位赛使用)
        if tonumber(rewardList.prop_type) == 29 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, -1, rewardList.item_value}, true, true, false, true})
            else
                cell = propMoneyIcon:createCell()
                cell:init("29", tonumber(rewardList.item_value), nil)
            end
            rewardListView:addChild(cell)
            
        end
        --如果有魂玉
        if tonumber(rewardList.prop_type) == 5 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, -1, rewardList.item_value}, true, true, false, true})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
            end
            -- self._rewardPad[i]:addChild(cell)
            flag = true
            rewardListView:addChild(cell)
            
        end
        --道具
        if tonumber(rewardList.prop_type) == 6 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                -- cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item,nil,nil,true,true)
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
            end

            -- self._rewardPad[i]:addChild(cell)
            flag = true
            rewardListView:addChild(cell)
            
        end
        --装备
        if tonumber(rewardList.prop_type) == 7 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                -- cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item,nil,nil,true,true,nil,{equipQuality = 0})
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true, {equipQuality = 0}})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
            end
            -- self._rewardPad[i]:addChild(cell)
            flag = true
            rewardListView:addChild(cell)
            
        end
        -- 皮肤
        if tonumber(rewardList.prop_type) == 64 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                --cell:init(64, 0, tonumber(rewardList.prop_item), nil, nil, true, true, 1,{des_time = des_time_r, skin_num = 1})
                --local cell = ResourcesIconCell:createCell()
                --local limit_time_index  = dms.int(dms["ship_skin_mould"], tonumber(rewardList.prop_item), ship_skin_mould.duration)
                --local des_time_r = zstring.tonumber(limit_time_index) == -1 and tipStringInfo_evolution_status_tips[4] or limit_time_index .. tipStringInfo_evolution_status_tips[5]
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            else
                local cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
            end
            flag = true
            rewardListView:addChild(cell)
        end
        --体力
        if tonumber(rewardList.prop_type) == 12 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, -1, rewardList.item_value}, true, true, false, true, {equipQuality = 0}})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
            end
            flag = true
            rewardListView:addChild(cell)
            
        end

        --武将
        if tonumber(rewardList.prop_type) == 13 and tonumber(rewardList.item_value) > 0 and flag == false then
            local ship = nil
            for i, v in pairs(_ED.user_ship) do
                if _ED.recruit_success_ship_id == v.ship_id then
                    ship = v
                end
            end
            local table = {}
            if ship ~= nil then
                table.shipStar = ship.StarRating
            end

            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                -- cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item,nil,nil,true,true , 1,table)
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, false, false, true, table})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
            end
            -- self._rewardPad[i]:addChild(cell)
            flag = true
            rewardListView:addChild(cell)
            
        end
        --威名
        if tonumber(rewardList.prop_type) == 18 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
            end
            -- self._rewardPad[i]:addChild(cell)
            flag = true
            rewardListView:addChild(cell)

        end
        --声望
        if tonumber(rewardList.prop_type) == 3 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
            end
            -- self._rewardPad[i]:addChild(cell)
            flag = true
            rewardListView:addChild(cell)

        end

        --4:将魂
        if tonumber(rewardList.prop_type) == 4 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
            end
            -- self._rewardPad[i]:addChild(cell)
            flag = true
            rewardListView:addChild(cell)

        end

        if tonumber(rewardList.prop_type) == 21 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            else
                cell = propMoneyIcon:createCell()
                cell:init("7", tonumber(rewardList.item_value), nil)
            end
            rewardListView:addChild(cell)
        end
        if tonumber(rewardList.prop_type) == 28 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
            end
            flag = true
            rewardListView:addChild(cell)
           
        end

        if tonumber(rewardList.prop_type) == 31 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
            end
            flag = true
            rewardListView:addChild(cell)
           
        end

        --驯兽魂
        if tonumber(rewardList.prop_type) == 33 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
            end
            flag = true
            rewardListView:addChild(cell)
           
        end

        if tonumber(rewardList.prop_type) == 8 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
            end
            flag = true
            rewardListView:addChild(cell)
           
        end

        if tonumber(rewardList.prop_type) == 34 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
            end
            flag = true
            rewardListView:addChild(cell)
            
        end

        if tonumber(rewardList.prop_type) == 39 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
            end
            flag = true
            rewardListView:addChild(cell)
           
        end

        if tonumber(rewardList.prop_type) == 63 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
            end
            flag = true
            rewardListView:addChild(cell)

        end

        if tonumber(rewardList.prop_type) == 71 and tonumber(rewardList.item_value) > 0 and flag == false then
            if
                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                    __lua_project_id == __lua_project_onepiece or
                    __lua_project_id == __lua_project_l_naruto
             then
                local property_info = dms.string(dms["ship_silk_bag_mould"], rewardList.prop_item, ship_silk_bag_mould.base_property)
                local basePropertyList = {}
                if nil ~= property_info then
                    local add_property_info = zstring.split(property_info, "|")
                    for i = 1, table.nums(add_property_info) do
                        local add_property_per = zstring.split(add_property_info[i], ",")
                        if nil ~= add_property_per then
                            local a = tipStringInfo_rescue_silkbag_property["0"]
                            local baseProperty = {}
                            baseProperty.property_name = tipStringInfo_rescue_silkbag_property[tostring(add_property_per[1])]
                            baseProperty.property_value = add_property_per[2]
                            basePropertyList[i] = baseProperty
                        end
                    end
                end
                cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true, {basePropertyList, 0}})
            else
                cell = ResourcesIconCell:createCell()
                cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
            end
            flag = true
            rewardListView:addChild(cell)

        end

        if tonumber(rewardList.prop_type) == 65 and tonumber(rewardList.item_value) > 0 and flag == false then
            cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            flag = true
            rewardListView:addChild(cell)
        end

        --合金
        if tonumber(rewardList.prop_type) == 66 and tonumber(rewardList.item_value) > 0 and flag == false then
            cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            flag = true
            rewardListView:addChild(cell)
        end

        --合金精华
        if tonumber(rewardList.prop_type) == 67 and tonumber(rewardList.item_value) > 0 and flag == false then
            flag = true
            cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            rewardListView:addChild(cell)
        end

        -- 探索币
        if tonumber(rewardList.prop_type) == 68 and tonumber(rewardList.item_value) > 0 and flag == false then
            cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            flag = true
            rewardListView:addChild(cell)
        end

        -- 探索币（口袋）
        if tonumber(rewardList.prop_type) == 70 and tonumber(rewardList.item_value) > 0 and flag == false then
            cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            flag = true
            rewardListView:addChild(cell)
        end

        -- 圣物精华
        if tonumber(rewardList.prop_type) == 69 and tonumber(rewardList.item_value) > 0 and flag == false then
            flag = true
            cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            rewardListView:addChild(cell)
        end

        -- 战魂
        if tonumber(rewardList.prop_type) == 73 and tonumber(rewardList.item_value) > 0 and flag == false then
            flag = true
            cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            rewardListView:addChild(cell)

        end

        -- 代金券
        if tonumber(rewardList.prop_type) == 74 and tonumber(rewardList.item_value) > 0 and flag == false then
            flag = true
            cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            rewardListView:addChild(cell)
        end

        -- 头像框
        if tonumber(rewardList.prop_type) == 76 and tonumber(rewardList.item_value) > 0 and flag == false then
            flag = true
            cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
            rewardListView:addChild(cell)
        end

        if cell ~= nil and cell.setActivityDouble ~= nil then
            if self._isShowDouble == true then
                cell:setActivityDouble(self._isShowDouble)
            end
        end
        nCount = nCount + 1
        if nCount >= drawMaxCount and drawMaxCount > 0 then
            break
        end
    end

    self._draw_last_index = self._draw_last_index + nCount

    rewardListView:requestRefreshView()

    if
        __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or
            __lua_project_id == __lua_project_l_pokemon or
            __lua_project_id == __lua_project_onepiece or
            __lua_project_id == __lua_project_l_naruto or
            __lua_project_id == __lua_project_red_alert or
            __lua_project_id == __lua_project_warship_girl_b or
            __lua_project_id == __lua_project_digimon_adventure or
            __lua_project_id == __lua_project_pokemon or
            __lua_project_id == __lua_project_yugioh
     then
        local tpx = 120
        --每个奖励框大小
        local x = rewardListView:getContentSize().width
        local _tables = rewardListView:getItems()
        for i, v in pairs(_tables) do
            tpx = v.roots[1]:getContentSize().width
            v.roots[1]:setPositionX(v.roots[1]:getPositionX() + (x - tpx * #_tables) / 2)
            if drawMaxCount > 0 then
                local t = 0.5 + 0.1 * (i - 1) + 0.001
                v:runAction(
                    cc.Sequence:create(
                        {
                            cc.DelayTime:create(t),
                            cc.CallFunc:create(
                                function(sender)
                                    sender:setVisible(true)
                                end
                            )
                        }
                    )
                )
                v:setVisible(false)
            end
        end
    end
end

function EasterEggReward:onEnterTransitionFinish()
    local csbfenjiefanhuan = csb.createNode("activity/easter_egg/easter_egg_reward.csb")
	local root = csbfenjiefanhuan:getChildByName("root")
	self:addChild(csbfenjiefanhuan)
	table.insert(self.roots, root)

    local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
    local jsonFile = "sprite/spirte_daojuhuode.json"
    local atlasFile = "sprite/spirte_daojuhuode.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "effect", true, nil)
    local isOver = false
    local function onFrameEventBullet(bone, evt, originFrameIndex, currentFrameIndex)
        if evt ~= nil and #evt > 0 then
            if evt == "union_10010101" then
                local jsonFile2 = "sprite/effect_10010101.json"
                local atlasFile2 = "sprite/effect_10010101.atlas"
                local animation2 = sp.spine(jsonFile2, atlasFile2, 1, 0, "animation", true, nil)
                animation2:setPosition(cc.p(Panel_effect:getContentSize().width / 2, Panel_effect:getContentSize().height / 2))
                animation2:setTag(1205)
                Panel_effect:addChild(animation2)
            elseif evt == "union_10010102" then
                if Panel_effect:getChildByTag(1205) ~= nil then
                    Panel_effect:removeChildByTag(1205)
                end
                if isOver == false then
                    isOver = true
                    local jsonFile3 = "sprite/effect_10010102.json"
                    local atlasFile3 = "sprite/effect_10010102.atlas"
                    local animation3 = sp.spine(jsonFile3, atlasFile3, 1, 0, "animation", true, nil)
                    animation3:setPosition(cc.p(Panel_effect:getContentSize().width / 2, Panel_effect:getContentSize().height / 2))
                    Panel_effect:addChild(animation3)
                end
            end
        end
    end
    animation.animationNameList = {"effect", "effect_loop"}
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallback
    animation:getAnimation():setFrameEventCallFunc(onFrameEventBullet)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(animation, 0, 1, false)
    Panel_effect:addChild(animation)
    animation:setPosition(cc.p(Panel_effect:getContentSize().width / 2, Panel_effect:getContentSize().height / 2))
    playEffect(formatMusicFile("effect", 9980))

    
    local action = csb.createTimeline("activity/easter_egg/easter_egg_reward.csb")
    table.insert(self.actions, action)
    csbfenjiefanhuan:runAction(action)

    local btn_ok = ccui.Helper:seekWidgetByName(root, "Button_ok")
    btn_ok:setVisible(false)
    btn_ok:runAction(
        cc.Sequence:create(
            {
                cc.DelayTime:create(1),
                cc.CallFunc:create(
                    function(sender)
                        btn_ok:setVisible(true)
                    end
                )
            }
        )
    )
    fwin:addTouchEventListener(
        btn_ok,
        nil,
        {
            terminal_name = "easter_egg_reward_close",
            terminal_state = 0,
            touch_black = true
        },
        nil,
        3
    )
    action:play("open", false)

    for i = 1, 4 do
        self._rewardPad[i] = ccui.Helper:seekWidgetByName(root, string.format("Panel_huode_%d", i))
    end

    local function calculateIconType(number)
        local iconid = 3009
        if number >= 1 and number <= 9999 then
            iconid = 3009
        elseif number >= 10000 and number <= 99999 then
            iconid = 3011
        elseif number >= 100000 then
            iconid = 3013
        end
        return iconid
    end

    local rewardInfo = nil
    if self._rewardInfo == nil then
        rewardInfo = getSceneReward(self._rewardType == nil and 0 or self._rewardType)
        self._rewardInfo = rewardInfo
    else
        getSceneReward(self._rewardType == nil and 0 or self._rewardType)
        rewardInfo = self._rewardInfo
    end

    if nil == rewardInfo then
        return
    end

    if self._rewardSorting ~= nil then
        self._rewardInfo.show_reward_list = rewardDrawSorting(self._rewardInfo.show_reward_list, self._rewardSorting)
        self._rewardInfo.show_reward_item_count = #self._rewardInfo.show_reward_list
    end
    self:onUpdateDraw(self._draw_last_index, self._rewardInfo, self._max_draw_count)
end

function EasterEggReward:onExit()
    -- state_machine.remove("EasterEggReward")
    state_machine.remove("draw_rare_reward_on_check_over")
end

function EasterEggReward:init(_rewardType, _eventInfo, _callback)
    if fwin:find("EasterEggRewardClass") ~= nil then
        fwin:close(fwin:find("EasterEggRewardClass"))
    end
    self._rewardType = _rewardType
    self._eventInfo = _eventInfo
    self._callback = _callback

    if fwin:find("HeroStorageClass") ~= nil then
        state_machine.unlock("sm_hero_seat_open_synthesis", 0, "")
        state_machine.excute("hero_list_view_update_cell_lock_synthesis", 0, false)
    end
end
