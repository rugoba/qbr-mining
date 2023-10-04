local sharedItems = exports['qbr-core']:GetItems()
local mines
local miningactive = false
local presseddeploy = false
local pressedmine = false
local pressedsmelt = false
local mloactions = {}


Citizen.CreateThread(function()
    
	for mines, v in pairs(Config.MiningLocations) do
		table.insert(mloactions,{kord = v.coords , mined = false })
    end

	local MineBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.MineCord)
	SetBlipSprite(MineBlip, 1220803671, 1)
	SetBlipScale(MineBlip, 0.2)
	Citizen.InvokeNative(0x9CB1A1623062F402, MineBlip, "Mine entrance")

	local DeployBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.MineDeploy)
	SetBlipSprite(DeployBlip, 1220803671, 1)
	SetBlipScale(DeployBlip, 0.2)
	Citizen.InvokeNative(0x9CB1A1623062F402, DeployBlip, "Coal deploy")

	local SmeltBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.MineSmelt)
	SetBlipSprite(SmeltBlip, 1220803671, 1)
	SetBlipScale(SmeltBlip, 0.2)
	Citizen.InvokeNative(0x9CB1A1623062F402, SmeltBlip, "Smelt ore")
end)


function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextFontForCurrentCommand(2)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
	SetTextCentre(centre)
    SetTextDropshadow(1, 150, 20, 0, 255)
	DisplayText(str, x, y)
end

Citizen.CreateThread(function()
	while true do
		Wait(10)
		
		local sleep = true

        for k, v in pairs(mloactions) do
			
			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
            local handwep = Citizen.InvokeNative(0x8425C5F057012DAB,ped)
			local dist = #(pos - v.kord)
			

			if dist < 3.0 and not v.mined and Citizen.InvokeNative(0x79407D33328286C6,handwep) then
				sleep = false
				Citizen.InvokeNative(0x2A32FAA57B937173, 0x07DCE236, v.kord.x, v.kord.y, v.kord.z-0.9, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 99, 23, 23, 150, 0, 0, 2, 0, 0, 0, 0)
				DrawText3D( v.kord.x, v.kord.y, v.kord.z, "Press "..Config.DrawKey.." to start mining")
				----if dist < 0.8 and not v.mined and Citizen.InvokeNative(0x79407D33328286C6,handwep) then
			        -----DrawTxt("Press "..Config.DrawKey.." to start mining", 0.90, 0.54, 0.3, 0.3, true, 255, 255, 255, 255, true) 
					-----DrawSprite("menu_textures", "translate_bg_1a",  0.90, 0.55, 0.13, 0.04, 0.8, 0, 0, 0, 255, 0)
					-----DrawText3D( v.kord.x, v.kord.y, v.kord.z, "Press "..Config.DrawKey.." to start mining")
				----end
			    if IsControlJustReleased(0, Config.Key) and dist < 0.8 and not v.mined and not pressedmine then -- [E]
					pressedmine = true
			    	TriggerEvent('rb94-mine')
					v.mined = true
					Citizen.Wait(5000)
					pressedmine = false
				
				end
			end
			
		end
		if sleep then
			Wait(2000)
			-----print("spawam")
		end
	end
end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())  
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    if onScreen then
    	SetTextScale(0.30, 0.30)
  		SetTextFontForCurrentCommand(2)
    	SetTextColor(255, 255, 255, 215)
    	SetTextCentre(1)
    	DisplayText(str,_x,_y)
    	local factor = (string.len(text)) / 225
    	DrawSprite("menu_textures", "translate_bg_1a", _x, _y+0.0125,0.015+ factor, 0.03,0.8, 0, 0, 0, 250, 0)
    	--DrawSprite("feeds", "toast_bg", _x, _y+0.0125,0.015+ factor, 0.03, 0.1, 100, 1, 1, 190, 0)
    end
end

