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

Follow the instructions below to complete this lab. If you have any questions, please contact the TA in your lab. Make sure to answer any questions marked by the ***(Q)*** sign and submit the deliverables marked by the ***(S)*** sign.

### I. Setup HDFS Cluster (10 minutes) - In-lab part
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
* ***(Q1) Copy the output of this command.***
* ***(Q2) How many lived datanodes are in this cluster?***

### II. Understand HDFS Write Behavior
This part will be done on the `cs167` server (continue to part 1).
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
* ***(Q3) How many replicas are stored on the namenode? How many replicas are stored in the datanodes?***

4. Now on each `datanode` machine, repeat step 2 and step 3 to upload the file to HDFS and observe the block replica distribution.
    * *Note*: you need to change [UCRNetID] to the netid of student owning this datanode.

* ***(Q4) How many replicas are stored on the datanode uploading the file? How many replicas are stored across other datanodes?***

* ***(Q5) Compare your results of Q4 and Q5, give one sentence to explain the results you obtained.***


### III. Main Program (45 minutes) - In-home part
This part will be done in your `local laptop`.
In this part, you will write a Java program which can simulate how HDFS performs random read to a file. 

1. Create a new Java project using Maven for lab 3 in your `cs167/workspace` directory either from command line or from IntelliJ. The project name should be [UCRNetID]_lab3. Below is the example of using command line:
```shell
# Replace [UCRNetID] with your UCR Net ID, not student ID.
mvn archetype:generate "-DgroupId=edu.ucr.cs.cs167.[UCRNetID]" "-DartifactId=[UCRNetID]_lab3" "-DarchetypeArtifactId=maven-archetype-quickstart" "-DinteractiveMode=false"
```

