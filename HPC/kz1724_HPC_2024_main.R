# abc123_HPC_2024_main.R
# CMEE 2024 HPC exercises R code main pro forma

name <- "Kevin Zhao"
preferred_name <- "Kevin"
email <- "zhetao.zhao24@imperial.ac.uk"
username <- "kz1724"

# Please remember *not* to clear the workspace here
# so no rm(list=ls()) or graphics.off() in this file.

#############################################################
# Section One: Stochastic demographic population model
#############################################################

source("Demographic.R")   # Ensure we have deterministic_simulation, stochastic_simulation, etc.

#######################
# Question 0
#######################
state_initialise_adult <- function(num_stages, initial_size){
  # Put all individuals in the last stage (adult)
  state <- rep(0, num_stages)
  state[num_stages] <- initial_size
  return(state)
}

state_initialise_spread <- function(num_stages, initial_size){
  # Evenly distribute individuals across all stages
  base <- floor(initial_size / num_stages)
  remainder <- initial_size %% num_stages
  state <- rep(base, num_stages)
  if (remainder > 0){
    state[1:remainder] <- state[1:remainder] + 1
  }
  return(state)
}

#######################
# Question 1
#######################
question_1 <- function(){
  # Initial states
  initial_state_1 <- state_initialise_adult(4, 100)
  initial_state_2 <- state_initialise_spread(4, 100)

  # Build projection matrix
  growth_matrix <- matrix(c(0.1, 0.0, 0.0, 0.0,
                            0.5, 0.4, 0.0, 0.0,
                            0.0, 0.4, 0.7, 0.0,
                            0.0, 0.0, 0.25,0.4),
                          nrow=4, ncol=4, byrow=TRUE)
  reproduction_matrix <- matrix(c(0.0, 0.0, 0.0, 2.6,
                                  0.0, 0.0, 0.0, 0.0,
                                  0.0, 0.0, 0.0, 0.0,
                                  0.0, 0.0, 0.0, 0.0),
                                nrow=4, ncol=4, byrow=TRUE)
  projection_matrix <- growth_matrix + reproduction_matrix

  # Deterministic simulation
  sim_adult <- deterministic_simulation(initial_state_1, projection_matrix, 24)
  sim_spread <- deterministic_simulation(initial_state_2, projection_matrix, 24)

  # Plot
  png(filename="question_1.png", width=600, height=400)
  plot(sim_adult, type="l", col="red", ylim=c(0,500), xlab="Time step", ylab="Population size",
       main="Deterministic Simulation: adult vs. spread")
  lines(sim_spread, col="blue")
  legend("topright", legend=c("All adult (100)", "Spread (100)"),
         col=c("red","blue"), lty=1, lwd=2)
  Sys.sleep(0.1)
  dev.off()

  return("Pop. with all adults sees immediate growth due to high fecundity, then a dip, then stabilizes. A spread initial age distribution grows more steadily.")
}

#######################
# Question 2
#######################
question_2 <- function(){
  # same initial states
  initial_state_1 <- state_initialise_adult(4, 100)
  initial_state_2 <- state_initialise_spread(4, 100)

  # same matrices
  growth_matrix <- matrix(c(0.1, 0.0, 0.0, 0.0,
                            0.5, 0.4, 0.0, 0.0,
                            0.0, 0.4, 0.7, 0.0,
                            0.0, 0.0, 0.25, 0.4),
                          nrow=4, ncol=4, byrow=TRUE)
  reproduction_matrix <- matrix(c(0.0, 0.0, 0.0, 2.6,
                                  0.0, 0.0, 0.0, 0.0,
                                  0.0, 0.0, 0.0, 0.0,
                                  0.0, 0.0, 0.0, 0.0),
                                nrow=4, ncol=4, byrow=TRUE)
  clutch_distribution <- c(0.06,0.08,0.13,0.15,0.16,0.18,0.15,0.06,0.03)

  # Stochastic simulation
  sim_adult <- stochastic_simulation(initial_state_1, growth_matrix, reproduction_matrix, clutch_distribution, 24)
  sim_spread <- stochastic_simulation(initial_state_2, growth_matrix, reproduction_matrix, clutch_distribution, 24)

  png(filename="question_2.png", width=600, height=400)
  plot(sim_adult, type="l", col="red", ylim=c(0,500), xlab="Time step", ylab="Population size",
       main="Stochastic Simulation: adult vs. spread")
  lines(sim_spread, col="blue")
  legend("topright", legend=c("All adult (100)", "Spread (100)"),
         col=c("red","blue"), lty=1, lwd=2)
  Sys.sleep(0.1)
  dev.off()

  return("Stochastic model shows greater fluctuations due to random survival and reproduction events, but overall patterns still reflect initial conditions.")
}

#######################
# Questions 3 & 4
#######################
# HPC code -> see separate .R script: "kz1724_HPC_2024_demographic_cluster.R"
# question_3() / question_4() are explained in HPC scripts

