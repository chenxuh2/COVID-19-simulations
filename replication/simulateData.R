library(rstan)
library(extrafont)
loadfonts()

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

library(shinystan)
library(ggplot2)
library(dplyr)

# between subject variable: presentation format (interactive, static)
# within subject variable: level of social distancing (4)

# Y_i = beta_{intercept} + beta_{format} * X_{i,format} + beta_{level} * X_{i, level} + beta_{format*level}*X_{i,format}*X_{i,level}

# Constraint 
transform <- function(x) {
	y <- 1/ (1+ exp(x))
	return(y)
}

# Let's try to simulate some data
set.seed(8675309)
K <- 4
J <- 50 #number of subjects

# format 
# 0 is static, 1 is interactive
format <- sample(c(0,1),J, replace=T)
sub.format <- rep(format, each=12)

# level
sub.level <- rep(rep(1:4, each=3), J)
# item 
item <- rep(1:12, J)

# set a baseline
# static group rating none social distancing (level 1)

# let's assume some intercept value 
beta.gm <- 5
beta.gm.vec <- rep(beta.gm, 4)

# let's assume that interactive group has a rating that is lower by 2
beta.format <- -2
beta.format.vec <- c(0, rep(beta.format, 3))

# let's assume that level 4: extensive social distancing 
# has a rating that is lower by 3
beta.level.ext <- -3

# level 3: moderate social distancing 
# has a rating that is lower by 1
beta.level.mod <- -1

# level 2: minor social distancing
# has a rating that is lower by 0.2
beta.level.min <- -0.2

beta.level.vec <- c(0, beta.level.min, beta.level.mod, beta.level.ext)

# specify betas for interactions
beta.format.level.min <-  -0.1
beta.format.level.mod <- -0.1
beta.format.level.ext <- -0.1 
beta.interactions.vec <- c(0, beta.format.level.min, beta.format.level.mod, beta.format.level.ext)


Beta <- as.matrix(cbind(beta.gm.vec, beta.format.vec, beta.level.vec, beta.interactions.vec))

data <- cbind(rep(1, length(sub.format)), sub.format, sub.level, sub.format*sub.level)

y <- rep(NA, nrow(data))
for(i in 1:nrow(data)) {
	y[i] <- transform(Beta[data[i,3],] %*% data[i,] + rnorm(1, 0,1))
}

N <- length(y)
# uninormal


df <- cbind.data.frame(data, item, y)
colnames(df) <- c('intercept', 'format', 'level', 'interaction', 'item','rating')
head(df)

gp <- ggplot(df, aes(x=rating)) +
      geom_histogram(fill='black') +
      facet_grid(as.factor(item) ~ .)

#setwd("Documents/GitHub/COVID-19-simulations/replication")
#write.csv(df, "fake-data.csv")

df <- as.data.frame(df)
df$format <- as.factor(df$format)
df$level <- as.factor(df$level)

fd <- list(K = K, D = 10, N = N, format = sub.format, level = sub.level)

setwd("~/Documents/GitHub/COVID-19-simulations/replication")
fit <- stan(file='model.stan',
            data=fd,
            warmup = 800,
            iter = 2000,
            chains = 4)

launch_shinystan(fit)
