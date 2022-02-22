dx = {
  baseRefreshRate = 200,
  statusRefreshRate = 2000,
  checksRefreshRate = 1000,
  -- in milliseconds, make sure you know what you're doing
  -- higher: better performances, worse looking
  -- lower: better looking, worse performances

  persistentRadar = false,
  -- true: radar is always on
  -- false: radar is only shown while driving

  metricSystem = true,
  -- true: speed will be kmh
  -- false: speed will be mph

  stress = false,
  -- setting this to true requires you to add a stress status

  fuel = false,
  -- setting this to true requires you to add a fuel managment resource

  voice = false,
  -- enabling this requires pma-voice

  circleMap = true
  -- enable or disable circle map
  -- toggling this requires you to restart the server (or clients to restart fivem)
}
