#!/usr/bin/perl
use Getopt::Long;
use DBI();
use Cwd;

my @jobs = ("02001","02002","02003","02004","02005","02006","02008","02011","02012","02013","02014","02015","02016","02017","02018","02019","02020","02021","02022","02023","02024","02026","02027","02028","02029","02030","02031","02032","02033","02034","02035","02036","02037","02038","02039","02040","02041","02042","02043","02044","02045","02046","02047","02048","02049","02050","02051","02052","02053","02054","02055","02056","02057","02058","02059","02060","02061","02062","02063","02064","02065","02066","02067","02068","02069","02070","02071","02072","02073","02074","02075","02076","02077","02078","02079","02080","02081","02082","02083","02084","02085","02086","02087","02088","02089","02090","02091","02092","02093","02094","02095","02096","02097","02098","02099","020100","020101","020102","020103","020104","020105","020106","020107","020108","020109","020110","020111","020112","020113","020114","020115","020116","020117","020118","020119","020120","020121","020122","020123","020124","020125");

my @rcoors = ();
my @rcoors2= ();

foreach my $job(@jobs)
{
  $firstRC=getRC1(substr($job,2,4));
  $secondRC=getRC2(substr($job,2,4));
  push(@rcoors,$firstRC);
  push(@rcoors2,$secondRC);
}
my %forcesx = ();
my %forcesy = ();

my $maxRuns = 20;
my $maxItems = 0;
my $KConvert = 1182.0;
my $NAve=20;

foreach my $job(@jobs)
{
 my @forceList = ();
 my @forceListb = ();
 my $i=1;
 while ($i<=$maxRuns)
 {
   my $runNumber=$i;
   if($i<10)
   {
     $runNumber="0$i"; 
   }
   my $fileName= "trHbN_$job"."_$runNumber.ShakeForce"; 
   if (-e "$fileName") 
   {
     open(INFILE,"<$fileName") or die "Cannot open $fileName to read!\n";
     foreach my $line(<INFILE>) 
     {
       if($line =~ m/(-?\d+[.]?\d*);(-?\d+[.]?\d*)/)
       {
         push(@forceList,$1); 
         push(@forceListb,$2);
       }
     }
     close(INFILE);
   }
   else
   {
     $i=$maxRuns;
   }
   $i++;
 }
 if(scalar(@forceList>$maxItems))
 {
   $maxItems = scalar(@forceList);
 }
 $forcesx{$job}=\@forceList;
 $forcesy{$job}=\@forceListb;
}

my $fileName="forces_raw3x.out";
open(OUTFILE1x,">$fileName") or die "Cannot open $fileName to write!\n";

$fileName="forces_converted3x.out"; #use this
open(OUTFILE2x,">$fileName") or die "Cannot open $fileName to write!\n";

$fileName="forces_ave3x.out";
open(OUTFILE3x,">$fileName") or die "Cannot open $fileName to write!\n";

my $fileName="forces_raw3y.out";
open(OUTFILE1y,">$fileName") or die "Cannot open $fileName to write!\n";

$fileName="forces_converted3y.out";
open(OUTFILE2y,">$fileName") or die "Cannot open $fileName to write!\n";

$fileName="forces_ave3y.out";
open(OUTFILE3y,">$fileName") or die "Cannot open $fileName to write!\n";


foreach my $job(@jobs)
{
  print OUTFILE1x ",$job";
  print OUTFILE2x ",$job";
  print OUTFILE3x ",$job";
  print OUTFILE1y ",$job";
  print OUTFILE2y ",$job";
  print OUTFILE3y ",$job";
}
print OUTFILE1x "\n";
print OUTFILE2x "\n";
print OUTFILE3x "\n";
print OUTFILE1y "\n";
print OUTFILE2y "\n";
print OUTFILE3y "\n";

foreach my $rcoor(@rcoors)
{
  print OUTFILE1x ",$rcoor";
  print OUTFILE2x ",$rcoor";
  print OUTFILE3x ",$rcoor";
  print OUTFILE1y ",$rcoor";
  print OUTFILE2y ",$rcoor";
  print OUTFILE3y ",$rcoor";
}
print OUTFILE1x "\n";
print OUTFILE2x "\n";
print OUTFILE3x "\n";
print OUTFILE1y "\n";
print OUTFILE2y "\n";
print OUTFILE3y "\n";

