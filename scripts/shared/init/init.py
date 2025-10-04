#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Initiates needed parameters

Created on 04/03/2025
@author: Fede

"""

# Imports
import os


def init_config():

    config = {
        'paths':{},
        'visits': []
    }

    # Define Paths
    sep = os.path.sep
    base = '.'
    #config['paths']['sessions'] = os.path.join('..' + sep,'..' + sep,'EEG','standardized','derivatives','fex')
    config['paths']['sessions'] = os.path.join('E:' + sep, 'C3N Dropbox', 'Proyectos', 'AI-Mind', 'EEG','standardized',
                                               'derivatives','fex')

    config['paths']['plv'] = {'out':os.path.join(base,'data','plv')}
    config['paths']['pow'] = {'out': os.path.join(base,'data', 'pow')}
    config['paths']['strength'] = {'out': os.path.join(base, 'data', 'strength')}

    # Create output folder if it not exists
    if not os.path.exists(config['paths']['plv']['out']):
        os.mkdir(config['paths']['plv']['out'])
    if not os.path.exists(config['paths']['pow']['out']):
        os.mkdir(config['paths']['pow']['out'])
    if not os.path.exists(config['paths']['strength']['out']):
        os.mkdir(config['paths']['strength']['out'])

    # Define visits of interest
    config['visits'] = ['1','2','3','4']

    # Define the bands of interest
    config['bands'] = ['delta','theta','alpha','low_beta','high_beta','gamma']

    config['overwrite'] = True

    return config