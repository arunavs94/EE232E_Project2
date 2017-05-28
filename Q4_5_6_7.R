# EE232E Project 2 Question 4,5,6,7

# clearing workspace
closeAllConnections()
rm(list=ls())

library('igraph')
library('readr')

############## Question 4 ##############
cat("\n \n ############## Question 4 ############## \n")

Graph.data = read.delim("data_files/node_list4_smovies.txt",sep = ",",header=FALSE,stringsAsFactors = FALSE) #generate from Q4.py
colnames(Graph.data) = c("Node 1", "Node 2", "weights")
g1 = graph.data.frame(Graph.data,directed = FALSE)
g1_simple = simplify(g1,remove.loops = FALSE,edge.attr.comb = "first") #remove multiple edges

cat("Number of nodes in the movie network: ",length(V(g1_simple)),"\n")
cat("Number of edges in the movie network: ",length(E(g1_simple)),"\n")


############## Question 5 ##############
cat("\n \n ############## Question 5 ############## \n")

# read in movies & genres  
movie_genre = read.delim("data_files/movie_genre.txt" ,header = FALSE,stringsAsFactors = FALSE)
movie_genre$V2 = NULL
colnames(movie_genre) = c("movie","genre")
movies = as.vector(movie_genre$movie)

genre_master = as.vector(unique(movie_genre$genre)) #create vector mapping genre to a specific index

comm_struct = fastgreedy.community(g1_simple, weights = E(g1_simple)$weights)

memberships = comm_struct$membership # 35213 nodes
num_coms = length(unique(memberships)) # 297

tot_comm_genres = matrix(list(),num_coms,1)
for(i in 1:num_coms){
  cat('Analyzing Community', i , 'of', num_coms,'\n')
  
    # get all movies in community i   
  idx = which(memberships == i) # indicies of nodes in community i
  comm_movies = V(g1_simple)$name[idx]                  
  
    # get all genres of movies in community i
  matches = match( sub("\\s+$", "", comm_movies), movies , nomatch = 0 )
  matches = matches[ which(matches != 0)]
  comm_genres = movie_genre$genre[matches]
  
    #get master idx of each genre in community i
  genre_idx = table(match(comm_genres,genre_master)) 
  
  thresh = length(comm_genres)*0.2 # set 20% threshold
  
  ps_thresh = which(genre_idx >= thresh) # which indicies occured more than 20% of the time
  comm_20_genres = genre_master[as.numeric(names(ps_thresh))] # convert idx back to actual genre names
  if(length(comm_20_genres) == 0){
    comm_20_genres = "None greater than 20%"
  }
  tot_comm_genres[[i,1]] = comm_20_genres
  cat('     Community', i, 'genres: ',comm_20_genres,'\n')
}


############## Question 6 ##############
cat("\n \n ############## Question 6 ############## \n")

nodes = V(g1_simple)$name # all nodes names in g1_simple graph

  #Batman
movie_name_bat = "Batman v Superman: Dawn of Justice (2016)  "

batman = which(nodes == movie_name_bat) # find index for batman node
batman_comm = comm_struct$membership[batman] # find belonging community
batman_neighbors = as.vector(neighbors(g1_simple , batman , mode = "all"))

  # generate node pair list to get edge ids (N1,N2 , N1,N3 , ...)
batman_nvec = numeric()
for( i in batman_neighbors){
  batman_nvec = c(batman_nvec,batman,i) 
}

batman_edge_ids = get.edge.ids(g1_simple,batman_nvec,directed = FALSE) # get all edges ids with batman nodes
batman_edge_weights = E(g1_simple , directed = FALSE)$weights[batman_edge_ids] # get corresponding weights
sorted_weights = sort(batman_edge_weights , decreasing = TRUE , index.return = TRUE)

  # take first 5 sorted idx and convert back to movie name
batman_5NN_idx = batman_edge_ids[sorted_weights$ix[1:5]]
batman_5NN_pairs = ends(g1_simple,batman_5NN_idx) # outputs a matrix
batman_5NN_names = batman_5NN_pairs[which(batman_5NN_pairs != movie_name_bat)]

  # Print statements
cat("\"",sub("\\s+$" , "", movie_name_bat) , "\" is in community # ",batman_comm ,
    " labeled with genre(s): " , tot_comm_genres[[batman_comm,1]] , "\n \n")

cat("The 5 Nearest neightbors of \"",sub("\\s+$", "", movie_name_bat), "\" are: \n")
cat("   ",batman_5NN_names[1]," with weight ",sorted_weights$x[1],"\n")
cat("   ",batman_5NN_names[2]," with weight ",sorted_weights$x[2],"\n")
cat("   ",batman_5NN_names[3]," with weight ",sorted_weights$x[3],"\n")
cat("   ",batman_5NN_names[4]," with weight ",sorted_weights$x[4],"\n")
cat("   ",batman_5NN_names[5]," with weight ",sorted_weights$x[5],"\n \n")

