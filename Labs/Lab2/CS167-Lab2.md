# Lab 2

## Objectives

* Understand the differences between the running modes of Hadoop.
* Setup the Hadoop Distributed File System on your local development machine.
* Compare the performance of HDFS to the local file system.

## Prerequisites

* Follow the instructions in [Lab #1](../Lab1/CS167-Lab1.md) to setup the development environment.
* If you prefer to use a virtual machine, you can follow the instructions on [this page](../../VirtualMachineSetup.md)
* Download this [Sample File](https://drive.google.com/file/d/0B1jY75xGiy7eR3VpNC1XMzB5cWs/view)
 and decompress it. We will use it for testing.
  * Linux and MacOS: To unarchive, run `tar xvfj AREAWATER.csv.bz2`
  * Windows: You may use 7-zip.

## Overview

This labs asks you to write a program that simply copies a file using the HDFS API. If written correctly, the program will run on the local file system, HDFS, and any other supported file system without any changes. You are also required to use your program as a benchmark to compare the local file system and HDFS.

## Lab Work

Follow the instructions below to complete this lab. If you have any questions, please contact the TA in your lab. Make sure to answer any questions marked by the ***(Q)*** sign and submit the deliverables marked by the ***(S)*** sign.

### I. Setup (10 minutes) - In-home part

1. Create a new Java project using Maven for lab 2 either from command line or from IntelliJ. The project name should be `<UCRNetID>_lab2` (Replace `<UCRNetID>` with your UCR Net ID).
2. In `pom.xml` file, add dependencies for [`org.apache.hadoop:hadoop-common`](https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-common) and [`org.apache.hadoop:hadoop-hdfs`](https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-hdfs):
   * Linux and MacOS: Version 3.2.3, [hadoop-common](https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-common/3.2.3) and [hadoop-hdfs](https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-hdfs/3.2.3)
   * Windows: Version 3.2.2, [hadoop-common](https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-common/3.2.2) and [hadoop-hdfs](https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-hdfs/3.2.2)

### II. Main Program (45 minutes) - In-home part

Write a main function with the following specifications.

1. It should take exactly two command-line arguments; the first for the *input* file and the second for the *output* file.
2. If the number of command line arguments is incorrect, use the following code to print the error message and exit.

    ```java
    System.err.println("Incorrect number of arguments! Expected two arguments.");
    System.exit(-1);
    ```

3. Store the two arguments in local variables of type [`org.apache.hadoop.fs.Path`](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/fs/Path.html)
4. Retrieve the correct file system for the two files and store in a variable of type [`org.apache.hadoop.fs.FileSystem`](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/fs/FileSystem.html). *Hint, use the function [Path#getFileSystem(Configuration)](https://hadoop.apache.org/docs/stable/api/org/apache/hadoop/fs/Path.html#getFileSystem(org.apache.hadoop.conf.Configuration))*
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

### III. Benchmark Local File System performance (10 minutes)

Now, it is time to use your program to benchmark the performance of the local file system and HDFS.

1. Compile your program into a runnable JAR file via `mvn package` command.
2. Test your program on a small file, e.g., a `README` file to make sure that it works correctly.
3. Now, test it on the sample file that you downloaded and unarchived, `AREAWATER.csv`.
    * ***(Q1) Verify the file size and record the running time.***
4. Make a copy of the file using your file system command, e.g., [`cp`](https://www.unix.com/man-page/osx/1/cp/) command in Linux and MacOS, or [`copy`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/copy) command in Windows, and record the time, e.g., using [`time`](https://www.unix.com/man-page/osx/1/time/) command on Linux and MacOS, or using [`Measure-Command`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/measure-command) command on Windows PowerShell (or Windows Terminal, this command does not work in CMD).
    * ***(Q2) Record the running time of the copy command.***
5. ***(Q3) How do the two numbers compare? (The running times of copying the file through your program and the operating system.) Explain IN YOUR OWN WORDS why you see these results.***

### IV. Configure and Run HDFS (20 minutes)

To run HDFS, you need at least one name node and one data node.

1. Configure Hadoop to use HDFS as the default filesystem. Add the following lines to `$HADOOP_HOME/etc/hadoop/core-site.xml`

    ```xml
    <property>
      <name>fs.defaultFS</name>
      <value>hdfs://localhost:9000</value>
    </property>
    ```

2. Initialize the files for HDFS by running the command `hdfs namenode -format`
3. Start the master node by running `hdfs namenode`
4. Start the data node by running `hdfs datanode`

*Note: You will need to run the name node and data node in two separate tabs/windows. Keep them open so you can see their progress as your program runs.*

### V. Use the Command-Line Interface (CLI) to Access HDFS (20 minutes)

1. List the contents in HDFS under the root directory. `hdfs dfs -ls /`
2. Create a home directory for yourself if it does not exist. `hdfs dfs -mkdir -p .`
3. Upload a small file, e.g., a `README` file to your home directory in HDFS. `hdfs dfs -put <filename>`
4. List the files in your home directory. `hdfs dfs -ls`
5. List all available commands. `hdfs dfs`

### VI. Run Your Program with HDFS (20 minutes)

1. Run your program again from the command line to copy the file. You will need to use the `hadoop` command as was shown in Lab 1.
    * ***(Q4) Does the program run after you change the default file system to HDFS? What is the error message, if any, that you get?***
2. Run your program again, this time specify the full path to your local file (both input and output) and explicitly specify the local file system using [`file://`](https://en.wikipedia.org/wiki/File_URI_scheme) protocol.
3. ***(Q5) Use your program to test the following cases and record the running time for each case.***
    1. Copy a file from local file system to HDFS
    2. Copy a file from HDFS to local file system.
    3. Copy a file from HDFS to HDFS.

Note: to explicitly specify the HDFS file system, use the scheme `hdfs://` followed by the absolute path. For example:

```bash
# Linux and MacOS local file
file:///Users/your_user/cs167/netid_lab2/AREAWATER.csv

# Windows local file
file:///C:/cs167/netid_lab2/AREAWATER.csv

# HDFS
hdfs://localhost:9000/user/your_user/AREAWATER.csv
# Or
hdfs:///user/your_user/AREAWATER.csv
```

### VII. Bonus Task (30 minutes) +3 points

1. Build a separate main class `AppB` that takes one input file. The main class should do the following steps.
    1. Make sure that the file already exists.
    2. Make 10,000 reads from the file at random positions. Each one should read 8,192 bytes. You can discard the bytes that you read immediately after they are read.
    3. Measure the total time needed to do the 10,000 reads.
    * ***(Q6) Test your program on two files, one file stored on the local file system, and another file stored on HDFS. Compare the running times of both tasks. What do you observe?***
        * The file on the local file system and on HDFS should be the same file, and the file must be large enough. You may use `AREAWATER.csv` for this task.
2. Update your `run.sh` script to run the AppB class after the previous one. Since a JAR file cannot have two main classes, you will need to modify your running commands to explicitly specify the main class in each case.
Additionally, you will need to remove the main class in `maven-jar-plugin` plugin from your `pom.xml` configuration file.

### VIII. Submission (15 minutes)

1. Add a `README.md` file ([template](https://raw.githubusercontent.com/aseldawy/CS167/master/Labs/Lab2/CS167-Lab2-README.md)) and include all the answers to the questions above in the `README` file.
2. Add a [table](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#tables) that shows the running time for copying the test file in the three or five cases mentioned above.
    * 3 test cases for Q5.
    * (Bonus) 2 test cases for Q6.
3. Add a script `run.sh` that will compile your code and run the five cases on the input file `AREAWATER.csv`
4. ***(S) Submit your compressed file as the lab deliverable.***

* Note 1: Don't forget to include your information in the README file.
* Note 2: Don't forget to remove any unnecessary test or binary files.
* Note 3: In your `run` script, you can access the current working directory to specify the full path correctly when you specify the copy command. Assuming that the input file `AREAWATER.csv` is in the current working directory, you can run one of the following commands.

In a Linux shell script:

```shell
hadoop jar <JARFILE> file://`pwd`/AREAWATER.csv hdfs:///AREAWATER.csv
```

In a Windows PowerShell script:

```PowerShell
hadoop jar <JARFILE> file:///$pwd/AREAWATER.csv hdfs:///AREAWATER.csv
```

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

## Notes

* Make sure to follow the naming conventions that are mentioned in Lab #1.
* Do *not* include the target directory or the test input files in your submission.
* Failure to follow these instructions and conventions might result in losing some points. This includes, for example, adding unnecessary files in your compressed file, using different package names, using a different name for the compressed file, not including a runnable script, and not including a `README.md` file.
