#!/usr/bin/env bash

source myenv/bin/activate
pip install .
#pip install --upgrade pip

for ARCH in attentive_lstm pointer_generator_lstm \
            pointer_generator_transformer transducer transformer; do
  for SEED in 144 233 377 610 987; do
      yoyodyne-train \
        --model_dir results \
        --experiment "ady_${ARCH}_${SEED}" \
        --train ady/ady_train.tsv \
        --val ady/ady_dev.tsv \
        --arch ${ARCH} \
        --seed "${SEED}"
      yoyodyne-predict \
        --model_dir results \
        --experiment "ady_${ARCH}_${SEED}" \
        --checkpoint results/ady_${ARCH}_${SEED}/version_0/checkpoints/*.ckpt \
        --predict ady/ady_test.tsv \
        --arch ${ARCH} \
        --output results/ady_${ARCH}_${SEED}/pred_${ARCH}_${SEED}
      ./wer.py \
        ady/ady_test.tsv \
        results/ady_${ARCH}_${SEED}/pred_${ARCH}_${SEED}
  done
done

"""
# How to incoporate the following?
# Creates a sweep; save the sweep ID as ${SWEEP_ID} for later.
wandb sweep --entity "${ENTITY}" --project "${PROJECT}" config.yaml
# Runs the sweep itself.
./train_wandb_sweep.py --entity "${ENTITY}" --project "${PROJECT}" \
     --sweep_id "${SWEEP_ID}" --count "${COUNT}" ...
"""