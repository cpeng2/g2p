#!/bin/bash

set -x

python -m venv myenv
source myenv/bin/activate

export TRAIN="tsv/eng/gp2p-CELEX-NETTalk-control-train.tsv"
export VAL="tsv/eng/gp2p-CELEX-NETTalK-control-dev.tsv"
export PREDICT="tsv/eng/gp2p-CELEX-NETTalk-control-test.tsv"
export ARCH="transformer"

export SEED=42
./sweep.py \
    --entity g-p2p \
    --project trans-ctrl \
    --sweep_id elapifu0 \
    --count 200 \
    --arch "${ARCH}" \
    --model_dir results/"eng_trans_ctrl_clx_nttk_${SEED}" \
    --train "${TRAIN}" \
    --val "${VAL}" \
    --source_sep " " \
    --target_sep " " \
    --seed "${SEED}" \
    --max_epochs 50 \
    --accelerator gpu

# Fetch and export best hyperparameters
eval "$(python ./best_hyperparameters.py \
              --entity g-p2p \
              --project trans-ctrl \
              --sweep_id elapifu0 \
              | sed -E 's/--([a-zA-Z0-9_]+) ([^ ]+)/\1="\2"/g' \
              | sed 's/^/export /')"

# Experiment with 5 seeds
for SEED in 144 233 377 610 987; do
    yoyodyne-train \
        --arch "${ARCH}" \
        --model_dir results/"eng_trans_ctrl_clx_nttk_${SEED}" \
        --train "${TRAIN}" \
        --val "${VAL}" \
        --source_sep " " \
        --target_sep " " \
        --features_sep " " \
        --seed "${SEED}" \
        --batch_size "${batch_size:-64}" \
        --beta1 0.9 \
        --beta2 0.999 \
        --decoder_layers 1 \
        --dropout "${dropout:-0.05811570547102013}" \
        --embedding_size "${embedding_size:-272}" \
        --encoder_layers 1 \
        --features_attention_heads 1 \
        --hidden_size "${hidden_size:-864}" \
        --label_smoothing "${label_smoothing:-0.08109528615720343}" \
        --learning_rate "${learning_rate:-0.00012206891601741508}" \
        --max_source_length 128 \
        --max_target_length 128 \
        --optimizer adam \
        --check_val_every_n_epoch 1 \
        --reduceonplateau_factor 0.1 \
        --reduceonplateau_patience 10 \
        --warmup_steps 0 \
        --source_attention_heads 4 \
        --attention_context "${attention_context:-0}" \
        --max_epochs 50 \
        --accelerator gpu
    for folder in results/"eng_trans_ctrl_clx_nttk_${SEED}"/lightning_logs/version_*; do
        if [ -d "$folder" ]; then
            yoyodyne-predict \
                --arch "${ARCH}" \
                --model_dir results/"eng_trans_ctrl_clx_nttk_${SEED}" \
                --checkpoint "$folder"/checkpoints/*.ckpt \
                --predict "${PREDICT}" \
                --output "$folder"/pred_trans_ctrl_clx_nttk_${SEED} \
                --source_sep " " \
                --target_sep " " \
                --accelerator gpu
            ./evaluate.py \
                <(paste "$folder"/pred_trans_ctrl_clx_nttk_${SEED} \
                  <(cut -f2 "${PREDICT}")
                  )
        fi
    done
done
