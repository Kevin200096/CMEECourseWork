# PACKAGES
library(tidyverse)
library(minpack.lm)  # for nlsLM()
library(xtable)      # optional, for generating LaTeX table
library(patchwork)   # optional, if we want to do combined plots in here

# READ DATA 
data_modified <- read.csv("../data/data_modified.csv", stringsAsFactors = FALSE)

# Get all unique IDs
unique_IDs <- unique(data_modified$ID)

# UTILITY FUNCTIONS

# Calculate R^2, AICc, BIC based on log residuals (if fitted with log.PopBio) or raw residuals (if fitted with PopBio)
# In this case: RSS = sum(residuals^2)
# n = number of data points, p = number of parameters
# AIC = n*ln(RSS/n) + 2(p+1)
# AICc = AIC + [2p(p+1)/(n-p-1)]
# BIC = n*ln(RSS/n) + (p+1)*ln(n)
Calc_Values <- function(model, dataset) {
  if (is.null(model) || inherits(model, "try-error")) {
    return(c(NA, NA, NA, NA))
  }
  RSS <- sum(residuals(model)^2)
  n <- nrow(dataset)
  p <- length(coef(model))
  
  # R^2
  TSS <- sum((dataset$log.PopBio - mean(dataset$log.PopBio))^2)  # under log
  Rsq <- 1 - RSS / TSS
  
  # AIC
  AIC_ <- n * log(RSS / n) + 2 * (p + 1)
  # AICc
  AICc_ <- AIC_ + (2 * p * (p + 1)) / (n - p - 1)
  # BIC
  BIC_ <- n * log(RSS / n) + (p + 1) * log(n)
  
  return(c(Rsq, AICc_, BIC_, AIC_))  # Return one more original AIC
}

# MODEL DEFINITIONS
# Logistic / Gompertz Function (Linear Scale)：
# logistic_model(t, r_max, K, N_0)
# gompertz_model(t, r_max, K, N_0, t_lag)
# Here we fit: log.PopBio ~ model( ... ), which means that we assume that log is taken on the left side and need to return log(N(t)) on the right side.

logistic_model <- function(t, r_max, K, N_0){
  # Linear output N(t)
  return(N_0 * K * exp(r_max * t) / (K + N_0 * (exp(r_max * t) - 1)))
}

gompertz_model <- function(t, r_max, K, N_0, t_lag){
  return( N_0 + (K - N_0) *
            exp( -exp( r_max * exp(1) * (t_lag - t) / ((K - N_0)*log(10)) + 1 ) )
  )
}

# Polynomial: lm(log.PopBio ~ poly(Time, 2)) / lm(log.PopBio ~ poly(Time, 3)) You can use the built-in function directly.

# OUTPUT DATAFRAME
model_results <- data.frame(
  ID = unique_IDs,
  ID_num = seq_along(unique_IDs),
  
  # R^2
  Logistic_Rsq = NA_real_,
  Gompertz_Rsq = NA_real_,
  Quad_Rsq = NA_real_,
  Cubic_Rsq = NA_real_,
  
  # AICc
  Logistic_AICc = NA_real_,
  Gompertz_AICc = NA_real_,
  Quad_AICc = NA_real_,
  Cubic_AICc = NA_real_,
  
  # BIC
  Logistic_BIC = NA_real_,
  Gompertz_BIC = NA_real_,
  Quad_BIC = NA_real_,
  Cubic_BIC = NA_real_,
  
  # AIC
  Logistic_AIC = NA_real_,
  Gompertz_AIC = NA_real_,
  Quad_AIC = NA_real_,
  Cubic_AIC = NA_real_,
  
  stringsAsFactors = FALSE
)

# Output visualization of all curves to the same PDF (one page per ID)
pdf("../results/fitted_models.pdf", width=7, height=6)

run_num <- 0

