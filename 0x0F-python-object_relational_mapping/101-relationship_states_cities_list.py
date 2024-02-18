#!/usr/bin/python3
"""listing all State objects and its City objects in hbtn_0e_101_usa"""

if __name__ == "__main__":

    import sys
    from relationship_state import Base, State
    from relationship_city import City
    from sqlalchemy import create_engine
    from sqlalchemy.orm import Session
    from sqlalchemy.schema import Table

    myEng = create_engine('mysql+mysqldb://{}:{}@localhost/{}'
                           .format(sys.argv[1], sys.argv[2],
                                   sys.argv[3]), pool_pre_ping=True)
    Base.metadata.create_all(myEng)

    mySess = Session(myEng)
    for s in mySess.query(State).order_by(State.id).all():
        print("{}: {}".format(s.id, s.name))
        for c in s.cities:
            print("    {}: {}".format(c.id, c.name))
    mySess.close()
