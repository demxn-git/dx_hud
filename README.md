# dx_hud

dx_hud is a FiveM HUD for ox_core or ESX Legacy.

## Dependencies

- ox_lib

This also requires a framework of your choice between ox_core and es_extended.  
Note that if you are using ESX, you will also need esx_status and esx_basicneeds.

## Download & Installation

- Go to the [releases page](https://github.com/0xDEMXN/dx_hud/releases "Releases page") and download the latest release
- Place it inside the `resources` directory
- Add the resource to your `server.cfg` after dependencies to make sure it's started correctly at server startup:

```
ensure dx_hud
```

## Configuration

You can add these settings directly to your 'server.cfg', or add them to a separate file (i.e. hud.cfg) and call it with exec. **Convars must be set before starting dx_hud.**

The values below are defaults and should not be explicitly set unless changing the value.

``` yaml
### Shared

# Seabelt system
setr hud:seatbelt false

### Client

# Stress Indicator
setr hud:stress false

# Stamina Indicator
setr hud:stamina false

# Fuel Indicator
setr hud:fuel false

# Vehicles speed: "imperial" or "metric"
setr hud:unitsystem "imperial"

# Radar mode: by default, the radar is only enabled while sitting on a vehicle.
# Set this to true to have it always enabled. This will also enable the map cycler.
setr hud:persistentRadar false

# Radar shape
setr hud:circleMap true

# Keys for map cycler and seatbelt
setr hud:cyclemapKey "Z"
setr hud:seatbeltKey "B"

# Voice Indicator
setr hud:voice false

# Voice system: "pma-voice" or "saltychat"
setr hud:voiceService "pma-voice"

# Server logo
setr hud:logo true

# Version check against GitHub repo (Recommended)
setr hud:versioncheck true
```

## Thanks to
[Overextended Community](https://discord.gg/overextended) for always being supportive 🐂❤️  
[nojdh](https://github.com/nojdh/) for Cosmo HUD, which initially this was a fork of

<br>
<table><tr><td><h4 align='center'>Legal Notices</h4></tr></td>
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
