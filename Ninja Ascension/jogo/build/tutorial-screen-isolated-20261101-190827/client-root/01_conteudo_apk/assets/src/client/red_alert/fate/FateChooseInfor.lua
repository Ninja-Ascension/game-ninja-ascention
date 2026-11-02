-----------------------------
--浮动详细信息
-----------------------------
FateChooseInfo = class("FateChooseInfoClass", Window)
FateChooseInfo.__size = nil

--打开浮动信息
local fate_choose_info_window_open_terminal = {
    _name = "fate_choose_info_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("FateChooseInfoClass") then
        	local prop = params[1]
        	local pos = params[2]
            fwin:open(FateChooseInfo:new():init(prop,pos), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭浮动信息
local fate_choose_info_window_close_terminal = {
    _name = "fate_choose_info_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FateChooseInfoClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fate_choose_info_window_open_terminal)
state_machine.add(fate_choose_info_window_close_terminal)
state_machine.init()

function FateChooseInfo:ctor()
    self.super:ctor()
    self.roots = {}
   
end

function FateChooseInfo:onUpdateDraw()
    local root = self.roots[1]
    local Text_altar_choose_name = ccui.Helper:seekWidgetByName(root,"Text_altar_choose_name")              --宝石名字
    Text_altar_choose_name:setString(self.prop.name)
    local Text_altar_choose_infor_stye = ccui.Helper:seekWidgetByName(root,"Text_altar_choose_infor_stye")  --宝石描述
    Text_altar_choose_infor_stye:setString(self.prop.dec)

    local Panel_gem_box = ccui.Helper:seekWidgetByName(root,"Panel_gem_box")                                --宝石图标
    Panel_gem_box:removeAllChildren(true)
    local data = {
		item_value = 1,
    	prop_type = 34,
    	prop_item = self.prop.prop_item,
	}
    local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
    Panel_gem_box:addChild(cell)
end

function FateChooseInfo:onEnterTransitionFinish()

end

--初始化界面
function FateChooseInfo:onInit( )
    local csbItem = csb.createNode(config_csb.fate.fate_choose_infor)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    if FateChooseInfo.__size == nil then
        FateChooseInfo.__size = root:getContentSize()
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_fate_infor"), nil, 
    {
        terminal_name = "fate_choose_info_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()	

end
--设置位置
function FateChooseInfo:init(prop,pos)
    self.prop = prop
	self:onInit()
    self:setContentSize(FateChooseInfo.__size)
    local x = math.max(pos.x/ app.scaleFactor,0)
    x = math.min(x,(fwin._width - FateChooseInfo.__size.width))
    local y = math.max(0,pos.y/ app.scaleFactor)
    y = math.min(y,(fwin._height - FateChooseInfo.__size.height))
    self:setPosition(cc.p(x,y))
    return self
end

function FateChooseInfo:onExit()

end