#######################
# Question 5
#######################
question_5 <- function(){
  # We'll define a helper function
  is_extinct <- function(x) { x[121] == 0 } # If at final time step, pop size == 0

  # a function to count extinctions from HPC files
  count_extinctions <- function(file_indices){
    ext_count <- 0
    for(i in file_indices){
      load(paste0("demographic_cluster_output_", i, ".rda"))# suppose HPC outputs "output_1.rda" etc.
      # 'results' is a list of 150 sims
      ext_count <- ext_count + sum(sapply(results, is_extinct))
    }
    return(ext_count)
  }

  # We'll assume 1:25 => large_adult, 26:50 => small_adult, 51:75 => large_spread, 76:100 => small_spread
  la_ext <- count_extinctions(1:25)
  sa_ext <- count_extinctions(26:50)
  ls_ext <- count_extinctions(51:75)
  ss_ext <- count_extinctions(76:100)

  # convert to proportions (25 files * 150 sims each = 3750 sims per group)
  la_prop <- la_ext / 3750
  sa_prop <- sa_ext / 3750
  ls_prop <- ls_ext / 3750
  ss_prop <- ss_ext / 3750

  data_vec <- c(la_prop, sa_prop, ls_prop, ss_prop)

  png("question_5.png", 600, 400)
  barplot(data_vec, names.arg=c("Large Adult","Small Adult","Large Spread","Small Spread"),
          main="Extinction probability by initial condition", col="blue",
          ylab="Proportion extinct", ylim=c(0,0.2))
  Sys.sleep(0.1)
  dev.off()

  return("Small, spread population is at highest risk of extinction due to having fewer reproducing adults initially + greater variance impact on small population.")
}

#######################
# Question 6
#######################
question_6 <- function(){
  # read HPC results and compute mean population trajectory => compare deterministic
  pop_trend_from_files <- function(file_indices){
    total_sum <- numeric(121)
    total_count <- 0
    for(i in file_indices){
      load(paste0("demographic_cluster_output_", i, ".rda")) # each load => 'results' a list of length 150
      # combine
      mat <- do.call(rbind, results) # 150 x 121
      total_sum <- total_sum + colSums(mat)
      total_count <- total_count + nrow(mat)
    }
    return(total_sum / total_count)
  }

  # let's define small_spread 76:100, large_spread 51:75
  stoc_large <- pop_trend_from_files(51:75)
  stoc_small <- pop_trend_from_files(76:100)

  # do a deterministic run for large_spread(100) and small_spread(10)
  growth_matrix <- matrix(c(0.1,0,0,0,
                            0.5,0.4,0,0,
                            0,0.4,0.7,0,
                            0,0,0.25,0.4),
                          nrow=4, byrow=TRUE)
  reproduction_matrix <- matrix(c(0,0,0,2.6,
                                  0,0,0,0,
                                  0,0,0,0,
                                  0,0,0,0),
                                nrow=4, byrow=TRUE)
  proj_matrix <- growth_matrix + reproduction_matrix
  det_large <- deterministic_simulation(state_initialise_spread(4,100), proj_matrix, 120)
  det_small <- deterministic_simulation(state_initialise_spread(4,10), proj_matrix, 120)

  # ratio
  dev_large <- stoc_large / det_large
  dev_small <- stoc_small / det_small

  png("question_6.png", 600, 400)
  plot(dev_large, type="l", col="red", ylim=c(0.995,1.03), xlab="Time", ylab="Stoch/Det ratio",
       main="Deviation of Stochastic from Deterministic (spread)")
  lines(dev_small, col="blue")
  legend("bottomright", legend=c("Large Spread", "Small Spread"),
         col=c("red","blue"), lty=1, lwd=2)
  Sys.sleep(0.1)
  dev.off()

  return("Large population's stochastic mean is closer to deterministic predictions. Small population shows bigger deviations, because random variation is proportionally larger at low N.")
}

#############################
# Section Two: Individual-based ecological neutral theory
#############################

#######################
# Question 7
#######################
species_richness <- function(community){
  # Returns the number of distinct species in the community
  return(length(unique(community)))
}

#######################
# Question 8
#######################
init_community_max <- function(size){
  # Assign each individual a unique species ID (1..size),
  # so the community has maximum possible initial richness.
  return(seq(1, size))
}

#######################
# Question 9
#######################
init_community_min <- function(size){
  # All individuals belong to species "1"
  # so the community has minimum possible initial richness (monodominance).
  return(rep(1, size))
}

#######################
# Question 10
#######################
choose_two <- function(max_value){
  # Randomly pick 2 distinct indices from 1..max_value
  # Using sample.int() is a small optimization over sample(1:max_value, ...).
  return(sample.int(max_value, 2, replace = FALSE))
}

#######################
# Question 11
#######################
neutral_step <- function(community){
  # 1. Pick two random individuals
  indices <- choose_two(length(community))
  # 2. One is replaced by the species of the other
  community[indices[1]] <- community[indices[2]]
  return(community)
}

#######################
# Question 12
#######################
neutral_generation <- function(community){
  # According to the course notes:
  #   A 'generation' = (community_size / 2) neutral steps.
  # If the size is odd, we randomly adjust by ±1
  # so we can do an integer number of steps.

  size <- length(community)
  if(size %% 2 == 1){
    # randomly add or subtract 1
    # so we do an exact half
    size <- size + sample(c(-1, 1), 1)
  }
  generation_length <- size / 2

  # Perform that many neutral steps
  for(i in seq_len(generation_length)){
    community <- neutral_step(community)
  }
  return(community)
}

#######################
# Question 13
#######################
neutral_time_series <- function(community, duration){
  # We'll track species richness at each time point
  richness_values <- numeric(duration + 1)
  richness_values[1] <- species_richness(community)

  for(t in seq_len(duration)){
    community <- neutral_generation(community)
    richness_values[t + 1] <- species_richness(community)
  }

  return(richness_values)
}

