# Commented out in order to not have to load .RData file 
# clearing workspace
closeAllConnections()
rm(list=ls())

library('igraph')

# Set to appropriate working director
setwd("~/Desktop/Project2/EE232E_Project2/project_2_data")

load("~/Desktop/Project2/EE232E_Project2/.RData")

write.csv(train_feature, file = "train_features.csv")
write.csv(test_feature, file = "test_features.csv")
