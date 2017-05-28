import csv
import pandas as pd
from pprint import pprint
from collections import defaultdict

import math

def main():

	# Read from original files

	actors_filepath = "C:/Users/Steven/Desktop/EE232E_Project2/data_files/actor_movies.txt"
	actresses_filepath = "C:/Users/Steven/Desktop/EE232E_Project2/data_files/actress_movies.txt"


	with open(actors_filepath) as f:
	    reader_actors = csv.reader(f, delimiter="\t")
	    data_actors = list(reader_actors)

	with open(actresses_filepath) as f:
	    reader_actress = csv.reader(f, delimiter="\t")
	    data_actresses = list(reader_actress)

	actors = []
	actresses = []

	# Create list of all actors and actresses -> total_actors
	for idx, rows in enumerate(data_actors):
		# progress check
		print idx


		### To test #####
		if idx == 50000:
			break
		#################




		tmp = [item for item in rows if item != '']
		actors.append(tmp)


	for idx, rows in enumerate(data_actresses):
		# progress check
		print idx


		### To test #####
		if idx == 50000:
			break
		#################



		tmp = [item for item in rows if item != '']
		actresses.append(tmp)
	
	total_actors = actors + actresses

	print 'Creating dataframe....'

	# Put data into dataframe
	total_data = pd.DataFrame(total_actors)

	# create list for actors' names
	actors = total_data[0].tolist()

	# create dictionaries
	actors_movies = {}
	movies_actors = defaultdict(list)
	movies_actors_fin = defaultdict(list)
	actors_index = {}
	personal_actors = {}

	# create dict with actors as keys, and their movies as values | create dict with movies as keys and its actors as values | create dict with actors as key and index as value
	for row in total_data.iterrows():
		index, data = row
		# progress check
		print "Dictionary creation progress: ", (float(index))/(len(total_data))

		# put data of each row into a list
		tmp = data.tolist()
		tmp = [item for item in tmp if item is not None]

		# seperate out the movies and the corresponding actor
		tmpMovies = tmp[1:len(tmp)]
		actor = tmp[0]

		# organize data into dictionaries
		actors_movies[actor] = tmpMovies
		[movies_actors[movie].append(actor) for movie in tmpMovies]
		actors_index[actor] = index + 1
	
	# create list of movies (is unique)
	tot_movies = movies_actors.keys()

	# filter through the movies and only keep the ones with at least 5 actors (movies_actors_fin)
	counter = 0
	for key, val in movies_actors.iteritems():
		# progress check
		print "Core movie filter progress: ", (float(counter))/(len(movies_actors))

		if len(val) >= 5:
			movies_actors_fin[key] = val
		counter = counter + 1

	# generate list of movies with at least 5 actors
	core_movies = movies_actors_fin.keys()


	text_file = open("data_files/node_list4_snacktors.txt", "w")


	# Generate movie-subMovie pairs and weights, write to file
	for idx, movie in enumerate(core_movies): # [M1, M2, ... , MN] for N total movies
		# progress check
		print "Progress of Movie-SubMovie pair/weight .txt file: ", (float(idx))/(len(core_movies))

		match = defaultdict(float)

		personal_actors[movie] = len(movies_actors_fin[movie])

		for actor in movies_actors_fin[movie]: # [A1,A2, ... , AM] for M total actors in movie n

			for subMovie in actors_movies[actor]: # [sM1, sM2, ... , sMP] for P total movies for actor m
				
				personal_actors[subMovie] = len(movies_actors_fin[subMovie])
				pair = (movie,subMovie)
				alt_pair = (subMovie,movie)

				if alt_pair in match:
					continue

				if (movie != subMovie):
					match[pair] = match[pair] + 1


		for key_ in match.keys():

			movie_ = str(key_[0])
			subMovie_ = str(key_[1])

			weight = (match[key_]) / ( (personal_actors[movie_] + personal_actors[subMovie_]) - match[key_] )

			text_file.write("\"" + movie_ + "\"")
			text_file.write(',')
			text_file.write("\"" + subMovie_ + "\"")
			text_file.write(',')
			text_file.write(str(weight))
			text_file.write('\n')


	




if __name__ == '__main__':
	main()
