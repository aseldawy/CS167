# Lab 3

## Objectives

* Setup HDFS cluster and understand the differences between writing from NameNode and DataNode.
* Learn how to perform random access in HDFS.
* Understand how HDFS read a split of file.

## Prerequisites

* Follow the instructions in [Lab #1](../Lab1/CS167-Lab1.md) to setup the development environment.
* Download the file [`nasa_19950801.tsv`](nasa_19950801.tsv), [`nasa_19950630.22-19950728.12.tsv`](./nasa_19950630.22-19950728.12.tsv.gz) and place it in your local machine to be used later.

## Overview

In this lab, you will set a HDFS cluster with your group members. You will learn how to use web interface to write a file to hdfs from NameNode and DataNode, respectively. You need to be aware of the differences between these two cases.
You will write a java program, which can use the HDFS interface to perform random read on a certain split of file. 

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

2. Add `hadoop-common` and `hadoop-hdfs` dependencies as explained in [Lab 2](../Lab2/CS167-Lab2.md), and reload `pom.xml` to add the new dependencies.

3. Write a main function that takes exactly three command-line arguments; the first for the `input`(a string indicating the file), the second for `offset` (a long type integer indicating the position starts reading), and the third for `length` (a long type integer indicating the number of bytes to read).
    * *Note*: You need to parse `offset` and `length` to long type integer, try to use [`Long.parseLong`](https://docs.oracle.com/javase/8/docs/api/java/lang/Long.html#parseLong-java.lang.String-).
    * *Hint*: Try to use ChatGPT to create the main function above. We only need to parse the arguments but we will explain later how to use them.

4. If the number of command line arguments is incorrect, use the following code to print the error message and exit.
  ```java
  System.err.println("Incorrect number of arguments! Expected three arguments.");
  System.exit(-1);
  ```

5. Retreieve a `FileSystem` instance as done in the previous lab and then open `input` file using [org.apache.hadoop.fs.FSDataInputStream](https://hadoop.apache.org/docs/r3.3.1/api/org/apache/hadoop/fs/FSDataInputStream.html). You may refer to [Lab2](../Lab2/CS167-Lab2.md) for how to open a file  using the HDFS API. Use [`FSDataInputStream.seek`](https://hadoop.apache.org/docs/r3.3.1/api/org/apache/hadoop/fs/FSDataInputStream.html#seek-long-) to find the start position. If `offset` is not 0, you need to skip to content until meet a newline character. Feel free to use the following helper function to read a line from the input stream.
  ```Java
  public static String readLine(FSDataInputStream input) throws IOException {
    StringBuffer line = new StringBuffer();
    int value;
    do {
      value = input.read();
      if (value != -1)
        line.append((char)value);
    } while (value != -1 && value != 13 && value != 10);
    return line.toString();
  }
  ```

6. Use the function [`FSDataInputStream#getPos`](https://hadoop.apache.org/docs/r3.3.1/api/org/apache/hadoop/fs/FSDataInputStream.html#getPos--)
  to track the current position in the file. End the reading process when the position exceeds the `offset+length` as described in class.
  Pay attention to the special case that was discussed in class, i.e., when the line perfectly aligns with the end of the split.
  At the end, print the following statements to indicate the split length and the actual number of bytes read.
  ```java
  System.out.println("Split length: "+ length);
  System.out.println("Actual bytes read: "+ (inputStream.getPos() - offset));
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

8. Modify your code, so that it will output the number of lines containing string `200`. Using the function [`String#contains`] for that.
  Your output should be the same as the following format `numMatchingLines` is the number of lines contain string `200`:
  ```Java
  System.out.println("Number of matching lines: " + numMatchingLines);
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

### II. Setup HDFS Cluster (10 minutes) - In-lab part - Group Activity
This part will be done on the `cs167` server.
In this part, you need to set up a HDFS cluster with your group members. 

1. Identify all members of your group. You will find the group information in Canvas. 
Each member should find their machine name by running the command `hostname` with format `class-xxx` after they are logged in to their `cs167` machine.
2. By convention, we will use the machine with the *lowest* hostname number as the namenode, and others will be the datanodes.
3. All group members need to modify `$HADOOP_HOME/etc/hadoop/core-site.xml`, so that all machines are in the same cluster. 
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
    * *Note*: Replace `[namenode]` with the `hostname` of the machine that you selected as the namenode. After this step, the `core-site.xml` file should look identical across all machines. Make sure there are no additional spaces in the name and value.
  
4. Also, all group members need to modify `$HADOOP_HOME/etc/hadoop/hdfs-site.xml` so that you change the default replication factor.
Edit `$HADOOP_HOME/etc/hadoop/hdfs-site.xml`, and add the following property inside the configuration tag:
```xml
  <property>
      <name>dfs.replication</name>
      <value>3</value>
  </property>
```
5. On the `namenode`, initialize the files for HDFS by running the command (*Note*: Make sure that you run this command `only on the namenode`):
```shell
 hdfs namenode -format
```
6. On the `namenode`: start the namenode by running:
```shell
hdfs namenode
``` 
Wait a few seconds to make sure that the namenode has started.

7. On each of the datanodes: start the data node by running:
```shell
hdfs datanode
```
  * *Note*: if you can the following error, you can **check the solution at the bottom** of this instruction:
    ```shell
    java.io.IOException: Incompatible clusterIDs in /home/cs167/hadoop/dfs/data: namenode clusterID = CID-ca13b215-c651-468c-9188-bcdee4ad2d41; datanode clusterID = CID-d9c134b6-c875-4019-bce0-2e6f8fbe30d9
    ```

8. Run this command to check the status of the cluster
 ```shell
   hdfs dfsadmin -report
   ```
* ***(Q2) Copy the output of this command.***
* ***(Q3) How many live datanodes are in this cluster?***

### III. Understand HDFS Write Behavior (20 minutes) - In-lab part - Group Activity
This part will be done on the `cs167` server (continue to part II).
In this part, you need to write to HDFS from namenode and datanode.  

1. Make sure your `namenode` and `datanodes` are running on the `cs167` server.
    * *Note*: Nothing need to be done if you follow part1.

2. On the `namenode` machine, run the following command to copy `AREAWATER_[UCRNetID].csv` from your local file system to HDFS:
```shell
# Replace [UCRNetID] with the netid of the student owning this namenode
hdfs dfs -put AREAWATER_[UCRNetID].csv
```
  * *Note*: If you get error message saying 'no such file or directory', create a directory in HDFS by using:
    ```shell
    hdfs dfs -mkdir -p .
    ```


3. On the `namenode` machine, run the following command to find the block locations of the file you just uploaded:
```shell
# Replace [UCRNetID] with the netid of student owning this the namenode
hdfs fsck AREAWATER_[UCRNetID].csv  -files -blocks -locations
```
* ***(Q4) How many replicas are stored on the namenode? How many replicas are stored in the datanodes?***
  * *Note* You can find the datanode ip/information by using the command:
  ```shell
  hdfs dfsadmin -report
  ```

4. Now, on each `datanode` machine, repeat step 2 and step 3 to upload the file to HDFS and observe the block replica distribution.
    * *Note*: you need to change [UCRNetID] to the netid of student owning this datanode.

* ***(Q5) How many replicas are stored on the datanode uploading the file? How many replicas are stored across other datanodes?***

* ***(Q6) Compare your results of Q4 and Q5, give one sentence to explain the results you obtained.***

### IV. Test your code in HDFS (10 minutes) - In-lab Part - Group Activity
This part will be done in `cs167` server.
You will use your packed `jar` file to read from HDFS.

1. Make sure the namenode and datanodes are running.
2. Upload your `jar` file (on your local machine) to your `cs167` server, you can refer to [Lab2](../Lab2/CS167-Lab2.md) for how to do this.
3. Download `nasa_19950801.tsv` in `Lab3`, upload it to your `cs167` folder. And put the file into HDFS by using:
  ```shell
  hdfs dfs -put nasa_19950801.tsv
  ```
4. Now, use `hadoop jar` to run your jar file. Below is an example of running this:
  ```shell
  hadoop jar [UCRNetID]_lab3-1.0-SNAPSHOT.jar nasa_19950801.tsv [offset] [length]
  ```
  Your code should output the number of lines contain string `200`.

5. Test with the following input parameters with the input file `nasa_19950801.tsv`:

  | offset | length |
  | ------ | ------ |
  | 500    | 1000   |
  | 12000  | 1000   |
  | 100095 | 1000   |
  ***(Q7) Include the output of the three cases above in your README file.***

6. Test on larger dataset. Now you need to test your code on larger dataset. Download [`nasa_19950630.22-19950728.12.tsv.gz`](./nasa_19950630.22-19950728.12.tsv.gz) to your local computer.  
Upload the downloaded file `nasa_19950630.22-19950728.12.tsv.gz` to your `cs167` server home directory.  
Use the following command to decompress it:  
```shell
gunzip nasa_19950630.22-19950728.12.tsv.gz
```

7. Put the file `gunzip nasa_19950630.22-19950728.12.tsv` to HDFS, similar to step 3.

8. Test your program with the following input parameters on `nasa_19950630.22-19950728.12.tsv`:

| offset | length |
| ------ | ------ |
| 1500   | 2000   |
| 13245  | 3500   |
| 112233 | 4000   |

Write a shell script named `run.sh`, which contains the commands you run the above three cases on `nasa_19950630.22-19950728.12.tsv`.

### V. Submission (15 minutes)

1. Add a `README.md` file ([template](CS167-Lab3-README.md)) and include all the answers to the questions above in the `README` file.
2. Add a script `run.sh` that will compile your code and run the three cases mentioned above on the file `nasa_19950630.22-19950728.12.tsv`
3. ***(S) Submit your compressed file as the lab deliverable.***

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
- Q7. +3 point
- Code: +5 points
  - +1 validating input correctly
  - +1 open and read the file correctly
  - +3 handle all the test cases correctly
- Following submission instructions: +1 point

## Notes

* Make sure to follow the naming conventions that are mentioned in Lab #1.
* Do *not* include the target directory or the test input files in your submission.
* Failure to follow these instructions and conventions might result in losing some points. This includes, for example, adding unnecessary files in your compressed file, using different package names, using a different name for the compressed file, not including a runnable script, and not including a `README.md` file.

## Common Errors:

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
2. Delete the directory `~/hadoop` on *the namenode and all datanodes*. `rm -rf ~/hadoop`.
3. Reformat HDFS using the command `hdfs namenode -format` only on the namenode.
4. Start the namenode using the command `hdfs namenode`.
5. Start the datanode using the command `hdfs datanode`.
