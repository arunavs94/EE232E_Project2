import pandas as pd
from sklearn import linear_model
from sklearn.model_selection import KFold, cross_val_score, train_test_split
from sklearn.metrics import mean_squared_error
import math

def main():

	filename_test = "data_files/test_features.csv"
	filename_train = "data_files/train_features.csv"

	# read data into dataframe
	train_pd = pd.read_csv(filename_train)
	test_pd = pd.read_csv(filename_test)

	# remove first column
	col_names = list(test_pd)
	test_pd = test_pd.drop(col_names[0],1)
	train_pd = train_pd.drop(col_names[0],1)

	# remove movies that have rating of 0
	train_pd = train_pd[train_pd['Rating'] > 0]

	# train linear regression model
	movie_names = train_pd.Movie
	cols_of_interest = ['PR1','PR2','PR3','PR4','PR5','Director']
	
	# Separate out target feature
	x_vals = train_pd[cols_of_interest]
	y_vals = train_pd.Rating
	
	lin = linear_model.LinearRegression()

	kf = KFold(n_splits = 10)

	sub_rmse = 0

	for train_index, test_index in kf.split(x_vals):
		X_train, X_test = x_vals.values[train_index], x_vals.values[test_index]
		y_train, y_test = y_vals.values[train_index], y_vals.values[test_index]

		lin.fit(X_train,y_train)

		y_pred = lin.predict(X_test)[0:len(y_test)]
		rmse = math.sqrt(mean_squared_error(y_test,y_pred))
		sub_rmse = rmse + sub_rmse

	avg_rmse = sub_rmse / kf.n_splits

	print "Training Avg RMSE:", avg_rmse

	# Test model
	x_real_vals = test_pd[cols_of_interest]
	x_real_test = x_real_vals.values[0:len(x_real_vals)]

	test_rating_predict = lin.predict(x_real_test)
	print test_pd
	print test_rating_predict


if __name__ == '__main__':
	main()