-- Keep the recovered language packs ahead of common/base resources.
local M={}
function M.apply(language)
    local files=cc.FileUtils:getInstance()
    language=language or cc.UserDefault:getInstance():getStringForKey('current_language','pt_BR')
    if language=='' then language='pt_BR' end
    if language=='pt-BR' or language=='pt' then language='pt_BR' end
    local base=M.root..'/01_conteudo_apk/assets/res/language/'
    local paths={}
    for _,path in ipairs(files:getSearchPaths()) do
        if not path:gsub('\\','/'):find('res/language/',1,true) then paths[#paths+1]=path end
    end
    if files:isDirectoryExist(base..'comun') then table.insert(paths,1,base..'comun') end
    if files:isDirectoryExist(base..language) then table.insert(paths,1,base..language) end
    files:setSearchPaths(paths)
    files:purgeCachedEntries()
    local tip=files:fullPathForFilename('data/TipStringInfo.lua')
    if files:isFileExist(tip) and M.loadedLanguage~=language then
        local source=files:getStringFromFile(tip)
        local fn=assert(loadstring(source,'@'..tip));fn()
        M.loadedLanguage=language
    end
    M.language=language
    print('LOCAL_LANGUAGE_ASSETS '..language..' '..files:fullPathForFilename('data/TipStringInfo.lua'))
end
function M.install(root)
    M.root=root
    if not M.installed then
        M.installed=true
        local original=app.setSearchPaths
        app.setSearchPaths=function(language,...)
            local result=original(language,...)
            if result then M.apply(language) end
            return result
        end
    end
    M.apply()
end
return M
