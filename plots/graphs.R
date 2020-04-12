setwd("~/Documents/GitHub/COVID-19-simulations/plots")
library(ggplot2)
library(tidyr)
library(wesanderson)
sample.df <- read.csv('nDays30populationSize2000propInfectedpropImmuComp0.028interactionsPerDay10.csv')
head(sample.df)
## add day 0
d0 <- rep(0, ncol(sample.df))
sample.df <- rbind(d0, sample.df)
sample.long <- gather(sample.df, key = 'pars', value = 'values')
sample.long <- sample.long[-c(1:31),]
sample.long$day <- rep(0:30, length(unique(sample.long$pars)))
## number of hospital beds available
beds <<- 20


sample.gg <- ggplot(data=sample.long, aes(x=day, y=values, color=pars)) +
             geom_line(size=.75) + 
             geom_hline(yintercept = beds) +
             xlab('days since first case of coronavirus') +
             ylab('number of cases') +
             ylim(0,2000) +
             ggtitle("p(infected) = 0.01; \np(immunocompromised) = 0.028; \n10 interactions/day") +
             theme(title=element_text(size=12), axis.text=element_text(size=12), axis.title = element_text(size=12), legend.text = element_text(size=12), legend.title = element_text(size=12)) +
             scale_color_manual(values=wes_palette("Darjeeling1"), 
                              name="condition",
                              breaks=c("nCritical", "nHospitalized", "nInfected", "nRecovered", 'nSymptomatic'),
                              labels=c("Critical", "Hospitalized", "Infected", "Recovered", "Symptomatic"))
             
sample.gg
ggsave(filename = 'simPopSize2000_1.pdf', sample.gg, height = 4, width = 5)

