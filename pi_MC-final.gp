reset

set term x11 persist font "Times-Roman, 18"  size 600, 800


set size 1,1

set bmargin 5
set rmargin 4
set lmargin 5
set tmargin 4

unset border

set print "pi_MC.dat
print '#N', 'pi', 'pi_err'
unset print

set print "points.dat
print '#i', 'x', 'y', 'over=0'
unset print


#we set the seed: use a random number from bash
#!RANDOM=$(date +%s)


seed = rand(time(0))            #set from clock using time()

#seed = rand(139)          #or for a reproducible seed


set size 1,1

#a function to calculate the modulus of a number
mod(x,y) = (x-floor(x/y)*y)


#numbs of loops: n_trial is the number of trials per batch. We do n_batch batches.
n_trial    = 200
n_batch    = 200


#counters for pi and pi sq
pi_sum = 0.0
pisq_sum = 0.0


#set the height of the plot of pi (the square will have height 2, so we set this to be, say, half that at dy = 1)
dy = 1.0

#and everything must be multiplied by a factor, which is dy divided the max - min for pi (play with this, but it is about from 3 to 3.28, so 0.28).
pi_min = 3.0
pi_max = 3.35
fac = 1.0/(pi_max-pi_min)

#offset between the plots
d_o = 0.5

#the y limits of the total plot
y_min = pi_min*fac                  #min value for pi (about 3), multiplied by fac
y_max = pi_max*fac + 2.0 + d_o      #max value for pi (about 3.28), multiplied by fac, then we add on 2 for the square, plus an offset d_o 

#and the plot for pi will go from y_min to y_min + dy 

#we also need to shift the y values for everything to do with the square (e.g. the points, the function to draw the circle)
func_shift(x) = x + 1.0 + pi_max*fac + d_o

#x and y axes
set xrange [0:n_batch]
set yrange [y_min:y_max]
set x2range [0:n_batch]
set y2range [y_min:y_max]
set xtics 0.0,0.1*n_batch, n_batch*1.0 nomirror
set ytics ("3.0" 3.0*fac, "3.1" 3.1*fac, "3.2" 3.2*fac, "3.3" 3.3*fac) nomirror

set xlabel sprintf("n batches of  %d", n_trial)
set ylabel "pi"


#functions for the circle and the actual value of pi
f(x) = sqrt(1.0 - x**2)
l(x)  = pi




####draw the axes
#first the box around the points 
set arrow from 0.1*n_batch,func_shift(1.0)  to 0.9*n_batch,func_shift(1.0) nohead lw 3 lt -1 front         #top
set arrow from 0.1*n_batch,func_shift(-1.0) to 0.9*n_batch,func_shift(-1.0) nohead lw 3 lt -1 front        #bottom

set arrow from 0.1*n_batch,func_shift(-1.0) to 0.1*n_batch,func_shift(1.0) nohead lw 3 lt -1 front         #left
set arrow from 0.9*n_batch,func_shift(-1.0) to 0.9*n_batch,func_shift(1.0) nohead lw 3 lt -1 front         #right

#and the axes for the plot of pi
set arrow from 0,y_min to n_batch*1.05, y_min lw 3 lt -1              #xaxis
set arrow from 0,y_min to 0, y_min+dy lw 3 lt -1                      #yaxis

set label " {/Symbol p} calculator " at n_batch/2.0,func_shift(0.07) center
set label " hit any key to kegin " at n_batch/2.0,func_shift(-0.07) center
plot \
l(x)*fac w l lw 3 lt -1 t "",\
      f( 2.0*(x-0.1*n_batch)/(0.8*n_batch)-1.0 )+func_shift(0.0) w l lw 3 lt -1 t "",\
      -f( 2.0*(x-0.1*n_batch)/(0.8*n_batch)-1.0 )+func_shift(0.0) w l lw 3 lt -1 t ""
!read -n 1 -s -r -p ""


do for [i=1:n_batch:1] {

   n_over = 0.0

   do for [j=1:n_trial:1] {

      x = 2.0*rand(0)-1.0
      y = 2.0*rand(0)-1.0

      #x = rand(0)
      #y = rand(0)


      #check if it is within the circle
      r = x**2 + y**2
      if (r < 1.0){
      	 n_over = n_over + 1.0

      	 #output the positions: 1 if overlaps
      	 set print "points.dat" append
      	 print i, x,y, 1
      	 unset print

   	 }else{
      	 #output the positions: 0 if no overlap
      	 set print "points.dat" append
      	 print i, x,y, 0
      	 unset print
	 
	 }
   }

   pi_sub = 4.0*n_over/n_trial

   pi_sum = pi_sum + pi_sub
   pisq_sum = pisq_sum + pi_sub**2


   if ( i>1){
      pi_av = pi_sum/i
      pi_error = sqrt(pisq_sum/i - pi_av**2)/(i-1.0)**0.5


      set print "pi_MC.dat" append
      print i,  pi_av, pi_error
      unset print

      unset label
      set label sprintf("N = %d", i*n_trial) at n_batch/2.0,pi_max*fac+0.24 center
      set label sprintf("{/Symbol p} = %.8f +/-%.8f", pi_av, pi_error) at n_batch/2.0,pi_max*fac+0.08 center tc "red" 
      set label sprintf("real value = %.8f", pi) at n_batch/2.0,pi_max*fac-0.08 center

      m(x) = pi_av

      

      plot \
      "pi_MC.dat" u 1:($2*fac):($3*fac) w yerror ps 1.0 pt 7 lw 3 lt 3 t "",\
      "pi_MC.dat" u 1:($2*fac):($3*fac) w p ps 1.25 pt 7 lw 3 lc "red" t "",\
      m(x)*fac w l lw 2 lc "red" t "",\
      l(x)*fac w l lw 3 lt -1 t "",\
      "points.dat"  u (0.8*n_batch*($2+1.0)/2.0 + 0.1*n_batch):($4==1 ? func_shift($3):1.0/0.0) w p ps 0.5 pt 7 lt 1 t "",\
      "points.dat"  u (0.8*n_batch*($2+1.0)/2.0 + 0.1*n_batch):($4==0 ? func_shift($3):1.0/0.0) w p ps 0.5 pt 7 lt 2 t "",\
      f( 2.0*(x-0.1*n_batch)/(0.8*n_batch)-1.0 )+func_shift(0.0) w l lw 3 lt -1 t "",\
      -f( 2.0*(x-0.1*n_batch)/(0.8*n_batch)-1.0 )+func_shift(0.0) w l lw 3 lt -1 t ""
      
      pause 0.05
      
   }

#   if(mod(i*1.0,20.0) == 0){
#        set print "points.dat"
#        print '#i', 'x', 'y', 'over=0'
#        unset print
#   }


}
