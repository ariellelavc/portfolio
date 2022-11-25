#!/bin/bash
jobid=`qsub -N trHbN_02011_01                          ./run.cp2k`
jobid=`qsub -N trHbN_02011_02 -W depend=afterok:$jobid ./run.cp2k`
jobid=`qsub -N trHbN_02011_03 -W depend=afterok:$jobid ./run.cp2k`
jobid=`qsub -N trHbN_02011_04 -W depend=afterok:$jobid ./run.cp2k`
jobid=`qsub -N trHbN_02011_05 -W depend=afterok:$jobid ./run.cp2k`
jobid=`qsub -N trHbN_02011_06 -W depend=afterok:$jobid ./run.cp2k`
jobid=`qsub -N trHbN_02011_07 -W depend=afterok:$jobid ./run.cp2k`
jobid=`qsub -N trHbN_02011_08 -W depend=afterok:$jobid ./run.cp2k`
jobid=`qsub -N trHbN_02011_09 -W depend=afterok:$jobid ./run.cp2k`
jobid=`qsub -N trHbN_02011_10 -W depend=afterok:$jobid ./run.cp2k`
