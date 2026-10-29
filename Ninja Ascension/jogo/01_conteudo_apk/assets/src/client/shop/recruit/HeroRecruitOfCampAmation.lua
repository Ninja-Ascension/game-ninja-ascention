--------------------------------------------------------------------------------------------------------------
--  说明：阵营招募动画界面
--------------------------------------------------------------------------------------------------------------
HeroRecruitOfCampAmation = class("HeroRecruitOfCampAmationClass", Window)

--打开界面
local hero_recruit_of_camp_hero_amtion_open_terminal = {
    _name = "hero_recruit_of_camp_hero_amtion_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.lock("hero_recruit_of_camp_hero_amtion_open")
        local HeroRecruitOfCampAmation_window = HeroRecruitOfCampAmation:new()
        HeroRecruitOfCampAmation_window:init()
        fwin:open(HeroRecruitOfCampAmation_window,fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local hero_recruit_of_camp_hero_amtion_close_terminal = {
    _name = "hero_recruit_of_camp_hero_amtion_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroRecruitOfCampAmationClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_recruit_of_camp_hero_amtion_open_terminal)
state_machine.add(hero_recruit_of_camp_hero_amtion_close_terminal)
state_machine.init()
function HeroRecruitOfCampAmation:ctor()
	self.super:ctor()
	self.roots = {}
	
	self:initDeclare()
	 -- Initialize union duplicate seat machine.
	 -- 初始化状态机
    local function init_hero_recruit_of_camp_amation_terminal() 
		--通知去播放动画
        local hero_recruit_of_camp_amation_toplay_terminal = {
            _name = "hero_recruit_of_camp_amation_toplay",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--state_machine.excute("hero_recruit_of_camp_amation_toplay",0,{"left",1,251}) 
				-- 如果是抽取 ，旋转方向默认左，速度默认1秒，由策划或者美术定，最后是抽取到的道具id，如果是10连抽 取最后或者 最先的一个
				if instance ~= nil then
					local datas = params
					state_machine.lock("hero_recruit_of_camp_amation_toplay")
					instance:scrollBall(datas[1],datas[2],datas[3])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--通知去刷新界面，通常在阵营切换的时候刷新，用到比较少
		local hero_recruit_of_camp_amation_update_all_terminal = {
            _name = "hero_recruit_of_camp_amation_update_all",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance ~= nil then
					state_machine.lock("hero_recruit_of_camp_amation_update_all")
					instance:updateAnimationByTypeId()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(hero_recruit_of_camp_amation_toplay_terminal)
		state_machine.add(hero_recruit_of_camp_amation_update_all_terminal)
        state_machine.init()
    end
    -- call func init union duplicate seat machine.
    init_hero_recruit_of_camp_amation_terminal()

end

--声明
function HeroRecruitOfCampAmation:initDeclare()
	self.hero_names = {} --英雄名字碎片
	self.hero_quality ={} -- 英雄品质
	self.hero_panel = {} -- 用来控制移动的层
	self.heros_icon = {} --  用来切换的两个英雄
	self.hero_red_name = {} --两个红色英雄显示的名字
	self.hero_icon_id = 1
	self.ball_positionsX = {} -- 需要移动到的x
	self.ball_positionsY = {} -- 需要移动到的y
	self.ball_scales = {} --存储所有的缩放值
	self.balls = {} -- 所有球的table，暂时只是存了一下，没有用
	self.prop_mould_id = {} --所有英雄对应的碎片id ，抽取时会传一个id ，这边匹配
	self.red_hero_scale = 1 --红色英雄的缩放值，乘基础缩放值
	--self.stopAnimation = false 这种判断方式，先pass 通过总转动次数控制，保证抽取动画时间总时长一样，如果，要转动时间随转动轴变化，打开这个相应的注释
	self.scroll_times = 0 -- 这个会递减
	self.alltimes = 0 --这个总次数不变
end

--临界值的处理、阵营变化时
function HeroRecruitOfCampAmation:updateAnimationByTypeId()
	local root = self.roots[1]
	for i ,v in pairs(self.hero_panel) do
		v:removeFromParent(true)
	end
	local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role")
	Panel_role:stopAllActions()
	self:initDeclare()
	self:initHeroCamp()
	self:initNpc()
	self:initDraw()
	
	state_machine.unlock("hero_recruit_of_camp_amation_update_all")
end

--初始化所用英雄数据
function HeroRecruitOfCampAmation:initHeroCamp()
	local type_id = tonumber(_ED.user_bounty_typeid)
	local group_id = dms.int(dms["partner_bounty"],type_id,partner_bounty.bounty_group)
	local hero_table = dms.searchs(dms["partner_bounty_library"], partner_bounty_library.group_id,group_id )
	for i ,v in pairs(hero_table) do
		local name = dms.string(hero_table,i,partner_bounty_library.ship_name)
		local prop_mould_id = dms.int(hero_table,i,partner_bounty_library.prop_mould_id)
		local quality = dms.int(dms["prop_mould"],prop_mould_id,prop_mould.prop_quality)
		table.insert(self.hero_names,name) 
		table.insert(self.hero_quality,quality)
		table.insert(self.prop_mould_id,prop_mould_id)
	end
end

--初始化npc
function HeroRecruitOfCampAmation:initNpc()
	local root = self.roots[1]

	local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role")
	local Text_role_name = ccui.Helper:seekWidgetByName(root,"Text_role_name")
	Text_role_name:setVisible(true)
	Panel_role:setLocalZOrder(1)
	local type_id = tonumber(_ED.user_bounty_typeid)
	local heros_id = dms.string(dms["partner_bounty"],type_id,partner_bounty.hero_icon)
	local heros_ship_mould_ids = dms.string(dms["partner_bounty"],type_id,partner_bounty.ship_mould)
	self.heros_icon  = zstring.split(heros_id,",")
	local ship_mould_table = zstring.split(heros_ship_mould_ids,",")
	local getPersonName = nil
	local name_1 = nil
	local name_2 = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], tonumber(ship_mould_table[1]), ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		-- local ship_evo = zstring.split(fundShipWidthId(""..shipID).evolution_status, "|")
		local evo_mould_id = evo_info[dms.int(dms["ship_mould"], tonumber(ship_mould_table[1]), ship_mould.captain_name)]
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
        name_1 = word_info[3]
	else
		name_1 = dms.string(dms["ship_mould"],tonumber(ship_mould_table[1]),ship_mould.captain_name)
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], tonumber(ship_mould_table[2]), ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		-- local ship_evo = zstring.split(fundShipWidthId(""..shipID).evolution_status, "|")
		local evo_mould_id = evo_info[dms.int(dms["ship_mould"], tonumber(ship_mould_table[2]), ship_mould.captain_name)]
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
        name_2 = word_info[3]
	else
		name_2 = dms.string(dms["ship_mould"],tonumber(ship_mould_table[2]),ship_mould.captain_name)
	end
	table.insert(self.hero_red_name,name_1)
	table.insert(self.hero_red_name,name_2)
	Panel_role:removeBackGroundImage()
	Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png",self.heros_icon[self.hero_icon_id]))
	Text_role_name:setString(self.hero_red_name[self.hero_icon_id])
	self:runAcationNpc()
end

--初始化一些table
function HeroRecruitOfCampAmation:initDraw()
	local root = self.roots[1]
	local number = #self.hero_names --该阵营有多少个英雄
	local ArmatureNode = {}
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_guangqiu/effect_guangqiu.ExportJson")
	for i = 1 , number do	
		local cell = ccs.Armature:create("effect_guangqiu")
		cell:getAnimation():playWithIndex(0)
		cell:setAnchorPoint(0.5,0.5)
		table.insert(ArmatureNode,cell)
	end

	for i,v in pairs (self.hero_names) do
		local index = i 
		if index > 10 then
			index = 10
		end
		local panel = ccui.Helper:seekWidgetByName(root,string.format("Panel_role_icon_%d",index))
		table.insert(self.ball_positionsX,panel:getPositionX())
		table.insert(self.ball_positionsY,panel:getPositionY())
		table.insert(self.ball_scales,panel:getScale())
	end  
	
	for i , v in pairs(self.hero_names) do 
		local ball_images = cc.Sprite:create("images/ui/icon/zhengying_icon.png")
		local nameLabel = cc.Label:createWithTTF(v, "fonts/FZYiHei-M20S.ttf", 30 / CC_CONTENT_SCALE_FACTOR())
		local Hero_Panel = ccui.Layout:create()
		
		local Panel_shop = ccui.Helper:seekWidgetByName(root,"Panel_shop")
		table.insert(self.balls,ball_images)
		table.insert(self.hero_panel,Hero_Panel)
		if self.hero_quality[i] == 5 then
			self.red_hero_scale = 1.2
			nameLabel:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3])) --红色
		else
			self.red_hero_scale = 1
			nameLabel:setColor(cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3])) --橙色
		end
		if i <= 9 then
			Hero_Panel:setPosition(cc.p(self.ball_positionsX[i],self.ball_positionsY[i]))
			Hero_Panel:setScale(self.ball_scales[i]*self.red_hero_scale)
		else
			Hero_Panel:setPosition(cc.p(self.ball_positionsX[10],self.ball_positionsY[10]))
			Hero_Panel:setScale(self.ball_scales[10]*self.red_hero_scale)
		end
		nameLabel:setPositionY(nameLabel:getPositionY()-80)
		
		Hero_Panel:setLocalZOrder(2) --临时全部设置最高
		Panel_shop:addChild(Hero_Panel)
		Hero_Panel:addChild(ball_images)
		Hero_Panel:addChild(nameLabel)
		ArmatureNode[i]:setPosition(cc.p( Hero_Panel:getContentSize().width/2, Hero_Panel:getContentSize().height/2))
		Hero_Panel:addChild(ArmatureNode[i])
		Hero_Panel:setTag(i)
	end