Citizen.CreateThread(function()
	while true do
		Wait(6000*Config.RefreshTime)
        for k, v in pairs(mloactions) do
			v.mined = false
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(10)
        local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		local kor = Config.MineDeploy
        local dist = #(pos - kor)
		
		if dist < 4.0 and not presseddeploy then
			
			Citizen.InvokeNative(0x2A32FAA57B937173, 0x07DCE236, kor.x, kor.y, kor.z-0.9, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 99, 23, 23, 150, 0, 0, 2, 0, 0, 0, 0)
			DrawText3D(kor.x, kor.y, kor.z, "Press "..Config.DrawKey.." to deploy coal")
			if IsControlJustReleased(0, Config.Key) and dist < 0.8 then -- [E]
				TriggerEvent("triggerInputmenu")
				presseddeploy = true
				Citizen.Wait(5000)
				presseddeploy = false
			end
		else
			Wait(2000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(10)
        local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		local kora = Config.MineSmelt 
        local dist = #(pos - kora)
		
		if dist < 4.0 and not pressedsmelt then
			
			Citizen.InvokeNative(0x2A32FAA57B937173, 0x07DCE236, kora.x, kora.y, kora.z-0.9, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 99, 23, 23, 150, 0, 0, 2, 0, 0, 0, 0)
			DrawText3D(kora.x, kora.y, kora.z, "Press "..Config.DrawKey.." to smelt ore")
			if IsControlJustReleased(0, Config.Key) and dist < 0.8 then -- [E]
				TriggerEvent("triggerInputmenusmelt")
				pressedsmelt = true
				Citizen.Wait(5000)
				pressedsmelt = false
			end
		else
			Wait(2000)
		end
	end
end)


RegisterNetEvent("triggerInputmenu",function()
	
	local input = exports['qbr-input']:ShowInput({
		header = "Amount of coal",
		submitText = "Confirm",
		inputs = {
			{
				type = 'number',
				isRequired = true,
				name = 'realinput',
				text = 'Amount'
			}
		}
	})

	if input == nil or tonumber(input.realinput) < 0 then print("no can do") return end
	
	TriggerServerEvent("rb94_deploy",GetPlayerServerId(PlayerId()),"coal", Config.priceCoal,input.realinput)	
	
end)

RegisterNetEvent("triggerInputmenusmelt",function()
	local ped = PlayerPedId()
	local input = exports['qbr-input']:ShowInput({
		header = "Amount of ore",
		submitText = "Confirm",
		inputs = {
			{
				type = 'number',
				isRequired = true,
				name = 'realinput',
				text = 'Amount'
			}
		}
	})

	if input == nil or tonumber(input.realinput) < 0 then print("no can do") return end
    TriggerServerEvent("rb94_smelt",GetPlayerServerId(PlayerId()),"ore",input.realinput)
end)

RegisterNetEvent("startclscenario",function()
	local ped = PlayerPedId()
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
	TaskStartScenarioInPlace(ped, `WORLD_HUMAN_FEED_PIGS`, 0, true)
	Citizen.Wait(5000)
	ClearPedTasks(ped)
	SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
end)
-------StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
-------AddPointToGpsMultiRoute(-1404.681, 1157.0645, 226.1493)
-------SetGpsMultiRouteRender(true)

RegisterNetEvent('rb94-mine')
AddEventHandler('rb94-mine', function()
	exports['qbr-core']:TriggerCallback('QBCore:HasItem', function(hasItem) 
		if hasItem then
            local player = PlayerPedId()
			
			SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
				
			TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_PICKAXE_WALL'), 0, true, false, false, false)
				
			exports['qbr-core']:Progressbar("majning", "Mining", 30000, false, true, {
					disableMovement = false,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = true,
				}, {}, {}, {}, function()
					ClearPedTasks(player)
				    miningactive = false
			        TriggerServerEvent('rb94-mineRew')
					SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
				
			end)
		else
			exports['qbr-core']:Notify(9, 'you don\'t have a pickaxe!', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
	end, { ['pickaxe'] = 1 })
end)
