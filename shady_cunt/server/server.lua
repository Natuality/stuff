--
-- Functions
--

function getMoney(playerId)
	-- Insert your framework's method here.

	return 10000
end

function addMoney(playerId, amount)
	-- Insert your framework's method here.

	return true
end


-- Payment Function

RegisterNetEvent('shady_cunt:drugsDelievered')
AddEventHandler('shady_cunt:drugsDelievered', function(totalRouteDistance)
	local playerId = source
	local payout   = math.floor(totalRouteDistance * Config.PayPerMeter)

	addMoney(playerId, payout)

	TriggerClientEvent('shady_cunt:helper:showNotification', playerId, 'Here is ~g~$' .. payout .. '~s~ from your drug run. Now scam, get outta here quick!')
end)

-- Job start Function

RegisterNetEvent('shady_cunt:drugsPickedUp')
AddEventHandler('shady_cunt:drugsPickedUp', function()
	local playerId = source

TriggerClientEvent('shady_cunt:startJob', playerId)
end)

RegisterNetEvent('shady_cunt;drugsPickedUp')
AddEventHandler('shady_cunt;drugsPickedUp', function()
	local playerId = source


	TriggerClientEvent('shady_cunt;startJob', playerId)
  
end)

RegisterNetEvent('shady_cunt:return')
AddEventHandler('shady_cunt:return', function()
	local playerId = source

	addMoney(playerId, Config.FinishPayment)

	TriggerClientEvent('shady_cunt:helper:showNotification', playerId, 'Thanks for the help, here is $' .. Config.TruckRentalPrice .. ' for helping me out.')
end)