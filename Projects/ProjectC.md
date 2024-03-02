# Project C: Wildfire Data Analysis

## Objectives
- Apply the techniques we learned on a real big-data application.
- Translate high-level requirements into a big-data processing pipeline.
- Break down a big problem into smaller parts that can be solved separately.

## Overview
This project analyzes a dataset the represents the wildfire occurrences in the US.
This data is made available by UC Riverside.
You can explore the WildfireDB dataset on [UCR-Star](https://star.cs.ucr.edu/?wildfiredb#center=40.03,-116.90&zoom=5).
Click on a few points to see sample data records and their attribute values.
The dataset contains a total of 18 million points. However, we will only work with a subset of the data in California.
Furthermore, we will have several subsets of the data of sizes, 1K, 10K, and 100K, to expedite the development.

You can also explore the [county dataset on UCR-Star](https://star.cs.ucr.edu/?TIGER2018/COUNTY#center=40.03,-116.90&zoom=5).
Click on a few records to see all the attributes that we have available for this data.
Do you think that the county name is unique? Can you find two different counties with the same name?

## Prerequisites
1. Download samples of the data with different sizes to test your program while developing.
There are samples of
[1,000 points](https://drive.google.com/open?id=1D0pM0tZpPiLqLQvXdl7IItmWG_uZTnoQ),
[10,000 points](https://drive.google.com/open?id=1D0VZpgJCr9RBOXD0Wxsq03TP_r8WWGJd),
and [100,000 points](https://drive.google.com/open?id=1D-Xxcpc8_l0X-n_6jbdqF3no2TUqIpBb).
You do not have to decompress these files before processing.

2. Download the [County dataset](https://drive.google.com/open?id=1Cl5_lR4tHPTDSaez5u1vsr685fZ9MKYa) 
made available by the US Census Bureau. You do not need to decompress this dataset either.

## Task 1: Data preparation
The first task is to prepare the data for processing. This includes two major steps.
First, introduce a new attribute `County` that indicates the county at which each wildfire happened.
Second, convert the file into a column-oriented Parquet format to speed up the analysis.

- Parse and load the CSV file using the Dataframe API.
- Introduce a geometry attribute that represents the location of each crime. Use the `ST_CreatePoint` function.
- Keep only the following columns to reduce the size of the dataset: "x", "y", "acq_date", "frp", "acq_time".
- The `frp` column, short for fire radiative power, requires some attention from you.
  This column sometimes stores a floating point value, and sometimes store two values separated by comma.
  In this step, you should convert all of them to float to prepare for the next step.
  To do that, use the `split` function to split the string around the comma and take only the first value.
  Then, cast this value to double using the syntax `double(...)` in SQL.
- Convert the resulting Dataframe to a SpatialRDD to prepare for the next step.
- Load the County dataset using Beast.
- Run a spatial join query to find the county of each wildfire.
- Use the attribute `GEOID` from the county to introduce a new attribute `County` in the wildfire.
  Notice that we cannot use the county name because it is not unique across the states.
- Convert the result back to a Dataframe.
- Drop the geometry column using the function `dropColumn` on the Dataframe.
- Write the output as a Parquet file named `wildfiredb_ZIP`.

The final output will have a schema that looks like the following.
Notice the fewer attributes and the last attribute that indicates the county.
```
root
 |-- x: double (nullable = true)
 |-- y: double (nullable = true)
 |-- acq_date: string (nullable = true)
 |-- frp: double (nullable = true)
 |-- acq_time: string (nullable = true)
 |-- County: string (nullable = true)
```

You can download this [sample output file](https://drive.google.com/open?id=1DlgXB3lA_sHIgcvaQQd_RBQPHqzK959x) to double-check your result.

A few sample records are shown below for your reference.

|                  x|                 y|  acq_date| frp| acq_time|County|
|-------------------|------------------|----------|----|---------|------|
|-123.79012382714633| 39.49769932079566|2014-04-16| 5.7|     2051| 06045|
|-123.59370530564676| 40.62211574302579|2015-08-07| 1.4|     1005| 06023|
|-123.58558385152243| 40.61345034913054|2015-08-05| 1.8|1043,1043| 06023|
|-123.57749200118698| 40.33575710612239|2015-08-15| 2.1|1055,1055| 06023|
|-123.56022433828086| 40.44443512212919|2015-08-04| 1.5|     1102| 06023|


In the report, include one paragraph, in your own words, on why the Parquet format will be helpful for this project.
Include a table that indicates the size of the original (decompressed) data and the Parquet format similar to the following.

| Dataset | CSV size | Parquet size |
|---------|----------|--------------|
| 1,000   |          |              |
| 10,000  |          |              |
| 100,000 |          |              |

## Task 2: Spatial analysis

Given a date range, start and end, compute the total fire intensity for each county over that time.
Draw the result as a choropleth map.

![Sample result for Task 2](images/ProjectC-Task2-Result.png)

Here is an overview of what you are expected to do.
- Load the dataset in the Parquet format.
You can test on [this sample file](https://drive.google.com/open?id=1DlgXB3lA_sHIgcvaQQd_RBQPHqzK959x) until the first task is complete.
- Run an SQL query that does the following:
  - Parse the `acq_date` attribute into a proper timestamp attribute.
    For that use the SQL function `to_date` with the format `yyyy-MM-dd`.
  - Parse the user-provided start and end dates using the function `to_date` with the format `MM/dd/yyyy`
  - Include a `WHERE` clause that tests if the observation date is `BETWEEN` start `AND` end dates.
  - Include a grouped aggregate statement to compute the `SUM` of the `frp` attribute for each `County`.
- The result of the query is still missing the county name and the geometry of the county. 
  To fix this problem we do the following.
- Load the county dataset using Beast and convert to a Dataframe.
- Run an equi-join SQL query to join with the results of the previous query on `GEOID=County`.
  Select the county name, the geometry, and the fire_intensity.
- Convert the result back to an RDD and write as a Shapefile named `wildfireIntensityCounty`.
  You might want to use `coalesce(1)` to ensure that only one output file is written.
- Import the file into QGIS and follow [these directions](Choropleth.md) to plot the choropleth map.
The output should look like the image shown above. That specific example was for the 1k dataset with date range
`[01/01/2016, 12/31/2017]`

You can also find [this sample result file](https://drive.google.com/open?id=1EC5oYQijky6Bjfs3ChiI-klM6-i09_V2) to get an idea of what is expected.

The contents of this data should look similar to the following. The actual values depend on the selected species.

|GEOID|         NAME|                   g|    fire_intensity|
|-----|-------------|--------------------|------------------|
|32001|    Churchill|POLYGON ((-119.08...|             112.0|
|32003|        Clark|POLYGON ((-115.89...|               9.9|
|41035|      Klamath|POLYGON ((-121.31...|             246.0|
|41029|      Jackson|POLYGON ((-122.95...|              14.0|
|06067|   Sacramento|POLYGON ((-121.18...|               2.0|
|06083|Santa Barbara|MULTIPOLYGON (((-...|             491.0|

with the following schema.

```
root
|-- GEOID: string (nullable = true)
|-- NAME: string (nullable = true)
|-- g: geometry (nullable = true)
|-- fire_intensity: double (nullable = true)
```

In the report, include your own visualization of the result for the 10k file that you get from Task A with any species of your choice.
Include which species you selected.

## Task 3: Temporal analysis
Given a specific county by name, compute the total fire intensity each month over all time
and plot the result as a line chart.

![Pie chart of species](images/ProjectC-Task3-Result.png)

Here is an overview of what you are expected to do.
- Load the dataset in the Parquet format.
  You can test on [this sample file](https://drive.google.com/open?id=1DlgXB3lA_sHIgcvaQQd_RBQPHqzK959x)
  until the first task is complete.
- Since the name is not unique and is not present in the WildfireDB dataset, we cannot directly search by it.
- To solve this issue, we first search for the unique GEOID of the county with that name in California.
- Retrieve the county name as a command-line argument.
- First, load the county dataset and run a filter by the given county name and by `STATEFP="06"` which represents California.
  Retrieve the GEOID of the selected county.
- Now, back to the wildfire data, run a grouped aggregate query that select all wildfires related to that county. 
  Compute the total fire intensity, `SUM(frp)`, and group by the combination of year and month.
- Sort the results lexicographically by (year, month).
- Store the result in a CSV file named `wildfires<countyName>` and substitute the county name provided by the user.
- Here is part a sample output file for Riverside county.

| year_month | fire_intensity     |
|------------|--------------------|
| 2012-01    | 8.7                |
| 2013-07    | 31.799999999999997 |
| 2013-11    | 3.0                |
| 2015-06    | 1.0                |
| 2016-02    | 0.6                |
| 2016-09    | 0.8                |
| 2017-09    | 1.3                |

- Open the file in a spreadsheet program and plot the result as a line chart.
  The output should look similar to the figure above.
