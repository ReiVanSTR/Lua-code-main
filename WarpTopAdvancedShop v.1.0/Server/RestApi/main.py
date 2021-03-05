import flask
from flask import request, jsonify
import sqlite3
from SQLighter import SQLighter

app = flask.Flask(__name__)
app.config["DEBUG"] = True
data = SQLighter("hui.db")
connection = sqlite3.connect('hui.db')
cursor = connection.cursor()
print(data.get_user('OB1CHAM'))
print(cursor.execute("SELECT * FROM users").fetchall())
cursor.execute("DROP TABLE users")
cursor.execute("""CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT,user text NOT NULL, money integer NOT NULL default 0, status integer NOT NULL default 0)""")
connection.commit()
cursor.execute("INSERT INTO users (user) VALUES ('OB1CHAM')")
connection.commit()
cursor.execute("""CREATE TABLE IF NOT EXISTS articles (id INTEGER PRIMARY KEY AUTOINCREMENT,mod text NOT NULL, data text NOT NULL)""")
req=cursor.execute("SELECT money FROM users WHERE user = 'ReiVanSTR'").fetchall()
print(req = req[0][0]+=1)
connection.commit()
print(cursor.execute("SELECT * FROM users WHERE user = 'black_vizor'").fetchall())
print(data.get_user('ReiVanSTR'))
user='black_vizor'
query="SELECT money FROM users WHERE user = 'black_vizor'"
response = cursor.execute(query).fetchall()[0][0]+10
query = "UPDATE users SET money = ? WHERE user = ?"
cursor.execute(query,(response,user))
connection.commit()
@app.route('/user/getUser')
def get_user():
    if 'user' in request.args:
        user=str(request.args['user'])
        return jsonify(data.get_user(user))
    else:
        return 'Unexpected user'

@app.route('/user/updateMoney')
def set_money():
    if 'user' and 'delta' in request.args:
        user=str(request.args['user'])
        delta=int(request.args['delta'])
    else:
        return "Not all variables"
    return jsonify(data.update_user_money(user, delta))

# @app.route('/terminal/loadArticle')
# def put_article():
