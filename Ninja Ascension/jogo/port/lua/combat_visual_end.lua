local M={}
function M.clear()
    local qte=fwin:find('FightQTEControllerClass')
    if qte and qte.totalHurtRoot and type(qte.updateDrawPowerSkillTotalDamage)=='function' then
        qte:updateDrawPowerSkillTotalDamage(0)
    end
end
function M.install(class,method,before)
    if type(class)~='table' or class['__nr_visual_end_'..method] then return end
    local original=class[method]
    if type(original)~='function' then return end
    class['__nr_visual_end_'..method]=true
    class[method]=function(self,...)
        if before then M.clear() end
        local result={original(self,...)}
        if not before then M.clear() end
        return unpack(result)
    end
end
return M