# Mission Impossible 
movie_name_misimp = "Mission: Impossible - Rogue Nation (2015)  "

misimp = which(nodes == movie_name_misimp) # find index for misimp node
misimp_comm = comm_struct$membership[misimp] # find belonging community
misimp_neighbors = as.vector(neighbors(g1_simple , misimp , mode = "all"))

# generate node pair list to get edge ids (N1,N2 , N1,N3 , ...)
misimp_nvec = numeric()
for( i in misimp_neighbors){
  misimp_nvec = c(misimp_nvec,misimp,i) 
}

misimp_edge_ids = get.edge.ids(g1_simple,misimp_nvec,directed = FALSE) # get all edges ids with misimp nodes
misimp_edge_weights = E(g1_simple , directed = FALSE)$weights[misimp_edge_ids] # get corresponding weights
sorted_weights = sort(misimp_edge_weights , decreasing = TRUE , index.return = TRUE)

# take first 5 sorted idx and convert back to movie name
misimp_5NN_idx = misimp_edge_ids[sorted_weights$ix[1:5]]
misimp_5NN_pairs = ends(g1_simple,misimp_5NN_idx) # outputs a matrix
misimp_5NN_names = misimp_5NN_pairs[which(misimp_5NN_pairs != movie_name_misimp)]

# Print statements
cat("\"",sub("\\s+$" , "", movie_name_misimp) , "\" is in community # ",misimp_comm ,
    " labeled with genre(s): " , tot_comm_genres[[misimp_comm,1]] , "\n \n")

cat("The 5 Nearest neightbors of \"",sub("\\s+$", "", movie_name_misimp), "\" are: \n")
cat("   ",misimp_5NN_names[1]," with weight ",sorted_weights$x[1],"\n")
cat("   ",misimp_5NN_names[2]," with weight ",sorted_weights$x[2],"\n")
cat("   ",misimp_5NN_names[3]," with weight ",sorted_weights$x[3],"\n")
cat("   ",misimp_5NN_names[4]," with weight ",sorted_weights$x[4],"\n")
cat("   ",misimp_5NN_names[5]," with weight ",sorted_weights$x[5],"\n \n")

#Minions

movie_name_minions = "Minions (2015)  "

minions = which(nodes == movie_name_minions) # find index for minions node
minions_comm = comm_struct$membership[minions] # find belonging community
minions_neighbors = as.vector(neighbors(g1_simple , minions , mode = "all"))

# generate node pair list to get edge ids (N1,N2 , N1,N3 , ...)
minions_nvec = numeric()
for( i in minions_neighbors){
  minions_nvec = c(minions_nvec,minions,i) 
}

minions_edge_ids = get.edge.ids(g1_simple,minions_nvec,directed = FALSE) # get all edges ids with minions nodes
minions_edge_weights = E(g1_simple , directed = FALSE)$weights[minions_edge_ids] # get corresponding weights
sorted_weights = sort(minions_edge_weights , decreasing = TRUE , index.return = TRUE)

# take first 5 sorted idx and convert back to movie name
minions_5NN_idx = minions_edge_ids[sorted_weights$ix[1:5]]
minions_5NN_pairs = ends(g1_simple,minions_5NN_idx) # outputs a matrix
minions_5NN_names = minions_5NN_pairs[which(minions_5NN_pairs != movie_name_minions)]

# Print statements
cat("\"",sub("\\s+$" , "", movie_name_minions) , "\" is in community # ",minions_comm ,
    " labeled with genre(s): " , tot_comm_genres[[minions_comm,1]] , "\n \n")

cat("The 5 Nearest neightbors of \"",sub("\\s+$", "", movie_name_misimp), "\" are: \n")
cat("   ",minions_5NN_names[1]," with weight ",sorted_weights$x[1],"\n")
cat("   ",minions_5NN_names[2]," with weight ",sorted_weights$x[2],"\n")
cat("   ",minions_5NN_names[3]," with weight ",sorted_weights$x[3],"\n")
cat("   ",minions_5NN_names[4]," with weight ",sorted_weights$x[4],"\n")
cat("   ",minions_5NN_names[5]," with weight ",sorted_weights$x[5],"\n \n")

############## Question 7 ##############
cat("\n \n ############## Question 7 ############## \n")

# read in movies & ratings  
movie_rating = read.delim("data_files/movie_rating.txt" ,header = FALSE,stringsAsFactors = FALSE)
movie_rating$V2 = NULL
colnames(movie_rating) = c("movie","rating")
rating_movie_list = as.vector(movie_rating$movie) # list of movies in movie_rating file
all_ratings = as.vector(movie_rating$rating) # list of ratings in movie_rating file (note: indicies correspond to rating_movie_list)
  
  #Batman
  # predict using average ratings of neighbors
