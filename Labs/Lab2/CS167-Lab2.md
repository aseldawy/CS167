# Lab 2

## Objectives

* Write a program which can copy file across different file systems.
* Setup the Hadoop Distributed File System on your remote virtual machine.
* Compare the file copy performance of HDFS to the local file system.
* Understand the differences between the running modes of Hadoop.

## Prerequisites

* Follow the instructions in [Lab #1](../Lab1/CS167-Lab1.md) to setup the development environment on your local machine.
* Make sure you know your CS password. You will need this to connect to your remote machine, see instructions in `remote-access.md`.

## Overview

This lab asks you to write a program that simply copies a file using the HDFS API. If written correctly, the program can be run across different file systems such as local file system, HDFS, and any other supported file system without any changes. 
You are also required to use your program as a benchmark to compare the local file system and HDFS.

## Lab Work

Follow the instructions below to complete this lab. If you have any questions, please contact the TA in your lab. Make sure to answer any questions marked by the ***(Q)*** sign and submit the deliverables marked by the ***(S)*** sign.

### I. Setup (15 minutes) - In-Home Part
This part will be done in your laptop (i.e., local environment).

1. Create a new Java project using Maven for lab 2 in your `cs167/workspace` directory  either from command line or from IntelliJ. The project name should be `[UCRNetID]_lab2` (Replace `[UCRNetID]` with your UCR Net ID).
Below is the example of using command line:
```
# Replace [UCRNetID] with your UCR Net ID, not student ID.
mvn archetype:generate "-DgroupId=edu.ucr.cs.cs167.[UCRNetID]" "-DartifactId=[UCRNetID]_lab2" "-DarchetypeArtifactId=maven-archetype-quickstart" "-DinteractiveMode=false"
```
2. Open [UCRNetID]_lab2 in IntelliJ IDEA, just like in Lab1.
3. In `pom.xml` file, add dependencies for [`org.apache.hadoop:hadoop-common`](https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-common/3.3.6) and [`org.apache.hadoop:hadoop-hdfs`](https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-hdfs/3.2.2) version 3.3.6 (click the link for details). To do so, you can copy the following dependency configuration to your `pom.xml` file inside `<dependencies> </dependencies>` block:
```
# Replace [hadoop-common] and [hadoop-hdfs] with the configuration code you found in the provided links, respectively.
  <dependencies>

    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>3.8.1</version>
      <scope>test</scope>
    </dependency>

    [hadoop-common]  <-  [You need to modify here]

    [hadoop-hdfs]   <-  [You need to modify here] 

  <dependencies>

```
4. After you add new dependencies to pom.xml, you need to reload the maven project so that new dependencies can be downloaded and applied to your project in IntelliJ IDEA. To do so: `right click pom.xml (in the left project part) -> select Maven (at the bottom) -> select Sync project (at the top)`

### II. Main Program (45 minutes) - In-Home Part

This part will be done in your local laptop. You need to write a program which can copy file from one place to another place across different file systems. The input and output file will be specified by two commandline arguments.

Write a main function in `App.java` with the following specifications.

1. It should take exactly two command-line arguments: the first for the *input* file and the second for the *output* file.
2. If the number of command line arguments is incorrect, use the following code to print the error message and exit.

  ```java
  System.err.println("Incorrect number of arguments! Expected two arguments.");
  System.exit(-1);
  ```

3. Store the two arguments in local variables of type [`org.apache.hadoop.fs.Path`](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/fs/Path.html)
To do so, you need to import `org.apache.hadoop.fs.Path` in your project, and make two instances of type `Path` based on the commandline arguments.

4. Retrieve the correct file system for the two files and store in a variable of type [`org.apache.hadoop.fs.FileSystem`](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/fs/FileSystem.html). *Hint*, use the function 
[Path#getFileSystem(Configuration)](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/fs/Path.html#getFileSystem(org.apache.hadoop.conf.Configuration)) \
You may need to catch the exception when using `getFileSystem()` method to compile your code successfully.
This [link](https://www.geeksforgeeks.org/handle-an-ioexception-in-java/) will be helpful for handling the exceptions. \
You can ignore the following warnings (since they are not used):
```
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/Users/huangbo/.m2/repository/org/slf4j/slf4j-reload4j/1.7.36/slf4j-reload4j-1.7.36.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/Users/huangbo/.m2/repository/ch/qos/logback/logback-classic/1.2.10/logback-classic-1.2.10.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.slf4j.impl.Reload4jLoggerFactory]
log4j:WARN No appenders could be found for logger (org.apache.hadoop.util.Shell).
log4j:WARN Please initialize the log4j system properly.
log4j:WARN See http://logging.apache.org/log4j/1.2/faq.html#noconfig for more info.
```

5. You need to make sure the `input` file exists in the `input file system` so that you can do the copy procedure.
You can find `exists()` method by using this [link](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/fs/FileSystem.html#exists(org.apache.hadoop.fs.Path)). 
If it does not exist, use the following code to print the error message and exit.

  ```java
  // `input` is a Path variable in step 3
  System.err.printf("Input file '%s' does not exist!\n", input);
  System.exit(-1);
  ```

6. Similarly, `output` file should not exist (otherwise you will overwrite it). 
   Check whether `output` file exists in the `output file system`.
   If it already exists, use the following code to print the error message and exit. 

  ```java
  // `output` is a Path variable in step 3
  System.err.printf("Output file '%s' already exists!\n", output);
  System.exit(-1);
  ```

7. Use FileSystem API to [open](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/fs/FileSystem.html#open(org.apache.hadoop.fs.Path)) the input file and copy all its contents to the output file. Measure the total time that it takes to do this step. *Hint: Use the method [System#nanoTime()](https://docs.oracle.com/javase/8/docs/api/java/lang/System.html#nanoTime--)*


8. Use the following code to output measured results. The message shows the correct size, input, output, and total time of the copy procedure.
  You need to specify `bytesCopied`, `input`, `output`, `endTime` and `startTime` by yourself. 
  Make sure you use the same wording of the output below, otherwise you may lose points.
  ```java
  // `bytesCopied` is the actual number of bytes copied. You may need to use `long` type to avoid overflow.
  // `input` and `output` are Path in step 3.
  // `startTime` and `endTime` are the System.nanoTime() before and after the copy function.
  System.out.printf("Copied %d bytes from '%s' to '%s' in %f seconds\n",
                      bytesCopied, input, output, (endTime - startTime) * 1E-9);
  ```

9. Create a sample file `README.txt` in your project folder `[UCRNetID]_lab2/` for testing.
Set the commanline arguments inside the IDE to be `README.txt README_copy.txt`.
Then run your code in the IDE. 
Below is an example of a test run:
  ```text
  Copied 1255 bytes from 'README.txt' to 'README_copy.txt' in 0.016095 seconds
  ```

10. Pack your project into a `jar` file for future use in your remote virtual machine.
  You need to add the build information to `pom.xml` similar to `Lab1`:
  ```xml
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
  Then, pack your project in commandline by running:
  ```
  mvn package
  ```
  The generated `jar` file will be under `target/[UCRNetID]_lab2-1.0-SNAPSHOT.jar`. 
  This `jar` will be used later in your virtual machine.
  To run this jar in hadoop remotely, you need to install hadoop environment in your virtual machine.

### III. Setup your remote virtual machine for Hadoop (15 minutes)

1. You need to have a CS account to login to the cluster. If you don't have have a cs account or have forgotton the password, you can set your password as follows:
   - If you are not in a UCR-Secure network, you need to connect to UCR GlobaProtect VPN. You can follow the instructions on [`this link`](https://ucrsupport.service-now.com/ucr_portal/?id=kb_article&sys_id=47d747771bf47550f3444158dc4bcbdd&spa=1) for that.
   - Once connected to UCR's GlobalProtect VPN or on UCR-Secure Wifi, load (`password.cs.ucr.edu`)[https://password.cs.ucr.edu/] in a web browser and follow the instructions to log in to our CS Password Reset page with your UCR R'Mail account.
   - A few minutes after successfully setting your CS password, you should be able to log in CS servers via SSH using your UCR NetID as the username and the CS password you set in the previous step.
2. Follow the instruction here [`remote-access.md`](../../remote-access.md) to setup remote access to your virtual machine.

3. You need to do the rest of this lab in your remote virtual machine. 

4. Connect to your CS167 machine as shown in the instructions above.

5. Create a shell script named `setup.sh` in your home directory, put the following contents into `setup.sh`:
  ```shell
  # Setup directory
  mkdir $HOME/cs167
  cd $HOME/cs167
  
  # Download JDK-17
  curl https://download.oracle.com/java/17/archive/jdk-17.0.12_linux-x64_bin.tar.gz | tar -xz
  echo 'export JAVA_HOME=$HOME/cs167/jdk-17.0.12' >> $HOME/.bashrc
  echo 'export PATH=$PATH:$JAVA_HOME/bin' >> $HOME/.bashrc
  
  # Download Apache Maven
  curl https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz | tar -xz
  echo 'export PATH=$PATH:$HOME/cs167/apache-maven-3.9.6/bin' >> $HOME/.bashrc
  
  # Download Apache Hadoop
  curl https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz | tar -xz
  echo 'export HADOOP_HOME=$HOME/cs167/hadoop-3.3.6' >> $HOME/.bashrc
  echo 'export PATH=$PATH:$HADOOP_HOME/bin' >> $HOME/.bashrc
  ```
6. Run the shell script and then source it:
  ```shell
  bash setup.sh
  source $HOME/.bashrc
  ```
7. To verify that your machine is setup correctly, run the following commands:
  ```shell
  hadoop version
  java -version
  mvn --version
  ```
  Each of these commands should run and provide the version of Hadoop, Java, and Maven, respectively.

8. Download the file in your virtual machine and save as `AREAWATER_[UCRNetID].csv` and decompress it using the following command:
   ```shell
   wget http://bdlab.cs.ucr.edu/classes/AREAWATER.csv.bz2 -O AREAWATER_[UCRNetID].csv.bz2
   ```
   ```shell
   bzip2 -dk AREAWATER_[UCRNetID].csv.bz2
   ```

### IV. Setup and run an HDFS cluster (30 minutes) In-Lab Part
1. Edit the file `$HADOOP_HOME/etc/hadoop/core-site.xml` and add the following property inside the configuration tag.
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
    Replace `[namenode]` with the hostname of your virtual machine (i.e., class-XXX). \
    *Hint:* To edit the file, you can use `vi $HADOOP_HOME/etc/hadoop/core-site.xml` and type `i` to enable the insert mode.

2. Initialize the files for HDFS by running the command:
    ```shell
    hdfs namenode -format
    ```

3. Start the namenode by the following command, wait a few seconds to make sure that the namenode has started:
    ```shell
    hdfs namenode
    ```
    *[Important]* Once it runs successfully, keep the session open (do not quit or close the terminal). 
    Since hadoop need the namenode alive for processing.

    *Hint* It is better to run that command in a screen so it stays on even if you are disconnected. Check [this page](../../remote-access.md) for more details.

4. Start a new terminal/session, connect to your virtual environment.  
    Start the data node by running 
    ```shell
    hdfs datanode
    ```
    *[Important]* Also keep this session open (do not quit or close the terminal).
    You need datanode alive for writing data into hdfs.

    - Start a new terminal/session, connect to your virtual environment (Now you should have 3 sessions alive, one running the namenode, one running the datenode).   
    Run this command to check the status of the cluster:
    ```shell
    hdfs dfsadmin -report
    ```
    * ***(Q1) Copy the output of the command `hdfs dfsadmin -report`.***

    * ***(Q2) What is the total capacity of this cluster and how much of it is free? and how many live data nodes are there?***

### V. Use the Command-Line Interface (CLI) to Access HDFS (10 minutes) - In-Lab Part

1. List the contents in HDFS under the root directory. `hdfs dfs -ls /`
2. Create a home directory for yourself if it does not exist. `hdfs dfs -mkdir -p .`
3. Create a new empty file with your NetID as the name `touch [UCRNetID].txt`
4. Upload this file to your home directory in HDFS. `hdfs dfs -put [UCRNetID].txt`
5. List the files in your home directory. `hdfs dfs -ls`
 * ***(Q3) What is the output of the command `hdfs dfs -ls` after you copied the text file?***

6. List all available commands. `hdfs dfs`.
7. Confirm that all datanodes can see the same HDFS contents.

### VI. Run Your Program with HDFS (20 minutes) - In-Lab Part

Now, it is time to use your program to benchmark the performance of the local file system and HDFS.

1. Upload your runnable JAR file generated in Section III to your virtual machine, using this command:
   ```shell
   # On your local machine, the path to compiled jar file can be found in part2
   scp [PATH_TO_COMPILED_JAR_FILE] cs167:~
   ```
   *Alternative:* if you setup your Visual Studio Code envrionment correctly, you can connect to cs167 first, and then just drag and drop the `jar` file to the home folder using GUI interface.

2. Now, use your packed `jar` file to copy the sample file that you downloaded and decompressed, `AREAWATER_[UCRNetID].csv` to your local file system. To run your `jar` file, you will need to use `hadoop jar` command since your java code use hadoop interfaces:
  ```shell
  hadoop jar [UCRNetID]_lab2-1.0-SNAPSHOT.jar AREAWATER_[UCRNetID].csv copy.csv
  ```
  * ***(Q4) Does the program run after you change the default file system to HDFS? What is the error message, if any, that you get?***
  
  [ *Note:*  If you get this error: `"Exception in thread "main" java.lang.UnsupportedClassVersionError: edu/ucr/cs/cs167/[UCRNetID]/App has been compiled by a more recent version of the Java Runtime (class file version 61.0), this version of the Java Runtime only recognizes class file versions up to 55.0"`, you need to change your `pom.xml` file of your source code. Find the `<properties>` tag in the pom.xml and add the following blocks if not exist:
  ```xml
      <maven.compiler.source>11</maven.compiler.source>
      <maven.compiler.target>11</maven.compiler.target>
  ```
  If these two blocks already exist in your `pom.xml` file, just replace the version number with 11. After that, run `mvn clean package` from the terminal, and do step 1 of this section to send the updated jar file to your remote virtual machine.]

3. Run your program again, this time specify the full path to your local file (both input and output) and explicitly specify the local file system using [`file://`](https://en.wikipedia.org/wiki/File_URI_scheme) protocol. More concretely, use file://\`pwd`/AREAWATER_[UCRNetID].csv for the input file, and keep the output file remains unchanged.

4. Run `hdfs dfs -ls` again, now you should see the copied file in hdfs.

* ***(Q5) Verify the file size and report the running time.***

5. Make a copy of the file using your local file system command, e.g., [`cp`](https://www.unix.com/man-page/osx/1/cp/) command, and report the time, e.g., using [`time`](https://www.unix.com/man-page/osx/1/time/) command. 
```shell
time cp AREAWATER_[UCRNetID].csv copy2.csv
```
* ***(Q6) Report the running time of the `cp` command.*** 
* ***(Q7) How do the two numbers in (Q5) and (Q6) compare? (The running times of copying the file through your program and the operating system.) Explain IN YOUR OWN WORDS why you see these results.***


* ***(Q8) Use your program to test the following cases and report the running time for each case.***
    1. Copy a file from local file system to HDFS.
    2. Copy a file from HDFS to local file system.
    3. Copy a file from HDFS to HDFS.

  Note: to override the default file system in the specified path, use `hdfs://` for HDFS and `file://` for the local file system.

### VII. Submission (15 minutes)

1. Add a `README.md` file ([template](CS167-Lab2-README.md)) and include all the answers to the questions above in the `README` file.
2. Add a [table](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#tables) that shows the running time for copying the test file in the three cases mentioned above.
    * 3 test cases for Q8.
3. Add a script `run.sh` that will compile your code and run the three cases on the input file `AREAWATER_[UCRNetID].csv`
4. ***(S) Submit your compressed file as the lab deliverable.***

* Note 1: Don't forget to include your information in the README file.
* Note 2: Don't forget to remove any unnecessary test or binary files.
* Note 3: In your `run.sh` script, you can access the current working directory by using [`pwd`](https://en.wikipedia.org/wiki/Pwd).

Submission file format:

```console
<UCRNetID>_lab2.{tar.gz | zip}
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
