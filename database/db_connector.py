import MySQLdb
import os

def connect_to_database(host='classmysql.engr.oregonstate.edu', user='cs340_leeje7', passwd='8989', db='cs340_leeje7'):
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
