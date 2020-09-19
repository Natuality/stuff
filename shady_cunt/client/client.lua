local jobStatus    		 = CONST_NOTWORKING
local currentRoute          = nil
local currentDestination    = nil
local routeBlip             = nil
local totalRouteDistance    = nil
local lastDropCoordinates   = nil
local jobID                 = nil 

--
-- Threads
--

Citizen.CreateThread(function()
	ShadyCunt.CreateBlip(Config.JobStart.Coordinates, 'Trucking', Config.Blip.SpriteID, Config.Blip.ColorID, Config.Blip.Scale)

	while true do
		Citizen.Wait(0)

		local playerId             = PlayerPedId()
		local playerCoordinates    = GetEntityCoords(playerId)
		local distanceFromJobStart = GetDistanceBetweenCoords(playerCoordinates, Config.JobStart.Coordinates, false)
		local sleep                = 1000
    
    if distanceFromJobStart < Config.Marker.DrawDistance then
			sleep = 0
		
			DrawMarker(Config.Marker.Type, Config.JobStart.Coordinates, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.Size,  Config.Marker.Color.r, Config.Marker.Color.g, Config.Marker.Color.b, 100, false, true, 2, false, nil, nil, false)

			if distanceFromJobStart < Config.Marker.Size.x then
        
				elseif not IsPedInAnyVehicle(playerId, false) then
					ShadyCunt.ShowAlert('Press ~INPUT_PICKUP~ to pickup drugs', true)

					if IsControlJustReleased(0, 38) then
						TriggerServerEvent('shady_cunt:drugsPickedUp')
					end
				end
			end
		end
    
    		if jobStatus ~= CONST_NOTWORKING then
			sleep = 0

			if jobStatus == CONST_WAITINGFORTASK then
				assignTask()
			elseif jobStatus == CONST_PICKINGUP then
				pickingUpThread(playerId, playerCoordinates)
			elseif jobStatus == CONST_DELIVERING then
				deliveringThread(playerId, playerCoordinates)
			end
		
			-- Abort Hotkey
			if IsControlJustReleased(0, Config.AbortKey) then
				abortJob()
			end
		end
    
    
    function pickingUpThread(playerId, playerCoordinates)
	if not GetDistanceBetweenCoords(playerCoordinates, currentRoute.PickupCoordinates, true) < 100.0 then
		trailerId = ShadyCunt.SpawnVehicle(currentRoute.TrailerModel, currentRoute.PickupCoordinates, currentRoute.PickupHeading)
	end

	if trailerId and IsEntityAttachedToEntity(trailerId, truckId) then
		RemoveBlip(routeBlip)
		ShadyCunt.CreateRouteBlip(currentDestination)

		ShadyCunt.ShowNotification('Take the delivery to the ~y~drop off point~s~.')

		jobStatus = CONST_DELIVERING
	end
end



function deliveringThread(playerId, playerCoordinates)
	local distanceFromDelivery = GetDistanceBetweenCoords(playerCoordinates, currentDestination, true)

	if distanceFromDelivery < Config.Marker.DrawDistance then
		DrawMarker(Config.Marker.Type, currentDestination, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.Size,  Config.Marker.Color.r, Config.Marker.Color.g, Config.Marker.Color.b, 100, false, true, 2, false, nil, nil, false)	
	
		if distanceFromDelivery < Config.Marker.Size.x then
			ShadyCunt.ShowAlert('Press ~INPUT_PICKUP~ to deliver the package.', true)

			if IsControlJustReleased(0, 38) then
				TriggerServerEvent('shady_cunt:drugsDelievered', totalRouteDistance)
				cleanupTask()
			end
		end
	end
end

    
    
    function cleanupTask()


	RemoveBlip(routeBlip)


	routeBlip          = nil
	currentDestination = nil
	currentRoute       = nil

	jobStatus = CONST_WAITINGFORTASK
end
    
    
    
    function abortJob()
	DoScreenFadeOut(500)
	Citizen.Wait(500)


	if routeBlip then
		RemoveBlip(routeBlip)
	end


	routeBlip			= nil
	currentDestination  = nil
	currentRoute        = nil
	lastDropCoordinates = nil
	totalRouteDistance  = nil

	Citizen.Wait(500)
	DoScreenFadeIn(500)
end
    
    
    
    
    function assignTask()
	currentRoute       = Config.Routes[math.random(1, #Config.Routes)]
	currentDestination = currentRoute.Destinations[math.random(1, #currentRoute.Destinations)]
	routeBlip          = ShadyCunt.CreateRouteBlip(currentRoute.PickupCoordinates)

	local distanceToPickup   = GetDistanceBetweenCoords(lastDropCoordinates, currentRoute.PickupCoordinates)
	local distanceToDelivery = GetDistanceBetweenCoords(currentRoute.PickupCoordinates, currentDestination)

	totalRouteDistance  = distanceToPickup + distanceToDelivery
	lastDropCoordinates = currentDestination

	ShadyCunt.ShowNotification('Head to the ~y~pickup~s~ on your GPS.')

	jobStatus = CONST_PICKINGUP
end
    
   
   
   RegisterNetEvent('shady_cunt:startJob')
AddEventHandler('shady_cunt:startJob', function()
	local playerId = PlayerPedId()

	jobID = ShadyCunt.StartJob( Config.JobStart.Coordinates, Config.JobStart.Heading)



	lastDropCoordinates = Config.JobStart.Coordinates

	jobStatus = CONST_WAITINGFORTASK
end)