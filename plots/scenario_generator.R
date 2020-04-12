library(randomNames)

n <- 27
age <- c(sample(20:44, 9, replace = F), sample(45:64, 9, replace = F), sample(65:84, 9, replace = F))
# 0 is male & 1 is famile
gender <- sample(c(0,1), n, replace = T)
g_code <- ifelse(gender==0, 'He decides to', 'She decides to')
name <- randomNames::randomNames(n, which.names = 'first', gender = gender)
roommate <- rep(rep(c('lives alone.', 'lives with another person.', 'lives with family members.'), each=3),3)
extreme <- c('pick up grocery outside the store.',
            'go to the doctor for an annual exam.')
mod <- c('play chess with a friend in the park.',
         'visit a close friend who lives alone.')
none <- c('go to a game night at a friend\'s house.',
          'go to a party.')


items <- rep(NA, n)
for(i in 1:n) {
  items[i] <- paste(name[i], 'is', age[i], 'years old and', roommate[i], g_code[i], events[i], sep = " ")
}
