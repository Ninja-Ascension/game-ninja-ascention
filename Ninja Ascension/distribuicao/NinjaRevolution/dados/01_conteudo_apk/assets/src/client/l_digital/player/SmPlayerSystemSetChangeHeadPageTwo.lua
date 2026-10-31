-- ----------------------------------------------------------------------------------------------------
-- 说明：数码系统修改头像page2
-------------------------------------------------------------------------------------------------------
SmPlayerSystemSetChangeHeadPageTwo = class("SmPlayerSystemSetChangeHeadPageTwoClass", Window)
local sm_player_system_set_change_head_page_two_open_terminal = {
    _name = "sm_player_system_set_change_head_page_two_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local page = SmPlayerSystemSetChangeHeadPageTwo:new():init()
        return page
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_player_system_set_change_head_page_two_open_terminal)
state_machine.init()
    
function SmPlayerSystemSetChangeHeadPageTwo:ctor()
    self.super:ctor()
    self.actions = {}
    self.roots = {}
    self.shipName = {}

    self._cell_group = nil
    self._cell_size = nil
    local function init_sm_player_system_set_change_head_terminal()
        --确定
        local sm_player_change_head_page_two_define_terminal = {
            _name = "sm_player_change_head_page_two_define",
            _init = function (terminal) 
                app.load("client.l_digital.player.SmPlayerHeadUnlockInfo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currHeadId = params._datas._headId
                local currName = params._datas._name
                state_machine.excute("sm_player_head_unlock_info_open",0,{currHeadId , currName})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_player_change_head_page_two_update_cells_terminal = {
            _name = "sm_player_change_head_page_two_update_cells",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateCells(params[1], params[2])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_player_change_head_page_two_define_terminal)
        state_machine.add(sm_player_change_head_page_two_update_cells_terminal)
        state_machine.init()
    end
    
    init_sm_player_system_set_change_head_terminal()
end

function SmPlayerSystemSetChangeHeadPageTwo:reloadHead(cell)
    if cell._button ~= nil then
        return
    end
    local layer = cell
    local pic = cell._pic
    local name = cell._name
    local layerSize = cell:getContentSize()

    local big_icon_path = nil
    if pic < 9 then
        big_icon_path = string.format("images/ui/home/head_%d.png", pic)
    else
        big_icon_path = string.format("images/ui/props/props_%d.png", pic)
    end 

    local ButtonHead = ccui.Button:create(big_icon_path,big_icon_path)
    ButtonHead:setAnchorPoint(cc.p(0.5,0.5))
    ButtonHead:setPosition(cc.p(layerSize.width / 2 , layerSize.height / 2))
    layer:addChild(ButtonHead,1)
    ButtonHead:setBright(false)

    local quality_path = ""
    if tonumber(_ED.vip_grade) > 0 then
        quality_path = "images/ui/quality/player_1.png"
    else
        quality_path = "images/ui/quality/player_2.png"
    end
    local SpritKuang = cc.Sprite:create(quality_path)
    SpritKuang:setAnchorPoint(cc.p(0.5,0.5))
    SpritKuang:setPosition(cc.p(layerSize.width / 2 , layerSize.height / 2))
    layer:addChild(SpritKuang,0)
    display:gray(SpritKuang)

    ButtonHead:setSwallowTouches(false)
    local function fourOpenTouchEvent(sender, eventType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        if eventType == ccui.TouchEventType.began then
            sender.isMoving = false
        elseif eventType == ccui.TouchEventType.moved then 
            sender.isMoving = true
        elseif eventType == ccui.TouchEventType.ended then 
            if math.abs(__spoint.y - __epoint.y) <= 3 then
                state_machine.excute("sm_player_change_head_page_two_define",0,{ _datas = { _headId = pic , _name = name }})
            end
        end
    end
    ButtonHead:addTouchEventListener(fourOpenTouchEvent)  

    layer._button = ButtonHead
end

function SmPlayerSystemSetChangeHeadPageTwo:drawHead( pic , name )
    --头像
    local layer = cc.Layer:create()
    -- local frameCache = cc.SpriteFrameCache:getInstance()
    -- frameCache:addSpriteFrames("images/ui/home/home.plist")
    layer:setContentSize(cc.size(120,100))
    local layerSize = layer:getContentSize()

    local big_icon_path = string.format("images/ui/props/props_%d.png", pic)
    if cc.FileUtils:getInstance():isFileExist(big_icon_path) == false then
        return false
    end
  
    layer._pic = pic
    layer._name = name
    return layer
end

function SmPlayerSystemSetChangeHeadPageTwo:onUpdataDraw()
    local root = self.roots[1]
    local Panel_head_2 = ccui.Helper:seekWidgetByName(root, "Panel_head_2")
    local Image_bg_2 = ccui.Helper:seekWidgetByName(root, "Image_bg_2")
    local Panel_222 = ccui.Helper:seekWidgetByName(root, "Panel_222")
    Panel_head_2:removeAllChildren(true)
    local cell_size = 0 
    local AllIndexGroup = {}
    self.shipName = {}
    local index = 0 
    local cell_group = {}
    for i = 1 ,56 do
        local evo_image = dms.string(dms["ship_mould"], i, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        local currStage = dms.int(dms["ship_mould"], i, ship_mould.captain_name)-1
        local ship = fundShipWidthTemplateId(i)
        if ship ~= nil then
            local ship_evo = zstring.split(ship.evolution_status, "|")
            currStage = tonumber(ship_evo[1])
        end

        --活动皮肤头像
        local get_skin = {}
        if ship and ship.ship_skin_info and ship.ship_skin_info ~= "" then
            local skin_info = zstring.split(ship.ship_skin_info, "|")
            for i,v in ipairs(zstring.split(skin_info[2], ",")) do
                local skin_id = zstring.split(v, ":")[1]
                local unlock_condition  = dms.int(dms["ship_skin_mould"], skin_id, ship_skin_mould.unlock_condition)
                local evo_id = dms.int(dms["ship_skin_mould"], skin_id, ship_skin_mould.ship_evo_id)
                local evo_pic_id = dms.int(dms["ship_evo_mould"], evo_id, ship_evo_mould.level_groun_icon)
                local activityPicIndex = dms.int(dms["ship_evo_mould"], evo_id, ship_evo_mould.form_id)
                local limit_time = zstring.split(v, ":")[2]
                -- local activity_time = zstring.tonumber(limit_time )/ 1000 - (_ED.system_time + (os.time() - _ED.native_time))
                -- local dayTime = math.ceil((activity_time ) / 86400)
                if unlock_condition == -1 and evo_pic_id == 5 and zstring.tonumber(limit_time) == -1 then
                    get_skin[evo_id] = true
                end
            end
        end

        local current_skin_evo_id = -1
        local skin_mould_rows = dms.searchs(dms["ship_skin_mould"], ship_skin_mould.ship_mould_id, i)
        if skin_mould_rows ~= nil then
            for i,v in ipairs(skin_mould_rows) do
                local unlock_condition  = dms.int(dms["ship_skin_mould"], v[1], ship_skin_mould.unlock_condition)
                if unlock_condition == -1 then
                    local avtivityEvoId = v[3]
                    local picIndex = dms.int(dms["ship_evo_mould"], avtivityEvoId, ship_evo_mould.form_id)
                    local shipNameId = dms.int(dms["ship_evo_mould"], avtivityEvoId, ship_evo_mould.name_index)
                    local evo_pic_id = dms.int(dms["ship_evo_mould"], avtivityEvoId, ship_evo_mould.level_groun_icon)
                    local word_info = dms.element(dms["word_mould"], shipNameId)
                    if not get_skin[tonumber(avtivityEvoId)] and picIndex ~= nil and evo_pic_id == 5 and word_info and current_skin_evo_id ~= tonumber(avtivityEvoId) then
                        table.insert(AllIndexGroup,picIndex)
                        table.insert(self.shipName,word_info[3])
                        local cell = self:drawHead(tonumber(picIndex) , word_info[3])
                        if cell ~= false then
                            Panel_head_2:addChild(cell)
                            if cell_size == 0 then
                                cell_size = cell:getContentSize()
                            end
                            current_skin_evo_id = tonumber(avtivityEvoId)
                            table.insert(cell_group , cell)
                            index = index + 1
                        end
                    end
                end
            end
        end

        for j = currStage + 1 , #evo_info do
            local isShow = true
            if dms.int(dms["ship_evo_mould"], evo_info[j], ship_evo_mould.level_groun_icon) == -1 then
                isShow = false
            end
            if isShow == true then
                local picIndex = dms.int(dms["ship_evo_mould"], evo_info[j], ship_evo_mould.form_id)
                local shipNameId = dms.int(dms["ship_evo_mould"], evo_info[j], ship_evo_mould.name_index)
                local word_info = dms.element(dms["word_mould"], shipNameId)
                if picIndex ~= nil then
                    table.insert(AllIndexGroup,picIndex)
                    table.insert(self.shipName,word_info[3])
                    local cell = self:drawHead(tonumber(picIndex) , word_info[3])
                    if cell ~= false then
                        Panel_head_2:addChild(cell)
                        if cell_size == 0 then
                            cell_size = cell:getContentSize()
                        end
                        table.insert(cell_group , cell)
                        index = index + 1
                    end
                end
            end
        end
    end
    if index > 0 then
        local height_n = math.ceil(index / 5)
        local total_height = height_n * cell_size.height + 20
        if total_height > Panel_head_2:getContentSize().height then
            local curr_height = total_height - Panel_head_2:getContentSize().height
            Panel_head_2:setContentSize(cc.size(Panel_head_2:getContentSize().width , total_height))
            Image_bg_2:setContentSize(cc.size(Image_bg_2:getContentSize().width , Image_bg_2:getContentSize().height + curr_height))
            Panel_222:setContentSize(cc.size(Panel_222:getContentSize().width , Panel_222:getContentSize().height + curr_height))
            root:setPositionY(curr_height)
        end
        for i , v in pairs(cell_group) do 
            v:setPosition(cc.p((i - 1) % 5 * cell_size.width , total_height - math.ceil(i / 5) * cell_size.height - 10))
        end
    end
    
    self:setContentSize(Panel_222:getContentSize())

    self._cell_group = cell_group
    self._cell_size = cell_size
end

function SmPlayerSystemSetChangeHeadPageTwo:updateCells(posY, size)
    if self._cell_group ~= nil then
        local items = self._cell_group
        local itemSize = self._cell_size
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                -- v:unload()
            else
                self:reloadHead(v)
            end
        end
    end
end


function SmPlayerSystemSetChangeHeadPageTwo:onInit()
    local csbUserInfo = csb.createNode("player/role_information_change_head_list_2.csb")
    self:addChild(csbUserInfo)
    local root = csbUserInfo:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdataDraw()
end

function SmPlayerSystemSetChangeHeadPageTwo:init()
    self:onInit()
    return self
end

function SmPlayerSystemSetChangeHeadPageTwo:onExit()
    state_machine.remove("sm_player_change_head_page_two_define")
    state_machine.remove("sm_player_change_head_page_two_update_cells")
end
