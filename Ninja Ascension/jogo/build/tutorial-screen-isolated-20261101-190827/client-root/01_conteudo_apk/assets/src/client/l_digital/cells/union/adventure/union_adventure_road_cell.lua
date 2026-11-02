-- ----------------------------------------------------------------------------------------------------
-- 说明：工会大冒险立柱的控件
-------------------------------------------------------------------------------------------------------

UnionAdventureRoadCell = class("UnionAdventureRoadCellClass", Window)
UnionAdventureRoadCell.__size = nil

local union_adventure_road_cell_creat_terminal = {
    _name = "union_adventure_road_cell_creat",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = UnionAdventureRoadCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_adventure_road_cell_creat_terminal)
state_machine.init()

    
function UnionAdventureRoadCell:ctor()
    self.super:ctor()
    self.roots = {}
	self._index = 0
	self.reward_type = 0
    local function init_union_adventure_road_cell_terminal()
	
		local union_adventure_road_cell_updata_terminal = {
            _name = "union_adventure_road_cell_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local cell = params._datas._cell
				cell:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_adventure_road_cell_show_stick_terminal = {
            _name = "union_adventure_road_cell_show_stick",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params[1]
                local is_show = params[2]
                if cell._stick ~= nil then
                    cell._stick:setVisible(is_show)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(union_adventure_road_cell_updata_terminal)
        state_machine.add(union_adventure_road_cell_show_stick_terminal)
        state_machine.init()
    end

    init_union_adventure_road_cell_terminal()
end


function UnionAdventureRoadCell:onUpdateDraw()
	local root = self.roots[1]
	
    local Panel_21 = ccui.Helper:seekWidgetByName(root, "Panel_21")
    if Panel_21:getChildByTag(100) ~= nil then
        Panel_21:removeChildByTag(100)
    end
    local Image_road = ccui.Helper:seekWidgetByName(root, "Image_road")
    for i=1,3 do
        local Panel_reward_type = ccui.Helper:seekWidgetByName(root, "Panel_reward_type_"..i)
        Panel_reward_type:setVisible(false)
    end
    local Panel_wanmei = ccui.Helper:seekWidgetByName(root, "Panel_wanmei")
    Panel_wanmei:setVisible(false)
    local Panel_huode = ccui.Helper:seekWidgetByName(root, "Panel_huode")
    Panel_huode:setVisible(false)

    --添加棍子
    local stick = state_machine.excute("union_adventure_stick_cell_creat", 0, "0")
    stick:setTag(100)
    Panel_21:addChild(stick)
    self._stick = stick
    if self.initial_width ~= nil and tonumber(self.m_type) == 1 then
        Image_road:setContentSize(cc.size(tonumber(self.initial_width),Image_road:getContentSize().height))
        stick:setVisible(true)
    else
        local step_range = zstring.split(dms.string(dms["union_adventure_reward"], self.current_layer, union_adventure_reward.step_range),",")
        Image_road:setContentSize(cc.size(math.random(tonumber(step_range[1]),tonumber(step_range[2]))*Image_road._w,Image_road:getContentSize().height))
        stick:setVisible(false)
        local reward = zstring.split(dms.string(dms["union_adventure_reward"], self.current_layer, union_adventure_reward.reward),",")
        if tonumber(reward[1]) == 1 then
            ccui.Helper:seekWidgetByName(root, "Panel_reward_type_1"):setVisible(true)
        elseif tonumber(reward[1]) == 2 then
            ccui.Helper:seekWidgetByName(root, "Panel_reward_type_2"):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root, "Panel_reward_type_3"):setVisible(true)
        end
        local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
        Text_number:setString("x"..reward[3])

    end
    stick:setPositionX(Image_road:getPositionX()+Image_road:getContentSize().width/2)
    stick:setPositionY(ccui.Helper:seekWidgetByName(root, "Image_center"):getPositionY())

    self.stick = stick
end

function UnionAdventureRoadCell:onEnterTransitionFinish()

end

function UnionAdventureRoadCell:onInit()
	local root = cacher.createUIRef("legion/sm_legion_adventure_road.csb", "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
	if UnionAdventureRoadCell.__size == nil then
		UnionAdventureRoadCell.__size = root:getContentSize()
	end
    local Image_road = ccui.Helper:seekWidgetByName(root, "Image_road")
    if Image_road._w == nil then
        Image_road._w = Image_road:getContentSize().width
    end
    Image_road:setContentSize(cc.size(Image_road._w,Image_road:getContentSize().height))
	
	--领取
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_reward_bg"), nil, 
 --    {
 --        terminal_name = "union_adventure_road_cell_reward_request", 
 --        terminal_state = 0, 
 --        cells = self,
 --    }, nil, 1)
	
	self:onUpdateDraw()
end

function UnionAdventureRoadCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef("legion/sm_legion_adventure_road.csb", root)
end

function UnionAdventureRoadCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionAdventureRoadCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef("legion/sm_legion_adventure_road.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

function UnionAdventureRoadCell:clearUIInfo( ... )
    local root = self.roots[1]

end

function UnionAdventureRoadCell:init(params)
    self.m_type = params[1]
    self.initial_width = params[2] or nil
    self.current_layer = params[3] or nil
	self:onInit()
	self:setContentSize(UnionAdventureRoadCell.__size)
    return self
end

-- 重新绘制奖励
function UnionAdventureRoadCell:resetData(nLevel)
    self.current_layer = nLevel

    local root = self.roots[1]

    local step_range = zstring.split(dms.string(dms["union_adventure_reward"], self.current_layer, union_adventure_reward.step_range),",")
    local Image_road = ccui.Helper:seekWidgetByName(root, "Image_road")
    Image_road:setContentSize(cc.size(math.random(tonumber(step_range[1]),tonumber(step_range[2]))*Image_road._w,Image_road:getContentSize().height))

    ccui.Helper:seekWidgetByName(root, "Panel_reward_type_1"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Panel_reward_type_2"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Panel_reward_type_3"):setVisible(false)

    local reward = zstring.split(dms.string(dms["union_adventure_reward"], self.current_layer, union_adventure_reward.reward),",")

    if tonumber(reward[1]) == 1 then
        ccui.Helper:seekWidgetByName(root, "Panel_reward_type_1"):setVisible(true)
    elseif tonumber(reward[1]) == 2 then
        ccui.Helper:seekWidgetByName(root, "Panel_reward_type_2"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root, "Panel_reward_type_3"):setVisible(true)
    end
    local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
    Text_number:setString("x"..reward[3])

    if self.stick then
        self.stick:setPositionX(Image_road:getPositionX()+Image_road:getContentSize().width/2)
    end
end
