This page describes the potential projects for CS167. More details will be added soon for each of them.

# Instructions 
The project will be done in groups of three.
The three students are expected to work together to get the project done but each student will have a separate task
so that it is clear who did what in the project.
Each student will choose what projects they want to work on but the assignment will be done by the instructor 
to ensure there is a balance between the different topics.
Students are expected to work together and use all the technologies available, 
e.g., Zoom and Google Drive, to collaborate and organize their work.

The final deliverable include the following:

1. A README file with the group number, project title, student information, and the task of everyone.
2. The source code of the project. Similar to the labs, you should not include any binary or intermediate files.
3. A script that compiles and runs the project code. There should be one script to compile and run all the three tasks in order.
4. A report. Include a written report that describes your project and includes the results you are asked to include in the report.
5. A two-minute video describing what you did.
6. A single multiple choice question with exactly one correct answer. The answer should be there in the video.

In all projects, feel free to make any reasonable assumptions and document them in your report.
You can use any of the systems we learned about this quarter.
Write an introductory paragraph that explains why you chose those systems specifically.

# [Project A: Chicago Crimes](ProjectA.md)
In this project, you are asked to analyze Chicago Crime dataset by location.
You will use Parquet file format to prepare the data for analysis.
You will use a mix of SparkSQL and Beast to perform the analysis.
The results will be visualized on a map and using a bar chart.

## Datasets
This project will work with [Chicago Crime](https://star.cs.ucr.edu/?Chicago%20Crimes#center=41.8756,-87.6227&zoom=11) dataset by Chicago City and the [ZIP Codes](https://star.cs.ucr.edu/?TIGER2018/ZCTA5#center=41.8756,-87.6227&zoom=11) dataset by the US Census Bureau.

## Task 1: Data preparation
This task prepares the data for analysis by doing the following:

- Parse the dataset from its CSV format.
- Rename some of the columns that contain white space to make it easier to process in SQL.
- Introduce a ZIP Code column that associates each crime with a ZIP code based on its location.
- Write te output in Parquet format to make it more efficient for analysis.

## Task 2: Spatial analysis
In this task, you need to count the total number of crimes for each ZIP code and plot the results as a choropleth map.

## Task 3: Temporal analysis
Given start and end dates, count the number of crimes for each crime type and plot as a bar chart.

## [Project B: Bird Analysis](ProjectB.md)
In this project, you will perform some analytical tasks on a dataset that represents bird observations.
We will combine this dataset with a ZIP code dataset to determine the ZIP code for each point.
Then, we will perform two analytical tasks, one based on ZIP codes, and one based on time.
The results will be visualized using existing tools.

### Task 1: Data preparation
To prepare the data for analysis, we will do the following.

- Parse the dataset in its CSV format.
- Rename the columns that contain white space or other special characters in their name to simplify the next steps.
- Introduce the ZIP Code for each bird observation by joining in the ZIPCode dataset.
- Save the converted file in Parquet file format to speed up the next tasks

### Task 2: Spatial analysis
Given a specific bird species, count the percentage of observations for this species among
all observations per ZIP Code and visualize the result as a choropleth map.

## Task 3: Temporal analysis
Given a date range `[start, end]`, find the number of observations of each species and plot the result as a pie chart.

## [Project C: Wildfire analysis](ProjectC.md)
In this project, we will perform some analytic tasks on the wildfire dataset in California.
Each point in this dataset represents an occurrence of a wildfire along with relevant information
such as the location at which it happened, the date of the first, and the fire intensity.

### Task 1: Preparation
To prepare the dataset for analysis, we will do the following.

- Parse the data in its CSV format.
- Drop all the columns that store information about neighbors. We will not need this data for the next step.
- Join with the county dataset and add a new column that gives the county name for each fire observation.
- Write the output in Parquet format.

### Task 2: Spatio-temporal analysis
Given a date range, start and end, compute the total fire intensity for each county over that time. Draw the result as a choropleth map.

### Task 3: Temporal analysis
Given a specific county by name, compute the total fire intensity each month over all time and plot the result as a line chart.

## [Project D: Twitter data analysis](ProjectD.md)
In this project, we will analyze twitter data. Our goal is to build a machine-learning classifier that assigns
a topic to each tweet. The topics are automatically extracted from all tweets based on most frequent hashtags.

### Task 1: Data preparation 1
Clean the dataset by selecting only relevant attributes that will be used in next steps.
Store the converted data in a new CSV file.
Extract the top 20 hashtags in all tweets and store them in an array.

### Task 2: Data preparation 2
Add a new column for each tweet that indicates its topic.
The topic is any of the hashtags that appear in the most frequent list.
If a tweet contains more than one top hashtags, any of them can be used.

### Task 3: Topic prediction
Build a machine learning model that assigns a topic for each tweet based on the classified tweets.
The model should learn the relationship between all features and the topic.
Then, it applies this model to all data to predict one topic for each tweet.

# Rubric
- 2% for the code part.
  - Make sure that your code is indented and use proper variable names. Include comments as-needed to understand your code.
  - Include a README file with your information.
  - Include all source files and no binary or data files.
  - Include a script that compiles and runs the three tasks in order.
    If you use AsterixDB or MongoDB, include the query in a comment and do not run it.
- 2% for the report that includes:
  - A title for your project.
  - Student information and who did which part.
  - A short introduction in your own words for the project and which big-data system you used and why you chose it.
  - A section for each task that includes what you were asked for, e.g., visualizations or other comparisons.
- 2% for the video and the question.
  - The video can be up-to two minutes. If it goes any longer, it will be trimmed and you will lose points.
  - In the first 10-15 seconds, indicate which project you worked on, your group number, and the group members.
    Make sure that all this information is written during that time.
  - In 10-15 seconds, give a very brief introduction to the project in your own words.
  - Include 30 seconds for each task where you very briefly describe what you did and how you did it. For example,
    mention which functions you used and how they helped you. Show the result that you included in the report as you talk.
  - Each student must present their own part. If only one student makes the whole presentation, other members will get zero in this part.
- 2% for the question.
  - The question must be a multiple choice question.
  - There should be exactly three choices.
  - Only one choice can be correct.
  - The answer should be in the presentation. It can be about any of the three tasks.
  - The answer should be clear but not too blunt. For example, do not say in the presentation "The answer is ...". 
    However, your question could be "Which function is used to drop a column from a dataframe?" and during the presentation
    you could say "We used the function `drop` to drop a column from a dataframe.
    And now, you cannot use this specific question because I mentioned it.
- 2% for the answers.
  - After I receive all the videos, they will be concatenated into a single video.
  - As you watch the videos, you will answer the questions.
  - Your final grade in this part will be calculated using the equation `max(4%, correct answers/number of questions / 0.8 * 4%)`.
    This means that if you get 80% correct, you get full score.

