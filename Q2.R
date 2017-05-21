# EE232E Project 2 Question 2

# clearing workspace
closeAllConnections()
rm(list=ls())

library('igraph')

# read in actors file
actors = read.csv("total_actors.txt")
actors = actors[2:9] #remove first column (true indicies from original file)
colnames(actors) = c("names","V1","V2","V3","V4","V5","V6","V7") #rename columns

num_movies=numeric()
for (i in 1:length(actors$names)){
  num_movies[i] = length(actors[i,][!is.na(actors[i,])]) #number of movies each actor has performed in
}
