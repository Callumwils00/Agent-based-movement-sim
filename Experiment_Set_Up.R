# Install and load packages 
if(!require("plotly")){install.packages("plotly")}
if(!require("crqa")){install.packages("crqa")}
if(!require("tidyverse")){install.packages("tidyverse")}
if(!require("reshape2")){install.packages("reshape2")}

library(plotly)
library(crqa)
library(tidyverse)
library(reshape2)
#library(forcast)


## Build file structure if it does not exist
plot_dir <- paste0(getwd(), "\\movement_plots")
dir.create(path = plot_dir)

results_dir <- paste0(getwd(), "\\results")
dir.create(path = results_dir)

## Generate pink noise sequences

pink_noise_func <- function(N, alpha = 1){ 
  f <- seq(from=0, to=pi, length.out=(N/2+1))[-c(1,(N/2+1))] # Fourier frequencies
  f_ <- 1 / f^alpha # Power law
  RW <- sqrt(0.5*f_) * rnorm(N/2-1) # for the real part
  IW <- sqrt(0.5*f_) * rnorm(N/2-1) # for the imaginary part
  fR <- complex(real = c(rnorm(1), RW, rnorm(1), RW[(N/2-1):1]), 
                imaginary = c(0, IW, 0, -IW[(N/2-1):1]), length.out=N)
  # Those complex numbers that are to be back transformed for Fourier Frequencies 0, 2pi/N, 2*2pi/N, ..., pi, ..., 2pi-1/N 
  # Choose in a way that frequencies are complex-conjugated and symmetric around pi 
  # 0 and pi do not need an imaginary part
  reihe <- fft(fR, inverse=TRUE) # go back into time domain
  return(Re(reihe)) # imaginary part is 0
}


pink_noises <- list("list", trial_num)
pink_noise <- list("list", iter_num)


for(i in 1:trial_num){
  for(j in 1:2){
    pink_noise[[j]] <- pink_noise_func(iter_num,1)/25
  }
  pink_noises[[i]] <- pink_noise
}

## Create some Agents

