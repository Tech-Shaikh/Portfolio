# Netflix Shows and Movies - Data Analysis in SQL SERVER
## Overview

The primary goal of this project is to use SQL Server to clean and analyze Netflix's content data. The project's main goals are to: (1) ensure data quality through cleaning techniques; and (2) extract useful about the type of content available on Netflix, content distribution trends over time, and popular ratings among users and many more. The following important Netflix tables were analyzed using data from [Kaggle:](https://www.kaggle.com/datasets/victorsoeiro/netflix-tv-shows-and-movies?select=titles.csv)
- Data Cleaning: In the first phase, I focused on performing data cleaning tasks on a Netflix-related SQL database. The goal was to ensure data consistency and completeness in the Titles and Credits tables, which store information about movies and series, as well as the individuals credited in them. The process involved identifying missing data, handling null values, and verifying data types to ensure compatibility across different data sources.
-	Data Analysis: After cleaning, the project analyzes Netflix's content, focusing on key business questions, including the total number of movies and TV shows, the distribution of content by release year, and the most common audience ratings. These insights provide a comprehensive understanding of Netflix's content trends and user preferences.
By combining data cleaning and analysis, this project showcases how structured SQL processes can improve data quality and generate actionable insights to drive data-driven decisions for media platforms like Netflix.
##About the dataset:
I'll be using two raw files for my analysis: Netflix_titles, which has 77,214 entries for actors and directors, and New_credits, which has 5806 entries for movies and episodes.

### Data Dictionary:
### **Table Structure: Netflix Titles Data**

| **Column Name**          | **Data Type** | **Type**         | **Description**                                                    |
|--------------------------|---------------|------------------|--------------------------------------------------------------------|
| `id`                     | `string`      | NON NULLABLE     | Unique ID for each entry                                           |
| `title`                  | `string`      | NON NULLABLE     | The title of the movie or TV show                                  |
| `type`                   | `string`      | NON NULLABLE     | The type of the content (Movie or TV Show)                         |
| `release_year`           | `integer`     | NON NULLABLE     | The year the movie or TV show was released                         |
| `age_certification`       | `string`      | NULLABLE         | The age certification of the movie or TV show                      |
| `runtime`                | `integer`     | NON NULLABLE     | The runtime of the movie or TV show                                |
| `genres`                 | `string`      | NULLABLE         | The genres of the movie or TV show                                 |
| `production_countries`    | `string`      | NULLABLE         | The production countries of the movie or TV show                   |
| `seasons`                | `integer`     | NULLABLE         | The number of seasons of the TV show                               |
| `imdb_score`             | `float`       | NON NULLABLE     | The IMDb score of the movie or TV show                             |
| `imdb_votes`             | `integer`     | NON NULLABLE     | The number of IMDb votes for the movie or TV show                  |

### **Table Structure: Netflix Credits Data**

| **Column Name** | **Data Type** | **Type**         | **Description**                                                    |
|-----------------|---------------|------------------|--------------------------------------------------------------------|
| `index`         | `integer`     | NON NULLABLE     | Index of the rows                                                  |
| `person_id`     | `integer`     | NON NULLABLE     | Unique ID for each entry                                           |
| `id`            | `integer`     | NON NULLABLE     | ID of the movie/show                                               |
| `name`          | `string`      | NON NULLABLE     | The name of the actor or actress                                   |
| `character`     | `string`      | NULLABLE         | The character the actor or actress played in the movie or TV show   |
| `role`          | `string`      | NON NULLABLE     | The role the actor or actress played in the movie or TV show        |


