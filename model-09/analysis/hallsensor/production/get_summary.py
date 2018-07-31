#!/usr/bin/env python-sirius

import pickle as pic
import numpy as np

#pos = 'positive'
cur = '0991p63A'
pos = 'negative'

data = '''Booster Dipoles' Integrated Principal Multipoles
================================================

As calculated in {0:s}-half Runge-Kutta trajectory,
defined by measured fieldmap with magnet excitated with current of {1:s},
corresponding to nominal particle energy of 3 GeV.

'''.format(pos, cur)

fmt = '{0:^10s} | {1:^11s} |  {2:^11s} | {3:^11s} | {4:^11s} |\n'
data += fmt.format('Dipole', 'Angle [°]', 'Dint [T.m]', 'Gint [T]', 'Sint [T/m]')
data += fmt.format('','','','','')

fmt = '{0:^10s} | {1:^+11.5f} |  {2:^+11.5f} | {3:^+11.5f} | {4:^+11.5f} |\n'
for i in range(4,58):
    name = 'bd-{0:03d}'.format(i)
    fi = name + '/M1/{0:s}/z-{1:s}/'.format(cur, pos)
    with open(fi + '0991p63A.pkl', 'rb') as fi:
        config = pic.load(fi)
    si = 1 if pos == 'positive' else -1
    multi = config.multipoles.normal_multipoles_integral
    theta = si*np.arctan(config.traj.px[-1]/config.traj.pz[-1])*180/np.pi
    data += fmt.format(name, theta, multi[0], multi[1], multi[2])

print(data)

with open('README-{0:s}-Z{1:s}.md'.format(cur, pos), 'w') as fi:
    fi.write(data)

