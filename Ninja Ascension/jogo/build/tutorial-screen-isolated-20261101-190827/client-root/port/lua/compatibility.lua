-- Probe-only aliases. This does not certify arbitrary recovered modules.
local function run()
    assert(_VERSION == "Lua 5.1", "Recovered runtime requires Lua 5.1 semantics")
    assert(jit and jit.version, "AX_USE_LUAJIT must be enabled")
    assert(ax and ax.FileUtils and ax.Director, "Missing core Axmol bindings")
    cc = ax
    ccui = assert(axui, "Missing UI bindings")
    local files=cc.FileUtils:getInstance()
    function cc.dms_load(path)
        assert(type(path)=="string" and files:isFileExist(path), "dms_load file missing: "..tostring(path))
        return files:getStringFromFile(path)
    end
    local config=cc.dms_load("configs/app.config")
    assert(config:find('"ReleaseProject"%s*:%s*"27"'), "Unexpected original project selection")
    local ok,err=pcall(cc.dms_load,"__missing_probe_file__")
    assert(not ok and err:find("file missing",1,true),"Missing resources must fail visibly")
    print("LUA_CONTRACT_PASSED",jit.version,#config)
end
local ok,err=xpcall(run,debug.traceback)
if not ok then error(err) end
-- executeScriptFile() maps a chunk's return number to its result; make boot success explicit.
return 1
