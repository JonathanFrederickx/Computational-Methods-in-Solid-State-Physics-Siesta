#!/bin/bash

touch Energy_kpt.dat         # create a file to store the energy information
for i in `seq -w 1 1 20`; do    # 1 2 3 4 5 6 ... 20 for kpoint grid
mkdir $i; cp *.psf $i
cd $i

cat >kpt.fdf<<EOF

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
$i   0   0      0
0    $i   0     0
0    0   1      0
%endblock kgrid_Monkhorst_Pack



       # --SELF CONSISTENT FIELD - -

MeshCutoff           300 Ry       # use a large enough cutoff energy for testing
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
MD.NumCGsteps        0    # maximum number of cg minimization moves
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
echo "running the calculation with kpoint of $i"
mpirun -np 6 siesta < kpt.fdf > kpt.fdf.sout

E=`grep "siesta:         Total =" kpt.fdf.sout | tail -1| awk '{printf "%12.6f \n", $4}'`
   # read the total energy of the system

echo $i $E >> ../Energy_kpt.dat

cd ../
done
