-- ----------------------------------------------------------------------------------------------------
-- 说明：仓库没人物提示
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
StorageDialog = class("StorageDialogClass", Window)
    
function StorageDialog:ctor()
    self.super:ctor()
	self.type = nil
	app.load("client.campaign.trialtower.TrialTower")
	app.load("client.campaign.plunder.Plunder")
    -- Initialize HelperDlg state machine.
    local function init_storage_dialog_terminal()
		-- 战斗界面
        local storage_dialog_return_to_battle_terminal = {
            _name = "storage_dialog_return_to_battle",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- if tonumber(_ED.user_info.user_grade) >= 15 then 
					-- fwin:cleanView(fwin._view) 
					-- fwin:close(instance)
					-- fwin:open(Plunder:new(), fwin._view)
				-- else
					-- TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 15, fun_open_condition.tip_info))
				-- end
    --             state_machine.excute("duplicate_page_controller_open", 0, 
    --                 {
    --                     _datas = {
    --                         terminal_name = "duplicate_page_controller_open",   
    --                         next_terminal_name = "duplicate_page_controller_open",        
    --                         but_image = "Image_duplicate",       
    --                         terminal_state = 0, 
    --                         isPressedActionEnabled = true
    --                     }
    --                 }
    --             )
			app.load("client.home.Menu")
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end
			state_machine.excute("menu_manager", 0, 
				{
					_datas = {
						terminal_name = "menu_manager", 	
						next_terminal_name = "menu_show_duplicate",  	
						current_button_name = "Button_duplicate", 	
						but_image = "Image_duplicate", 	
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
			
			state_machine.excute("shortcut_open_duplicate_window", 0, params) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--海战界面
		local storage_dialog_return_to_wather_battle_terminal = {
            _name = "storage_dialog_return_to_wather_battle",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if dms.int(dms["fun_open_condition"], 14, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
					fwin:cleanView(fwin._view) 
					fwin:close(instance)
					local function responseKingdomsCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							fwin:open(TrialTower:new(), fwin._view)
						end
					end
					NetworkManager:register(protocol_command.three_kingdoms_init.code, nil, nil, nil, nil, responseKingdomsCallback, false, nil)
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 14, fun_open_condition.tip_info))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--夺宝
		local storage_dialog_return_to_plunder_terminal = {
            _name = "storage_dialog_return_to_plunder",
            _init = function (terminal) 
				app.load("client.campaign.plunder.Plunder")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local level = dms.int(dms["fun_open_condition"], 15, fun_open_condition.level)
				if level <= zstring.tonumber(_ED.user_info.user_grade) then
					state_machine.excute("menu_clean_page_state", 0,"") 
					state_machine.excute("menu_button_hide_highlighted_all", 0,"") 
					
					fwin:cleanView(fwin._view) 
					fwin:close(instance)
					fwin:open(Plunder:new(), fwin._view)	
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 15, fun_open_condition.tip_info))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --创建军团
		local storage_dialog_return_to_creat_union_terminal = {
            _name = "storage_dialog_return_to_creat_union",
            _init = function (terminal) 
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    app.load("client.l_digital.union.create.UnionCreate")
                else
                	app.load("client.union.create.UnionCreate")
                end
				state_machine.excute("union_create_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --魔陷卡获取途径
		local storage_dialog_return_to_get_magic_trup_terminal = {
            _name = "storage_dialog_return_to_get_magic_trup",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.excute("menu_clean_page_state", 0,"") 
				state_machine.excute("menu_button_hide_highlighted_all", 0,"")
				fwin:cleanView(fwin._view)
				fwin:close(instance)

            	app.load("client.duplicate.DuplicateController")
            	fwin:open(DuplicateController:new(), fwin._view)
                state_machine.excute("duplicate_controller_manager", 0, 
                    {
                        _datas = {
                            terminal_name = "duplicate_controller_manager",     
                            next_terminal_name = "duplicate_controller_copy_page",       
                            current_button_name = "Button_putong",    
                            but_image = "Image_copy",       
                            terminal_state = 0, 
                            isPressedActionEnabled = true
                        }
                    }
                )
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --战宠商店
		local storage_dialog_return_to_pet_shop_terminal = {
            _name = "storage_dialog_return_to_pet_shop",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("pet_storage_return_home_page",0,0)
                app.load("client.packs.pet.PetShop")                
                local cell = PetShop:new()
                cell:init(1)
                fwin:open(cell, fwin._view)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(storage_dialog_return_to_plunder_terminal)
        state_machine.add(storage_dialog_return_to_battle_terminal)
        state_machine.add(storage_dialog_return_to_wather_battle_terminal)
        state_machine.add(storage_dialog_return_to_creat_union_terminal)
        state_machine.add(storage_dialog_return_to_get_magic_trup_terminal)
        state_machine.add(storage_dialog_return_to_pet_shop_terminal)
        state_machine.init()
    end
    
    -- call func init HelperDlg state machine.
    init_storage_dialog_terminal()
end

function StorageDialog:onEnterTransitionFinish()
    local csbStorageDialog = csb.createNode("utils/tanchuang.csb")
    self:addChild(csbStorageDialog)
	
	local root = csbStorageDialog:getChildByName("toot")
	-- local close_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {terminal_name = "helper_dlg_close", terminal_state = 1}, nil, 0)
	
	if self.type == 1 then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chuji_5"), nil, {func_string = [[state_machine.excute("storage_dialog_return_to_battle", 0, "click storage_dialog_return_to_battle.'")]], isPressedActionEnabled = true}, nil, 0)
	elseif self.type == 2 then
		ccui.Helper:seekWidgetByName(root, "Panel_jianniangsuipian"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_zhuangbei"):setVisible(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chuji"), nil, {func_string = [[state_machine.excute("storage_dialog_return_to_battle", 0, "click storage_dialog_return_to_battle.'")]], isPressedActionEnabled = true}, nil, 0)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_haizhan"), nil, {func_string = [[state_machine.excute("storage_dialog_return_to_wather_battle", 0, "click storage_dialog_return_to_wather_battle.'")]], isPressedActionEnabled = true}, nil, 0)
	elseif self.type == 3 then
		ccui.Helper:seekWidgetByName(root, "Panel_jianniangsuipian"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_baowu"):setVisible(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chuji_5_8"), nil, {func_string = [[state_machine.excute("storage_dialog_return_to_plunder", 0, "click storage_dialog_return_to_plunder.'")]], isPressedActionEnabled = true}, nil, 0)
	elseif self.type == 4 then
		ccui.Helper:seekWidgetByName(root, "Panel_jianniangsuipian"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_jiandui"):setVisible(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jiandui_5_8"), nil, {func_string = [[state_machine.excute("storage_dialog_return_to_creat_union", 0, "click storage_dialog_return_to_creat_union.'")]], isPressedActionEnabled = true}, nil, 0)
	elseif self.type == 5 then
		ccui.Helper:seekWidgetByName(root, "Panel_jianniangsuipian"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_magic"):setVisible(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chuji_6"), nil, {func_string = [[state_machine.excute("storage_dialog_return_to_get_magic_trup", 0, "click storage_dialog_return_to_get_magic_trup.'")]], isPressedActionEnabled = true}, nil, 0)
	elseif self.type == 6 then
		ccui.Helper:seekWidgetByName(root, "Panel_jianniangsuipian"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_turp"):setVisible(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chuji_7"), nil, {func_string = [[state_machine.excute("storage_dialog_return_to_get_magic_trup", 0, "click storage_dialog_return_to_get_magic_trup.'")]], isPressedActionEnabled = true}, nil, 0)
	elseif self.type == 7 then 
		--战宠
        ccui.Helper:seekWidgetByName(root, "Panel_jianniangsuipian"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Panel_pet"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_pet"):setString(_pet_tipString_info[4])
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pet_shop"), nil, {func_string = [[state_machine.excute("storage_dialog_return_to_pet_shop", 0, "click storage_dialog_return_to_battle.'")]], isPressedActionEnabled = true}, nil, 0)
	elseif self.type == 8 then 
		--战宠碎片
        ccui.Helper:seekWidgetByName(root, "Panel_jianniangsuipian"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Panel_pet"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_pet"):setString(_pet_tipString_info[5])
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pet_shop"), nil, {func_string = [[state_machine.excute("storage_dialog_return_to_pet_shop", 0, "click storage_dialog_return_to_battle.'")]], isPressedActionEnabled = true}, nil, 0)
	end
end

function StorageDialog:init(_types)
	self.type = _types
end

function StorageDialog:onExit()
	state_machine.remove("storage_dialog_return_to_plunder")
	state_machine.remove("storage_dialog_return_to_battle")
	state_machine.remove("storage_dialog_return_to_wather_battle")
	state_machine.remove("storage_dialog_return_to_creat_union")
	state_machine.remove("storage_dialog_return_to_get_magic_trup")
    state_machine.remove("storage_dialog_return_to_pet_shop")
end

function StorageDialog:createCell()
	local cell = StorageDialog:new()
	cell:registerOnNodeEvent(cell)
	return cell
end