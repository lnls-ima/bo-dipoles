#!/usr/bin/env python-sirius

"""."""


# import matplotlib.pyplot as plt
import numpy as np


curlabels = ('0040p31A', '0050p39A', '0060p46A', '0165p27A',
             '0330p54A', '0942p05A', '0991p63A', '1041p21A')


class HallSensorAnalysis:
    """."""

    _path = ('/home/fac_files/lnls-ima/bo-dipoles/model-09/'
             'analysis/hallprobe/excitation_curve/')

    def __init__(self, name, current):
        """."""
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

        fname = HallSensorAnalysis._path + \
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


class BODipoles:
    """."""

    def __init__(self, magnets):
        """."""
        self.magnets = magnets
        self.curlabels = curlabels
        self.currents = np.zeros((len(self.magnets), len(self.curlabels)))
        self.angle = np.zeros((len(self.magnets), len(self.curlabels)))
        self.beam_energy = np.zeros((len(self.magnets), len(self.curlabels)))
        self.quadrupole = np.zeros((len(self.magnets), len(self.curlabels)))
        self.sextupole = np.zeros((len(self.magnets), len(self.curlabels)))
        for i in range(len(self.magnets)):
            for j in range(len(self.curlabels)):
                h = HallSensorAnalysis(self.magnets[i], self.curlabels[j])
                self.currents[i, j] = h.current
                self.beam_energy[i, j] = h.beam_energy
                self.angle[i, j] = h.angle
                self.quadrupole[i, j] = h.intn1
                self.sextupole[i, j] = h.intn2

        self.currents_avg = np.mean(self.currents, axis=0)
        self.angle_avg = np.mean(self.angle, axis=0)
        self.angle_std = np.std(self.angle, axis=0)
        self.quadrupole_avg = np.mean(self.quadrupole, axis=0)
        self.quadrupole_std = np.std(self.quadrupole, axis=0)
        self.sextupole_avg = np.mean(self.sextupole, axis=0)
        self.sextupole_std = np.std(self.sextupole, axis=0)

    def plot_beam_energy(self, plt):
        """."""
        for i in range(len(self.magnets)):
            plt.plot(self.currents[i, :], self.beam_energy[i, :],
                     label=self.magnets[i])
        plt.xlabel('Current [A]')
        plt.ylabel('Energy [GeV]')
        plt.legend()

    def plot_angle_error(self, plt):
        """."""
        for i in range(len(self.magnets)):
            error = 100*(self.angle[i, :] - self.angle_avg)/self.angle_avg
            plt.plot(self.currents[i, :], error, 'o', label=self.magnets[i])
        plt.plot(self.currents_avg,
                 -100*self.angle_std/self.angle_avg, 'k--')
        plt.plot(self.currents_avg,
                 +100*self.angle_std/self.angle_avg, 'k--')
        plt.xlabel('Current [A]')
        plt.ylabel("Angle Error w.r.t. Magnets' Average [%]")
        plt.legend()

    def plot_quadrupole_error(self, plt):
        """."""
        for i in range(len(self.magnets)):
            error = 100*(self.quadrupole[i, :] - self.quadrupole_avg) / \
                self.quadrupole_avg
            plt.plot(self.currents[i, :], error, 'o', label=self.magnets[i])
        plt.plot(self.currents_avg,
                 -100*self.quadrupole_std/self.quadrupole_avg, 'k--')
        plt.plot(self.currents_avg,
                 +100*self.quadrupole_std/self.quadrupole_avg, 'k--')
        plt.xlabel('Current [A]')
        plt.ylabel("Quadrupole Error w.r.t. Magnets' Average [%]")
        plt.legend()

    def plot_sextupole_error(self, plt):
        """."""
        for i in range(len(self.magnets)):
            error = 100*(self.sextupole[i, :] - self.sextupole_avg) / \
                self.sextupole_avg
            plt.plot(self.currents[i, :], error, 'o', label=self.magnets[i])
        plt.plot(self.currents_avg,
                 -100*self.sextupole_std/self.sextupole_avg, 'k--')
        plt.plot(self.currents_avg,
                 +100*self.sextupole_std/self.sextupole_avg, 'k--')
        plt.xlabel('Current [A]')
        plt.ylabel("Sextupole Error w.r.t. Magnets' Average [%]")
        plt.legend()