# MAIN LOOP OVER ALL IDs
for(id in unique_IDs) {
  run_num <- run_num + 1
  cat("Fitting curve", run_num, "of", length(unique_IDs), "=> ID:", id, "\n")
  
  # Subset
  data_subset <- filter(data_modified, ID == id)
  if(nrow(data_subset) < 4) {
    cat("Not enough points to fit properly: ", id, "\n")
    next
  }
  
  # x, y
  x_data <- data_subset$Time
  y_data <- data_subset$log.PopBio
  
  # 1) Logistic
  # Use diff(range(y_data))/diff(range(x_data)) as initial value of r_max
  start_rmax <- (max(y_data) - min(y_data)) / (max(x_data) - min(x_data))
  # Consider logistic_model back to N(t):
  start_N0 <- min(y_data) #(in the log)
  start_K  <- max(y_data)
  
  # Fitting: log.PopBio ~ logistic_model( ... )
  fit_logistic <- tryCatch({
    nlsLM(log.PopBio ~ logistic_model(t=Time, r_max, K, N_0),
          data = data_subset,
          start = list(r_max=start_rmax, N_0=start_N0, K=start_K),
          control = nls.lm.control(maxiter=1000))
  }, error = function(e) {
    cat("Logistic Fit Error for ID:", id, "->", e$message, "\n")
    return(NULL)
  })
  
  # Predicted value
  logistic_points <- NULL
  if(!is.null(fit_logistic)) {
    logistic_points <- logistic_model(
      t=x_data,
      r_max = coef(fit_logistic)["r_max"],
      K     = coef(fit_logistic)["K"],
      N_0   = coef(fit_logistic)["N_0"]
    )
  }
  
  # 2) Gompertz
  start_rmax_g <- (max(y_data) - min(y_data)) / (max(x_data) - min(x_data))
  start_N0_g   <- min(y_data)
  start_K_g    <- max(y_data)
  # t_lag gives an initial value (second-order difference to find the maximum acceleration point)
  d2 <- diff(diff(y_data))
  idx <- which.max(d2)
  start_t_lag <- if(length(idx)>0) x_data[idx+1] else mean(x_data)
  
  fit_gompertz <- tryCatch({
    nlsLM(log.PopBio ~ gompertz_model(t=Time, r_max, K, N_0, t_lag),
          data = data_subset,
          start = list(r_max=start_rmax_g, K=start_K_g, N_0=start_N0_g, t_lag=start_t_lag),
          control = nls.lm.control(maxiter=1000))
  }, error = function(e) {
    cat("Gompertz Fit Error for ID:", id, "->", e$message, "\n")
    return(NULL)
  })
  
  gompertz_points <- NULL
  if(!is.null(fit_gompertz)) {
    gompertz_points <- gompertz_model(
      t=x_data,
      r_max = coef(fit_gompertz)["r_max"],
      K     = coef(fit_gompertz)["K"],
      N_0   = coef(fit_gompertz)["N_0"],
      t_lag = coef(fit_gompertz)["t_lag"]
    )
  }
  
  # 3) Quadratic
  # log.PopBio ~ poly(Time, 2)
  QuaFit <- tryCatch({
    lm(log.PopBio ~ poly(Time, 2), data=data_subset)
  }, error = function(e) {
    cat("Quadratic Fit Error for ID:", id, "->", e$message, "\n")
    return(NULL)
  })
  
  quad_points <- NULL
  if(!is.null(QuaFit) && !inherits(QuaFit, "try-error")) {
    quad_points <- predict(QuaFit, newdata=data.frame(Time=x_data))
  }
  
  # 4) Cubic
  CubicFit <- tryCatch({
    lm(log.PopBio ~ poly(Time, 3), data=data_subset)
  }, error = function(e) {
    cat("Cubic Fit Error for ID:", id, "->", e$message, "\n")
    return(NULL)
  })
  
  cubic_points <- NULL
  if(!is.null(CubicFit) && !inherits(CubicFit, "try-error")) {
    cubic_points <- predict(CubicFit, newdata=data.frame(Time=x_data))
  }
  
  # Combine the predicted values ​​of all models and prepare to draw the graph
  df1 <- if(!is.null(logistic_points)) data.frame(Time=x_data, log.PopBio=logistic_points, Model="Logistic") else NULL
  df2 <- if(!is.null(gompertz_points)) data.frame(Time=x_data, log.PopBio=gompertz_points, Model="Gompertz") else NULL
  df3 <- if(!is.null(quad_points)) data.frame(Time=x_data, log.PopBio=quad_points,  Model="Quadratic") else NULL
  df4 <- if(!is.null(cubic_points)) data.frame(Time=x_data, log.PopBio=cubic_points, Model="Cubic") else NULL
  
  model_frame <- bind_rows(df1, df2, df3, df4)
  
  # Export drawings to PDF
  p <- ggplot(data_subset, aes(x=Time, y=log.PopBio)) +
    geom_point(size=2) +
    labs(title=paste0("ID: ", id),
         x="Time", y="Logged Abundance") +
    theme_bw(base_size=12) +
    theme(aspect.ratio=1)
  
  if(nrow(model_frame) > 0) {
    p <- p + geom_line(data=model_frame, aes(x=Time, y=log.PopBio, color=Model), size=1)
  }
  print(p)
  
  # Calculate and store R², AICc, BIC, etc.
  # logistic
  val_log <- Calc_Values(fit_logistic, data_subset)
  # gompertz
  val_gomp <- Calc_Values(fit_gompertz, data_subset)
  # quad
  val_quad <- Calc_Values(QuaFit, data_subset)
  # cubic
  val_cubic <- Calc_Values(CubicFit, data_subset)
  
  # Write values ​​to model_results
  idx_row <- which(model_results$ID == id)
  model_results$Logistic_Rsq[idx_row]   <- val_log[1]
  model_results$Logistic_AICc[idx_row]  <- val_log[2]
  model_results$Logistic_BIC[idx_row]   <- val_log[3]
  model_results$Logistic_AIC[idx_row]   <- val_log[4]
  
  model_results$Gompertz_Rsq[idx_row]   <- val_gomp[1]
  model_results$Gompertz_AICc[idx_row]  <- val_gomp[2]
  model_results$Gompertz_BIC[idx_row]   <- val_gomp[3]
  model_results$Gompertz_AIC[idx_row]   <- val_gomp[4]
  
  model_results$Quad_Rsq[idx_row]       <- val_quad[1]
  model_results$Quad_AICc[idx_row]      <- val_quad[2]
  model_results$Quad_BIC[idx_row]       <- val_quad[3]
  model_results$Quad_AIC[idx_row]       <- val_quad[4]
  
  model_results$Cubic_Rsq[idx_row]      <- val_cubic[1]
  model_results$Cubic_AICc[idx_row]     <- val_cubic[2]
  model_results$Cubic_BIC[idx_row]      <- val_cubic[3]
  model_results$Cubic_AIC[idx_row]      <- val_cubic[4]
  
  # clean
  fit_logistic <- fit_gompertz <- QuaFit <- CubicFit <- NULL
}

