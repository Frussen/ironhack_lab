import numpy as np
import pandas as pd

def clean_gender(x):
    if x in ['M', "Male"]:
        return 'M'
    elif x in ['F', 'female', "Femal"]:
        return 'F'
    else:
        return np.nan

def clean_state(x):
    changes = {"AZ": "Arizona", "Cali": "California", "WA": "Washington"}
    if x in changes:
        return changes[x]
    else:
        return x

def clean_education(x):
    if x == "Bachelors":
        return "Bachelor"
    else:
        return x

def clean_customer_lifetime_value(x):
    if isinstance(x, str):
        return float(x.replace("%", ""))
    else:
        return pd.to_numeric(x, errors='coerce')

def clean_vehicle_class(x):
    if x in ['Luxury SUV', 'Sports Car', 'Luxury Car']:
        return 'Luxury'
    else:
        return x

def clean_complaints(x):
    if isinstance(x, str) and len(x)!=1:
        return float(x.split("/")[1])
    else:
        return pd.to_numeric(x, errors='coerce')


def clean_data(df):

    if isinstance(df, str) and df[-4:] == ".csv":
        df = pd.read_csv(df)

    df.columns = [i.lower().replace(" ","_") for i in df.columns]
    df.rename(columns={'st':'state'}, inplace=True)

    df['gender'] = list(map(clean_gender, df['gender']))
    df['state'] = df['state'].apply(clean_state)
    df['education'] = df['education'].apply(clean_education)
    df['customer_lifetime_value'] = df['customer_lifetime_value'].apply(clean_customer_lifetime_value)
    df['vehicle_class'] = df['vehicle_class'].apply(clean_vehicle_class)

    df['customer_lifetime_value'] = df['customer_lifetime_value'].astype(float)
    df['number_of_open_complaints'] = df['number_of_open_complaints'].apply(clean_complaints)

    # Find percentage of missing values
    percent_missing = df.isnull().mean() * 100
    missing_value_df = pd.DataFrame({'percent_missing': percent_missing})

    # Drop rows with all null values
    na_number = df.isnull().sum(axis=1)
    df.drop(df[na_number == len(df.columns)].index, inplace=True)

    # Replace customer_lifetime_value nan with mean value
    df['customer_lifetime_value'].fillna(value=round(df.customer_lifetime_value.median(),2), inplace=True)
    df['gender'].replace(np.nan, "U", inplace=True)

    # Drop duplicates
    df.drop_duplicates(inplace=True)
    df.reset_index(drop=True, inplace=True)

    return df
