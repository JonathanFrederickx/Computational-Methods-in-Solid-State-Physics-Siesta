#!/bin/bash

mpirun -np 6 siesta <graphene-relax.fdf>graphene-relax.fdf.sout   # relaxation

mpirun -np 6 siesta <graphene-dos.fdf>graphene-dos.fdf.sout  # DOS and Band structure calculations

gnubands < graphene.bands > band.dat   # Post-processing of the bandstructure

gnuplot Band.gnu  
gnuplot Band+Dos.gnu   # plot the bandstructure
