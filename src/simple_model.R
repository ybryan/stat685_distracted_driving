library(rstan)
library(dplyr)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

## Data import
df <- feather::read_feather(here::here("study_df", "df_select.feather"))
subject_df <- feather::read_feather(here::here("study_df", "subject_df.feather"))
nd_nolanechange <- df %>% dplyr::filter(Drive == "ND") %>% 
    dplyr::filter(!dplyr::between(Distance, 5000, 7000))
md_nolanechange <- df %>% dplyr::filter(Drive == "MD")  %>%
    dplyr::filter(!dplyr::between(Distance, 5000, 7000))

nd_drive <- nd_nolanechange %>% 
    dplyr::group_by(Subject) %>% 
    dplyr::summarize(sd_lane = log(sd(Lane.Position)))

# =========== Generate Data ==================================================
# Simulated model 1a: Homogeneous population (age)
#fit_homo_a <- stan(here::here('src', 'stan', 'sim_model_1a.stan'),
#                 iter=1, chains=1, warmup=0, algorithm='Fixed_param')

# Simulated model 1b: Homogenoue population (age) with functional call
fit_homo_b <- stan(here::here('src', 'stan', 'sim_model_1b.stan'),
                   iter=100, chains=1, warmup=0, algorithm='Fixed_param')

la <- rstan::extract(fit_homo_b, permuted=TRUE)
a <- rstan::extract(fit_homo_b, permuted=FALSE)

# Simulated model 2a: Heterogeneous popuations (age cohor)
#fit_hetero <- stan(here::here('src', 'stan', 'sim_model_2a.stan'),
#                   iter=1, chains=1, warmup=0, algorithm='Fixed_param')

# Simulated model 2b: Heterogeneous popuations (age cohor) with functional call
fit_hetero <- stan(here::here('src', 'stan', 'sim_model_2b.stan'),
                   iter=100, chains=1, warmup=0, algorithm='Fixed_param')

lb <- rstan::extract(fit_homo_b, permuted=TRUE)
b <- rstan::extract(fit_homo_b, permuted=FALSE)

# ========== Fit data to model ===============================================
