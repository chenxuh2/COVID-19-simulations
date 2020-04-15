## simulate and analyze data with an ordinal-logit model

## y ~ ordinal_logit(logodds)
## logodds ~ b0 + b1X1 + b2X2 + b12X1X2

## Reference category:
## rate 5 (strongly agree) 
## given static graphs 
## none social distacing 


K <- 5 # number of categories
c <- K - 1 
J <- 50 # number of subjects
D <- 12 # number of items 
N <- J * D # number of data points 

## beta intercepts 
beta.4 <- 0.8
beta.3 <- 0.2
beta.2 <- -0.2
beta.1 <- -0.9

beta.gm <- c(beta.4, beta.3, beta.2, beta.1)

## beta format 
## change when group is interactive 
beta.f <- .02

beta.format <- rep(beta.f, c)
format <- rep(sample(c(0,1),J,replace = T), each=D)

## beta level
level.all <- rep(rep(1:4, each = 3), J)
## change when level is NOT none social distancing 
beta.min <- rep(-0.5, c)  
level.isMIN <- ifelse(level.all==2, 1, 0)

beta.mod <- rep(-0.3, c)
level.isMOD <- ifelse(level.all==3, 1, 0)

beta.ext <- rep(-0.2, c)
level.isEXT <- ifelse(level.all==4, 1, 0)

## beta interaction
beta.f.min <- rep(-0.01, c) 
beta.f.mod <- rep(-0.01, c)
beta.f.ext <- rep(-0.03, c)

Beta <- cbind(beta.gm, beta.format, beta.min, beta.mod, beta.ext, beta.f.min, beta.f.mod, beta.f.ext)

data <- cbind(rep(1, N), format, level.isMIN, level.isMOD, level.isEXT, format*level.isMIN, format*level.isMOD, format*level.isEXT)

logOdds_4 <- sum(Beta[1, ] * t(data))  # 1,2,3,4 | 5
logOdds_3 <- sum(Beta[2, ] * t(data))  # 1,2,3 | 4,5
logOdds_2 <- sum(Beta[3, ] * t(data))  # 1,2 | 3,4,5
logOdds_1 <- sum(Beta[4, ] * t(data))  # 1 | 2,3,4,5

print(c(logOdds_1, logOdds_2, logOdds_3, logOdds_4))

