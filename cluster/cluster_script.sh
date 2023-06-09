#!/bin/bash
#PBS -N batch_job
#PBS -l select=1:mem=4gb:scratch_local=10gb:ngpus=1:gpu_cap=cuda60
#PBS -l walltime=0:30:00
#PBS -q gpu

DATADIR=/storage/praha1/home/gajdoma6

test -n "$SCRATCHDIR" || { echo >&2 "Variable SCRATCHDIR is not set!"; exit 1; }

cp -r $DATADIR/data $DATADIR/cluster/denoise_traces_cls.py $DATADIR/cluster/run_cls.py $SCRATCHDIR
cd $SCRATCHDIR

singularity exec -B $SCRATCHDIR:/scratchdir --nv /cvmfs/singularity.metacentrum.cz/NGC/TensorFlow\:22.12-tf2-py3.SIF python /scratchdir/run_cls.py

rm -r $DATADIR/MODEL
mkdir $DATADIR/MODEL
cp -r $SCRATCHDIR/CLS_MODEL $DATADIR/MODEL/CLS_MODEL
cp $SCRATCHDIR/history.json $DATADIR/MODEL/history.json

clean_scratch
