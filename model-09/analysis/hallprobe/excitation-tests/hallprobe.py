#!/usr/bin/env python-sirius

"""."""


# import matplotlib.pyplot as plt
import numpy as np


curlabels = ('0040p31A', '0050p39A', '0060p46A', '0165p27A',
             '0330p54A', '0942p05A', '0991p63A', '1041p21A')


class HallProbeAnalysis:
    """."""

    _path = ('/home/fac_files/lnls-ima/bo-dipoles/model-09/'
             'analysis/hallprobe/excitation_curve/')

    def __init__(self, dataset, name, current):
        """."""
        self.dataset = dataset
        self.name = name
        self.current = current
        self.current_pos, self.beam_energy_pos, \
            self.angle_pos, \
            self.intn0_pos, self.intn1_pos, self.intn2_pos = \
            self._read_analysis('z-positive')
        self.current_neg, self.beam_energy_neg, \
            self.angle_neg, \
            self.intn0_neg, self.intn1_neg, self.intn2_neg = \
            self._read_analysis('z-negative')
        self.current = 0.5*(self.current_pos + self.current_neg)
        self.beam_energy = 0.5*(self.beam_energy_pos + self.beam_energy_neg)
        self.angle = self.angle_pos - self.angle_neg  # corrects sign error
        self.intn0 = self.intn0_pos + self.intn0_neg
        self.intn1 = self.intn1_pos + self.intn1_neg
        self.intn2 = self.intn2_pos + self.intn2_neg

    def _read_analysis(self, side):

        fname = HallProbeAnalysis._path + self.dataset + '/' + \
                self.name + '/' + self.current + '/' + side + '/analysis.txt'
        with open(fname, 'r') as f:
            lines = f.readlines()
        for line in lines:
            if 'horizontal_deflection_angle' in line:
                angle = float(line.split()[1])
            elif 'n=00' in line:
                intn0 = float(line.split()[2])
            elif 'n=01' in line:
                intn1 = float(line.split()[2])
            elif 'n=02' in line:
                intn2 = float(line.split()[2])
            elif 'main_coil_current' in line:
                current = float(line.split()[1])
            elif 'beam_energy' in line:
                energy = float(line.split()[1])
        return current, energy, angle, intn0, intn1, intn2


