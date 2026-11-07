-- Need Confirm: asks "are you sure?" before a Need roll on group loot.
--
-- Instead of hooking a specific loot frame, the global RollOnLoot is wrapped.
-- That catches the Blizzard group loot frame as well as any other roll UI,
-- no matter how the frame is built. RollOnLoot is not protected, so
-- replacing it does not block anything.

local ROLL_NEED = 1
local POPUP = "NEEDCONFIRM_ROLL"

-- {need} is replaced with the client's own word for Need (global NEED),
-- %s with the item link.
local TEXTS = {
    enUS = "Really roll {need} on\n%s?",
    deDE = "Wirklich auf {need} würfeln für\n%s?",
    frFR = "Voulez-vous vraiment choisir {need} pour\n%s ?",
    esES = "¿Seguro que quieres tirar {need} por\n%s?",
    esMX = "¿Seguro que quieres tirar {need} por\n%s?",
    itIT = "Vuoi davvero tirare {need} per\n%s?",
    ptBR = "Quer mesmo rolar {need} para\n%s?",
    ruRU = "Точно выбрать «{need}» для\n%s?",
    koKR = "%s\n정말 {need}을(를) 선택하시겠습니까?",
    zhCN = "确定要对\n%s\n选择{need}吗？",
    zhTW = "確定要對\n%s\n選擇{need}嗎？",
}

-- Only used if the client has no global NEED string.
local NEED_WORDS = {
    enUS = "Need",
    deDE = "Bedarf",
    frFR = "Besoin",
    esES = "Necesidad",
    esMX = "Necesidad",
    itIT = "Necessità",
    ptBR = "Necessidade",
    ruRU = "Мне это нужно",
    koKR = "입찰",
    zhCN = "需求",
    zhTW = "需求",
}

local locale = GetLocale()
if locale == "enGB" then
    locale = "enUS"
end
local needWord = (type(NEED) == "string" and NEED ~= "") and NEED or NEED_WORDS[locale] or NEED_WORDS.enUS
local text = (TEXTS[locale] or TEXTS.enUS):gsub("{need}", function()
    return "|cffffd100" .. needWord .. "|r"
end)

local originalRollOnLoot = RollOnLoot

StaticPopupDialogs[POPUP] = {
    text = text,
    button1 = YES,
    button2 = NO,
    OnAccept = function(_, rollID)
        originalRollOnLoot(rollID, ROLL_NEED)
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    showAlert = true,
    preferredIndex = 3,
}

-- Bind-on-pickup items already get Blizzard's own confirmation ("will bind to
-- you"), so a second question would be redundant. Leatrix Plus can switch that
-- Blizzard dialog off ("Disable loot warnings"); then we ask ourselves.
local function BlizzardAsksAnyway(rollID)
    local _, _, _, _, bindOnPickUp = GetLootRollItemInfo(rollID)
    if not bindOnPickUp then
        return false
    end
    if type(LeaPlusDB) == "table" and LeaPlusDB["NoConfirmLoot"] == "On" then
        return false
    end
    return true
end

RollOnLoot = function(rollID, rollType, ...)
    if rollType == ROLL_NEED and not IsShiftKeyDown() and not BlizzardAsksAnyway(rollID) then
        local link = GetLootRollItemLink(rollID) or UNKNOWN
        StaticPopup_Hide(POPUP)
        StaticPopup_Show(POPUP, link, nil, rollID)
        return
    end
    return originalRollOnLoot(rollID, rollType, ...)
end

-- Close the question when the roll ends (timeout, or rolled elsewhere).
local frame = CreateFrame("Frame")
frame:RegisterEvent("CANCEL_LOOT_ROLL")
frame:SetScript("OnEvent", function(_, _, rollID)
    StaticPopup_Hide(POPUP, rollID)
end)
