if GetResourceState('ox_core'):find('start') then
  if player then
    PlayerLoaded = true
  end

  RegisterNetEvent('ox:playerLoaded', function()
    PlayerLoaded = true
    SendMessage('toggleHud', true)
    InitializeHUD()
  end)

  RegisterNetEvent('ox:playerLogout', function()
    PlayerLoaded = false
    SendMessage('toggleHud', false)
  end)

  AddEventHandler('ox:statusTick', function(values)
    SendMessage('status', values)
  end)
end

if GetResourceState('es_extended'):find('start') then
  RegisterNetEvent('esx:playerLoaded')
  AddEventHandler('esx:playerLoaded', function()
    PlayerLoaded = true
    SendMessage('toggleHud', true)
    InitializeHUD()
  end)

  RegisterNetEvent('esx:onPlayerLogout')
  AddEventHandler('esx:onPlayerLogout', function()
    PlayerLoaded = false
    SendMessage('toggleHud', false)
  end)

  AddEventHandler('esx_status:onTick', function(data)
    local hunger, thirst, stress
    for i = 1, #data do
        if data[i].name == 'thirst' then thirst = math.floor(data[i].percent) end
        if data[i].name == 'hunger' then hunger = math.floor(data[i].percent) end
        if data[i].name == 'stress' then stress = math.floor(data[i].percent) end
    end
  
    SendMessage('status', {
      hunger = hunger,
      thirst = thirst,
      stress = GetConvar('hud:stress', 'false') and stress,
    })
  end)
end