# %%
import os
from pathlib import Path
import pandas as pd
import pprint

env_variables = {
    "NUPLAN_DEVKIT_ROOT": "/home/linlongzhong/Projects/nuplan-devkit",  # nuplan-devkit absolute path (e.g., "/home/user/nuplan-devkit")
    "NUPLAN_DATA_ROOT": "/home/linlongzhong/Data/Datasets/nuplan/raw", # nuplan dataset absolute path (e.g. "/data")
    "NUPLAN_MAPS_ROOT": "/home/linlongzhong/Data/Datasets/nuplan/raw/maps", # nuplan maps absolute path (e.g. "/data/nuplan-v1.1/maps")
    "NUPLAN_EXP_ROOT": "/home/linlongzhong/Projects/UniMM_Planning", # nuplan experiment absolute path (e.g. "/data/nuplan-v1.1/exp")
    "NUPLAN_SIMULATION_ALLOW_ANY_BUILDER":"1"
}

for k, v in env_variables.items():
    os.environ[k] = v


RESULT_FOLDER = "exp/simulation/closed_loop_reactive_agents/pluto_planner/original/mini14/2025-04-12-16-20-43"

root = Path(RESULT_FOLDER) / "aggregator_metric"
result = list(root.glob("*.parquet"))
result = max(result, key=lambda item: item.stat().st_ctime)
print(f"Latest result file: {result}")

df = pd.read_parquet(result)
final_score = df[df["scenario"] == "final_score"]
final_score = final_score.to_dict(orient="records")[0]
final_score_copy = final_score.copy()
for k, v in final_score_copy.items():
    if v is None:
        final_score.pop(k)
    elif type(v) == float:
        final_score[k] = round(v, 4)
pprint.PrettyPrinter().pprint(final_score)


#%%
import socket
import hydra
from nuplan.planning.script.run_nuboard import main as main_nuboard

def get_free_port():
    s = socket.socket()
    s.bind(('', 0))  # 绑定到一个可用端口，0表示让系统自动分配
    port = s.getsockname()[1]
    s.close()
    return port

# Location of path with all nuBoard configs
CONFIG_PATH = '../nuplan-devkit/nuplan/planning/script/config/nuboard' # relative path to nuplan-devkit
CONFIG_NAME = 'default_nuboard'

# Initialize configuration management system
hydra.core.global_hydra.GlobalHydra.instance().clear()  # reinitialize hydra if already initialized
hydra.initialize(config_path=CONFIG_PATH)

ml_planner_simulation_folder = RESULT_FOLDER
ml_planner_simulation_folder = [dp for dp, _, fn in os.walk(ml_planner_simulation_folder) if True in ['.nuboard' in x for x in fn]]

# Compose the configuration
cfg = hydra.compose(config_name=CONFIG_NAME, overrides=[
    'scenario_builder=nuplan_mini',  # set the database (same as simulation) used to fetch data for visualization
    f'simulation_path={ml_planner_simulation_folder}',  # nuboard file path(s), if left empty the user can open the file inside nuBoard
    'hydra.searchpath=[file://./config, pkg://nuplan.planning.script.config.common, pkg://nuplan.planning.script.experiments]',
    f'port_number={get_free_port()}',  # port number for nuBoard
])

# Run nuBoard
main_nuboard(cfg)
