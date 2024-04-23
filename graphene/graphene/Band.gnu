set term postscript eps enhanced 
set output 'graphene.band.eps'

xmin=0.0 ; xmax=2.117351
ymin=-10 ; ymax=10
G1=xmin ; M = 0.775134;K=1.222539;G2=xmax
set nokey
set size 0.4,0.5
set xrange [xmin:xmax]
set yrange [ymin:ymax]
set arrow from M, ymin to  M,ymax nohead lt 5 lw 1
set arrow from K, ymin to  K,ymax nohead lt 5 lw 1
set noxtics
set ylabel 'E - E_F (eV)' font "Times-Roman, 14"
set noxlabel
set title "Band structure of graphene " font 'Times-Roman, 16'
set xtics ('{/Symbol G}' G1,'M' M, 'K' K,'{/Symbol G}' G2)
set ytics ymin,2,ymax font 'Helvetica, 12'
plot 'band.dat' u 1:($2+3.6509) w lines lw 2
