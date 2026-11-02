blowfish = blowfish or {}

function blowfish:setKey(_key)
    if not _key or type(_key) ~= "string" then
        _key = ""
    end
    if _key ~= "" then
        blowfish._key = _key
        if not blowfish._entry then
            blowfish._entry = cc.CBlowFish:new(_key)
        else
            blowfish._entry:setKey(_key)
        end
    end
end

function blowfish:encrypt(_in)
    return blowfish._entry:Encrypt(_in)
end

function blowfish:decrypt(_in)
    return blowfish._entry:Decrypt(_in)
end


return blowfish