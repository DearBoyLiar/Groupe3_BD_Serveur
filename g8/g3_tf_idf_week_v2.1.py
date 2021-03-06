# -*- coding: utf-8 -*-
"""
Created on Mon Jan 15 08:57:58 2018

@author: laura
"""

"""
g1
@Author : F.C
g3 
@Author : L.B. M.I. A.H. C.G.
g8
@Author : F.R.
"""
import MySQLdb
from datetime import datetime, timedelta
import timestring
from flask import Flask, request, jsonify
import json
import requests
from flask_restful import Resource, Api
import mysql.connector
from flask_mysqldb import MySQL


app = Flask(__name__) # we are using this variable to use the flask
					   # microframework

api = Api(app)


# MySQL configurations
servername = "localhost"
username = "root"
passwordDB = ""
databasename = "bdd_test"
db = MySQLdb.connect(user = username, passwd = passwordDB, 
	host = servername, db = databasename)

@app.route("/link_by_source/", methods = ['GET', 'POST', 'PATCH', 'PUT', 'DELETE'])    

def exec_query(query) :
	"""
	input : query
	output : result of the query
	this function execute the query from the data base
	"""
	cursor = db.cursor()
	cursor.execute(query)
	result = cursor.fetchall()
	cursor.close()
	return result

def api_link_by_source():
	"""
	input : /
	output : json data
	this function returns a json data formated the way Stats wanted it
	"""
	week = {}
	list_word  = []

	date_min = """SELECT MIN(date_publication) FROM mv_tf_idf_week"""
	date_max = """SELECT MAX(date_publication) FROM mv_tf_idf_week"""
	date_min_res = exec_query (date_min)
	date_max_res = exec_query (date_max)
	date_max_res = str(date_max_res[0][0])
	date_min_res = str(date_min_res[0][0])

	week["Period"] = date_min_res + " - " + date_max_res
	id_words = """SELECT DISTINCT id_word FROM mv_tf_idf_week WHERE 
	date_publication BETWEEN %s and %s ORDER BY id_word
	""" % ("'" + date_min_res + "'", "'" + date_max_res + "'" )
	id_words_res = exec_query (id_words)
	for i in range(0, len(id_words_res)):
		list_word.append(id_words_res[i][0])
		

	for word in range(0, len(list_word)):
		week_words_tf_idf =[]
		week_words_tf = []
		list_week = []
		for day in range(7):
			day_query = datetime.strptime(date_min_res, "%Y-%m-%d") \
			+ timedelta(days=day)
			list_article = []
			id_article = """SELECT id_article FROM mv_tf_idf_week WHERE 
			date_publication = %s AND id_word = %s ORDER BY id_article
			""" % ("'" +  str(day_query) + "'", list_word[word])
			id_article_res = exec_query (id_article)
			list_tf_idf = []
			list_tf = []
			for article in range(0, len(id_article_res)):
				list_article.append(id_article_res[article][0])
				q_tf_idf = """SELECT tf_idf FROM mv_tf_idf_week WHERE 
				id_word = %s AND id_article = %s AND date_publication = %s 
				""" % (list_word[word], list_article[article], "'" 
				+  str(day_query) + "'")
				tf_idf_res = exec_query (q_tf_idf)
				tf = []
				tf_idf = []
				for j in range(0, len(tf_idf_res)):
					tf_idf.append(tf_idf_res[j][0])
				list_tf_idf.append(tf_idf[0])
				q_tf = """SELECT tf FROM mv_tf_idf_week WHERE 
				id_word = %s AND id_article = %s AND date_publication = %s 
				""" % (list_word[word], list_article[article], "'" 
				+  str(day_query) + "'")
				tf_res = exec_query (q_tf)
				for k in range(0, len(tf_res)):
					tf.append(tf_res[k][0])
				list_tf.append(tf[0])
			week_words_tf_idf.append(list_tf_idf)
			list_week.append(list_article)
			week_words_tf.append(list_tf)
		week[str(list_word[word])+"_tf_idf"] = week_words_tf_idf
		week[str(list_word[word])+"_tf"] = week_words_tf
	json = jsonify(week)
	return json