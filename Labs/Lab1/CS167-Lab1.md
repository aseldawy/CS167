# Lab 1

## Objectives

- Set up the development environment for Java.
- Run a test program on Hadoop within the IDE.
- Package the source code of your project in a compressed form.
- Write a script that compiles, tests, and runs your project.

## Pre-lab
Before the lab, complete the following steps to be ready for the lab.
1. If you want to use the virtual machine, download the virutal machine image at [this link](https://coursefiles.cs.ucr.edu/cs167-S22.ova).
2. If you want to use the virtual machine, download and setup VirtualBox at [this link](https://www.virtualbox.org/wiki/Downloads).
3. Follow the instructions on [this page](../../VirtualMachineSetup.md) to setup the virutal machine.
4. Download JDK 17 from [this link](https://www.oracle.com/java/technologies/downloads/#java17) and make sure to get the version suitable for your OS.
5. Download [Apache Maven binaries](https://maven.apache.org/download.cgi).
6. Download [IntelliJ IDEA Community Edition](https://www.jetbrains.com/idea/download/).

If you have troubles with setting up the virtual machine, bring your questions to the lab.

## Lab Work

Follow the instructions below to complete this lab. If you have any questions, please contact the TA in your lab. Make sure to answer any questions marked by the ***(Q)*** sign and submit the deliverables marked by the ***(S)*** sign. You must answer the questions at the right step to get the correct output. Do *not* wait until you finish all the steps and then answer the questions.

---

### 1. Install Required Software

1. Make sure your user name does not have any space. Otherwise, create a user without space.
2. Create a writable folder with no space in the path, for example:
    - Linux and macOS: "`$HOME/cs167`", where `$HOME` is your home directory
    - Windows: "`%HomeDrive%%HomePath%\cs167`", where `%HomeDrive%%HomePath%` is typically `C:\Users\<username>\`
3. From this point on, we will call this directory *the course directory*.

#### Oracle JDK 17
We will use JDK as our SDK to compile Java and Scala code in this course.

 1. Download the compressed archive that is right for your operating system from the [JDK download page](https://www.oracle.com/java/technologies/downloads/#java17).\\
    *Note*: For Mac users, make sure to choose ARM64 if your device runs on an M* chip and x64 if it runs on Intel.
 2. Decompress the archive in the course directory.

#### Apache Maven
Apache Maven is a Java-based project management software. It makes it easier to compile and package your code.

  1. Download the binary archive from [Maven download page](https://maven.apache.org/download.cgi).
  2. Unarchive it to the course directory.

#### IntelliJ IDEA Community Edition
IntelliJ IDEA is the recommended IDE to use in this course. While you can run with other IDEs, e.g., Eclipse, it will be easier if we all use the same IDE.

  1. Download the binary archive from the [download page](https://www.jetbrains.com/idea/download/).
  2. Make sure to download the version that is suitable for your operating system and hardware.
  3. You will need to scroll down a little bit to download the free Community Edition. Do not download the Ultimate Edition.
  4. For Windows, download the compressed archive `.zip`.
  5. For Linux, download the compressed archive `.tar.gz`
  6. For MacOS, download the `.dmg` installer that is right for your hardward.
  7. For Windows and Linux, extract the binaries to the course page. For MacOS, mount the `.dmg` installer and follow the instructions to install the software.

#### Apache Hadoop
Hadoop binaries will be used to run big-data systems.
1. Download the binaries for Hadoop 3.3.6 from [Hadoop download page](https://hadoop.apache.org/releases.html).
2. Extract the compressed archive to the course directory.
3. *For Windows users only*, patch the binaries of Hadoop, otherwise some Hadoop related functions will fail:
  1. Download the patched binaries from [https://github.com/cdarlint/winutils](https://github.com/cdarlint/winutils), `winutils.exe` and `hadoop.dll`.
  2. Place the downloaded files in the `bin/` subdirectory under the extracted Hadoop directory.

---

### 2. Set Environment Variables
In this part, you will configure some environment variables to make sure your programs will run easily and correctly.

#### Linux and MacOS

1. To test if environment variables are set, run the following commands

    ```bash
    echo $JAVA_HOME
    echo $MAVEN_HOME
    echo $HADOOP_HOME
    ```

    They should output nothing or three empty lines. We will set them shortly.
2. Find which shell you are using, run the following command

    ```bash
    echo $SHELL
    ```

    - If it prints `/usr/bash`, you are using *bash*, the profile file name should be `.bashrc` or `.bash_profile` (note the leading dot).
    - If it prints `/usr/zsh`, you are using *zsh*, the profile file name should be `.zshrc` or `.zprofile` (note the leading dot).
3. Assume you are using *bash*, and profile file `.bashrc`
4. Edit or create the profile, run the following command

    ```bash
    vi ~/.bashrc # Change the file name accodingly
    ```

5. Add the following lines into the profile, and save.
    - Linux

      ```bash
      export JAVA_HOME="$HOME/cs167/jdk-17.0.9"
      export MAVEN_HOME="$HOME/cs167/apache-maven-3.9.6"
      export HADOOP_HOME="$HOME/cs167/hadoop-3.3.6"
      
      export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$HADOOP_HOME/bin:$PATH
      ```

    - macOS

      ```bash
      export JAVA_HOME="$HOME/cs167/jdk-17.0.9.jdk/Contents/Home"
      export MAVEN_HOME="$HOME/cs167/apache-maven-3.9.6"
      export HADOOP_HOME="$HOME/cs167/hadoop-3.3.6"
      
      export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$HADOOP_HOME/bin:$PATH
      ```

6. Reload the current environment
    - Run command `source ~/.bashrc` or `. ~/.bashrc` (Change the file name accodingly).
    - Or, quit the terminal app and restart it.
7. Verify the environment variables again

    ```bash
    echo $JAVA_HOME
    echo $MAVEN_HOME
    echo $HADOOP_HOME
    ```

    They should print three non-empty lines with the values you just set.

#### Windows

1. To test if environment variables are set, run the following commands
    - Command line promot

      ```console
      echo %JAVA_HOME%
      echo %MAVEN_HOME%
      echo %HADOOP_HOME%
      ```

    - PowerShell or Windows Terminal

      ```console
      echo $Env:JAVA_HOME
      echo $Env:MAVEN_HOME
      echo $Env:HADOOP_HOME
      ```

    They should output nothing or three empty lines.
2. Press `Win + R` to open the *Run* window.
3. Type `rundll32.exe sysdm.cpl,EditEnvironmentVariables` and press Enter.
4. In *User variables for xxx*, click *New* to add a new environment variable for each of the following 3 pairs:
    - Variable name: `JAVA_HOME`, Variable value: `C:\Users\[username]\cs167\jdk-17.0.9`
    - Variable name: `MAVEN_HOME`, Variable value: `C:\Users\[username]\cs167\apache-maven-3.9.6`
    - Variable name: `HADOOP_HOME`, Variable value: `C:\Users\[username]\cs167\hadoop-3.3.6`
5. Double click variable **Path**, add the following 3 values via "New" button:
    - `%JAVA_HOME%\bin`
    - `%MAVEN_HOME%\bin`
    - `%HADOOP_HOME%\bin`
6. Don't forget to click "Ok" to close and save the changes in environment variables.
7. Close and restart the current terminal, and rerun the commands in step 1, they should print 3 non-empty lines with the values you just set.

---

### 3. Verify Installed Software

#### JDK

Run command

```bash
javac -version
```

Example output

```text
javac 17.0.9
```

#### Apache Maven

Run command

```bash
mvn -version
```

Example output (contents may differ)

```text
Maven home: /Users/student/cs167/apache-maven-3.9.6
Java version: 17.0.9, vendor: Oracle Corporation, runtime: /Users/student/cs167/jdk-17.0.9.jdk/Contents/Home
Default locale: en_US, platform encoding: UTF-8
OS name: "mac os x", version: "14.2.1", arch: "x86_64", family: "mac"
```

#### Apache Hadoop

Run command

```bash
hadoop version
```

Example output on Linux and macOS (contents may differ)

```text
Hadoop 3.3.6
Source code repository https://github.com/apache/hadoop-git -т 1be78238728da9266a4f88195058f8
Compiled by ubuntu on 2023-06-18T08:22Z
Compiled on platform linux-x86_64
Compiled with protoc 3.7.1
From source with checksum 5652179ad55f76cb287d9c633bb53bbd
This command was run using /Users/student/cs167/hadoop-3.3.6/share/hadoop/common/hadoop-common-3.3.6.jar
```

### 4. Create an Empty Maven Project

- Create a new directory "$HOME/cs167/workspace" or "C:\cs167\workspace" to place all your projects.

- Open terminal, cd to workspace
  - Linux and macOS: `cd $HOME/cs167/workspace`
  - Windows: `cd C:\cs167\workspace`
  
- Run the following command

  ```bash
  # Replace [UCRNetID] with your UCR Net ID, not student ID.
  mvn archetype:generate -DgroupId=edu.ucr.cs.cs167.[UCRNetID] -DartifactId=[UCRNetID]_lab1 -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
  ```

  If the above command fails on Windows, you can try Windows Command Prompt (cmd). This command may have some issues with PowerShell and Windows Terminal. You may also try enclose every argument with double quotes `"`.
  Alternatively, you can use the [alternative method](#alternative-method) later in this section to create a project via IntelliJ.

- ***(Q1) What is the name of the created directory?***

- Change into the project directory and type

  ```bash
  mvn package
  ```

  This command compiles your project and produces a JAR file with your compiled classes under the target directory.
- To run your newly created program, type

  ```bash
  java -cp target/[UCRNetID]_lab1-1.0-SNAPSHOT.jar edu.ucr.cs.cs167.[UCRNetID].App
  ```

  Replace `[UCRNetID]` with your UCR Net ID, not student ID.

- ***(Q2) What do you see at the console output?***

#### Import Your Project into InelliJ IDEA

- Open IntelliJ IDEA and choose "Open".
- Choose the directory of your new Maven project, select the "pom.xml" file.
- In the prompt, choose "Open as Project".
- The project will open. It may take some time to import the project and download neessary dependencies.
- Open the file "App.java" and click the small green arrow to run the main class.

#### Alternative Method

Try the following method if you see red errors (likely on Windows).

1. Open IntelliJ.
2. Select "New Project"
3. Make sure "Project SDK" is showing *17* in the right panel, otherwise select the JDK 17 you just installed.
4. Select "Maven" in the left panel, check "Create from archetype" in the right panel, then select `org.apache.maven.archetypes:maven-archetype-quickstart`. Click "Next".
5. Expand "Artifact Coordinates"
6. Change "GroupId" to `edu.ucr.cs.cs167.[UCRNetID]` (Replace `[UCRNetID]` with your UCR Net ID, not student ID).
7. Change "ArticifactId" to `[UCRNetID]_lab1` (Replace `[UCRNetID]` with your UCR Net ID, not student ID), the project "Name" will be automatically changed.
8. Modify "Location" to `"$HOME/cs167/workspace/[UCRNetID]_lab1"` or `"C:\cs167\workspace\[UCRNetID]_lab1"` (Replace `[UCRNetID]` with your UCR Net ID, not student ID).
9. Click "Next" and then "Finish".

#### Configure for Hadoop

- Edit your **pom.xml** file and add the following blocks. This adds Hadoop libraries to your dependencies so that you an access Hadoop API.
  1. Find `<properties>` tag, add the following block into it (change the version number to 3.2.2 if you are using Windows).

      ```xml
      <hadoop.version>3.3.6</hadoop.version>
      ```

  2. If `<properties>` tag does not exist, add the following block above `<dependencies>` tag (change the version number to 3.2.2 if you are using Windows).

      ```xml
      <properties>
        <hadoop.version>3.3.6</hadoop.version>
      </properties>
      ```

  3. Add the following blocks into `<dependencies>` tag.

      ```xml
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
      ```

  - If the IDE asks for importing the changes in your pom.xml file, press "Import Changes" to accept the changes.
    - In newer versions of IntelliJ, you don't see this prompt. Instead, you may see a floating M icon, click it to *Load Maven Changes*.

---

### 5. Create WordCount Example

1. Replace the code in your App.java file with the following code but leave the package line as-is.

    ```java
    // Replace [UCRNetID] with your UCR Net ID, not student ID.
    package edu.ucr.cs.cs167.[UCRNetID];

    import java.io.IOException;
    import java.util.StringTokenizer;

    import org.apache.hadoop.conf.Configuration;
    import org.apache.hadoop.fs.Path;
    import org.apache.hadoop.io.IntWritable;
    import org.apache.hadoop.io.Text;
    import org.apache.hadoop.mapreduce.Job;
    import org.apache.hadoop.mapreduce.Mapper;
    import org.apache.hadoop.mapreduce.Reducer;
    import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
    import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

    /**
    * Word Count MapReduce Example.
    */
    public class App {
        public static class TokenizerMapper
                extends Mapper<Object, Text, Text, IntWritable> {
            private final static IntWritable one = new IntWritable(1);
            private Text word = new Text();

            public void map(Object key, Text value, Context context
            ) throws IOException, InterruptedException {
                StringTokenizer itr = new StringTokenizer(value.toString());
                while (itr.hasMoreTokens()) {
                    word.set(itr.nextToken());
                    context.write(word, one);
                }
            }
        }

        public static class IntSumReducer
                extends Reducer<Text, IntWritable, Text, IntWritable> {
            private IntWritable result = new IntWritable();

            public void reduce(Text key, Iterable<IntWritable> values,
                              Context context
            ) throws IOException, InterruptedException {
                int sum = 0;
                for (IntWritable val : values) {
                    sum += val.get();
                }
                result.set(sum);
                context.write(key, result);
            }
        }

        public static void main(String[] args) throws Exception {
            Configuration conf = new Configuration();
            Job job = Job.getInstance(conf, "word count");
            job.setJarByClass(App.class);
            job.setMapperClass(TokenizerMapper.class);
            job.setCombinerClass(IntSumReducer.class);
            job.setReducerClass(IntSumReducer.class);
            job.setOutputKeyClass(Text.class);
            job.setOutputValueClass(IntWritable.class);
            FileInputFormat.addInputPath(job, new Path(args[0]));
            FileOutputFormat.setOutputPath(job, new Path(args[1]));
            System.exit(job.waitForCompletion(true) ? 0 : 1);
        }
    }
    ```

2. Run the updated App class.

- ***(Q3) What do you see at the output?***

*Hint:* It will fail with an error. Report this error.

- Create a new text file named "input.txt" in the project folder (same level as "src"), and add the following sample content to it.

    ```text
    if you cannot fly, then run
    if you cannot run, then walk
    if you cannot walk, then crawl
    but whatever you do you have to keep moving forward
    ```

- Now specify "input.txt" and "output.txt" as the input and output files to your program as follows.

    ![alt text](lab1_images/word_count_1.png)

    Then

    ![alt text](lab1_images/word_count_2.png)

- ***(Q4) What is the output that you see at the console?***

  Note: We will later cover how MapReduce programs are executed in more details. This lab just ensures that you have the development environment setup.

#### Run the WordCount example from Command Line

- At the command line, type:

    ```bash
    mvn package 
    ```

- Try to run your program as we did earlier.

  ```bash
  java -cp target/[UCRNetID]_lab1-1.0-SNAPSHOT.jar edu.ucr.cs.cs167.[UCRNetID].App
  ```

- ***(Q5) Does it run? Why or why not?***

*Hint:* Report the error and explain in a few words what it means.

- Try to run the program using the following command:

    ```bash
    # Replace [UCRNetID] with your UCR Net ID, not student ID.
    hadoop jar target/[UCRNetID]_lab1-1.0-SNAPSHOT.jar edu.ucr.cs.cs167.[UCRNetID].App input.txt output.txt
    ```

---

### 6. Prepare Your Submission

- To avoid entering the full class name when you run your program, configure the main class in the `pom.xml` file as follows.
  - If you can find `<artifactId>maven-jar-plugin</artifactId>` under `<build>` &rarr; `<plugins>` &rarr; `<plugin>`, add the following block into it (Replace `[UCRNetID]` with your UCR Net ID, not student ID).

    ```xml
    <configuration>
      <archive>
        <manifest>
          <mainClass>edu.ucr.cs.cs167.[UCRNetID].App</mainClass>
        </manifest>
      </archive>
    </configuration>
    ```

  - Otherwise, add the following block (Replace `[UCRNetID]` with your UCR Net ID, not student ID).

    ```xml
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

- Then, rebuild the project/jar file.

  ```bash
  mvn package
  ```

- Now, you can run your program using the following command.

  ```bash
  # Replace [UCRNetID] with your UCR Net ID, not student ID.
  hadoop jar target/[UCRNetID]_lab1-1.0-SNAPSHOT.jar input.txt output.txt
  ```

- Add a README.md file to your project home directory. In this file, write down your name, email, UCR Net ID, and Student ID.

- Answer all the questions above in the README file. For each question, copy/paste the question first and then enter your answer in a new line.
- Add any additional information that you think are important.
- Feel free to style your README file according to the Markdown markup language
<https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet>
You can also refer to our template at [HERE](CS167-Lab1-README.md) (Click on the <> icon to Display the source blob, or click Raw to see the original content).
- Add a script file "run.sh" that will compile and run your program. Find a sample below (Replace `[UCRNetID]` with your UCR Net ID, not student ID).

  ```shell script
  #!/usr/bin/env sh
  mvn clean package
  hadoop jar target/[UCRNetID]_lab1-1.0-SNAPSHOT.jar input.txt output.txt
  ```

- Package the source files into a compressed file. Only the following files and directories should be included in your submission.

  ```text
  src/
  pom.xml
  README.md
  run.sh
  ```

  Check [here](../MakeArchive.md) for how to make the archive file in `.tar.gz` or `.zip` format with only required files.

- ***(S) Submit your compressed file as the lab deliverable.***

#### Notes

- Make sure to follow the naming conventions that are mentioned in this lab.

  - We will follow similar naming conventions for future labs with the necessary changes for the lab name.

  - Failure to follow these instructions and conventions might result in losing some points. This includes, for example, adding unnecessary files in your compressed file, using different package names, using a different name for the compressed file, not including a runnable script, and not including a README file.

---

## Frequent Problems

**Problems**

Environment variables do not preserve. All `*_HOME` variables become empty when the terminal restarts.

**Resolution**

- If you see `(base)` in the begining of every line in the terminal, it's likely you have **Conda** (Anaconda, miniforge, etc) installed. Run the following command to disable its auto-start.

  ```bash
  conda config --set auto_activate_base false
  ```

- It is possible some profile file of higher priority overrides the file you edited. For example, `.bash_profile` may override `.bashrc`, and `.zprofile` may override `.zshrc`. Try to move your settings to a file with higher priority.

**Problem**

```console
Exception in thread "main" org.apache.hadoop.mapred.FileAlreadyExistsException: Output directory output.txt already exists
```

**Resolution**: Delete the output directory if it already exists.

**Problem**

```console
Exception in thread "main" java.lang.RuntimeException: java.io.FileNotFoundException: java.io.FileNotFoundException: HADOOP_HOME and hadoop.home.dir are unset. -see https://wiki.apache.org/hadoop/WindowsProblems
```

**Resolution**: Set the `HADOOP_HOME` environment variable to where Hadoop is installed. After that, you might need to restart IntelliJ IDEA or the command-line depending on where you got this error.

**Problem**

```console
Exception in thread "main" java.lang.RuntimeException: java.io.FileNotFoundException: Could not locate Hadoop executable: hadoop\bin\winutils.exe -see https://wiki.apache.org/hadoop/WindowsProblems
```

**Resolution**: Make sure that `winutils.exe` is in `%HADOOP_HOME%\bin` directory.

**Problem**

```console
Exception in thread "main" java.lang.UnsatisfiedLinkError: org.apache.hadoop.io.nativeio.NativeIO$Windows.access0(Ljava/lang/String;I)Z
```

**Resolution**: Make sure that `hadoop.dll` is in `%HADOOP_HOME%\bin` directory and that `%HADOOP_HOME%\bin` is in the executable path.

**Problem**

```console
Exception in thread "main" 0: No such file or directory
 at org.apache.hadoop.io.nativeio.NativeIO$POSIX.chmod(NativeIO.java:388)
 at org.apache.hadoop.fs.RawLocalFileSystem.setPermission(RawLocalFileSystem.java:863)
 at org.apache.hadoop.fs.ChecksumFileSystem$1.apply(ChecksumFileSystem.java:510)
 at org.apache.hadoop.fs.ChecksumFileSystem$FsOperation.run(ChecksumFileSystem.java:491)
 at org.apache.hadoop.fs.ChecksumFileSystem.setPermission(ChecksumFileSystem.java:513)
 at org.apache.hadoop.fs.FileSystem.mkdirs(FileSystem.java:682)
 at org.apache.hadoop.mapreduce.JobResourceUploader.mkdirs(JobResourceUploader.java:660)
 at org.apache.hadoop.mapreduce.JobResourceUploader.uploadResourcesInternal(JobResourceUploader.java:174)
 at org.apache.hadoop.mapreduce.JobResourceUploader.uploadResources(JobResourceUploader.java:135)
 at org.apache.hadoop.mapreduce.JobSubmitter.copyAndConfigureFiles(JobSubmitter.java:99)
 at org.apache.hadoop.mapreduce.JobSubmitter.submitJobInternal(JobSubmitter.java:194)
 at org.apache.hadoop.mapreduce.Job$11.run(Job.java:1565)
 at org.apache.hadoop.mapreduce.Job$11.run(Job.java:1562)
 at java.security.AccessController.doPrivileged(Native Method)
 at javax.security.auth.Subject.doAs(Subject.java:422)
 at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1762)
 at org.apache.hadoop.mapreduce.Job.submit(Job.java:1562)
 at org.apache.hadoop.mapreduce.Job.waitForCompletion(Job.java:1583)
```

**Resolution**: Modify your code as below when Hadoop configuration is created. Make sure that the directory that you add to the configuration exists and is writable.

```java
Configuration conf = new Configuration();
conf.set("mapreduce.jobtracker.staging.root.dir", "%USERPROFILE%\\Workspace\\hadooptmp\\staging");
```

**Problem**

```console
log4j:WARN No appenders could be found for logger (org.apache.hadoop.metrics2.lib.MutableMetricsFactory).
log4j:WARN Please initialize the log4j system properly.
log4j:WARN See http://logging.apache.org/log4j/1.2/faq.html#noconfig for more info.
```

**Resolution**: This is just a warning. You can ignore it for now.


**Problem**

When downloading JDK, I get the following error.
```
Bad Oracle Access Manager Request
Unable to process the request due to unexpected error.
```

**Resolution**
You can try the following workaround

1. Go back to the download page https://www.oracle.com/java/technologies/downloads/ Links to an external site.
2. Find the correct version you want to download, jdk-8u321-macosx-x64.dmg for example (for MacOS).
3. Click the download link (jdk-8u321-macosx-x64.dmg).
4. Check "I reviewed and accept the Oracle Technology Network License Agreement for Oracle Java SE".
5. *Right click* "Download jdk-8u321-macosx-x64.dmg", select "Copy link address".
6. You can paste the copied link in your browser's URL bar, the copied link is something like `https://www.oracle.com/webapps/redirect/signon?nexturl=https://download.oracle.com/otn/java/jdk/8u321-b07/df5ad55fdd604472a86a45a217032c7d/jdk-8u321-macosx-x64.dmg`
7. Remove the first part before =, and only keep `https://download.oracle.com/otn/java/jdk/8u321-b07/df5ad55fdd604472a86a45a217032c7d/jdk-8u321-macosx-x64.dmg`
8. Then press Enter to download the file.
