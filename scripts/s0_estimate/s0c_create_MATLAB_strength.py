#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
First step of X-Model study.

Estimation of PLV ratio to see significant areas

Created on 04/03/2025

@author: Fede
"""

# Imports
import os
import scipy
import numpy as np

from mne_connectivity import read_connectivity

from scripts.shared.init.init import init_config
from scripts.shared.io.load_sessions import load_session


# Init config
config = init_config()

# Get the list of sessions
subjects = load_session(config)

# Dimensions
n_channels = 126
n_subjects = len(subjects)
n_bands = len(config['bands'])

# For each subject
for current_subject in subjects:

    print('Working on ' + current_subject)

    # Check if overwrite
    dummy_name = current_subject + '-strength.mat'
    outfile = os.path.join(config['paths']['strength']['out'], dummy_name)
    if os.path.exists(outfile) and not(config['overwrite']):
        print('  Already calculated. Skip.')
        continue

    strength_dict = {'1': np.full((n_channels, n_bands), np.nan),
                '2': np.full((n_channels, n_bands), np.nan),
                '3': np.full((n_channels, n_bands), np.nan),
                '4': np.full((n_channels, n_bands), np.nan)}

    # For each band
    for iband in range(n_bands):

        # Get the current band
        current_band = config['bands'][iband]

        for ifile in range(len(subjects[current_subject])):

            # Find and load the file (It has to be 2-EC or 4-EC)
            current_session = subjects[current_subject][ifile]
            dummy = os.path.join(config['paths']['sessions'],current_session,current_session,
                                 'sensors','plv-' + current_band,current_session + '_2-EC_eeg.mnenc')
            if not(os.path.exists(dummy)):
                dummy = os.path.join(config['paths']['sessions'],current_session,current_session,
                                     'sensors','plv-' + current_band,current_session + '_4-EC_eeg.mnenc')
            if not(os.path.exists(dummy)):
                continue
            data = read_connectivity(dummy)

            # Load PLV_v1 in vector form (triu)
            dummy_plv = data.get_data()
            current_visit = current_session[6]

            # Estimate the strength
            mask = ~np.eye(dummy_plv.shape[0], dtype=bool)
            strength_dict[current_visit][:,iband] = np.sum(dummy_plv * mask, axis=0) / (dummy_plv.shape[0] - 1)

    # Save as MATLAB file
    # Convert the matrix to dictionary
    out = {'strength_v1': strength_dict['1'],
           'strength_v2': strength_dict['2'],
           'strength_v3': strength_dict['3'],
           'strength_v4': strength_dict['4'],
           'dimensions_strength_dict': 'channels x bands',
           'bands': config['bands']
           }
    scipy.io.savemat(outfile,out)
