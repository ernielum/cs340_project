import MySQLdb
import os
from dotenv import load_dotenv, find_dotenv

# Load the .env file into the environment variables
load_dotenv()

# Set the variables in our app to the already set environment variables
host = os.environ.get("340DBHOST")
user = os.environ.get("340DBUSER")
passwd = os.environ.get("340DBPW")
db = os.environ.get("340DB")

def connect_to_database(host = host, user = user, passwd = passwd, db = db):
    db_connection = MySQLdb.connect(host, user, passwd, db)
    return db_connection

def execute_query(db_connection = None, query = None, query_params = ()):
    if db_connection is None:
        print("No connection to database found! Try calling connect_to_database() first")
        return None
    if query is None or len(query.strip()) == 0:
        print("Query is empty. Please pass a SQL query in query")
        return None
    
    print("Executing %s with %s" % (query, query_params));

    cursor = db_connection.cursor(MySQLdb.cursors.DictCursor)

    params = tuple()
    for q in query_params:
        params = params + (q)

    cursor.execute(query, query_params)

    db_connection.commit();
    return cursor

if __name__ == 'main':
    print("Executing a sample query on the database using credentials from db_credentials.py")
    db = connect_to_database()
    query = "SELECT * from Patients;"
    results = execute_query(db, query);
    print("Printing results of %s" % query)

    for r in results.fetchall():
        print(r)
