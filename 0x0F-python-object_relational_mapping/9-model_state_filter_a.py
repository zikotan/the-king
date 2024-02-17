#!/usr/bin/python3
"""listing all State objects that contain the
letter a from hbtn_0e_6_usa"""

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
    for s in mySession.query(State)\
                        .filter(State.name.like('%a%'))\
                        .order_by(State.id):
        print("{}: {}".format(s.id, s.name))
    mySession.close()
