import csv
import pandas as pd
from pprint import pprint
from collections import defaultdict
import xlsxwriter
import math

def main():

	# .txt file generated from previous part
	filename = "tot_actors_fixed.csv"

	# read data into dataframe
	total_data = pd.read_csv(filename, header=None)

	## Test to see how data is read in
	# print total_data
	# return 0
	########

	# create list for actors' names
	actors = total_data[0].tolist()

	actors_movies = {}
	movies_actors = defaultdict(list)
	actors_index = {}

	# create dict with actors as keys, and their movies as values | create dict with movies as keys and its actors as values | create dict with actors as key and index as value
	for row in total_data.iterrows():
		index, data = row
		print index

		# put data of each row into a list
		tmp = data.tolist()
		tmp = [item for item in tmp if type(item) != float]

		# seperate out the movies and the corresponding actor
		tmpMovies = tmp[1:len(tmp)]
		actor = tmp[0]

		# organize data into dictionaries
		actors_movies[actor] = tmpMovies
		[movies_actors[movie].append(actor) for movie in tmpMovies]
		actors_index[actor] = index + 1

		## Test
		# if index == 10000:
		# 	break

	# should pickle the above result....

	text_file = open("node_list2.txt", "w")

	# can make these all into list comps to fun faster

	# Generating weights between actors and writing out to file
	for idx, actor in enumerate(actors): # [A1,A2,...,AM] for M total actors
		print idx

		# # Test
		# if idx == 10001:
		# 	break

		match = defaultdict(float)
		personalMovies = len(actors_movies[actor])

		for movie in actors_movies[actor]: # [M1,M2,...,MN] for N total movies for actor m

			for subActor in movies_actors[movie]: # [sA1,sA2,...sAP] for P total actors in movie n
				pair = (actor,subActor)

				if actor != subActor:
					match[pair] = match[pair] + 1
		

		# write out to a .txt file
		for key, val in match.iteritems():

			actor_ = str(key[0])
			subActor_ = str(key[1])


			text_file.write("\"" + actor_ + "\"")
			text_file.write(',')
			text_file.write("\"" + subActor_ + "\"")
			text_file.write(',')
			text_file.write(str(val/personalMovies))
			text_file.write('\n')


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

	# workbook = xlsxwriter.Workbook('test_list.xlsx')
	# worksheet = workbook.add_worksheet()

	# col = 0
	# row = 0

	# # write actor (with name)
	# worksheet.write(row,col,key[0])

	# # write subActor (with name)
	# worksheet.write(row,col+1,key[1])

	# # write actor (with index)
	# worksheet.write(row,col,actors_index[key[0]])

	# # write subActor (with index)
	# worksheet.write(row,col+1,actors_index[key[1]])

	# # write out to excel sheet
		# for key, val in match.iteritems():

		# 	# write actor (with name)
		# 	worksheet.write(row,col,key[0])

		# 	# write subActor (with name)
		# 	worksheet.write(row,col+1,key[1])

		# 	# write weight
		# 	worksheet.write(row,col+2,val/personalMovies)

		# 	row = row + 1
	########################

if __name__ == '__main__':
	main()

