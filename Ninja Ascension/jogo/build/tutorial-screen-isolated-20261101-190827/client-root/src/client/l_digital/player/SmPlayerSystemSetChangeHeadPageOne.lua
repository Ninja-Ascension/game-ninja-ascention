-- ----------------------------------------------------------------------------------------------------
-- 说明：数码系统修改头像page1
-------------------------------------------------------------------------------------------------------
SmPlayerSystemSetChangeHeadPageOne = class("SmPlayerSystemSetChangeHeadPageOneClass", Window)
local sm_player_system_set_change_head_page_one_open_terminal = {
    _name = "sm_player_system_set_change_head_page_one_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local page = SmPlayerSystemSetChangeHeadPageOne:new():init()
        return page
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_player_system_set_change_head_page_one_open_terminal)
state_machine.init()
    
function SmPlayerSystemSetChangeHeadPageOne:ctor()
    self.super:ctor()
    self.actions = {}
    self.roots = {}

    self._cell_group = nil
    self._cell_size = nil
    local function init_sm_player_system_set_change_head_terminal()
        --确定
        local sm_player_change_head_page_one_define_terminal = {
            _name = "sm_player_change_head_page_one_define",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currHeadId = params._datas._headId
                if tonumber(_ED.user_info.user_head) == tonumber(currHeadId) then
                    state_machine.excute("sm_player_system_set_change_head_close",0,"sm_player_system_set_change_head_close.")
                    return
                end
                local function responseChangeNameCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        _ED.user_info.user_head = tonumber(currHeadId)
                        state_machine.excute("sm_player_infomation_page_updata_head",0,"sm_player_infomation_page_updata_head.")                        
                        state_machine.excute("user_information_update_head",0,"user_information_update_head.")
                        if fwin:find("ArenaClass") ~= nil then
                            state_machine.excute("arena_update_user_pic",0,"arena_update_user_pic.")
                        end
                        state_machine.excute("sm_player_system_set_change_head_close",0,"sm_player_system_set_change_head_close.")
                    end
                end
                protocol_command.user_info_modify.param_list = "1".."\r\n"..currHeadId
                NetworkManager:register(protocol_command.user_info_modify.code, nil, nil, nil, instance, responseChangeNameCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_player_change_head_page_one_update_cells_terminal = {
            _name = "sm_player_change_head_page_one_update_cells",
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

        state_machine.add(sm_player_change_head_page_one_define_terminal)
        state_machine.add(sm_player_change_head_page_one_update_cells_terminal)
        state_machine.init()
    end
    
    init_sm_player_system_set_change_head_terminal()
end

function SmPlayerSystemSetChangeHeadPageOne:reloadHead(cell)
    if cell._button ~= nil then
        return
    end
    local layer = cell
    local pic = cell._pic
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

    ButtonHead:setSwallowTouches(false)
    local function fourOpenTouchEvent(sender, eventType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        if eventType == ccui.TouchEventType.began then
            -- sender.isMoving = false
        elseif eventType == ccui.TouchEventType.moved then 
            -- sender.isMoving = true
        elseif eventType == ccui.TouchEventType.ended then 
            -- if sender.isMoving == false then
            if math.abs(__spoint.y - __epoint.y) <= 3 then
                state_machine.excute("sm_player_change_head_page_one_define",0,{ _datas = { _headId = pic }})
            end
            -- end
        end
    end
    ButtonHead:addTouchEventListener(fourOpenTouchEvent)  
    layer._button = ButtonHead  
end

function SmPlayerSystemSetChangeHeadPageOne:drawHead( pic )
    --头像
    -- cc.Director:getInstance():getTextureCache():addImage("images/ui/home/home.png")
    -- cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/home/home.plist")
    local layer = cc.Layer:create()
    -- local frameCache = cc.SpriteFrameCache:getInstance()
    -- frameCache:addSpriteFrames("images/ui/home/home.plist")
    layer:setContentSize(cc.size(120,100))
    local layerSize = layer:getContentSize()

    local big_icon_path = nil
    if pic < 9 then
        big_icon_path = string.format("images/ui/home/head_%d.png", pic)
    else
        big_icon_path = string.format("images/ui/props/props_%d.png", pic)
    end 
    if cc.FileUtils:getInstance():isFileExist(big_icon_path) == false then
        return false
    end

    layer._pic = pic 
    return layer
    -- Panel_kuang:setBackGroundImage(quality_path , 1)
    -- Panel_head:setBackGroundImage(big_icon_path)

    --return roots
end

function SmPlayerSystemSetChangeHeadPageOne:updateCells(posY, size)
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

function SmPlayerSystemSetChangeHeadPageOne:onUpdataDraw()
    local root = self.roots[1]
    local Panel_head_1 = ccui.Helper:seekWidgetByName(root, "Panel_head_1")
    local Image_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_bg_1")
    local Panel_221 = ccui.Helper:seekWidgetByName(root, "Panel_221")
    Panel_head_1:removeAllChildren(true)
    local cell_size = 0 
    local AllIndexGroup = zstring.split(dms.string(dms["user_config"], 15 ,user_config.param), ",")

    for i, v in pairs(_ED.user_ship) do
        local evo_image = dms.string(dms["ship_mould"], tonumber(v.ship_template_id), ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        local ship_evo = zstring.split(v.evolution_status, "|")
        for j = 1 , tonumber(ship_evo[1]) do
            if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                local level_groun_iconIndex = dms.int(dms["ship_evo_mould"], evo_info[j], ship_evo_mould.level_groun_icon)
                if level_groun_iconIndex == -1 then
                else    
                    local picIndex = dms.int(dms["ship_evo_mould"], evo_info[j], ship_evo_mould.form_id)
                    if picIndex ~= nil then
                        table.insert(AllIndexGroup,picIndex)
                    end
                end
            else
                local picIndex = dms.int(dms["ship_evo_mould"], evo_info[j], ship_evo_mould.form_id)
                if picIndex ~= nil then
                    table.insert(AllIndexGroup,picIndex)
                end
            end
        end

        --活动皮肤头像
        if v.ship_skin_info and v.ship_skin_info ~= "" then
            local skin_info = zstring.split(v.ship_skin_info, "|")
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
                    table.insert(AllIndexGroup, activityPicIndex)
                end
            end
        end
    end
    local cell_group = {}
    local index = 0 

    local tempAllIndexGroup = {}

    for i, v in pairs(AllIndexGroup) do
        if not tempAllIndexGroup[v] then
            local cell = self:drawHead(tonumber(v))
            if cell ~= false then
                Panel_head_1:addChild(cell)
                if cell_size == 0 then
                    cell_size = cell:getContentSize()
                end
                table.insert(cell_group , cell)
                index = index + 1

                tempAllIndexGroup[v] = true
            end
        end
    end
    local height_n = math.ceil(index / 5)
    local total_height = height_n * cell_size.height + 20
    if total_height > Panel_head_1:getContentSize().height then
        local curr_height = total_height - Panel_head_1:getContentSize().height
        Panel_head_1:setContentSize(cc.size(Panel_head_1:getContentSize().width , total_height))
        Image_bg_1:setContentSize(cc.size(Image_bg_1:getContentSize().width , Image_bg_1:getContentSize().height + curr_height))
        Panel_221:setContentSize(cc.size(Panel_221:getContentSize().width , Panel_221:getContentSize().height + curr_height))
        root:setPositionY(curr_height)
    end
    for i , v in pairs(cell_group) do 
        v:setPosition(cc.p((i - 1) % 5 * cell_size.width , total_height - math.ceil(i / 5) * cell_size.height - 10))
    end
    self:setContentSize(Panel_221:getContentSize())

    self._cell_group = cell_group
    self._cell_size = cell_size
end


function SmPlayerSystemSetChangeHeadPageOne:onInit()
    local csbUserInfo = csb.createNode("player/role_information_change_head_list_1.csb")
    self:addChild(csbUserInfo)
    local root = csbUserInfo:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdataDraw()
end

function SmPlayerSystemSetChangeHeadPageOne:init()
    self:onInit()
    return self
end

function SmPlayerSystemSetChangeHeadPageOne:onExit()
    state_machine.remove("sm_player_change_head_page_one_define")
    state_machine.remove("sm_player_change_head_page_one_update_cells")
end
