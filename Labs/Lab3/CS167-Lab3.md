# Lab 3

## Objectives

* Setup HDFS clust and understand the differences between writing from NameNode and DataNode.
* Learn how to perform random access in HDFS.
* Understand how HDFS read a split of file.

## Prerequisites

* Follow the instructions in [Lab #2](../Lab1/CS167-Lab1.md) to setup the development environment.
<!-- * Download this [Sample File](http://bdlab.cs.ucr.edu/classes/AREAWATER.csv.bz2)
 and decompress it. We will use it for testing.
  * Linux: Run `tar xfj AREAWATER.csv.bz2` or `bzip2 -dk AREAWATER.csv.bz2` if previous one not work
  * macOS: Use Archive Utility, or run `bzip2 -dk AREAWATER.csv.bz2`
  * Windows: You may use 7-zip.
* Make sure you know your CS password. You will need this to connect to your remote machine, see instructions in take . -->

## Overview

In this lab, you will set a HDFS cluster with your group members. You will learn how to use web interface to write a file to hdfs from NameNode and DataNode, respectively. You need to be awared of the differences between these two cases.
You will write a java program, which can use HDFS interface to perform random read on a certain split of file. 

## Lab Work

Follow the instructions below to complete this lab. If you have any questions, please contact the TA in your lab. Make sure to  answer any questions marked by the ***(Q)*** sign and submit the deliverables marked by the ***(S)*** sign.

### I. Main Program (45 minutes) - In-home part
This part will be done in your `local laptop`.
In this part, you will write a Java program which can simulate how HDFS performs random read to a file. 

1. Create a new Java project using Maven for lab 3 in your `cs167/workspace` directory either from command line or from IntelliJ. The project name should be [UCRNetID]_lab3. Below is the example of using command line:
```shell
# Replace [UCRNetID] with your UCR Net ID, not student ID.
mvn archetype:generate "-DgroupId=edu.ucr.cs.cs167.[UCRNetID]" "-DartifactId=[UCRNetID]_lab3" "-DarchetypeArtifactId=maven-archetype-quickstart" "-DinteractiveMode=false"
```

2. Your program should take exactly three command-line arguments; the first for the `input`(a string indicating the file), the second for `offset` (a long type integer indicating the position starts reading), and the third for `length` (a long type integer indicating the number of bytes to read).
    * *Note*: You need to parse `offset` and `length` to long type integer, try to use [`Long.parseLong`](https://docs.oracle.com/javase/8/docs/api/java/lang/Long.html#parseLong-java.lang.String-).

3. If the number of command line arguments is incorrect, use the following code to print the error message and exit.
  ```java
  System.err.println("Incorrect number of arguments! Expected three arguments.");
  System.exit(-1);
  ```

4. Open `input` file using [org.apache.hadoop.fs.FSDataInputStream](https://hadoop.apache.org/docs/r3.3.1/api/org/apache/hadoop/fs/FSDataInputStream.html). You may refer to [Lab2](../Lab2/CS167-Lab2.md) for how to open a file by using HDFS interface. Use [`FSDataInputStream.seek`](https://hadoop.apache.org/docs/r3.3.1/api/org/apache/hadoop/fs/FSDataInputStream.html#seek-long-) to find the start position. If `offset` is not 0, you need to skip to content until meet a newline character. You can use [`BufferedReader.readline`](https://docs.oracle.com/javase/8/docs/api/java/io/BufferedReader.html#readLine--) to read a line from `inputStream`. Below is an example for your reference:
```Java
FSDataInputStream inputStream = fs.open(`path`) 
inputStream.seek(offset); //  Go to the start position
BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
if (offset != 0) {  // if offset is 0, directly read that file. Otherwise, until meet a newline character.
    reader.readLine(); 
}
```

5. Create a variable `bytesRead` to store the number of bytes your program reads.
Read the file line by line, until `bytesRead` exceeds the expected `length`. 
You should output the expected bytes `length`, and the actual bytes read `bytesRead` in the following format:
```Java
System.out.println("Expected Bytes Read: " + length);
System.out.println("Actual Bytes Read: " + bytesRead );
```

6. To test your program, create a file called `test.txt` in your `cs167/workspace/[UCRNetID]_lab3` directory. Copy the following message to the file:
```text
Hello!
This is
an example of simulating
HDFS read procedure.
It will ignore contents right after offset (if it is not 0),
until meet a newline character.
After that,
it will keep reading lines until
the number of read bytes exceeds
expected length.
```

7. Now, test your program with the following arguments in IntelliJ IDEA (You can refer to Lab1-note on how to set running arguments in IDEA):
```text
test.txt 0 4
test.txt 3 4
test.txt 3 9
```
* ***(Q1) Compare `bytesRead` and `length`, are they equal? Use one sentance to explain why.***

8. Modify your code, so that it will output the number of line contains string `200`.
Your output should be the same as the following format `result` is the number of lines contain string `200`:
```Java
System.out.println("Result: " + result);
```
9. Pack your project into a `jar` file. Don't forget to edit `pom.xml` in your lab folder `[UCRNetID]_lab3`:
```maven
  <!-- Replace [UCRNetID] with your UCRNetID -->
  <build>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-jar-plugin</artifactId>
        <configuration>
          <archive>
            <manifest>
              <mainClass>edu.ucr.cs.cs167.[UCRNetID].App</mainClass>
            </manifest>
          </archive>
        </configuration>
      </plugin>
    </plugins>
  </build>
```
The `jar` file will be used and tested on your remote `cs167` server.

### II. Setup HDFS Cluster (10 minutes) - In-lab part
This part will be done on the `cs167` server.
In this part, you need to set up a HDFS cluster with your group members. 

1. Identify all members of your group. You will find the group information in Canvas. 
Each member should find their machine name by running the command `hostname` with format `class-xxx` after they are logged in to their `cs167` machine.
3. By convention, we will use the machine with the *lowest* hostname number as the namenode, and others will be the datanodes.
4. All group members need to modify `$HADOOP_HOME/etc/hadoop/core-site.xml`, so that all machines are in the same cluster. 
For all machines (including both namenode and datanodes), edit `$HADOOP_HOME/etc/hadoop/core-site.xml`, and modify the following property inside the configuration tag.
    ```xml
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://[namenode]:9000</value>
    </property>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/home/cs167/hadoop</value>
    </property>
    ```
    * *Note*: Replace `[namenode]` with the `hostname` of the machine that you selected as the namenode. After this step, the core-site.xml file should look identical across all machines. Make sure there are no additional spaces in the name and value.
5. On the `namenode`, initialize the files for HDFS by running the command `hdfs namenode -format`.
    * *Note*: Make sure that you run this command `only on the namenode`. 
6. On the `namenode`: start the namenode by running `hdfs namenode`. Wait a few seconds to make sure that the namenode has started.
7. On each of the datanodes: start the data node by running `hdfs datanode`
8. Run this command to check the status of the cluster
 ```shell
   hdfs dfsadmin -report
   ```
* ***(Q2) Copy the output of this command.***
* ***(Q3) How many lived datanodes are in this cluster?***

### III. Understand HDFS Write Behavior
This part will be done on the `cs167` server (continue to part II).
In this part, you need to write to HDFS from namenode and datanode.  

1. Make sure your `namenode` and `datanode` are running on the `cs167` server.
    * *Note*: Nothing need to be done if you follow part1.

2. On the `namenode` machine, run the following command to copy `AREAWATER_[UCRNetID].csv` from your local file system to HDFS:
```shell
# Replace [UCRNetID] with the netid of student owning this the namenode
hdfs dfs -put AREAWATER_[UCRNetID].csv
```

3. On the `namenode` machine, run the following command to find the block locations of the file you just uploaded:
```shell
# Replace [UCRNetID] with the netid of student owning this the namenode
hdfs fsck AREAWATER_[UCRNetID].csv -locations
```
* ***(Q4) How many replicas are stored on the namenode? How many replicas are stored in the datanodes?***

4. Now, on each `datanode` machine, repeat step 2 and step 3 to upload the file to HDFS and observe the block replica distribution.
    * *Note*: you need to change [UCRNetID] to the netid of student owning this datanode.

* ***(Q5) How many replicas are stored on the datanode uploading the file? How many replicas are stored across other datanodes?***

* ***(Q6) Compare your results of Q4 and Q5, give one sentence to explain the results you obtained.***

### IV. Test your code in HDFS (10 minutes) - In-lab Part
This part will be done in `cs167` server.
You will use your packed `jar` file to read from HDFS.

1. Make sure the namenode and datanodes are running.
2. Upload your `jar` file (on your local machine) to your `cs167` server, you can refer to [Lab2](../Lab2/) for how to do this.
3. Download `nasa_19950801.tsv` in `Lab3`, upload it to your `cs167` folder. And put the file into HDFS by using:
```shell
hdfs dfs -put nasa_19950801.tsv
```
4. Now, use `hadoop jar` to run your jar file. Below is an example of running this:
```shell
hadoop jar [UCRNetID]_lab3-1.0-SNAPSHOT.jar nasa_19950801.tsv [offset] [length]
```
Your code should output the line of lines contain string `200`.

### TODO
  * ***(Q7) Some output?.***

### IX. Submission (15 minutes)

1. Add a `README.md` file ([template](CS167-Lab3-README.md)) and include all the answers to the questions above in the `README` file.
2. Add a script `run.sh` that will compile your code and run the five cases on the input file `AREAWATER_[UCRNetID].csv`
4. ***(S) Submit your compressed file as the lab deliverable.***

* Note 1: Don't forget to include your information in the README file.
* Note 2: Don't forget to remove any unnecessary test or binary files.
* Note 3: In your `run` script, you can access the current working directory to specify the full path correctly when you specify the copy command. Assuming that the input file `AREAWATER_[UCRNetID].csv` is in the current working directory, you can run one of the following commands.

### Submission file format:

```console
<UCRNetID>_lab3.{tar.gz | zip}
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

## Rubric

- Q1. +1 point
- Q2. +1 point
- Q3. +1 point
- Q4. +1 point
- Q5. +1 point
- Q6. +1 point
- Q7. +1 point
- Q8. +3 points
- Code: +4 points
  - +1 validating input correctly
  - +1 open and read the file correctly
  - +2 writing the file correctly
- Following submission instructions: +1 point

## Notes

* Make sure to follow the naming conventions that are mentioned in Lab #1.
* Do *not* include the target directory or the test input files in your submission.
* Failure to follow these instructions and conventions might result in losing some points. This includes, for example, adding unnecessary files in your compressed file, using different package names, using a different name for the compressed file, not including a runnable script, and not including a `README.md` file.