#######################
# Question 14
#######################
question_14 <- function(){
  # We'll run a neutral model WITHOUT speciation (just Q12/13 logic)
  # to see how species richness evolves in time.

  # 1. Initialize a community with MAX diversity (i.e. each individual a unique species)
  community <- init_community_max(100)

  # 2. Simulate e.g. 200 generations
  duration <- 200
  richness_ts <- neutral_time_series(community, duration)
  
  # 3. Plot the species richness over time
  png("question_14.png", width=600, height=400)
  plot(richness_ts, type="l", col="blue", lwd=2,
       xlab="Generation", ylab="Species Richness",
       main="Neutral Model (no speciation): Richness vs. Time")
  Sys.sleep(0.1)
  dev.off()
  
  return("In a neutral model without speciation, random drift eventually leads to a single surviving species (richness=1) as other species go extinct stochastically.")
}

#######################
# Question 15
#######################
neutral_step_speciation <- function(community, speciation_rate){
  # Similar to neutral_step, except with probability speciation_rate
  # we introduce a new species instead of copying.
  
  # 1. Pick 2 distinct individuals
  indices <- choose_two(length(community))
  
  # 2. With probability speciation_rate, the "offspring" is a brand new species
  if(runif(1) < speciation_rate){
    community[indices[2]] <- max(community) + 1
  } else {
    # Otherwise, just copy species from indices[1] to indices[2]
    community[indices[2]] <- community[indices[1]]
  }
  return(community)
}

#######################
# Question 16
#######################
neutral_generation_speciation <- function(community, speciation_rate){
  # One "generation" = (community_size / 2) steps,
  # adjusting if size is odd (like in Q12).
  
  size <- length(community)
  if(size %% 2 == 1){
    size <- size + sample(c(-1,1), 1)
  }
  gen_length <- size / 2
  
  for(i in seq_len(gen_length)){
    community <- neutral_step_speciation(community, speciation_rate)
  }
  return(community)
}

#######################
# Question 17
#######################
neutral_time_series_speciation <- function(community, speciation_rate, duration){
  # Track species richness over given number of generations,
  # but using the "speciation" version of neutral model.
  
  richness_vec <- numeric(duration+1)
  richness_vec[1] <- species_richness(community)
  
  for(t in seq_len(duration)){
    community <- neutral_generation_speciation(community, speciation_rate)
    richness_vec[t+1] <- species_richness(community)
  }
  return(richness_vec)
}

#######################
# Question 18
#######################
question_18 <- function(){
  # Compare time-series of species richness with speciation
  # under two different initial conditions (max vs min).
  
  # 1. Setup
  duration <- 200
  spec_rate <- 0.1
  
  # 2. Run two simulations
  ts_max <- neutral_time_series_speciation(init_community_max(100), spec_rate, duration)
  ts_min <- neutral_time_series_speciation(init_community_min(100), spec_rate, duration)
  
  # 3. Plot
  png("question_18.png", width=600, height=400)
  plot(ts_max, type="l", col="red", ylim=c(0,100),
       xlab="Generation", ylab="Species Richness",
       main="Neutral Model with Speciation")
  lines(ts_min, col="blue")
  legend("topright", legend=c("Initial max diversity","Initial min diversity"),
         col=c("red","blue"), lty=1, lwd=2)
  Sys.sleep(0.1)
  dev.off()
  
  return("Despite different initial richness, both eventually reach a similar equilibrium determined by the balance of speciation and extinction.")
}

#######################
# Question 19
#######################
species_abundance <- function(community){
  # Count how many individuals belong to each species,
  # then return a sorted vector of abundances in descending order.
  
  abundance_table <- table(community)   # species -> counts
  return(as.vector(sort(abundance_table, decreasing=TRUE)))
}

#######################
# Question 20
#######################
octaves <- function(abundance_vector){
  # We group species abundances into log2 "octave" bins,
  # e.g. abundance 1 => bin 1, abundance [2..3] => bin2, [4..7] => bin3, etc.
  
  if(length(abundance_vector)==0){
    return(numeric(0))  # if no species exist, return empty
  }
  
  # For each abundance n, octave index = floor(log2(n)) + 1
  octave_indices <- floor(log2(abundance_vector)) + 1
  # Tabulate how many species are in each octave
  octave_counts <- tabulate(octave_indices)
  
  return(octave_counts)
}

#######################
# Question 21
#######################
sum_vect <- function(x, y){
  # Sums two vectors of possibly different lengths,
  # by padding the shorter one with zeros.
  
  if(length(x) > length(y)){
    tmp <- x
    x <- y
    y <- tmp
  }
  difference <- length(y) - length(x)
  if(difference > 0){
    x <- c(x, rep(0, difference))
  }
  return(x + y)
}

