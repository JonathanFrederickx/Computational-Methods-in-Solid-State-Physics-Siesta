set term postscript eps enhanced
set output 'graphene.bandNdos.eps'
set multiplot

xmin=0.0 ; xmax=2.117351
ymin=-10 ; ymax=10
G=xmin ; M = 0.775134;K=1.222539;G=xmax

set nokey
set title "                  Band structure and DOS of graphene"
set size 0.4,0.5
set rmargin 0
set xrange [xmin:xmax]
set yrange [ymin:ymax]
set arrow from M, ymin to  M,ymax nohead lt 5 lw 1
set arrow from K, ymin to  K,ymax nohead lt 5 lw 1
set ylabel 'E - E_F (eV)'
set xtics ('{/Symbol G}' G,'M' M, 'K' K,'{/Symbol G}' G)
set ytics ymin,2,ymax font 'Helvetica, 12'
plot 'band.dat' u 1:($2+3.6509) w lines lw 2

set title " "
set origin 0.4,0
set lmargin 0.5
set size 0.12,0.5
set yr[-10:10]
set xr[0:0.65]
set noarrow
set ytics ( " " 0)
set ytics nomirror
set xtics ( " " 0)
set noylabel
p  'graphene.DOS' u 2:($1+3.6509) w lines lw 2 