Agent_1 <- function(x = NULL, y = NULL, type, pair_Agent = NULL, distance = NULL, is_first = FALSE, follow_rule = TRUE, df = NULL,
                    model_type_ = model_type, noise_type = "white_", noise_value = NA_integer_){
  
  if(!type %in% c("divergent", "convergent")){
    stop('type parameter must be in c("divergent","convergent"')
  }
  if(!follow_rule %in% c(TRUE, FALSE)){
    stop('follow rule parameter must be in TRUE FALSE')
  }
  if(!noise_type %in% c("white_", "pink_", "")){
    stop('noise_type parameter must be in white_ pink_')
  }
  
  if(model_type_ == "you"){
    formula_x <- as.formula(move_x_A2 ~ iter + move_x_A2)
    formula_y <- as.formula(move_y_A2 ~ iter + move_y_A2)
  } else if(model_type_ == "us both"){
    formula_x <- as.formula(move_x_A2 ~ iter + move_x_A2 + move_x_A1)
    formula_y <- as.formula(move_y_A2 ~ iter + move_y_A2 + move_y_A1)
  } else{
    invisible()
  }
  
  
  if(is_first == TRUE){
    x <- 102#runif(1,-500,500)
    y <- 102#runif(1,-500,500)
    x_2 <- x
    y_2 <- y
    move_x <- 0
    move_y <- 0
  } 
  
  Slope <- y - pair_Agent$y/x- pair_Agent$x
  n <- if_else(type == "convergent", 1, -1)
  y_diff <- y - pair_Agent$y
  x_diff <- x - pair_Agent$x
  
  rand_x <-runif(1,-1,1)
  rand_y <- runif(1,-1,1)
  
  if(follow_rule == TRUE){
    if(is_first == TRUE){
      invisible()
    }else if(is.na(x)){
      x_2 <- NA
      y_2 <- NA
      move_x <- NA
      move_y <- NA
    } else if(abs(distance) < difference & x_diff < 0 & y_diff < 0){
      x_2 <- x + 1*n*fac + if_else(noise_type == "white_", rand_x , noise_value)#sample(c(5:30)*n*fac,1)
      y_2 <- y + 1*n*fac + if_else(noise_type == "white_", rand_y, noise_value)#sample(c(5:30)*n*fac, 1)
      move_x <- x_2 - x
      move_y <- y_2 - x
    } else if(abs(distance) < difference & x_diff < 0 & y_diff >= 0){
      x_2 <- x - 1*n*fac + if_else(noise_type == "white_", rand_x, noise_value)#sample(c(5:30)*n*fac,1)
      y_2 <- y + 1*n*fac + if_else(noise_type == "white_", rand_y, noise_value)# sample(c(5:30)*n*fac, 1)
      move_x <- x_2 - x
      move_y <- y_2 - y
    } else if(abs(distance) < difference & x_diff >= 0 & y_diff >=0){
      x_2 <- x - 1*n*fac + if_else(noise_type == "white_", rand_x, noise_value)#sample(c(5:30)*n*fac,1)
      y_2 <- y - 1*n*fac + if_else(noise_type == "white_", rand_y, noise_value)#sample(c(5:30)*n*fac, 1)
      move_x <- x_2 - x
      move_y <- y_2 - y
    } else if(abs(distance) < difference & x_diff >= 0 & y_diff < 0){
      x_2 <- x - 1*n*fac + if_else(noise_type == "white_", rand_x, noise_value)#sample(c(5:30)*n*fac,1)
      y_2 <- y + 1*n*fac + if_else(noise_type == "white_", rand_y, noise_value)#sample(c(5:30)*n*fac, 1)
      move_x <- x_2 - x
      move_y <- y_2 - y
    } 
  } else{

    m1 <- lm(formula_x, data = df)
    move_x <- predict(m1)[1]
    m2 <- lm(formula_y, data = df)
    move_y <- predict(m2)[1]
    x_2_pred <-  move_x + x
    y_2_pred <- move_y + y
    
    y_diff <- y - y_2_pred
    x_diff <- x - x_2_pred
    
    if(abs(distance) < difference & x_diff < 0 & y_diff < 0){
      x_2 <- x + 1*n*fac + if_else(noise_type == "white_", rand_x, noise_value)#sample(c(5:30)*n*fac,1)
      y_2 <- y + 1*n*fac + if_else(noise_type == "white_", rand_y, noise_value)#sample(c(5:30)*n*fac, 1)
      move_x <- x_2 - x
      move_y <- y_2 - x
    } else if(abs(distance) < difference & x_diff < 0 & y_diff >= 0){
      x_2 <- x - 1*n*fac + if_else(noise_type == "white_", rand_x, noise_value)#sample(c(5:30)*n*fac,1)
      y_2 <- y + 1*n*fac + if_else(noise_type == "white_", rand_y, noise_value)#sample(c(5:30)*n*fac, 1)
      move_x <- x_2 - x
      move_y <- y_2 - y
    } else if(abs(distance) < difference & x_diff >= 0 & y_diff >=0){
      x_2 <- x - 1*n*fac + if_else(noise_type == "white_", rand_x, noise_value)#sample(c(5:30)*n*fac,1)
      y_2 <- y - 1*n*fac + if_else(noise_type == "white_", rand_y, noise_value)#sample(c(5:30)*n*fac, 1)
      move_x <- x_2 - x
      move_y <- y_2 - y
    } else if(abs(distance) < difference & x_diff >= 0 & y_diff < 0){
      x_2 <- x - 1*n*fac + if_else(noise_type == "white_", rand_x, noise_value)#sample(c(5:30)*n*fac,1)
      y_2 <- y + 1*n*fac + if_else(noise_type == "white_", rand_y, noise_value)#sample(c(5:30)*n*fac, 1)
      move_x <- x_2 - x
      move_y <- y_2 - y
    } 
  }
  return(data.frame(x = x_2, y = y_2, move_x_A1 = move_x, move_y_A1 = move_y, noise_type_A1 = noise_type,
                    error_x = if_else(noise_type == "white_", rand_x, noise_value),
                    error_y = if_else(noise_type == "white_", rand_y, noise_value)))
}

