import pandas as pd
from sqlalchemy import create_engine

# 1. Read the CSV into a DataFrame
df = pd.read_csv(r"C:/Users/katar/OneDrive/Desktop/netflix_titles.csv")

# 2. Create a connection to MySQL
# Replace username, password, host, and database with your details
engine = create_engine("mysql+pymysql://root:Hoplita17!@localhost/netflix")

# 3. Send the DataFrame to MySQL
# "netflix" is your table name
df.to_sql("netflix", con=engine, if_exists="replace", index=False)