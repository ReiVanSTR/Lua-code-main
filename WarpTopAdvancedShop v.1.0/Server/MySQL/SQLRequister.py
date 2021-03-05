import sys

class SQLRequister(object):
	"""docstring for SQLRequister"""
	def __init__(self, mysql):
		super(SQLRequister, self).__init__()
		self.mysql = mysql
		self.commit = mysql.connection.commit()
	def getUser(self, userNick=str):
	    try:
	        cursor = self.mysql.connect.cursor()
	        args = userNick
	        query = "SELECT * FROM users WHERE user = ?"
	        cursor.execute(query, args)
	        rows = cursor.fetchall()
	    except:
	       return "Error"
	    finally:
	       cursor.close()
	       return rows

	# def updateUser(self, userNick, delta)
	# 	try:
	#         self.connection = MySQLConnection(**self.db)
	#         self.cursor = self.connection.cursor()
	#         self.args = userNick
	#         self.query = "SELECT * FROM users WHERE nick = '{}'".format(self.args)
	#         self.cursor.execute(self.query, self.args)
	#         self.rows = self.cursor.fetchall()
	#         print('Total Row(s):', self.cursor.rowcount)
	#         self.ans = []
	#         for self.row in self.rows:
	#             self.ans.append(self.row)
	#     except Error as e:
	#        print(e)
	#     finally:
	#        self.cursor.close()
	#        self.connection.close()
	#        return self.ans
