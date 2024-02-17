#!/usr/bin/python3
"""listing hbtn_0e_4_usa all cities"""

if __name__ == '__main__':

    import MySQLdb
    import sys

    myDB = MySQLdb.connect(
        host='localhost', port=3306, user=sys.argv[1],
        passwd=sys.argv[2], db=sys.argv[3])
    myCursor = myDB.cursor()
    myCursor.execute("SELECT cities.id, cities.name, states.name\
                FROM cities LEFT JOIN states\
                ON states.id = cities.state_id\
                ORDER BY cities.id ASC")
    myRows = myCursor.fetchall()
    for r in myRows:
        print(r)