#######################
# Question 22
#######################
question_22 <- function(){
  # 1) "Burn in" both a high-initial-richness community
  #    and a low-initial-richness community for 200 generations.
  # 2) Then run additional 2000 steps, recording
  #    the species abundance distribution (octaves) every 20 steps.
  # 3) Average those octaves and create barplots.

  spec_rate <- 0.1
  size <- 100
  
  # (a) burn-in:
  generations_burn <- 200
  community_max <- init_community_max(size)
  community_min <- init_community_min(size)
  
  # Run 200 generations using e.g. 'Reduce' or a loop:
  for(i in 1:generations_burn){
    community_max <- neutral_generation_speciation(community_max, spec_rate)
    community_min <- neutral_generation_speciation(community_min, spec_rate)
  }

  # (b) after burn-in, record octaves every 20 steps
  # run 2000 steps, i.e. 100 records if every 20 steps
  max_octaves_sum <- octaves(species_abundance(community_max))
  min_octaves_sum <- octaves(species_abundance(community_min))
  steps_record <- 2000
  record_interval <- 20
  
  for(i in 1:steps_record){
    community_max <- neutral_generation_speciation(community_max, spec_rate)
    community_min <- neutral_generation_speciation(community_min, spec_rate)
    
    if(i %% record_interval == 0){
      max_octaves_sum <- sum_vect(max_octaves_sum, octaves(species_abundance(community_max)))
      min_octaves_sum <- sum_vect(min_octaves_sum, octaves(species_abundance(community_min)))
    }
  }
  
  # We recorded every 20 steps, so total recordings = steps_record / record_interval = 2000/20=100
  max_octaves_mean <- max_octaves_sum / (steps_record/record_interval)
  min_octaves_mean <- min_octaves_sum / (steps_record/record_interval)
  
  # (c) Plot side by side
  png("question_22.png", width=600, height=400)
  par(mfrow=c(1,2), oma=c(0,0,3,0)) 
  barplot(max_octaves_mean, col="blue",
          main="High Initial Richness",
          xlab="Octave Class", ylab="Mean # of species")
  barplot(min_octaves_mean, col="red",
          main="Low Initial Richness",
          xlab="Octave Class", ylab="Mean # of species")
  mtext("Mean Species Abundance Distribution", outer=TRUE)
  Sys.sleep(0.1)
  dev.off()
  
  return("After sufficient burn-in, both high and low initial richness converge to similar abundance distributions, implying initial conditions have limited long-term effect.")
}

#######################
# Question 23
#######################
neutral_cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct,
                                burn_in_generations, output_file_name){
  # HPC function to run a neutral model with speciation under time constraints.
  # We record:
  #   1) time_series of species richness during burn_in
  #   2) abundance_list (octaves) after burn_in, every interval_oct steps
  
  # 1) Start timer
  start_time <- proc.time()[3]
  
  # 2) Initialize community with minimal diversity
  community <- init_community_min(size)
  
  # 3) Prepare data storage
  time_series <- numeric(burn_in_generations / interval_rich) # store richness each interval_rich
  abundance_list <- list()
  
  i <- 1 # burn-in generation index
  j <- 1 # post-burn generation index
  
  # 4) Main loop: keep simming until out of time
  while((proc.time()[3] - start_time) < wall_time * 60){
    
    # (a) If still in burn_in
    if(i <= burn_in_generations){
      # record richness if i is multiple of interval_rich
      if(i %% interval_rich == 0){
        time_series[i / interval_rich] <- species_richness(community)
      }
      # do 1 generation
      community <- neutral_generation_speciation(community, speciation_rate)
      i <- i + 1
      
    } else {
      # (b) after burn_in
      # record octaves every interval_oct
      if(j %% interval_oct == 0){
        abundance_list[[ j / interval_oct ]] <- octaves(species_abundance(community))
      }
      community <- neutral_generation_speciation(community, speciation_rate)
      j <- j + 1
    }
    
    # check time
    if((proc.time()[3] - start_time) >= wall_time * 60){
      break
    }
  }
  
  total_time <- proc.time()[3] - start_time
  
  # 5) Save results
  save(time_series, abundance_list, community, total_time,
       speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations,
       file=output_file_name)
  
  return("Simulation Complete")
}

#######################
# Questions 24 & 25
#######################
# HPC code -> see separate .R script: "kz1724_HPC_2024_neutral_cluster.R"
# question_24() / question_25() are explained in HPC scripts

#######################
# Question 26
#######################
process_neutral_cluster_results <- function(){
  # Function to read HPC outputs, average octaves for each community size, etc.
  
  # We'll assume we have 4 community sizes => 500,1000,2500,5000
  # and that HPC outputs are "neutral_cluster_output_1.rda" ... etc.
  # We parse iter=1:25 => size 500, 26:50 => size 1000, etc.
  
  # Initialize store
  rep500 <- 0
  rep1000 <- 0
  rep2500 <- 0
  rep5000 <- 0
  
  # track how many snapshots in each group
  count500 <- 0
  count1000 <- 0
  count2500 <- 0
  count5000 <- 0
  
  # We assume we have 100 HPC files => array job 1..100
  for(iter in 1:100){
    fname <- paste0("neutral_cluster_output_", iter, ".rda")
    if(!file.exists(fname)) next
    
    load(fname)  # loads: time_series, abundance_list, speciation_rate, etc.
    # Decide which size group this file belongs to
    # (like how we do in HPC script => 1..25 => size=500, 26..50 =>1000, etc.)
    
    if(iter <= 25){
      # 500 group
      for(abvec in abundance_list){
        rep500 <- sum_vect(rep500, abvec)
      }
      count500 <- count500 + length(abundance_list)
      
    } else if(iter <= 50){
      # 1000
      for(abvec in abundance_list){
        rep1000 <- sum_vect(rep1000, abvec)
      }
      count1000 <- count1000 + length(abundance_list)
      
    } else if(iter <= 75){
      # 2500
      for(abvec in abundance_list){
        rep2500 <- sum_vect(rep2500, abvec)
      }
      count2500 <- count2500 + length(abundance_list)
      
    } else {
      # 5000
      for(abvec in abundance_list){
        rep5000 <- sum_vect(rep5000, abvec)
      }
      count5000 <- count5000 + length(abundance_list)
    }
    
  }
  
  # compute means
  if(count500>0)  rep500 <- rep500 / count500
  if(count1000>0) rep1000 <- rep1000 / count1000
  if(count2500>0) rep2500 <- rep2500 / count2500
  if(count5000>0) rep5000 <- rep5000 / count5000
  
  combined_results <- list(
    size_500   = rep500,
    size_1000  = rep1000,
    size_2500  = rep2500,
    size_5000  = rep5000
  )
  
  # Save final results
  save(combined_results, file="processed_neutral_results.rda")
  cat("processed_neutral_results.rda created!\n")
}


