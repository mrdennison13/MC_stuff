# MC_stuff
Some bits and pieces demonstrating Monte Carlo methods

pi_MC-final.gp
-------------
Gnuplot script showing the calculation of pi using MC integration. 

- A circle of diameter D is placed in a square of length L=D.
- Points are placed randomly inside the square: n_iterations.
- We count the points that fall within the circle: n_over.
- The ratio P = n_over/n_iterations is equal to the ratio of the two areas: P = A_circle / A_square = pi(D/2)^2 / L^2.
- These can be equated to give: pi = 4 * n_over/n_iterations

onsager_B2.ipynb
----------------
A python notebook showing the importance of vectorizing our code when calculating the second virial coefficient (using MC integration). We get a speed improvement of x100 when we do, compared to using a loop based approach.
 - B2_L5d0_D1d0-race-csv.dat is required for the final plots
 - onsager_B2.cpython-35m-darwin.so contains the module which uses a fortran program to calculate B2
