#!/usr/bin/env python-sirius

import hallprobe
import numpy as np
import sys

s_step = 0.1
meas_path = ('/home/fac_files/lnls-ima/bo-dipoles/model-09/measurement/'
             'magnetic/hallprobe/production/')


def process_magnet(fmap):
    """."""
    beam_energy = 3.0
    rx_init = 9.1013
    goal = np.array([-7.2, 28.2550])

    path_fmap = meas_path + fmap
    sfmt = ('x0={:.3f} mm: ref-x={:+6.3f} mm, angle={:+7.4f} deg. '
            '| {:+6.3f} mm,  {:+7.4f} deg. [{:+.3f} %]')
    magnet_name = fmap[:6]

    print('[{}]'.format(magnet_name))

    # vary x0
    path_analysis = '/tmp/fmap-test'
    x0_grid = np.linspace(rx_init - 0.15, rx_init + 0.15, 21)
    angle_grid = np.zeros(x0_grid.shape)
    rx_ref_grid = np.zeros(x0_grid.shape)
    for i in range(len(x0_grid)):
        hp = hallprobe.FMapAnalysis(
             'model-09', '3GeV', path_analysis, path_fmap,
             beam_energy, x0_grid[i], s_step)
        hp.analysis_trajectory()
        hn = hallprobe.FMapAnalysis(
             'model-09', '3GeV', path_analysis, path_fmap,
             beam_energy, x0_grid[i], -s_step)
        hn.analysis_trajectory()
        angle_grid[i] = hp.results_angle - hn.results_angle
        rx_ref_grid[i] = 0.5 * (hp.results_rx_ref + hn.results_rx_ref)
        rx_ref_grid[i] = np.sqrt(0.5 * ((hp.results_rx_ref - goal[1])**2 +
                                        (hn.results_rx_ref - goal[1])**2))
        print(magnet_name + ' - ' +
              sfmt.format(x0_grid[i], rx_ref_grid[i], angle_grid[i],
                          rx_ref_grid[i] - 0*goal[1], angle_grid[i] - goal[0],
                          100*(angle_grid[i] - goal[0])/goal[0]))
    # select best x0
    error = abs(rx_ref_grid - 0*goal[1])
    i = np.argmin(error)
    sfmt = 'selected x0={:.3f} mm, running analysis for z-{}'

    # does analysis for selected x0 and z-positive
    print(sfmt.format(x0_grid[i], 'positive'))
    path_analysis = './' + magnet_name + '/M1/0991p63A/z-positive'
    h = hallprobe.FMapAnalysis(
        'model-09', '3GeV', path_analysis, path_fmap,
        beam_energy, x0_grid[i], s_step)
    h.analysis_multipoles()
    h.cmd_model()
    h.analysis_concatenate_output_files()

    # does analysis for selected x0 and z-negative
    print(sfmt.format(x0_grid[i], 'negative'))
    path_analysis = './' + magnet_name + '/M1/0991p63A/z-negative'
    h = hallprobe.FMapAnalysis(
        'model-09', '3GeV', path_analysis, path_fmap,
        beam_energy, x0_grid[i], -1.0*s_step)
    h.analysis_multipoles()
    h.cmd_model()
    h.analysis_concatenate_output_files()


def gen_analysis_file(fmap):
    """."""
    path_fmap = meas_path + fmap
    magnet_name = fmap[:6]
    # does analysis for selected x0 and z-positive
    path_analysis = './' + magnet_name + '/M1/0991p63A/z-positive'
    h = hallprobe.FMapAnalysis(
        'model-09', '3GeV', path_analysis, path_fmap,
        3.0, 0, s_step)
    h.analysis_concatenate_output_files()

    # does analysis for selected x0 and z-negative
    path_analysis = './' + magnet_name + '/M1/0991p63A/z-negative'
    h = hallprobe.FMapAnalysis(
        'model-09', '3GeV', path_analysis, path_fmap,
        3.0, 0, s_step)
    h.analysis_concatenate_output_files()


