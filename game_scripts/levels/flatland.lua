local factory = require 'factories.flatland_factory'

return factory.createLevelApi{
    episodeLengthSeconds=12,
}

local make_map = require 'common.make_map'
local map_maker = require 'dmlab.system.map_maker'
local random = require 'common.random'

local randomMap = random(map_maker:randomGen())
function api:nextMap()
    if kwargs.quickRestart then
        self._map = ''
    end
    return self._map
end

function api:start(episode, seed)
random:seed(seed)
randomMap:seed(random:mapGenerationSeed())

-- * is a wall
-- G is a goal spawn point
-- H is a north-south door
-- I is an east-west door
-- P is a player spawn point
self._map = make_map.makeMap{
    mapName = 'MinimalFlatland',
    mapEntityLayer =
        '***********\n' ..
        '*P   GGG  *\n' ..
        '*  G*PPP* *\n' ..
        '*GP  PGP* *\n' ..
        '*PGG* *** *\n' ..
        '*    PGP* *\n' ..
        '*P P*PGG* *\n' ..
        '*GP *PGP* *\n' ..
        '*** *** * *\n' ..
        '***       *\n' ..
        '***********\n'
}

local setting_overrides = require 'decorators.setting_overrides'
custom_observations.decorate(api)
setting_overrides.decorate{
    api = api,
    apiParams = kwargs,
    decorateWithTimeout = true
}
return api

local pickups = require 'common.geometric_pickups'
function api:createPickup(className)
    return pickups.defaults[className]
end

local maze_gen = require 'dmlab.system.maze_generation'
self._maze = maze_gen.mazeGeneration{
        entity =
            '***********\n' ..
            '*** IAFGI *\n' ..
            '***L*PPP* *\n' ..
            '*MP IPSP* *\n' ..
            '*PWA*H*** *\n' ..
            '*   IPFP* *\n' ..
            '*P P*PGL* *\n' ..
            '*MP *PSP* *\n' ..
            '***H***H* *\n' ..
            '***       *\n' ..
            '***********\n',
    }
    self._map = make_map.makeMap{
        mapName = 'WideOpenLevel',
        mapEntityLayer = self._maze:entityLayer(),
        -- sphere pickup should be a positive reward, cube pickup should be negative
        -- 
        pickups = {
            G = 'goal',
            S = 'fut_obj_sphere_1',
            C = 'fut_obj_cube_1',
        }
    }

local debug_observations = require 'decorators.debug_observations'
debug_observations.setMaze(self._maze)

end