end
--开始转动
function HeroRecruitOfCampAmation:scrollBall(_types,_runSpeed,_propId)
	local table_len = #self.hero_panel
	local runSpeed = _runSpeed or 0.3 --旋转速度
	local prop_id = _propId
	local types = _types or "left"
	local runSpeedFornext = _runSpeed
	if prop_id ~= nil then
		for i , v in pairs(self.prop_mould_id)	do
			if v == prop_id then
				local tag = self.hero_panel[i]:getTag() 
				local times = table_len - 5 + tag
				if times > table_len then
					times = times - table_len
				end
				self.scroll_times = times
				self.alltimes = times --用来计算平均每次转动的时间
			end
		end
	end	
	-- if true then
	-- state_machine.unlock("hero_recruit_of_camp_amation_toplay")
		-- return
	-- end
	local function RunOverFunc()
	--print("速度",runSpeed)
		--if runSpeed ~= 0.3 then --说明是抽取动画的旋转，这里需要解锁，等于0.3的代表一次转动，会在touch事件里解锁,
		--注掉，滑动不松开就会一直划。
			state_machine.unlock("hero_recruit_of_camp_amation_toplay")
		--end
		
		--if prop_id ~= nil then --如果有传道具id 说明是抽取之后的转动，动画播放打开，递归旋转
			--self.stopAnimation = true
			--self:CheckStop(prop_id) -- 检测是否播放继续转动，当id匹配，位置到中间时，停止，如果无匹配 stopAnimation依然为true,进行下一次转动，换用方法注释
		--end
		--if self.stopAnimation == true then
			--state_machine.excute("hero_recruit_of_camp_amation_toplay",0,{"right",runSpeed,prop_id})
			--return self:scrollBall("right",runSpeed,prop_id)
		--end
		--print("-------times---------",self.scroll_times)
		if self.scroll_times == 1 then
			state_machine.excute("hero_recruit_of_camp_play_animation",0,"")
			self.scroll_times = 0
		end
		if self.scroll_times > 1 then
			self.scroll_times = self.scroll_times - 1
			state_machine.excute("hero_recruit_of_camp_amation_toplay",0,{"left",runSpeedFornext})	
		end
	end
	if runSpeed ~= 0.3 then
		runSpeed = runSpeed/self.alltimes
		state_machine.excute("hero_recruit_of_set_isplaying",0,"")
	end
	if types == "left" then
		for i ,v in pairs( self.hero_panel) do
			local index = v:getTag()
			if index == 1 then
				index = table_len + 1
			end
			v:setTag(index - 1)
			if self.hero_quality[i] == 5 then
				self.red_hero_scale = 1.2
			else
				self.red_hero_scale = 1
			end
			
			v:runAction(cc.Spawn:create(cc.ScaleTo:create(runSpeed,self.ball_scales[index-1]*self.red_hero_scale),cc.MoveTo:create(runSpeed,cc.p(self.ball_positionsX[index-1],self.ball_positionsY[index-1]))))
			
		end
		self:runAction(cc.Sequence:create(cc.DelayTime:create(runSpeed+0.02),cc.CallFunc:create(RunOverFunc)))
	elseif types == "right" then

		for i ,v in pairs( self.hero_panel) do
			local index = v:getTag()
			if index == table_len then
				index = 0
			end
			v:setTag(index+1)
			if self.hero_quality[i] == 5 then
				self.red_hero_scale = 1.2
			else
				self.red_hero_scale = 1
			end
			v:runAction(cc.Spawn:create(cc.ScaleTo:create(runSpeed,self.ball_scales[index+1]*self.red_hero_scale),cc.MoveTo:create(runSpeed,cc.p(self.ball_positionsX[index+1],self.ball_positionsY[index+1]))))
			
		end
		self:runAction(cc.Sequence:create(cc.DelayTime:create(runSpeed+0.02),cc.CallFunc:create(RunOverFunc)))
	end
