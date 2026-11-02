local M={}
local pending
local scheduled
local entering
local function ready()
    local class=rawget(_G,'LDuplicateWindow')
    return class and fwin:find('LDuplicateWindowClass') and class._pageViews
        and class._pageViewsElite and class._pageViewsEm
end
local function deferEntry()
    if scheduled or not pending or not ready() then return end
    local scheduler=cc.Director:getInstance():getScheduler()
    scheduled=scheduler:scheduleScriptFunc(function()
        scheduler:unscheduleScriptEntry(scheduled);scheduled=nil
        if pending and ready() then
            local args=pending;pending=nil
            state_machine.unlock('lduplicate_window_pve_quick_entrance')
            state_machine.excute('lduplicate_window_pve_quick_entrance',unpack(args))
        end
    end,0,false)
end
function M.install()
    if ccui.PageView then
        ccui.PageView.getPages=ccui.PageView.getPages or function(self) return self:getItems() end
        ccui.PageView.getPage=ccui.PageView.getPage or function(self,index) return self:getItem(index) end
        ccui.PageView.getCurPageIndex=ccui.PageView.getCurPageIndex or function(self) return self:getCurrentPageIndex() end
    end
    if ccui.PageView and not ccui.PageView.setCustomScrollThreshold then
        -- Axmol replaced the Cocos 3.5 distance threshold with magnetic paging.
        -- Preserve the original map's short swipe gesture through public APIs.
        ccui.PageView.setCustomScrollThreshold=function(self,distance)
            assert(type(distance)=='number' and distance>0,'Invalid page threshold')
            self:addTouchEventListener(function(view,event)
                if event==0 then
                    view.__nr_page_start=view:getCurPageIndex()
                elseif event==2 then
                    local first=view:getTouchBeganPosition()
                    local last=view:getTouchEndPosition()
                    local dx=last.x-first.x
                    local count=#view:getPages()
                    if math.abs(dx)>=distance and count>0 then
                        local index=(view.__nr_page_start or view:getCurPageIndex())+(dx<0 and 1 or -1)
                        view:scrollToPage(math.max(0,math.min(count-1,index)))
                    end
                end
            end)
        end
    end
    if ccui.RichText and not ccui.RichText.formatTextExt then
        ccui.RichText.formatTextExt=function(self) return self:formatText(true) end
    end
    local class=rawget(_G,'LDuplicateWindow')
    if class and type(class.onEnterTransitionFinish)=='function' and not class.__nr_pve_ready
        and (not class.super or class.onEnterTransitionFinish~=class.super.onEnterTransitionFinish) then
        class.__nr_pve_ready=true
        print('HOST_PVE_READY installed after class definition')
        local original=class.onEnterTransitionFinish
        class.onEnterTransitionFinish=function(self,...)
            local args={...}
            entering=true
            local result={xpcall(function() return original(self,unpack(args)) end,debug.traceback)}
            entering=false
            if not result[1] then
                print('HOST_PVE_READY FAILED '..tostring(result[2]))
                error(result[2],0)
            end
            print('HOST_PVE_READY entered pending='..tostring(pending~=nil)
                ..' pages='..tostring(class._pageViews~=nil)..'/'..tostring(class._pageViewsElite~=nil)
                ..'/'..tostring(class._pageViewsEm~=nil))
            if pending and ready() then
                print('HOST_PVE_READY resuming original chapter entry')
                deferEntry()
            end
            return unpack(result,2)
        end
    end
    -- The class is defined after the first boot call. Retry that hook above,
    -- while installing global lookup/dispatch wrappers only once below.
    local envolveu = class ~= nil and class.__nr_pve_ready == true
    -- Global adapters install once; the class hook above remains retryable.
    if package.__nr_pve_global_adapters then return envolveu end
    package.__nr_pve_global_adapters=true
    local aliases={PageView_pve_map='PageView_pve_map_pr2',
        PageView_pve_map_jy='PageView_pve_map_jy_pr2',PageView_pve_map_em='PageView_pve_map_em_pr2'}
    local seek=ccui.Helper.seekWidgetByName
    ccui.Helper.seekWidgetByName=function(self,root,name)
        if name==nil and type(root)=='string' then name=root;root=self;self=ccui.Helper end
        if root==nil or name==nil then return nil end
        local node=seek(self,root,name)
        if not node and aliases[name] then node=seek(self,root,aliases[name]) end
        return node
    end
    local execute=state_machine.excute
    state_machine.excute=function(name,...)
        if name=='lduplicate_window_pve_quick_entrance' and (entering or not ready()) then
            app.load('client.landscape.duplicate.LDuplicateWindow')
            pending={...}
            if not fwin:find('LDuplicateWindowClass') then
                execute('lduplicate_window_manager',0,{1,1})
            end
            deferEntry()
            return true
        end
        return execute(name,...)
    end
    -- Só considera concluído quando a classe já existia e foi envolvida.
    -- Enquanto a classe não carregar, cada nova chamada tenta de novo (o
    -- `M.install` é chamado pelo app.load de Menu/LDuplicateWindow).
    if envolveu then
        package.__nr_pve_entry_ready = true
        print('HOST_PVE_READY installed after class definition')
    else
        print('HOST_PVE_READY aliases/execute armed; waiting for LDuplicateWindow')
    end
    return envolveu
end
return M