class DipolesSet:
    """."""

    spec_angle = -7.2  # [deg]
    spec_angle_rms = 0.15  # [%]
    spec_ref_current = 991.63  # [A]
    spec_quadrupole = 2.4788148246867  # [T] @991.63A (3 GeV)
    spec_quadrupole_rms = 2.4  # [%]
    spec_sextupole = 25.627729062301  # [T/m] @991.63A (3 GeV)
    spec_sextupole_rms = 9.0  # [%]

    def __init__(self, dataset, magnets):
        """."""
        self.dataset = dataset
        self._data = dict()
        for magnet, currlabels in magnets.items():
            self._data[magnet] = dict()
            for currlabel in currlabels:
                self._data[magnet][currlabel] = \
                    HallProbeAnalysis(self.dataset, magnet, currlabel)

    @property
    def magnet_labels(self):
        """."""
        return list(self._data.keys())

    def currents_minmax(self):
        """."""
        mi, ma = None, None
        for v in self._data.values():
            currlabels = list(v.keys())
            currents = [v[c].current for c in currlabels]
            mi = min(currents) if not mi else min(mi, min(currents))
            ma = max(currents) if not ma else max(ma, max(currents))
        return mi, ma

    def get_energies(self):
        """."""
        maglabel_set = self.magnet_labels
        currents_set = []
        energies_set = []
        for v in self._data.values():
            currlabels = list(v.keys())
            currents = [v[c].current for c in currlabels]
            energies = [v[c].beam_energy for c in currlabels]
            currents_set.append(currents)
            energies_set.append(energies)
        return maglabel_set, currents_set, energies_set

    def get_angles(self):
        """."""
        maglabel_set = self.magnet_labels
        currents_set = []
        angles_set = []
        for v in self._data.values():
            currlabels = list(v.keys())
            currents = [v[c].current for c in currlabels]
            angles = [v[c].angle for c in currlabels]
            currents_set.append(currents)
            angles_set.append(angles)
        return maglabel_set, currents_set, angles_set

    def get_quadrupoles(self):
        """."""
        maglabel_set = self.magnet_labels
        currents_set = []
        quadrupoles_set = []
        for v in self._data.values():
            currlabels = list(v.keys())
            currents = [v[c].current for c in currlabels]
            quadrupoles = [v[c].intn1 for c in currlabels]
            currents_set.append(currents)
            quadrupoles_set.append(quadrupoles)
        return maglabel_set, currents_set, quadrupoles_set

    def get_sextupoles(self):
        """."""
        maglabel_set = self.magnet_labels
        currents_set = []
        sextupoles_set = []
        for v in self._data.values():
            currlabels = list(v.keys())
            currents = [v[c].current for c in currlabels]
            sextupoles = [v[c].intn2 for c in currlabels]
            currents_set.append(currents)
            sextupoles_set.append(sextupoles)
        return maglabel_set, currents_set, sextupoles_set

    def plot_energies(self, plt):
        """."""
        magnets, currents, energies = self.get_energies()
        for i in range(len(magnets)):
            plt.plot(currents[i], energies[i], 'o-', label=magnets[i])
        plt.xlabel('Current [A]')
        plt.ylabel('Energy [GeV]')
        plt.legend()

    def plot_angles(self, plt):
        """."""
        magnets, currents, angles = self.get_angles()
        spec = DipolesSet.spec_angle
        xrms = self.currents_minmax()
        plt.plot(xrms, (+DipolesSet.spec_angle_rms,)*2, 'k--')
        plt.plot(xrms, (-DipolesSet.spec_angle_rms,)*2, 'k--')
        for i in range(len(magnets)):
            error = 100 * (np.array(angles[i]) - spec)/spec
            plt.plot(currents[i], error, 'o-', label=magnets[i])
        plt.xlabel('Current [A]')
        plt.ylabel('Angle Error w.r.t. to Spec [%]')
        plt.legend()

    def plot_quadrupoles(self, plt):
        """."""
        magnets, currents, quadrupoles = self.get_quadrupoles()
        spec0 = DipolesSet.spec_quadrupole
        xrms = self.currents_minmax()
        plt.plot(xrms, (+DipolesSet.spec_quadrupole_rms,)*2, 'k--')
        plt.plot(xrms, (-DipolesSet.spec_quadrupole_rms,)*2, 'k--')
        for i in range(len(magnets)):
            error = []
            for j in range(len(currents[i])):
                spec = spec0 * currents[i][j]/DipolesSet.spec_ref_current
                error.append(100 * (quadrupoles[i][j] - spec)/spec)
            plt.plot(currents[i], error, 'o-', label=magnets[i])
        plt.xlabel('Current [A]')
        plt.ylabel('Quadrupole Error w.r.t. to Spec [%]')
        plt.legend()

    def plot_sextupoles(self, plt):
        """."""
        magnets, currents, sextupoles = self.get_sextupoles()
        spec0 = DipolesSet.spec_sextupole
        xrms = self.currents_minmax()
        plt.plot(xrms, (+DipolesSet.spec_sextupole_rms,)*2, 'k--')
        plt.plot(xrms, (-DipolesSet.spec_sextupole_rms,)*2, 'k--')
        for i in range(len(magnets)):
            error = []
            for j in range(len(currents[i])):
                spec = spec0 * currents[i][j]/DipolesSet.spec_ref_current
                error.append(100 * (sextupoles[i][j] - spec)/spec)
            plt.plot(currents[i], error, 'o-', label=magnets[i])
        plt.xlabel('Current [A]')
        plt.ylabel('Sextupole Error w.r.t. to Spec [%]')
        plt.legend()