2. Your program should take exactly three command-line arguments; the first for the `input`(a string indicating the file), the second for `offset` (a long type integer indicating the position starts reading), and the third for `length` (a long type integer indicating the number of bytes to read).
    * *Note*: You need to parse `offset` and `length` to integer, try to use [`Long.parseLong`](https://docs.oracle.com/javase/8/docs/api/java/lang/Long.html#parseLong-java.lang.String-).

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
if (offset != 0) {  // As introduced in class, if offset is 0, directly read that file. Otherwise, until meet a newline character.
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
* ***(Q5) Compare `bytesRead` and `length`, are they equal? Use one sentance to explain why.***

8. Modify your code, so that it will output the number of line contains string `200`.
Your output should 

### III. Modify Your Code for Counting Lines (10 minutes)

1. Compile your program into a runnable JAR file via `mvn package` command.
2. Test your program on a small file, e.g., a `README` file to make sure that it works correctly.
3. Now, test it on the sample file that you downloaded and decompressed, `AREAWATER.csv`.
    * ***(Q1) Verify the file size and report the running time.***
4. Make a copy of the file using your file system command, e.g., [`cp`](https://www.unix.com/man-page/osx/1/cp/) command in Linux and macOS, or [`copy`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/copy) command in Windows, and report the time, e.g., using [`time`](https://www.unix.com/man-page/osx/1/time/) command on Linux and macOS, or using [`Measure-Command`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/measure-command) command on Windows PowerShell (or Windows Terminal, this command does not work in CMD).
    * ***(Q2) Report the running time of the copy command.***
5. ***(Q3) How do the two numbers in (Q1) and (Q2) compare? (The running times of copying the file through your program and the operating system.) Explain IN YOUR OWN WORDS why you see these results.***

### IV. Setup your remote machine for Hadoop (15 minutes)
1. Connect to your remote machine through SSH. Your machine is accessible through bolt.cs.ucr.edu.
2. Connect to bolt.cs.ucr.edu by running the command:
  ```
  ssh [UCRNetID]@bolt.cs.ucr.edu
  ```
  Use your CS password when asked.
3. Once connected to bolt, run the command `cs167_login` to connect to your machine.
4. Create a `setup.sh` file in your home directory as below:
  ```shell
  # Setup directory
  mkdir $HOME/cs167
  cd $HOME/cs167
  echo export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 >> $HOME/.bashrc
  # Download Apache Maven
  curl https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz | tar -xz
  echo 'export PATH=$PATH:$HOME/cs167/apache-maven-3.9.6/bin' >> $HOME/.bashrc
  # Download Apache Hadoop
  curl https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz | tar -xz
  echo 'export HADOOP_HOME=$HOME/cs167/hadoop-3.3.6' >> $HOME/.bashrc
  echo 'export PATH=$PATH:$HADOOP_HOME/bin' >> $HOME/.bashrc
  ```
5. Run the file you just created and reload `.bashrc` to update the environment variables.
  ```shell
  bash setup.sh
  source $HOME/.bashrc
  ```
6. To verify that your machine is setup correctly, run the following commands:
  ```shell
  hadoop version
  java -version
  mvn --version
  ```
  Each of these commands should run and provide the version of Hadoop, Java, and Maven, respectively.

### V. Setup and run an HDFS cluster (30 minutes)
1. Identify all members of your group. You will find the group information in this [`link`](https://docs.google.com/spreadsheets/d/1PdQmX-rVydvSvrBM04_XMaIZZ4RJ-z63xql1fdotuSM/edit?usp=sharing). 
2. Each member should find their machine name by running the command `hostname` after they are logged in to their machine. It should be in the format of `class-xxx`.
3. By convention, we will use the machine with the lowest number as the namenode. All the others will be the datanodes.
4. For all machines, namenode and datanodes, edit the file `$HADOOP_HOME/etc/hadoop/core-site.xml` and add the following property inside the configuration tag.
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
    Replace `[namenode]` with the hostname of the machine that you selected as the namenode. After this step, the core-site.xml file should look identical in all machines. Make sure there are no additional spaces in the name and value.

    *Hint:* To edit the file, you can use `vi $HADOOP_HOME/etc/hadoop/core-site.xml` and type `i` to enable the insert mode.
5. Initialize the files for HDFS by running the command `hdfs namenode -format` on the namenode. Make sure that you run this command only on the namenode. None of the datanodes should run this command.
6. On the namenode: start the namenode by running `hdfs namenode`. Wait a few seconds to make sure that the namenode has started.
7. On each of the datanodes: start the data node by running `hdfs datanode`
8. Run this command to check the status of the cluster
 ```shell
   hdfs dfsadmin -report
   ```
 * ***(Q4) Copy the output of this command.***

 * ***(Q5) What is the total capacity of this cluster and how much of it is free? and how many live data nodes are there?***

### VI. Use the Command-Line Interface (CLI) to Access HDFS (10 minutes)

1. List the contents in HDFS under the root directory. `hdfs dfs -ls /`
2. Create a home directory for yourself if it does not exist. `hdfs dfs -mkdir -p .`
3. Create a new empty file with your NetID as the name `touch [UCRNetID].txt`
4. Upload this file to your home directory in HDFS. `hdfs dfs -put [UCRNetID].txt`
5. List the files in your home directory. `hdfs dfs -ls`
 * ***(Q6) What is the output of this command?***

7. List all available commands. `hdfs dfs`.
8. Confirm that all datanodes can see the same HDFS contents.

### VII. Run Your Program with HDFS (20 minutes)
1. Upload your runnable JAR file generated in Section III to your virtual machine, using this command:
   ```shell
   scp -J [UCRNetID]@bolt.cs.ucr.edu [PATH_TO_COMPILED_JAR_FILE] cs167@class-###.cs.ucr.edu:~
   ```
   Note: class-### is the hostname of your virtual machine.

   *Alternative 1:* if you setup your Visual Studio Code envrionment correctly, you can just drag and drop the file to the home folder using its interface.

   *Alternative 2:* if your config file is setup correctly, you can run this simpler command:
   ```shell
   scp [PATH_TO_COMPILED_JAR_FILE] cs167:~
   ```
3. Download the file in your virtual machine and save as `AREAWATER_[UCRNetID].csv` and decompress it using this:
   ```shell
   wget http://bdlab.cs.ucr.edu/classes/AREAWATER.csv.bz2 -O AREAWATER_[UCRNetID].csv.bz2
   bzip2 -dk AREAWATER_[UCRNetID].csv.bz2
   ```
4. Run your program again from the command line to copy the file (``). You will need to use the `hadoop` command as was shown in Lab 1.
    * ***(Q7) Does the program run after you change the default file system to HDFS? What is the error message, if any, that you get?***
  
[ *Note:*  If you get this error: "Exception in thread "main" java.lang.UnsupportedClassVersionError: edu/ucr/cs/cs167/[UCRNetID]/App has been compiled by a more recent version of the Java Runtime (class file version 61.0), this version of the Java Runtime only recognizes class file versions up to 55.0", you need to change your `pom.xml` file of your source code. Find the `<properties>` tag in the pom.xml and add the following blocks if not exist:
```xml
    <maven.compiler.source>11</maven.compiler.source>
    <maven.compiler.target>11</maven.compiler.target>
```
If these two blocks already exist in your `pom.xml` file, just replace the version number with 11. After that, run `mvn clean package` from the terminal, and do step 1 of this section to send the updated jar file to your remote virtual machine.]

5. Run your program again, this time specify the full path to your local file (both input and output) and explicitly specify the local file system using [`file://`](https://en.wikipedia.org/wiki/File_URI_scheme) protocol.
6. ***(Q8) Use your program to test the following cases and report the running time for each case.***
    1. Copy a file from local file system to HDFS.
    2. Copy a file from HDFS to local file system.
    3. Copy a file from HDFS to HDFS.

Note: to explicitly specify the HDFS file system, use the scheme `hdfs://` followed by the absolute path.

### VIII. Bonus Task (30 minutes) +3 points

1. Build a separate main class `AppB` that takes one input file. The main class should do the following steps.
    1. Make sure that the file already exists.
    2. Make 10,000 reads from the file at random positions. Each one should read 8,192 bytes. You can discard the bytes that you read immediately after they are read.
    3. Measure the total time needed to do the 10,000 reads.
    * ***(Q9) Test your program on two files, one file stored on the local file system, and another file stored on HDFS. Compare the running times of both tasks. What do you observe?***
        * The file on the local file system and on HDFS should be the same file, and the file must be large enough. You may use `AREAWATER_[UCRNetID].csv` for this task.
2. Update your `run.sh` script to run the AppB class after the previous one. Since a JAR file cannot have two main classes, you will need to modify your running commands to explicitly specify the main class in each case.
Additionally, you will need to remove the main class in `maven-jar-plugin` plugin from your `pom.xml` configuration file.

### IX. Submission (15 minutes)

1. Add a `README.md` file ([template](CS167-Lab2-README.md)) and include all the answers to the questions above in the `README` file.
2. Add a [table](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#tables) that shows the running time for copying the test file in the three or five cases mentioned above.
    * 3 test cases for Q8.
    * (Bonus) 2 test cases for Q9.
3. Add a script `run.sh` that will compile your code and run the five cases on the input file `AREAWATER_[UCRNetID].csv`
4. ***(S) Submit your compressed file as the lab deliverable.***

* Note 1: Don't forget to include your information in the README file.
* Note 2: Don't forget to remove any unnecessary test or binary files.
* Note 3: In your `run` script, you can access the current working directory to specify the full path correctly when you specify the copy command. Assuming that the input file `AREAWATER_[UCRNetID].csv` is in the current working directory, you can run one of the following commands.

In a Linux shell script:

```shell
hadoop jar <JARFILE> file://`pwd`/AREAWATER_[UCRNetID].csv hdfs:///AREAWATER_[UCRNetID].csvcsv
```

In a Windows PowerShell script:

```PowerShell
hadoop jar <JARFILE> file:///$pwd/AREAWATER_[UCRNetID].csv hdfs:///AREAWATER_[UCRNetID].csv
```

Submission file format:

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
