---
name: machine-learning-ml
description: Build ML systems pragmatically — data prep, train/eval split, overfitting, deployment, drift monitoring, MLOps essentials.
category: Data & AI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Machine Learning (pragmatic)

## Decide ML vs rules
- Start with a heuristic/baseline (threshold, lookup, simple regression) — measure, then add ML only if it beats the baseline meaningfully. 80% of products never need models.

## Data pipeline (the real work)
- Clean + label consistently; **leakage is the #1 silent killer**: temporal split (train on past, test on future) for time-series; dedupe near-duplicates across splits; no features computed from the label (e.g. target-encoded post-split).
- Split: train/val/test (80/10/10 typical; temporal for streaming); stratify for imbalance.
- Feature store only when teams share features — otherwise keep features in the training pipeline (deterministic, versioned).

## Training & eval
- Start simple (linear/tree ensemble), then deepen; use cross-validation for hyperparams (grid small), holdout only for final report.
- Metrics match business: precision vs recall by cost of error types (fraud: recall; recsys: precision@k); ROC is for choosing thresholds, not the report.
- **The test set is sacred**: tune until it looks great on val, report once on test. Tuning on test = lying to yourself.
- Overfitting tell: train ≫ val performance, giant feature counts — prune, regularize, more data.

## Serving & ops
- Deploy as an API with versioned models (registry: mlflow/simple versioned artifacts), precomputed batches when latency is off-critical-path.
- Drift: monitor input distribution (feature stats vs train), prediction distribution, and feedback (labels when available) — alert thresholds tuned, not default.
- Retraining cadence: scheduled (weekly/monthly) with automated eval gate (no auto-deploy if eval fails); champion/challenger rollout.
- Log predictions + features (sampled) for debugging/regression testing (replay old batch through new model).

## Reproducibility
- Seed everything; pin data snapshot + code version + model params — one artifact (hash) per trained model. CI runs smoke eval on train reproducibility.

## Checklist
- [ ] Baseline first; ML justified by gap
- [ ] No leakage; temporal split for time series
- [ ] Metrics map to error cost; test set single-use
- [ ] Model versioned; drift + feedback monitored
- [ ] Retrain gate: eval must pass before deploy