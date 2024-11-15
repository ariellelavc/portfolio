%chk=NOD_iso_150_250_s1.chk
%mem=2500MB
%nprocshared=8
# ub3lyp/gen pseudo=read scf=(maxcycle=999) guess=(only,fragment=3) pop=none

NOD_iso_150_250_s1 FePImOONO wavefunction from broken-symmetry guess

0 2 0 3 0 -3 0 2
 Fe(Fragment=1)     0.00000       0.00000       0.00000
 N(Fragment=1)      0.00000       0.00000       2.02414
 N(Fragment=1)      2.02449       0.00000      -0.01205
 N(Fragment=1)      0.00658      -0.16896      -2.01636
 N(Fragment=1)     -2.01621      -0.16607       0.01956
 C(Fragment=1)     -1.09755      -0.24979      -2.83131
 C(Fragment=1)     -0.68745      -0.25238      -4.22605
 C(Fragment=1)      0.67272      -0.16755      -4.23861
 C(Fragment=1)     -2.84276      -0.10954       1.11819
 C(Fragment=1)     -4.23416      -0.16065       0.69954
 C(Fragment=1)     -4.23057      -0.24690      -0.66023
 C(Fragment=1)     -2.83809      -0.24676      -1.07916
 C(Fragment=1)      1.10387       0.07930       2.83925
 C(Fragment=1)      0.69024       0.15997       4.23101
 C(Fragment=1)     -0.67194       0.13340       4.24058
 C(Fragment=1)      2.84779       0.03277      -1.11465
 C(Fragment=1)      4.23692       0.13102      -0.69756
 C(Fragment=1)      4.23524       0.15890       0.66504
 C(Fragment=1)      2.84636       0.07912       1.08701
 C(Fragment=1)      2.43041       0.10104       2.40970
 H(Fragment=1)      5.07875       0.17916      -1.37010
 H(Fragment=1)      5.07696       0.23322       1.33559
 H(Fragment=1)      3.19777       0.16689       3.17267
 H(Fragment=1)      1.36593       0.23318       5.06864
 H(Fragment=1)     -5.07891      -0.12776       1.36920
 H(Fragment=1)     -5.07327      -0.29965      -1.33152
 C(Fragment=1)     -1.09726       0.03427       2.85377
 C(Fragment=1)     -2.41957      -0.02308       2.44416
 C(Fragment=1)      1.10034      -0.11396      -2.85022
 C(Fragment=1)     -2.42291      -0.30088      -2.39980
 C(Fragment=1)      2.42344      -0.02981      -2.44219
 H(Fragment=1)     -3.19292      -0.36260      -3.16044
 H(Fragment=1)     -1.36418      -0.30440      -5.06448
 H(Fragment=1)      1.33661      -0.13467      -5.08800
 H(Fragment=1)      3.18352       0.00570      -3.21429
 H(Fragment=1)     -3.18255       0.01227       3.21326
 H(Fragment=1)     -1.33970       0.18074       5.08616
 N(Fragment=1)      0.09364      -2.08129       0.08026
 C(Fragment=1)      0.89497      -2.81989      -0.66456
 N(Fragment=1)      0.72124      -4.14073      -0.37617
 C(Fragment=1)     -0.24571      -4.24135       0.60748
 C(Fragment=1)     -0.62388      -2.94694       0.87803
 H(Fragment=1)      1.59041      -2.44709      -1.39783
 H(Fragment=1)      1.21422      -4.91182      -0.80732
 H(Fragment=1)     -0.56666      -5.18450       1.01196
 H(Fragment=1)     -1.35289      -2.58666       1.58238
 O(Fragment=2)      0.01273       1.80579       0.01775
 O(Fragment=2)     -0.93994       2.39916      -0.86469
 N(Fragment=3)     -0.35599       3.18135      -1.88365
 O(Fragment=3)      0.82786       3.19836      -1.91049

C  H  N  O
6-311G(d,p)
****
Fe     0
S   3   1.00
      6.4220000             -0.3927882
      1.8260000              0.7712643
      0.7135000              0.4920228
S   4   1.00
      6.4220000              0.1786877
      1.8260000             -0.4194032
      0.7135000             -0.4568185
      0.1021000              1.1035048
S   1   1.00
      0.0363000              1.0000000
P   3   1.00
     19.4800000             -0.0470282
      2.3890000              0.6248841
      0.7795000              0.4722542
P   1   1.00
      0.0740000              1.0000000
P   1   1.00
      0.0220000              1.0000000
D   4   1.00
     37.0800000              0.0329000
     10.1000000              0.1787418
      3.2200000              0.4487657
      0.9628000              0.5876361
D   1   1.00
      0.2262000              1.0000000
****

FE     0
FE-ECP     2     10
d potential
  3
1    392.6149787            -10.0000000
2     71.1756979            -63.2667518
2     17.7320281            -10.9613338
s-d potential
  5
0    126.0571895              3.0000000
1    138.1264251             18.1729137
2     54.2098858            339.1231164
2      9.2837966            317.1068012
2      8.6289082           -207.3421649
p-d potential
  5
0     83.1759490              5.0000000
1    106.0559938              5.9535930
2     42.8284937            294.2665527
2      8.7701805            154.4244635
2      8.0397818            -95.3164249










