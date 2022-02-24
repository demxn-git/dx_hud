cinematic = false

if cfg.menu.enabled then
  local toggled = false
  function HUDMenu()
    local elements = {}

    table.insert(elements, {label = 'Toggle Cinematic Mode', value = 'cinematic'})

    ESX.UI.Menu.Open('default', currentResourceName, 'hud', {
        title    = "HUD Menu",
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value =='cinematic' then
            cinematic = not cinematic
            SendMessage('setCinematic', cinematic)
        end
    end, function(data, menu)
        menu.close()
        toggled = false
    end)
  end

  RegisterCommand('hudmenu', function()
    if ESX.PlayerLoaded then
      if not toggled then
        ESX.UI.Menu.CloseAll()
        HUDMenu()
      else ESX.UI.Menu.Close('default', currentResourceName, 'hud') end
      toggled = not toggled
    end
  end, false)

  RegisterKeyMapping('hudmenu', 'Toggle HUD Menu', 'keyboard', cfg.menu.key)
end