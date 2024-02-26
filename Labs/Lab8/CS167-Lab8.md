# Lab 8

## Objectives

* Understand the document database model.
* Manipulate a set of documents in a database.
* Understand how MongoDB deals with the flexibility of the document data model.

---

## Prerequisites

* Download the following sample file [tweets.json](./tweets.json).
* Access to your cs167 machine.
---

## Lab Work

### I. Setup MongoDB, Database Tools and MongoDB shell in your cs167 machine (15 minutes, In-home)
1. Login to your CS167 machine.
2. On your CS167 machine, download and extract MongoDB Community Edition to your `$HOME/cs167` using the command below.  We will work with version 7.0.5 (current).
```shell
curl https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2004-7.0.5.tgz | tar -xvz -C $HOME/cs167
```
3. Download and extract MongoDB Database Tools.to your $HOME/cs167 using the command below. We will work with version 100.9.4 (current).
```shell
curl https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2004-x86_64-100.9.4.tgz | tar -xvz -C $HOME/cs167
```
4. Download and extract MongoDB Shell to your $HOME/cs167 using the command below. We will use version 2.1.5 (current).
```shell	
curl https://downloads.mongodb.com/compass/mongosh-2.1.5-linux-x64.tgz | tar -xvz -C $HOME/cs167
```

*Note:* You should see the following three folders created in your `$HOME/cs167` folder after step 4:
+ mongodb-linux-x86_64-ubuntu2004-7.0.5
+ mongodb-database-tools-ubuntu2004-x86_64-100.9.4
+ mongosh-2.1.5-linux-x64

5. Copy or move all the files from  the `mongodb-database-tools-ubuntu2004-x86_64-100.9.4/bin` directory to the `mongodb-linux-x86_64-ubuntu2004-7.0.5/bin` directory. Available files are:
    + bsondump
    + mongoexport
    + mongoimport
    + mongostat
    + mongodump
    + mongofiles
    + mongorestore
    + mongotop

You can use the following command for this step:
```shell
cp -r $HOME/cs167/mongodb-database-tools-ubuntu2004-x86_64-100.9.4/bin/* $HOME/cs167/mongodb-linux-x86_64-ubuntu2004-7.0.5/bin/
```

6. Copy or move all the files from  the `cs167/mongosh-2.1.5-linux-x64/bin` directory to the `mongodb-linux-x86_64-ubuntu2004-7.0.5/bin` directory. Available files are:
    + mongosh 
    + mongosh_crypt_v1.so

You can use the following command for this step:
```shell
cp -r $HOME/cs167/mongosh-2.1.5-linux-x64/bin/* $HOME/cs167/mongodb-linux-x86_64-ubuntu2004-7.0.5/bin/
```
7. Configure Environment variables:

    Set the environment variables $MONGODB_HOME and $PATH as follows:
    ```shell
    echo 'export MONGODB_HOME=$HOME/cs167/mongodb-linux-x86_64-ubuntu2004-7.0.5' >> ~/.bashrc
    echo 'export PATH=$PATH:$MONGODB_HOME/bin' >> ~/.bashrc
    ```

8. Reload the configuration by running `source ~/.bashrc`.

9. Test that MongoDB works correctly by running the command `mongod -version`. The output should look something like the following:

```json
db version v7.0.5
Build Info: {
    "version": "7.0.5",
    "gitVersion": "7809d71e84e314b497f282ea8aa06d7ded3eb205",
    "openSSLVersion": "OpenSSL 1.1.1f  31 Mar 2020",
    "modules": [],
    "allocator": "tcmalloc",
    "environment": {
        "distmod": "ubuntu2004",
        "distarch": "x86_64",
        "target_arch": "x86_64"
    }
}
```

10. Create a $MONGODB_HOME/data directory where your data will be stored. You can use the following command for this task.
	```shell
    mkdir $MONGODB_HOME/data
    ```
11. Start the MongoDB server by running the following command (you must keep the tab/window open while doing this lab)
    ```shell
    mongod --dbpath $MONGODB_HOME/data
    ```
