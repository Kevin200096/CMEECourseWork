# PACKAGES
library(tidyverse)   # Data collation + ggplot2
library(minpack.lm)  # nlsLM fit
library(patchwork)   # Combine
library(stringr)     # str_wrap

# READ FILES
# 1. Read the cleaned data
data_modified <- read.csv("../data/data_modified.csv", stringsAsFactors = FALSE)

# 2. Read model fitting results, including Best_AICc, Best_BIC and other columns
model_results <- read.csv("../results/model_results.csv", stringsAsFactors = FALSE)

# All ID
unique_IDs <- unique(data_modified$ID)

# PICK 4 IDS
# Find the 4 sample data where Logistic/Gompertz/Quad/Cubic win respectively under Best_AICc
id_logistic <- model_results %>%
  filter(Best_AICc == "Logistic") %>%
  slice_head(n=1) %>%
  pull(ID)

id_gompertz <- model_results %>%
  filter(Best_AICc == "Gompertz") %>%
  slice_head(n=1) %>%
  pull(ID)

id_quad <- model_results %>%
  filter(Best_AICc == "Quad") %>%
  slice_head(n=1) %>%
  pull(ID)

id_cubic <- model_results %>%
  filter(Best_AICc == "Cubic") %>%
  slice_head(n=1) %>%
  pull(ID)

# Combine them into one vector
example_IDs <- c(id_logistic, id_gompertz, id_quad, id_cubic)

# MODELS
logistic_model <- function(t, r_max, K, N_0){
  N_0 * K * exp(r_max * t) / (K + N_0*(exp(r_max * t)-1))
}

gompertz_model <- function(t, r_max, K, N_0, t_lag){
  N_0 + (K - N_0)*exp(
    -exp(r_max*exp(1)*(t_lag - t)/((K - N_0)*log(10)) + 1)
  )
}

# FIT HELPER FUNCTION
# This function fits 4 models at once to a single ID data and returns the predicted values ​​required for plotting.
fit_all_models_for_plot <- function(this_id, data_modified){
  df <- filter(data_modified, ID == this_id)
  x_data <- df$Time
  y_data <- df$log.PopBio
  
  # Logistic Initial Value
  start_list_log <- list(
    r_max = (max(y_data) - min(y_data)) / (max(x_data) - min(x_data)), 
    N_0   = min(y_data),
    K     = max(y_data)
  )

  # 1) Logistic
  fit_log <- tryCatch(
    nlsLM(log.PopBio ~ logistic_model(Time, r_max, K, N_0),
          data = df,
          start = start_list_log,
          control = nls.lm.control(maxiter=1000)),  # Adjustable maxiter
    error = function(e) NULL
  )
  df_log <- NULL
  if(!is.null(fit_log)){
    preds_log <- logistic_model(x_data,
                                coef(fit_log)["r_max"],
                                coef(fit_log)["K"],
                                coef(fit_log)["N_0"])
    df_log <- data.frame(Time=x_data, log.PopBio=preds_log, Model="Logistic model")
  }
  
  # 2) Gompertz
  start_list_gomp <- c(start_list_log, t_lag = mean(x_data))
  fit_gomp <- tryCatch(
    nlsLM(log.PopBio ~ gompertz_model(Time, r_max, K, N_0, t_lag),
          data = df,
          start = start_list_gomp,
          control = nls.lm.control(maxiter=1000)),
    error = function(e) NULL
  )
  df_gomp <- NULL
  if(!is.null(fit_gomp)){
    preds_gomp <- gompertz_model(x_data,
                                 coef(fit_gomp)["r_max"],
                                 coef(fit_gomp)["K"],
                                 coef(fit_gomp)["N_0"],
                                 coef(fit_gomp)["t_lag"])
    df_gomp <- data.frame(Time=x_data, log.PopBio=preds_gomp, Model="Gompertz model")
  }
  
  # 3) Quadratic
  fit_quad <- tryCatch(
    lm(log.PopBio ~ poly(Time,2), data=df),
    error = function(e) NULL
  )
  df_quad <- NULL
  if(!is.null(fit_quad)){
    preds_quad <- predict(fit_quad, newdata=data.frame(Time=x_data))
    df_quad <- data.frame(Time=x_data, log.PopBio=preds_quad, Model="Quadratic model")
  }
  
  # 4) Cubic
  fit_cubic <- tryCatch(
    lm(log.PopBio ~ poly(Time,3), data=df),
    error = function(e) NULL
  )
  df_cubic <- NULL
  if(!is.null(fit_cubic)){
    preds_cubic <- predict(fit_cubic, newdata=data.frame(Time=x_data))
    df_cubic <- data.frame(Time=x_data, log.PopBio=preds_cubic, Model="Cubic model")
  }

  # Combined to get a table of predicted values ​​that can be used for plotting
  plot_df <- bind_rows(df_log, df_gomp, df_quad, df_cubic)
  return(plot_df)
}

# MAKE PLOTS
plots_list <- list()

for(i in seq_along(example_IDs)){
  this_id <- example_IDs[i]
  
  # Take the corresponding data subset + predicted value
  df_sub <- filter(data_modified, ID == this_id)
  pred_df <- fit_all_models_for_plot(this_id, data_modified)
  
  # Find its Best_AICc in model_results and put it in the title
  best_model <- model_results %>%
    filter(ID == this_id) %>%
    pull(Best_AICc)
  
  # If the ID is too long, you can use str_wrap() to wrap it automatically (width can be fine-tuned)
  wrapped_id <- str_wrap(this_id, width=30)
  
  # The title here shows the ID + which model is the best
  p <- ggplot(df_sub, aes(x=Time, y=log.PopBio)) +
    geom_point(size=2, color="black") +
    geom_line(data=pred_df, aes(x=Time, y=log.PopBio, color=Model), linewidth=1) +
    theme_bw(base_size=12) +
    theme(aspect.ratio=1) +
    labs(
      x = "Time",
      y = "Logged Abundance",
      title = paste0("ID: ", wrapped_id, "\n(", best_model, " best)")
    )
  
  plots_list[[i]] <- p
}

# Use patchwork to patch these four sub-images into a 2×2
final_plot <- (plots_list[[1]] + plots_list[[2]]) /
              (plots_list[[3]] + plots_list[[4]])

# Automatically add (A), (B), (C), (D) labels to sub-graphs
final_plot <- final_plot + plot_annotation(tag_levels = 'A', tag_suffix = ')')

# Add a large title to the overall map
final_plot <- final_plot + plot_annotation(
  title = "Representative Growth Curves Illustrating Different Best-Fit Models",
  theme = theme(plot.title = element_text(hjust = 0.5, size=15))
)

# Save to the results directory
ggsave("../results/example_bestfits.png", final_plot, width=10, height=10, dpi=300)
cat("example_bestfits.png saved.\n")
