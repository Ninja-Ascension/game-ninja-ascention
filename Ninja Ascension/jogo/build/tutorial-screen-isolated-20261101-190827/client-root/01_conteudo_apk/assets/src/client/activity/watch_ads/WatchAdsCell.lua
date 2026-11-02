-- 观看广告(常驻功能)
WatchAdsCell = class("WatchAdsCellClass", Window)

function WatchAdsCell:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.activity.watch_ads.WatchAdsWindow")

    local function init_watch_ads_cell_terminal()
        local watch_ads_cell_open_terminal = {
            _name = "watch_ads_cell_open",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("watch_ads_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新主页按钮可观看动画状态
        local watch_ads_cell_can_see_terminal = {
            _name = "watch_ads_cell_can_see",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    instance:drawEffect()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(watch_ads_cell_open_terminal)
        state_machine.add(watch_ads_cell_can_see_terminal)
        state_machine.init()
    end
    init_watch_ads_cell_terminal()
end

function WatchAdsCell:init(params)
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function WatchAdsCell:onInit(params)
    local csbWatchAdsCell = csb.createNode("activity/icon/activity_advertisement.csb")
    local root = csbWatchAdsCell:getChildByName("root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
    self:addChild(root)
    self:setContentSize(root:getContentSize())

    self:drawBtn()
    self:drawEffect()
end

-- 是否可观看
function WatchAdsCell:canWatchGetAward()
    local canWatch = false
    local dayInfo = dms.searchs(dms["ad_reward"], ad_reward_mould.type, 1)
    local day_max_tence = tonumber(dayInfo[1][ad_reward_mould.limitTence])
    if _ED.user_advertisement_info.day_common_tence < day_max_tence then
        canWatch = true
    end
    return canWatch
end

function WatchAdsCell:drawBtn()
    local root = self.roots[1]
    local Button_advertisement = ccui.Helper:seekWidgetByName(root, "Button_advertisement")
    fwin:addTouchEventListener(
        Button_advertisement,
        nil,
        {
            terminal_name = "watch_ads_cell_open",
            terminal_state = 0,
            isPressedActionEnabled = false
        },
        nil,
        0
    )
end

-- 可观看提示动画
function WatchAdsCell:drawEffect()
    local root = self.roots[1]
    local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
    local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
    Panel_effect:removeAllChildren(true)
    local jsonFile = "images/ui/effice/effect_advertisement/effect_advertisement.json"
    local atlasFile = "images/ui/effice/effect_advertisement/effect_advertisement.atlas"

    if self:canWatchGetAward() then
        Image_1:setVisible(false)
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation:setPosition(cc.p(Panel_effect:getContentSize().width / 2, Panel_effect:getContentSize().height / 2))
        Panel_effect:addChild(animation)
    else
        Image_1:setVisible(true)
    end
end

function WatchAdsCell:createCell()
    local cell = WatchAdsCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function WatchAdsCell:onExit()
    state_machine.remove("watch_ads_cell_open")
end
