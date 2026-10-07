import os
import pandas as pd
import requests


USERS_URL = "https://jsonplaceholder.typicode.com/users"  # for the users data
POSTS_URL = "https://jsonplaceholder.typicode.com/posts"  # for the posts data
OUTPUT_FILE = "output/etl_result.csv"


def extract_data():
    '''For Fetching the users and posts data from API'''

    users_data = requests.get(USERS_URL)
    posts_data = requests.get(POSTS_URL)

    # returns the users and posts data in json
    return users_data.json(), posts_data.json()

def transform_data(users, posts):
    ''' Transforms the extracted data as per question requirements'''
    
    # (a) Create users DataFrame
    users_df = pd.DataFrame(users)
    posts_df = pd.DataFrame(posts)

    ## (b) Add word_count column to posts.
    posts_df["word_count"] = posts_df["body"].apply(
        lambda text: len(text.split())
    )

    merged_df = pd.merge(
        posts_df,
        users_df,
        left_on="userId",
        right_on="id",
        suffixes=("_post", "_user")
    )

    # (d) Filter word_count > 30. 
    filtered_df = merged_df[merged_df["word_count"] > 30].copy()

    # (e) Add category: Short/Medium/Long.
    filtered_df["category"] = filtered_df["word_count"].apply(
        lambda count: (
            "Short"
            if count <= 10
            else "Medium"
            if count <= 30
            else "Long"
        )
    )

    return filtered_df

def load_the_data(df):
    '''Save the transformed data'''
    os.makedirs("output", exist_ok=True)
    df.to_csv(OUTPUT_FILE, index=False)

def main():
    """complete ETL pipeline"""
    try:
        users, posts = extract_data()
        result_df = transform_data(users, posts)
        load_the_data(result_df)

        print(
            f"ETL completed: "
            f"{len(users)} users, "
            f"{len(posts)} posts extracted, "
            f"{len(result_df)} rows loaded."
        )

    except requests.RequestException as error:
        print(f"API request failed: {error}")

    except Exception as error:
        print(f"ETL pipeline failed: {error}")



if __name__ == "__main__":
    main()
