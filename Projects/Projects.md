This page describes the potential projects for CS167. 

# Instructions 
The project will be done in groups of fout to five.
All group members are expected to work together to get the project done.
Each student will be assigned a task which can be implemented independently (without waiting for others).
We provided sample files for each task (except data preprocessing). You can use the sample file for `development` and `visulization`. Remember to run your code for the required input file `when data is ready`.
  * *Note*: If some student can not finish assigned task, you need to justify it in the report. We will grade your task accordingly. Remember that invalid justifications will lead to points reduction.

All tasks (except the data preprocessing) can be implemented and tested on the given sample dataset.

To finish your project, you need to prepare the following files:

1. A `README` file with:
    - `group name` (e.g., Section-XX-Y),
    - `project title` 
    - `student information`
    - `task of everyone`
2. The project `source code`. Similar to the labs, you should not include any binary or intermediate files.
3. A `script` (i.e., `run.sh`) compiles and runs the project code. There should be one script to compile and run all the tasks in order (task1 -> task2 -> task3 -> ... ).
4. A `report`. Include a written report describes your project and includes the results based on the instructions on Canvas and concrete Project (A, B, C, D).
5. A `two-minute video` describes what you did.
6. A `single multiple choice question` with `exactly one correct answer`. The answer of the question should be included in the video.

