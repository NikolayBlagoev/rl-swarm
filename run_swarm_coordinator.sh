#!/bin/bash

#General args
ROOT=$PWD

export PUB_MULTI_ADDRS
export PEER_MULTI_ADDRS
export HOST_MULTI_ADDRS
export IDENTITY_PATH

#Check if public multi-address is given else set to default
DEFAULT_PUB_MULTI_ADDRS=""
PUB_MULTI_ADDRS=${PUB_MULTI_ADDRS:-$DEFAULT_PUB_MULTI_ADDRS}

#Check if peer multi-address is given else set to default
DEFAULT_PEER_MULTI_ADDRS="" # gensyn coordinator node
PEER_MULTI_ADDRS=${PEER_MULTI_ADDRS:-$DEFAULT_PEER_MULTI_ADDRS}

#Check if host multi-address is given else set to default
DEFAULT_HOST_MULTI_ADDRS="/ip4/0.0.0.0/tcp/38331"
HOST_MULTI_ADDRS=${HOST_MULTI_ADDRS:-$DEFAULT_HOST_MULTI_ADDRS}

# Path to an RSA private key. No need to specify if you
# just want a random Peer ID for this run.
DEFAULT_IDENTITY_PATH=""
IDENTITY_PATH=${IDENTITY_PATH:-$DEFAULT_IDENTITY_PATH}

#lets go!
echo "Getting requirements..."
pip install -r "$ROOT"/requirements-hivemind.txt
pip install -r "$ROOT"/requirements.txt

if ! which nvidia-smi; then
   #You don't have a NVIDIA GPU
   CONFIG_PATH="$ROOT/hivemind_exp/configs/mac/grpo-qwen-2.5-0.5b-deepseek-r1.yaml"
elif [ -n "$CPU_ONLY" ]; then
   # ... or we don't want to use it
   CONFIG_PATH="$ROOT/hivemind_exp/configs/mac/grpo-qwen-2.5-0.5b-deepseek-r1.yaml"
else
   #NVIDIA GPU found
   pip install -r "$ROOT"/requirements_gpu.txt
   CONFIG_PATH="$ROOT/hivemind_exp/configs/gpu/grpo-qwen-2.5-0.5b-deepseek-r1.yaml"
fi

echo ">> Done!"
echo "Good luck in the swarm!"
python -m hivemind_exp.gsm8k.train_single_gpu --identity_path "$IDENTITY_PATH" --public_maddr "$PUB_MULTI_ADDRS" --initial_peer "$PEER_MULTI_ADDRS" --host_maddr "$HOST_MULTI_ADDRS" --config "$CONFIG_PATH" --device $1
