# EE232E Project 2 Question 7 
# use this code to check the number of common actors different movies have 

# clearing workspace
closeAllConnections()
rm(list=ls())

library('igraph')
library('readr')

mv_act = read.delim("data_files/core_movies_to_actors.txt",sep = ",",header=FALSE,stringsAsFactors = FALSE, col.names=paste("V", 1:350, sep="")) 
movie_names = as.vector(mv_act$V1)

movie_name_bat = "Batman v Superman: Dawn of Justice (2016)"
bat_actors = mv_act[which(movie_names == movie_name_bat),2:350]
bat_actors = bat_actors[which(bat_actors != "")]

movie_name_MI = "Mission: Impossible - Rogue Nation (2015)"
MI_actors = mv_act[which(movie_names == movie_name_MI),2:350]
MI_actors = MI_actors[which(MI_actors != "")]

movie_name_minions = "Minions (2015)"
minions_actors = mv_act[which(movie_names == movie_name_minions),2:350]
minions_actors = minions_actors[which(minions_actors != "")]

bat_neigh = c("Eloise (2015)", 
              "Love and Honor (2013)",
              "Man of Steel (2013)",
              "Grain (2015)",
              "Into the Storm (2014)")
MI_neigh = c("Fan (2015)",
             "Phantom (2015)",
             "Breaking the Bank (2014)",
             "Suffragette (2015)",
             "Now You See Me: The Second Act (2016)")
Minions_neigh = c("The Lorax (2012)",
                  "Inside Out (2015)",
                  "Up (2009)",
                  "Despicable Me 2 (2013)",
                  "Surf's Up (2007)")

num_bat_common = numeric()
for(i in bat_neigh){
  temp_actors = mv_act[which(movie_names == i),2:350]
  temp_actors = temp_actors[which(temp_actors != "")]
  
  common = match(temp_actors,bat_actors,nomatch = 0)
  common = common[which(common!= 0)]
  
  num_bat_common = c(num_bat_common,length(common))
}

num_MI_common = numeric()
for(i in MI_neigh){
  temp_actors = mv_act[which(movie_names == i),2:350]
  temp_actors = temp_actors[which(temp_actors != "")]
  
  common = match(temp_actors,MI_actors,nomatch = 0)
  common = common[which(common!= 0)]
  
  num_MI_common = c(num_MI_common,length(common))
}


num_minion_common = numeric()
for(i in Minions_neigh){
  temp_actors = mv_act[which(movie_names == i),2:350]
  temp_actors = temp_actors[which(temp_actors != "")]
  
  common = match(temp_actors,minions_actors,nomatch = 0)
  common = common[which(common!= 0)]
  
  num_minion_common = c(num_minion_common,length(common))
}