You can check the submission portal in Canvas for details.
Please check the [rubric](#rubric) carefully before your final submission.

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

## Task 4: Spatio-Temporal Analysis
Given a rectangle region and a time period, show all crimes cases happened within the given time and region. 

## Task 5: Arrest Prediction
Develop a predictive model to forecast whether a reported crime incident will result in an arrest.


# [Project B: Bird Analysis](ProjectB.md)
In this project, you will perform some analytical tasks on a dataset that represents bird observations.
We will combine this dataset with a ZIP code dataset to determine the ZIP code for each point.
Then, we will perform two analytical tasks, one based on ZIP codes, and one based on time.
The results will be visualized using existing tools.

## Task 1: Data preparation
To prepare the data for analysis, we will do the following.

- Parse the dataset in its CSV format.
- Rename the columns that contain white space or other special characters in their name to simplify the next steps.
- Introduce the ZIP Code for each bird observation by joining in the ZIPCode dataset.
- Save the converted file in Parquet file format to speed up the next tasks

## Task 2: Spatial analysis
Given a specific bird species, count the percentage of observations for this species among
all observations per ZIP Code and visualize the result as a choropleth map.

## Task 3: Temporal analysis
Given a date range `[start, end]`, find the number of observations of each species and plot the result as a pie chart.

## Task 4: Spatio-Temporal Analysis
Given a rectangle region and a time period, show all locations of observed birds within the given time and region. 

## Task 5: Bird's Category Prediction
Use machine learning to predict the category of a bird sighting using features derived from the bird's common and scientific names.

# [Project C: Wildfire analysis](ProjectC.md)
In this project, we will perform some analytic tasks on the wildfire dataset in California.
Each point in this dataset represents an occurrence of a wildfire along with relevant information
such as the location at which it happened, the date of the first, and the fire intensity.

## Task 1: Preparation
To prepare the dataset for analysis, we will do the following.

- Parse the data in its CSV format.
- Drop all the columns that store information about neighbors. We will not need this data for the next step.
- Join with the county dataset and add a new column that gives the county name for each fire observation.
- Write the output in Parquet format.

## Task 2: Spatio-temporal analysis
Given a date range, start and end, compute the total fire intensity for each county over that time. Draw the result as a choropleth map.

## Task 3: Temporal analysis
Given a specific county by name, compute the total fire intensity each month over all time and plot the result as a line chart.

## Task 4: Fire Intensity Prediction
Develop a machine learning model to predict fire intensity using other fire features.

## Task 5: Temporal analysis - 2
Given start and end dates, compute the total fire intesitites for each country of California and show the result in a bar-chart.


# [Project D: Twitter data analysis](ProjectD.md)
In this project, we will analyze twitter data. Our goal is to build a machine-learning classifier that assigns
a topic to each tweet. The topics are automatically extracted from all tweets based on most frequent hashtags.

## Task 1: Data preparation 1
Clean the dataset by selecting only relevant attributes that will be used in next steps.
Store the converted data in a new CSV file.
Extract the top 20 hashtags in all tweets and store them in an array.

## Task 2: Data preparation 2
Add a new column for each tweet that indicates its topic.
The topic is any of the hashtags that appear in the most frequent list.
If a tweet contains more than one top hashtags, any of them can be used.

## Task 3: Topic prediction
Build a machine learning model that assigns a topic for each tweet based on the classified tweets.
The model should learn the relationship between all features and the topic.
Then, it applies this model to all data to predict one topic for each tweet.

## Task 4: Temporal Analysis
Given start and end dates, count the number of tweets for each country_code and plot as a bar chart.

## Task 5: Discover Topic of the Week
Given a start date, find the most hot top-5 topics among all tweets for the next continous 7 days for each country.

# Rubric
The final code submissions will contain `three separated files`. One submission for each group, and you need to submit the three files to Canvas (do not ). They are structured as follows:
```console
Project-Section-XY-Z-report.pdf # file 1, your project report

Project-Section-XY-Z-question.txt # file 2, your project question

Project-Section-XY-Z.{tar.gz | zip} # file three, your code and run script
|-- src/  # a folder contains source codes. One for each task
|-- pom.xml # a pom.xml which can compile all tasks
|-- README.md
|-- run.sh  # a script can run your project tasks in order
```
*Note*: XY is your section number (one of {21, 22, 23}). Z is your group number in your section (e.g., 1, 2, 3, ...)

- 3% for the code part.
  - Make sure that your code is indented and uses proper variable names. Include `comments` as-needed to understand your code.
  - Include a `README` file with your information.
  - Include `all source files` (i.e., `Scala` or `Java` source code) in the `src` folder and `no binary or data files`.
  - Include a `script` (run.sh) that compiles and runs the all tasks in order (from task1 to task5) on the `smallest input file`.
    * *Note*: If you adopted AsterixDB or MongoDB in your task, include the query in a comment and do not run it.
- 1% for the `report` that includes:
  - A `title` for your project.
  - `Student information` and the corresponding task for each student.
  - A `short introduction` in your own words for the project and which big-data system you used and why you chose it.
  - A `section for each task` that includes results asked by the instruction, e.g., visualizations or other comparisons.
- 3% for the `video`.
  - The video can be `up-to` two minutes and a half (`150 seconds`). Points will be reduced if the video time exceeds the given limit.
  - In the first 10-15 seconds, indicate which project you worked on, your group name, and the group members.
    Make sure that all this information is written during that time.
  - In 10-15 seconds, give a very brief introduction to the project in your own words.
  - Include 30 seconds for each task where you very briefly describe what you did and how you did it. For example,
    mention which functions you used and how they helped you. Show the result that you included in the report in your presentation.
  - Each student must present their own part. You cann't receive any points if you didn't showup in the presentation.
- 1% for the `question`.
  - The question must be `a multiple choice question`.
  - There should be `exactly three choices`.
  - Only `one choice can be correct`. 
  - The `answer` should be in the presentation. It can be any of the tasks.
    * *Note*: Please make sure the answer you provided is correct. All group members will not receive question points if the provided answer is wrong.
  - The answer should be clear but not too blunt. For example, do not say in the presentation "The answer is ...". 
    However, your question could be "Which function is used to drop a column from a dataframe?" and during the presentation
    you could say "We used the function `drop` to drop a column from a dataframe.
    And now, you cannot use this specific question because I mentioned it.
- 2% for the project question answers.
  - There will be a concatenated video after the project submission deadline.
  - You need to watch the video, check how others are doing the project and answer project questions.
  - Your final grade in this part will be calculated using the following equation `max(4%, correct answers/number of questions / 0.8 * 4%)`.
    * *Note*: This means that if you get 80% correct, you get full score.

# Frequenty Asked Questions

***(Q1) How do I fix this error 'java.lang.OutOfMemoryError'?***

Spark by default only uses one Gigabyte of memory. You need to configure it to use all availalbe memory in your machine. The CS167 mahcine we provided to you has 32GB of ram, and you should use it if you don't have sufficient memory in your laptop.

To make Spark use all available memory, you can add the related options after `spark-submit` or `beast` commands, which set the `spark.executer.memory` and `spark.driver.memory` configurations. Your commands will look something similar to this:


```bash
spark-submit --conf spark.executor.memory=32g --conf spark.driver.memory=32g [OTHER_PARTS_OF_YOUR_COMMAND]
```

Or:

```bash
beast --conf spark.executor.memory=32g --conf spark.driver.memory=32g [OTHER_PARTS_OF_YOUR_COMMAND]
```
