#!/usr/bin/python3
"""listing all the hbtn_0e_6_usa State objects"""

if __name__ == "__main__":

    import sys
    from model_state import Base, State
    from sqlalchemy import create_engine
    from sqlalchemy.orm import Session

    myEng = create_engine(
        'mysql+mysqldb://{}:{}@localhost/{}'.format(sys.argv[1], sys.argv[2],
                                                    sys.argv[3]), pool_pre_ping=True)
    Base.metadata.create_all(myEng)

    mySession = Session(myEng)
    for s in mySession.query(State).order_by(State.id).all():
        print("{}: {}".format(s.id, s.name))
    mySession.close()
