#!/usr/bin/python3
"""printing the database hbtn_0e_6_usa first State object"""

if __name__ == "__main__":

    import sys
    from model_state import Base, State
    from sqlalchemy import create_engine
    from sqlalchemy.orm import Session

    myEng = create_engine('mysql+mysqldb://{}:{}@localhost/{}'
                          .format(sys.argv[1], sys.argv[2], sys.argv[3]),
                          pool_pre_ping=True)
    Base.metadata.create_all(myEng)

    mySession = Session(myEng)
    one = mySession.query(State).order_by(State.id).first()
    if one:
        print("{}: {}".format(one.id, one.name))
    else:
        print("Nothing")
    mySession.close()
