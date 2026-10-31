--------------------------------------------------------------------------------------------------------------
--  运送军资战报
--------------------------------------------------------------------------------------------------------------
ShipMilitaryUseCell = class("ShipMilitaryUseCellClass", Window)
ShipMilitaryUseCell.__size = nil
--创建cell
local ship_military_use_create_cell_terminal = {
    _name = "ship_military_use_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local user_info = params[1]
        local cell = ShipMilitaryUseCell:new()
        cell:init(user_info)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(ship_military_use_create_cell_terminal)
state_machine.init()

function ShipMilitaryUseCell:ctor()
	self.super:ctor()
	self.roots = {}
    --var

    self._last_time = nil
    --运送马匹信息
    self.user_info = nil

     -- Initialize ship_military_use state machine.
    local function init_ship_military_use_cell_terminal()
        --掠夺界面
        local ship_military_use_cell_open_attack_terminal = {
            _name = "ship_military_use_cell_open_attack",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                state_machine.excute("ship_military_attack_window_open",0,{cell.user_info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        state_machine.add(ship_military_use_cell_open_attack_terminal)
        state_machine.init()
    end
    
    -- call func ship_military_use state machine.
    init_ship_military_use_cell_terminal()

end

function ShipMilitaryUseCell:updateDraw()
    local root = self.roots[1]
    -- user_id = 1,
    -- user_name = "yanghan",
    -- user_fight = "10000",
    -- user_level = 50,
    -- user_camp = math.random(1,3),
    -- user_sex = math.random(1,2),
    -- resource_quality = math.random(1,5),--军资品质
    -- ready_attack_times = math.random(0,2), -- 已经被掠夺次数
    local Text_ship_name = ccui.Helper:seekWidgetByName(root,"Text_ship_name")--名字
    local Panel_ship_fire = ccui.Helper:seekWidgetByName(root,"Panel_ship_fire") --点燃
    local Panel_ship_camp = ccui.Helper:seekWidgetByName(root,"Panel_ship_camp")--阵营
    local Panel_ship_pic = ccui.Helper:seekWidgetByName(root,"Panel_ship_pic")--船只动画
    local Panel_my_horse = ccui.Helper:seekWidgetByName(root,"Panel_my_horse")--我的马匹光效
    -- Panel_ship_pic:setBackGroundImage("images/ui/play/shipmilitaryuse/ship_pic_"..self.user_info.resource_quality .. ".png")
    Panel_ship_fire:setVisible(false)
    Panel_my_horse:setVisible(false)
    Text_ship_name:setString(self.user_info.user_name)
    if tonumber(self.user_info.ready_attack_times) > 0 then
        Panel_ship_fire:setVisible(true)
    else
        Panel_ship_fire:setVisible(false)
    end
    if self.user_info.user_id == _ED.user_info.user_id then
        Panel_my_horse:setVisible(true)
    end
    Panel_ship_camp:removeAllChildren(true)
    --阵营旗帜动画
    local jsonPath = "images/ui/effice/ship_camp/ship_camp_" .. self.user_info.user_camp .. ".json"
    local atlasPath = "images/ui/effice/ship_camp/ship_camp_" .. self.user_info.user_camp .. ".atlas"

    if cc.FileUtils:getInstance():isFileExist(jsonPath) == true then
        local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
        animation:setPosition(cc.p(Panel_ship_camp:getContentSize().width/2,Panel_ship_camp:getContentSize().height/2))
        Panel_ship_camp:addChild(animation)
    end
end

--船只动画
function ShipMilitaryUseCell:updateDrawShip()
    local root = self.roots[1]
    local Panel_ship_pic = ccui.Helper:seekWidgetByName(root,"Panel_ship_pic")--船只动画
    Panel_ship_pic:removeAllChildren(true)
    local jsonPath = "images/ui/effice/ship_pic/ship_pic_" .. self.user_info.resource_quality .. ".json"
    local atlasPath = "images/ui/effice/ship_pic/ship_pic_" .. self.user_info.resource_quality .. ".atlas"
    if cc.FileUtils:getInstance():isFileExist(jsonPath) == true then
        local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
        animation:setPosition(cc.p(Panel_ship_pic:getContentSize().width/2,Panel_ship_pic:getContentSize().height/2))
        Panel_ship_pic:addChild(animation)
    end
end

function ShipMilitaryUseCell:onUpdate()
    local now_time = os.time()
    if now_time - zstring.tonumber(self._last_time) >= 1 then
        local leave_time = self._transport_times - (now_time - _ED.transport_resouce_info.now_leave_time_os_times)
        if tonumber(self.user_info.user_id) == tonumber(_ED.user_info.user_id) then
            if leave_time <= 0 or tonumber(_ED.transport_resouce_info.is_transport) == 0 then
                self:setVisible(false)
            end
        else
            if leave_time <= 0 then
                self:setVisible(false)
                for k,v in pairs(_ED.transport_resouce_user_infos) do
                    if tonumber(v.user_id) == tonumber(self.user_info.user_id) then
                        table.remove(_ED.transport_resouce_user_infos, k, 1)
                        break
                    end
                end
            end
        end
        self._last_time = now_time
    end
end

function ShipMilitaryUseCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.campaign.shipmilitrayuse.ship_military_use_cell)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    if ShipMilitaryUseCell.__size == nil then
        ShipMilitaryUseCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_ship_pic"), nil, 
    {
        terminal_name = "ship_military_use_cell_open_attack", 
        terminal_state = 0, 
        cell = self,
    }, nil, 0)  
        
   
	self:updateDraw()
    self:updateDrawShip()
end

function ShipMilitaryUseCell:onEnterTransitionFinish()

end

function ShipMilitaryUseCell:init(user_info)
    self.user_info = user_info
    self._transport_times = dms.int(dms["ship_military_config"],7,ship_military_config.param)
	self:onInit()
    self:setContentSize(ShipMilitaryUseCell.__size)
end


function ShipMilitaryUseCell:onExit()
    state_machine.remove("ship_military_use_cell_open_attack")
end
