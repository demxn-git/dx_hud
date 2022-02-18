# dx_hud

This started as a fork of Cosmo HUD but ended up being a complete rewrite.  
dx_hud is an HUD for FiveM and ESX Legacy.

## Requirements

- es_extended (Legacy)
- esx_status
- esx_basicneeds

## Optionals

- pma-voice

## Useful Snippets

### I won't provide any support for the snippets below, it's up to you to understand if you need it or not or if you have any conflicts aswell.

If you want to equal health among peds, run this client-side every tick.
```lua
if GetEntityMaxHealth(PlayerPedId()) ~= 200 then
  SetEntityMaxHealth(PlayerPedId(), 200)
  SetEntityHealth(PlayerPedId(), 200)
end
```

If you want to disable health regen, run this client-side every tick.
```lua
  SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0) 
  SetPlayerHealthRechargeLimit(PlayerId(), 0.0)
```

## Download & Installation


### Using Git

```
cd resources
git clone https://github.com/0xDEMXN/dx_hud.git
```

### Manually

- Go to the [releases page](https://github.com/0xDEMXN/dx_hud/releases "Releases page") and download the latest release
- Place it inside the `resources` directory

### Installation

- Edit `config.lua` to fit your needs
- Add the resource to your `server.cfg` after dependencies to make sure it's started correctly at server startup:

```
ensure dx_hud
```

## Screenshot(s)

![dx_hud screenshot](https://user-images.githubusercontent.com/15928886/154711951-584adcec-5369-477b-8a4a-f3c006182881.png)

## Thanks to
[nojdh](https://github.com/nojdh/) for Cosmo HUD

<br>
<table><tr><td><h3 align='center'>Legal Notices</h2></tr></td>
<tr><td>
dx_hud for ESX Legacy  

Copyright © 2022  [Demxn](https://github.com/0xDEMXN)


This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.  


This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.  


You should have received a copy of the GNU General Public License
along with this program.  
If not, see <https://www.gnu.org/licenses/>
</td></tr></table>