plot_neutral_cluster_results <- function(){
  # load the combined_results
  if(!file.exists("processed_neutral_results.rda")){
    stop("No processed_neutral_results.rda found! Run process_neutral_cluster_results() first.")
  }
  load("processed_neutral_results.rda")  # loads "combined_results"

  # We can do a simple multi-plot in base R
  sizes <- c("size_500","size_1000","size_2500","size_5000")
  # or do a single multi-panel layout
  png("plot_neutral_cluster_results.png", width=800, height=600)
  par(mfrow=c(2,2), oma=c(0,0,2,0))
  
  for(i in seq_along(sizes)){
    # barplot
    oct_vec <- combined_results[[ sizes[i] ]]
    if(is.null(oct_vec) || length(oct_vec)==1 && oct_vec==0) {
      barplot(0, main=paste(sizes[i],"No data"), ylab="Mean # species", xlab="Octave Bin")
    } else {
      barplot(oct_vec, 
              main=paste("Mean abundance for", sizes[i]),
              xlab="Octave Bin", ylab="Mean # species")
    }
  }

  mtext("Neutral cluster results", outer=TRUE, cex=1.2)
  Sys.sleep(0.1)
  dev.off()
  
  return(combined_results)
}

#############################
# Challenge questions
#############################

#######################
# Challenge A
#######################
# 思路：读入 HPC 生成的 'demographic_cluster_output_X.rda' (X=1..100)
#       将每个文件中 150 次模拟的时间序列合并成一大 dataframe
#       并画出随时间的人口规模走势, 按初始条件分颜色

# (1) 先做一个函数 create_challengeA_data() 来收集并合并数据
create_challengeA_data <- function(){
  # 1) 预定义一个空列表来存储合并结果
  all_dfs <- list()
  sim_id <- 1
  
  # 2) 遍历 HPC 输出文件 (如 "demographic_cluster_output_1.rda"到_100.rda)
  for(i in 1:100){
    fname <- paste0("demographic_cluster_output_", i, ".rda")
    if(!file.exists(fname)) next
    
    load(fname)  # loads "results" (list of 150 numeric vectors)
    
    # 决定初始条件标签
    # 例如 1..25 => "Large Adult", 26..50 => "Small Adult", etc.
    cond <- ""
    if(i <= 25){
      cond <- "Large Adult"
    } else if(i <= 50){
      cond <- "Small Adult"
    } else if(i <= 75){
      cond <- "Large Mixed"
    } else {
      cond <- "Small Mixed"
    }
    
    # 3) 每个 rda 包含 150 个模拟, 每个是长度=121(0..120) 的population vector
    for(j in seq_along(results)){
      pop_vec <- results[[j]]
      # 形成一个 dataframe
      df <- data.frame(
        simulation_number = sim_id,
        initial_condition = cond,
        time_step = seq_along(pop_vec) - 1,  # 0-based
        population_size = pop_vec
      )
      all_dfs[[length(all_dfs)+1]] <- df
      sim_id <- sim_id + 1
    }
  }
  
  # 4) 合并所有 df
  big_df <- do.call(rbind, all_dfs)
  
  # 5) 存到 .rda
  save(big_df, file="challenge_A_data.rda")
  cat("challenge_A_data.rda created, containing all demographic results!\n")
}

# (2) Challenge_A() 函数来画图
Challenge_A <- function(){
  if(!file.exists("challenge_A_data.rda")){
    stop("No challenge_A_data.rda found! Run create_challengeA_data() first.")
  }
  
  load("challenge_A_data.rda")  # loads "big_df"
  # big_df columns: simulation_number, initial_condition, time_step, population_size
  
  if(!requireNamespace("ggplot2", quietly=TRUE)){
    stop("Please install ggplot2 to run Challenge A plot.")
  }
  library(ggplot2)
  
  png("Challenge_A.png", width=600, height=400)
  
  p <- ggplot(big_df, aes(x=time_step, y=population_size,
                          group=simulation_number,
                          color=initial_condition)) +
    geom_line(alpha=0.05) +  # alpha=0.05 使线条更淡,多重叠时看趋势
    labs(title="Challenge A: Demographic population trends",
         x="Time Step", y="Population Size") +
    theme_minimal() +
    theme(legend.position="right",
          plot.title=element_text(hjust=0.5, face="bold"))
  
  print(p)
  Sys.sleep(0.1)
  dev.off()
  
  return("Challenge A plot saved in Challenge_A.png")
}


#######################
# Challenge B
#######################
# 思路：大量重复模拟中性模型(有 speciation)，比较 init_community_max vs init_community_min，
#       并画出平均物种数+置信区间随时间变化

