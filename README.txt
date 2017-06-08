# EE232E Project 2

Arunav Singh (UID: 304 760 844)
Eric Goldfien (UID: 603 887 003)
Steven Leung (UID: 304 777 142)

########################################################
This Project was programmed in R v3.3.0 with iGraph v1.0.1


Files requred to run for each question 

* Question 1: Files needed : Q1.py - combines both actor/actress files and filters out actors with < 5 or 10 movies. Create .csv file of dictionary to be readin Q2.py

* Question 2: Files needed : Q2.py - generates edge/weigth list .txt file for the actors w/ > 5 and 10 movies
			     Q2_3.py - Creates the actors w/ > 5 and 10 movies graph from .txt file from Q2.py

* Question 3: Files needed : Q2_3.py - compuetes page rank for each actor/actress and returns the top 10 actors and their page ranks

* Question 4: Files needed : Q4.py - Create edge/weight list .txt file of movies network to be read into R to create graph
			     Q4_5_6_7.R - Creates graph from .txt file generated from Q4.py

* Question 5: Files needed : Q4_5_6_7.R - Run Fast Greedy and tag communities

* Question 6: Files needed : Q4_5_6_7.R - find 5NN of each movie of interest and determine the community each blongs to

* Question 7: Files needed : Q4_5_6_7.R - predict movie rating basedon neighbors and community
			     Q7_check_common_actor.R - run after Q4_5_6_7.R to check the number of common movies in the KNN 

* Question 8: Files needed : Q8.R - Q8.R compuetes all features for all movies in the network and stores it as a train and test matrix
			     Q8_featureWriteOut.R - converts train and test matrix to a csv to be able to be read into python
			     Q8_regression.py - Performs training of a linear regression and testing on the 3 movies. 
							Outputs training error and rating predictions for the 3 movies.

* Question 9: File needed : Q9.py - This will output a prediction for the tree movies from the bipartite graph. 