# imports the pandas module for reading CSV with ease
import pandas as pd

# Reads in our CSV as a dataframe
df = pd.read_csv('crypto.csv')
# Replaces whitespaces in column names in our variable df.columns
df.columns = df.columns.str.replace(' ', '')
# Sets the columns we will be using 
dfcols = df[['Name', 'BirthMonth']]

# Find Vitaliks info by searching the Name row for vitalks name and setting the returned info a
# as a var
vitaliksinfo = df[dfcols['Name'].str.match('Vitalik')]

# Printing vitaliks name and birth month
print(vitaliksinfo)

