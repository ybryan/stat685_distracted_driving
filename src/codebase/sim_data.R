fit_homo <- stan(here::here("src", "stan", "sim_model_1b.stan"),
                 iter=200, chains=1, warmup=0, algorithm="Fixed_param")

fit_hetero <- stan(here::here("src", "stan", "sim_model_2b.stan"),
                   iter=200, chains=1, warmup=0, algorithm="Fixed_param")

fit_texting <- stan(here::here("src", "stan", "sim_model_3b.stan"),
                    iter=200, chains=1, warmup=0, algorithm="Fixed_param")

save(fit_homo, fit_hetero, fit_texting, file="sim_models.RData")
