#!/bin/bash

source myenv/bin/activate
pip install .

#yoyodyne-train \
#  --model_dir results \
#  --experiment ady_att_144 \
#  --train ady/ady_train.tsv \
#  --val ady/ady_dev.tsv \
#  --arch attentive_lstm \
#  --seed 144

yoyodyne-train \
  --model_dir results \
  --experiment ady_att_233 \
  --train ady/ady_train.tsv \
  --val ady/ady_dev.tsv \
  --arch attentive_lstm \
  --seed 233

yoyodyne-train \
  --model_dir results \
  --experiment ady_att_377 \
  --train ady/ady_train.tsv \
  --val ady/ady_dev.tsv \
  --arch attentive_lstm \
  --seed 377

yoyodyne-train \
  --model_dir results \
  --experiment ady_poi_144 \
  --train ady/ady_train.tsv \
  --val ady/ady_dev.tsv \
  --arch pointer_generator_lstm \
  --seed 144

yoyodyne-train \
  --model_dir results \
  --experiment ady_poi_233 \
  --train ady/ady_train.tsv \
  --val ady/ady_dev.tsv \
  --arch pointer_generator_lstm \
  --seed 233

yoyodyne-train \
  --model_dir results \
  --experiment ady_poi_377 \
  --train ady/ady_train.tsv \
  --val ady/ady_dev.tsv \
  --arch pointer_generator_lstm \
  --seed 377

yoyodyne-train \
  --model_dir results \
  --experiment ady_tra_144 \
  --train ady/ady_train.tsv \
  --val ady/ady_dev.tsv \
  --arch transformer \
  --seed 144

yoyodyne-train \
  --model_dir results \
  --experiment ady_tra_233 \
  --train ady/ady_train.tsv \
  --val ady/ady_dev.tsv \
  --arch transformer \
  --seed 233

yoyodyne-train \
  --model_dir results \
  --experiment ady_tra_377 \
  --train ady/ady_train.tsv \
  --val ady/ady_dev.tsv \
  --arch transformer \
  --seed 377

#for i in {144, 233, 377, 610, 987}
#do
#  yoyodyne-train \
#  --model_dir results \
#  --experiment ady_att_144 \
#  --train ady/ady_train.tsv \
#  --val ady/ady_dev.tsv \
#  --arch attentive_lstm \
#  --seed $i
#done

#yoyodyne-train \
#  --lang ady \
#  --output-path results \
#  --experiment-name demo \
#  --train-data-path ady/ady_train.tsv \
#  --dev-data-path ady/ady_dev.tsv \
#  --arch lstm \
#  --attn \
#  --learning-rate 0.9 \
#  --seed 144
