library(rstan)
library(dplyr)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

## Data import
df_feather <- feather::read_feather(here::here("study_df", "df.feather"))
subject_bio <- feather::read_feather(here::here("study_df", "subject_bio.feather"))
df <- df_feather %>% 
    dplyr::select(Subject, Distance, Lane.Position, Drive, phase,
                  Gaze.X.Pos, Gaze.Y.Pos, Lft.Pupil.Diameter, Rt.Pupil.Diameter,
                  gender, age_group, tai, type_ab) %>%
    dplyr::mutate(age_group=as.factor(age_group),
                  gender=as.factor(gender),
                  Drive=as.factor(Drive))
nd_df <- df %>% dplyr::filter(Drive == "ND") 
md_df <- df %>% dplyr::filter(Drive == "MD") 
nd_nolanechange <- nd_df %>% dplyr::filter(!dplyr::between(Distance, 5000, 7000))
md_nolanechange <- md_df %>% dplyr::filter(!dplyr::between(Distance, 5000, 7000))

data <- nd_nolanechange %>% dplyr::group_by(Subject) %>% 
    summarize(sd_lane = sd(Lane.Position),
              mu_eye = mean(Lft.Pupil.Diameter, na.rm=FALSE))

# Simulated model 1a: Homogeneous population (age)
sim_1 <- here::here('src', 'stan', 'sim_model_1a.stan')
fit_homo <- stan(file=sim_1, iter=1, chains=1, warmup=0, algorithm='Fixed_param')

la <- rstan::extract(fit_homo, permuted=TRUE)
a <- rstan::extract(fit_homo, permuted=FALSE)
