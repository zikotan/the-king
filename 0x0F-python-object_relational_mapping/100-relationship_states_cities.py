#!/usr/bin/python3
"""adding the “California” State object with the City “San Francisco”
to hbtn_0e_100_usa"""

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

    mySess = Session(myEng)
    myCity = City(name='San Francisco')
    theNew = State(name='California')
    theNew.cities.append(myCity)
    mySess.add_all([theNew, myCity])
    mySess.commit()
    mySess.close()
