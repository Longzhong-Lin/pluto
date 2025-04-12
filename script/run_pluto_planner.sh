export CUDA_VISIBLE_DEVICES=0
export HYDRA_FULL_ERROR=1
export PYTHONPATH="/home/linlongzhong/Projects/pluto":$PYTHONPATH

cwd=$(pwd)
CKPT_ROOT="$cwd/checkpoints"

export NUPLAN_DATA_ROOT="$cwd/data/nuplan/raw"
export NUPLAN_MAPS_ROOT="$cwd/data/nuplan/raw/maps"
export NUPLAN_EXP_ROOT="$cwd"

PLANNER=pluto_planner
BRANCH=original
BUILDER=nuplan_mini
FILTER=mini14
CKPT=pluto_1M_aux_cil.ckpt
VIDEO_SAVE_DIR=video

# CHALLENGE="closed_loop_nonreactive_agents"
CHALLENGE="closed_loop_reactive_agents"
# CHALLENGE="open_loop_boxes"

python run_simulation.py \
    +simulation=$CHALLENGE \
    planner=$PLANNER \
    scenario_builder=$BUILDER \
    scenario_filter=$FILTER \
    worker=sequential \
    verbose=true \
    experiment_uid="$PLANNER/$BRANCH/$FILTER/$(date "+%Y-%m-%d-%H-%M-%S")" \
    worker=ray_distributed \
    worker.threads_per_node=128 \
    distributed_mode='SCENARIO_BASED' \
    number_of_gpus_allocated_per_simulation=0.02 \
    enable_simulation_progress_bar=true \
    planner.pluto_planner.render=false \
    planner.pluto_planner.planner_ckpt="$CKPT_ROOT/$CKPT" \
    +planner.pluto_planner.save_dir=$VIDEO_SAVE_DIR \