foreach my $rcoor2(@rcoors2)
{
  print OUTFILE1x ",$rcoor2";
  print OUTFILE2x ",$rcoor2";
  print OUTFILE3x ",$rcoor2";
  print OUTFILE1y ",$rcoor2";
  print OUTFILE2y ",$rcoor2";
  print OUTFILE3y ",$rcoor2";
}
print OUTFILE1x "\n";
print OUTFILE2x "\n";
print OUTFILE3x "\n";
print OUTFILE1y "\n";
print OUTFILE2y "\n";
print OUTFILE3y "\n";

my $i;
for($i=0;$i<$maxItems;$i++)
{
 print OUTFILE1x $i+1;
 print OUTFILE2x ($i+1)/2000;
 print OUTFILE3x ($i+1)/2000;
 print OUTFILE1y $i+1;
 print OUTFILE2y ($i+1)/2000;
 print OUTFILE3y ($i+1)/2000;

 foreach my $job(@jobs)
 { 
  my $temp_refx = $forcesx{$job};
  my @tempx = @$temp_refx;
  my $temp_refy = $forcesy{$job};
  my @tempy = @$temp_refy;

  my $forceValue1x;
  my $forceValue2x;
  my $forceValue3x;
  my $forceValue1y;
  my $forceValue2y;
  my $forceValue3y;

  if(scalar(@tempx)>$i)
  {
    $forceValue1x = $tempx[$i];
    $forceValue2x = $tempx[$i]*$KConvert;
    $forceValue1y = $tempy[$i];
    $forceValue2y = $tempy[$i]*$KConvert;

    if(scalar(@tempx)>($i+$NAve))
    {
      my $j;
      $forceValue3x = 0.0;
      $forceValue3y = 0.0;
      for($j=0;$j<$NAve;$j++)
      {
       $forceValue3x += $tempx[$i+$j]*$KConvert;
       $forceValue3y += $tempy[$i+$j]*$KConvert;
      }
      $forceValue3x /= $NAve;
      $forceValue3y /= $NAve;
    }
  }
  print OUTFILE1x ",$forceValue1x";
  print OUTFILE2x ",$forceValue2x";
  print OUTFILE3x ",$forceValue3x";
  print OUTFILE1y ",$forceValue1y";
  print OUTFILE2y ",$forceValue2y";
  print OUTFILE3y ",$forceValue3y";
 }
 print OUTFILE1x "\n";
 print OUTFILE2x "\n";
 print OUTFILE3x "\n";
 print OUTFILE1y "\n";
 print OUTFILE2y "\n";
 print OUTFILE3y "\n";

}

close(OUTFILE1x);
close(OUTFILE2x);
close(OUTFILE3x);
close(OUTFILE1y);
close(OUTFILE2y);
close(OUTFILE3y);

