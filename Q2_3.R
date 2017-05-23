# EE232E Project 2 Question 2/3/4

# clearing workspace
closeAllConnections()
rm(list=ls())

library('igraph')
library('readr')


# # read in movies
# movies = read_delim("movie_genre.txt" , col_names = paste0("V",seq_len(3)), delim = "\t",quote = "\"")
# movies= movies$V1[] # list of all movies

# read in actors file
actors = read.csv("total_actors.txt")
actors_names = actors[2] #remove first column (true indicies from original file)

# Question 2
Graph.data = read.delim("node_list.txt",sep = "\t",header=FALSE)
g1 = graph.data.frame(Graph.data,directed = TRUE)

# Question 3
pg_rank = page.rank(g1, directed = TRUE, damping = 0.85)
sorted_pg_rank = sort(pg_rank$vector,decreasing = TRUE,index.return = TRUE)

print(sorted_pg_rank$x[1:10]) # print 10 highest page ranks
