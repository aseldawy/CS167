# Lab 7

## Objectives

* Run SQL queries using SparkSQL and work with more complex schema.
* Understand the performance gains of working with Parquet files.
* Run analytic queries on Parquet files.

## Prerequisites
* Setup the development environment as explained in [Lab 6](../Lab6/CS167-Lab6.md).
* Download the following sample file [Tweets_1m.json.zip](https://drive.google.com/file/d/12-Mmv6JPgeWqp_EDurmePBqeaK1URyFv/view?usp=sharing), and decompress it in your Lab 7 directory.

## Note
The instructions given in this lab are in Scala but you are allowed to use Java if you prefer.

## Lab Work

### I. Project Setup (10 minutes) (In home)
Setup a new Scala project similar to [Lab 6](../Lab6/CS167-Lab6.md). Make sure to change the project name to Lab 7.

Make sure your `pom.xml` file contains the following by replacing the `properties` and `dependencies` sections:

```xml
  <properties>
    <spark.version>3.5.0</spark.version>
    <scala.compat.version>2.12</scala.compat.version>
    <maven.compiler.source>1.8</maven.compiler.source>
    <maven.compiler.target>1.8</maven.compiler.target>   
    <encoding>UTF-8</encoding>
    <scala.version>2.12.18</scala.version>
    <spec2.version>4.20.5</spec2.version>
  </properties>
 <dependencies>
   <dependency>
       <groupId>org.apache.spark</groupId>
       <artifactId>spark-core_${scala.compat.version}</artifactId>
       <version>${spark.version}</version>
       <scope>compile</scope>
     </dependency>
     <dependency>
      <groupId>org.apache.spark</groupId>
      <artifactId>spark-sql_${scala.compat.version}</artifactId>
      <version>${spark.version}</version>
    </dependency>
   <!-- new dependency for lab 07, required for code to run in IntelliJ -->
   <dependency>
     <groupId>com.fasterxml.jackson.core</groupId>
     <artifactId>jackson-core</artifactId>
     <version>2.16.1</version>
   </dependency>
    <dependency>
      <groupId>org.scala-lang</groupId>
      <artifactId>scala-library</artifactId>
      <version>${scala.version}</version>
    </dependency>
    <!-- Test -->
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.12</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.scalatest</groupId>
      <artifactId>scalatest_${scala.compat.version}</artifactId>
      <version>3.0.8</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.specs2</groupId>
      <artifactId>specs2-core_${scala.compat.version}</artifactId>
      <version>${spec2.version}</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.specs2</groupId>
      <artifactId>specs2-junit_${scala.compat.version}</artifactId>
      <version>${spec2.version}</version>
      <scope>test</scope>
    </dependency>
  </dependencies>

```

### II. Initialize Spark Session (10 minutes) (In home)

For this lab, we will use two files: `PreprocessTweets.scala` and `AnalyzeTweets.scala`.

1. Create a new scala file named `PreprocessTweets.scala` and use the following as your starter code:

```scala
package edu.ucr.cs.cs167.[UCRNetID]

import org.apache.spark.SparkConf
import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.catalyst.expressions.GenericRowWithSchema
import org.apache.spark.sql.expressions.UserDefinedFunction
import org.apache.spark.sql.functions.udf

import scala.collection.mutable


object PreprocessTweets {
  def main(args: Array[String]): Unit = {
    val inputfile: String = args(0)
    val outputfile: String = "tweets"

    val getHashtagTexts: UserDefinedFunction = udf((x: mutable.WrappedArray[GenericRowWithSchema]) => {
      x match {
        case x: mutable.WrappedArray[GenericRowWithSchema] => x.map(_.getAs[String]("text"))
        case _ => null
      }
    })

    val conf = new SparkConf
    if (!conf.contains("spark.master"))
      conf.setMaster("local[*]")
    println(s"Using Spark master '${conf.get("spark.master")}'")

    val spark = SparkSession
      .builder()
      .appName("CS167 Lab7 - Preprocessor")
      .config(conf)
      .getOrCreate()
    spark.udf.register("getHashtagTexts", getHashtagTexts)

    try {
      import spark.implicits._
      // TODO: A.1. read file and print schema
      //           A.1.1 read json file
      //           A.1.2 print dataframe schema

      // TODO: A.2. use SQL to select relevant columns
      //           A.2.1 createOrReplaceTempView
      //           A.2.2 use Spark SQL select query
      //           A.2.3 print schema of new dataframe
      // TODO: A.3. apply functions to some columns, by modifying the previous SQL command as follows:
      //           A.3.1 drop some nested columns from `place`
      //           A.3.2 drop some nested columns `user`
      //           A.3.3 transform `timestamp` to the appropriate datatype
      //           A.3.4 simplify the structure of the `hashtags` column
      //           A.3.5 print schema of new dataframe
      // TODO: A.5. show the dataframe
      // TODO: A.6. save the dataframe in JSON format
      // TODO: A.7. save the file in Parquet format
      // TODO: A.8. save the file in CSV format
    } finally {
      spark.stop
    }
  }
}
```

2. Create a new scala file named `AnalyzeTweets.scala` and use the following as your starter code:
```scala
package edu.ucr.cs.cs167.[UCRNetID]

import org.apache.spark.SparkConf
import org.apache.spark.sql.expressions.UserDefinedFunction
import org.apache.spark.sql.functions.{explode, udf}
import org.apache.spark.sql.{DataFrame, SparkSession}

import scala.collection.mutable

object AnalyzeTweets {

  def main(args: Array[String]) {
    val operation: String = args(0)
    val inputfile: String = args(1)

    val conf = new SparkConf
    if (!conf.contains("spark.master"))
      conf.setMaster("local[*]")

    println(s"Using Spark master '${conf.get("spark.master")}'")

    val spark = SparkSession
      .builder()
      .appName("CS167 Lab7 - SQL")
      .config(conf)
      .getOrCreate()

    val getTopLangs : UserDefinedFunction = udf((x: mutable.WrappedArray[String]) => {
      val orderedLangCount = x.groupBy(identity).map { case (x, y) => x -> y.size }.toArray.sortBy(-1 * _._2)
      orderedLangCount.take(5.min(orderedLangCount.length))
    })
    spark.udf.register("getTopLangs", getTopLangs)

    if (!(inputfile.endsWith(".json") || inputfile.endsWith(".parquet"))) {
      Console.err.println(s"Unexpected input format. Expected file name to end with either '.json' or '.parquet'.")
    }
    var df : DataFrame = if (inputfile.endsWith(".json")) {
      spark.read.json(inputfile)
    } else {
      spark.read.parquet(inputfile)
    }
    df.createOrReplaceTempView("tweets")

    try {
      import spark.implicits._
      var valid_operation = true
      val t1 = System.nanoTime
      operation match {
        case "top-country" =>
          // TODO: B.1. print out the top 5 countries by count
          df = spark.sql("SELECT <YOUR_SELECTED_COLUMNS> FROM tweets GROUP BY <YOUR_GROUP_BY_COLUMN> ORDER BY <YOUR_ORDER_COLUMN> DESC LIMIT 5")
          df.show()
        case "top-lang" =>
          // TODO: B.2. print out the top 5 languages by count
          df = spark.sql("SELECT <YOUR_SELECTED_COLUMNS> FROM tweets GROUP BY <YOUR_GROUP_BY_COLUMN> ORDER BY <YOUR_ORDER_COLUMN> LIMIT 5")
          df.show()
        case "top-country-with-lang" =>
          // TODO: B.3. print out the top 5 countries by count, and the top five languages in each of them by percentage

          // TODO: B.3.1. start by copying the same query from part B.1, but add `, getTopLangs(collect_list(lang))` before the `FROM` keyword.
          df = spark.sql(s"SELECT ..., getTopLangs(collect_list(lang)) AS top_langs FROM tweets ... LIMIT 5")

          println("Schema after step B.3.1:")
          df.printSchema()

          // TODO B.3.2. Use the `explode` function on the `top_lang` column

          println("\nSchema after step B.3.2:")
          df.printSchema()
          // Create a view for the new dataframe
          df.createOrReplaceTempView("tweets")

          // TODO B.3.3. update this command to get the table in the expected output
          df = spark.sql(s"SELECT <YOUR_SELECTED_COLUMNS> FROM tweets ORDER BY <YOUR_ORDER_COLUMNS>")

          println("\nSchema after step B.3.3:")
          df.printSchema()
          df.show(25)
        case "corr" =>
          // TODO: B.4. compute the correlation between the `user_followers_count` and `retweet_count`
        case "top-hashtags" =>
          // TODO: B.5. Get the hashtags with the most tweets 
          // B.5.1. explode the hashtags columns
          // B.5.2. create a view for the new dataframe
          // B.5.3. use a sql query to get the top 10 hashtags with the most tweets.
          // B.5.4. show the final result
        case _ => valid_operation = false
      }
      val t2 = System.nanoTime
      if (valid_operation)
        println(s"Operation $operation on file '$inputfile' finished in ${(t2 - t1) * 1E-9} seconds")
      else
        Console.err.println(s"Invalid operation '$operation'")
    } finally {
      spark.stop
    }
  }
}

```

### III. Data Pre-processing (40 minutes) (In home)

In this part, you will complete the implementation of the `PreprocessTweets.scala` file which takes the path to the `Tweets_1m.json` file as input and will save a cleaner version in different formats. Note, in this part all of the code is implemented for. You'll have to follow the instructions to fill all the `TODO` parts, and check the console outputs to answer the questions.

To run this file, you can use the following command after you create a JAR file for your project:
```bash
spark-submit --master "local[*]" --class edu.ucr.cs.cs167.[UCRNetID].PreprocessTweets ./target/[UCRNetID]_lab7-1.0-SNAPSHOT.jar ./Tweets_1m.json
```

1. First, read the input data file in JSON format, and print its schema. (`TODO A1`)

To read a `JSONLines` file in Spark you can use the following command:
```scala
var df = spark.read.json(inputfile)
```

To print the schema of a dataframe, you can use the following:
```scala
df.printSchema()
```

Do you notice how large the schema of this data is? Take some time to explore this schema, and think about its nesting levels.

***Q1: What is the nesting level of this column `root.entities.hashtags.element.text`?***
Note: You may consider `root` to be at nesting level 0, and `element` represents an element in an array and doesn't add to the nesting levels.

***Q2: In Parquet, would this field be stored as a repeated column? Explain your answer.***

2. Let's now select a smaller subset of these columns, only those that will be relevant to our analysis. We are only interested in the following columns:

`id`, `text`, `retweet_count`, `reply_count`, `lang`, `place`, `user`, `timestamp_ms`, `entities.hashtags`

We can use a SQL query to select these columns, but first we need to create a view (`TODO A.2.1`):
```scala
df.createOrReplaceTempView("tweets")
```

You can now select those columns with the following query (`TODO A.2.2`):

```scala
df = spark.sql(
        """SELECT
       id,
       text,
       place,
       user,
       timestamp_ms AS time,
       entities.hashtags AS hashtags,
       lang
       FROM tweets""")
```

Now, print the schema of the updated dataframe (`TODO A.2.3`):
```scala
df.printSchema()
```

The schema is now much smaller than the original one.

***Q3: Based on this schema answer the following:***
 - *How many fields does the `place` column contain?*
 - *How many fields does the `user` column contain?*
 - *What is the datatype of the `time` column?*
 - *What is the datatype of the `hashtags` column?*

3. We will now apply some transformations to these columns.

(`TODO A.3.[1-4]`) In the previous SQL query, replace these line:

```SQL
       place,
       user,
       timestamp_ms,
       entities.hashtags AS hashtags,
```

With the following lines:

```SQL
       (place.country_code AS country_code, place.name AS name, place.place_type AS place_type) AS place,
       (user.followers_count AS followers_count, user.statuses_count AS statuses_count, user.id AS id) AS user,
       timestamp(cast(timestamp_ms as long)/1000) AS time,
       getHashtagTexts(entities.hashtags) AS hashtags,
```

This first two lines will select only the nested columns that we want from the `place` and `user` columns, respectively. The third line converts the `timestamp_ms` column. The last line extracts only the hashtag text from the hashtags structure. We are using a custom function to do this transformation, which is already implemented for you.

*Note:* Leave the query in A.2.2 as-is and write only one new query with all the four changes in A.3.


This will change the data type of the time column.

Now, print the schema of this dataframe (`TODO A.3.5`).

***Q4: Based on this new schema answer the following:***
 - *How many fields does the `place` column contain?*
 - *How many fields does the `user` column contain?*
 - *What is the datatype of the `time` column?*
 - *What is the datatype of the `hashtags` column?*

5. You can show the dataframe to see a sample of rows (`TODO A.5`):

```scala
df.show()
```

6. We can now save this dataframe in different format.

First, save it in JSON format, using this command (`TODO A.6`):

```scala
 df.write.mode("overwrite").json(outputfile + ".json")
```

Then, save it in Parquet format, using this command (`TODO A.7`):

```scala
df.write.mode("overwrite").parquet(outputfile + ".parquet")
```

These two commands will create two folders, one for each format.

***Q5: What is the size of each folder? Explain the difference in size, knowing that the two folders `tweets.json` and `tweets.parquet` contain the exact same dataframe?***

Now, try to save the dataframe in `CSV` format, using the following line (`TODO A.8`):
```scala
df.write.mode("overwrite").parquet(outputfile + ".csv")
```

This line will produce an error.

***Q6: What is the error that you see? Why isn't Spark able to write this dataframe in the CSV format?***

After answering this question, comment that last line to avoid the error.

This is the end of this part. Now, we have three different files: `Tweets_1m.json`, `tweets.json` and `tweets.parquet`. We will use all three in the next section to learn how the different formats affect performance.

### III. Analyzing Data

In this part, you will work on the `AnalyzeTweets.scala` file. You will implement different operations on the data we obtained after the pre-processing.

#### B.1. Print the top 5 countriers by number of tweets (20 minutes)

1. Run a SQL query on the tweets table, that first groups by the country_code and counts the rows for each country. Simply modify `<YOUR_SELECTED_COLUMNS>`, `<YOUR_GROUP_BY_COLUMN>`,  and `<YOUR_ORDER_COLUMN>` with the appropriate values, and make sure that the final result is in descending order.

2. Compile your code using `mvn package` and then run the following commands:
```bash
spark-submit --master "local[*]" --class edu.ucr.cs.cs167.[UCRNetID].AnalyzeTweets ./target/[UCRNetID]_lab7-1.0-SNAPSHOT.jar top-country ./Tweets_1m.json
spark-submit --master "local[*]" --class edu.ucr.cs.cs167.[UCRNetID].AnalyzeTweets ./target/[UCRNetID]_lab7-1.0-SNAPSHOT.jar top-country ./tweets.json
spark-submit --master "local[*]" --class edu.ucr.cs.cs167.[UCRNetID].AnalyzeTweets ./target/[UCRNetID]_lab7-1.0-SNAPSHOT.jar top-country ./tweets.parquet
```

Each command will run the same operation on one of the files we have from the previous section.

***Q7: What do you see in the output? Copy it here.***
Note: to get the score for this question both your output must be correct and your implementation must also be correct.

***Q8: What do you observe in terms of run time for each file? Which file is slowest and which is the fastest? Explain your observation?.***


#### B.2. Print the top 5 languages by number of tweets

1. Run a SQL query on the tweets table, that first groups by the `lang` and counts the rows for each language. Simply modify `<YOUR_SELECTED_COLUMNS>`, `<YOUR_GROUP_BY_COLUMN>`,  and `<YOUR_ORDER_COLUMN>` with the appropriate values, and make sure that the final result is in descending order.

```bash
spark-submit --master "local[*]" --class edu.ucr.cs.cs167.[UCRNetID].AnalyzeTweets ./target/[UCRNetID]_lab7-1.0-SNAPSHOT.jar top-lang ./Tweets_1m.json
spark-submit --master "local[*]" --class edu.ucr.cs.cs167.[UCRNetID].AnalyzeTweets ./target/[UCRNetID]_lab7-1.0-SNAPSHOT.jar top-lang ./tweets.json
spark-submit --master "local[*]" --class edu.ucr.cs.cs167.[UCRNetID].AnalyzeTweets ./target/[UCRNetID]_lab7-1.0-SNAPSHOT.jar top-lang ./tweets.parquet
```

***Q9.1: What are the top languages that you see? Copy the output here.***
Note: to get the score for this question both your output must be correct and your implementation must also be correct.

***Q9.2: Do you also observe the same perfroamnce for the different file formats?***


#### B.3. Print the top 5 countries, and the percentage of tweets posted in their top languages.

For this operation, we want to run a little more complex query. You will also use this command for this operation:

```bash
spark-submit --master "local[*]" --class edu.ucr.cs.cs167.[UCRNetID].AnalyzeTweets ./target/[UCRNetID]_lab7-1.0-SNAPSHOT.jar top-country-with-lang ./Tweets_1m.json
spark-submit --master "local[*]" --class edu.ucr.cs.cs167.[UCRNetID].AnalyzeTweets ./target/[UCRNetID]_lab7-1.0-SNAPSHOT.jar top-country-with-lang ./tweets.json
spark-submit --master "local[*]" --class edu.ucr.cs.cs167.[UCRNetID].AnalyzeTweets ./target/[UCRNetID]_lab7-1.0-SNAPSHOT.jar top-country-with-lang ./tweets.parquet
```


B.3.1. To begin with, copy the same query from part B.1, but add `, getTopLangs(collect_list(lang))` before the `FROM` keyword. We made this custom function to make it easier to get the expected output. It collects the language code for all records for a country and converts to an array with (language, count) pair. Replace the `...` with the corresponding part from the previous query.

B.3.2. Use the `explode` function on the `top_lang` column. You can use the following line:
```scala
df = df.withColumn("top_langs", explode($"top_langs"))
```

B.3.3, B.3.4. After this part, we expect the output to have the following schema:

```
root
 |-- country: string (nullable = true)
 |-- tweets_count: long (nullable = false)
 |-- lang: string (nullable = true)
 |-- lang_percent: double (nullable = true)

```
The name of your columns might slightly be different. It should not be an issue as long as they represent the same data we expect.

Use the provided SQL command template, and update `<YOUR_SELECTED_COLUMNS>` to select the relavant columns. To select the langauge code, you can use `top_langs._1 AS lang` and you can also select the language count similarly `top_langs._2` but you will need to divide it by the `count` column to get the percentage, and give it the name `lang_percent`.

Next, you will also need to update how the rows are sorted, by replacing `<YOUR_ORDER_COLUMNS>`. You will need to sort by two columns, the `count` column, and the `lang_percent` column, respectivley, both in descending order.

*Note:* The field `top_lang` is a struct with two nested attributes, `_1` and `_2`, which represent the language and the number of tweets in that language. To access the nested attributes, use the `.` notation similar to C or Java.


***Q10: After step B.3.2, how did the schema change? What was the effect of the `explode` function?***

***Q11: For the country with the most tweets, what is the fifth most used language? Also, copy the entire output table here.***


#### B.4. For this part, we want to find if there is any correlation between a user's `statuses_count` and their `follower_count`. We can do this with the following line:

```
println(df.stat.corr("user.statuses_count", "user.followers_count"))
```

You can run it using these commands:
```bash
spark-submit --master "local[*]" --class edu.ucr.cs.cs167.[UCRNetID].AnalyzeTweets ./target/[UCRNetID]_lab7-1.0-SNAPSHOT.jar corr ./Tweets_1m.json
spark-submit --master "local[*]" --class edu.ucr.cs.cs167.[UCRNetID].AnalyzeTweets ./target/[UCRNetID]_lab7-1.0-SNAPSHOT.jar corr ./tweets.json
spark-submit --master "local[*]" --class edu.ucr.cs.cs167.[UCRNetID].AnalyzeTweets ./target/[UCRNetID]_lab7-1.0-SNAPSHOT.jar corr ./tweets.parquet
```

***Q12: Does the observed statistical value show a strong correlation between the two columns? Note: a value close to 1 or -1 means there is high correlation, but a value that is close to 0 means there is no correlation.***


#### B.5. Print top 10 hashtags by tweet count

In this part, we want to know the most used hashtags in our dataset.

You can run this operation using these commands:
```bash
spark-submit --master "local[*]" --class edu.ucr.cs.cs167.[UCRNetID].AnalyzeTweets ./target/[UCRNetID]_lab7-1.0-SNAPSHOT.jar top-hashtags ./tweets.json
spark-submit --master "local[*]" --class edu.ucr.cs.cs167.[UCRNetID].AnalyzeTweets ./target/[UCRNetID]_lab7-1.0-SNAPSHOT.jar top-hashtags ./tweets.parquet
```

B.5.1. First, you can explode the hashtags columns, similar to how you did in part B.3.2.
B.5.2. Then, you'll need to create a new view for this dataframe.
B.5.3. Apply a SQL query on the new dataframe to get the top 10 hashtags with the most tweets.
B.5.4. show the final result

***Q13: What are the top 10 hashtags? Copy paste your output here.***
Note: to get the score for this question both your output must be correct and your implementation must also be correct.


***Q14: For this operation, do you observe difference in performance when comparing the two different input files `tweets.json` and `tweets.parquet`? Explain the reason behind the difference.***


### IX. Submission (30 minutes)
1. Add a `README` file with all your answers.
2. Include the running time of all the operations you ran on the three files. The table will look similar to the following.
```
| Command               | Tweets_1m.json | tweets.json | tweets.parquet |
| top-country           |                |             |                |
| top-lang              |                |             |                |
| top-country-with-lang |                |             |                |
| corr                  |                |             |                |
| top-hashtags          |  N/A           |             |                |
```

3. Add a `run.sh` script that compiles your code and then runs the following set of operations in order.
* Run the preprocessor on the `Tweets_1m.json` file.
* Run the `top-country` operation on the three files.
* Run the `top-lang` operation on the three files.
* Run the `top-country-with-lang` operation on the three files.
* Run the `corr` operation on the three files.
* Run the `top-hashtags` operation on the two files: `tweets.json` and `tweets.parquet`.

## Rubric

Q1-12: +12 points (+1 point for each question; a point is counted only if the corresponding part is correctly implemented)

Code compiles correctly: +1 point

Full table of run-time by input format: +1 point

Following submission instructions: +1 point

## Common Issues

- *Problem*: When I run my program in IntelliJ, I get the following error:
```Exception in thread "main" java. lang.IllegalAccessError Create breakpoint: class org.apache.spark.torage.StorageUtils$```

- *Solution*: Edit your run configuration and add the following to VM Options:
```text
--add-opens java.base/java.nio=ALL-UNNAMED
--add-opens java.base/java.util=ALL-UNNAMED
--add-opens java.base/java.lang=ALL-UNNAMED
--add-opens java.base/sun.nio.ch=ALL-UNNAMED
--add-opens java.base/java.lang.invoke=ALL-UNNAMED
```

Below is how to add VM options to run configuration.

![Open Run Configuration](../Lab5/images/open-run-configuration.png)

![Add VM Options](../Lab5/images/add-vm-options.png)
