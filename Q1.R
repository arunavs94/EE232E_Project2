# Commented out in order to not have to load .RData file 
# clearing workspace
closeAllConnections()
rm(list=ls())

library('igraph')
# library('readr')

# Set to appropriate working director
# setwd("~/Desktop/Project2/EE232E_Project2/project_2_data")

#### Only need to run once (Have already run, data stored in -> CorrectActorsActresses.RData) ####

# # Read in data from .txt files
actors.movies = read_delim("actor_movies.txt" , col_names = paste0("V",seq_len(15)), delim = "\t", quote = "\"")
actress.movies = read_delim("actress_movies.txt" , col_names = paste0("V",seq_len(15)), delim = "\t")

# Search for actors and actresses with at least 5 movies 

# correct_actors = c()
# correct_actresses = c()
# correct_total = c()
# 
# for (i in 1:length(actors.movies$V1)){
#   cat('Actor iteration: ')
#   cat(i)
#   cat('\n')
#   count = 0
#   if (!(is.na(actors.movies$V3[i]))){
#     count = count + 1
#   }
#   if (!(is.na(actors.movies$V5[i]))){
#     count = count + 1
#   }
#   if (!(is.na(actors.movies$V7[i]))){
#     count = count + 1
#   }
#   if (!(is.na(actors.movies$V9[i]))){
#     count = count + 1
#   }
#   if (!(is.na(actors.movies$V11[i]))){
#     count = count + 1
#   }
#   if (!(is.na(actors.movies$V13[i]))){
#     count = count + 1
#   }
#   if (!(is.na(actors.movies$V15[i]))){
#     count = count + 1
#   }
#   
#   if (count >= 5){
#     correct_actors = c(correct_actors,actors.movies$V1[i])
#     correct_total = c(correct_total,actors.movies$V1[i])
#   }
#  
# }
# 
# for (i in 1:length(actress.movies$V1)){
#   cat('Actress iteration: ')
#   cat(i)
#   cat('\n')
#   count = 0
#   if (!(is.na(actress.movies$V3[i]))){
#     count = count + 1
#   }
#   if (!(is.na(actress.movies$V5[i]))){
#     count = count + 1
#   }
#   if (!(is.na(actress.movies$V7[i]))){
#     count = count + 1
#   }
#   if (!(is.na(actress.movies$V9[i]))){
#     count = count + 1
#   }
#   if (!(is.na(actress.movies$V11[i]))){
#     count = count + 1
#   }
#   if (!(is.na(actress.movies$V13[i]))){
#     count = count + 1
#   }
#   if (!(is.na(actress.movies$V15[i]))){
#     count = count + 1
#   }
#   
#   if (count >= 5){
#     correct_actresses = c(correct_actresses,actress.movies$V1[i])
#     correct_total = c(correct_total,actress.movies$V1[i])
#   }
#   
# }
# 

## Saving the .RData 
save.image(file = 'CorrectActorsActresses.RData')

#### END ####

# # Load data
load("CorrectActorsActresses.RData")

# Taking subset of dataframe corresponding to only core nodes
core_actors.movies = actors.movies[actors.movies$V1 %in% correct_actors, ]
core_actress.movies = actress.movies[actress.movies$V1 %in% correct_actresses, ]
core_total.movies = rbind(core_actors.movies, core_actress.movies)

write.csv(core_total.movies[c(TRUE,FALSE)],file = "total_actors.txt") # write to CSV removing all NA

# # use the following to read in CSV
# temp = read.csv("total_actors.txt")
# temp = temp[2:9] #remove first column (true indicies from original file)

