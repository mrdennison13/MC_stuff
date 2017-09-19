# MC_stuff
Some bits and pieces demonstrating Monte Carlo methods

pi_MC-final.gp
-------------
Gnuplot script showing the calculation of pi using MC integration. 
Points are chosen randomly inside a square. We count those that fall within a circle that sits within the square.
The ratio that do gives the ratio of the two areas: area of the circle / area of the square.
This is proportional to pi

onsager_B2.ipynb
----------------
A python notebook showing the importance of vectorizing our code when calculating of the second virial coefficient (using MC integration). We get a speed up of 100X when we do, compared to using a loop based approach.
B2_L5d0_D1d0-race-csv.dat is required for the final plots
