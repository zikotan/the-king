#!/usr/bin/python3
"""changing the hbtn_0e_6_usa State object name"""

if __name__ == "__main__":

    import sys
    from model_state import Base, State
    from sqlalchemy import create_engine
    from sqlalchemy.orm import Session
    from sqlalchemy.schema import Table

    myEng = create_engine('mysql+mysqldb://{}:{}@localhost/{}'
                          .format(sys.argv[1], sys.argv[2], sys.argv[3]),
                          pool_pre_ping=True)
    Base.metadata.create_all(myEng)

    mySess = Session(myEng)
    myState = mySess.query(State).filter(State.id == 2).first()
    myState.name = 'New Mexico'
    mySess.commit()
    mySess.close()
