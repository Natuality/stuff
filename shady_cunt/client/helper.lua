ShadyCunt = {}

ShadyCunt.ShowAlert = function(message, playNotificationSound)
    SetTextComponentFormat('STRING')
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, 0, playNotificationSound, -1)
end

ShadyCunt.ShowNotification = function(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(true, false)
end

ShadyCunt.StartJob = function(coordinates, heading)



    local start = startJob(coordinates, heading)


    return start
end

ShadyCunt.CreateBlip = function(coordinates, name, spriteId, colorId, scale)
	local blip = AddBlipForCoord(coordinates)

	SetBlipSprite(blip, spriteId)
	SetBlipColour(blip, colorId)
	SetBlipScale(blip, scale)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)

	return blip
end

ShadyCunt.CreateRouteBlip = function(coordinates)
	local blip = AddBlipForCoord(coordinates)

	SetBlipSprite(blip, 57)
	SetBlipColour(blip, 5)
	SetBlipScale(blip, 0.30)
	SetBlipRoute(blip,  true)

	return blip
end

--
-- Events
--

RegisterNetEvent('shady_cunt:helper:showAlert')
AddEventHandler('shady_cunt:helper:showAlert', function(message, playNotificationSound)
	ShadyCunt.ShowAlert(message, playNotificationSound)
end)

RegisterNetEvent('shady_cunt:helper:showNotification')
AddEventHandler('shady_cunt:helper:showNotification', function(message)
	ShadyCunt.ShowNotification(message)
end)