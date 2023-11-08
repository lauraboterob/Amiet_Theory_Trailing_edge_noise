# Amiet_Theory_Trailing_edge_noise
## Description:

This code predicts trailing-edge noise for airfoils using Amiet's theory. The code is linked with XFOIL to obtain the boundary layer parameters. Both, the approximation of far-field noise (recommended for aspect ratio larger than 3) and the sincardinal formulation are implemented.

## What is needed to run the code

This code is ready to use in a matlab for windows, specifically for the 2019 version. For running the code in linux or other operational systems, changes in the scripts migth be conducted accordinly, mainly in the script: "XFOIL_new_airfoil.mat". 

The executable of XFOIL is in the folder. The user does not need to install anything regarding this. 

## Trailing-edge noise prediction method
This code is based on Amiet's theory [1]. The aeroacoustics transfer function is modeled for subcritial and supercritical gusts considering also the backscattering effect of the leading edge proposed by Roger and Moreau [2]. 

The reference system is x located in the chordwise direction, y in the spanwise direction and z perpendicular to the wall. The origin of coordinates is located at the trailing edge at the midspan, as shown: 
![Inputs.](reference_system.png "This is a sample image.")

The far-field approximation is implemented when the input is defined as k_y = 0. Otherwise, the sincardinal formulation shown by Roger and Moreau is used [3]. 

The spanwise correlation length is modeled using Corco's function with the constant equal to 1.4. this can be changed on: ``spanwise_corlength_K2.m`` line 6.

The wall-pressure spectrum can be calculated using any of the following methods:
1. Amiet's model [1]
2. Goodys's model [4]
3. Lee's model [5]
4. Kammrruzamann model [6]
5. TNO-Blame model [7].

The inputs for those models are calculated using XFOIL simulations. For that the coordinates for the airfoil are needed. 

## How to run the code

The user needs to run ``Main_TE_noise_prediction.m``. This will open a dialog box:
![Inputs.](inputs.png "This is a sample image.")


The inputs are:
* airfoil: this does not really matter since the coordinates needs to be updated 
* chord
* Span
* Inflow velocity
* Angle of attack
* Location of forced transition for the suction side (1 for natural transition)
* Location of forced transition for the pressure side (1 for natural transition)
* Position for extracting the boundary layer paraters (close to the trailing edge)
* Oberver location coordinate in x
* Observer location coordinate in y
* Observer location coordinate in z
* k_y_{max}: this is the maximum wave number in the spanwise direction for integrate in case the sin cardinal formulation is used, if it it equal to 0, the far-field approximation is used. The sincardinal formulation takes much longer than the far-field approximation. 


Later, a  dialog box to select the wall-pressure spectrum model is shown:
![Inputs.](WPS.png "This is a sample image.")

The coordinates of the airfoils need to be on the same folder in a .txt file in a format redable by XFOIL. The file cannot  have any header. To update the name of the file change line 6 of ``XFOIL_new_airfoil.m``

The plots shown the far-field noise and the wall-pressure spectra on the suction and pressure sides. 

## References
[1] Amiet, R., “Noise due to turbulent flow past a trailing edge,” Journal of Sound and Vibration, Vol. 47, No. 3, 1976, pp. 387–393. https://doi.org/10.1016/0022-460X(76)90948-2.
[3] Roger, M., “On broadband jet–ring interaction noise and aerofoil turbulence-interaction noise predictions,” Journal of Fluid Mechanics, Vol. 653, 2010, pp. 337–364. https://doi.org/10.1017/S0022112010000285.
[4] Goody, M., “Empirical spectral model of surface pressure fluctuations,” AIAA journal, Vol. 42, No. 9, 2004, pp. 1788–1794. https://doi.org//10.2514/1.9433.
[5] Seongkyu Lee, Lorna Ayton, Franck Bertagnolio, Stephane Moreau, Tze Pei Chong, and Phillip Joseph. “Turbulent boundary layer trailing-edge noise: Theory, computation, experiment, and application”. In: Progress in Aerospace Sciences 126 (2021), p. 100737. issn: 0376-0421. doi: 10.1016/j. paerosci.2021.100737. url: science/article/pii/S0376042121000427. 
[6] Kamruzzaman, M., Bekiropoulos, D., Lutz, T., Würz, W., and Krämer, E., “A semi-empirical surface pressure spectrum model for airfoil trailing-edge noise prediction,” International Journal of Aeroacoustics, Vol. 14, No. 5-6, 2015, pp. 833–882. https://doi.org//10.1260/1475-472X.14.5-6.833.
[7] Stalnov, O., Chaitanya, P., and Joseph, P. F., “Towards a non-empirical trailing edge noise prediction model,” Journal of Sound and Vibration, Vol. 372, 2016, pp. 50–68. https://doi.org/10.1016/j.jsv.2015.10.011.
