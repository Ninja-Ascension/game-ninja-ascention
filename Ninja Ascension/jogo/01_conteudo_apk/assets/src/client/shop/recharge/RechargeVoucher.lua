RechargeVoucher = RechargeVoucher or {}

function RechargeVoucher.getCanUseVoucher(info, callback)
    local rechargeIdx = info.recharge_idx
    local rechargeDimond = info.recharge_dimond

    if rechargeDimond == nil then
        rechargeDimond = dms.int(dms["top_up_goods"], rechargeId, top_up_goods.game_money)
    end
    local canUseInfo = nil
    
    for k,v in pairs(_ED.all_cash_vouchers) do
        local mouldId = v.vouchers_mould_id
        if tonumber(RechargeVoucher.getDimondByMouldId(mouldId)) == tonumber(rechargeDimond) then
            local surplus_time = difftime(v.end_time)
            if surplus_time > 0 then 
                canUseInfo = v
                break
            end
        end
    end
    if canUseInfo then
        RechargeVoucher.goUseVouchers(canUseInfo, nil, callback)
    else
        callback()
    end
end

-- 跳转使用代金券
function RechargeVoucher.goUseVouchers(info, callback, callbackExit)
    local infos = info
    function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            _ED.Voucher_Mode_Flag = false
            -- 刷新列表
            if callback then
                callback()
            end
            
            local getGold = _ED.recharge_result_cheak.recharge_allGame
            TipDlg.drawTextDailog(_string_piece_info[245] .. getGold .. _string_piece_info[246])
        else
            _ED.Voucher_Mode_Flag = false
        end
     
    end
    function showConfirmTip(instance, n)
        if n == 0 then
            _ED.Voucher_Mode_Flag = true
            protocol_command.use_voucher.param_list = "" .. infos.vouchers_temport_id
            NetworkManager:register(protocol_command.use_voucher.code, nil, nil, nil, instance, responseCallback, false, nil)
        elseif n == 3 then 
        else
            if callbackExit then
                callbackExit()
            end
        end
    end
    if callbackExit then 
        local getDimondNums = RechargeVoucher.getDimondByMouldId(infos.vouchers_mould_id)
        app.load("client.shop.recharge.RechargeVoucherUseTip")
        local tip = RechargeVoucherUseTip:new()
        tip:init(instance, showConfirmTip, string.format(tipStringInfo_vouchers_tips[3], tostring(getDimondNums)))
        fwin:open(tip, fwin._ui)
    else
        local getDimondNums = RechargeVoucher.getDimondByMouldId(infos.vouchers_mould_id)
        app.load("client.shop.recharge.RechargeVoucherTip")
        local tip = RechargeVoucherTip:new()
        tip:init(instance, showConfirmTip, string.format(tipStringInfo_vouchers_tips[3], tostring(getDimondNums)))
        fwin:open(tip, fwin._ui)
    end
end

-- 跳转出售代金券
function RechargeVoucher.goSellVouchers(info, callback)
    local infos = info
    function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            -- 刷新列表
            app.load("client.reward.DrawRareReward")
            local getRewardWnd = DrawRareReward:new()
            getRewardWnd:init(7)
            fwin:open(getRewardWnd, fwin._windows)
            if callback then
                callback()
            end
        end
    end
    function showConfirmTip(instance, n)
        if n == 0 then
            protocol_command.sell_voucher.param_list = "" .. infos.vouchers_temport_id
            NetworkManager:register(protocol_command.sell_voucher.code, nil, nil, nil, instance, responseCallback, false, nil)
        end
    end
    app.load("client.utils.ConfirmTip")
    local tip = ConfirmTip:new()
    tip:init(instance, showConfirmTip, tipStringInfo_vouchers_tips[4])
    fwin:open(tip, fwin._ui)
end

-- 根据mouldId获得钻石数
function RechargeVoucher.getDimondByMouldId(mouldId)
    local rechargeId = dms.int(dms["vouchers_mould"], tonumber(mouldId), warehouse_vouchers_mould.recharge_id)
    local game_money = dms.string(dms["top_up_goods"], rechargeId, top_up_goods.game_money)
    return game_money
end
