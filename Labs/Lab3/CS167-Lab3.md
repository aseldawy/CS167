# Lab 3

## Objectives

* Understand the differences between the running modes of Hadoop.
* Setup the Hadoop Distributed File System on your local development machine.
* Compare the performance of HDFS to the local file system.

## Prerequisites

* Follow the instructions in [Lab #1](../Lab1/CS167-Lab1.md) to setup the development environment.
* Download this [Sample File](http://bdlab.cs.ucr.edu/classes/AREAWATER.csv.bz2)
 and decompress it. We will use it for testing.
  * Linux: Run `tar xfj AREAWATER.csv.bz2` or `bzip2 -dk AREAWATER.csv.bz2` if previous one not work
  * macOS: Use Archive Utility, or run `bzip2 -dk AREAWATER.csv.bz2`
  * Windows: You may use 7-zip.
* Make sure you know your CS password. You will need this to connect to your remote machine, see instructions in take .

## Overview

This lab asks you to write a program that simply copies a file using the HDFS API. If written correctly, the program will run on the local file system, HDFS, and any other supported file system without any changes. You are also required to use your program as a benchmark to compare the local file system and HDFS.

## Lab Work

Follow the instructions below to complete this lab. If you have any questions, please contact the TA in your lab. Make sure to answer any questions marked by the ***(Q)*** sign and submit the deliverables marked by the ***(S)*** sign.

### I. Setup (30 minutes) - In-home part

1. Create a new Java project using Maven for lab 3 either from command line or from IntelliJ. The project name should be `[UCRNetID]_lab3` (Replace `[UCRNetID]` with your UCR Net ID).
2. In `pom.xml` file, add dependencies for [`org.apache.hadoop:hadoop-common`](https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-common/3.3.6) and [`org.apache.hadoop:hadoop-hdfs`](https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-hdfs/3.2.2) version 3.3.6.
3. You need to have a CS account to login to the cluster. If you don't have have a cs account or have forgotton the password, you can set your password as follows:
   - If you are not in a UCR-Secure network, you need to connect to UCR GlobaProtect VPN. You can follow the instructions on [`this link`](https://ucrsupport.service-now.com/ucr_portal/?id=kb_article&sys_id=47d747771bf47550f3444158dc4bcbdd&spa=1) for that.
   - Once connected to UCR's GlobalProtect VPN or on UCR-Secure Wifi, load (`password.cs.ucr.edu`)[https://password.cs.ucr.edu/] in a web browser and follow the instructions to log in to our CS Password Reset page with your UCR R'Mail account.
   - A few minutes after successfully setting your CS password, you should be able to log in CS servers via SSH using your UCR NetID as the username and the CS password you set in the previous step.
4. Follow the instruction here [`remote-access.md`](https://github.com/aseldawy/CS167/blob/lab3/remote-access.md) to setup remote access to your virtual machine.


### II. Main Program (45 minutes) - In-home part

Write a main function with the following specifications.

1. It should take exactly two command-line arguments; the first for the *input* file and the second for the *output* file.
2. If the number of command line arguments is incorrect, use the following code to print the error message and exit.

  ```java
  System.err.println("Incorrect number of arguments! Expected two arguments.");
  System.exit(-1);
  ```

3. Store the two arguments in local variables of type [`org.apache.hadoop.fs.Path`](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/fs/Path.html)
4. Retrieve the correct file system for the two files and store in a variable of type [`org.apache.hadoop.fs.FileSystem`](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/fs/FileSystem.html). *Hint*, use the function [Path#getFileSystem(Configuration)](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/fs/Path.html#getFileSystem(org.apache.hadoop.conf.Configuration))
5. Check whether the input file [exists](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/fs/FileSystem.html#exists(org.apache.hadoop.fs.Path)) or not. If it does not exist, use the following code to print the error message and exit.

  ```java
  // `input` is a Path variable in step 3
  System.err.printf("Input file '%s' does not exist!\n", input);
  System.exit(-1);
  ```

6. Similarly, check whether the output file exists or not. If it already exists, use the following code to print the error message and exit.

  ```java
  // `output` is a Path variable in step 3
  System.err.printf("Output file '%s' already exists!\n", output);
  System.exit(-1);
  ```

7. Use FileSystem API to [open](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/fs/FileSystem.html#open(org.apache.hadoop.fs.Path)) the input file and copy all its contents to the output file. Measure the total time that it takes to do this step. *Hint: Use the method [System#nanoTime()](https://docs.oracle.com/javase/8/docs/api/java/lang/System.html#nanoTime--)*
8. Write a message similar to the following to the standard output.

  ```text
  Copied 1255 bytes from 'README' to 'README_copy' in 0.016095 seconds
  ```

  The message should show the correct size, input, output, and total time according to how the program ran. Make sure you use the same wording of the output above or you may lose points. You may use the following code.
  
  ```java
  // `bytesCopied` is the actual number of bytes copied. You may need to use `long` type to avoid overflow.
  // `input` and `output` are Path in step 3.
  // `startTime` and `endTime` are the System.nanoTime() before and after the copy function.
  System.out.printf("Copied %d bytes from '%s' to '%s' in %f seconds\n",
                      bytesCopied, input, output, (endTime - startTime) * 1E-9);
  ```

### III. Benchmark Local File System performance (In lab) (10 minutes)

Now, it is time to use your program to benchmark the performance of the local file system and HDFS.

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
    * 3 test cases for Q7.
    * (Bonus) 2 test cases for Q8.
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
