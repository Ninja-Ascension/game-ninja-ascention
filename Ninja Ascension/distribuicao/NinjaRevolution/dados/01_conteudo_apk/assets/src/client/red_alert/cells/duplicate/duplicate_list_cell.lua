--------------------------------------------------------------------------------------------------------------
--  说明：副本单个控件项
--------------------------------------------------------------------------------------------------------------
DuplicateListCell = class("DuplicateListCellClass", Window)
DuplicateListCell.__size = nil

local duplicate_list_create_cell_terminal = {
    _name = "duplicate_list_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local from_type = params[1]
        local scenceID = params[2]
        local index = params[3]      
        local cell = DuplicateListCell:new()
        cell:init(from_type, scenceID,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(duplicate_list_create_cell_terminal)
state_machine.init()

function DuplicateListCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.from_type = nil  -- 1 简单 2普通  3困难
    self.index = nil
    self.scenceID = nil

    app.load("client.red_alert.duplicate.DuplicateMap")
    
	 -- Initialize duplicate_list_cell state machine.
    local function init_duplicate_list_cell_terminal()
		--进入副本地图
		local duplicate_list_cell_click_terminal = {
            _name = "duplicate_list_cell_click",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local scenceID = params._datas.cell.scenceID
                local from_type = params._datas.cell.from_type
                local npc_id = params._datas.cell.npc_id
                local index = params._datas.cell.index
                -- print("==========打开地图===",scenceID)
                local numbers_easy = 0
                local numbers_normal = 0
                local numbers_hard = 0
                for i, v in pairs(_ED.scene_current_state) do  
                    local _scene_type = dms.int(dms["pve_scene"], i, pve_scene.scene_type)
                    if _scene_type == 0 then
                        numbers_easy = numbers_easy + 1 
                        if tonumber(_ED.scene_current_state[i]) == -1 and i == scenceID then
                            local open_level = dms.int(dms["pve_scene"], scenceID, pve_scene.open_level) 
                            TipDlg.drawTextDailog(string.format(tipStringInfo_trialTower[31],open_level))
                            return false
                        end
                    elseif _scene_type == 1 then 
                        numbers_normal = numbers_normal + 1 
                        if tonumber(_ED.scene_current_state[i]) == -1 and i == scenceID then
                            TipDlg.drawTextDailog(string.format(tipStringInfo_trialTower[32],numbers_normal,numbers_normal-1 ))
                            return false
                        end
                    elseif _scene_type == 15 then 
                        numbers_hard = numbers_hard + 1 
                        if tonumber(_ED.scene_current_state[i]) == -1 and i == scenceID then
                            TipDlg.drawTextDailog(string.format(tipStringInfo_trialTower[33],40,numbers_hard,numbers_hard-1))
                            return false
                        end
                    end
                end
                state_machine.excute("duplicate_map_window_open",0,{_datas={_scenceID = scenceID,_from_type = from_type , _npc_id = npc_id, index = index}})
                state_machine.excute("duplicate_title_window_open",0,{_datas={_scenceID = scenceID,_from_type = from_type}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(duplicate_list_cell_click_terminal)
        state_machine.init()
    end
    
    -- call func DuplicateListCell create state machine.
    init_duplicate_list_cell_terminal()

end

function DuplicateListCell:updateDraw()
    local root = self.roots[1]
    local Panel_dup_sell_1 = ccui.Helper:seekWidgetByName(root,"Panel_dup_sell_1")
    local Panel_dup_sell_2 = ccui.Helper:seekWidgetByName(root,"Panel_dup_sell_2")
    local Panel_chapter_name_1 = ccui.Helper:seekWidgetByName(root,"Panel_chapter_name_1")
    local Panel_chapter_name_2 = ccui.Helper:seekWidgetByName(root,"Panel_chapter_name_2")
    local Panel_un_chapter_1 = ccui.Helper:seekWidgetByName(root,"Panel_un_chapter_1")
    local Panel_un_chapter_2 = ccui.Helper:seekWidgetByName(root,"Panel_un_chapter_2")
    local Panel_chapter_1 = ccui.Helper:seekWidgetByName(root,"Panel_chapter_1")
    local Panel_chapter_2 = ccui.Helper:seekWidgetByName(root,"Panel_chapter_2")
    local Sprite_1 = Panel_chapter_1:getChildByName("Sprite_1")
    local Sprite_2 = Panel_chapter_2:getChildByName("Sprite_2")
    Panel_dup_sell_1:setVisible(false)
    Panel_dup_sell_2:setVisible(false)
    Panel_un_chapter_1:setVisible(false)
    Panel_un_chapter_2:setVisible(false)

    display:ungray(Sprite_1)
    display:ungray(Sprite_2)

    local now_secne_id = 0
    if self.from_type == 1 then
        now_secne_id = _ED.easy_now_scene_id 
    elseif self.from_type == 2 then
        now_secne_id = _ED.normal_now_scene_id
    elseif self.from_type == 3 then
        now_secne_id = _ED.hard_now_scene_id
    end

    local scene_id = dms.int(dms["pve_scene"], self.scenceID, pve_scene.scene_id) 

    local button_name = "images/ui/pve_sn/duplicate_chapter/btn_chapter_"..scene_id..".png"
    local sprites = cc.Sprite:create(button_name)
    -- debug.print_r(_ED.scene_current_state)
    if self.index %2 ~= 0 then
        Panel_dup_sell_1:setVisible(true)
        Panel_chapter_name_1:removeBackGroundImage()
        Sprite_1:setTexture(button_name)
        Panel_chapter_name_1:setBackGroundImage("images/ui/pve_sn/duplicate_chapter_name/pve_chapter_name_"..scene_id..".png")
        
        if tonumber(now_secne_id) == self.scenceID then
            self:addCurrentLevel(Panel_chapter_name_1)
            Panel_un_chapter_1:setVisible(true)
        elseif tonumber(_ED.scene_current_state[self.scenceID]) == -1 then
            display:gray(Sprite_1)
        end
    else
        Panel_dup_sell_2:setVisible(true)
        Panel_chapter_name_2:removeBackGroundImage()
        Sprite_2:setTexture(button_name)
        Panel_chapter_name_2:setBackGroundImage("images/ui/pve_sn/duplicate_chapter_name/pve_chapter_name_"..scene_id..".png")
        if tonumber(now_secne_id) == self.scenceID then
            self:addCurrentLevel(Panel_chapter_name_2)
            Panel_un_chapter_2:setVisible(true)
        elseif tonumber(_ED.scene_current_state[self.scenceID]) == -1 then
            display:gray(Sprite_2)
        end
    end
    
    -- print("========scenceID",tonumber(_ED.scene_current_state[self.scenceID]),self.scenceID)
    
end


function DuplicateListCell:addCurrentLevel(panle)
    -- local cell = state_machine.excute("duplicate_current_level_create_cell",0,"")
    -- -- print("===========,打开箭头")
    -- local pos_y = cell:getPositionY()
    -- local height = panle:getContentSize().height
    -- cell:setPositionY(pos_y + height)
    -- panle:addChild(cell)
    -- print("-================",panle:getName())
end

function DuplicateListCell:onInit() 
    local root = cacher.createUIRef(config_csb.cells.duplicate.duplicate_list_cell,"root")
    self:addChild(root)    
    table.insert(self.roots, root) 

    if DuplicateListCell.__size == nil then
        local __size = root:getContentSize()
        DuplicateListCell.__size = __size
    end

    local Panel_dup_sell_1 = ccui.Helper:seekWidgetByName(root, "Panel_dup_sell_1")
    local Panel_dup_sell_2 = ccui.Helper:seekWidgetByName(root, "Panel_dup_sell_2")
    --进入副本地图页面
    fwin:addTouchEventListener(Panel_dup_sell_1, nil, 
    {
        terminal_name = "duplicate_list_cell_click", 
        terminal_state = 0,
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

        --进入副本地图页面
    fwin:addTouchEventListener(Panel_dup_sell_2, nil, 
    {
        terminal_name = "duplicate_list_cell_click", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
	self:updateDraw()
end

function DuplicateListCell:onEnterTransitionFinish()

end

function DuplicateListCell:init(from_type,scenceID,index)
    self.from_type = from_type
    self.scenceID = scenceID
    self.index = index
	self:onInit()
    self:setContentSize(DuplicateListCell.__size)
end

function DuplicateListCell:onExit()
    cacher.freeRef(config_csb.cells.duplicate.duplicate_list_cell, self.roots[1])
end