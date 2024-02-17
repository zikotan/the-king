#!/usr/bin/python3
"""adding the “Louisiana” State object to hbtn_0e_6_usa"""

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
    myNew = State(name='Louisiana')
    mySess.add(myNew)
    myState = mySess.query(State).filter(State.name == 'Louisiana').first()
    mySess.commit()
    print("{}".format(myState.id))
    mySess.close()
