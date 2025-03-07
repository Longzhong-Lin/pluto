cwd=$(pwd)
CKPT_ROOT="$cwd/checkpoints"

export NUPLAN_DATA_ROOT="$cwd/data/nuplan/raw"
export NUPLAN_MAPS_ROOT="$cwd/data/nuplan/raw/maps"
export NUPLAN_EXP_ROOT="$cwd"

PLANNER=$1
BUILDER=$2
FILTER=$3
CKPT=$4
VIDEO_SAVE_DIR=$5

CHALLENGE="closed_loop_nonreactive_agents"
# CHALLENGE="closed_loop_reactive_agents"
# CHALLENGE="open_loop_boxes"

python run_simulation.py \
    +simulation=$CHALLENGE \
    planner=$PLANNER \
    scenario_builder=$BUILDER \
    scenario_filter=$FILTER \
    worker=sequential \
    verbose=true \
    experiment_uid="pluto_planner/$FILTER" \
    planner.pluto_planner.render=true \
    planner.pluto_planner.planner_ckpt="$CKPT_ROOT/$CKPT" \
    +planner.pluto_planner.save_dir=$VIDEO_SAVE_DIR