*Note*: It is recommended to run the **mongod** service in a [screen](../../remote-access.md#part-vii-run-commands-in-a-screen) so it stays running in case you lose your connection. If this is too complicated for you, just keep the window open. If you get disconnected, you will need to rerun the **mongod** service again using the command above.

### II. Data Understanding (15 minutes - In Home)

In this part, you will work with the [`tweets.json`](tweets.json) file to better understand it.

1. On your *local machine*, run the command `scp tweets.json cs167:~/` to copy the [downloaded sample data](tweets.json) file to your CS167 machine.
2. On your *CS167 machine*, run `spark-shell --master local` to start a new Spark shell in local mode.
3. Once the Spark shell starts, run the command `spark.read.json("file:///home/cs167/tweets.json").printSchema`.

    *Note*: We explicitly use the local file system (`file:///`) to override your existing configuration from previous labs.

***(Q1) What is the schema of the file? Copy it to the README file and keep it for your reference.***

---

### III. Data Manipulation (60 minutes)


1. On your *CS167 machine*, import the sample file into a new collection named `tweets`. You will need to use [`mongoimport`](https://www.mongodb.com/docs/database-tools/mongoimport/) command from the database tool. You may use [`--collection`](https://www.mongodb.com/docs/database-tools/mongoimport/#std-option-mongoimport.--collection) option.
    * ***(Q2) What is your command to import the `tweets.json` file?***
    * ***(Q3) What is the output of the import command?***

2. On your CS167 machine, run the command `mongosh` in the terminal, and  this will open the MongoDB Shell (mongosh), which is an interactive JavaScript interface to MongoDB. Here, you can run queries, manage data, and perform administrative tasks directly against your MongoDB database. You should see the following after running this command.

    ![Mongo Shell](images/mongosh-terminal.png)

3. Write a query in the MongoDB shell to count the total number of records in the `tweets` collection.
    * ***(Q4) What is your command to count the total number of records in the `tweets` collection and what is the output of the command?***

    Hint: Use [`db.collection.find()`](https://www.mongodb.com/docs/manual/reference/method/db.collection.find/#mongodb-method-db.collection.find) and [`db.collection.count()`](https://www.mongodb.com/docs/manual/reference/method/db.collection.count/).

4. Find all tweets those have `country_code` "JP" and user's `statuses_count` is greater than 50,000. From these tweets, list information about the users, specifically their username (`user_name`), number of followers (`followers_count`), and total number of tweets (`statuses_count`). The results should be sorted in *ascending order* based on the number of followers (`followers_count`).
    * ***(Q5) What is your command for this query?***
    * ***(Q6) How many records does your query return?*** (Use the [db.collection.count()](https://www.mongodb.com/docs/manual/reference/method/db.collection.count/) function to answer this question.)
    
    Hint: You will need to use [db.collection.find()](https://www.mongodb.com/docs/manual/reference/method/db.collection.find/#mongodb-method-db.collection.find), [projection](https://www.mongodb.com/docs/manual/reference/method/db.collection.find/#projection) and [Ascending/Descending Sort](https://www.mongodb.com/docs/manual/reference/method/cursor.sort/#ascending-descending-sort). Check how to [access nested attributes](https://www.mongodb.com/docs/manual/reference/method/db.collection.find/#embedded-field-specification).

5. Repeat step 5 but [do not show the `_id` field](https://www.mongodb.com/docs/manual/reference/method/db.collection.find/#_id-field-projection).
    * ***(Q7) What is the command that retrieves the results without the _id field?*** 

6. Insert the following document to the collection.
    ```json
    {id: Long('921633456941125634'), place: { country_code: 'JP', name: 'Japan', place_type: 'city' }, user: {user_name: 'xyz2', followers_count: [2100, 5000], statuses_count: 55000}, hashtags: ['nature' ],lang: 'ja'}
    ```
    * ***(Q8) What is the command to insert the sample document? What is the result of running the command?*** 
    * ***(Q9) Does MongoDB accept this document while the followers_count field has a different type than other records?*** 

    Hint: Use [`db.collection.insertOne()`](https://www.mongodb.com/docs/manual/reference/method/db.collection.insertOne/#db.collection.insertone--).

7. Insert the following documen to the collection.

    ```json
    {id: Long('921633456941121354'), place: { country_code: 'JP', name: 'Japan', place_type: 'city' }, user: {user_name: 'xyz3', followers_count: {last_month: 550, this_month: 2200}, statuses_count: 112000}, hashtags: [ 'art', 'tour' ], lang: 'ja'
    }
    ```
    * ***(Q10) What is your command to insert this record?***

8. Rerun step 4, which lists the records sorted by followers_count in **descending** order.
    * ***(Q11) Where did the two new records appear in the sort order?***

    * ***(Q12) Why did they appear at these specific locations?***

    Check the [documentation of MongoDB](https://www.mongodb.com/docs/v6.2/reference/bson-type-comparison-order/) to help you answering this question.

9. Rerun step 5, but this time lists the records sorted by followers_count in **ascending** order.
    * ***(Q13) Where did the two records appear in the ascending sort order? Explain your observation.***

    Hint: [Ascending/Descending Sort](https://www.mongodb.com/docs/manual/reference/method/cursor.sort/#ascending-descending-sort).


10. Build an index on the `user.followers_count` field for the `tweets` collection.
    * ***(Q14) Is MongoDB able to build the index on that field with the different value types stored in the `user.followers_count` field?***
    * ***(Q15) What is your command for building the index?***
    * ***(Q16) What is the output of the create index command?***

    Hint: Use [`db.collection.createIndex()`](https://www.mongodb.com/docs/manual/reference/method/db.collection.createIndex/#mongodb-method-db.collection.createIndex).

---
### IV.  Identify Tweets with Selected Hashtags
In this part, you need to find all tweets that include any of the following hashtags: 'job', 'hiring', or 'IT'. The query should return the tweet text (text field), the associated hashtags, and the associated user's user_name, followers_count for each matching document in the **ascending** order of user's follower's count. 
* ***(Q17) What is your command for this query?***
* ***(Q18) How many records are returned from this query?***

*Hint:* : Use the [`$in`](https://www.mongodb.com/docs/manual/reference/operator/query/in/) operator within your query to specify that you want to find documents where the hashtags array contains at least one of the specified hashtags.

---
### V. Print top 5 countries with most number of tweets
For this part, you need to run a query on `tweets` collection which will return the top 5 countries with most number of tweets. List the country_code and tweets_count in the descending order of the tweets_count. Use the [db.collection.aggregate()](https://www.mongodb.com/docs/manual/reference/method/db.collection.aggregate/#db.collection.aggregate--) framework stages to group documents by the country code, count the number of tweets for each country, sort these counts, and then limit the results to only the top 5 countries. You can modify the `???` portion of the following command for this part:
```javascript
db.tweets.aggregate([
  { $group: {
      _id: ???,
      totalTweets: { $sum: ??? }
  }},
  { $sort: { ??? : -1 } },
  { $limit: ??? }
])
```
* ***(Q19) What is your command for this query?***
* ***(Q20) What is the output of the command?***
---
### VI. Print the Top 5 Trending Hashtags from Tweets
Write a MongoDB aggregation pipeline to determine the top 5 most frequently used hashtags in the tweets collection. The results should be sorted by the frequency of each hashtag in descending order. 
+ Begin by breaking down the array of hashtags so each one can be analyzed individually. Use [`$unwind`](https://www.mongodb.com/docs/manual/reference/operator/aggregation/unwind/) on the `hashtags` column in the aggregate pipeline. 
+ Then, group by `hashtags`, count the occurrences of each, and order the results to find the most common hashtags. Finally, limit the output to show only the top 5 hashtags.
    * ***(Q21) What is your command for this query?***
    * ***(Q22) What is the output of the command?***
---

### VII. Submission (2 minutes)

1. Write your answers using the [template `README.md`](CS167-Lab8-README.md) file.
2. Name your file `[UCRNetID]_lab7_README.md`, replace `[UCRNetID]` with your UCR Net ID.
3. Do not forget to include your information as you do in other labs.
4. No separate code is required for this lab.
