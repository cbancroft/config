local utility = require('utility')
local util = require('awful.util')

local private = {}

local locations =
   { gjovik = { city = "Gjovik", country = "Norway",
                lat = 60.79, lon = 10.69,
                gmt = 1 },
     ivfran = { city = "Ivano-Frankivsk",
                country = "Ukraine",
                lat = 48.92, lon = 24.71,
                gmt = 2 },
     kiev = { city = "Kiev", country = "Ukraine",
              lat = 50.45, lon = 30.52,
              gmt = 2 },
     rochester = { city = "Rochester", state = "NH", country = "USA",
                    lat = 43.30, lon = 70.97, gmt = -6 }
                }

private.user = { name = "cbancroft",
                 loc = locations.rochester }

-- forecast.io API key is read from ./.forecast_io_api_key file
private.weather = { api_key = utility.slurp(util.getdir("config") ..
                                               "/.forecast_io_api_key", "*line") }

return private
