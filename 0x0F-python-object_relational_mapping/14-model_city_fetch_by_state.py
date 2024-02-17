#!/usr/bin/python3
"""printing all hbtn_0e_14_usa City objects"""

if __name__ == "__main__":

    import sys
    from model_state import Base, State
    from model_city import City
    from sqlalchemy import create_engine
    from sqlalchemy.orm import Session
    from sqlalchemy.schema import Table

    myEng = create_engine('mysql+mysqldb://{}:{}@localhost/{}'
                           .format(sys.argv[1], sys.argv[2],
                                   sys.argv[3]), pool_pre_ping=True)
    Base.metadata.create_all(myEng)

    mySess = Session(myEng)
    for s, c in mySess.query(State, City)\
        .filter(City.state_id == State.id).order_by(City.id).all():
            print("{}: ({}) {}".format(s.name, c.id, c.name))
    mySess.close()
