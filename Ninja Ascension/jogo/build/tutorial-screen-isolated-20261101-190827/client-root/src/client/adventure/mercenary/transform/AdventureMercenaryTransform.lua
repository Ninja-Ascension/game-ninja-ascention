-- ----------------------------------------------------------------------------------------------------
-- 说明：灵力转换
-------------------------------------------------------------------------------------------------------
AdventureMercenaryTransform = class("AdventureMercenaryTransformClass", Window)
    
function AdventureMercenaryTransform:ctor()
    self.super:ctor()
    self.roots = {}
	self.choice = nil
	app.load("client.adventure.mercenary.transform.AdventureMercenaryTransformChoice")
	app.load("client.adventure.mercenary.transform.AdventureMercenaryTransformServants")
	app.load("client.adventure.mercenary.transform.AdventureMercenaryTransformTheMain")
    app.load("client.adventure.mercenary.transform.AdventureMercenaryTransformConfirm")
	
	self.heroServants = nil
	self.heroThemain = nil
	self.shoWtypes = nil
	self.cells = nil
    self.consumeNum = nil
    -- Initialize adventure mercenary transform state machine.
    local function init_adventure_mercenary_transform_terminal()
		local adventure_mercenary_transform_open_choice_servants_terminal = {
            _name = "adventure_mercenary_transform_open_choice_servants",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureMercenaryTransformChoice:new():init(params._datas.types, 1), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_mercenary_transform_update_servants_terminal = {
            _name = "adventure_mercenary_transform_update_servants",
            _init = function (terminal)
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.heroServants = params
				instance:onUpdateServants(params)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_mercenary_transform_update_themain_terminal = {
            _name = "adventure_mercenary_transform_update_themain",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.heroThemain = params
				instance:onUpdateTerminal(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_mercenary_transform_confirm_ok_terminal = {
            _name = "adventure_mercenary_transform_confirm_ok",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self:onUpdateTransfer()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_mercenary_transform_cancel_terminal = {
            _name = "adventure_mercenary_transform_cancel",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                _ED.transform_strengthen = 0
                fwin:close(fwin:find("AdventureMercenaryTransformClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local adventure_mercenary_transform_command_transfer_terminal = {
			_name = "adventure_mercenary_transform_command_transfer",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if self.shoWtypes == 1 then
					if self.heroServants ~= nil and self.heroThemain~=nil then
                        fwin:open(AdventureMercenaryTransConfirm:new():init(self.heroServants.ship_id,self.heroThemain.ship_id,self.consumeNum), fwin._ui)
					end
				elseif self.shoWtypes == 2 then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xuanly"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_33"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xuanly_0"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xuanly_0"):removeAllChildren(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xuanlz_0"):removeAllChildren(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Text_61"):setString(_transform_transfer_text[1])
					self.shoWtypes = 0
					self.heroServants = nil
					self.heroThemain = nil
					self.cells = nil
					_ED.transform_strengthen = 0
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_mercenary_transform_remove_transfer_terminal = {
			_name = "adventure_mercenary_transform_remove_transfer",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xuanly_0"):removeAllChildren(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xuanlz_0"):removeAllChildren(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Text_61"):setString(_transform_transfer_text[1])
				self.shoWtypes = 0
				self.heroServants = nil
				self.heroThemain = nil
				self.cells = nil
				_ED.transform_strengthen = 0
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
			
        state_machine.add(adventure_mercenary_transform_open_choice_servants_terminal)
        state_machine.add(adventure_mercenary_transform_update_servants_terminal)
        state_machine.add(adventure_mercenary_transform_update_themain_terminal)
        state_machine.add(adventure_mercenary_transform_command_transfer_terminal)
        state_machine.add(adventure_mercenary_transform_remove_transfer_terminal)
        state_machine.add(adventure_mercenary_transform_confirm_ok_terminal)
        state_machine.add(adventure_mercenary_transform_cancel_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mercenary transform state machine.
    init_adventure_mercenary_transform_terminal()
end

function AdventureMercenaryTransform:init()
    return self
end

function AdventureMercenaryTransform:onUpdateTransfer()
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Panel_xuanly"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_33"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_xuanly_0"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Text_61"):setString(_transform_transfer_text[4])
	self.shoWtypes = 2
	ccui.Helper:seekWidgetByName(self.cells.roots[1], "Button_1"):setVisible(false)
end

function AdventureMercenaryTransform:onUpdateServants(hero)
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Panel_xuanly_0"):removeAllChildren(true)
	local cell = AdventureMercenaryTransformServants:createCell()
	--  源   self.heroThemain  目标
	cell:init(hero, self)
	ccui.Helper:seekWidgetByName(root, "Panel_xuanly_0"):addChild(cell)
	_ED.transform_strengthen = hero.ship_id
end

function AdventureMercenaryTransform:onUpdateTerminal(hero)
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Panel_xuanlz_0"):removeAllChildren(true)
	local cell = AdventureMercenaryTransformTheMain:createCell()
	----------  目标  源
	cell:init(hero,self.heroServants)
	ccui.Helper:seekWidgetByName(root, "Panel_xuanlz_0"):addChild(cell)
	self.cells = cell
	self.shoWtypes = 1
	local config = zstring.split(dms.string(dms["pirates_config"], 305, pirates_config.param), ",")
	local mould_data = dms.element(dms["ship_mould"], hero.ship_template_id)
    self.consumeNum = config[dms.atoi(mould_data, ship_mould.ship_type)+1]
	ccui.Helper:seekWidgetByName(root, "Text_xiaohao"):setString(self.consumeNum)
	if zstring.tonumber(config[dms.atoi(mould_data, ship_mould.ship_type)+1]) > zstring.tonumber(_ED.user_info.user_gold) then
		ccui.Helper:seekWidgetByName(root, "Text_61"):setString(_transform_transfer_text[3])
	else
		ccui.Helper:seekWidgetByName(root, "Text_61"):setString(_transform_transfer_text[2])
	end
end

function AdventureMercenaryTransform:onEnterTransitionFinish()
    local csbAdventureMercenaryTransform = csb.createNode("packs/Mercenary/yongbing_linlizhuanyi.csb")
    local root = csbAdventureMercenaryTransform:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMercenaryTransform)
	
	ccui.Helper:seekWidgetByName(root, "Text_61"):setString(_transform_transfer_text[1])
	ccui.Helper:seekWidgetByName(root, "Text_xiaohao"):setString("0")
	self.shoWtypes = 0

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        terminal_name = "adventure_mercenary_transform_cancel",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 等待选择
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wait"),       nil, 
    {
        terminal_name = "adventure_mercenary_transform_command_transfer",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	-- 选择灵源
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_choose_ly"),       nil, 
    {
        terminal_name = "adventure_mercenary_transform_open_choice_servants",      
        terminal_state = 0, 
		types = 1,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	-- 选择灵主
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_choose_lz"),       nil, 
    {
        terminal_name = "adventure_mercenary_transform_open_choice_servants",      
        terminal_state = 0, 
		types = 2,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	
end

function AdventureMercenaryTransform:onExit()

end
