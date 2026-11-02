local M={}
function M.armar()
    -- Android already implements (path, callback, target, flags...). Only
    -- Axmol needs translation to its shorter (path, callback) signature.
    if cc.Application and cc.PLATFORM_OS_ANDROID
        and cc.Application:getInstance():getTargetPlatform()==cc.PLATFORM_OS_ANDROID then return end
    local class=cc.TextureCache
    if class.__nr_legacy_async then return end
    local original=assert(class.addImageAsync)
    class.__nr_legacy_async=true
    class.addImageAsync=function(self,path,callback,...)
        if select('#',...)==0 then return original(self,path,callback) end
        local target=select(1,...)
        assert(type(callback)=='function','Legacy texture callback missing')
        return original(self,path,function(texture) callback(target,texture) end)
    end
end
function M.testMenuLoader()
    app.load('client.utils.Loading')
    local count=0
    Loading.loading({_pic={'images/ui/login/fb_icon.png'},_plist={},_ui={}},function()
        count=count+1
        assert(count==1,'Menu resource completion repeated')
        assert(Loading.loadCount==0,'Menu resource load count not drained')
        print('MENU_RESOURCE_LOADING_PASSED original Loading.loading and native async callback')
    end,nil)
end
return M
