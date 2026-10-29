-----------------------------
-- 天赋图标
-----------------------------
SmTalentCell = class("SmTalentCellClass", Window)
SmTalentCell.__size = nil
--打开界面
local sm_talent_cell_creat_terminal = {
	_name = "sm_talent_cell_creat",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local cell = SmTalentCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_talent_cell_creat_terminal)
state_machine.init()

function SmTalentCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.page_index = 0
    self.index = 0
    self.talent_id = 0
    self.islock = false
    
    local function init_sm_talent_cell_terminal()
		local sm_talent_cell_show_info_terminal = {
            _name = "sm_talent_cell_show_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
				state_machine.excute("sm_talent_detail_info_open",0,{cell.talent_id ,cell.page_index ,cell.islock})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_talent_cell_show_info_terminal)
        state_machine.init()
    end
    init_sm_talent_cell_terminal()
end

function SmTalentCell:onUpdateDraw()
    local root = self.roots[1]
    local table_data = {}
    if self.page_index > 0 and self.page_index < 4 then
        local pageTalentOne = dms.int(dms["ship_talent_group"],self.page_index,ship_talent_group.first_mould)
        self.talent_id = pageTalentOne - 1 + self.index
        table_data = dms.element(dms["ship_talent_mould"] , self.talent_id)
    elseif self.page_index == 4 then
        table_data = dms.element(dms["ship_talent_mould"] , self.talent_id)
    end 
    --图标
    local Panel_tf_icon = ccui.Helper:seekWidgetByName(root,"Panel_tf_icon")
    Panel_tf_icon:removeAllChildren(true)
    local imageIndex = 0
    if self.page_index == 0 then
        imageIndex = dms.int(dms["ship_talent_group"],self.index,ship_talent_group.icon)
    else
        imageIndex = dms.atoi(table_data , ship_talent_mould.icon)
    end
    if imageIndex < 10 then
        imageIndex = "0"..imageIndex
    end
    local spriteImage = string.format("images/ui/talent_icon/talent_icon_%s.png", ""..imageIndex)
    local currSprite = cc.Sprite:create(spriteImage)
    currSprite:setAnchorPoint(0,0)
    Panel_tf_icon:addChild(currSprite) 
    if self.page_index == 0 then
        Panel_tf_icon:setTouchEnabled(false)
    else
        Panel_tf_icon:setTouchEnabled(true)
    end
    --等级
    local Text_lv = ccui.Helper:seekWidgetByName(root,"Text_lv")
    local Image_slot_2 = ccui.Helper:seekWidgetByName(root,"Image_slot_2") -- 满级图标
    local Image_slot_3 = ccui.Helper:seekWidgetByName(root,"Image_slot_3") -- 未满级图标
    Image_slot_2:setVisible(false)
    Image_slot_3:setVisible(false)
    Text_lv:setString("")
    
    local Panel_tf_bg = ccui.Helper:seekWidgetByName(root,"Panel_tf_bg")
    Panel_tf_bg:removeBackGroundImage()
    --锁
    local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock")
    local islock = false
    if self.page_index == 0 then
        islock = _ED.digital_talent_page_is_lock[self.index]
        if islock == true then
            Panel_tf_bg:setBackGroundImage("images/ui/quality/tf_bg_1.png")
        else
            Panel_tf_bg:setBackGroundImage("images/ui/quality/tf_bg_0.png")
        end
    else
        local lockString = dms.atos(table_data , ship_talent_mould.unlock_condition)
        if lockString == "3" then
            islock = _ED.digital_talent_page_is_lock[self.page_index]
        else
            if _ED.digital_talent_state_info == nil or _ED.digital_talent_state_info == "" then
                islock = true
            else
                local unLockData = zstring.split(lockString ,"|")
                for i , v in pairs(unLockData) do
                    local needData = zstring.split(v , ",")
                    if tonumber(needData[1]) == 1 then -- 等级判定
                        if tonumber(_ED.user_info.user_grade) < tonumber(needData[2]) then
                            islock = true
                            break
                        end
                    else
                        local needTalent = _ED.digital_talent_already_add[""..needData[2]]
                        if needTalent == nil then
                            islock = true
                        elseif tonumber(needTalent.level) < tonumber(needData[3]) then
                            islock = true
                        end
                    end
                end
            end
        end
        if islock == true then
            Panel_tf_bg:setBackGroundImage("images/ui/quality/tf_bg_1.png")
        else
            local maxLv = dms.atoi(table_data , ship_talent_mould.max_lv)
            local currLv = 0
            local currTalent = _ED.digital_talent_already_add[""..self.talent_id]
            if currTalent ~= nil then
                currLv = zstring.tonumber(currTalent.level)
            end
            if currLv < maxLv then
                Image_slot_3:setVisible(true)
                Text_lv:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
            else
                Image_slot_2:setVisible(true)
                Text_lv:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
            end
            Text_lv:setString(currLv.."/"..maxLv)
            if currLv == maxLv then
                Panel_tf_bg:setBackGroundImage("images/ui/quality/tf_bg_2.png")
            else
                Panel_tf_bg:setBackGroundImage("images/ui/quality/tf_bg_3.png")
            end
        end
    end

    if islock == true then
        display:gray(currSprite)
    else
        display:ungray(currSprite)
    end
    Image_lock:setVisible(islock)
    self.islock = islock
end

function SmTalentCell:init(params)
    self.page_index = tonumber(params[1])
    self.index = tonumber(params[2])
    self.talent_id = tonumber(params[3])
	self:onInit()
    self:setContentSize(SmTalentCell.__size)
    return self
end

function SmTalentCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_tf_icon = ccui.Helper:seekWidgetByName(root,"Panel_tf_icon")
    if Panel_tf_icon ~= nil then
        Panel_tf_icon:setTouchEnabled(true)
        Panel_tf_icon:removeAllChildren(true)
    end
end

function SmTalentCell:onInit()
    local root = cacher.createUIRef("cultivate/cultivate_talent_icon.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    if SmTalentCell.__size == nil then
        SmTalentCell.__size = root:getContentSize()
    end

    ccui.Helper:seekWidgetByName(root,"Panel_tf_icon"):setSwallowTouches(false)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_tf_icon"), nil, 
    {
        terminal_name = "sm_talent_cell_show_info", 
        terminal_state = 0, 
        cell = self,
    }, nil, 3)

	self:onUpdateDraw()
end

function SmTalentCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
    cacher.freeRef("cultivate/cultivate_talent_icon.csb", root)
end