end

--ball层级 label层级
function HeroRecruitOfCampAmation:onUpdate()
	self:onUpdateBallZOrder()
end
--检测是否播放继续转动，当id匹配，位置到中间时，停止 -- 因为所有的转动总时间不同，更换方式，这个方式先注释
-- function HeroRecruitOfCampAmation:CheckStop(prop_id)
	-- for i ,v in pairs(self.prop_mould_id) do
		-- if v == prop_id and self.hero_panel[i]:getTag() == 5 then
			-- self.stopAnimation = false
		-- end
	-- end
-- end

function HeroRecruitOfCampAmation:runAcationNpc()
	local root = self.roots[1]
	local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role")
	local Text_role_name = ccui.Helper:seekWidgetByName(root,"Text_role_name")
	local function ChangeBackFunc()
		if self.hero_icon_id == 1 then
			self.hero_icon_id = 2
		else
			self.hero_icon_id = 1
		end
		Panel_role:removeBackGroundImage()
		Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png",self.heros_icon[self.hero_icon_id]))
		Text_role_name:setString(self.hero_red_name[self.hero_icon_id])
	end
	Panel_role:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeOut:create(3.5),cc.CallFunc:create(ChangeBackFunc),cc.FadeIn:create(1.5),cc.DelayTime:create(0.5))))
