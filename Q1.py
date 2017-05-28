import pandas
import numpy as np
import csv
from pprint import pprint

def main():

	actors_filepath = "/Users/Arunav/Desktop/Project2/EE232E_Project2/project_2_data/actor_movies.txt"
	actresses_filepath = "/Users/Arunav/Desktop/Project2/EE232E_Project2/project_2_data/actress_movies.txt"


	with open(actors_filepath) as f:
	    reader_actors = csv.reader(f, delimiter="\t")
	    data_actors = list(reader_actors)

	with open(actresses_filepath) as f:
	    reader_actress = csv.reader(f, delimiter="\t")
	    data_actresses = list(reader_actress)

	actors = []
	actresses = []

	for idx, rows in enumerate(data_actors):
		# progress check
		print idx

		tmp = [item for item in rows if item != '']
		numMovies = len(tmp) - 1 

		if numMovies >= 5:
			actors.append(tmp)

	for idx, rows in enumerate(data_actresses):
		# progress check
		print idx

		tmp = [item for item in rows if item != '']
		numMovies = len(tmp) - 1 

		if numMovies >= 5:
			actresses.append(tmp)

	with open("total_snacktors.csv", "wb") as f:
	    writer = csv.writer(f)
	    writer.writerows(actors)
	    writer.writerows(actresses)






if __name__ == '__main__':
	main()