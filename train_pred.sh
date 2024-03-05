#!/usr/bin/env bash

source myenv/bin/activate
pip install .
#pip install --upgrade pip

for ARCH in attentive_lstm pointer_generator_lstm \
            pointer_generator_transformer transducer transformer; do
  for SEED in 144 233 377 610 987; do
      yoyodyne-train \
        --model_dir results \
        --experiment "eng_${ARCH}_${SEED}" \
        --train data/celex_nettalk/train.tsv \
        --val data/celex_nettalk/dev.tsv \
        --arch ${ARCH} \
        --seed "${SEED}"
      yoyodyne-predict \
        --model_dir results \
        --experiment "eng_${ARCH}_${SEED}" \
        --checkpoint results/eng_${ARCH}_${SEED}/version_0/checkpoints/*.ckpt \
        --predict data/celex_nettalk/test.tsv \
        --arch ${ARCH} \
        --output results/eng_${ARCH}_${SEED}/pred_${ARCH}_${SEED}
      ./wer.py \
        data/celex_nettalk/test.tsv \
        results/eng_${ARCH}_${SEED}/pred_${ARCH}_${SEED}
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