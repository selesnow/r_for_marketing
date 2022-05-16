# угадай число
# ###############
# простой вариант
# ###############
x = round(runif(n = 1, min = 1, max = 10), 0)

while ( TRUE ) {
  z = readline("Enter your number: ")
  
  if ( x == z ) {
    print("You win!")
    break
  }
  
  print("No!")
} 

# ###############
# сложный вариант
# ###############
users_num <- as.integer(readline("Enter users number: "))

usernames <- c()

for ( user in 1:users_num ){
  print(user)
  username <- readline(paste0("Enter name for user ", user, ": "))
  usernames <- c(usernames, username)
}

print(paste0(c("Users:", usernames), collapse = " "))

max_points  <- 10
max_attemps <- 3
rounds      <- 3

xmin <- 1
xmax <- 10

results <- as.list(rep(0, length(usernames)))
names(results) <- usernames

for (round in 1:rounds) {
  
  message("Round: ", round)
  
  for (user in usernames) {
    
    x = round(runif(n = 1, min = xmin, max = xmax), 0)
    
    message("User: ", user)
    current_points = max_points
    
    for (attemp in 1:max_attemps){
      
      
      message("atemp: ", attemp)
      z = as.integer(readline(paste(user,"enter your number: ")))
      
      if ( z == x ) {
        results[[user]] <-  results[[user]] + current_points
        x = round(runif(n = 1, min = 1, max = 10), 0)
        message(user, "points:", results[user] )
        break
      } else {
        current_points <- round(current_points * 0.75, 0)
      }
      
    }
    
  }
  
}

# Who is winner
which.max(results)

# results 
results
