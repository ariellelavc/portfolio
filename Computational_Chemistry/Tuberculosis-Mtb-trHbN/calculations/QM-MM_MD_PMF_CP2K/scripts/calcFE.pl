#!/usr/bin/perl

# Summary:
# Reconstruct the free energy surface from forces

use strict;
use Getopt::Long;
use Math::MatrixReal;
use Math::Amoeba qw(MinimiseND);
my $inputFile;

GetOptions('input=s' => \$inputFile);

open(IFILE,"<$inputFile") or die "Cannot open file to read: $!\n";
my @file_data = <IFILE>;
print @file_data;
close(IFILE);

my $nDim = 2;

my $nPoints = 0;
my @coor = ();
my @force = ();

while ($file_data[$nPoints] =~ m/^\s*(-?\d+[.]?\d+)\s*(-?\d+[.]?\d+)\s*(-?\d+[.]?\d+)\s*(-?\d+[.]?\d+)\s*$/) {
    $nPoints++;
    push(@coor,[$1,$2]);
    push(@force,[$3,$4]);
    #print $nPoints + "\n";
    #print @coor + "\n";
}
print $nPoints + "\n";

my $matrix_A = new Math::MatrixReal(1,$nPoints);
#Scan:
#my $output = "output.out";
#open(OUTFILE,">$output") or die "Cannot open $output to write!\n";
#for (my $i=0;$i<100;$i++) {
# my $sigma =0.3 + $i/500;
# build_A($sigma);
# my $err = calc_err($sigma);
# print "$sigma : $err\n";
# print OUTFILE "$sigma : $err\n";
#}
#close(OUTFILE);

#Ameoba minimization:
#
my @guess = ();
push(@guess,0.4);
my @scale = ();
push(@scale,0.05);
my ($p,$y) = MinimiseND( \@guess,\@scale,\&calculate_chi_square,1e-3, 20000);

print "(",join(',',@{$p}),")=$y\n";
# Final print:
#
my $sigma = 1.2;
build_A($sigma);
my $err = calc_err($sigma);
print $err;
my @FE = build_FE($sigma);
my $output = "output.out";
open(OUTFILE,">$output") or die "Cannot open $output to write!\n";
for (my $i=0;$i<$nPoints;$i++) {
 for (my $j=0;$j<$nDim;$j++) {
   print OUTFILE "$coor[$i]->[$j] ";
 }
 print OUTFILE "$FE[$i]\n";
}
close(OUTFILE);

sub calc_dist {
  my $p1 = $_[0];
  my $p2 = $_[1];
  
  # For 2D.
  my $dist = sqrt(($coor[$p1]->[0]-$coor[$p2]->[0])**2 + ($coor[$p1]->[1]-$coor[$p2]->[1])**2);
  return $dist;
}

sub calc_Gaussian {
  my $p1 = $_[0];
  my $p2 = $_[1];
  my $sigma = $_[2];
  my $gauss = exp((-(calc_dist($p1,$p2)/$sigma)**2)/2.0);
  return $gauss;
}

sub calc_f_Gaussian {
  my $p1 = $_[0];
  my $p2 = $_[1];
  my $sigma = $_[2]; 
  my $gauss = calc_Gaussian($p1,$p2,$sigma);
  my $factor = $gauss * (-1.0/$sigma**2);
  my @result = ();
  push(@result,$factor*($coor[$p1]->[0]-$coor[$p2]->[0]));
  push(@result,$factor*($coor[$p1]->[1]-$coor[$p2]->[1]));
  return @result;
}

sub calc_dot_prod {
  my @v1;
  my @v2;
  my $i = 0;
  for my $temp (@_) {
   if ($i==0) {
     @v1 = @$temp;
   }
   else {
     @v2 = @$temp;
   }
   $i++;
  }

  my $result = 0.0;
  
  my $i;
  for ($i=0;$i<$nDim;$i++) {
    $result += $v1[$i]*$v2[$i];
  }

  return $result;
}

sub build_B {
  my $sigma = $_[0];
  my $B = new Math::MatrixReal($nPoints,$nPoints);
  for (my $i=0;$i<$nPoints;$i++) {
    for (my $j=0;$j<$nPoints;$j++) {
      my $value = 0.0;
      for (my $k=0;$k<$nPoints;$k++) {
        my @v1 = calc_f_Gaussian($i,$k,$sigma);
        my @v2 = calc_f_Gaussian($k,$j,$sigma);
        $value += calc_dot_prod(\@v1,\@v2);
      }
      $B->assign($i+1,$j+1,$value);
    }
  }
  
  return $B;
}

sub build_C {
  my $sigma = $_[0];
  my $C = new Math::MatrixReal($nPoints,1);
  for (my $i=0;$i<$nPoints;$i++) {
    my $value = 0.0;
    for (my $j=0;$j<$nPoints;$j++) {
      my @v1 = calc_f_Gaussian($i,$j,$sigma); 
      my @v2 = @{$force[$j]};
      $value += calc_dot_prod(\@v1,\@v2);
    }
    $C->assign($i+1,1,-$value);
  }
  
  return $C;
}

sub build_A {
        my $sigma = $_[0];
  my $B = build_B($sigma);
  my $C = build_C($sigma);
  
  my ($solution,@solution,$dimension,$base_matrix);
  my $LR = decompose_LR $B;
  ($dimension, $solution, $base_matrix) = $LR->solve_LR($C);
  $matrix_A = $solution; #$B->inverse * $C;
}

sub calc_err {
        my $sigma = $_[0];
  my $error = 0.0;
  for (my $i=0;$i<$nPoints;$i++) {
    my $forceTerm = 0.0;
    my @f_calc = ();
    for (my $k=0;$k<$nDim;$k++) {
      $f_calc[$k]=0.0;
    } 
    for (my $j=0;$j<$nPoints;$j++) {
      my @deriv = calc_f_Gaussian($i,$j,$sigma);
      for (my $k=0;$k<$nDim;$k++) {
        $f_calc[$k] += $matrix_A->element($j+1,1) * $deriv[$k];
      }
    }
    my @forceItem = @{$force[$i]};
    for (my $k=0;$k<$nDim;$k++) {
      $f_calc[$k] += $forceItem[$k];
    }
    
    for (my $k=0;$k<$nDim;$k++) {
      $error += $f_calc[$k]**2;
    } 
  }
  return $error;
}

sub build_FE {
  my $sigma = $_[0];
  my @FE = ();
  my $minValue = 999999.9;
  for (my $i=0;$i<$nPoints;$i++) {
    $FE[$i] = 0.0;
    for (my $j=0;$j<$nPoints;$j++) {
      $FE[$i] += $matrix_A->element($j+1,1) * calc_Gaussian($i,$j,$sigma);
    }
    if ($FE[$i] < $minValue) {
      $minValue = $FE[$i];
    }
  }
  for (my $i=0;$i<$nPoints;$i++) {
    $FE[$i] -= $minValue;
  }
  return @FE;
}

sub calculate_chi_square {
        my $sigma = $_[0];
  print "Y:$sigma\n";
  build_A($sigma);
  my $err = calc_err($sigma);
  print "X:$err\n";
  return $err;
}
