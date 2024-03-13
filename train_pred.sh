#!/usr/bin/env bash

#python -m venv myenv
source myenv/bin/activate
#pip install .
#pip install wandb --upgrade

for SEED in 144 233 377 610 987; do
    ./train_wandb_sweep.py \
        --entity "g-p2p" \
        --project "eng-celex-nettalk" \
        --sweep_id "pwt3ffm1" \
        --count "200" \
        --model_dir results \
        --arch attentive_lstm \
        --experiment "eng_attentive_lstm_${SEED}" \
        --train tsv/eng/gp2p-CELEX-NETTalk-column-train.tsv \
        --val tsv/eng/gp2p-CELEX-NETTalk-column-dev.tsv \
        --target_col 3
    yoyodyne-predict \
        --model_dir results \
        --experiment "eng_attentive_lstm_${SEED}" \
        --checkpoint results/eng_attentive_lstm_${SEED}/version_0/checkpoints/*.ckpt \
        --arch attentive_lstm \
        --predict tsv/eng/gp2p-CELEX-NETTalk-column-test.tsv \
        --output results/eng_attentive_lstm_${SEED}/pred_attentive_lstm_${SEED}
    evaulate.py \
        --tsv_path results/eng_attentive_lstm_${SEED}/pred_attentive_lstm_${SEED}
done