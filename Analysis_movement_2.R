if(!require(lme4)){install.packages("lme4")}
if(!require(lmerTest)){install.packages("lmerTest")}

#Read in the Data

dataset_names <- list.files(results_dir, pattern = "*.csv")
datasets <- lapply(dataset_names, function(i) read.csv(paste0(results_dir, "\\", i)))

analysis_df <- do.call("rbind", datasets) %>% mutate(noise_type = if_else(noise_type == "pink_", "pink", "white"),
                                                     model_type = if_else(model_type == "you", "prediction 1", "prediction 2"),
                                                     syn_type = if_else(syn_type == "non_synergy", "alignment", "synergy"))

analysis_df$var <- rep("", nrow(analysis_df))


# Make Violin Plots
ggplot(analysis_df, aes(var, RR)) + theme_bw() +
  geom_violin(fill = "purple4",alpha = 0.2) + geom_point(size = 0.2) +
  facet_grid(model_type+syn_type~ noise_type+TYPE) +
  xlab("") +
  ylab("Recurrence Rate")

# # Run Statistical Models
# 

RR_model <- lm(RR ~ noise_type*model_type*TYPE + syn_type, data = analysis_df)
sink(paste0(results_dir, "\\", "Recurrence_rate_model.txt"))
print(summary(RR_model))
sink()  # returns output to the console

ggplot(RR_model$residuals)
residuals_df <- data.frame(var = rep("", 800), residuals = RR_model$residuals)
ggplot(residuals_df, aes(residuals)) + geom_density(fill = "purple4", alpha = 0.2) + theme_bw()



DET_model <- lmer(DET ~ noise_type*model_type*TYPE + syn_type +(1 | RR), data = analysis_df)
sink(paste0(results_dir, "\\", "Determinism_model.txt"))
print(summary(DET_model))
sink()


ENT_model <-lmer(ENT ~noise_type*model_type*TYPE + syn_type +(1 |RR), data = analysis_df)
sink(paste0(results_dir, "\\", "Entropy_model.txt"))
print(summary(ENT_model))
sink()

LAM_model <-lmer(LAM ~noise_type*model_type*TYPE + syn_type +(1 |RR), data = analysis_df)
sink(paste0(results_dir, "\\", "Laminarity_model.txt"))
print(summary(LAM_model))
sink()

MaxL_model <-lmer(MaxL ~noise_type*model_type*TYPE + syn_type +(1 |RR), data = analysis_df)
sink(paste0(results_dir, "\\", "MaxL_model.txt"))
print(summary(MaxL_model))
sink()

