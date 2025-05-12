# Miniproject Feedback and Assessment

## Report

**"Guidelines" below refers to the MQB report [MQB Miniproject report guidelines](https://mulquabio.github.io/MQB/notebooks/Appendix-MiniProj.html#the-report) [here](https://mulquabio.github.io/MQB/notebooks/Appendix-MiniProj.html) (which were provided to the students in advance).**

**Title:** “Mechanistic Models Outperform Phenomenological Models in Bacterial Growth Curve Fitting”

- **Introduction (15%)**  
  - **Score:** 12/15  
  - Good overview of logistic vs. Gompertz vs. polynomials. Could expand on the gap or direct aim.

- **Methods (15%)**  
  - **Score:** 11/15  
  - Summarizes data usage but is brief on parameter-fitting or repeated tries. 

- **Results (20%)**  
  - **Score:** 14/20  
  - Mechanistic (logistic, Gompertz) does well, with logistic typically top. More numeric detail or a table summarizing best-fit counts is recommended.

- **Tables/Figures (10%)**  
  - **Score:** 6/10  
  - Possibly references a frequency table but not deeply integrated. The [MQB Miniproject report guidelines](https://mulquabio.github.io/MQB/notebooks/Appendix-MiniProj.html#the-report) suggest explicit referencing and commentary.

- **Discussion (20%)**  
  - **Score:** 15/20  
  - Summarizes logistic's interpretive benefits, polynomials' lower interpretability. Could add future expansions or reflect on data-limitation.

- **Style/Structure (20%)**  
  - **Score:** 14/20  
  - Decent organization, standard structure, references could be more thoroughly linked to the data. The [MQB Miniproject report guidelines](https://mulquabio.github.io/MQB/notebooks/Appendix-MiniProj.html#the-report) recommend explicit cross-referencing.

**Summary:** A coherent analysis emphasizing advantages of mechanistic models.  More thorough numeric results and parameter-fitting details would have strengthened it.

**Report Score:** 68  

---

## Computing

### Project Structure & Workflow

**Strengths**

* `run_MiniProject.sh` clearly sequences data prep, model fitting, plotting, and LaTeX report compilation.
* Three focused R scripts—`Mini_data_prep.R`, `Mini_model_fit.R`, and `Mini_plots.R`—each encapsulate a distinct analysis stage.
* The shell script ensures required R packages are installed before running each script, smoothing setup for new users.

**Suggestions**

1. **Shell Script Robustness:**

   * Use `#!/usr/bin/env bash` and add `set -euo pipefail` to catch errors and undefined variables.
   * At the top, `cd "$(dirname "$0")"` ensures relative paths resolve correctly.
   * Pipe all output (`2>&1`) into a logfile (`results/pipeline.log`) so you can audit runs and debug failures.
2. **Reproducible Environments:**

   * Replace ad-hoc `install.packages()` with **renv** snapshots. In `Mini_data_prep.R`, include `renv::restore()` or instruct users in README to call `renv::restore()` prior to execution.
   * Commit `renv.lock` so everyone uses the same package versions.

---

### README File

**Strengths**

* Describes project purpose, author, contact info, and scripts.
* Documents how to run the pipeline and what outputs to expect.

**Suggestions**

1. **Reproducible Setup:** Promote `renv` usage in README:

   ```bash
   Rscript -e "renv::restore()"
   ```
2. Rather than listing package names, show full commands or refer to `renv.lock`.
3. Add a tree diagram showing where to place raw data (`data/LogisticGrowthData.csv`) and where outputs appear (`results/`).
4. Include a LICENSE file, and cite the data source (`LogisticGrowthData.csv`).
5. Briefly mention the primary functions of each R script under “Code.”

---

### Scripts

####  `Mini_data_prep.R`

* Use `here::here("data", "LogisticGrowthData.csv")` and `here::here("data", "data_modified.csv")` for robust portable paths.
* Remove `rm(list = ls())` if present; rely on fresh R sessions launched by the shell script.
* Wrap the sequence—reading, filtering, transforming, writing—in a function (e.g. `prepare_data()`) and a main guard:

  ```r
  if (interactive()) prepare_data()
  ```
* After filtering `PopBio > 0`, check and report how many rows/IDs were dropped.

####  `Mini_model_fit.R`

* Extract each model fit (logistic, Gompertz, quadratic, cubic) into named functions (`fit_logistic()`, `fit_gompertz()`, etc.) that return a list with model object and metric vector.
* Instead of a `for`-loop with `rbind`, use `purrr::map_df(unique_IDs, ~ process_id(.x, data_modified))` to build `model_results` in a tidy workflow.
* Constrain parameters with `lower`/`upper` in `nlsLM()` and leverage **nls.multstart** to simplify multi-start sampling and parallelize fits:

  ```r
  nls_multstart(
    log.PopBio ~ gompertz_model(...),
    data = df, iter = 50,
    start_lower = lower_bounds,
    start_upper = upper_bounds,
    supp_errors = "Y"
  )
  ```
* In each `tryCatch`, funnel error messages to a structured list or a CSV (e.g. `errors.csv`) for post-run diagnostics.

####  `Mini_plots.R`

* Write a helper `plot_examples(example_IDs)` that handles subsetting, model-fitting for plot, and returns a ggplot object.
* *Don’t Repeat Yourself (DRY) Code:* The repetitive initial-value code for logistic and Gompertz can be abstracted into `get_initials(df)` to reduce duplication.
* Instead of building `plots_list` in a loop, use:

  ```r
  example_plots <- map(example_IDs, ~ make_example_plot(.x, data_modified, model_results))
  final_plot <- wrap_plots(example_plots, ncol=2)
  ```
* Leverage `patchwork::plot_annotation()` only once after plot assembly, as you already do, but ensure consistent theme settings across panels.

---

### NLLS Fitting Approach

**Strengths**

* Comparing logistic, Gompertz, and polynomial addressed both mechanistic and phenomenological models.
* Reporting R², AICc, BIC, and AIC gives a multifaceted evaluation of fit quality.

**Suggestions**

1. Adopt **nls.multstart** with Latin hypercube or uniform sampling to explore starting values more efficiently and reproducibly.
2. Explicitly bound biologically implausible values (e.g. `r_max ≥ 0`, `K ≥ N0`), flagging fits that hit these boundaries.
3. Collect convergence codes and warnings (e.g. from `model$convInfo`) to identify patterns in fit failures.
4. Compute Akaike weights for each ID and visualize their distribution (boxplot or density), not just counts of winning models.
5. Implement time-point leave-one-out Cross-Validation to test predictive accuracy beyond in-sample criteria.

---

### Summary

Your pipeline is well-structured and achieves its goals. By adopting R’s ecosystem tools for environment management (`renv`), functional programming (`purrr`), and advanced NLLS multi-start (`nls.multstart`), along with a more robust shell driver, you can improve reproducibility, maintainability, and scalability for future projects.

### **Score: 68**

---

## Overall Score: (68 + 68)/2 = 68