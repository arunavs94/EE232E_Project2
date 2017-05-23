import csv
import pandas
from pprint import pprint
from collections import defaultdict
import xlsxwriter
import math

def main():

	# .txt file generated from previous part
	filename = "total_actors.txt"

	# read data into dataframe
	total_data = pandas.read_csv(filename)

	# create list for actors' names
	actors = total_data["V1"].tolist()

	print len(actors)

	actors_movies = {}
	movies_actors = defaultdict(list)

	# create dict with actors as keys, and their movies as values | create dict with movies as keys and its actors as values
	for row in total_data.iterrows():
		index, data = row
		print index

		# put data of each row into a list
		tmp = data.tolist()
		tmp = [item for item in tmp if type(item) != float]

		# seperate out the movies and the corresponding actor
		tmpMovies = tmp[2:len(tmp)]
		actor = tmp[1]

		# organize data into dictionaries
		actors_movies[actor] = tmpMovies
		[movies_actors[movie].append(actor) for movie in tmpMovies]

		## Test
		# if index == 10000:
		# 	break

	# should pickle the above result....

	workbook = xlsxwriter.Workbook('node_list.xlsx')
	worksheet = workbook.add_worksheet()

	col = 0
	row = 0

	# can make these all into list comps to fun faster

	# Generating weights between actors and writing out to file
	for idx, actor in enumerate(actors): # [A1,A2,...,AM] for M total actors
		print idx

		## Test
		# if idx == 10001:
		# 	break

		match = defaultdict(float)
		personalMovies = len(actors_movies[actor])

		for movie in actors_movies[actor]: # [M1,M2,...,MN] for N total movies for actor m

			for subActor in movies_actors[movie]: # [sA1,sA2,...sAP] for P total actors in movie n
				pair = (actor,subActor)

				if actor != subActor:
					match[pair] = match[pair] + 1
		

		# write out to excel sheet
		for key, val in match.iteritems():
			worksheet.write(row,col,key[0])
			worksheet.write(row,col+1,key[1])
			worksheet.write(row,col+2,val/personalMovies)
			row = row + 1



	###### GRAVEYARD ######
	# # create list for all movies
	# tmp_mov1 = total_data["V3"].tolist()
	# tmp_mov2 = total_data["V5"].tolist()
	# tmp_mov3 = total_data["V7"].tolist()
	# tmp_mov4 = total_data["V9"].tolist()
	# tmp_mov5 = total_data["V11"].tolist()
	# tmp_mov6 = total_data["V13"].tolist()
	# tmp_mov7 = total_data["V15"].tolist()
	
	# # master list of movies (with repeats)
	# movies = tmp_mov1 + tmp_mov2 + tmp_mov3 + tmp_mov4 + tmp_mov5 + tmp_mov6 + tmp_mov7

	# # filter out NaN's
	# movies = [item for item in movies if type(item) != float]

	# # create a unique list of movies
	# movies = set(movies)
	# movies = list(movies)
	########################

if __name__ == '__main__':
	main()

