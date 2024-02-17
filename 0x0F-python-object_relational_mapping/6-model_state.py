#!/usr/bin/python3
"""Starting link class to table in database"""
import sys
from model_state import Base

from sqlalchemy import (create_engine)

if __name__ == "__main__":
    myEng = create_engine('mysql+mysqldb://{}:{}@localhost/{}'.
                          format(sys.argv[1], sys.argv[2], sys.argv[3]),
                          pool_pre_ping=True)
    Base.metadata.create_all(myEng)