fmaps = (
    'bd-004/M1/2017-03-06_BD-004_Model09_Hall_I=991.63A.dat',
    'bd-005/M1/2017-03-06_BD-005_Model09_Hall_I=991.63A.dat',
    'bd-006/M1/2017-04-19_BD-006_Model09_Hall_I=991.63A_12.dat',
    'bd-007/M1/2017-03-15_BD-007_Model09_Hall_I=991.63A_3.dat',
    'bd-008/M1/2017-03-08_BD-008_Model09_Hall_I=991.63A.dat',
    'bd-009/M1/2017-03-08_BD-009_Model09_Hall_I=991.63A.dat',
    'bd-010/M1/2017-03-08_BD-010_Model09_Hall_I=991.63A.dat',
    'bd-011/M1/2017-03-15_BD-011_Model09_Hall_I=991.63A_3.dat',
    'bd-012/M1/2017-03-09_BD-012_Model09_Hall_I=991.63A.dat',
    'bd-013/M1/2017-03-09_BD-013_Model09_Hall_I=991.63A.dat',
    'bd-014/M1/2017-03-09_BD-014_Model09_Hall_I=991.63A_3.dat',
    'bd-015/M1/2017-03-14_BD-015_Model09_Hall_I=991.63A_2.dat',
    'bd-016/M1/2017-03-14_BD-0016_Model09_Hall_I=991.63A.dat',
    'bd-017/M1/2017-03-13_BD-017_Model09_Hall_I=991.63A.dat',
    'bd-018/M1/2017-03-14_BD-018_Model09_Hall_I=991.63A.dat',
    'bd-019/M1/2017-03-15_BD-019_Model09_Hall_I=991.63A_3.dat',
    'bd-020/M1/2017-03-11_BD-020_Model09_Hall_I=991.63A_2.dat',
    'bd-021/M1/2017-03-13_BD-021_Model09_Hall_I=991.63A.dat',
    'bd-022/M1/2017-03-13_BD-022_Model09_Hall_I=991.63A.dat',
    'bd-023/M1/2017-03-11_BD-023_Model09_Hall_I=991.63A.dat',
    'bd-024/M1/2017-03-13_BD-024_Model09_Hall_I=991.63A.dat',
    'bd-025/M1/2017-03-31_BD-025_Model09_Hall_I=991.63A.dat',
    'bd-026/M1/2017-03-30_BD-026_Model09_Hall_I=991.63A.dat',
    'bd-027/M1/2017-03-31_BD-027_Model09_Hall_I=991.63A.dat',
    'bd-028/M1/2017-03-30_BD-028_Model09_Hall_I=991.63A.dat',
    'bd-029/M1/2017-04-01_BD-029_Model09_Hall_I=991.63A_3.dat',
    'bd-030/M1/2017-03-31_BD-030_Model09_Hall_I=991.63A.dat',
    'bd-031/M1/2017-03-30_BD-031_Model09_Hall_I=991.63A.dat',
    'bd-032/M1/2017-03-31_BD-032_Model09_Hall_I=991.63A.dat',
    'bd-033/M1/2017-03-30_BD-033_Model09_Hall_I=991.63A.dat',
    'bd-034/M1/2017-03-31_BD-034_Model09_Hall_I=991.63A.dat',
    'bd-035/M1/2017-04-01_BD-035_Model09_Hall_I=991.63A.dat',
    'bd-036/M1/2017-04-03_BD-036_Model09_Hall_I=991.63A.dat',
    'bd-037/M1/2017-04-04_BD-037_Model09_Hall_I=991.63A.dat',
    'bd-038/M1/2017-04-03_BD-038_Model09_Hall_I=991.63A.dat',
    'bd-039/M1/2017-04-03_BD-039_Model09_Hall_I=991.63A.dat',
    'bd-040/M1/2017-04-05_BD-040_Model09_Hall_I=991.63A.dat',
    'bd-041/M1/2017-04-04_BD-041_Model09_Hall_I=991.63A.dat',
    'bd-042/M1/2017-04-05_BD-042_Model09_Hall_I=991.63A.dat',
    'bd-043/M1/2017-04-04_BD-043_Model09_Hall_I=991.63A.dat',
    'bd-044/M1/2017-04-04_BD-044_Model09_Hall_I=991.63A.dat',
    'bd-045/M1/2017-04-04_BD-045_Model09_Hall_I=991.63A.dat',
    'bd-046/M1/2017-04-05_BD-046_Model09_Hall_I=991.63A_3.dat',
    'bd-047/M1/2017-04-19_BD-047_Model09_Hall_I=991.63A.dat',
    'bd-048/M1/2017-04-20_BD-048_Model09_Hall_I=991.63A.dat',
    'bd-049/M1/2017-04-17_BD-049_Model09_Hall_I=991.63A.dat',
    'bd-050/M1/2017-04-19_BD-050_Model09_Hall_I=991.63A.dat',
    'bd-051/M1/2017-04-20_BD-051_Model09_Hall_I=991.63A.dat',
    'bd-052/M1/2017-04-20_BD-052_Model09_Hall_I=991.63A.dat',
    'bd-053/M1/2017-04-20_BD-053_Model09_Hall_I=991.63A.dat',
    'bd-054/M1/2017-04-18_BD-054_Model09_Hall_I=991.63A.dat',
    'bd-055/M1/2017-04-19_BD-055_Model09_Hall_I=991.63A.dat',
    'bd-056/M1/2017-04-20_BD-056_Model09_Hall_I=991.63A_2.dat',
    'bd-057/M1/2017-04-19_BD-057_Model09_Hall_I=991.63A.dat',
)

for fmap in fmaps:
    # process_magnet(fmap)
    gen_analysis_file(fmap)
    print()
