-----------------------------
--宝石雕刻选择
-----------------------------
FateChoose = class("FateChooseClass", Window)
--打开界面
local fate_choose_window_open_terminal = {
	_name = "fate_choose_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)	
		if fwin:find("FateChooseClass") == nil then
			local cell = params._datas.cell
			fwin:open(FateChoose:new():init(cell),fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local fate_choose_window_close_terminal = {
	_name = "fate_choose_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FateChooseClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(fate_choose_window_open_terminal)
state_machine.add(fate_choose_window_close_terminal)
state_machine.init()

function FateChoose:ctor()
	self.super:ctor()
	self.roots = {}

    -- load lua file
    app.load("client.red_alert.cells.fate.fate_choose_cell")

    --var
    --选择列表
	self.select_page_index = nil
	
    -- Initialize Fate machine.
    local function init_fate_choose_terminal()
 		--确认选择
        local fate_choose_sure_terminal = {
            _name = "fate_choose_sure",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.excute("fate_cell_change_select_gems_type",0,{self.cell,self.select_page_index})
            	state_machine.excute("fate_choose_window_close",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

 		--改变选择
        local fate_choose_change_select_page_terminal = {
            _name = "fate_choose_change_select_page",
            _init = function (terminal)
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance.select_page_index = params
            	instance:setSelect()
            	-- print("===============",instance.select_page_index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fate_choose_sure_terminal)
        state_machine.add(fate_choose_change_select_page_terminal)
        state_machine.init()
    end

    -- call func init fate machine.
    init_fate_choose_terminal()
end

--刷新列表
function FateChoose:onUpdateDraw()
	local root = self.roots[1]
	local Listview_fate_choose = ccui.Helper:seekWidgetByName(root,"Listview_fate_choose")     --雕刻选择列表
	Listview_fate_choose:removeAllChildren(true)
    local param = dms.string(dms["major_city_config"],2,major_city_config.param)
    param = zstring.split(param,"|")
    param = zstring.split(param[tonumber(_ED.now_week_day)+1],",")

    for i,v in pairs(param) do
    	local magic_beg_id = tonumber(v)
		local drop_show = dms.string(dms["magic_beg"],magic_beg_id,magic_beg.drop_show)           --掉落显示
	    local ship_mould_id = dms.string(dms["magic_beg"],magic_beg_id,magic_beg.ship_mould_id)   --掉落显示的英雄像
	    local cell = state_machine.excute("fate_choose_create_cell",0,{magic_beg_id,i,self.select_page_index})
	    Listview_fate_choose:addChild(cell)
    end
end

--设置选择
function FateChoose:setSelect()
	local root = self.roots[1]
	local Listview_fate_choose = ccui.Helper:seekWidgetByName(root,"Listview_fate_choose")
	for i,cell in pairs(Listview_fate_choose:getItems()) do
		cell.select_page_index = self.select_page_index
		if cell ~= nil and cell.setSelect ~= nil then
			cell:setSelect()
		end
	end
end

function FateChoose:init(cell)
	self.cell = cell
	self.select_page_index = cell.select_page_index
	self:onInit()
    return self
end

--初始化界面
function FateChoose:onInit()
    local csbItem = csb.createNode(config_csb.fate.fate_choose)
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    --确认选择
  	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_make_sure"), nil, 
    {
        terminal_name = "fate_choose_sure", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,0)
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_altar_choose"), nil, 
    {
        terminal_name = "fate_choose_window_close", 
        terminal_state = 0,
    },
    nil,0)
    self:onUpdateDraw()
end

function FateChoose:onEnterTransitionFinish()
    
end

--移除状态机
function FateChoose:onExit()
	state_machine.remove("fate_choose_sure")
    state_machine.remove("fate_choose_change_select_page")
end

