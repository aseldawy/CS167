# Lab 4

## Objectives

* Write a simple MapReduce program.
* Customize the MapReduce program by accepting user input.
* Run Hadoop MapReduce programs in standalone and distributed modes.

## Prerequisites

* Setup the development environment as explained in [Lab #1](../Lab1/CS167-Lab1.md).
* Download these two sample files [sample file 1](nasa_19950801.tsv), [sample file 2](https://drive.google.com/open?id=1pDNwfsx5jrAqaSy8AKEZyfubCE358L2p).
* [TODO] Install hadoop locally or Create project on Server?

## Lab Work

### I. Setup - In-home (30 minutes)

1. Create a new empty project using Maven for Lab 4. See previous Labs ([Lab #1](../Lab1/CS167-Lab1.md), [Lab #2](../Lab2/CS167-Lab2.md), [Lab #3](../Lab3/CS167-Lab3.md) for more details.

2. Import your project into IntelliJ IDEA.

3. Copy the file `$HADOOP_HOME/etc/hadoop/log4j.properties` to your project directory under `src/main/resources`. This allows you to see internal Hadoop log messages when you run in IntelliJ IDEA.
    * Manually create `src/main/resources` if it does not exist.

4. Place the two sample files in your project home directory, i.e., next to the `pom.xml` file.

5. In `pom.xml` add the following dependencies.

    ```xml
    <properties>
      <!-- Change the version number below to match your installed Hadoop. -->
      <hadoop.version>3.3.6</hadoop.version>
      <maven.compiler.source>1.8</maven.compiler.source>
      <maven.compiler.target>1.8</maven.compiler.target>
    </properties>

    <dependencies>
        <dependency>
          <groupId>org.apache.hadoop</groupId>
          <artifactId>hadoop-common</artifactId>
          <version>${hadoop.version}</version>
        </dependency>
        <dependency>
          <groupId>org.apache.hadoop</groupId>
          <artifactId>hadoop-hdfs</artifactId>
          <version>${hadoop.version}</version>
        </dependency>
        <dependency>
          <groupId>org.apache.hadoop</groupId>
          <artifactId>hadoop-mapreduce-client-common</artifactId>
          <version>${hadoop.version}</version>
        </dependency>
        <dependency>
          <groupId>org.apache.hadoop</groupId>
          <artifactId>hadoop-mapreduce-client-core</artifactId>
          <version>${hadoop.version}</version>
        </dependency>
    </dependencies>
    ```

### II. Simple Filter Program - In-home (30 minutes)

[TODO] Specify the location of the file. I assume student will do this experiment on the server.

In this part, you will need to write a MapReduce program that produces the lines that have a specific response code in them (similar to [Lab #3](../Lab3/CS167-Lab3.md)). We will provide you with a sample code to help you understand MapReduce procedure in Hadoop.

0. If [`nasa_19950801.tsv`](./nasa_19950801.tsv) does not exist in your home directory, download [`nasa_19950801.tsv`](./nasa_19950801.tsv) and put it to your virtual environment home directory. You can use the following command to check whether you have one:
```shell
ls ~/ | grep nasa
```
If the output contains `nasa_19950801.tsv`, then you have the file.

1. Take a few minutes to look into the sample file and understand its format, or using the following command:
```shell
less nasa_19950801.tsv
```
You can press `J` or `K` on your keyborad to scroll down or up. Press `Q` when you want to exist viewing the file.

2. Create a new class named `Filter` in package `edu.ucr.cs.cs167.[UCRNetID]` with the following content:
    ```java
    package edu.ucr.cs.cs167.[UCRNetID];

    import org.apache.hadoop.conf.Configuration;
    import org.apache.hadoop.fs.Path;
    import org.apache.hadoop.io.LongWritable;
    import org.apache.hadoop.io.NullWritable;
    import org.apache.hadoop.io.Text;
    import org.apache.hadoop.mapreduce.Job;
    import org.apache.hadoop.mapreduce.Mapper;
    import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
    import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
    import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

    import java.io.IOException;

    /**
    * Filter log file by response code
    */
    public class Filter {
        public static void main(String[] args) throws Exception {
            String inputPath = args[0];
            String outputPath = args[1];
            // String desiredResponse = args[2];
            Configuration conf = new Configuration();
            // TODO pass the desiredResponse code to the MapReduce program
            Job job = Job.getInstance(conf, "filter");
            job.setJarByClass(Filter.class);
            job.setMapperClass(TokenizerMapper.class);
            job.setNumReduceTasks(0);
            job.setInputFormatClass(TextInputFormat.class);
            Path input = new Path(inputPath);
            FileInputFormat.addInputPath(job, input);
            Path output = new Path(outputPath);
            FileOutputFormat.setOutputPath(job, output);
            System.exit(job.waitForCompletion(true) ? 0 : 1);
        }

        public static class TokenizerMapper extends 
                Mapper<LongWritable, Text, NullWritable, Text> {

            @Override
            protected void setup(Context context) 
                    throws IOException, InterruptedException {
                super.setup(context);
                // TODO add additional setup to your map task, if needed.
            }

            public void map(LongWritable key, Text value, Context context) 
                    throws IOException, InterruptedException {
                if (key.get() == 0) return; // Skip header line
                String[] parts = value.toString().split("\t");
                String responseCode = parts[5];
                // TODO Filter by response code
            }
        }
    }
    ```

3. Take some time to understand the code and answer the following questions.
    * ***(Q1) What do you think the line [`job.setJarByClass(Filter.class);`](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/mapreduce/Job.html#setJarByClass-java.lang.Class-) does?***
    * ***(Q2) What is the effect of the line [`job.setNumReduceTasks(0);`](https://data-flair.training/forums/topic/what-happen-if-number-of-reducer-is-0-in-hadoop/)?***
    * ***(Q3) Where does the `main` function run? (Driver node, Master node, or an executor node).***

4. Initially, to make the code easy to run and test, we want the program to filter all the lines with response code `200`. 
We will hard code the value `200` instead of accepting it from the user input. 
To do so, add the `// TODO Filter by response code` in `map` function with the following code snippet:

    ```java
    // TODO Filter by response code
    if (responseCode.equals("200")){
        context.write(NullWritable.get(), value);
    }
    ```
    Notice that we use [`String#equals`](https://docs.oracle.com/javase/7/docs/api/java/lang/String.html#equals(java.lang.Object)) rather than the operator `==` since `String` is not a primitive value in Java.

5. Go to your project directory `workspace/[UCR_NetID]_lab4`, use the following command to build your `jar` file:
```shell
mvn clean package
```

6. Compile and run your program from the command line using the `hadoop jar` command.
```shell
hadoop jar target/[UCRNetID]_lab4-1.0-SNAPSHOT.jar edu.ucr.cs.cs167.[UCRNetID].Filter nasa_19950801.tsv filter_output_dir
```

7. Check the output by using the following command:
```shell
hdfs dfs -ls filter_output_dir 
```
You should be able to see two files. One is called `_SUCCESS`, which indicates that your MapReduce job successfully finished. 
The other is the actual output, which contains the lines with response code `200`.
You can use the following command to see how many lines are in the MapReduce output file:
```shell
hdfs dfs -cat filter_output_dir/part-m-00000 | wc -l
```
*Note*: `hdfs dfs -cat` will show all contents of input file. `wc -l` will count the number of lines of input file. `|` will feed the output of first command to the input of the second command. 

* **(Q4) How many lines do you see in the output?***


### III. Take User Input For the Filter (20 minutes)
[TODO] Specify location of running the code.

In this part, we will customize our program by taking the desired response code from the user as a command line argument.

1. Uncomment the line `// String desiredResponse = args[2];` in the `main` function.
2. Add the desired response code to the job configuration using the method [`Configuration#set`](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/conf/Configuration.html#set-java.lang.String-java.lang.String-). Use a user-defined configuration entry with the key `code`.
3. In the setup function, add a code that will read the desired response code from the job configuration and store it in an instance variable in the class `TokenizerMapper`.
    * Hint: Use [`org.apache.hadoop.mapreduce.Mapper.Context`](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/mapreduce/Mapper.html#setup-org.apache.hadoop.mapreduce.Mapper.Context-) and [`Configuration#get`](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/conf/Configuration.html#get-java.lang.String-).
4. Modify the `map` function to use the user given response code rather than the hard-coded response code that we used in Part II.
5. Run your program again to filter the lines with response code `200`. This time, you will need to pass it as a third command-line argument.

6. Try on both files `nasa_19950801.tsv` and `nasa_19950630.22-19950728.12.tsv`.
    * ***(Q5) How many files are produced in the output for each of the two files?***
    * ***(Q6) Explain this number based on the input file size and default block size.***
    * *Hint:* Think about how may blocks are needed to store to two files, respectively.

Note: If you run your program from the command-line without setting up YARN (see next section), then it runs in standalone mode, similar to how it runs in IntelliJ.

### IV. Run in Distributed Mode (45 minutes)

This part will be done on `cs167` server.

To run your MapReduce program in distributed mode, we will need to configure Hadoop to use YARN and start YARN instances.

*Note:* YARN stands for Yet Another Resource Negotiator and is the default cluster manager that ships with Hadoop.
1. Login to your CS167 machine.
2. Among your group members that are present in lab, choose the node with the smallest number as the master node.
3. Configure Hadoop to run MapReduce programs with YARN. Edit the file `$HADOOP_HOME/etc/hadoop/mapred-site.xml` and add the following part.

    ```xml
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <!-- Replace $HADOOP_HOME below to the actual absolute path -->
    <property>
      <name>yarn.app.mapreduce.am.env</name>
      <value>HADOOP_MAPRED_HOME=$HADOOP_HOME</value>
    </property>
    <property>
      <name>mapreduce.map.env</name>
      <value>HADOOP_MAPRED_HOME=$HADOOP_HOME</value>
    </property>
    <property>
      <name>mapreduce.reduce.env</name>
      <value>HADOOP_MAPRED_HOME=$HADOOP_HOME</value>
    </property>
    ```

    Note: If you do not have a `mapred-site.xml` file, make a copy of `mapred-site.xml.template` and name it `mapred-site.xml`.

4. Edit the file `$HADOOP_HOME/etc/hadoop/yarn-site.xml` and add the following part.

    ```xml
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>class-###</value>
    </property>
    ```
    *Note:* Replace `class-###` with the name of the master node. If you want to run YARN on your local machine, replace `class-###` with `localhost`.
5. Start the HDFS namenode and datanodes as done in Lab 3. *TL;DR* `hdfs namenode` on the NameNode and `hdfs datanode` on all data nodes. Check the bottom of this page for some common problems that you might face.
6. On the master node, and preferably in a screen, start the resource manager by running the command `yarn resourcemanager`. Leave the process running on that window.
7. On each data node, and preferably in a screen, start the node manager (worker) by running the command `yarn nodemanager`. Leave the process running on that window. Notice that while not common, you can use the nodemanager on the samenode as the resourcemanager.
8. On your local machine, generate a JAR file for your program using the command `mvn clean package`.
9. On your local machine, run the command `scp target/*.jar cs167:~/` to copy the JAR file to your CS167 machine.
10. On your local machine, run the command `scp nasa_19950801.tsv cs167:~/` to copy the test file to your CS167 machine. Repeat for all test files you would like to copy.
11. On the CS167 machine, copy both test files to your HDFS home directory using the command `hdfs dfs -put nasa_19950801.tsv nasa_19950801_[UCRNetID].tsv`. Make sure to replace `[UCRNetID]` with your UCR Net ID. This ensures that your group members will not accidentally overwrite your file since you all share the same HDFS home directory. Repeat the same for the other test file to put that in HDFS.
* *Note* If you get this error: `put: 'nasa_19950801_[UCRNetID].tsv': No such file or directory: 'hdfs://..../nasa_19950801_[UCRNetID].tsv'` first run this command: `hdfs dfs -mkdir -p .` and then run: `hdfs dfs -put nasa_19950801.tsv nasa_19950801_[UCRNetID].tsv`.
13. Run your JAR file using the command `yarn jar <*.jar> <main class> <input> <output> <code>`, for example:

    ```bash
    yarn jar [UCRNetID]_lab4-1.0-SNAPSHOT.jar edu.ucr.cs.cs167.[UCRNetID].Filter nasa_19950801_[UCRNetID].tsv filter_output_[UCRNetID].tsv 200
    ```

### V. Write an Aggregate Program (30 minutes)

[TODO] Keep Yarn or not?

In this part, we will create another MapReduce program that computes the total bytes for each response code. That is the sum of the column `bytes` grouped by the column `response`.

1. Create a new class `Aggregation` based on the following stub code.

    ```java
    package edu.ucr.cs.cs167.[UCRNetID];

    import org.apache.hadoop.conf.Configuration;
    import org.apache.hadoop.fs.Path;
    import org.apache.hadoop.io.IntWritable;
    import org.apache.hadoop.io.LongWritable;
    import org.apache.hadoop.io.Text;
    import org.apache.hadoop.mapreduce.Job;
    import org.apache.hadoop.mapreduce.Mapper;
    import org.apache.hadoop.mapreduce.Reducer;
    import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
    import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
    import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

    import java.io.IOException;


    public class Aggregation {
        public static void main(String[] args) throws Exception {
            Configuration conf = new Configuration();
            Job job = Job.getInstance(conf, "aggregation");
            job.setJarByClass(Aggregation.class);
            job.setMapperClass(TokenizerMapper.class);
            job.setCombinerClass(IntSumReducer.class);
            job.setReducerClass(IntSumReducer.class);
            job.setMapOutputKeyClass(IntWritable.class);
            job.setMapOutputValueClass(IntWritable.class);
            job.setOutputKeyClass(IntWritable.class);
            job.setOutputValueClass(IntWritable.class);
            job.setInputFormatClass(TextInputFormat.class);
            job.setNumReduceTasks(2);
            FileInputFormat.addInputPath(job, new Path(args[0]));
            FileOutputFormat.setOutputPath(job, new Path(args[1]));
            System.exit(job.waitForCompletion(true) ? 0 : 1);
        }

        public static class TokenizerMapper extends
                Mapper<LongWritable, Text, IntWritable, IntWritable> {

            private final IntWritable outKey = new IntWritable();
            private final IntWritable outVal = new IntWritable();

            public void map(LongWritable key, Text value, Context context)
                    throws IOException, InterruptedException {
                if (key.get() == 0)
                    return;
                String[] parts = value.toString().split("\t");
                int responseCode = Integer.parseInt(parts[5]);
                int bytes = Integer.parseInt(parts[6]);
                // TODO write <responseCode, bytes> to the output
            }
        }

        public static class IntSumReducer extends
                Reducer<IntWritable, IntWritable, IntWritable, IntWritable> {

            private final IntWritable result = new IntWritable();

            public void reduce(IntWritable key, Iterable<IntWritable> values,
                            Context context)
                    throws IOException, InterruptedException {
                // TODO write <key, sum(values)> to the output
            }
        }
    }
    ```

2. Implement the **TODO** items to make the desired logic. Hint: look at the [WordCount example](https://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html#Example:_WordCount_v1.0).

3. Run your program on the file `nasa_19950801.tsv` and check the output directory. You can run it locally first in IntelliJ to test the logic. Once you're satisfied with the result, recompile into a new JAR file, copy it to your CS167 machine, and run as follows on the CS167 machine:

    ```bash
    yarn jar [UCRNetID]_lab4-1.0-SNAPSHOT.jar edu.ucr.cs.cs167.[UCRNetID].Aggregation nasa_19950801_[UCRNetID].tsv aggregation_nasa_19950801_output_dir_[UCRNetID]
    ```

    * ***(Q7) How many files are produced in the output directory and how many lines are there in each file?***
    * ***(Q8) Explain these numbers based on the number of reducers and number of response codes in the input file.***

    * *Note:* The [hash function](https://github.com/apache/hadoop/blob/trunk/hadoop-common-project/hadoop-common/src/main/java/org/apache/hadoop/io/IntWritable.java#L71) of the class `IntWritable` is its integer value. The [default hash partitioner](https://github.com/apache/hadoop/blob/trunk/hadoop-mapreduce-project/hadoop-mapreduce-client/hadoop-mapreduce-client-core/src/main/java/org/apache/hadoop/mapred/lib/HashPartitioner.java#L36) assigns a record to a partition using the function `hashCode mod #reducers`.

4. Run your program on the file `nasa_19950630.22-19950728.12.tsv`.

    ```bash
    yarn jar [UCRNetID]_lab4-1.0-SNAPSHOT.jar edu.ucr.cs.cs167.[UCRNetID].Aggregation nasa_19950630.22-19950728.12_[UCRNetID].tsv aggregation_large_output_dir_[UCRNetID].tsv
    ```

    * ***(Q9) How many files are produced in the output directory and how many lines are there in each file?***
    * ***(Q10) Explain these numbers based on the number of reducers and number of response codes in the input file.***

5. Run your program on the output of the `Filter` operation with response code `200` on the file `nasa_19950630.22-19950728.12.tsv`.
    1. Re-run `Filter` program on the file `nasa_19950630.22-19950728.12.tsv`.

        ```bash
        yarn jar [UCRNetID]_lab4-1.0-SNAPSHOT.jar edu.ucr.cs.cs167.[UCRNetID].Filter nasa_19950630.22-19950728.12_[UCRNetID].tsv filter_large_output_[UCRNetID].tsv 200
        ```

    2. Run `Aggregation` program on the output **directory** of `Filter`: filter_nasa_19950630_output_[UCRNetID].tsv

        ```bash
        yarn jar [UCRNetID]_lab4-1.0-SNAPSHOT.jar edu.ucr.cs.cs167.[UCRNetID].Aggregation filter_large_output_[UCRNetID].tsv aggregation_filter_large_output_[UCRNetID].tsv
        ```

    * ***(Q11) How many files are produced in the output directory and how many lines are there in each file?***
    * ***(Q12) Explain these numbers based on the number of reducers and number of response codes in the input file.***

### VI. Submission (15 minutes)

1. Add a `README.md` file with all your answers ([template](CS167-Lab4-README.md)).
2. Add a `run.sh` script that runs compiles and runs your filter operation on the sample input file with response code `200`. Then, it should run the aggregation method on the same input file. The output files should be named `filter_output` and `aggregation_output` accordingly. Try the `run.sh` file before submission to make sure your code is correct.

Submission file format:

```console
[UCRNetID]_lab4.{tar.gz | zip}
  - src/
  - pom.xml
  - README.md
  - run.sh
```

Requirements:

* The archive file must be either `.tar.gz` or `.zip` format.
* The archive file name must be all lower case letters. It must be underscore '\_', not hyphen '-'.
* The folder `src` and three files `pom.xml`, `README.md` and `run.sh` must be the exact names.
* The folder `src` and three files `pom.xml`, `README.md` and `run.sh` must be directly in the root of the archive, do not put them inside any folder.
* Do not include any other files/folders, otherwise points will be deducted.

See how to create the archive file for submission at [here](../MakeArchive.md).
## Rubrics
- Q/A: +12 points (+1 point for each question)
- Code: +2 points
  - +1 for completing filter class
  - +1 for completing aggregate class
- Following submission instructions: +1 point

## Useful Hadoop Filesystem Commands

Check all Hadoop filesystem commands from [https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/FileSystemShell.html](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/FileSystemShell.html)

Specifically, you would be interested in the following commands:

* Upload file: [put](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/FileSystemShell.html#put)
* Create a directory: [mkdir](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/FileSystemShell.html#mkdir)
  * To create directory with parent directoriesl use argument `-p`.
* Delete file: [rm](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/FileSystemShell.html#rm)
  * To delete a directory recursively, use argument `-r`.
* List files: [ls](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/FileSystemShell.html#ls)
* Print text file content: [cat](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/FileSystemShell.html#cat)
  * Do not use this command on large files, otherwise your terminal may freeze.
* Print the first few lines of a text file: [head](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/FileSystemShell.html#head)
* Print the last few lines of a text file: [tail](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/FileSystemShell.html#tail)

#### Example commands

```bash
# Upload file to hdfs root
hadoop fs -put nasa_19950801.tsv /

# Create a directory
hadoop fs -mkdir -p /dir1/dir2

# Upload file to hdfs under some directory
hadoop fs -put nasa_19950630.22-19950728.12.tsv /dir1/dir2/

# List directory contents
hadoop fs -ls /dir1/dir2

# Delete a directory
hadoop fs -rm -f -r /dir1
```

## Common Errors

* Error: When I run my program on YARN, I see an error message similar to the following.

    ```text
    Failing this attempt.Diagnostics: [...]Container [pid=xxx,containerID=xxx] is running beyond virtual memory limits. Current usage: xxx MB of yyy GB physical memory used; xxx TB of yyy GB virtual memory used. Killing container.
    ```

* Fix: Add the following configuration to your `$HADOOP_HOME/etc/yarn-site.xml`.

    ```xml
    <property>
        <name>yarn.nodemanager.vmem-check-enabled</name>
        <value>false</value>
    </property>
    ```

    See also [https://stackoverflow.com/questions/21005643/container-is-running-beyond-memory-limits](https://stackoverflow.com/questions/21005643/container-is-running-beyond-memory-limits)

* Error: When I run any HDFS command, I get an error related to safemode
```
Cannot create file/user/cs167/nasa_19950630.22-19950728.12.tsv._COPYING_. Name node is in safe mode.
```

* Fix: Run the following command
```shell
hdfs dfsadmin -safemode leave
```

* Error: When I run the datanode, I get the following error:

```
java.io.IOException: Incompatible clusterIDs in /home/cs167/hadoop/dfs/data: namenode clusterID = CID-ca13b215-c651-468c-9188-bcdee4ad2d41; datanode clusterID = CID-d9c134b6-c875-4019-bce0-2e6f8fbe30d9
```

* Fix: Do the following steps to ensure a fresh start of HDFS:

1. Stop the namenode and all data nodes.
2. Delete the directory `~/hadoop/dfs` on *the namenode and all datanodes*. `rm -rf ~/hadoop/dfs`.
3. Reformat HDFS using the command `hdfs namenode -format`.
4. Start the namenode using the command `hdfs namenode`.
5. Start the datanode using the command `hdfs datanode`.
