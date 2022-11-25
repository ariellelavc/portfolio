%chk=NOD_iso_150_275_s2.chk
%mem=2500MB
%nprocshared=8
# ub3lyp chkbasis scf=(qc,maxcycle=999) guess=read geom=allcheckpoint opt=(modredundant,maxcycle=200)

B 47 48 1.50 F
B 47 49 2.75 F