Challenge_B <- function(){
  # 1) 并行参数
  if(!requireNamespace("parallel", quietly=TRUE)){
    stop("Please install 'parallel' package for Challenge B or rewrite in single-thread.")
  }
  library(parallel)
  
  n_runs <- 200   # 多少次模拟
  n_cores <- detectCores() - 1
  spec_rate <- 0.1
  duration <- 100
  
  # 2) 并行运行 init_community_max
  max_list <- mclapply(1:n_runs, function(x){
    neutral_time_series_speciation(init_community_max(100), spec_rate, duration)
  }, mc.cores=n_cores)
  
  # 并行运行 init_community_min
  min_list <- mclapply(1:n_runs, function(x){
    neutral_time_series_speciation(init_community_min(100), spec_rate, duration)
  }, mc.cores=n_cores)
  
  # 3) 转成矩阵
  max_mat <- do.call(rbind, max_list)  # n_runs x (duration+1)
  min_mat <- do.call(rbind, min_list)
  
  # 4) 算均值+std
  mean_max <- colMeans(max_mat, na.rm=TRUE)
  mean_min <- colMeans(min_mat, na.rm=TRUE)
  
  # 标准差 / sqrt(n)
  sd_max <- apply(max_mat, 2, sd, na.rm=TRUE)
  sd_min <- apply(min_mat, 2, sd, na.rm=TRUE)
  se_max <- sd_max / sqrt(n_runs)
  se_min <- sd_min / sqrt(n_runs)
  
  # 置信区间 97.2% => z ~ 2.26 (或 t 分布, big n)
  # Harry 用 qt(1-(1-0.972)/2, df=n_runs-1)
  t_critical <- qt(1 - (1-0.972)/2, df=n_runs-1)
  ci_max <- t_critical * se_max
  ci_min <- t_critical * se_min
  
  # 5) 构建 long-format df
  gen_vec <- 0:duration
  df <- data.frame(
    Generation = rep(gen_vec, 2),
    Mean_Richness = c(mean_max, mean_min),
    CI_Lower = c(mean_max - ci_max, mean_min - ci_min),
    CI_Upper = c(mean_max + ci_max, mean_min + ci_min),
    Condition = rep(c("MaxInit","MinInit"), each=length(gen_vec))
  )
  
  # 6) 画图
  if(!requireNamespace("ggplot2", quietly=TRUE)){
    stop("Please install ggplot2 for Challenge B plotting.")
  }
  library(ggplot2)
  
  png("Challenge_B.png", width=600, height=400)
  
  p <- ggplot(df, aes(x=Generation, y=Mean_Richness, color=Condition, fill=Condition)) +
    geom_ribbon(aes(ymin=CI_Lower, ymax=CI_Upper), alpha=0.2, color=NA) +
    geom_line(size=0.8) +
    labs(title="Challenge B: Mean Richness with 97.2% CI",
         x="Generation", y="Mean Species Richness") +
    theme_bw() +
    scale_color_manual(values=c("MaxInit"="red", "MinInit"="blue")) +
    scale_fill_manual(values=c("MaxInit"="red", "MinInit"="blue")) +
    theme(plot.title=element_text(hjust=0.5, face="bold"))
  
  print(p)
  
  Sys.sleep(0.1)
  dev.off()
  
  return("Challenge B done! See Challenge_B.png for the time-series with confidence intervals.")
}


#######################
# Challenge C
#######################
# 思路：给出不同的“初始物种丰富度”(1, 10, 20..），
#       在固定 community size=100，speciation_rate=0.1 下跑 repeated simulation，
#       画出每种初始丰富度下随时间的平均物种数曲线

Challenge_C <- function(){
  if(!requireNamespace("ggplot2", quietly=TRUE)){
    stop("Please install ggplot2 for Challenge C.")
  }
  library(ggplot2)
  
  # 1) 定义不同初始丰富度
  richness_levels <- c(10,20,40,80,160,320)
  n_reps <- 50
  spec_rate <- 0.1
  duration <- 100
  size <- 100
  
  # 辅助函数：根据给定 richness 随机初始化
  init_community_custom <- function(size, richness){
    sample.int(richness, size, replace=TRUE)  # random species ID from 1..richness
  }
  
  # 2) 存放结果
  #   all_df: long format => Generation, MeanRichness, Condition
  all_df <- data.frame()
  
  # 3) 对每个 richness_level 做 n_reps 次
  for(r in richness_levels){
    # 记录多个 time_series
    time_series_mat <- matrix(0, nrow=n_reps, ncol=duration+1)
    
    for(i in 1:n_reps){
      comm <- init_community_custom(size, r)
      ts <- neutral_time_series_speciation(comm, spec_rate, duration)
      time_series_mat[i, ] <- ts
    }
    
    # 取平均
    avg_richness <- colMeans(time_series_mat)
    
    # 拼成长格式
    df_part <- data.frame(
      Generation=0:duration,
      Mean_Richness=avg_richness,
      Initial_Richness=factor(r)
    )
    all_df <- rbind(all_df, df_part)
  }
  
  # 4) 画图
  png("Challenge_C.png", width=600, height=400)
  
  p <- ggplot(all_df, aes(x=Generation, y=Mean_Richness,
                          color=Initial_Richness, group=Initial_Richness)) +
    geom_line(size=1) +
    labs(title="Challenge C: Different initial richness vs time",
         x="Generation", y="Mean Species Richness") +
    theme_bw() +
    theme(legend.position="right",
          plot.title=element_text(hjust=0.5, face="bold"))
  
  print(p)
  Sys.sleep(0.1)
  dev.off()
  
  return("Challenge C done! See Challenge_C.png.")
}

#######################
# Challenge D
#######################
# Idea: read HPC outputs from e.g. neutral_cluster_output_{1..100}.rda.
# Group them by community size: 1..25 => size=500, 26..50 => size=1000, 51..75 => 2500, 76..100 => 5000.
# Each .rda presumably has a "time_series" or "results" variable that records species richness over time.
# We then compute the mean time series for each size and plot them together.