sub getRC1 {
  my $RCstring = $_[0];
  if($RCstring == "001")
  {return  1.5; }
  if($RCstring == "002")
  {return  2.0;}
  if($RCstring == "003")
  {return  2.0; }
  if($RCstring == "004")
  {return  1.75;}
  if($RCstring == "005")
  {return  2.0; }
  if($RCstring == "006")
  {return  1.5;}
  if($RCstring == "007")
  {return  1.0; }
  if($RCstring == "008")
  {return  1.5;}
  if($RCstring == "009")
  {return  1.0; }
  if($RCstring == "010")
  {return  1.0;}
  if($RCstring == "011")
  {return  1.75;}
  if($RCstring == "012")
  {return  2.25;}
  if($RCstring == "013")
  {return  2.25;}
  if($RCstring == "014")
  {return  2.25;}
  if($RCstring == "015")
  {return  2.25;}
  if($RCstring == "016")
  {return  2.25;}
  if($RCstring == "017")
  {return  2.0;}
  if($RCstring == "018")
  {return  2.0;}
  if($RCstring == "019")
  {return  2.25;}
  if($RCstring == "020")
  {return  2.5;}
  if($RCstring == "021")
  {return  2.5;}
  if($RCstring == "022")
  {return  2.0;}
  if($RCstring == "023")
  {return  2.5;}
  if($RCstring == "024")
  {return  2.25;}
  if($RCstring == "025")
  {return  2.5;}
  if($RCstring == "026")
  {return  2.0;}
  if($RCstring == "027")
  {return  1.75;}
  if($RCstring == "028")
  {return  2.5;}
  if($RCstring == "029")
  {return  2.25;}
  if($RCstring == "030")
  {return  2.5;}
  if($RCstring == "031")
  {return  2.75;}
  if($RCstring == "032")
  {return  2.75;}
  if($RCstring == "033")
  {return  2.75;}
  if($RCstring == "034")
  {return  3.0;}
  if($RCstring == "035")
  {return  2.5;}
  if($RCstring == "036")
  {return  2.75;}
  if($RCstring == "037")
  {return  2.5;}
  if($RCstring == "038")
  {return  2.75;}
  if($RCstring == "039")
  {return  3.0;}
  if($RCstring == "040")
  {return  3.0;}
  if($RCstring == "041")
  {return  3.25;}


  if($RCstring == "042")
  {return  3.5;}
  if($RCstring == "043")
  {return  3.75;}
  if($RCstring == "044")
  {return  3.25;}
  if($RCstring == "045")
  {return  3.5;}
  if($RCstring == "046")
  {return  3.75;}
  if($RCstring == "047")
  {return  3.25;}
  if($RCstring == "048")
  {return  3.5;}
  if($RCstring == "049")
  {return  3.75;}
  if($RCstring == "050")
  {return  3.0;}
  if($RCstring == "051")
  {return  3.25;}
  if($RCstring == "052")
  {return  3.5;}
  if($RCstring == "053")
  {return  3.75;}
  if($RCstring == "054")
  {return  2.75;}
  if($RCstring == "055")
  {return  3.0;}
  if($RCstring == "056")
  {return  3.25;}
  if($RCstring == "057")
  {return  3.5;}
  if($RCstring == "058")
  {return  2.75;}
  if($RCstring == "059")
  {return  3.0;}
  if($RCstring == "060")
  {return  3.25;}
  if($RCstring == "061")
  {return  2.75;}
  if($RCstring == "062")
  {return  3.0;}
  if($RCstring == "063")
  {return  2.5;}
  if($RCstring == "064")
  {return  2.75;}
  if($RCstring == "065")
  {return  2.25;}
  if($RCstring == "066")
  {return  2.5;}
  if($RCstring == "067")
  {return  2.0;}
  if($RCstring == "068")
  {return  1.5;}
  if($RCstring == "069")
  {return  1.5;}
  if($RCstring == "070")
  {return  1.25;}
  if($RCstring == "071")
  {return  1.25;}
  if($RCstring == "072")
  {return  1.25;}
  if($RCstring == "073")
  {return  1.25;}
  if($RCstring == "074")
  {return  1.25;}
  if($RCstring == "075")
  {return  1.75;}
  if($RCstring == "076")
  {return  1.75;}
  if($RCstring == "077")
  {return  2.75;}
  if($RCstring == "078")
  {return  1.5;}
  if($RCstring == "079")
  {return  1.75;}
  if($RCstring == "080")
  {return  1.75;}
  if($RCstring == "081")
  {return  1.75;}
  if($RCstring == "082")
  {return  1.5;}
  if($RCstring == "083")
  {return  2.75;}
  if($RCstring == "084")
  {return  3.25;}
  if($RCstring == "085")
  {return  2.5;}
  if($RCstring == "086")
  {return  3.25;}
  if($RCstring == "087")
  {return  3.0;}
  if($RCstring == "088")
  {return  3.25;}
  if($RCstring == "089")
  {return  3.0;}
  if($RCstring == "090")
  {return  1.75;}
  if($RCstring == "091")
  {return  2.0;}
  if($RCstring == "092")
  {return  2.25;}
  if($RCstring == "093")
  {return  1.5;}
  if($RCstring == "094")
  {return  1.25;}
  if($RCstring == "095")
  {return  1.25;}
  if($RCstring == "096")
  {return  1.5;}
  if($RCstring == "097")
  {return  1.75;}
  if($RCstring == "098")
  {return  2.0;}
  if($RCstring == "099")
  {return  2.5;}
  if($RCstring == "0100")
  {return  3.5;}
  if($RCstring == "0101")
  {return  3.25;}
  if($RCstring == "0102")
  {return  3.5;}
  if($RCstring == "0103")
  {return  3.75;}
  if($RCstring == "0104")
  {return  3.75;}
  if($RCstring == "0105")
  {return  3.0;}
  if($RCstring == "0106")
  {return  3.25;}
  if($RCstring == "0107")
  {return  3.0;}
  if($RCstring == "0108")
  {return  3.5;}
  if($RCstring == "0109")
  {return  3.75;}
  if($RCstring == "0110")
  {return  3.5;}
  if($RCstring == "0111")
  {return  3.75;}
  if($RCstring == "0112")
  {return  3.75;}
  if($RCstring == "0113")
  {return  3.5;}
  if($RCstring == "0114")
  {return  3.5;}
  if($RCstring == "0115")
  {return  3.75;}
  if($RCstring == "0116")
  {return  3.75;}
  if($RCstring == "0117")
  {return  1.75;}
  if($RCstring == "0118")
  {return  1.5;}
  if($RCstring == "0119")
  {return  1.25;}
  if($RCstring == "0120")
  {return  2.0;}
  if($RCstring == "0121")
  {return  2.25;}
  if($RCstring == "0122")
  {return  1.25;}
  if($RCstring == "0123")
  {return  1.25;}
  if($RCstring == "0124")
  {return  1.5;}
  if($RCstring == "0125")
  {return  1.25;}

  exit;
}

