local custom_observations = require 'decorators.custom_observations'
local game = require 'dmlab.system.game'

local factory = {}

function factory.createLevelApi(kwargs)
    assert(kwargs.episodeLengthSeconds)
    local api = {}

    custom_boservations.decorate(api)
    return api
end

return factory