Challenge_D <- function() {
  
  # Helper function: read HPC results (time_series) and sum up
  mean_time_series_from_filelist <- function(file_indices){
    # We assume each HPC .rda file has a variable named 'time_series' (a numeric vector).
    total_sum <- 0
    file_count <- 0
    
    for(i in file_indices){
      fname <- paste0("neutral_cluster_output_", i, ".rda")
      if(!file.exists(fname)) next
      
      load(fname)  # loads 'time_series' (or your HPC might store 'results'? adapt accordingly)
      
      # Check if time_series exists
      if(!exists("time_series")) {
        cat("Warning: no time_series in file", fname, "\n")
        next
      }
      
      # sum the vector
      # if it's the first file, define total_sum as numeric vector
      if(length(total_sum) == 1 && total_sum==0){
        total_sum <- time_series
      } else {
        # we need to align lengths if they differ
        len_diff <- length(time_series) - length(total_sum)
        if(len_diff > 0){
          total_sum <- c(total_sum, rep(0, len_diff))
        } else if(len_diff < 0){
          time_series <- c(time_series, rep(0, -len_diff))
        }
        total_sum <- total_sum + time_series
      }
      file_count <- file_count + 1
    }
    if(file_count==0){
      cat("No valid HPC files in that list.\n")
      return(NULL)
    }
    # compute mean vector
    mean_ts <- total_sum / file_count
    return(mean_ts)
  }

  # 1..25 => size=500, 26..50 => size=1000, 51..75 => size=2500, 76..100 => size=5000
  mts_500  <- mean_time_series_from_filelist(1:25)
  mts_1000 <- mean_time_series_from_filelist(26:50)
  mts_2500 <- mean_time_series_from_filelist(51:75)
  mts_5000 <- mean_time_series_from_filelist(76:100)

  # We need to align their lengths to do a combined plot
  # Find the max length among them
  max_len <- max(length(mts_500), length(mts_1000), length(mts_2500), length(mts_5000), na.rm=TRUE)
  if(!is.null(mts_500) && length(mts_500)<max_len)   mts_500   <- c(mts_500,   rep(NA, max_len-length(mts_500)))
  if(!is.null(mts_1000) && length(mts_1000)<max_len) mts_1000  <- c(mts_1000,  rep(NA, max_len-length(mts_1000)))
  if(!is.null(mts_2500) && length(mts_2500)<max_len) mts_2500  <- c(mts_2500,  rep(NA, max_len-length(mts_2500)))
  if(!is.null(mts_5000) && length(mts_5000)<max_len) mts_5000  <- c(mts_5000,  rep(NA, max_len-length(mts_5000)))

  gen_axis <- seq_len(max_len)

  png("Challenge_D.png", width=800, height=600)
  
  # We take the maximum among the non-NA values to define y-limit
  overall_max <- max(mts_500, mts_1000, mts_2500, mts_5000, na.rm=TRUE)
  plot(gen_axis, mts_500, type="l", col="blue", lwd=2,
       ylim=c(0, overall_max), xlab="Generation", ylab="Mean Species Richness",
       main="Challenge D: Richness Over Time by Community Size")
  if(!is.null(mts_1000)) lines(gen_axis, mts_1000, col="red", lwd=2)
  if(!is.null(mts_2500)) lines(gen_axis, mts_2500, col="green", lwd=2)
  if(!is.null(mts_5000)) lines(gen_axis, mts_5000, col="purple", lwd=2)

  legend("topright", legend=c("500","1000","2500","5000"),
         col=c("blue","red","green","purple"), lwd=2)
  
  Sys.sleep(0.1)
  dev.off()

  return("Challenge D: Compare mean richness time series for 4 population sizes. See Challenge_D.png.")
}

#######################
# Challenge E
#######################

# (A) HPC vs. Coalescence data aggregator
create_challengeE_data <- function(speciation_rate = 0.004247) {
  # This function loads HPC .rda files (neutral_cluster_output_*) 
  # that presumably have "abundance_list" snapshots.
  # We average those octaves for each J if the file belongs to e.g. 1..25 => J=500, etc.

  # We assume 1..25 => 500, 26..50 =>1000, 51..75=>2500, 76..100 =>5000
  # Also we assume HPC used the same speciation_rate. If HPC used a different rate, adapt.

  sum_vect <- function(x, y){
    len_diff <- length(x) - length(y)
    if(len_diff>0){
      y <- c(y, rep(0, len_diff))
    } else if(len_diff<0){
      x <- c(x, rep(0, -len_diff))
    }
    return(x+y)
  }

  HPC_out <- list(
    "J_500"  = c(0),
    "J_1000" = c(0),
    "J_2500" = c(0),
    "J_5000" = c(0)
  )
  HPC_counts <- list(
    "J_500"  = 0,
    "J_1000" = 0,
    "J_2500" = 0,
    "J_5000" = 0
  )
  
  for(i in 1:100){
    fname <- paste0("neutral_cluster_output_", i, ".rda")
    if(!file.exists(fname)) next
    
    load(fname)  # loads abundance_list, speciation_rate, size, ...
    
    # If HPC stored a 'size' variable or deduce from i range
    if(!exists("size")) {
      # deduce from i
      if(i <= 25)      size <- 500
      else if(i<=50)  size <- 1000
      else if(i<=75)  size <- 2500
      else            size <- 5000
    }
    # If HPC stored a 'speciation_rate' variable, check it:
    # if(speciation_rate != 0.004247) next  # or adapt

    key <- paste0("J_", size)
    if(!is.null(HPC_out[[key]])){
      # sum up all octaves in abundance_list
      for(oct in abundance_list){
        HPC_out[[key]] <- sum_vect(HPC_out[[key]], oct)
      }
      HPC_counts[[key]] <- HPC_counts[[key]] + length(abundance_list)
    }
  }
  
  # compute average
  for(k in names(HPC_out)){
    if(HPC_counts[[k]] > 0){
      HPC_out[[k]] <- HPC_out[[k]] / HPC_counts[[k]]
      # trim trailing zeros
      while(length(HPC_out[[k]])>0 && tail(HPC_out[[k]],1)==0){
        HPC_out[[k]] <- HPC_out[[k]][-length(HPC_out[[k]])]
      }
    }
  }
  
  # Save HPC_out
  save(HPC_out, file="Challenge_E_HPC.rda")
  cat("Saved HPC data in Challenge_E_HPC.rda\n")
}