end

--刷新ball层级
function HeroRecruitOfCampAmation:onUpdateBallZOrder()
	for i ,v in pairs( self.hero_panel) do
		if v:getTag() >= 9 or v:getTag() == 1 then
			v:setVisible(false)
		else
			v:setVisible(true)
		end
	end
	--控制球下面的文字层级，这里的层级有6层，从最外起每层高度递减
	for i ,v in pairs(self.hero_panel) do
		if v:getTag() == 5 then
			v:setLocalZOrder(6)
		elseif v:getTag() == 4 or v:getTag() == 6 then
			v:setLocalZOrder(5)
		elseif v:getTag() == 3 or v:getTag() == 7 then
			v:setLocalZOrder(4)
		elseif v:getTag() == 2 or v:getTag() == 8 then
			v:setLocalZOrder(3)
		elseif v:getTag() == 1 or v:getTag() == 9 then
			v:setLocalZOrder(2)
		elseif v:getTag() == 10 then
			v:setLocalZOrder(1)
		end
	end
end

function HeroRecruitOfCampAmation:onInit()
    local csbHeroRecruitOfHeroAmation = csb.createNode("shop/shop_zhenying_k.csb") 
    local root = csbHeroRecruitOfHeroAmation:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbHeroRecruitOfHeroAmation)

	
	local function moveTouch(sender, eventType)  
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		--print("------",__spoint.x,__mpoint.x)
        if eventType == ccui.TouchEventType.began then
		
		end
		
        if eventType == ccui.TouchEventType.moved then
			-- print("__mpoint.x - __spoint.x",__mpoint.x - __spoint.x)
			-- 这里的80相当于灵敏度
            if __mpoint.x - __spoint.x > 80 then
				state_machine.excute("hero_recruit_of_camp_amation_toplay",0,{"right"})
			end
			
			if __mpoint.x - __spoint.x < -80 then
				state_machine.excute("hero_recruit_of_camp_amation_toplay",0,{"left"})
			end
        end
		if eventType == ccui.TouchEventType.ended then
					--注掉，滑动不松开就会一直划。
			--state_machine.unlock("hero_recruit_of_camp_amation_toplay")
        end
		if eventType == ccui.TouchEventType.canceled then
            
        end	
    end
    local Panel_shop = ccui.Helper:seekWidgetByName(root, "Panel_shop")
	Panel_shop:addTouchEventListener(moveTouch)
	self:initHeroCamp()
	self:initNpc()
	self:initDraw()
	state_machine.unlock("hero_recruit_of_camp_hero_amtion_open")
end

function HeroRecruitOfCampAmation:onEnterTransitionFinish()

end

function HeroRecruitOfCampAmation:init()
	self:onInit()
	return self
end

function HeroRecruitOfCampAmation:onExit()
	ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("images/ui/effice/effect_guangqiu/effect_guangqiu.ExportJson")
	state_machine.remove("hero_recruit_of_camp_amation_toplay")
	state_machine.remove("hero_recruit_of_camp_amation_update_all")
end