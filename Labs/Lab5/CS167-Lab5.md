# Lab 5

## Objectives

* Write a Spark program using the Resilient Distributed Dataset API (RDD).
* Run a Spark program from the IDE.
* Run a Spark program from command line in local and cluster modes.

---

## Prerequisites

* Setup the development environment as explained in [Lab 1](../Lab1/CS167-Lab1.md).
* Download [Apache Spark 3.5.0](https://spark.apache.org/downloads.html). Choose the package type **Pre-built with user-provided Apache Hadoop**.
  * Direct link: [spark-3.5.0-bin-without-hadoop.tgz](https://dlcdn.apache.org/spark/spark-3.5.0/spark-3.5.0-bin-without-hadoop.tgz)
* Download these two sample files [sample file 1](../Lab4/nasa_19950801.tsv), [sample file 2](https://drive.google.com/open?id=1pDNwfsx5jrAqaSy8AKEZyfubCE358L2p). Decompress the second file after download. These are the same files we used in [Lab 4](../Lab4/CS167-Lab4.md).
---

## Lab Work

### I. Install Apache Spark (20 minutes) - In home

Note: We recommend that you use the standard Apache Spark 3.5.0 in this lab. Other versions might come with different default configuration that make it hard to debug the problems that you might face.

1. Expand the downloaded Apache Spark to your home/cs167 directory.
2. Set the environment variable `SPARK_HOME` to the expanded Spark directory. Add `$SPARK_HOME/bin` to the `PATH` environment variable. See [Lab 1](../Lab1/CS167-Lab1.md) for details on how to do it.

    * Linux and macOS
        In your profile file (*.bashrc*, *.bash_profile*, *.zshrc* or *.zprofile*):

        1. Add

            ```bash
            # Linux, MacOS
            export SPARK_HOME="$HOME/cs167/spark-3.3.1-bin-hadoop3"
            ```

        2. Add `$SPARK_HOME/bin:` to `PATH` variable like

            ```bash
            # This line must be after all the export lines
            PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$HADOOP_HOME/bin:$SPARK_HOME/bin:$PATH
            ```

    * Windows
        1. Add a new variable under **User variables for xxx**:
            * Variable name: `SPARK_HOME`
            * Variable value: `%USERPROFILE%\cs167\spark-3.3.1-bin-hadoop3`
        2. Add `%SPARK_HOME%\bin` to `Path` variable

3. Configure Spark to use your previsouly installed Hadoop. Reference: [Using Spark's "Hadoop Free" Build
](https://spark.apache.org/docs/latest/hadoop-provided.html)
    1. Go to `$SPARK_HOME/conf`, make a copy of **spark-env.sh.template** to **spark-env.sh**.
    2. Add `export SPARK_DIST_CLASSPATH=$(hadoop classpath)` to the end of **spark-env.sh**.
    3. **Windows only**
        1. In terminal, run `hadoop classpath`, copy its result string.
        2. Add an environment variable:
            * Variable name: `SPARK_DIST_CLASSPATH`
            * Variable value: the string you copied from the `hadoop classpath` command.
4. Make a copy of the file **$SPARK_HOME/conf/spark-defaults.conf.template** to **$SPARK_HOME/conf/spark-defaults.conf**.
5. To test that Spark is running correctly, run the command [spark-submit](https://spark.apache.org/docs/latest/submitting-applications.html) from the command line to see Spark usage. Then use the following command to run one of the Spark examples.

    ```bash
    spark-submit run-example org.apache.spark.examples.SparkPi
    ```

    This command estimates PI by generating random points in a unit square and computing the fraction the fills in a unit circle. In the output, you should see a line similar to the following one.

    ```text
    Pi is roughly 3.144355721778609
    ```

    Hint: You may use the following command to only print the needed line (Linux and macOS only).

    ```bash
    spark-submit run-example org.apache.spark.examples.SparkPi 2>/dev/null
    ```

---

### II. Project Setup (20 minutes) - In home

1. Create a new empty project using Maven for Lab 5. See [Lab 1](../Lab1/CS167-Lab1.md) for more details.
2. Import your project into IntelliJ IDEA.
3. Copy the file `$SPARK_HOME/conf/log4j.properties.template` to your project directory under `src/main/resources/log4j.properties`. This allows you to see internal Spark log messages when you run in IntelliJ IDEA.
4. Place the two sample files in your project home directory.
5. In `pom.xml` add the following configuration.

    ```xml
    <properties>
      <maven.compiler.source>1.8</maven.compiler.source>
      <maven.compiler.target>1.8</maven.compiler.target>
      <spark.version>3.5.0</spark.version>
    </properties>

    <dependencies>
      <dependency>
        <groupId>org.apache.spark</groupId>
        <artifactId>spark-core_2.13</artifactId>
        <version>${spark.version}</version>
        <scope>compile</scope>
      </dependency>
    </dependencies>
    ```

---

### III. Sample Spark Code (20 minutes)

1. Edit the `App` class and add the following sample code.

    ```java
    import org.apache.spark.api.java.JavaRDD;
    import org.apache.spark.api.java.JavaSparkContext;

    public class App {
        public static void main(String[] args) {
            final String inputPath = args[0];
            try (JavaSparkContext spark = new JavaSparkContext("local[*]", "CS167-Lab5")) {
                JavaRDD<String> logFile = spark.textFile(inputPath);
                System.out.printf("Number of lines in the log file %d\n", logFile.count());
            }
        }
    }
    ```

2. Run the `main` function in IntelliJ IDEA. The command line argument should be `nasa_19950801.tsv`. You should see the following line in the output.

    ```text
    Number of lines in the log file 30970
    ```

3. Switch to the command line. Compile your code using the command `mvn package`.
4. Run your program from command line using the following command. Do not forget to replace `[UCRNetID]` with the correct one. Also, make sure hdfs namenode and datanode are running. If you have error shows as no such hdfs host, then using file path start with `hdfs://localhost:9000/`

    ```bash
    spark-submit --class edu.ucr.cs.cs167.[UCRNetID].App target/[UCRNetID]_lab5-1.0-SNAPSHOT.jar hdfs:///nasa_19950801.tsv
    ```

    Hint: You may use the following command to only print the needed line (Linux and macOS only).

    ```bash
    spark-submit --class edu.ucr.cs.cs167.[UCRNetID].App target/[UCRNetID]_lab5-1.0-SNAPSHOT.jar hdfs:///nasa_19950801.tsv 2>/dev/null
    ```

---

### IV. Run in Distributed Mode (30 minutes)

In the followign part, we will configure Spark to run in distributed mode. Make sure that each group member has access to their CS167 machine before doing the following part.

1. Before connecting to your CS167 machine, edit the file `$HOME/.ssh/config` (Linux and MacOS) or `%USERPROFILE%\.ssh\config` (Windows). Add the line `LocalForward 8080 class-###:8080` and `LocalForward 4040 class-$$$:4040` under `Host cs167` in your config file. Replace `class-###` with the name of the machine you elect to be the master node (not necessarily your own machine) and `class-$$$` is your own machine. So, the file should look something like the following
    ```text
    Host cs167
        LocalForward 8080 class-777:8080
        LocalForward 4040 class-888:4040
        HostName class-888.cs.ucr.edu
        User cs167
        ProxyJump [UCRNetID]@bolt.cs.ucr.edu
    ```
    In this case, `class-777` is the master node and `class-888` is your own machine.
    *Note:* If you were already connected to your CS167 while changing the configuration, you will need to close that session and start a new SSH session for the new configuration to take effect.
1. On your CS167 machine, download and extract Spark to your `$HOME/cs167` using the command below.
    ```shell
    curl https://dlcdn.apache.org/spark/spark-3.5.0/spark-3.5.0-bin-without-hadoop.tgz | tar -xvz -C $HOME/cs167
    ```
2. Set the environment variables `$SPARK_HOME` and `$PATH` as follows:
    ```shell
    echo 'export SPARK_HOME=$HOME/cs167/spark-3.5.0-bin-without-hadoop' >> ~/.bashrc
    echo 'export PATH=$PATH:$SPARK_HOME/bin' >> ~/.bashrc
    ```
3. Configure Spark to use Hadoop classes that we installed in Lab 3.
    1. Go to `$SPARK_HOME/conf`, make a copy of `spark-env.sh.template` to `spark-env.sh`.
         ```shell
         cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh
         ```
    2. Edit the file using vim
        ```shell
        vim $SPARK_HOME/conf/spark-env.sh
        ```
    3. Add `export SPARK_DIST_CLASSPATH=$(hadoop classpath)` to the end of `spark-env.sh`.
4. Reload the configuration by running `source ~/.bashrc`.
5. Test that Spark works correctly by running the command `spark-submit --version`. The output should look something like the following.
    ```text
            Welcome to
          ____              __
         / __/__  ___ _____/ /__
         _\ \/ _ \/ _ `/ __/  '_/
        /___/ .__/\_,_/_/ /_/\_\   version 3.5.0
            /_/

        Using Scala version 2.12.18, OpenJDK 64-Bit Server VM, 11.0.21
        Branch HEAD
        Compiled by user ubuntu on 2023-09-09T01:41:38Z
        Revision ce5ddad990373636e94071e7cef2f31021add07b
        Url https://github.com/apache/spark
        Type --help for more information.
    ```

The following part will configure a Spark cluster.

1. Among your group, elect a machine as the master. By convention, we will use the machine with the lowest number that you have access to during the lab. In the following part we will call it `class-###`.
2. Set `spark.master` in your configuration file.
    1. If you don't have a file `$SPARK_HOME/conf/spark-defaults.conf` create one by running the command:
    ```shell
    cp $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf
    ```
    2. Edit the file using `vim $SPARK_HOME/conf/spark-defaults.conf`.
    3. Uncomment the line that starts with `spark.master` and change the value to `class-###:7077` where `class-###` is the name of the master node.
    4. Save the file and exit.
1. Start the master node by running the command:

    ```bash
    $SPARK_HOME/sbin/start-master.sh --host class-###
    ```
2. Make sure that the master is running by navigating to the [http://localhost:8080](http://localhost:8080) at your browser. You should see a page similar to the following one. Notice that there are no worker nodes since we did not start any yet.
    ![Spark master with no worker nodes](images/spark-master-no-workers.png)
3. On each worker node, run the following command.

    ```bash
    $SPARK_HOME/sbin/start-worker.sh spark://class-###:7077
    ```

    Notice: you can find the correct bind address from the web interface. Replace `class-###` with the name of the master node.
4. Now, if you refresh the master web interface, you should be able to see one or more worker nodes.
    ![Spark master with one worker node](images/spark-master-one-worker.png)
5. Start HDFS namenode and datanodes as instructed earlier. You might want to delete the `$HOME/hadoop/dfs` directory on all machines and reformat HDFS before doing this to ensure you have a consistent state across machines, i.e. no leftover temporary files from previous lab.
5. Now, go back to your program (on your local machine), compile the JAR file and copy it to your CS167 machine. Use the same `spark-submit` command that you had earlier.

    ***(Q1) Do you think it will use your cluster? Why or why not?***

    Hint: To find out, check the [web interface](http://localhost:8080) and observe any new applications that get listed.

6. To use the pseudo-cluster that we just started, change the following code from

    ```java
    JavaSparkContext spark = new JavaSparkContext("local[*]", "CS167-Lab5")
    ```

    to

    ```java
    JavaSparkContext spark = new JavaSparkContext("spark://class-###:7077", "CS167-Lab5");
    ```

7. Now, compile and then run your program from command line as you did before. Make sure to run it from WSL (Windows users).

    ***(Q2) Does the application use the cluster that you started? How did you find out?***

---

### V. Make the Application Portable (15 minutes)

We do not want to change the code every time we switch between local and cluster mode.

1. To automatically set an appropriate master, change your code to look as follows.

    ```java
    import org.apache.spark.SparkConf;
    import org.apache.spark.api.java.JavaRDD;
    import org.apache.spark.api.java.JavaSparkContext;

    public class App {
        public static void main(String[] args) {
            final String inputPath = args[0];
            SparkConf conf = new SparkConf();
            if (!conf.contains("spark.master"))
                conf.setMaster("local[*]");
            System.out.printf("Using Spark master '%s'\n", conf.get("spark.master"));
            conf.setAppName("CS167-Lab5");
            try (JavaSparkContext spark = new JavaSparkContext(conf)) {
                JavaRDD<String> logFile = spark.textFile(inputPath);
                System.out.printf("Number of lines in the log file %d\n", logFile.count());
            }
        }
    }
    ```

    This code first creates a [SparkConf](https://spark.apache.org/docs/latest/api/java/org/apache/spark/SparkConf.html) instance using the default configuration. If Spark master is already configured, it will use the default configuraiton. If not, it will use the local mode.

2. Edit your `$SPARK_HOME/conf/spark-defaults.conf` and add the line `spark.master spark://class-###:7077`. The configurations in this file are automatically loaded when you use spark-submit and instantiate a new instance of SparkConf using the default constructor.

3. Run the code from IntelliJ IDEA.

    ***(Q3) What is the Spark master printed on the standard output on IntelliJ IDEA?***

4. Compile the code from command line and run using `spark-submit`.

    ```bash
    spark-submit --class edu.ucr.cs.cs167.[UCRNetID].App target/[UCRNetID]_lab5-1.0-SNAPSHOT.jar hdfs:///nasa_19950801.tsv
    ```

    ***(Q4) What is the Spark master printed on the standard output on the terminal?***

5. You can manually override the master on the `spark-submit` command. Try the following line and observe what the master is.

    ```bash
    spark-submit --class edu.ucr.cs.cs167.[UCRNetID].App --master local[2] target/[UCRNetID]_lab5-1.0-SNAPSHOT.jar hdfs:///nasa_19950801.tsv
    ```

    Note: `local[2]` means that it runs on the local mode with two cores.
    Note: if you get file not found exception and you are sure the file is uploaded to HDFS, try using the full path like `hdfs://class-xxx:9000/user/cs167/nasa_19950801.tsv`, where `class-xxx` is your name node.

---

### VI. Filter Operation (30 minutes)

In the next part, we will extend the program to use more Spark functions. We will use the [filter](https://spark.apache.org/docs/latest/api/java/org/apache/spark/rdd/RDD.html#filter-scala.Function1-) transformation to find log entries with a specific response code.

1. Make a copy of the current sample class and named it `Filter`. Place it in the same package as the `App` class.
2. Add the following line to set the desired code to the value `200`.

    ```java
    final String desiredCode = "200";
    ```

3. Add the following lines to filter the lines based on the user-provided response code.

    ```java
    JavaRDD<String> matchingLines = logFile.filter(line -> line.split("\t")[5].equals(desiredCode));
    System.out.printf("The file '%s' contains %d lines with response code %s\n", inputPath, matchingLines.count(), desiredCode);
    ```

    Note: the following expression in Java

    ```java
    line -> line.split("\t")[5].equals(desiredCode)
    ```

    is called lambda expression. It is a shorthand to write an anonymous inner class with one function. After compilation, it will be similar to the map function that we used to write in Hadoop which was a class with one function called `map`.

4. Run your program using the file `nasa_19950801.tsv`. The output should look similar to the following.

    ```text
    The file 'nasa_19950801.tsv' contains 27972 lines with response code 200
    ```

    Hint: You may use the following command to only print the needed line (Linux and macOS only).

    ```bash
    spark-submit --class edu.ucr.cs.cs167.[UCRNetID].Filter target/[UCRNetID]_lab5-1.0-SNAPSHOT.jar hdfs:///nasa_19950801.tsv 2>/dev/null
    ```
    ***(Q5) For the previous command that prints the number of matching lines, list all the processed input splits.***

    Hint: Search for the patterm `HadoopRDD: Input split` in the output on the console. The input splits is printed as `path:start+length`. On Linux or macOS, you may try the following command

    ```bash
    spark-submit --class edu.ucr.cs.cs167.[UCRNetID].Filter target/[UCRNetID]_lab5-1.0-SNAPSHOT.jar hdfs:///nasa_19950801.tsv 2>&1 | grep "HadoopRDD: Input split"
    ```

    If the above command shows no result, it is because the actual logs were generated on the worker node and not printed in the main terminal. You can find those lines in the log file from the [web interface](http://localhost:8080).

5. In addition to counting the lines, let us also write the matching lines to another file. Add the following part at the beginning of the `main` function.

    ```java
    final String inputPath = args[0];
    final String outputPath = args[1];
    final String desiredCode = args[2];
    ```

6. After the `printf` command the prints the number of matching lines, add the following line:

    ```java
    matchingLines.saveAsTextFile(outputPath);
    ```

7. Run your program again with the following parameters `hdfs:///nasa_19950801.tsv hdfs:///filter_output 200`.

    ```bash
    spark-submit --class edu.ucr.cs.cs167.[UCRNetID].Filter target/[UCRNetID]_lab5-1.0-SNAPSHOT.jar hdfs:///nasa_19950801.tsv hdfs:///filter_output 200
    ```

    You can use the following command to count the total number of lines in the output files.

    ```bash
    hdfs dfs -cat /filter_output/part-"*" | wc -l
    ```

    ***(Q6) For the previous command that counts the lines and prints the output, how many splits were generated?***

    ***(Q7) Compare this number to the one you got earlier.***

    ***(Q8) Explain why we get these numbers.***

    ***(Q9) What can you do to the current code to ensure that the file is read only once?***

    Hint: Use the [cache](https://spark.apache.org/docs/latest/api/java/org/apache/spark/api/java/JavaRDD.html#cache--) function in Spark.

---

### VII. Aggregation Operation (20 minutes)

In this part, we will run an aggregation function to count number of records for each response code.

1. Use the template code below to create a new class `Aggregation`.

    ```java
    import org.apache.spark.SparkConf;
    import org.apache.spark.api.java.JavaPairRDD;
    import org.apache.spark.api.java.JavaRDD;
    import org.apache.spark.api.java.JavaSparkContext;
    import scala.Tuple2;
    import java.io.IOException;
    import java.util.Map;

    public class Aggregation {
        public static void main(String[] args) throws IOException {
            final String inputPath = args[0];
            SparkConf conf = new SparkConf();
            if (!conf.contains("spark.master"))
                conf.setMaster("local[*]");
            System.out.printf("Using Spark master '%s'\n", conf.get("spark.master"));
            conf.setAppName("CS167-Lab5");
            try (JavaSparkContext spark = new JavaSparkContext(conf)) {
                JavaRDD<String> logFile = spark.textFile(inputPath);
                JavaPairRDD<String, Integer> codes = // To do 1: transform via `mapToPair`, return `Tuple2`
                Map<String, Long> counts = // To do 2: `countByKey`
                for (Map.Entry<String, Long> entry : counts.entrySet()) {
                    System.out.printf("Code '%s' : number of entries %d\n", entry.getKey(), entry.getValue());
                }
                System.in.read();
            }
        }
    }
    ```

2. Create a [JavaPairRDD<String, Integer>](https://spark.apache.org/docs/latest/api/java/index.html?org/apache/spark/api/java/JavaPairRDD.html) that contains key-value pairs. The key is the response code (as a string) and the value is 1. You will use the [mapToPair](https://spark.apache.org/docs/latest/api/java/org/apache/spark/api/java/JavaRDDLike.html#mapToPair-org.apache.spark.api.java.function.PairFunction-) transformation and the [Tuple2](https://www.scala-lang.org/api/current/scala/Tuple2.html) class (Complete `// To do 1`).
3. To count the number of records per response code, use the action [countByKey](https://spark.apache.org/docs/latest/api/java/org/apache/spark/api/java/JavaPairRDD.html#countByKey--) (Complete `// To do 2`).
4. Write the aggregate values to the standard output. The output should look similar to the following:

    ```text
    Code '302' : number of entries 355
    Code '404' : number of entries 221
    Code 'response' : number of entries 1
    Code '304' : number of entries 2421
    Code '200' : number of entries 27972
    ```
    Note 1: The entry with the code `response` corresponds to the header file. We can easily filter this value at the end but we will leave it like this for simplicity.
    Note 2: You can run it locally first in IntelliJ to test the logic. Once you're satisfied with the result, recompile into a new JAR file, copy it to your CS167 machine.
   
   You can run your code using this commadn:

    ```bash
    spark-submit --class edu.ucr.cs.cs167.[UCRNetID].Aggregation [UCRNetID]_lab5-1.0-SNAPSHOT.jar hdfs:///nasa_19950801.tsv
    ```

    To print the desired output only:

    ```bash
    spark-submit --class edu.ucr.cs.cs167.[UCRNetID].Aggregation [UCRNetID]_lab5-1.0-SNAPSHOT.jar hdfs:///nasa_19950801.tsv 2>/dev/null
    ```
 5. While your program runs, keep the window open and visit `http://localhost:4040`
 6. On that page, click on the name of your job, like the following screenshot:
    ![Finding active job to visualize dag](images/screenshot_10.png)
 7. On the next page, the expand the `Dag Visualization` section. You will see a graph visualizing the stages and all the steps off your Spark job.
    Based on this DAG, answer the following questions:
    ***(Q10) How many stages does your program have, and what are the steps in each stage?***
    ***(Q11) Why does your program have two stages?***
    


---

### VIII. Submission (15 minutes)

1. Add a `README` file with all your answers. Use this [template](https://raw.githubusercontent.com/aseldawy/CS167/master/Labs/Lab5/CS167-Lab5-README.md).
2. Add a `run` script that compiles and runs your filter operation on the input file `nasa_19950630.22-19950728.12.tsv` with response code 302. Then, it should run the aggregation method on the same input file. Assume that the input is in the current working directory so your `run` script should just use the input file name as a parameter and not an absolute path.

* Note 1: Don't forget to include your information in the README file.
* Note 2: Don't forget to remove any unnecessary test or binary files.

Submission file format:

```console
[UCRNetID]_lab5.{tar.gz | zip}
  - src/
  - pom.xml
  - README.md
  - run.sh
```

Requirements:

* The archive file must be either `.tar.gz` or `.zip` format.
* The archive file name must be all lower case letters. It must contain underscore '\_', not hyphen '-'.
* The folder `src` and three files `pom.xml`, `README.md` and `run.sh` must be the exact names.
* The folder `src` and three files `pom.xml`, `README.md` and `run.sh` must be directly in the root of the archive, do not put them inside any folder.
* Do not include any other files/folders, otherwise points will be deducted.

See how to create the archive file for submission at [here](../MakeArchive.md).

---

### Ruberic
Q1-Q10: +11 points (+1 point for each questions)
Code: +3 points
    +1 filte class
    +2 aggregation class
Following submission instructions: +1 point
### IX. Cleanup

Do not forget to stop Spark master and worker using the following commands.

```bash
$SPARK_HOME/sbin/stop-worker.sh
$SPARK_HOME/sbin/stop-master.sh
# Also stop hdfs datanode and namenode
```
