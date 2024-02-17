#!/usr/bin/python3
"""adding the “Louisiana” State object to hbtn_0e_6_usa"""

if __name__ == "__main__":

    import sys
    from model_state import Base, State
    from sqlalchemy import create_engine
    from sqlalchemy.orm import Session

    myEng = create_engine('mysql+mysqldb://{}:{}@localhost/{}'
                          .format(sys.argv[1], sys.argv[2], sys.argv[3]),
                          pool_pre_ping=True)
    Base.metadata.create_all(myEng)

    mySess = Session(myEng)
    myState = mySess.query(State).filter(State.name == sys.argv[4]).first()
    if myState:
        print("{}".format(myState.id))
    else:
        print("Not found")
    mySess.close()
