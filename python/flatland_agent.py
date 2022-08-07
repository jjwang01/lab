from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import argparse
import random
import numpy as np
import six

import deepmind_lab


class FlatlandAgent(object):
    """Agent for Flatland experiment."""
    def __init__(self, action_spec):
        self.action_spec = action_spec
        self.action_count = len(action_spec)
    
    def step(self, action):
        pass

def run(width, height, level_script, frame_count):
    """Spins up an environment and runs the agent."""
    config = {'width': str(width), 'height': str(height)}
    env = deepmind_lab.Lab(level_script, 
        [
            'RGB_INTERLEAVED', 
            'VEL.TRANS', 
            'VEL.ROT', 
            'DEBUG.CAMERA.TOP_DOWN', 
            'DEBUG.CAMERA.PLAYER_VIEW_NO_RETICLE',
            'DEBUG.POS.TRANS',
            'DEBUG.POS.ROT',
        ], 
        config=config
    )
    env.reset()

    reward = 0
    agent = FlatlandAgent(env.action_spec())
    for _ in six.moves.range(frame_count):
        if not env.is_running():
            print('Environment stopped early')
            env.reset()
            agent.reset()

        # TODO: implement action getting in agent

        action = agent.step()
        reward += env.step(action, num_steps=1)
    
    print('Finished after ')