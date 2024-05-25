#!/usr/bin/env bash

python -m venv myenv
source myenv/bin/activate
#pip install -r requirements.txt
#pip install .

#pip install wandb --upgrade

for SEED in 144 233 377 610 987; do
    yoyodyne-train \
        --model_dir results \
        --arch attentive_lstm \
        --experiment "eng_attentive_lstm_ctrl_pronLex_${SEED}" \
        --train tsv/eng/gp2p-CELEX-PronLex-control-train.tsv \
        --val tsv/eng/gp2p-CELEX-PronLex-control-dev.tsv \
        --source_sep " " \
        --target_sep " " \
        --seed "${SEED}" \
        --arch attentive_lstm \
        --batch_size 80 \
        --beta1 0.9 \
        --beta2 0.999 \
        --decoder_layers 1 \
        --dropout 0.3386954003167651 \
        --embedding_size 256 \
        --encoder_layers 1 \
        --features_attention_heads 1 \
        --hidden_size 224 \
        --label_smoothing 0.1282339116652795 \
        --learning_rate 0.00016633669547278266 \
        --max_source_length 128 \
        --max_target_length 128 \
        --optimizer adam \
        --check_val_every_n_epoch 1 \
        --end_factor 1 \
        --min_learning_rate 0 \
        --reduceonplateau_factor 0.1 \
        --reduceonplateau_mode loss \
        --reduceonplateau_patience 10 \
        --start_factor 0.3333333333333333 \
        --total_decay_steps 5 \
        --warmup_steps 0 \
        --source_attention_heads 4 \
        --max_epochs 50 \
        --accelerator gpu
    for folder in results/"eng_attentive_lstm_ctrl_pronLex_${SEED}"/version_*; do
        if [ -d "$folder" ]; then
            yoyodyne-predict \
                --model_dir results \
                --experiment "eng_attentive_lstm_ctrl_pronLex_${SEED}" \
                --checkpoint "$folder"/checkpoints/*.ckpt \
                --arch attentive_lstm \
                --predict tsv/eng/gp2p-CELEX-PronLex-control-test.tsv \
                --output "$folder"/pred_attentive_lstm_ctrl_${SEED} \
                --source_sep " " \
                --target_sep " " \
                #--accelerator gpu
            ./evaluate.py \
                <(paste "$folder"/pred_attentive_lstm_ctrl_${SEED} \
                <(cut -f2 tsv/eng/gp2p-CELEX-PronLex-control-test.tsv)
                )
        fi
    done
done