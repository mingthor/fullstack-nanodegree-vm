from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.sql import functions
 
from puppies import Base, Shelter, Puppy
#from flask.ext.sqlalchemy import SQLAlchemy
from random import randint
import datetime
import random

def printPuppies(puppies):
	"print all the puppies info"
	for puppy in puppies:
		print puppy.name, puppy.gender, puppy.dateOfBirth, puppy.weight, puppy.shelter.name
	return

engine = create_engine('sqlite:///puppyshelter.db')

Base.metadata.bind = engine
 
DBSession = sessionmaker(bind=engine)

session = DBSession()

# 1. Query all of the puppies and return the results in ascending alphabetical order
puppies = session.query(Puppy).order_by(Puppy.name)
printPuppies(puppies)

# 2. Query all of the puppies that are less than 6 months old organized by the youngest first
puppies = session.query(Puppy).filter(Puppy.dateOfBirth > datetime.date.today() - datetime.timedelta(weeks=24)).order_by(Puppy.dateOfBirth)
printPuppies(puppies)

# 3. Query all puppies by ascending weight
puppies = session.query(Puppy).order_by(Puppy.weight)
printPuppies(puppies)

# 4. Query all puppies grouped by the shelter in which they are staying
puppies = session.query(Puppy).group_by(Puppy.shelter_id)
printPuppies(puppies)