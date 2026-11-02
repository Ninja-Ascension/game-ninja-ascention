-- Engine shaders must survive ALL search-path replacements, including the
-- direct FileUtils calls in app.init/update (not only app.setSearchPaths).
local M={}
local function normalized(path)return path:gsub('\\','/'):gsub('/+$','') end
function M.install(root)
    if M.installed then return end
    local files=cc.FileUtils:getInstance()
    local directory
    for _,path in ipairs({root..'/build/windows-probe-native/runtime/axslc',
                          root..'/build/windows-probe-native/bin/NinjaResourceProbe/Debug/axslc'}) do
        if files:isFileExist(path..'/positionColorLengthTexture_vs')
            and files:isFileExist(path..'/positionColorLengthTexture_fs') then directory=path;break end
    end
    assert(directory,'Engine shader binaries missing from runtime and executable directories')
    M.directory=directory;M.installed=true
    local original=cc.FileUtils.setSearchPaths
    assert(type(original)=='function','FileUtils search-path setter missing')
    cc.FileUtils.setSearchPaths=function(self,paths)
        local copy={};local found=false
        for _,path in ipairs(paths) do
            copy[#copy+1]=path
            if normalized(path)==normalized(directory) then found=true end
        end
        if not found then copy[#copy+1]=directory end
        return original(self,copy)
    end
    files:setSearchPaths(files:getSearchPaths())
    print('HOST_ENGINE_SHADER_PATH protected '..directory)
end
return M