Agent_2 <- function(x =NULL, y = NULL, type, pair_Agent = NULL, distance =NULL, is_first = FALSE, follow_rule = TRUE, df = NULL,
                    model_type_ = model_type, noise_type = "white_", noise_value = NA_integer_){
  
  if(!type %in% c("divergent", "convergent")){
    stop('type parameter must be in c("divergent","convergent"')
  }
  if(!follow_rule %in% c(TRUE, FALSE)){
    stop('follow rule parameter must be in TRUE FALSE')
  }
  if(!noise_type %in% c("white_", "pink_", "")){
    stop('noise_type parameter must be in white_ pink_')
  }
  
  if(model_type_ == "you"){
    formula_x <- as.formula(move_x_A1 ~ iter + move_x_A1)
    formula_y <- as.formula(move_y_A1 ~ iter + move_y_A1)
  } else if(model_type_ == "us both"){
    formula_x <- as.formula(move_x_A1 ~ iter + move_x_A1 + move_x_A2)
    formula_y <- as.formula(move_y_A1 ~ iter + move_y_A1 + move_y_A2)
  } else{
    invisible()
  }
  
  if(is_first == TRUE){
    x <- 200#runif(1,-500, 500)
    y <- 200#runif(1,-500, 500)
    x_2 <- x
    y_2 <- y
    move_x <-0
    move_y <- 0
  }
  
  n <- if_else(type == "convergent", 1, -1)
  Slope <- y - pair_Agent$y/x- pair_Agent$x
  y_diff <- y - pair_Agent$y
  x_diff <- x - pair_Agent$x
  
  rand_x <-runif(1,-1,1)
  rand_y <- runif(1,-1,1)
  
  if(follow_rule == TRUE){
    if(is_first == TRUE){
      invisible()
    }else if(is.na(x)){
      x_2 <- NA
      y_2 <- NA
      move_x <- NA
      move_y <- NA
    }else if(abs(distance) < difference & x_diff < 0 & y_diff < 0){
      x_2 <- x + 1*n*fac + if_else(noise_type == "white_", rand_x, noise_value)# sample(c(5:30)*n*fac,1)
      y_2 <- y + 1*n*fac + if_else(noise_type == "white_", rand_y, noise_value)#sample(c(5:30)*n*fac, 1)
      move_x <- x_2 - x
      move_y <- y_2 - x
    } else if(abs(distance) < difference & x_diff < 0 & y_diff >= 0){
      x_2 <- x - 1*n*fac + if_else(noise_type == "white_", rand_x, noise_value)#sample(c(5:30)*n*fac,1)
      y_2 <- y + 1*n*fac + if_else(noise_type == "white_", rand_y, noise_value)#sample(c(5:30)*n*fac, 1)
      move_x <- x_2 - x
      move_y <- y_2 - y
    } else if(abs(distance) < difference & x_diff >= 0 & y_diff >=0){
      x_2 <- x - 1*n*fac + if_else(noise_type == "white_", rand_x, noise_value)#sample(c(5:30)*n*fac,1)
      y_2 <- y - 1*n*fac + if_else(noise_type == "white_", rand_y, noise_value)#sample(c(5:30)*n*fac, 1)
      move_x <- x_2 - x
      move_y <- y_2 - y
    } else if(abs(distance) < difference & x_diff >= 0 & y_diff < 0){
      x_2 <- x - 1*n*fac + if_else(noise_type == "white_", rand_x, noise_value)#sample(c(5:30)*n*fac,1)
      y_2 <- y + 1*n*fac + if_else(noise_type == "white_", rand_y, noise_value)#sample(c(5:30)*n*fac, 1)
      move_x <- x_2 - x
      move_y <- y_2 - y
    } 
  } else{
    m1 <- lm(move_x_A1 ~ iter + move_x_A1, data = df)
    move_x <- predict(m1)[1]
    print(move_x)
    m2 <- lm(move_y_A1 ~ iter + move_y_A1, data = df)
    move_y <- predict(m2)[1]
    print(move_y)
    x_1_pred <-  move_x + x
    y_1_pred <- move_y + y
    
    y_diff <- y - y_1_pred
    x_diff <- x - x_1_pred
    
    if(abs(distance) < difference & x_diff < 0 & y_diff < 0){
      x_2 <- x + 1*n*fac + ifelse(noise_type == "white_", rand_x, noise_value)#sample(c(5:30)*n*fac,1)
      y_2 <- y + 1*n*fac + ifelse(noise_type == "white_", rand_y, noise_value)#sample(c(5:30)*n*fac, 1)
      move_x <- x_2 - x
      move_y <- y_2 - x
    } else if(abs(distance) < difference & x_diff < 0 & y_diff >= 0){
      x_2 <- x - 1*n*fac + ifelse(noise_type == "white_", rand_x, noise_value)#sample(c(5:30)*n*fac,1)
      y_2 <- y + 1*n*fac + ifelse(noise_type == "white_", rand_y, noise_value)#sample(c(5:30)*n*fac, 1)
      move_x <- x_2 - x
      move_y <- y_2 - y
    } else if(abs(distance) < difference & x_diff >= 0 & y_diff >=0){
      x_2 <- x - 1*n*fac + ifelse(noise_type == "white_", rand_x, noise_value) #sample(c(5:30)*n*fac,1)
      y_2 <- y - 1*n*fac + ifelse(noise_type == "white_", rand_y, noise_value) #sample(c(5:30)*n*fac, 1)
      move_x <- x_2 - x
      move_y <- y_2 - y
    } else if(abs(distance) < difference & x_diff >= 0 & y_diff < 0){
      x_2 <- x - 1*n*fac + ifelse(noise_type == "white_", rand_x, noise_value) #sample(c(5:30)*n*fac,1)
      y_2 <- y + 1*n*fac + ifelse(noise_type == "white_", rand_y, noise_value)#sample(c(5:30)*n*fac, 1)
      move_x <- x_2 - x
      move_y <- y_2 - y
    } 
  }
  return(data.frame(x = x_2, y = y_2, move_x_A2 = move_x, move_y_A2 = move_y, noise_type_A2 = noise_type,
                    error_x = if_else(noise_type == "white_", rand_x, noise_value),
                    error_y = if_else(noise_type == "white_", rand_y, noise_value)))
}
# 
# Agent_1_df <- Agent_1(0,0, is_first = TRUE)
# print(Agent_1_df)
# Agent_2(0,0,pair_Agent = Agent_1_df)


# Create objects to store results
out_1 <- data.frame(x_1 = 0, y_1 = 0, move_x_A1 = 0, move_y_A1 =0, noise_type = "", error_x = 0, error_y = 0)
out_2 <- data.frame(x_2 = 0, y_2 = 0, move_x_A2 = 0, move_y_A2 =0, noise_type = "", error_x = 0, error_y = 0)
out_b <- data.frame(x_1 = 0, y_1 = 0, move_x_A1 = 0, move_y_A1 =0, noise_type_A1 = "", error_xA1 = 0, error_yA1 = 0,
                    x_2 = 0, y_2 = 0, move_x_A2 = 0, move_y_A2 =0, noise_type_A2 = "", error_xA2 = 0, error_yA2 = 0, iter = 0, trial_num = 0, TYPE = NA, model_type = NA)
outs <- list("list")
output <- vector("list")
res_non_synergy <- data.frame(RR= 0, DET = 0, LAM = "", MaxL = "", ENT = "", TYPE = "", model_type = "", noise_type = "", syn_type = "")
res_synergy <- data.frame(RR= 0, DET = 0, LAM = "", MaxL = "", ENT = "", TYPE = "", model_type = "", noise_type = "", syn_type = "")
res_list <- list("list")