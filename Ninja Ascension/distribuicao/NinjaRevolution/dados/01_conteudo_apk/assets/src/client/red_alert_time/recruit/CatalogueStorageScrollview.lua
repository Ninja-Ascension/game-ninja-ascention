-- ----------------------------------------------------------------------------------------------------
-- 滚动层
-------------------------------------------------------------------------------------------------------
CatalogueStorageScrollview = class("CatalogueStorageScrollviewClass", Window)

--打开将星录
local catalogue_storage_scrollview_window_open_terminal = {
    _name = "catalogue_storage_scrollview_window_open",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = CatalogueStorageScrollview:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(catalogue_storage_scrollview_window_open_terminal)
state_machine.init()

function CatalogueStorageScrollview:ctor()
    self.super:ctor()
    self.roots = {}
    self.action = nil
    
    self._page_index = 1

    self._scroll_view = nil
    
    --load lua file 
    app.load("client.red_alert_time.cells.hero.hero_icon_cell")
  --   local function init_catalogue_storage_terminal()

        
        -- local catalogue_storage_to_four_terminal = {
  --           _name = "catalogue_storage_to_four",
  --           _init = function (terminal) 
                
  --           end,
  --           _inited = false,
  --           _instance = self,
  --           _state = 0,
  --           _invoke = function(terminal, instance, params)
  --            ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_1"):setVisible(false)
        --      ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_2"):setVisible(false)
        --      ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_3"):setVisible(false)
        --      ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_4"):setVisible(true)
        --      instance:onUpdateDrawFour()
        --      return true
  --           end,
  --           _terminal = nil,
  --           _terminals = nil
  --       }

  --       state_machine.add(catalogue_storage_to_four_terminal)
  --       state_machine.init()
  --   end
    
  --   init_catalogue_storage_terminal()
end

function CatalogueStorageScrollview:onEnterTransitionFinish()


end

function CatalogueStorageScrollview:onUpdateDraw()
    local root = self.roots[1]
    local ScrollView_catalogue_storage = ccui.Helper:seekWidgetByName(root,"ScrollView_catalogue_storage")
    ScrollView_catalogue_storage:removeAllChildren(true)
    self._scroll_view = ScrollView_catalogue_storage
    local width = ScrollView_catalogue_storage:getContentSize().width
    local height = ScrollView_catalogue_storage:getContentSize().height
    local scroll_height = 0
    local index = 0
    local line_max_count = 6
    local cell_temp = state_machine.excute("packs_icon_bg_create_cell",0,"")
    local cell_height = cell_temp:getContentSize().height + 8
    if _ED.catalogue_storage_datas == nil or table.nums(_ED.catalogue_storage_datas) == 0 then
        initCatalogueStorageDatas()
    end
    for i = 1,10000 do
        local v = _ED.catalogue_storage_datas[self._page_index][i]
        index = index + 1
        local wight_n = 1
        local height_n = 1
        if i % line_max_count == 0 then
            wight_n = line_max_count
        else
            wight_n = i % line_max_count
        end
        if v == nil then
            break
        end
    end
    if index % line_max_count == 0 then
        scroll_height = index / line_max_count
    else
        scroll_height = math.floor(index / line_max_count) + 1
    end

    if scroll_height*cell_height > height then
        height = scroll_height*cell_height
    end

    for i = 1,10000 do
        local v = _ED.catalogue_storage_datas[self._page_index][i]
        local wight_n = 1
        local height_n = 1
        if i % line_max_count == 0 then
            wight_n = line_max_count
        else
            wight_n = i % line_max_count
        end

        if i % line_max_count == 0 then
            height_n = i / line_max_count
        else
            height_n = math.floor(i / line_max_count) + 1
        end
        if v == nil then
            break
        end
        local cell = state_machine.excute("hero_icon_create_cell",0,{v.ship_mould_id,7,height_n,true})
        cell:setAnchorPoint(cc.p(0,1))
        cell:setPosition(cc.p((wight_n-1)*(width/line_max_count),height - (height_n-1)*cell_height))
        ScrollView_catalogue_storage:addChild(cell)
        
        if self._page_index == 1 and i == 1 then
           state_machine.excute("hero_icon_cell_click_head",0,{_datas = {cell = cell,from_type = 7}})
        end
    end


    ScrollView_catalogue_storage:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_catalogue_storage:jumpToTop()

    self.scroll_view = ScrollView_catalogue_storage
    self.scroll_view_poy = ScrollView_catalogue_storage:getInnerContainer():getPositionY()
end


function CatalogueStorageScrollview:onUpdate(dt) 
    if self.scroll_view ~= nil then
        local size = self.scroll_view:getContentSize()
        local posY = self.scroll_view:getInnerContainer():getPositionY()
        if self.scroll_view_poy == posY then
            return
        end
        self.scroll_view_poy = posY
        local items = self.scroll_view:getChildren()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function CatalogueStorageScrollview:onInit()
    local csbItem = csb.createNode(config_csb.recruit.catalogue_storage_scrollview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw()
end

function CatalogueStorageScrollview:init(params)
    local rootWindow = params[1]
    self._page_index = params[2]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function CatalogueStorageScrollview:onExit()

end