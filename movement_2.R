

for(j in 1:trial_num){
  for(g in c("white_", "pink_")){
    for(i in 1:iter_num){
      
      if(i != 1){
          # Find distance between points
          distance <- sqrt(sum((Agent_1_df$x-Agent_2_df$x)^2 + (Agent_1_df$y-Agent_2_df$y)^2))
          
          rand = runif(1, 0, 1)
          
          if(distance >= difference | is.na(Agent_1_df$x|abs(distance) < 5)){
            Agent_1_df <- data.frame(x=NA, y = NA, move_x_A1 = NA, move_y_A1 = NA, noise_type_A1 = g)
            Agent_2_df <- data.frame(x = NA, y = NA,move_x_A2 = NA, move_y_A2 = NA, noise_type_A2 = g)
            out_1[i,] <- Agent_1_df
            out_2[i,] <- Agent_2_df
          }else{
        }
      }
          
      if(i == 1){
        Agent_1_df <- Agent_1(type = k, is_first = TRUE)
        Agent_2_df <- Agent_2(type = k, is_first = TRUE)
        out_1[i,] <- Agent_1_df
        out_2[i,] <- Agent_2_df
      }else if(g == "white_"){
        if(i <= start_predicting){
          if(rand >= 0.5){
            Agent_2_df <- Agent_2(Agent_2_df$x, Agent_2_df$y, type = k,pair_Agent = Agent_1_df, distance = distance)
            Agent_1_df <- Agent_1(Agent_1_df$x, Agent_1_df$y, type = k, pair_Agent = Agent_2_df, distance = distance)
          }else{
            Agent_1_df <- Agent_1(Agent_1_df$x, Agent_1_df$y, type = k, pair_Agent = Agent_2_df, distance = distance)
            Agent_2_df <- Agent_2(Agent_2_df$x, Agent_2_df$y, type = k,pair_Agent = Agent_1_df, distance = distance)
          }
        }else{
          if(rand >= 0.5){
            Agent_2_df <- Agent_2(Agent_2_df$x, Agent_2_df$y, type = k,pair_Agent = Agent_1_df, distance = distance, follow_rule=FALSE, df = out_b[(i-5):(i-1),])
            Agent_1_df <- Agent_1(Agent_1_df$x, Agent_1_df$y, type = k, pair_Agent = Agent_2_df, distance = distance, follow_rule=FALSE, df = out_b[(i-5):(i-1),])
          }else{
            Agent_1_df <- Agent_1(Agent_1_df$x, Agent_1_df$y, type = k, pair_Agent = Agent_2_df, distance = distance, follow_rule=FALSE, df = out_b[(i-5):(i-1),])
            Agent_2_df <- Agent_2(Agent_2_df$x, Agent_2_df$y, type = k,pair_Agent = Agent_1_df, distance = distance, follow_rule=FALSE, df = out_b[(i-5):(i-1),])
          }
        }
        out_1[i,] <- Agent_1_df
        out_2[i,] <- Agent_2_df
      } else if(g == "pink_"){
          if(i <= start_predicting){
            if(rand >= 0.5){
              Agent_2_df <- Agent_2(Agent_2_df$x, Agent_2_df$y, type = k,pair_Agent = Agent_1_df, distance = distance, noise_type = "pink_", noise_value = pink_noises[[j]][[2]][i])
              Agent_1_df <- Agent_1(Agent_1_df$x, Agent_1_df$y, type = k, pair_Agent = Agent_2_df, distance = distance, noise_type = "pink_", noise_value = pink_noises[[j]][[1]][i])
            }else{
              Agent_1_df <- Agent_1(Agent_1_df$x, Agent_1_df$y, type = k, pair_Agent = Agent_2_df, distance = distance, noise_type = "pink_", noise_value = pink_noises[[j]][[1]][i])
                Agent_2_df <- Agent_2(Agent_2_df$x, Agent_2_df$y, type = k,pair_Agent = Agent_1_df, distance = distance, noise_type = "pink_", noise_value = pink_noises[[j]][[2]][i])
            }
          }else{
            if(rand >= 0.5){
              Agent_2_df <- Agent_2(Agent_2_df$x, Agent_2_df$y, type = k,pair_Agent = Agent_1_df,distance = distance, follow_rule=FALSE,
                               noise_type = "pink_", noise_value = pink_noises[[j]][[2]][i], df = out_b[(i-5):(i-1),])
              Agent_1_df <- Agent_1(Agent_1_df$x, Agent_1_df$y, type = k, pair_Agent = Agent_2_df, distance = distance, follow_rule=FALSE,
                               noise_type = "pink_", noise_value = pink_noises[[j]][[1]][i], df = out_b[(i-5):(i-1),])
            }else{
          
              Agent_1_df <- Agent_1(Agent_1_df$x, Agent_1_df$y, type = k, pair_Agent = Agent_2_df, distance = distance, follow_rule=FALSE,
                               noise_type = "pink_", noise_value = pink_noises[[j]][[1]][i], df = out_b[(i-5):(i-1),])
              Agent_2_df <- Agent_2(Agent_2_df$x, Agent_2_df$y, type = k,pair_Agent = Agent_1_df, distance = distance, follow_rule=FALSE,
                               noise_type = "pink_", noise_value = pink_noises[[j]][[2]][i], df = out_b[(i-5):(i-1),])
            }
          }
        out_1[i,] <- Agent_1_df
        out_2[i,] <- Agent_2_df
        
      }
    
    out_b[i,] <- cbind(out_1[i,], out_2[i,])
    }
    
     outs[[g]] <- out_b
     outs[[g]]$iter <- 1:iter_num
     outs[[g]]$trial_num <- j
     outs[[g]]$TYPE <- k
     outs[[g]]$model_type <- model_type
  }
  output[[j]] <- outs
}


