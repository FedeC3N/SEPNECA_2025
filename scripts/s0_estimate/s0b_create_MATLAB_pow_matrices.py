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
import mne
import h5py
import scipy
import numpy as np

from scripts.shared.init.init import init_config
from scripts.shared.io.load_sessions import load_session


# Init config
config = init_config()

# Get the list of sessions
subjects = load_session(config)

# Dimensions
n_subjects = len(subjects)
n_channels = 129
n_freqs = 172

# For each subject
for current_subject in subjects:

    print('Working on ' + current_subject)

    # Check if overwrite
    dummy_name = current_subject + '-pow.mat'
    outfile = os.path.join(config['paths']['pow']['out'], dummy_name)
    if os.path.exists(outfile):
        print('  Already calculated. Skip.')
        continue

    pow_dict = {'1': [],
                '2': [],
                '3': [],
                '4': []}

    bads_dict = {'1': [],
                '2': [],
                '3': [],
                '4': []}

    for ifile in range(len(subjects[current_subject])):

        # Find and load the file (It has to be 2-EC or 4-EC)
        current_session = subjects[current_subject][ifile]
        dummy = os.path.join(config['paths']['sessions'], current_session, current_session,
                             'sensors','spectrum',current_session + '_2-EC_eeg.h5')
        dummy_fif = os.path.join(config['paths']['sessions'], current_session, current_session,
                             'sensors', current_session + '_2-EC_eeg.fif')
        if not(os.path.exists(dummy)):
            dummy = os.path.join(config['paths']['sessions'], current_subject, current_session,
                                 'sensors', 'spectrum', current_session + '_4-EC_eeg.h5')
            dummy_fif = os.path.join(config['paths']['sessions'], current_subject, current_session,
                                     'sensors', current_session + '_4-EC_eeg.fif')
        if not(os.path.exists(dummy)):
            continue

        # Read the HDF5 file
        with h5py.File(dummy, "r") as f:
            spectrum = f['mnepython']['key_data'][:]
            freqs = f['mnepython']['key_freqs'][:]

        # I need the list of badchannels (or at least the list of good channels)
        raw = mne.read_epochs(dummy_fif, preload=False)

        # Save the
        current_visit = current_session[6]
        pow_dict[current_visit] = spectrum
        bads_dict[current_visit] =raw.info['bads']

    # Save as MATLAB file
    # Convert the matrix to dictionary
    out = {
        'pow':{
                'v1': pow_dict['1'],
                'v2': pow_dict['2'],
                'v3': pow_dict['3'],
                'v4': pow_dict['4']},
        'bads': {
            'v1': bads_dict['1'],
            'v2': bads_dict['2'],
            'v3': bads_dict['3'],
            'v4': bads_dict['4']},
        'dimensions': 'channels x freqs',
        'freqs': freqs}
    scipy.io.savemat(outfile, out)