batman_neighbors_names = nodes[batman_neighbors] # get all neighboring nodes names
batman_neigh_rating_idx = match(sub("\\s+$", "", batman_neighbors_names) , rating_movie_list , nomatch = 0) # compare titles to rating list
batman_neigh_rating_idx = batman_neigh_rating_idx[ which(batman_neigh_rating_idx != 0)] # remove zeros
batman_neigh_avg_rating = mean(all_ratings[batman_neigh_rating_idx]) # avg ratings
cat("Predicted rating for \"" , sub("\\s+$", "", movie_name_bat) , 
    "\"  using ratings of neighbors: " , batman_neigh_avg_rating ,"\n")

  # predict using average ratings of community
nodes_bat_comm = which(comm_struct$membership == batman_comm) # find all ndoes in the same community as batman 
batman_comm_names = nodes[nodes_bat_comm] # get all node names in the same community
batman_comm_rating_idx = match(sub("\\s+$", "", batman_comm_names) , rating_movie_list , nomatch = 0) # compare titles to rating list
batman_comm_rating_idx = batman_comm_rating_idx[ which(batman_comm_rating_idx != 0)] # remove zeros
batman_comm_avg_rating = mean(all_ratings[batman_comm_rating_idx]) # avg ratings
cat("Predicted rating for \"" , sub("\\s+$", "", movie_name_bat) 
    , "\"  using ratings of movies in the same community: " , batman_comm_avg_rating , "\n \n")

# Mission Impossible
# predict using average ratings of neighbors
misimp_neighbors_names = nodes[misimp_neighbors] # get all neighboring nodes names
misimp_neigh_rating_idx = match(sub("\\s+$", "", misimp_neighbors_names) , rating_movie_list , nomatch = 0) # compare titles to rating list
misimp_neigh_rating_idx = misimp_neigh_rating_idx[ which(misimp_neigh_rating_idx != 0)] # remove zeros
misimp_neigh_avg_rating = mean(all_ratings[misimp_neigh_rating_idx]) # avg ratings
cat("Predicted rating for \"" , sub("\\s+$", "", movie_name_misimp) , 
    "\"  using ratings of neighbors: " , misimp_neigh_avg_rating ,"\n")

# predict using average ratings of community
nodes_misimp_comm = which(comm_struct$membership == misimp_comm) # find all ndoes in the same community as batman 
misimp_comm_names = nodes[nodes_misimp_comm] # get all node names in the same community
misimp_comm_rating_idx = match(sub("\\s+$", "", misimp_comm_names) , rating_movie_list , nomatch = 0) # compare titles to rating list
misimp_comm_rating_idx = misimp_comm_rating_idx[ which(misimp_comm_rating_idx != 0)] # remove zeros
misimp_comm_avg_rating = mean(all_ratings[misimp_comm_rating_idx]) # avg ratings
cat("Predicted rating for \"" , sub("\\s+$", "", movie_name_misimp) 
    , "\"  using ratings of movies in the same community: " , misimp_comm_avg_rating , "\n \n")

# Minions
# predict using average ratings of neighbors
minions_neighbors_names = nodes[minions_neighbors] # get all neighboring nodes names
minions_neigh_rating_idx = match(sub("\\s+$", "", minions_neighbors_names) , rating_movie_list , nomatch = 0) # compare titles to rating list
minions_neigh_rating_idx = minions_neigh_rating_idx[ which(minions_neigh_rating_idx != 0)] # remove zeros
minions_neigh_avg_rating = mean(all_ratings[minions_neigh_rating_idx]) # avg ratings
cat("Predicted rating for \"" , sub("\\s+$", "", movie_name_minions) , 
    "\"  using ratings of neighbors: " , minions_neigh_avg_rating ,"\n")

# predict using average ratings of community
nodes_minions_comm = which(comm_struct$membership == minions_comm) # find all ndoes in the same community as batman 
minions_comm_names = nodes[nodes_minions_comm] # get all node names in the same community
minions_comm_rating_idx = match(sub("\\s+$", "", minions_comm_names) , rating_movie_list , nomatch = 0) # compare titles to rating list
minions_comm_rating_idx = minions_comm_rating_idx[ which(minions_comm_rating_idx != 0)] # remove zeros
minions_comm_avg_rating = mean(all_ratings[minions_comm_rating_idx]) # avg ratings
cat("Predicted rating for \"" , sub("\\s+$", "", movie_name_minions) 
    , "\"  using ratings of movies in the same community: " , minions_comm_avg_rating , "\n \n")
