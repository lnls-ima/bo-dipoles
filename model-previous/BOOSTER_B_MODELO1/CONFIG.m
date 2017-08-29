function parms = CONFIG(pathstr)

% units
% -----
degree = (pi/180);
mm     = 1e-3;
GeV    = 1;
mA     = 1e-3;
mrad   = 1e-3;

% SIRIUS_B2_MODELO7
% =================
parms.config_path   = pathstr;
parms.magnet_type   = 'dipole';            % magnet type (dipole, quadrupole, sextupole)
parms.nominal_ang   = (7.2 / 2) * degree;  % nominal deflection angle of half model
parms.fmap_fname    = '/opt/lnls-data/sirius_mml/magnet_modelling/MM3D/B_Booster/2013-06-28 Dipolo_Booster_BD_Modelo 1_-100_12mm_-1300_1300mm.txt';
parms.beam.energy   = 3.0 * GeV;           % beam energy
parms.beam.current  = 1.5 * mA;            % beam current
parms.init_position       = ([0 0 0 0 0 1].*[mm mm mm 1 1 1])'; % initial condition [x,y,z,beta_x,beta_y,beta_z] 
parms.perp_grid.points    = linspace(-11,11,27) * mm;           % perpendicular grid points for multipole and transfer map calcs
parms.perp_grid.monomials = [0 1 2 3 4 5 6];                    % monomial for multipole fitting
parms.model.half_length   = 770 * mm;                           % half-length to use for magnet modelling
parms.track.rx            = linspace(-11,11,27) * mm;           % grid of x  initial positions for transfer maps calc
parms.track.px            = linspace(0,0,1) * mrad;             % grid of xl initial positions for transfer maps calc
parms.tracy.r0            = 17.5 * mm;                          % reference radius for tracy3 multipole calcs
parms.runge_kutta_flags.RelTol  = 1e-8;                         % RK tolerance                        
parms.runge_kutta_flags.AbsTol  = 1e-8;                         % RK tolerance                        
parms.runge_kutta_flags.MaxStep = 1 * mm;                       % RK max step size (longitudinal position)    
parms.calibration.nrpts_fit    = 10;                            % nr points for adjustment of kick curve fitting based on polynomial interpolation
parms.calibration.nrpts_trials = 8000;                          % nrpts of iterations in the search for better polynomb ('0' disables calibration)
parms.calibration.perc_change  = 0.01;                          % variation of polynomials for tmatrix calibration [%]

