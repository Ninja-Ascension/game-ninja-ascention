-- ----------------------------------------------------------------------------------------------------
-- 说明：活动 / 分享
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivitySharePage = class("ActivitySharePageClass", Window)
    
function ActivitySharePage:ctor()
    self.super:ctor()
    self.roots = {}
    self.listview = nil
    self.listview_ContainerPosY = nil

    self.loaded = false
    -- Initialize ActivityDailySignIn state machine.
    local function init_ActivitySharePage_terminal()
		--界面刷新
        local activitysharepage_update_terminal = {
            _name = "activitysharepage_update",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance ~= nil and instance.roots ~= nil then
                    instance:onUpdateListDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(activitysharepage_update_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityDailySignIn state machine.
    init_ActivitySharePage_terminal()
end
function ActivitySharePage:onUpdateListDraw()
    local root = self.roots[1]
    local ListView_share = ccui.Helper:seekWidgetByName(root,"ListView_share")
    ListView_share:removeAllItems()
    ListView_share:requestRefreshView()
    self.listview = ListView_share
    app.load("client.cells.activity.activity_share_list_cell")
    local table_weidacheng = {}
    local table_kefengxiang = {}
    local table_kelingju = {}
    local table_yilingqu = {}
    -- for i =2, #_ED.user_share_info do
    --     local v = _ED.user_share_info[i]
    --     local cell = ActivityShareListCell:createCell()
    --     cell:init(v.shareId,v.shareStatus,i - 1)
    --     ListView_share:addChild(cell)
    -- end
    -- 排序
        for i =2, #_ED.user_share_info do
            local v = _ED.user_share_info[i]
            local state = tonumber(v.shareStatus)
            if state == 0 then --未达成
                table.insert(table_weidacheng,v)
            elseif state == 1 then --可分享
                table.insert(table_kefengxiang,v)            
            elseif state == 2 then --可领取
                table.insert(table_kelingju,v)            
            elseif state == 3 then --已领取
                table.insert(table_yilingqu,v)            
            end
        end
        local index = 1
        for i , v in pairs(table_kelingju) do
            local cell = ActivityShareListCell:createCell()
            cell:init(v.shareId,v.shareStatus,index)
            ListView_share:addChild(cell)
            index = index + 1
        end

        for i , v in pairs(table_kefengxiang) do
            local cell = ActivityShareListCell:createCell()
            cell:init(v.shareId,v.shareStatus,index)
            ListView_share:addChild(cell)
            index = index + 1
        end

        for i , v in pairs(table_weidacheng) do
            local cell = ActivityShareListCell:createCell()
            cell:init(v.shareId,v.shareStatus,index)
            ListView_share:addChild(cell)
            index = index + 1
        end

        for i , v in pairs(table_yilingqu) do
            local cell = ActivityShareListCell:createCell()
            cell:init(v.shareId,v.shareStatus,index)
            ListView_share:addChild(cell)
            index = index + 1
        end
    -- 排序
    self.listview_ContainerPosY = ListView_share:getInnerContainer():getPositionY()
end
function ActivitySharePage:onUpdate()
    -- 现在并没有用缓存，所以先屏蔽
    -- if self.listview ~= nil then
    --     local size = self.listview:getContentSize()
    --     local posY = self.listview:getInnerContainer():getPositionY()
    --     if self.listview_ContainerPosY == posY then
    --         return
    --     end
    --     self.listview_ContainerPosY = posY
    --     local items = self.listview:getItems()
    --     if items[1] == nil then
    --         return
    --     end
    --     local itemSize = items[1]:getContentSize()
    --     for i, v in pairs(items) do
    --         local tempY = v:getPositionY() + posY
    --         if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
    --             v:unload()
    --         else
    --             v:reload()
    --         end
    --     end
    -- end
end
function ActivitySharePage:lazy()
    if self.loaded == true then
        return
    end
    self.loaded = true
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
    self:onInit()
end

function ActivitySharePage:unload()
    self:removeAllChildren(true)
    self.loaded = false
    self.roots = {}
end

function ActivitySharePage:onInit()
    local csbActivitySharePage = csb.createNode("activity/wonderful/share_weixin.csb")
    local root = csbActivitySharePage:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbActivitySharePage)
    
    local function responseShareInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil then
                response.node:onUpdateListDraw()
            end
        end
    end
    NetworkManager:register(protocol_command.share_reward_init.code, nil, nil, nil, self, responseShareInitCallback, false, nil)
    --self:registerOnNoteUpdate(self,0.1)      
end

function ActivitySharePage:onEnterTransitionFinish()

end
function ActivitySharePage:init()
    -- self:onInit()
end
function ActivitySharePage:createCell()
    local cell = ActivitySharePage:new()
    cell:registerOnNodeEvent(cell)
    return cell  
end
function ActivitySharePage:onExit()
    state_machine.remove("activitysharepage_update")
end