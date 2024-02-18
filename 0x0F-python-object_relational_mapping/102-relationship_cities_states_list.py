#!/usr/bin/python3
"""listing all hbtn_0e_101_usa City objects"""

if __name__ == "__main__":

    import sys
    from relationship_state import Base, State
    from relationship_city import City
    from sqlalchemy import create_engine
    from sqlalchemy.orm import Session
    from sqlalchemy.schema import Table

    myEng = create_engine('mysql+mysqldb://{}:{}@localhost/{}'
                          .format(sys.argv[1], sys.argv[2], sys.argv[3]),
                          pool_pre_ping=True)
    Base.metadata.create_all(myEng)

    mysess = Session(myEng)
    for s in mysess.query(City).order_by(City.id).all():
        print("{}: {} -> {}".format(s.id, s.name, s.state.name))
    mysess.close()
