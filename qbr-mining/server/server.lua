local sharedItems = exports['qbr-core']:GetItems()

RegisterServerEvent('rb94-mineRew')
AddEventHandler('rb94-mineRew', function()
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
	local randomNumber = math.random(1,100)
	
	if randomNumber > 0 and randomNumber <= 50 then
		Player.Functions.AddItem('coal', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, sharedItems['coal'], "add")
		TriggerClientEvent('QBCore:Notify', src, 9, 'you got coal', 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
	elseif randomNumber >= 51 and randomNumber <= 89 then	
		Player.Functions.AddItem('ore', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, sharedItems['ore'], "add")
		Citizen.Wait(1000)
        Player.Functions.AddItem('coal', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, sharedItems['coal'], "add")
		TriggerClientEvent('QBCore:Notify', src, 9, 'you got coal and ore', 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
    elseif randomNumber >= 90 and randomNumber <= 100 then
		Player.Functions.AddItem('ore', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, sharedItems['ore'], "add")
		Citizen.Wait(1000)
        Player.Functions.AddItem('diamond', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, sharedItems['diamond'], "add")
		TriggerClientEvent('QBCore:Notify', src, 9, 'you got diamond and ore', 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
	end
end)

RegisterServerEvent('rb94_deploy')
AddEventHandler('rb94_deploy', function(source,item,cena,amountofitems)
	local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
	local checkitem = Player.Functions.GetItemByName(item)
	if checkitem ~= nil then
		local checkitemamount = Player.Functions.GetItemByName(item).amount
		if tonumber(checkitemamount) >= tonumber(amountofitems) then
			TriggerClientEvent('startclscenario', src)
            Player.Functions.RemoveItem(item,amountofitems)
		    Player.Functions.AddMoney('cash',cena*amountofitems)
			TriggerClientEvent('QBCore:Notify', src, 9, 'You deployed '..amountofitems.."x "..item, 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
        else
			TriggerClientEvent('QBCore:Notify', src, 9, 'dont have that amount of coal!', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
    else
		TriggerClientEvent('QBCore:Notify', src, 9, 'you don\'t have any coal to sell!', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
	end
end)

RegisterServerEvent('rb94_smelt')
AddEventHandler('rb94_smelt', function(source,item,amountofitems)
	local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
	local checkitem = Player.Functions.GetItemByName(item)
	if checkitem ~= nil then
		local checkitemamount = Player.Functions.GetItemByName(item).amount
		if tonumber(checkitemamount) >= tonumber(amountofitems) then
			for c, rew in ipairs(Config.SmeltingItems) do
            Player.Functions.AddItem(rew,amountofitems)
			TriggerClientEvent('inventory:client:ItemBox', src, sharedItems[rew], "add")
			end
			Player.Functions.RemoveItem(item,amountofitems)
			TriggerClientEvent('QBCore:Notify', src, 9, 'You smellted '..amountofitems.."x "..item, 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
        else
			TriggerClientEvent('QBCore:Notify', src, 9, 'dont have that amount of ore!', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
    else
		TriggerClientEvent('QBCore:Notify', src, 9, 'you don\'t have any ore to smellt!', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
	end
end)