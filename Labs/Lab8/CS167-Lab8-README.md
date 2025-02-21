# Lab 8

## Student information

* Full name:
* E-mail:
* UCR NetID:
* Student ID:

## Answers

* (Q1) What is the nesting level of this column `root.entities.hashtags.element.text`?

* (Q2) In Parquet, would this field be stored as a repeated column? Explain your answer.

* (Q3) Based on this schema answer the following:***

    - How many fields does the `place` column contain?
    - How many fields does the `user` column contain?
    - What is the datatype of the `time` column?
    - What is the datatype of the `hashtags` column?

* (Q4) Based on this new schema answer the following:
    - *How many fields does the `place` column contain?*
    - *How many fields does the `user` column contain?*
    - *What is the datatype of the `time` column?*
    - *What is the datatype of the `hashtags` column?*

* (Q5) What is the size of each folder? Explain the difference in size, knowing that the two folders `tweets.json` and `tweets.parquet` contain the exact same dataframe?


* (Q6) What is the error that you see? Why isn't Spark able to write this dataframe in the CSV format?

* (Q7.1) What do you see in the output? Copy it here.

* (Q7.2) What do you observe in terms of run time for each file? Which file is slowest and which is the fastest? Explain your observation?.

* (Q8.1) What are the top languages that you see? Copy the output here.

* (Q8.2) Do you also observe the same perfroamnce for the different file formats?

* (Q9) After step B.3.2, how did the schema change? What was the effect of the `explode` function?

* (Q10) For the country with the most tweets, what is the fifth most used language? Also, copy the entire output table here.

* (Q11) Does the observed statistical value show a strong correlation between the two columns? Note: a value close to 1 or -1 means there is high correlation, but a value that is close to 0 means there is no correlation.

* (Q12.1) What are the top 10 hashtags? Copy paste your output here.

* (Q12.2) For this operation, do you observe difference in performance when comparing the two different input files `tweets.json` and `tweets.parquet`? Explain the reason behind the difference.
