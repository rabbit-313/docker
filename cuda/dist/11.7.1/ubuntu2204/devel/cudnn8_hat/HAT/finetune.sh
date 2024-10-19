#! bash
CUDA_VISIBLE_DEVICES=0,1
python hat/train.py -opt options/train/finetune_HAT_SRx4.yml
