# EE232E Project 2 Question 9

# clearing workspace
closeAllConnections()
rm(list=ls())

library('igraph')
library('readr')


# movie_actors # as a string
mv_act = read.delim("data_files/core_movies_to_actors.txt",sep = ",",header=FALSE,stringsAsFactors = FALSE, col.names=paste("V", 1:350, sep="")) 
movie_names = as.vector(mv_act$V1)
num_movies = length(movie_names)

nodesSet1 = movie_names
e_movie = character()
e_actor = character()

for (i in 1:num_movies){
  
  cat('Processing movie', i , 'of', num_movies, '\n')
  
  mv_act_row = as.vector(t(mv_act[i,]))
  temp_num_act = length(which(mv_act_row != ""))
  temp_mv_actors = mv_act_row[2:temp_num_act] # all actors in i^th movie
  
  e_movie = c(e_movie , rep(mv_act[i,1],length(temp_mv_actors)) )
  e_actor = c(e_actor , temp_mv_actors )
}

nodesSet2 = unique(e_actor)
edgeList = data.frame(S1 = e_movie, S2 = e_actor,stringsAsFactors = FALSE)

g <- graph.empty(directed = FALSE)
g <- add.vertices(g,nv=length(nodesSet1),attr=list(name = nodesSet1,
                                                   type=rep(TRUE,length(nodesSet1))))
g <- add.vertices(g,nv=length(nodesSet2),attr=list(name = nodesSet2,
                                                   type=rep(FALSE,length(nodesSet2))))


edgeListVec <- as.vector(t(as.matrix(data.frame(S1=edgeList$S1,
                                                S2=edgeList$S2) )) )
g = add.edges(g,edgeListVec)

is.bipartite(g) # check if bipartite

# let's plot it !
plot.igraph(g, layout=layout.bipartite,
            vertex.color=c("orange","green")[V(g)$type+1])

# Movie ratings
movie_rating = read.delim("data_files/movie_rating.txt" ,header = FALSE,stringsAsFactors = FALSE)
movie_rating$V2 = NULL
colnames(movie_rating) = c("movie","rating")
rating_movie_list = as.vector(movie_rating$movie) # list of movies in movie_rating file
all_ratings = as.vector(movie_rating$rating) # list of ratings in movie_rating file (note: indicies correspond to rating_movie_list)

nodes = V(g)$name
unique_act = unique(e_actor) # find all unique actors 
count = 1
act_score_mat = matrix(data = NA, nrow = length(unique_act),ncol = 2) #create matrix to store data

# Find actor scores
for ( i in unique_act){
  cat('Processing actor', count, 'of', length(unique_act), '\n')
  
  neigh = neighbors(g,i,mode = "all") # find all neighbors (i.e. movies)
  rating_idx = match(nodes[as.vector(neigh)],rating_movie_list,nomatch = 0) # check which movies we have ratings for
  
  # store variables to matrix
  act_score_mat[count,1] = i
  act_score_mat[count,2] = mean(na.omit(all_ratings[rating_idx]))
  
  count = count+1 #increment row count
}
p=na.omit(as.numeric(act_score_mat[,2]))
hist( x= p, breaks = seq(from = min(p), to = max(p), by = (max(p)-min(p))/50), 
      main = "Histogram of Actor Scores", xlab = "Actor Score", ylab = "Frequency")

save(act_score_mat,file= "actor_scoreQ8")

batman = "Batman v Superman: Dawn of Justice (2016)"
mission = "Mission: Impossible - Rogue Nation (2015)"
minion = "Minions (2015)"

for(i in c(batman,mission,minion)){
  
  mv_act_row = as.vector(t(mv_act[which(i==movie_names),]))
  temp_num_act = length(which(mv_act_row != ""))
  temp_mv_actors = mv_act_row[2:temp_num_act] # all actors in i^th movie
  
  temp_act_idx = match(temp_mv_actors,act_score_mat[,1],nomatch = 0)
  temp_act_idx = temp_act_idx[which(temp_act_idx!=0)]
  
  temp_act_score = act_score_mat[temp_act_idx,2]
  scores = sort(na.omit(as.numeric(temp_act_score)),decreasing=TRUE)
  movie_score = mean(scores) # avg score of all actors is movie rating
  
  cat(i,'has predicted rating of' ,movie_score ,'using bipartite graph \n')
  
}
  
  