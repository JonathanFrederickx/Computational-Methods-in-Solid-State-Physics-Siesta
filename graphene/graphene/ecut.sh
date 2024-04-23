#!/bin/bash

touch Energy_ecut.dat   # create this file to storage the total energy of each cutoff energy
for i in `seq -w 40 20 400`; do   # use 40 60 80 100...360 380 400 as the cutoff energy for testing
mkdir $i; cp *.psf $i
cd $i

cat >ecut.fdf<<EOF

        # -- NAME & LABEL --

SystemName       scf
SystemLabel      graphene     



        # -- MATERIAL --

NumberOfAtoms    2
NumberOfSpecies  1

%block ChemicalSpeciesLabel
    1    6  C
%endblock ChemicalSpeciesLabel



       # -- CELL & ATOMIC POSITIONS

LatticeConstant 1.0 Ang
%block LatticeParameters
  2.460000  2.460000  20.000000  90.000000  90.000000  120.000000
%endblock LatticeParameters

AtomicCoordinatesFormat NotScaledCartesianAng
%block AtomicCoordinatesAndAtomicSpecies
     0.000000000     0.000000000     9.700000000    1
    -0.000012300     1.420288764     9.700000000    1
%endblock AtomicCoordinatesAndAtomicSpecies



       # --MONKHORST PACK --

%block kgrid_Monkhorst_Pack
16   0   0      0                      # use a large enough kpoint for testing
0    16   0     0
0    0   1      0
%endblock kgrid_Monkhorst_Pack



       # --SELF CONSISTENT FIELD - -

MeshCutoff           $i Ry
PAO.BasisSize        DZP
PAO.BasisType        split
SolutionMethod       diagon
XC.authors           PBE        
XC.functional        GGA
MaxSCFIterations     200
DM.Tolerance         1.d-6    # 0.01 eV
DM.MixingWeight      0.05   
DM.NumberPulay       5  



       # --MOLECULAR DYNAMICS or CONJUGATE GRADIENT METHOD --       
                                                                                            
MD.TypeOfRun         cg     # cg: stuctural optimization
MD.NumCGsteps        0    # maximum number of cg minimization moves; set to 0 when doing a dos calculation
MD.MaxCGDispl        0.05  Ang   
MD.MaxForceTol       0.02 eV/Ang
MD.VariableCell      F      # T: true, cell relaxation; otherwise: F
MD.ConstantVolume    F   

MD.UseSaveXV         T      # read the atomic positions stored in the SystemLabel.XV file
MD.UseSaveCG         T      # read the cg history information stored in the SystemLabel.CG file; used for continuation of the interrupted CG runs
WriteMDHistory       T      # store the atomic coordinates and energy,temperature, etc. in the SystemLabel.MD and SystemLabel.MDE



       # -- SPIN --

SpinPolarized        F      #If spin polarized, use T
DM.InitSpinAF        F      #gives the antiferromagnetic order if T, otherwise all spin up if F

EOF

echo "running the calculation with ecut of $i"
mpirun -np 6 siesta < ecut.fdf > ecut.fdf.sout

E=`grep "siesta:         Total =" ecut.fdf.sout | tail -1| awk '{printf "%12.6f \n", $4}'`
   # read the total energy of the system

echo $i $E >> ../Energy_ecut.dat

cd ../
done