sub getRC2 {
  my $RCstring = $_[0];
  if($RCstring == "001")
  {return  2.5; }
  if($RCstring == "002")
  {return  2.5;}
  if($RCstring == "003")
  {return  3.0; }
  if($RCstring == "004")
  {return  2.25;}
  if($RCstring == "005")
  {return  2.0; }
  if($RCstring == "006")
  {return  2.0;}
  if($RCstring == "007")
  {return  2.5; }
  if($RCstring == "008")
  {return  3.0;}
  if($RCstring == "009")
  {return  2.0; }
  if($RCstring == "010")
  {return  3.0;}
  if($RCstring == "011")
  {return  2.75;}
  if($RCstring == "012")
  {return  2.0;}
  if($RCstring == "013")
  {return  2.25;}
  if($RCstring == "014")
  {return  2.5;}
  if($RCstring == "015")
  {return  2.75;}
  if($RCstring == "016")
  {return  3.0;}
  if($RCstring == "017")
  {return  2.25;}
  if($RCstring == "018")
  {return  2.75;}
  if($RCstring == "019")
  {return  1.75;}
  if($RCstring == "020")
  {return  1.75;}
  if($RCstring == "021")
  {return  2.0;}
  if($RCstring == "022")
  {return  1.75;}
  if($RCstring == "023")
  {return  2.25;}
  if($RCstring == "024")
  {return  1.5;}
  if($RCstring == "025")
  {return  1.5;}
  if($RCstring == "026")
  {return  1.5;}
  if($RCstring == "027")
  {return  2.5;}
  if($RCstring == "028")
  {return  3.0;}
  if($RCstring == "029")
  {return  3.25;}
  if($RCstring == "030")
  {return  3.25;}
  if($RCstring == "031")
  {return  2.0;}
  if($RCstring == "032")
  {return  2.25;}
  if($RCstring == "033")
  {return  1.75;}
  if($RCstring == "034")
  {return  2.25;}
  if($RCstring == "035")
  {return  2.75;}
  if($RCstring == "036")
  {return  2.75;}
  if($RCstring == "037")
  {return  2.5;}
  if($RCstring == "038")
  {return  2.5;}
  if($RCstring == "039")
  {return  2.5;}
  if($RCstring == "040")
  {return  2.75;}
  if($RCstring == "041")
  {return  3.0;}
  if($RCstring == "042")
  {return  3.25;}
  if($RCstring == "043")
  {return  3.5;}
  if($RCstring == "044")
  {return  2.75;}
  if($RCstring == "045")
  {return  3.0;}
  if($RCstring == "046")
  {return  3.25;}
  if($RCstring == "047")
  {return  2.5;}
  if($RCstring == "048")
  {return  2.75;}
  if($RCstring == "049")
  {return  3.0;}
  if($RCstring == "050")
  {return  3.0;}
  if($RCstring == "051")
  {return  3.25;}
  if($RCstring == "052")
  {return  3.5;}
  if($RCstring == "053")
  {return  3.75;}
  if($RCstring == "054")
  {return  3.0;}
  if($RCstring == "055")
  {return  3.25;}
  if($RCstring == "056")
  {return  3.5;}
  if($RCstring == "057")
  {return  3.75;}
  if($RCstring == "058")
  {return  3.25;}
  if($RCstring == "059")
  {return  3.5;}
  if($RCstring == "060")
  {return  3.75;}
  if($RCstring == "061")
  {return  3.5;}
  if($RCstring == "062")
  {return  3.75;}
  if($RCstring == "063")
  {return  3.5;}
  if($RCstring == "064")
  {return  3.75;}
  if($RCstring == "065")
  {return  1.25;}
  if($RCstring == "066")
  {return  1.25;}
  if($RCstring == "067")
  {return  1.25;}  
  if($RCstring == "068")
  {return  2.25;}
  if($RCstring == "069")
  {return  2.75;}
  if($RCstring == "070")
  {return  2.5;}
  if($RCstring == "071")
  {return  2.75;}
  if($RCstring == "072")
  {return  3.0;}
  if($RCstring == "073")
  {return  2.25;}
  if($RCstring == "074")
  {return  2.0;}
  if($RCstring == "075")
  {return  1.25;}
  if($RCstring == "076")
  {return  1.75;}
  if($RCstring == "077")
  {return  1.25;}
  if($RCstring == "078")
  {return  1.75;}
  if($RCstring == "079")
  {return  2.0;}
  if($RCstring == "080")
  {return  3.0;}
  if($RCstring == "081")
  {return  1.5;}
  if($RCstring == "082")
  {return  1.5;}
  if($RCstring == "083")
  {return  1.5;}
  if($RCstring == "084")
  {return  1.75;}
  if($RCstring == "085")
  {return  1.5;}
  if($RCstring == "086")
  {return  1.25;}
  if($RCstring == "087")
  {return  2.0;}
  if($RCstring == "088")
  {return  2.0;}
  if($RCstring == "089")
  {return  1.75;}
  if($RCstring == "090")
  {return  3.25;}
  if($RCstring == "091")
  {return  3.25;}
  if($RCstring == "092")
  {return  3.5;}
  if($RCstring == "093")
  {return  3.25;}
  if($RCstring == "094")
  {return  3.25;}
  if($RCstring == "095")
  {return  3.5;}
  if($RCstring == "096")
  {return  3.5;}
  if($RCstring == "097")
  {return  3.5;}
  if($RCstring == "098")
  {return  3.5;}
  if($RCstring == "099")
  {return  3.75;}
  if($RCstring == "0100")
  {return  2.25;}
  if($RCstring == "0101")
  {return  2.25;}
  if($RCstring == "0102")
  {return  2.5;}
  if($RCstring == "0103")
  {return  2.25;}
  if($RCstring == "0104")
  {return  2.75;}
  if($RCstring == "0105")
  {return  1.5;}
  if($RCstring == "0106")
  {return  1.5;}
  if($RCstring == "0107")
  {return  1.25;}
  if($RCstring == "0108")
  {return  2.0;}
  if($RCstring == "0109")
  {return  1.75;}
  if($RCstring == "0110")
  {return  1.25;}
  if($RCstring == "0111")
  {return  1.25;}
  if($RCstring == "0112")
  {return  2.5;}
  if($RCstring == "0113")
  {return  1.5;}
  if($RCstring == "0114")
  {return  1.75;}
  if($RCstring == "0115")
  {return  2.0;}
  if($RCstring == "0116")
  {return  1.5;}
  if($RCstring == "0117")
  {return  3.75;}
  if($RCstring == "0118")
  {return  3.75;}
  if($RCstring == "0119")
  {return  3.75;}
  if($RCstring == "0120")
  {return  3.75;}
  if($RCstring == "0121")
  {return  3.75;}
  if($RCstring == "0122")
  {return  1.75;}
  if($RCstring == "0123")
  {return  1.5;}
  if($RCstring == "0124")
  {return  1.25;}
  if($RCstring == "0125")
  {return  1.25;}

  exit;
}





