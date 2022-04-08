# Lab 1

## Objectives

- Set up the development environment for Java.
- Run a test program on Hadoop within the IDE.
- Package the source code of your project in a compressed form.
- Write a script that compiles, tests, and runs your project.

## Lab Work

Follow the instructions below to complete this lab. If you have any questions, please contact the TA in your lab. Make sure to answer any questions marked by the ***(Q)*** sign and submit the deliverables marked by the ***(S)*** sign.

---

### 1. Install Required Software

1. **Make sure your user name does not have any space. Otherwise, create an user without space.**
2. **Create a writable folder with no space in the path, for example:**
    - Linux and MacOS: "\~/cs167", where *\~* is your home directory
      - Linux: "/home/user/cs167", where your username is "user".
      - MacOS: "/Users/user/cs167", where your username is "user".
    - Windows: "C:\cs167"

<details>

  <summary>Linux</summary>

#### Oracle JDK 8 (OpenJDK or other versions may fail)

  1. Download **x64 Compressed Archive (jdk-8u321-linux-x64.tar.gz)** from [https://www.oracle.com/java/technologies/downloads/#java8-linux](https://www.oracle.com/java/technologies/downloads/#java8-linux).
  2. Unarchive it to the folder you created before, e.g, "\~/cs167". Your JDK path will be "\~/cs167/jdk1.8.0_321".

#### Apache Maven

  1. Download the archive (3.8.5) from [https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz](https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz).
  2. Unarchive it to the folder you created before, e.g, "\~/cs167". Your Maven path will be "\~/cs167/apache-maven-3.8.5".

#### IntelliJ Community Edition

- Ubuntu
  - Find **IDEA Community** in **Software Center** and install it.
  - Or run the following command:
    ```bash
    sudo snap install intellij-idea-community --classic
    ```

- CentOS/Fedora/Redhat
  - Follow the instructions at [https://www.javatpoint.com/how-to-install-intelij-idea-on-centos](https://www.javatpoint.com/how-to-install-intelij-idea-on-centos) or [https://snapcraft.io/install/intellij-idea-community/centos](https://snapcraft.io/install/intellij-idea-community/centos).

#### Apache Hadoop

  1. Download the archive (3.2.3) from [https://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-3.2.3/hadoop-3.2.3.tar.gz](https://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-3.2.3/hadoop-3.2.3.tar.gz).
  2. Unarchive it to the folder you created before, e.g, "\~/cs167". Your Hadoop path will be "\~/cs167/hadoop-3.2.3".

</details>

<details>

  <summary>MacOS</summary>

#### Oracle JDK 8 (OpenJDK or other versions may fail)

  1. Download the installer **x64 DMG Installer (jdk-8u321-macosx-x64.dmg)** from [https://www.oracle.com/java/technologies/downloads/#java8-mac](https://www.oracle.com/java/technologies/downloads/#java8-mac).
  2. Mount the dmg file and install it.

#### Apache Maven

  1. Download the archive (3.8.5) from [https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz](https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz).
  2. Unarchive it to the folder you created before, e.g, "\~/cs167". Your Maven path will be "\~/cs167/apache-maven-3.8.5".

#### IntelliJ Community Edition

  1. Download the **Community** version from [https://www.jetbrains.com/idea/download/#section=mac](https://www.jetbrains.com/idea/download/#section=mac). Select ".dmg (Intel)" or ".dmg (Apple Silicon)" according to your hardware.
  2. Mount the dmg file and install the app.

#### Apache Hadoop

  1. Download the archive (3.2.3) from [https://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-3.2.3/hadoop-3.2.3.tar.gz](https://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-3.2.3/hadoop-3.2.3.tar.gz).
  2. Unarchive it to the folder you created before, e.g, "\~/cs167". Your Hadoop path will be "\~/cs167/hadoop-3.2.3".

</details>

<details>

  <summary>Windows</summary>

#### 7-Zip

  1. Download and install it from [https://www.7-zip.org/](https://www.7-zip.org/). You will need it to unarchive .tar.gz files later.

#### Oracle JDK 8 (OpenJDK or other versions may fail)

  1. Download the installer **x64 Installer (jdk-8u321-windows-x64.exe)** from [https://www.oracle.com/java/technologies/downloads/#java8-windows](https://www.oracle.com/java/technologies/downloads/#java8-windows).
  2. Do **NOT** install it to the default location "C:\Program Files\Java". The path contains space, making Hadoop unable to work properly.
  3. During installation, change the install location to some path with no space, like "C:\cs167\jdk1.8.0_321".
  4. You may skip installation of "Source Code" and "Public JRE" during the installation. To do so, click on the drive icon, select "This feature will not be available".

#### Apache Maven

  1. Download the archive (3.8.5) from [https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz](https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz).
  2. Unarchive it to the folder you created before, e.g, "C:\cs167". Your Maven path will be "C:\cs167\apache-maven-3.8.5".

#### IntelliJ (IDEA) Community Edition

  1. Download the **Community** version from [https://www.jetbrains.com/idea/download/#section=windows](https://www.jetbrains.com/idea/download/#section=windows). Select "Windows (.exe)".
  2. Install it. It is OK to install IDEA to the default location.

#### Apache Hadoop

  1. Download the archive (3.2.2) from [https://archive.apache.org/dist/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz](https://archive.apache.org/dist/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz).
  2. Unarchive it to the folder you created before, e.g, "C:\cs167". Your Hadoop path will be "C:\cs167\hadoop-3.2.2".
     - To unarchive it, open the "hadoop-3.2.2.tar.gz" via 7-zip, double click "hadoop-3.2.2.tar" to open it. This may take a few seconds.
     - Select "hadoop-3.2.2", click the "Extract" button (do not drag to unarchive), Set "Copy to:" to "C:\cs167\", and the click "OK".
     - The decompression takes a few seconds to minutes, you will see 3 errors saying "Cannot create symbolic link: ...", just click "Close" to ignore the errors. Those files are only needed for Linux and MacOS.
  3. Patch the binaries, otherwise many Hadoop related functions will fail:
      1. Download the patched binaries from [https://github.com/cdarlint/winutils](https://github.com/cdarlint/winutils)
      2. To download a folder only, paste `https://github.com/cdarlint/winutils/tree/master/hadoop-3.2.2/bin` into the text box in [https://download-directory.github.io/](https://download-directory.github.io/), and press Enter key. This will download a zip file "cdarlint winutils master hadoop-3.2.2-bin.zip" which contains the patched binaries for 3.2.2 only.
      3. Unzip the downloaded file, and put all the files in the zip to "C:\cs167\hadoop-3.2.2\bin" to overwrite existing files.

#### Windows Terminal (Optional)

- You may install Windows Terminal [https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701) for better command line experience.

#### Alternative Solution

1. Download and install Oracle VirtualBox [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads).
2. Install a guest operating system Ubuntu 20.04 from [https://ubuntu.com/download/desktop/thank-you?version=20.04.4&architecture=amd64](https://ubuntu.com/download/desktop/thank-you?version=20.04.4&architecture=amd64)
3. Use the instructions for Linux (Ubuntu) above to configure the course environment in the guest OS.

</details>

---

### 2. Set Environment Variables

<details>

  <summary>Linux and MacOS</summary>

  1. To test if environment variables are set, run the following commands

      ```bash
      echo $JAVA_HOME
      echo $MAVEN_HOME
      echo $HADOOP_HOME
      ```

      They should output nothing or 3 empty lines.
  2. Find which shell you are using, run the following command

      ```bash
      echo $SHELL
      ```

      - If it prints **/usr/bash**, you are using **bash**, the profile file name should be `.bashrc` or `.bash_profile` (note the leading dot).
      - If it prints **/usr/zsh**, you are using **zsh**, the profile file name should be `.zshrc` or `.zprofile` (note the leading dot).
  3. Assume you are using **bash**, and profile file `.bashrc`
  4. Edit or create the profile, run the following command

      ```bash
      vi ~/.bashrc # Change the file name accodingly
      ```

  5. Add the following lines into the profile, and save.
      - Linux

        ```
        export JAVA_HOME="/home/$LOGNAME/cs167/jdk1.8.0_321"
        export MAVEN_HOME="/home/$LOGNAME/cs167/apache-maven-3.8.5"
        export HADOOP_HOME="/home/$LOGNAME/cs167/hadoop-3.2.3"
        
        PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$HADOOP_HOME/bin:$PATH
        ```

      - MacOS

        ```
        export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_321.jdk/Contents/Home"
        export MAVEN_HOME="/Users/$LOGNAME/cs167/apache-maven-3.8.5"
        export HADOOP_HOME="/Users/$LOGNAME/cs167/hadoop-3.2.3"
        
        PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$HADOOP_HOME/bin:$PATH
        ```

  6. Reload the current environment
      - Run command `source ~/.bash_rc` (Change the file name accodingly).
      - Or, quit the terminal app and restart it.
  7. Verify the environment variables again

      ```bash
      echo $JAVA_HOME
      echo $MAVEN_HOME
      echo $HADOOP_HOME
      ```

      They should print 3 non-empty lines with the values you just set.

</details>

<details>

  <summary>Windows</summary>

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

      They should output nothing or 3 empty lines.
  2. Press Win+R to open the **Run** window.
  3. Type `rundll32.exe sysdm.cpl,EditEnvironmentVariables` and press Enter.
  4. In **User variables for xxx**, click **New** to add a new environment variable for each of the following 3 pairs:
      - Variable name: `JAVA_HOME`, Variable value: `C:\cs167\jdk1.8.0_321`
      - Variable name: `MAVEN_HOME`, Variable value: `C:\cs167\apache-maven-3.8.5`
      - Variable name: `HADOOP_HOME`, Variable value: `C:\cs167\hadoop-3.2.2`
  5. Double click variable **Path**, add the following 3 values via "New" button:
      - `%JAVA_HOME%\bin`
      - `%MAVEN_HOME%\bin`
      - `%HADOOP_HOME%\bin`
  6. Don't forget to click "Ok" to close and save the changes in environment variables.
  7. Close and restart the current terminal, and rerun the commands in step 1, they should print 3 non-empty lines with the values you just set.

</details>

---

### 3. Verify Installed Software

#### JDK 8

Run command

```bash
javac -version
```

Example output

```
javac 1.8.0_321
```

#### Apache Maven

Run command

```bash
mvn -version
```

Example output (contents may differ)

```
Apache Maven 3.8.5 (3599d3414f046de2324203b78ddcf9b5e4388aa0)
Maven home: /Users/user/cs167/apache-maven-3.8.5
Java version: 1.8.0_321, vendor: Oracle Corporation, runtime: /Library/Java/JavaVirtualMachines/jdk1.8.0_321.jdk/Contents/Home/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "mac os x", version: "12.3", arch: "x86_64", family: "mac"
```

#### Apache Hadoop

Run command

```bash
hadoop version
```

Example output on Linux and MacOS (contents may differ)

```
Hadoop 3.2.3
Source code repository https://github.com/apache/hadoop -r abe5358143720085498613d399be3bbf01e0f131
Compiled by ubuntu on 2022-03-20T01:18Z
Compiled with protoc 2.5.0
From source with checksum 39bb14faec14b3aa25388a6d7c345fe8
This command was run using /Users/user/cs167/hadoop-3.2.3/share/hadoop/common/hadoop-common-3.2.3.jar
```

Example output on Windows
```
Hadoop 3.2.2
Source code repository Unknown -r 7a3bc90b05f257c8ace2f76d74264906f0f7a932
Compiled by hexiaoqiao on 2021-01-03T09:26Z
Compiled with protoc 2.5.0
From source with checksum 5a8f564f46624254b27f6a33126ff4
This command was run using /C:/cs167/hadoop-3.2.2/share/hadoop/common/hadoop-common-3.2.2.jar
```

### 4. Create an Empty Maven Project

- Create a new directory "~/cs167/workspace" or "C:\cs167\workspace" to place all your projects.

- Open terminal, cd to workspace
  - Linux and MacOS: `cd ~/cs167/workspace`
  - Windows: `cd C:\cs167\workspace`
  
- Run the following command

  ```bash
  # Replace <UCRNetID> with your UCR Net ID, not student ID.
  mvn archetype:generate -DgroupId=edu.ucr.cs.cs167.<UCRNetID> -DartifactId=<UCRNetID>_lab1 -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
  ```
  If the above command fails on Windows, you may try Windows Command Prompt (cmd). This command may have some issues with PowerShell and Windows Terminal.
  Alternatively, you can use the alternative method later in this section to create a project via IntelliJ.

- ***(Q1) What is the name of the created directory?***

- Change into the project directory and type

  ```bash
  mvn package
  ```

  This command compiles your project and produces a JAR file with your compiled classes under the target directory.
- To run your newly created program, type

  ```bash
  java -cp target/<UCRNetID>_lab1-1.0-SNAPSHOT.jar edu.ucr.cs.cs167.<UCRNetID>.App
  ```

  Replace <UCRNetID> with your UCR Net ID, not student ID.

- ***(Q2) What do you see at the console output?***

#### Import Your Project into InelliJ IDEA

- Open IntelliJ IDEA and choose "Open".
- Choose the directory of your new Maven project, select the "pom.xml" file.
- In the promot, choose "Open as Project".
- The project will open. It may take some time to import the project and download neessary dependencies.
- Open the file "App.java" and click the small green arrow to run the main class.

#### Alternative Method

Try the following method if you see red errors (likely on Windows).

1. Open IntelliJ
2. Select "New Project"
3. Make sure "Project SDK" is showing **1.8** in the right panel, otherwise select the JDK 8 you just installed.
4. Select "Maven" in the left panel, check "Create from archetype" in the right panel, then select `org.apache.maven.archetypes:maven-archetype-quickstart`. Click "Next".
5. Expand "Artifact Coordinates"
6. Change "GroupId" to `edu.ucr.cs.cs167.<UCRNetID>` (Replace `<UCRNetID>` with your UCR Net ID, not student ID).
7. Change "ArticifactId" to `<UCRNetID>_lab1` (Replace `<UCRNetID>` with your UCR Net ID, not student ID), the project "Name" will be automatically changed.
9. Modify "Location" to "~/cs167/workspace/\<UCRNetID\>_lab1" or "C:\cs167\workspace\\<UCRNetID\>_lab1" (Replace `<UCRNetID>` with your UCR Net ID, not student ID).
10. Click "Next" and then "Finish".

#### Configure for Hadoop

- Edit your **pom.xml** file and add the following blocks. This adds Hadoop libraries to your dependencies so that you an access Hadoop API.
  1. Find `<properties>` tag, add the following block into it (change the version number to 3.2.2 if you are using Windows).

      ```xml
      <hadoop.version>3.2.3</hadoop.version>
      ```

  2. If `<properties>` tag does not exist, add the following block above `<dependencies>` tag (change the version number to 3.2.2 if you are using Windows).

      ```xml
      <properties>
        <hadoop.version>3.2.3</hadoop.version>
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
    - In newer version of IntelliJ, you don't see this promot. Instead, you may see a floating M icon, click it to **Load Maven Changes**.  

---
### 5. Create WordCount Example

1. Replace the code in your App.java file with the following code but leave the package line as-is.
    ```java
    // Replace <UCRNetID> with your UCR Net ID, not student ID.
    package edu.ucr.cs.cs167.<UCRNetID>;

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
  java -cp target/<UCRNetID>_lab1-1.0-SNAPSHOT.jar edu.ucr.cs.cs167.<UCRNetID>.App
  ```

- ***(Q5) Does it run? Why or why not?***

- Try to run the program using the following command:

    ```bash
    # Replace <UCRNetID> with your UCR Net ID, not student ID.
    hadoop jar target/<UCRNetID>_lab1-1.0-SNAPSHOT.jar edu.ucr.cs.cs167.<UCRNetId>.App input.txt output.txt
    ```

---
### 6. Prepare Your Submission

- To avoid entering the full class name when you run your program, configure the main class in the **pom.xml** file as follows.
  - If you can find `<artifactId>maven-jar-plugin</artifactId>` under `<build>` &rarr; `<plugins>` &rarr; `<plugin>`, add the following block into it (Replace `<UCRNetID>` with your UCR Net ID, not student ID).

    ```xml
    <configuration>
      <archive>
        <manifest>
          <mainClass>edu.ucr.cs.cs167.<UCRNetID>.App</mainClass>
        </manifest>
      </archive>
    </configuration>
    ```

  - Otherwise, add the following block (Replace `<UCRNetID>` with your UCR Net ID, not student ID).

    ```xml
    <build>
      <plugins>
        <plugin>
          <groupId>org.apache.maven.plugins</groupId>
          <artifactId>maven-jar-plugin</artifactId>
          <configuration>
            <archive>
              <manifest>
                <mainClass>edu.ucr.cs.cs167.<UCRNetID>.App</mainClass>
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
  # Replace <UCRNetID> with your UCR Net ID, not student ID.
  hadoop jar target/<UCRNetID>_lab1-1.0-SNAPSHOT.jar input.txt output.txt
  ```

- Add a README.md file to your project home directory. In this file, write down your name, email, UCR Net ID, and Student ID.

- Answer all the questions above in the README file. For each question, copy/paste the question first and then enter your answer in a new line.
- Add any additional information that you think are important.
- Feel free to style your README file according to the Markdown markup language
<https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet>
You can also refer to our template at [HERE](CS167-Lab1-README.md) (Click on the <> icon to Display the source blob, or click Raw to see the original content).
- Add a script file "run.sh" that will compile and run your program. Find a sample below (Replace `<UCRNetID>` with your UCR Net ID, not student ID).

  ```shell script
  #!/usr/bin/env sh
  mvn clean package
  hadoop jar target/<UCRNetID>_lab1-1.0-SNAPSHOT.jar input.txt output.txt
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

* Make sure to follow the naming conventions that are mentioned in this lab.

  - We will follow similar naming conventions for future labs with the necessary changes for the lab name.

  - Failure to follow these instructions and conventions might result in losing some points. This includes, for example, adding unnecessary files in your compressed file, using different package names, using a different name for the compressed file, not including a runnable script, and not including a README file.

---
## Frequent Problems

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
