load(here::here("sim_models.RData"))
la <- rstan::extract(fit_homo, permuted=TRUE)
lb <- rstan::extract(fit_hetero, permuted=TRUE)
lc <- rstan::extract(fit_texting, permuted=TRUE)


N <- length(lb$x)
x <- lb$x
log_y <- lb$log_y
N_age <- length(unique(lb$age))
age <- lb$age
homo_model <- stan(here::here("src", "stan", "model_1c.stan"),
                   data=list(N, x, log_y, N_age, age))

hetero_model <- stan(here::here("src", "stan", "model_2a.stan"),
                     data=list(N, x, log_y, N_age, age))

N <- length(lc$x)
x <- lc$x
log_y <- lc$log_y
N_age <- length(unique(lc$age))
age <- lc$age
texting <- lc$texting

texting_model <- stan(here::here("src", "stan", "model_3a.stan"),
                      data=list(N, x, log_y, N_age, age, texting))

save(homo_model, hetero_model, texting_model,file = here::here("fitted_sim_models.RData"))


load("gaze.RData")

N <- dim(gaze)[1]
x <- gaze$sd_log_y_gaze
log_y <- gaze$sd_log_lane_position
N_age <- length(unique(gaze$age_group))
age <- as.integer(gaze$age_group)
texting <- as.integer(gaze$texting)

act_homo_model <- stan(here::here("src", "stan", "model_1c.stan"),
                       data=list(N, x, log_y, N_age, age))

act_hetero_model<- stan(here::here("src", "stan", "model_2a.stan"),
                        data=list(N, x, log_y, N_age, age))

act_texting_model <- stan(here::here("src", "stan", "model_3a.stan"),
                          data=list(N, x, log_y, N_age, age, texting))

save(act_homo_model, act_hetero_model, act_texting_model, file = here::here("fitted_act_models.RData"))
