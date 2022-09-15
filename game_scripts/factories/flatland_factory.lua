local custom_observations = require 'decorators.custom_observations'
local game = require 'dmlab.system.game'
local setting_overrides = require 'decorators.setting_overrides'
local make_map = require 'common.make_map'
local map_maker = require 'dmlab.system.map_maker'
local random = require 'common.random'
local randomMap = random(map_maker:randomGen())

local factory = {}

function factory.createLevelApi(kwargs)
    assert(kwargs.episodeLengthSeconds)
    local api = {}

    custom_observations.decorate(api)
    setting_overrides.decorate{
        api = api,
        apiParams = kwargs,
        decorateWithTimeout = true
    }

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
    end

    function api:nextMap()
        if kwargs.quickRestart then
            self._map = ''
        end
        return self._map
    end

    return api
end


return factory