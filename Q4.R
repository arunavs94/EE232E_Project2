# EE232E Project 2 Question 4

# clearing workspace
closeAllConnections()
rm(list=ls())

library('igraph')
library('readr')


# read in movies  col_names = paste0("V",seq_len(3)), delim = "\t",quote = "\"",)
movie_genre = read.delim("data_files/movie_genre.txt" ,header = FALSE,stringsAsFactors = FALSE)
movie_genre$V2 = NULL
colnames(movie_genre) = c("movie","genre")
movies = as.vector(movie_genre$movie)

genre_master = as.vector(unique(movie_genre$genre)) #create vector mapping genre to a specific index


Graph.data = read.delim("data_files/node_list4_smovies.txt",sep = ",",header=FALSE,stringsAsFactors = FALSE)
colnames(Graph.data) = c("Node 1", "Node 2", "weights")
g1 = graph.data.frame(Graph.data,directed = FALSE)

g1_simple = simplify(g1,remove.loops = FALSE,edge.attr.comb = "first") #remove multiple edges
comm_struct = fastgreedy.community(g1_simple, weights = E(g1_simple)$weights)

memberships = comm_struct$membership # 35213 nodes
num_coms = length(unique(memberships)) # 297
nodes = V(g1_simple) # all nodes in the graph

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
  cat('     Community', i, 'genres: ',comm_20_genres,'\n')
    
}

  