# df <-output[[1]][complete.cases(output[[1]]),]
# m1 <- lm(move_x_A1 ~ move_x_A1, move_y_A1 + move_x_A2 + move_y_A2, data = df)
# plot(m1)
# predict(m1)[1]
names_ <- c(" ", "white_", "pink_")
for(j in 2:3){
  for(i in 1:trial_num){
    trial_df <-output[[i]][[j]][complete.cases(output[[i]][[j]]),]
    trial_df <- trial_df[trial_df$TYPE != "0",]
    
    
    #m_plot <- plot_ly(trial_df, x = ~x_1, y = ~y_1, z = ~iter, type = "scatter3d", mode = "point") %>%
    #          add_trace(x = ~x_2, y = ~y_2, z = ~iter)
    
    #print(m_plot)
    for(g in c("non_synergy", "synergy")){
      
      if(g == "non_synergy"){
        res <-crqa(c(abs(trial_df$move_x_A1), abs(trial_df$move_y_A1)), c(abs(trial_df$move_x_A2), abs(trial_df$move_y_A2)),
                   delay = 2, embed = 2, rescale = 0, 
                   radius = 0.5, normalize = 0, mindiagline = 2, 
                   minvertline = 2, tw = 0, method = "crqa", side = "both", 
                   datatype = "continuous")
        
        par = list(unit = 1, labelx = NULL, labely = NULL, 
                   cols = "grey42", pcex = 1, pch = 19, 
                   labax = NULL, 
                   labay = NULL, 
                   las = 1)
        RP <- res$RP
        rp <- crqa::plotRP(RP, par = par)
        print(rp)
        
        res_non_synergy[i,] <- data.frame(RR =res$RR, DET = res$DET, LAM = res$LAM, MaxL = res$maxL, ENT = res$ENTR,
                               TYPE = unique(trial_df$TYPE), model_type = unique(trial_df$model_type), noise_type = names_[j],
                               syn_type = g)
      }else if(g == "synergy"){
        
        merged_df <- merge(x = melt(trial_df[,c("iter", "move_x_A1", "move_x_A2")], id = "iter"),
                           y =melt(trial_df[,c("iter", "move_y_A1", "move_y_A2")], id = "iter"),
                           by = "iter") %>% arrange(iter)
        
        synergy_x <- merged_df %>% group_by(iter, variable.x) %>% distinct(value.x)
        synergy_y <- merged_df %>% group_by(iter, variable.y) %>% distinct(value.y)
        
        res <-crqa(c(abs(synergy_x$value.x), abs(synergy_y$value.y)), c(abs(synergy_x$value.x), abs(synergy_y$value.y)),
                   delay = 2, embed = 2, rescale = 0, 
                   radius = 0.5, normalize = 0, mindiagline = 2, 
                   minvertline = 2, tw = 0, method = "crqa", side = "both", 
                   datatype = "continuous")
        
        par = list(unit = 1, labelx = NULL, labely = NULL, 
                   cols = "grey42", pcex = 1, pch = 19, 
                   labax = NULL, 
                   labay = NULL, 
                   las = 1)
        RP <- res$RP
        rp <- crqa::plotRP(RP, par = par)
        print(rp)
        
        res_synergy[i,] <- data.frame(RR =res$RR, DET = res$DET, LAM = res$LAM, MaxL = res$maxL, ENT = res$ENTR,
                               TYPE = unique(trial_df$TYPE), model_type = unique(trial_df$model_type), noise_type = names_[j],
                               syn_type = g)
      }
    }
  }
  res_list[[j]] <- rbind(res_non_synergy, res_synergy)
  write.csv(res_list[[j]], paste0(results_dir, "\\",k, "_", names_[j],"_", Sys.Date(), model_type, "_results.csv"))
}

# RR_plot <- ggplot(res_, aes(TYPE, RR)) +
#   geom_violin(fill = "tomato1") + geom_point()
# print(RR_plot)
# ggsave(paste0(results_dir,"\\", unique(res_$TYPE), "_RR_plot.png"), plot = RR_plot, device = png)
#  
# 
# DET_plot <- ggplot(res_, aes(TYPE, DET)) +
#   geom_violin(fill = "lightblue") + geom_point()
# print(DET_plot)
# 
# ggsave(paste0(results_dir,"\\", unique(res_$TYPE),"_DET_plot.png"), plot = DET_plot, device = png)
# 
# write.csv(res_, paste0(results_dir, "\\",k, "_", Sys.Date(), model_type, "_results.csv"))

# plot3d(out_b$iter, out_b$x_1, out_b$y_2)
# 
# ggplot(out_b) +
#   geom_line(aes(iter, y_1), color = "blue") +
#   geom_line(aes(iter, y_2), color = "red")

# merged_df <- merge(x =melt(output[[1]][["white_"]][,c("iter", "move_x_A1", "move_x_A2")], id = "iter"),
#                    y =melt(output[[1]][["white_"]][,c("iter", "move_y_A1", "move_y_A2")], id = "iter"),
#                    by = "iter") %>% arrange(iter)
# 
# synergy_x <- merged_df %>% group_by(iter, variable.x) %>% distinct(value.x)
# synergy_y <- merged_df %>% group_by(iter, variable.y) %>% distinct(value.y)