local _, L = ...;
local frame = CreateFrame("FRAME", "mySellAll")
frame:RegisterEvent("MERCHANT_SHOW")
frame:RegisterEvent("MERCHANT_CLOSED")
--frame:RegisterEvent("LOOT_BIND_CONFIRM")

--local busy = false
--local OnSend = false
local bag, slot

local beginmoney
local endmoney
local show

local function ToMoney(Coppers)
	 local FlMinus = false
         if Coppers < 0 then FlMinus=true end
         if FlMinus then Coppers = Coppers * (-1) end
         local Gold = math.floor(Coppers / 10000)
         local Silver = math.floor(Coppers / 100) % 100 
         local Copper = Coppers % 100 
         local ret = ""
         if FlMinus then  ret = ((Gold ~= 0) and ("|cFFFF0000" .. Gold .. "g |r") or "") .. (((Silver ~= 0) or (Gold ~= 0)) and ("|cFFFF0000" .. Silver .. "s |r") or "") .. ("|cFFFF0000" .. Copper .. "c|r") 
           else ret = ((Gold ~= 0) and ("|cffffd700" .. Gold .. "g |r") or "") .. (((Silver ~= 0) or (Gold ~= 0)) and ("|cffc7c7cf" .. Silver .. "s |r") or "") .. ("|cffeda55f" .. Copper .. "c|r") end
         return ret
end

local function eventHandler(self, event, ...)
	--[[
	local arg1 = ...
	if event == "LOOT_BIND_CONFIRM" and GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0 then
		slot2loot[arg1] = true
		print("BoPingEvent " .. arg1)
		return
	end
	]]
	
	if event == "MERCHANT_SHOW" then
		show = 0
		beginmoney = GetMoney()
		--sell all junk
		for bag = 0, 4 do
					if GetContainerNumSlots(bag) > 0 then
						for slot = 1, GetContainerNumSlots(bag) do
							local texture, itemCount, locked, quality = GetContainerItemInfo(bag, slot)
							local link = GetContainerItemLink(bag, slot)
							if link then
								local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(link)
								if itemRarity == 0 and itemSellPrice > 0 then
									UseContainerItem(bag, slot)
								end
							end
						end
					end
				end
		--repair
		if (CanMerchantRepair()) then
					--guild repair
					if (CanGuildBankRepair()==1) then
					RepairAllItems(1)
					end
					--self repair
					RepairAllItems()
		end
	end
	
	if event == "MERCHANT_CLOSED" then
	show = show+1
		if (show==1) then
			endmoney = GetMoney()
			local raznica=(endmoney - beginmoney)
			if raznica>0 then
					print(L["Result "] .. "|TInterface\\Icons\\INV_Misc_Coin_01:16|t " .. ToMoney(raznica))
			end
			if raznica<0 then
					print(L["Result "] .. "|cFFFF0000 -|r " .. ToMoney(raznica))
			end
		end
	end

	--[[
	local goflag
    local countsell=0
	local cost=0
	if (not busy) and (not IsShiftKeyDown()) then
		busy = true
		if event == "MERCHANT_SHOW" then
			for bag = 0, 4 do
				if GetContainerNumSlots(bag) > 0 then
					for slot = 1, GetContainerNumSlots(bag) do
						local texture, itemCount, locked, quality = GetContainerItemInfo(bag, slot)
						local link = GetContainerItemLink(bag, slot)
						if link then
							local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(link)
							if itemRarity == 0 and itemSellPrice > 0 then
								UseContainerItem(bag, slot)
								-- print("[" .. itemName .. "]х" .. itemCount .. " за " .. ToMoney(itemSellPrice*itemCount))
								countsell = countsell + (itemSellPrice*itemCount)
							end
						end
					end
				end
			end
			if (countsell~=0) then
			print(L["Sell "] .. ToMoney(countsell))
			end

			if CanMerchantRepair() then
				cost = GetRepairAllCost()
				if (CanGuildBankRepair()==1) then
				--print("Guild repair aviable")
				RepairAllItems(1)
				end
				if cost > 0 then
					local money = GetMoney()
					if money > cost then
						RepairAllItems()
						if (cost~=0) then
						print(L["Repair "] .. ToMoney(cost))
						end
					else
						if (cost~=0) then
						print(L["Too little money for repair "])
						end
					end
				end
		
			end
			if (countsell~=0 or cost~=0) then
				local raznica=(countsell - cost)
					if raznica>0 then
					print(L["Result "] .. "|TInterface\\Icons\\INV_Misc_Coin_01:16|t " .. ToMoney(raznica))
					end
					if raznica<0 then
					print(L["Result "] .. "|cFFFF0000 -|r " .. ToMoney(raznica))
					end
			end
		end
		busy = false
	end
	]]
	--return
end

--[[
local function DoTheStuff()

	if UIParent:IsEventRegistered("LOOT_BIND_CONFIRM") then
		UIParent:UnregisterEvent("LOOT_BIND_CONFIRM")
	end

		for i in pairs(slot2loot) do
			ConfirmLootSlot(i)
			print("Confirm " .. i)
			LootSlot(i+1)
			slot2loot[i] = nil
		end
end
]]

frame:SetScript("OnEvent", eventHandler)
frame:SetScript("OnUpdate", DoTheStuff)

OptPanel = CreateFrame( "Frame", "mySellAllOptions", UIParent );
OptPanel.name = "mySellAll";
local AAA = CreateFrame('CheckButton', "Sencored", OptPanel, 'InterfaceOptionsCheckButtonTemplate')
AAA:SetPoint('TOPLEFT', 10, -72)


InterfaceOptions_AddCategory(OptPanel);

SLASH_MYSELLALL1 = "/msa"
SlashCmdList["MYSELLALL"] = function()
	InterfaceOptionsFrame_OpenToCategory(OptPanel)
end
