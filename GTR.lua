-- GoldTradeResponder.lua

-- Default dungeon run cost (you can adjust this to any initial value)
local dungeonRunCost = 100  -- Default cost of a dungeon run

-- Function to handle trade updates
local function OnTradeUpdate(self, event, arg1)
    -- Check if trade has gold involved
    local tradeGoldAmount = GetTradePlayerMoney()

    -- If there's gold in the trade
    if tradeGoldAmount > 0 then
        local gold = tradeGoldAmount / 10000  -- Convert from copper to gold (1 gold = 10,000 copper)
        print("Gold traded: " .. gold .. "g")

        -- Calculate how many dungeon runs the gold traded can cover
        local runsCovered = gold / dungeonRunCost

        -- Get the name of the person you are trading with
        local traderName = UnitName("target")  -- Assuming the player targets the person they are trading with

        -- Send a message to the player who traded you the gold
        if traderName then
            -- Send a whisper with the dungeon run calculation
            SendChatMessage(
                string.format(
                    "Thank you for the %dg! That covers %.2f dungeon run(s) at %dg per run. Thanks, %s!",
                    gold, runsCovered, dungeonRunCost, traderName
                ),
                "WHISPER", nil, traderName
            )
        end
    end
end

-- Register the event listener for the trade update event
local frame = CreateFrame("Frame")
frame:RegisterEvent("TRADE_SHOW")  -- Fires when a trade window is opened
frame:RegisterEvent("TRADE_CLOSED") -- Fires when the trade window is closed
frame:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED") -- Fires when the player adds/removes items
frame:RegisterEvent("TRADE_PLAYER_MONEY") -- Fires when money is added to the trade

-- Attach the event handler to the frame
frame:SetScript("OnEvent", OnTradeUpdate)

-- Function to handle the slash command for changing dungeon run cost
local function SetDungeonRunCostHandler(msg)
    local newCost = tonumber(msg)
   
    if newCost and newCost > 0 then
        dungeonRunCost = newCost
        print("Dungeon run cost set to " .. dungeonRunCost .. "g.")
    else
        print("Invalid cost. Please enter a positive number.")
    end
end

-- Register the slash command "/setdungeoncost"
SLASH_SETDUNGEONCOST1 = "/setdungeoncost"
SlashCmdList["SETDUNGEONCOST"] = SetDungeonRunCostHandler

-- Notify when the addon is loaded
print("Gold Trade Responder loaded. Listening for gold trades.")
print("Use /setdungeoncost <amount> to change the dungeon run cost.")
