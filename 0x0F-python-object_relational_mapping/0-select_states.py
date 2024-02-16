#!/usr/bin/python3
"""listing the database hbtn_0e_0_usa states"""

if __name__ == '__main__':

    import MySQLdb
    import sys

    myDB = MySQLdb.connect(host='localhost', port=3306,
                         user=sys.argv[1], passwd=sys.argv[2], db=sys.argv[3])

    myCursor = myDB.cursor()
    myCursor.execute("SELECT * FROM states ORDER BY states.id ASC;")
    myRows = myCursor.fetchall()
    for r in myRows:
        print(r)