dev.off()
cat("All fits done. PDF saved to ../results/fitted_models.pdf\n")

# Select Best model

find_best_model <- function(aicc_vec){
  # aicc_vec = c(Logistic_AICc, Gompertz_AICc, Quad_AICc, Cubic_AICc)
  # If all are NA, an error will be reported. Check here
  if(all(is.na(aicc_vec))) return(NA)
  idx <- which.min(aicc_vec)  # Minimum position
  model_names <- c("Logistic", "Gompertz", "Quad", "Cubic")
  return(model_names[idx])
}

model_results <- model_results %>%
  rowwise() %>%
  mutate(
    Best_AICc = find_best_model(c(Logistic_AICc, Gompertz_AICc, Quad_AICc, Cubic_AICc)),
    Best_BIC  = find_best_model(c(Logistic_BIC,  Gompertz_BIC,  Quad_BIC,  Cubic_BIC ))
  ) %>%
  ungroup()

# Print statistical results (number of times each model wins)
cat("\n========= Best model by AICc =========\n")
print(model_results %>% count(Best_AICc))

cat("\n========= Best model by BIC =========\n")
print(model_results %>% count(Best_BIC))

# Write final statistics to CSV
write.csv(model_results, "../results/model_results.csv", row.names = FALSE)
cat("Model comparison saved to ../results/model_results.csv\n")

# Generating LaTeX tables
latex_table <- xtable(model_results, caption="Model Fitting Results", label="tab:results")
print(latex_table, file="../results/model_results.tex", include.rownames=FALSE)

cat("LaTeX table saved to ../results/model_results.tex\n")
