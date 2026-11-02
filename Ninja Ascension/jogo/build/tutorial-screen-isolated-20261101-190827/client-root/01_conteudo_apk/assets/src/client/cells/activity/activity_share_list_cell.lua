-- ----------------------------------------------------------------------------------------------------
-- 说明：分享活动列表控件 -- 
-- 创建时间：2015,11,8
-- 作者：杨晗
-- 修改记录：新建
-------------------------------------------------------------------------------------------------------

ActivityShareListCell= class("ActivityShareListCellClass", Window)
ActivityShareListCell.__size = nil
function ActivityShareListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.share_id = nil
    self.share_state = nil
    --初始状态机
    local function init_activity_list_cell_terminal()

        state_machine.init()
    end
    init_activity_list_cell_terminal() 
   -- call func init hom state machine.
end



function ActivityShareListCell:onEnterTransitionFinish()

end

function ActivityShareListCell:onInit()

    local root = cacher.createUIRef("activity/wonderful/share_weixin_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if ActivityShareListCell.__size == nil then
        local Image_11 = ccui.Helper:seekWidgetByName(root, "Image_11")
        local MySize = Image_11:getContentSize()
        ActivityShareListCell.__size = MySize
    end
    app.load("client.system.share.ShareCenter")
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_11_fenxiang"),nil, 
    {
        terminal_name = "shareCenter_to_getdata_and_open_share_dlg", 
        terminal_state = 0,
        share_id = self.share_id
    }
    ,nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12_lingqu"),nil, 
    {
        terminal_name = "shareCenter_to_getreward", 
        terminal_state = 0,
        share_id = self.share_id
    }
    ,nil, 0)
    
    self:initDraw()
end

function ActivityShareListCell:initDraw()
    local root = self.roots[1]
    local Panel_tubiao = ccui.Helper:seekWidgetByName(root,"Panel_tubiao")
    Panel_tubiao:removeAllChildren(true)

    app.load("client.cells.prop.prop_money_icon")
    local money_cell = propMoneyIcon:createCell()
    money_cell:init("2")
    Panel_tubiao:addChild(money_cell)

    local text_name = ccui.Helper:seekWidgetByName(root,"Text_fx_name")
    text_name:setString("")
    text_name:setString(share_text[self.share_id][2])
    local Text_jiangli = ccui.Helper:seekWidgetByName(root,"Text_jiangli")
    local rewardnumber = dms.int(dms["share_reward_mould"],self.share_id,share_reward_mould.need_jewel)
    Text_jiangli:setString(_All_tip_string_info._crystalName.." × " ..rewardnumber)

    local fenxiang = ccui.Helper:seekWidgetByName(root, "Button_11_fenxiang")
    local lingqu = ccui.Helper:seekWidgetByName(root, "Button_12_lingqu")
    local yilingqu = ccui.Helper:seekWidgetByName(root,"Image_13") 
    local weidacheng = ccui.Helper:seekWidgetByName(root,"Image_14")
    fenxiang:setVisible(false)
    lingqu:setVisible(false)
    yilingqu:setVisible(false)
    weidacheng:setVisible(false)
    -- local isopen = self:checkIsOpen() --现在由服务器去判断是否达成条件了
    --if isopen == false then
    --end
    if self.share_state == 0 then
        --未达成
        weidacheng:setVisible(true)
    elseif self.share_state == 1 then
         fenxiang:setVisible(true)
        --可以分享
    elseif self.share_state == 2 then
        --已分享--可以领取
        lingqu:setVisible(true)
    elseif self.share_state == 3 then
        --已领取
        yilingqu:setVisible(true)
    end

end

-- function ActivityShareListCell:checkIsOpen()
--     local share_id = self.share_id
--     local _type = dms.int(dms["share_reward_mould"],share_id,share_reward_mould.share_type)
--     local need = dms.int(dms["share_reward_mould"],share_id,share_reward_mould.need_value)
--     -- return self:checkTypeNeed(_type,need)
--     return true
-- end

-- function ActivityShareListCell:checkTypeNeed(_type , need)
--     local now_need = 0
--     if _type == 1 then
--         --等级
--         now_need = tonumber(_ED.user_info.user_grade)
--         if now_need >= need then
--             return true
--         end
--     elseif _type == 2 then
--         --副本
--         now_need = self:getOpenScene()
--         if now_need > need then
--             return true
--         end
--         self:getOpenScene()
--     elseif _type == 3 then
--         -- 竞技场排名 这里需要请求- -竞技场排名不是应该绑定到用户信息的吗
--         -- now_need = tonumber(_ED.arena_user_rank)
--         -- if now_need <= need then --越大越靠后
--         --     return true
--         -- end
--     elseif _type == 4 then
--         --橙色武将数量
--         for i, ship in pairs(_ED.user_ship) do
--             if ship.ship_id ~= nil then
--                 local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
--                 if dms.atoi(shipData, ship_mould.ship_type) >= 4 then
--                     now_need = now_need +1 --大于橙色武将的数量
--                 end
--             end
--         end
--         if now_need >= need then
--             return true
--         end
--     end
--     return false
-- end

-- function ActivityShareListCell:getOpenScene()
--     local sCount = 0  
--     local function getOpenSceneList()  
--         for i = 1,table.getn(_ED.scene_current_state) do
--             local _scene_type = dms.int(dms["pve_scene"], i, pve_scene.scene_type)
--                 if _ED.scene_current_state[i] == nil or _ED.scene_current_state[i] == "" then
--                     return
--                 end
--                 if tonumber(_ED.scene_current_state[i]) < 0 then
--                     -- 未开启章节
--                     sCount = sCount + 1
--                     return
--                 end
--                 sCount = sCount + 1
--         end
--     end
--     getOpenSceneList()
--     return sCount 
-- end
function ActivityShareListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ActivityShareListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef("activity/wonderful/share_weixin_list.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function ActivityShareListCell:init(share_id, share_state, index)
    self.share_id = tonumber(share_id)
    self.share_state = tonumber(share_state)
    if index ~= nil and index < 20 then --先临时设置20，活动窗口若是刷新，可以设置
        self:onInit()
    end
    self:setContentSize(ActivityShareListCell.__size)
    return self
end

function ActivityShareListCell:createCell()
    local cell = ActivityShareListCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end


function ActivityShareListCell:onExit()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef("activity/wonderful/share_weixin_list.csb", root)    
end

