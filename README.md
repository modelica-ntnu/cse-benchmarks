# MARCO dialects paper's benchmarks
## Model source code
The source code of the benchmarked Modelica model can be found in `data/src/CityLight.mo`.

## Run
It is possible to run the benchmarks using both Docker and Apptainer.
According to the desired container system, execute either the `docker_run.sh` or `apptainer_run.sh` scripts.
The `docker.slurm` and `apptainer.slurm` are also provided to run the configurations on a computing cluster managed by SLURM.

## Results
At the end of the benchmarks execution, an archive containing the logs and results is produced under the `output` folder. A `.csv` file is also generated, and its content can be inserted into the first page (named `Data`) of the `measurements.ods` spreadsheet template for rapid visualization. The remaining pages are views on the first one, each of which focusing on a specific benchmark dimension.
