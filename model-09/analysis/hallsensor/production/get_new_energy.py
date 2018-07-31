#!/usr/bin/env python-sirius

import pickle as pic
import numpy as np

theta = np.zeros(54)
for i in range(4,58):
    for pos in ['positive', 'negative']:
        fi = 'bd-{0:03d}/M1/0991p63A/z-{1:s}/'.format(i, pos)
        with open(fi + '0991p63A.pkl', 'rb') as fi:
            config = pic.load(fi)
        si = 1 if pos == 'positive' else -1
        theta[i-4] += si*np.arctan(config.traj.px[-1]/config.traj.pz[-1])*180/np.pi

print(theta)
print('New Energy = {0:7.5f} GeV'.format(theta.mean()/-7.2 * 3))
