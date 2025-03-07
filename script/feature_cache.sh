cwd=$(pwd)

export NUPLAN_DATA_ROOT="$cwd/data/nuplan/raw"
export NUPLAN_MAPS_ROOT="$cwd/data/nuplan/raw/maps"
export NUPLAN_EXP_ROOT="$cwd"

BUILDER="nuplan_mini"
FILTER="training_scenarios_tiny"
CACHE_PATH="$cwd/data/nuplan/pluto/sanity_check"

export PYTHONPATH=$PYTHONPATH:$(pwd)

python run_training.py \
    py_func=cache \
    +training=train_pluto \
    scenario_builder=$BUILDER \
    scenario_filter=$FILTER \
    cache.cache_path=$CACHE_PATH \
    cache.cleanup_cache=true \
    worker.threads_per_node=36