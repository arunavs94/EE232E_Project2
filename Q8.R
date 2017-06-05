# EE232E Project 2 Question 8

# clearing workspace
closeAllConnections()
rm(list=ls())

library('igraph')
library('readr')

############## Question 8 ##############
cat("\n \n ############## Question 8 ############## \n")

load("saved_var/page_rank") #saved from Q2_3 (variable name is page_rank)
page_rank_names = names(page_rank)

# movies to directors data.frame
mv_dir = read.delim("data_files/movie_director_pair_list.txt",sep = ",",header=FALSE,stringsAsFactors = FALSE) 
full_dir_list = as.vector(mv_dir$V2)


# movie_actors # as a string
mv_act = read.delim("data_files/core_movies_to_actors.txt",sep = ",",header=FALSE,stringsAsFactors = FALSE, col.names=paste("V", 1:350, sep="")) 
movie_names = as.vector(mv_act$V1)
num_movies = length(movie_names)


# intiate features matrix
feature_mat = matrix(data = NA, nrow = num_movies,ncol = 8)
colnames(feature_mat) = c('Movie','PR1','PR2','PR3','PR4','PR5','Director','Rating')

# get top 100 rated movies
movie_rating = read.delim("data_files/movie_rating.txt" ,header = FALSE,stringsAsFactors = FALSE)
movie_rating$V2 = NULL
colnames(movie_rating) = c("movie","rating")
rating_movie_list = as.vector(movie_rating$movie) # list of movies in movie_rating file
all_ratings = as.vector(movie_rating$rating) # list of ratings in movie_rating file (note: indicies correspond to rating_movie_list)
sorted_ratings = sort(all_ratings,decreasing = TRUE,index.return = TRUE) # sort all movie ratings
sorted_movies = rating_movie_list[sorted_ratings$ix] #sorted_movies

# get names of top 100 directors
top_idx = match(sorted_movies,as.vector(mv_dir$V1),nomatch = 0)
top_directors = full_dir_list[top_idx[which(top_idx != 0)]] # sort all directors that we have
top_100_directors = top_directors[1:100] # take top 100 of directors we have


for( i in 1:num_movies){
  
  cat('Processing Movie', i , 'of' , num_movies,'\n')
  
  # Movie name
  temp_mv = movie_names[i] # name of i^th movie
    feature_mat[i,1] = temp_mv # add movie name to matrix
  
  mv_act_row = as.vector(t(mv_act[i,]))
  temp_num_act = length(which(mv_act_row != ""))
  temp_mv_actors = mv_act_row[2:temp_num_act] # all actors in i^th movie
  actor_pr = match(temp_mv_actors, page_rank_names, nomatch = 0 ) # search for match in page rank names
  actor_pr = actor_pr[ which(actor_pr != 0)] # remove non_matches
  
  # Page Ranks
  sorted_actor_pr = sort(page_rank[actor_pr],decreasing = TRUE)
  sorted_actor_pr = c(sorted_actor_pr,0,0,0,0,0) # concat 5 zeros to ensure there are 5 page_ranks
    feature_mat[i,2] = round(sorted_actor_pr[[1]],6) # add top 5 page ranks to matrix
    feature_mat[i,3] = round(sorted_actor_pr[[2]],6)
    feature_mat[i,4] = round(sorted_actor_pr[[3]],6)
    feature_mat[i,5] = round(sorted_actor_pr[[4]],6)
    feature_mat[i,6] = round(sorted_actor_pr[[5]],6)
  
  # Director
  
  full_dir_idx = which(temp_mv == as.vector(mv_dir$V1))
  # cat(full_dir_idx, '\n')
  director = full_dir_list[full_dir_idx]
  dir_100_idx = which(director == top_100_directors)
  if(length(dir_100_idx) == 0) {dir_100_idx = 0} # if director not in top 100 directors set value to 0
    feature_mat[i,7] = max(dir_100_idx) # add top director to matrix
    
  # Rating (Ground Truth)
  mv_rating = all_ratings[which(temp_mv == rating_movie_list)] # find movie rating from rating.txt file
  if(length(mv_rating) == 0) {mv_rating = 0} # set rating to zero if could not find movie in rating.txt file
    feature_mat[i,8] = mv_rating # add top rating to matrix
}

# find indicies in matrix for 3 test movies
batman_idx = which("Batman v Superman: Dawn of Justice (2016)" == feature_mat[,1])
mission_idx = which("Mission: Impossible - Rogue Nation (2015)" == feature_mat[,1])
minion_idx = which("Minions (2015)" == feature_mat[,1])

test_feature = rbind(feature_mat[batman_idx,],feature_mat[mission_idx,],feature_mat[minion_idx,]) # test feature matrix

del_idx = c(-1*batman_idx,-1*mission_idx,-1*minion_idx) #delete test movies(rows) from train matrix
train_feature = feature_mat[del_idx,] # train feature matrix with labels

save(train_feature,test_feature,file="test") # save train/test_feature to be exported to python to perform regression model