# (B) Coalescence approach
Challenge_E_coalescence <- function(J, v){
  # This function simulates coalescence for population size J, spec rate v
  # returning a final abundance distribution.

  # theta = v*(J-1)/(1-v)
  lineages <- rep(1, J)
  abund <- c()
  N <- J
  theta <- v*(J-1)/(1-v)

  while(N>1){
    j <- sample.int(N, 1)
    # probability of speciation event in coalescence sense:
    p_spec <- theta/(theta+N-1)
    if(runif(1) < p_spec){
      # we record this lineage in 'abund'
      abund <- c(abund, lineages[j])
    } else {
      i <- j
      while(i==j){
        i <- sample.int(N,1)
      }
      lineages[i] <- lineages[i] + lineages[j]
    }
    lineages <- lineages[-j]
    N <- N-1
  }
  # final leftover
  abund <- c(abund, lineages)
  return(abund)
}

# (C) Compare HPC vs. Coalescence
Challenge_E <- function(){
  # 1) Load HPC_out from "Challenge_E_HPC.rda"
  if(!file.exists("Challenge_E_HPC.rda")){
    stop("Please run create_challengeE_data() first to generate HPC data.")
  }
  load("Challenge_E_HPC.rda")  # loads HPC_out
  
  # HPC_out is e.g. $J_500 = numeric vector of average octaves
  # We'll run coalescence for same J, maybe 50 repeats, average the octaves

  sum_vect <- function(x, y){
    len_diff <- length(x) - length(y)
    if(len_diff>0){
      y <- c(y, rep(0, len_diff))
    } else if(len_diff<0){
      x <- c(x, rep(0, -len_diff))
    }
    return(x+y)
  }
  octaves <- function(ab){
    idx <- floor(log2(ab)) + 1
    return(tabulate(idx))
  }
  
  # Suppose we use speciation_rate=0.004247
  v <- 0.004247
  
  # We do 4 sizes: 500,1000,2500,5000
  coalescence_mean <- list()

  for(j in c(500,1000,2500,5000)){
    key <- paste0("J_", j)
    if(is.null(HPC_out[[key]])){
      cat("No HPC data for J=", j, "\n")
      next
    }
    
    # how many coalescence replicates do we want?
    n_rep <- 50
    oct_sum <- rep(0,50)
    cat("Running coalescence for J=", j, " with v=", v, ", replicates=", n_rep, "\n")
    t0 <- proc.time()[3]
    for(r in 1:n_rep){
      ab <- Challenge_E_coalescence(j, v)
      oc <- octaves(ab)
      oct_sum <- sum_vect(oct_sum, oc)
    }
    coalescence_time <- proc.time()[3] - t0
    cat("Coalescence total time (sec) =", coalescence_time, "\n")
    
    mean_oct <- oct_sum / n_rep
    # trim trailing zeros
    while(length(mean_oct)>0 && tail(mean_oct,1)==0){
      mean_oct <- mean_oct[-length(mean_oct)]
    }
    coalescence_mean[[key]] <- mean_oct
  }
  
  # 2) Construct a data frame for HPC vs coalescence
  plot_data <- data.frame()
  for(k in names(HPC_out)){
    HPC_vec <- HPC_out[[k]]
    Coal_vec <- coalescence_mean[[k]]
    if(is.null(Coal_vec)) next  # no coalescence data for that J
    
    max_len <- max(length(HPC_vec), length(Coal_vec))
    HPC_pad  <- c(HPC_vec, rep(0, max_len-length(HPC_vec)))
    Coal_pad <- c(Coal_vec, rep(0, max_len-length(Coal_vec)))
    
    df_k <- rbind(
      data.frame(Octave=seq_len(max_len), Count=HPC_pad, Approach="HPC",  J=k),
      data.frame(Octave=seq_len(max_len), Count=Coal_pad,Approach="Coalescence", J=k)
    )
    plot_data <- rbind(plot_data, df_k)
  }

  # We can do a barplot in ggplot2
  if(!requireNamespace("ggplot2", quietly=TRUE)){
    stop("Please install ggplot2 to plot Challenge E results.")
  }
  library(ggplot2)
  # We'll transform 'J=k' into something nicer, e.g. "J=500"
  plot_data$Jlabel <- sapply(plot_data$J, function(x) gsub("J_","J=", x))

  png("Challenge_E.png", width=600, height=400)
  g <- ggplot(plot_data, aes(x=factor(Octave), y=Count, fill=Approach)) +
    geom_bar(stat="identity", position="dodge") +
    facet_wrap(~Jlabel, scales="free_y") +
    labs(x="Octave bin", y="Mean # of species", title="Challenge E: HPC vs. Coalescence") +
    theme_minimal(base_size=14)
  print(g)
  Sys.sleep(0.1)
  dev.off()
  
  return("Challenge E: HPC vs. coalescence comparison. See Challenge_E.png.")
}
