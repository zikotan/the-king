#!/usr/bin/python3
"""taking in an argument and displays all values in the
hbtn_0e_0_usa states where name matches the argument
and is safe from SQL injections"""

if __name__ == '__main__':

    import MySQLdb
    import sys

    myDB = MySQLdb.connect(
        host='localhost', port=3306, user=sys.argv[1],
        passwd=sys.argv[2], db=sys.argv[3])

    myCursor = myDB.cursor()
    myCursor.execute("SELECT * FROM states WHERE name=%s\
                ORDER BY states.id ASC", (sys.argv[4],))
    myRows = myCursor.fetchall()
    for r in myRows:
        print(r)
