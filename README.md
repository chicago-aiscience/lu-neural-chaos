[![Lint](https://github.com/chicago-aiscience/lu-neural-chaos/actions/workflows/lint.yml/badge.svg)](https://github.com/chicago-aiscience/lu-neural-chaos/actions/workflows/lint.yml)
[![Test](https://github.com/chicago-aiscience/lu-neural-chaos/actions/workflows/test.yml/badge.svg)](https://github.com/chicago-aiscience/lu-neural-chaos/actions/workflows/test.yml)
[![Benchmark](https://github.com/chicago-aiscience/lu-neural-chaos/actions/workflows/bench.yml/badge.svg)](https://github.com/chicago-aiscience/lu-neural-chaos/actions/workflows/bench.yml)
[![Coverage](https://codecov.io/gh/chicago-aiscience/lu-neural-chaos/branch/main/graph/badge.svg)](https://codecov.io/gh/chicago-aiscience/lu-neural-chaos)
[![CodSpeed](https://img.shields.io/endpoint?url=https://codspeed.io/badge.json)](https://codspeed.io/chicago-aiscience/lu-neural-chaos)

<p align="center">
  <img src="https://github.com/roxie62/neural_operators_for_chaos/blob/main/presentations/diagram_emulator.png" width="700">
</p>

This is the implementation for the NeurIPS 2023 paper "[Training neural operators to preserve invariant measures of chaotic attractors](https://openreview.net/pdf?id=8xx0pyMOW1)".

```
@article{jiang2023training,
  title={Training neural operators to preserve invariant measures of chaotic attractors},
  author={Jiang, Ruoxi and Lu, Peter Y and Orlova, Elena and Willett, Rebecca},
  journal={Advances in Neural Information Processing Systems},
  year={2023}
}
```

### Prepare the training data
To generate the Lorenz 96 data in the `l96_data` folder, run:
```
python generate_data.py
```
Then to create noisy observations and speed up the loading process during the training, in the parent folder, run:
```
python dataloader/dataloader_l96.py
```


### Optimal transport method
This implementation supports DistributedDataParallel training: The default configuration uses 4 GPUs.
The default algorithm used to solve the optimal transport problem is [Sinkhorn divergence](https://www.kernel-operations.io/geomloss/).

To train the neural operator with the optimal transport (OT) method for Lorenz 96 data, run:
```
bash experiments/OT_l96/srun.sh
```
The hyperparameters of the OT method are:
- Weights of the OT loss: `--lambda_geomloss 3`.
- Regularization value in the Sinkhorn algorithm, where smaller regularization usually leads to high accuracy while slowing the training: `--blur 0.02`.
- Controlling the physical knowledge you want to use during the training, set this to be larger than 0 if you only have partial knowledge of the system, `--with_geomloss_kd 0`.


### Contrastive feature learning method
This implementation supports DistributedDataParallel training: The default configuration uses 4 GPUs.

To train the neural operator with the contrastive learning (CL) method for Lorenz 96 data, run:
```
bash experiments/CL_l96/srun.sh
```
The hyperparameters of the OT method are:
- Memory bank size, which should be divisible by the current GPU_number times `batch_size_metricL`: `--bank_size 1000`.
- Temperature value for controlling the radius of the hypersphere feature space: `--T_metricL_traj_alone 0.3`.


### Evaluation
We only require 1 GPU for the evaluation. To run the evaluation for each method, run:
```
bash experiments/OT_l96/eval.sh
bash experiments/OT_l96/eval_partial.sh
bash experiments/CL_l96/eval.sh
```
Turning on the `--eval_LE` command means we are calculating the leading Lyapunov exponent (LLE) for the trained neural operator, which takes ~2 hours for 200 test instances.
If you want to calculate the ground truth LLE values for the data, run:
```
python eval_scripts/LE_l96.py
```
After all the LLEs are calculated, we could compare them by running:
```
python eval_scripts/read_LE.py
```

## Reference
- https://pre-commit.com/
- https://docs.astral.sh/uv/
- https://docs.astral.sh/ruff/
- https://microsoft.github.io/pyright/#/
