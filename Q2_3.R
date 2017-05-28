# EE232E Project 2 Question 2/3

# clearing workspace
closeAllConnections()
rm(list=ls())

library('igraph')
library('readr')


# Question 2
Graph.data = read.delim("data_files/node_list2.txt",sep = ",",header=FALSE,stringsAsFactors = FALSE) # text file generated from Q1.py and Q2.py
colnames(Graph.data) = c("Node 1", "Node 2", "weights")
g1 = graph.data.frame(Graph.data,directed = TRUE) #create graph

# Question 3
pg_rank = page.rank(g1, directed = TRUE, damping = 0.85) # get all page ranks
sorted_pg_rank = sort(pg_rank$vector,decreasing = TRUE,index.return = TRUE) # sort page rank

print(sorted_pg_rank$x[1:10]) # print 10 highest page ranks
