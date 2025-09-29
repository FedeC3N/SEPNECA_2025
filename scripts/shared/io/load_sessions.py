#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Get the folders' name for all sessions.

Only valids subjects with all sessions.

Created on 04/03/2025

@author: Fede
"""

# Imports
import os
import re
import glob



def load_session(config):

    """
    Find the sessions of each subject

    :param config: General parameters
    :return: A dictionary with the folders name associated with each subject
    """

    # Get all the folders
    folders = os.listdir(config['paths']['sessions'])

    # Parse the subjects
    subjects = {}
    pattern = '([0-9]-[0-9]{3})'
    subjects_list = [re.findall(pattern,current_folder)[0] for current_folder in folders]
    subjects_list = list(set(subjects_list))

    # For each subject, assign it name to an output
    for current_subject in subjects_list:

        # Find the sessions associated with the current subejct
        results = [os.path.basename(f) for f in glob.glob(os.path.join(config['paths']['sessions'],current_subject + '*'))]

        # Create a dictionary entry with the subject and its sessions
        subjects[current_subject] = results


    return subjects