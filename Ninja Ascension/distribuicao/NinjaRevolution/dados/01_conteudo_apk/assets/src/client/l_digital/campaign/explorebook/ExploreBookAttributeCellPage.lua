----------------------------------------------------------------------------------------------------
-- 说明：探索图鉴单元项数据属性
----------------------------------------------------------------------------------------------------
ExploreBookAttributeCellPage = class("ExploreBookAttributeCellPageClass", Window)
ExploreBookAttributeCellPage.__size = nil

function ExploreBookAttributeCellPage:ctor()
    self.super:ctor()



    -- 定义封装类中的变量
    self.roots = {}     -- 界面中的UI根节点，供模块获取界面中的UI元素实例
    self.prop = nil     -- 当前要绘制的道具实例数据对对象
    self.actions = {}
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.l_digital.campaign.explorebook.ExploreBookWindow")
    app.load("client.l_digital.campaign.explorebook.ExploreBookListCell")
    app.load("client.l_digital.campaign.explorebook.ExploreBookAttributeCell")
    
    -- 初始化道具小图标事件响应需要使用的状态机
    local function init_Button_exploration_book_data_terminal()
        --刷新列表
        local Button_exploration_book_activation_refush_terminal = {
            _name = "Button_exploration_book_activationl_refush",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = params.roots[1]
                local Image_sell_out = ccui.Helper:seekWidgetByName(root, "Image_sell_out")
                Image_sell_out:setVisible(true)
                Image_sell_out:setScale(2)
                Image_sell_out:runAction(cc.ScaleTo:create(0.1, 1))
                local show_group = nil
                if params.page == 2 then
                    show_group = _ED.secret_shop_init_info.goods_info[tonumber(params.index)]
                    params.prop.buy_times = 1 - tonumber(show_group.remain_times)
                elseif params.page == 3 then
                    show_group = _ED.arena_good[tonumber(params.index)]
                    params.prop.buy_times = tonumber(show_group.exchange_times)
                elseif params.page == 4 then
                    show_group = _ED.glories_shop_info[tonumber(params.index)]
                    params.prop.buy_times = tonumber(show_group.goods_exchange_times)
                elseif params.page == 5 then
                    show_group = _ED.union.union_shop_info.treasure.goods_info[tonumber(params.index)]
                    params.prop.buy_times = tonumber(show_group.remain_times)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(Button_exploration_book_activation_refush_terminal)
        state_machine.init()
    end
    init_Button_exploration_book_data_terminal()
end


function ExploreBookAttributeCellPage:onUpdateDraw()
    local root = self.roots[1]
    local book_name = dms.string(dms["explore_achievement_talent_mould"],self.page,9)
    local Panel_holy_right_icon = ccui.Helper:seekWidgetByName(root, "Panel_holy_right_icon")
    Panel_holy_right_icon:removeAllChildren(true)
    -- print("===========555555555555555==========")
    -- debug.print_r(book_name)

    local spriteImage = string.format("images/ui/talent_icon/talent_icon_%s.png", ""..book_name)
    local currSprite = cc.Sprite:create(spriteImage)
    currSprite:setAnchorPoint(0,0)
    Panel_holy_right_icon:addChild(currSprite)
end

function ExploreBookAttributeCellPage:onInit()
    local root = cacher.createUIRef("campaign/exploration/exploration_book_add_icon_cell.csb", "root")
    root:removeFromParent(false)
    self:addChild(root)
    table.insert(self.roots, root)
    
    -- local panel = ccui.Helper:seekWidgetByName(root, "Panel_5")
    local panel_size = root:getContentSize()
    self:onUpdateDraw()
    self:setContentSize(panel_size)
    if ExploreBookAttributeCellPage.__size == nil then
        ExploreBookAttributeCellPage.__size = panel_size
    end

    local Sprite_holy_right_icon_arrow_1 = root:getChildByName("Sprite_holy_right_icon_arrow_1")
    local Sprite_holy_right_icon_arrow_1_1 = root:getChildByName("Sprite_holy_right_icon_arrow_1_1")
    Sprite_holy_right_icon_arrow_1:setVisible(false)
    Sprite_holy_right_icon_arrow_1_1:setVisible(false)
end

function ExploreBookAttributeCellPage:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ExploreBookAttributeCellPage:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    --self:clearUIInfo()
    cacher.freeRef("campaign/exploration/exploration_book_add_icon_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function ExploreBookAttributeCellPage:clearUIInfo( ... )
    local root = self.roots[1]
    -- local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    -- local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
    -- local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
    -- local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    -- if Text_name ~= nil then
    --  Text_name:setString("")
    --  Text_5:setString("")
    --  Panel_6:removeAllChildren(true)
    --  Panel_icon:removeBackGroundImage()
    -- end
 --    local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
    -- if Image_1 ~= nil then
    --  Image_1:setVisible(false)
    -- end
end

function ExploreBookAttributeCellPage:onExit()
    --self:clearUIInfo()
    cacher.freeRef("campaign/exploration/exploration_book_add_icon_cell.csb", self.roots[1])
end

function ExploreBookAttributeCellPage:init(page,index)
    self.page = page
    self.index = index
    --print("=========999999999======",self.page,self.index)
    self:onInit()
    self:setContentSize(ExploreBookAttributeCellPage.__size)
end

function ExploreBookAttributeCellPage:createCell()
    local cell = ExploreBookAttributeCellPage:new()
    cell:registerOnNodeEvent(cell)
    return cell
end


