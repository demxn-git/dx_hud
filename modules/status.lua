StatusLoop = function()
  CreateThread(function()
    local hunger, thirst, stress

    while ESX.PlayerLoaded do

      TriggerEvent('esx_status:getStatus', 'hunger', function(status) hunger = status.val / 10000 end)
      TriggerEvent('esx_status:getStatus', 'thirst', function(status) thirst = status.val / 10000 end)
      if dx.stress then TriggerEvent('esx_status:getStatus', 'stress', function(status) stress = status.val / 10000 end) end

      SendNUIMessage({
        action = 'status',
        hunger = hunger,
        thirst = thirst,
        stress = dx.stress and stress,
      })

      Wait(dx.statusRefreshRate)
    end
  end)
end