-- Disable educational missions at their entry point, not merely their art.
local source=debug.getinfo(1,'S').source:gsub('^@',''):gsub('\\','/')
local function read(path)
    local file=path and io.open(path,'r')
    if not file then return nil end
    local value=file:read('*a');file:close();return value
end
local root=os.getenv('NR_GAME_ROOT')
local text=root and read(root..'/port/gameplay.json')
if not text or text=='' then
    local path=source:gsub('/lua/[^/]+$','/gameplay.json')
    if path~=source then text=read(path) end
end
if not text or text=='' then
    -- Android: the file is inside the APK (assets/src/port/gameplay.json).
    text=cc.FileUtils:getInstance():getStringFromFile('src/port/gameplay.json')
end
if not text or text=='' then
    -- The Android loader can resolve Lua assets even when FileUtils cannot
    -- read the JSON through its native search paths. Generated from the same
    -- gameplay.json during APK packaging; never substitute default settings.
    local ok,packed=pcall(require,'nr_gameplay_config')
    if ok then text=packed end
end
assert(type(text)=='string' and text~='','gameplay.json ausente')
local config=json.decode(text)
local override=os.getenv('NR_ENABLE_TUTORIAL')
local M={enabled=os.getenv('NR_PROBE_TEST_MODE') and override=='1' or false}
function M.install()
    if M.enabled then return end
    if state_machine and state_machine._terminals then
        for name,terminal in pairs(state_machine._terminals) do
            if type(name)=='string' and type(terminal)=='table' and name:find('tuition',1,true) then
                terminal._invoke=function() return false end
            end
        end
    end
    if rawget(_G,'Menu') and not rawget(_G,'Loading') then app.load('client.utils.Loading') end
    if not M.loginChecked and not os.getenv('NR_PROBE_TEST_MODE') then
        M.loginChecked=true
        local ud=cc.UserDefault:getInstance()
        if ud:getIntegerForKey('nr_account_reset_version',0)<config.account_reset_version then
            for _,key in ipairs({'name_local','pass_local','platform_account_Automatic_login'}) do ud:setStringForKey(key,'') end
            ud:setStringForKey('account_automatic_login','1')
            ud:setIntegerForKey('nr_account_reset_version',config.account_reset_version)
            ud:flush()
        end
    end
    local execute=rawget(_G,'executeMissionExt')
    if type(execute)=='function' and execute~=M.wrapper then
        M.wrapper=function(mould,...)
            if mould==mission_mould_tuition or mould==mission_mould_battle then return false end
            return execute(mould,...)
        end
        executeMissionExt=M.wrapper
    end
end
return M
