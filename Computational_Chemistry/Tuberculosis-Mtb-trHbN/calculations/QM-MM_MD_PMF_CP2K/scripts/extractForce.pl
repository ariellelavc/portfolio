#!/usr/bin/perl
use Getopt::Long;
use DBI();
use Cwd;

my $jobname;
GetOptions(  'jobname=s' => \$jobname );

my $fileName= $jobname.".LagrangeMultLog";
open(INFILE,"<$fileName") or die "Cannot open $fileName to read!\n";

my @shake;
my @rattle;
my $previousLine = "";
my $previousLine2 = "";
foreach my $line(<INFILE>) {
    if(!($line =~ m/^\s*$/))
    {
      if ($line =~ m/Shake\s+Lagrangian\s+Multipliers/) {
        my @forces = split(/\s+/,$previousLine);
        if(scalar(@forces)>2)
        {
          push(@rattle,"$forces[$#forces-1];$forces[$#forces]");
        }
        elsif(scalar(@forces)==2)
        {
          my @forces1 = split(/\s+/,$previousLine2);
          if(scalar(@forces1)>0)
          {
            push(@rattle,"$forces1[$#forces1];$forces[$#forces]");
          }
        }
      }
      if ($line =~ m/Rattle\s+Lagrangian\s+Multipliers/) {
        my @forces = split(/\s+/,$previousLine);
        if(scalar(@forces)>2)
        {
          push(@shake,"$forces[$#forces-1];$forces[$#forces]");
        }
        elsif(scalar(@forces)==2)
        {
          my @forces1 = split(/\s+/,$previousLine2);
          if(scalar(@forces1)>0)
          {
            push(@shake,"$forces1[$#forces1];$forces[$#forces]");
          } 
        }
      }
      $previousLine2 = $previousLine;
      $previousLine = $line;
    }
}

my @forces = split(/\s+/,$previousLine);
if(scalar(@forces)>2)
{
  push(@rattle,"$forces[$#forces-1];$forces[$#forces]");
}
elsif(scalar(@forces)==2)
{
  my @forces1 = split(/\s+/,$previousLine2);
  if(scalar(@forces1)>0)
  {
     push(@rattle,"$forces1[$#forces1];$forces[$#forces]");
  } 
} 

close(INFILE);


my $outputFile=$jobname.".ShakeForce";
open(OUTFILE,">$outputFile") or die "Cannot open $outputFile to write: $!\n";
foreach (@shake) { print OUTFILE "$_\n"; }
close(OUTFILE);

my $outputFile=$jobname.".RattleForce";
open(OUTFILE,">$outputFile") or die "Cannot open $outputFile to write: $!\n";
foreach (@rattle) { print OUTFILE "$_\n"; }
close(OUTFILE);

if(scalar(@shake)==scalar(@rattle))
{
#remove the big file:
  system("rm $fileName");
}
else
{
 print "Error: Not the same number of Shake forces and Rattle forces!";
}


