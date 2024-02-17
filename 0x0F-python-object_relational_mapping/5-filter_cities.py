#!/usr/bin/python3
"""taking in the name of a state as an argument and
listing all state cities, using hbtn_0e_4_usa"""

if __name__ == '__main__':

    import MySQLdb
    import sys

    myDB = MySQLdb.connect(
        host='localhost', port=3306, user=sys.argv[1],
        passwd=sys.argv[2], db=sys.argv[3])
    myCursor = myDB.cursor()
    myCursor.execute("SELECT cities.name\
                FROM cities LEFT JOIN states\
                ON states.id = cities.state_id\
                WHERE states.name = %s\
                ORDER BY cities.id ASC", (sys.argv[4],))
    myRows = myCursor.fetchall()
    print(", ".join([r[0] for r in myRows]))
    myCursor.close()
    myDB.close()
