--大师训练营奖励界面
TrainigCampReward = class("TrainigCampRewardClass", Window)

local training_camp_reward_open_terminal = {
	_name = "training_camp_reward_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("TrainigCampRewardClass") == nil then
			fwin:open(TrainigCampReward:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local training_camp_reward_close_terminal = {
	_name = "training_camp_reward_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TrainigCampRewardClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(training_camp_reward_open_terminal)
state_machine.add(training_camp_reward_close_terminal)
state_machine.add(training_camp_reward_show_terminal)
state_machine.add(training_camp_reward_hide_terminal)
state_machine.init()

function TrainigCampReward:ctor()
	self.super:ctor()
	self.roots = {}
    self._start_idex = 1
    self._end_idex = 10
    self.isover = false  --是否到底
    self.curidex = 0   --当前为第几页，10项为1页
    self._cells = {}  
    self._clickidex = nil   --点击的那一列第几个
    self._clickpage = nil --点击的第几列
    self._isreward = false
    self._rewardlvinfo = {}  --特殊奖励等级 特殊存
    self._rewardlvafter = {}  --特殊奖励等级 正常存
    self.ListView_training_camp_list_posx = -1
    self._update_count = 0
    self._cellsize = {}
    app.load("client.cells.activity.training_camp_reward_list_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.activity.traingcamp.TrainigCampChange")
    app.load("client.activity.traingcamp.TrainigCampRewardPreview")
    app.load("client.activity.traingcamp.TrainigCampPackage")
     local function init_training_camp_rewar_terminal()
        local training_camp_reward_terminal = {
            _name = "training_camp_reward_show",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._clickidex = params._datas.clickidex
                instance._clickpage = params._datas.page
                local temp = instance._clickidex
                if temp == 2 then
                    temp = 1
                elseif temp == 3 then
                    temp = 2
                end
                local info = nil

                if instance._clickidex == 1 then
                    info = _ED.training_camp_reward_info.freeReward[instance._clickpage]
                else
                    info = _ED.training_camp_reward_info.masterReward[instance._clickpage]
                end
                instance._isreward = true
                local num = #(instance._cells)
                local rewards = zstring.splits(info, "|", ",")
                if not rewards[temp] then
                    instance._isreward = false
                end
                for i= 1, num do
                   if instance._cells[i].roots[1] then
                        for k =1,3 do
                          ccui.Helper:seekWidgetByName(instance._cells[i].roots[1], "Image_icon_choose_"..k):setVisible(false)
                        end
                        if instance._cells[i]:getTag() ==  instance._clickpage and instance._isreward then
                          ccui.Helper:seekWidgetByName(instance._cells[i].roots[1], "Image_icon_choose_"..instance._clickidex):setVisible(true)
                        end
                   end
                end
                if instance._isreward then
                   instance:onUpdateRightSide(info,temp)
                end
                ccui.Helper:seekWidgetByName(instance.roots[1],"Button_training_reward_view"):setVisible(false)
                ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_camp_reward_unlock"):setVisible(false)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local training_camp_reward_draw_terminal = {
            _name = "training_camp_reward_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local lv =  params._datas.page
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        params._datas.cells:updateReward()
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._ui)
                    end
                end
                protocol_command.activity_pokemon_master_get_reward.param_list = lv
                NetworkManager:register(protocol_command.activity_pokemon_master_get_reward.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local training_camp_reward_all_draw_terminal = {
            _name = "training_camp_reward_all_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        for k,v in pairs(instance._cells) do
                           if v.roots[1] then
                              v:updateReward()
                           end
                        end
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._ui)
                    end
                end
                NetworkManager:register(protocol_command.activity_pokemon_master_one_key.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --刷新活动数据
        local training_camp_reward_update_actinfo_terminal = {
            _name = "training_camp_reward_update_actinfo",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for k,v in pairs(instance._cells) do
                   if v.roots[1] then
                      v:updateReward()
                   end
                end
                instance:isLockIma()
                instance:moveListPos()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local training_camp_reward_hide_ui_terminal = {
            _name = "training_camp_reward_hide_ui",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local training_camp_reward_show_ui_terminal = {
            _name = "training_camp_reward_show_ui",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    if instance:isVisible() == false  then
                        instance:setVisible(true)
                    end
                    instance:moveListPos()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
      
        state_machine.add(training_camp_reward_terminal)
        state_machine.add(training_camp_reward_draw_terminal)
        state_machine.add(training_camp_reward_all_draw_terminal)
        state_machine.add(training_camp_reward_update_actinfo_terminal)
        state_machine.add(training_camp_reward_hide_ui_terminal)
        state_machine.add(training_camp_reward_show_ui_terminal)
        state_machine.init()
    end
    init_training_camp_rewar_terminal()
end

function TrainigCampReward:onUpdateClick( ... )
    local num = #(instance._cells)
    for i= 1, num do
       if instance._cells[i].roots[1] then
            for k =1,3 do
              ccui.Helper:seekWidgetByName(instance._cells[i].roots[1], "Image_icon_choose_"..k):setVisible(false)
            end
            if instance._cells[i]:getTag() == page then
              ccui.Helper:seekWidgetByName(instance._cells[i].roots[1], "Image_icon_choose_"..clickidex):setVisible(true)
            end
       end
    end
end

function TrainigCampReward:onUpdateDraw()                 
    local ListView_camp_reward = ccui.Helper:seekWidgetByName(self.roots[1],"ListView_camp_reward")
    ListView_camp_reward:removeAllItems()
    if  not _ED.active_activity[157] then
        return
    end
    local num = table.nums(_ED.training_camp_reward_info.masterReward)
    self._rewardlvafter= {}
    self._rewardlvinfo = {}

    self._rewardlvafter =  zstring.split(dms.string(dms["activity_config"], 41, activity_config.param), ",")
    for k,v in pairs(self._rewardlvafter) do
        self._rewardlvinfo[tonumber(v)] = tonumber(v)
        if self._rewardlvafter[k+1] then
           self._rewardlvinfo[tonumber(v)+1] = tonumber(self._rewardlvafter[k+1])
        end
    end
   
    local itemSize = nil
    local drawpos_num = self:checkFirstDraw()
    local info = _ED.training_camp_reward_info

    for i=1,num do
       local isSpecila = false
       for k,v in pairs(self._rewardlvafter) do
           if i == tonumber(v)  then
              isSpecila = true
           end
       end
       local cell = state_machine.excute("training_camp_reward_list_cell_create",0,{info.freeReward[i],info.masterReward[i],i,isSpecila})
       ListView_camp_reward:addChild(cell)
       cell:setTag(i)
       table.insert(self._cells,cell) 
        if i == 1 then
          itemSize = cell:getContentSize()
          self._cellsize = itemSize
        end  
    end

    local totalWidth = (itemSize.width + 4)
    ListView_camp_reward:getInnerContainer():setPositionX(-(drawpos_num-1)*totalWidth)
    -- local function scrollViewEvent(sender, evenType)
    --     if evenType == ccui.ScrollviewEventType.bounceRight then--6
    --         --滑到头
    --        self:addnewlistCell()
    --     end
    -- end
    -- ListView_camp_reward:addScrollViewEventListener(scrollViewEvent)
    ListView_camp_reward:requestRefreshView()  
    local Text_camp_num =  ccui.Helper:seekWidgetByName(self.roots[1],"Text_camp_num")  --赛季
    Text_camp_num:setString(string.format(tipStringInfo_training_camp_name[16],_ED.training_camp_reward_info.season))

    local end_time = os.date("%m"..".".."%d".."  ".."%H"..":".."%M", getBaseGTM8Time(zstring.exchangeFrom(zstring.tonumber(_ED.training_camp_reward_info.closeTime)/1000)))
    local Text_camp_end_time_n =  ccui.Helper:seekWidgetByName(self.roots[1],"Text_camp_end_time_n")  --时间
    Text_camp_end_time_n:setString(end_time)

    self:onUpdateRight(_ED.training_camp_reward_info.freeReward[tonumber(self._rewardlvafter[1])],_ED.training_camp_reward_info.masterReward[tonumber(self._rewardlvafter[1])],tonumber(self._rewardlvafter[1]))
    self._parent:setVisible(true)
end


function TrainigCampReward:moveListPos()
    local ListView_camp_reward = ccui.Helper:seekWidgetByName(self.roots[1],"ListView_camp_reward")
    local drawpos_num = self:checkFirstDraw()
    local totalWidth = ( self._cellsize.width + 4)
    ListView_camp_reward:getInnerContainer():setPositionX(-(drawpos_num-1)*totalWidth)
    ListView_camp_reward:requestRefreshView()  
end

function TrainigCampReward:checkFirstDraw()
    local info =  json.decode(_ED.active_activity[157].activity_params)
    if tonumber(info.userActivityInfo.level) == 0 then
        return 0
    end
    
    for i=1, tonumber(info.userActivityInfo.level)  do
        local temp_one = false 
        local temp_two = false
        for k,v in pairs(info.userActivityInfo.drawFreeLevel) do
            if tonumber(v) == i then
                temp_one = true
            end
        end
        if not temp_one and (#_ED.training_camp_reward_info.freeReward[i]~=0) then
            return i
        end

        if info.userActivityInfo.buyMaster ~= 0 then
            for k,v in pairs(info.userActivityInfo.drawMasterLevel) do
                if tonumber(v) == i then
                    temp_two = true
                end
            end
            if not temp_two then
                return i
            end
        end
    end
   
    if tonumber(info.userActivityInfo.level) < #(_ED.training_camp_reward_info.masterReward) then
        return info.userActivityInfo.level + 1
    else
         return info.userActivityInfo.level 
    end
end

function TrainigCampReward:onUpdateRight(info_free,info_master,curidex)
    local Text_camp_lv = ccui.Helper:seekWidgetByName(self.roots[1],"Text_camp_b_lv")
    if curidex then
        Text_camp_lv:setString(curidex)
    else
        Text_camp_lv:setString(self._end_idex)
    end

    local Panel_camp_elite_icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_camp_elite_b_icon")  --奖励1
    local Panel_camp_advanced_icon_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_camp_advanced_b_icon_1")  --奖励2
    local Panel_camp_advanced_icon_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_camp_advanced_b_icon_2")  --奖励3
    Panel_camp_elite_icon:removeAllChildren(true)
    Panel_camp_advanced_icon_1:removeAllChildren(true)
    Panel_camp_advanced_icon_2:removeAllChildren(true)
    
    if #info_free ~= 0 then
        local reward_free = self:initRightReward(info_free,1)
        Panel_camp_elite_icon:addChild(reward_free) 
    end
    if #info_master ~= 0 then
        local reward_master_one = self:initRightReward(info_master,1)
        if reward_master_one then
            Panel_camp_advanced_icon_1:addChild(reward_master_one) 
        end
        local reward_master_two = self:initRightReward(info_master,2)
        if reward_master_two then
            Panel_camp_advanced_icon_2:addChild(reward_master_two) 
        end
    end
end

function TrainigCampReward:onUpdateRightSide(info,idex)
    local Text_camp_reward_name = ccui.Helper:seekWidgetByName(self.roots[1],"Text_camp_reward_name")  --名称

    local Text_camp_reward_infor = ccui.Helper:seekWidgetByName(self.roots[1],"Text_camp_reward_infor")  --描述    

    local Panel_reward_view = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_reward_view")  
  
    Panel_reward_view:removeAllChildren(true)
    
    if #info ~= 0 then
        local reward_free,name,num,quality,describe = self:initRightReward(info,idex)
        Panel_reward_view:addChild(reward_free) 
        Text_camp_reward_infor:setString(describe)
        if quality then
            Text_camp_reward_name:setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))
        end
        Text_camp_reward_name:setString(name.." x"..num)
    end
    self:slidingTxt()
end

function TrainigCampReward:isLockIma()
    local info = json.decode(_ED.active_activity[157].activity_params)
    local Image_camp_advanced = ccui.Helper:seekWidgetByName(self.roots[1],"Image_camp_advanced")
    local Panel_camp_props_unlock = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_camp_props_unlock")
    local Panel_camp_reward_unlock = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_camp_reward_unlock")
                
    if tonumber(info.userActivityInfo.buyMaster) == 0 then
        Image_camp_advanced:setEnabled(true)
        Panel_camp_props_unlock:setVisible(true)
        Panel_camp_reward_unlock:setVisible(true)
    else
        Image_camp_advanced:setEnabled(false)
        Panel_camp_props_unlock:setVisible(false)
        Panel_camp_reward_unlock:setVisible(false)
    end
end

function TrainigCampReward:getPropByType(_type,mould_id)  
    local prop = {}
    prop.type= _type
    prop.mould_id = mould_id
    local prop_info = nil
    if prop.type == 6 then
        prop_info = dms.element(dms["prop_mould"], prop.mould_id)
        if prop.mould_name == nil then
            prop.mould_name = dms.atos(prop_info, prop_mould.prop_name)
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                prop.mould_name = setThePropsIcon(prop.mould_id)[2]
            end
        end
        if prop.prop_quality == nil then
            prop.prop_quality = dms.atoi(prop_info, prop_mould.prop_quality)
        end
        prop.mould_remarks = dms.atos(prop_info, prop_mould.remarks)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            prop.mould_remarks = drawPropsDescription(prop.mould_id)
        end
    elseif prop.type == 7 then
        prop_info = dms.element(dms["equipment_mould"], prop.mould_id)
        if prop.mould_name == nil then
            prop.mould_name = smEquipWordlFundByIndex(prop.mould_id , 1)
        end
        prop.prop_quality = dms.atoi(prop_info, equipment_mould.trace_npc_index)
        if prop.prop_quality == 0 then
            prop.prop_quality = 3
        end
        prop.mould_remarks = smEquipWordlFundByIndex(prop.mould_id , 2)--描述
    end
    return prop
end


function TrainigCampReward:initRightReward(info,idex)
    -- 奖励
    local rewards = zstring.splits(info, "|", ",")
    if not rewards[idex] then
        return
    end
    rewards = rewards[idex]
    local rewardType = zstring.tonumber(rewards[1])
    local cell = ResourcesIconCell:createCell()
    if 13 == rewardType then
        local table = {}
        if rewards[4] ~= nil and tonumber(rewards[4]) ~= -1 then
            table.shipStar = tonumber(rewards[4])
        end
        cell:init(rewardType, tonumber(rewards[3]), tonumber(rewards[2]),nil,nil,true,true,1,table)
    else
        cell:init(rewardType, tonumber(rewards[3]), tonumber(rewards[2]),nil,nil,true,true,1)
    end

    local props = self:getPropByType(rewardType,tonumber(rewards[2]))
    local quality = tonumber(props.prop_quality)

    local describe = ""

    if tonumber(rewardType) == 1   then
        props.mould_name = _All_tip_string_info._fundName
        describe = _All_tip_string_info_description._fundNameDescription
    elseif tonumber(rewardType) == 2   then
        props.mould_name = _All_tip_string_info._crystalName
        describe = _All_tip_string_info_description._crystalNameDescription
    else
        describe = drawPropsDescription(tonumber(rewards[2]))
    end

    return cell,props.mould_name,rewards[3],quality,describe
end

function TrainigCampReward:onUpdate(dt)
    if not _ED.training_camp_reward_info then
        return
    end
    -- self._update_count = self._update_count + 1
    -- if self._update_count < 2 then
    --     return
    -- end
    local ListView_camp_reward = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_camp_reward")
    if ListView_camp_reward ~= nil then
        local size = ListView_camp_reward:getContentSize()
        local posX = ListView_camp_reward:getInnerContainer():getPositionX()
        if self.ListView_training_camp_list_posx == posX then
            return
        end
        self.ListView_training_camp_list_posx = posX
        local items =ListView_camp_reward:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempX = v:getPositionX() + posX
            if tempX + itemSize.width*0.8< 0 or tempX > size.width + itemSize.width*0.8 then
                v:unload()
            else
                v:reload()
                if self._clickpage and (v:getTag() == self._clickpage) and self._isreward then
                   ccui.Helper:seekWidgetByName(v.roots[1], "Image_icon_choose_"..self._clickidex):setVisible(true)
                end
            end
        end

        local totalWidth = (itemSize.width + 4)
        local _maxposX = math.ceil((posX-totalWidth)*-1)
        local _maxposXNext = math.ceil((posX)*-1)
        local pageIndex = math.ceil(math.abs(_maxposX) / (totalWidth*10))
        local pageIndexNext = math.ceil(math.abs(_maxposXNext) / totalWidth)   --指单独滑到了第几个cell
        local count = tonumber(table.nums(self._rewardlvinfo))  
        if self._rewardlvinfo[pageIndexNext] and self._rewardlvinfo[pageIndexNext+1]  then
            if pageIndexNext == tonumber(self._rewardlvinfo[pageIndexNext]) then
               self:onUpdateRight(_ED.training_camp_reward_info.freeReward[self._rewardlvinfo[pageIndexNext+1]],_ED.training_camp_reward_info.masterReward[self._rewardlvinfo[pageIndexNext+1]],self._rewardlvinfo[pageIndexNext+1])
            end
        elseif self._rewardlvinfo[pageIndexNext+1] and tonumber(self._rewardlvinfo[pageIndexNext+1]) ==  pageIndexNext +1  then
               self:onUpdateRight(_ED.training_camp_reward_info.freeReward[self._rewardlvinfo[pageIndexNext+1]],_ED.training_camp_reward_info.masterReward[self._rewardlvinfo[pageIndexNext+1]],self._rewardlvinfo[pageIndexNext+1])
        elseif pageIndexNext ==  0 then
            if self.curidex ~= pageIndex then
               self:onUpdateRight(_ED.training_camp_reward_info.freeReward[tonumber(self._rewardlvafter[1])],_ED.training_camp_reward_info.masterReward[tonumber(self._rewardlvafter[1])],tonumber(self._rewardlvafter[1]))
            end
        elseif pageIndexNext > tonumber(self._rewardlvafter[7]) then
          --  if self.curidex ~= pageIndex then
                self:onUpdateRight(_ED.training_camp_reward_info.freeReward[pageIndex*10],_ED.training_camp_reward_info.masterReward[pageIndex*10],pageIndex*10)
           -- end  
            --self.curidex = pageIndex
        end
    end
end 

function TrainigCampReward:slidingTxt()
    local ScrollView_explore_shop = ccui.Helper:seekWidgetByName(self.roots[1], "ScrollView_camp_reward")
    local Text_skill_infor = ccui.Helper:seekWidgetByName(self.roots[1], "Text_camp_reward_infor")

    local textRenderSize = Text_skill_infor:getAutoRenderSize() -- 未换行前尺寸
    local VirtualRendererSize = Text_skill_infor:getVirtualRendererSize() -- 控件本身可渲染尺寸
    local needRowNumber = math.ceil(textRenderSize.width / VirtualRendererSize.width)
    local currRowNumber = math.floor(VirtualRendererSize.height / textRenderSize.height)
    local curHeight = 0
    if needRowNumber > currRowNumber then
        curHeight = (needRowNumber - currRowNumber) * textRenderSize.height + Text_skill_infor:getFontSize()
    end
 
    local text_height = VirtualRendererSize.height + curHeight
    Text_skill_infor:setContentSize(cc.size(Text_skill_infor:getContentSize().width , text_height))
    ScrollView_explore_shop:setInnerContainerSize(cc.size(ScrollView_explore_shop:getContentSize().width, text_height))
    Text_skill_infor:setPositionY(text_height)

  --  ScrollView_explore_shop:jumpToTop()
end

function TrainigCampReward:addnewlistCell()  --奖励添加
    -- if self.isove then
    --     return
    -- end
    -- local ListView_camp_reward = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_camp_reward")
    -- local info = _ED.training_camp_reward_info
    -- local temp = 0
    -- self._start_idex = self._start_idex+10
    -- self._end_idex = self._end_idex+10
    
    -- if self._end_idex > #(_ED.training_camp_reward_info.freeReward) then
    --     temp = self._end_idex
    --     self._end_idex = #(_ED.training_camp_reward_info.freeReward) 
    --     self._start_idex  = temp - 10 + 1 
    --     self.isove = true
    -- end

    -- for i= self._start_idex,self._end_idex do   
    --     local isSpecila = false
    --     for k,v in pairs(self._rewardlvafter) do
    --        if i == tonumber(v)  then
    --           isSpecila = true
    --        end
    --     end
    --     local cell = state_machine.excute("training_camp_reward_list_cell_create",0,{info.freeReward[i],info.masterReward[i],i,isSpecila})
    --     ListView_camp_reward:addChild(cell)
    --     cell:setTag(i)
    --     table.insert(self._cells,cell)  
    -- end
    -- ListView_camp_reward:requestRefreshView()

end

function TrainigCampReward:init(params)
    self._rootWindows = params[1]
    self._parent = params[2]
	self:onInit()
    return self
end

function TrainigCampReward:onInit()
    local csbItem = csb.createNode("activity/wonderful/training_camp_reward_tab.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_training_reward_view"), nil, --奖励预览
    {
        terminal_name = "training_camp_reward_preview_open",
        terminal_state = 0,
        idex = 2,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_training_advanced"), nil, --进阶训练营
    {
        terminal_name = "training_camp_package_open",
        terminal_state = 0,
        idex = 2,
    },
    nil,1)
  
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_camp_advanced"), nil, --点击进阶图
    {
        terminal_name = "training_camp_reward_preview_open",
        terminal_state = 0,
        idex = 2,
    },
    nil,1)

    self:onUpdateDraw()
    self:isLockIma()
    self:slidingTxt()
end

function TrainigCampReward:onEnterTransitionFinish()
end

function TrainigCampReward:onExit()
	self.ListView_training_camp_list_posx  = 0
    state_machine.remove("training_camp_reward_show")
    state_machine.remove("training_camp_reward_draw")
    state_machine.remove("training_camp_reward_all_draw")
    state_machine.remove("training_camp_reward_update_actinfo")
    state_machine.remove("training_camp_reward_hide_ui")
    state_machine.remove("training_camp_reward_show_ui")
end

