# Lab 1

## Objectives

- Get access to remote virtual machine.
- Run a test program on Hadoop.
- Package the source code of your project in a compressed form.
- Write a script that compiles, tests, and runs your project.

## Pre-lab
Before the lab, complete the following steps to be ready for the lab.
1. Get access to CS167 virtual machine through bolt(https://github.com/aseldawy/CS167/blob/master/remote-access.md).
- Please only do Part I and Part II, remaining parts will be instructed at lab by TA.
- Make sure you either know your CS password or reset it before the lab.
2. Download [Apache Maven binaries](https://maven.apache.org/download.cgi).

If you have trouble with accessing remote virtual machine, please email `ychan268@ucr.edu`.

## Lab Work

Follow the instructions below to complete this lab. If you have any questions, please contact the TA in your lab. Make sure to answer any questions marked by the ***(Q)*** sign and submit the deliverables marked by the ***(S)*** sign. You must answer the questions at the right step to get the correct output. Do *not* wait until you finish all the steps and then answer the questions.

---

### 1. Environment setup
All the steps below are to run on the virtual machine

1. Create a writable folder with no space in the path, for example: `$HOME/cs167`", where `$HOME` is your home directory
2. From this point on, we will call this directory *the course directory*.

#### Oracle JDK 11
We will use JDK as our SDK to compile Java and Scala code in this course. The virtual machine has already installed jdk.

#### Apache Maven
Apache Maven is a Java-based project management software. It makes it easier to compile and package your code.

  1. Download the 3.9.6 binary archive from [Maven download page](https://maven.apache.org/download.cgi).
  ```bash
  export MVN_VER=3.9.6
  wget "https://archive.apache.org/dist/maven/maven-3/${MVN_VER}/binaries/apache-maven-${MVN_VER}-bin.tar.gz" -O apache-maven-${MVN_VER}-bin.tar.gz
  ```
  2. Extract it to the course directory. Use `wget <URL>` to download a file from command line. Use the command `tar -xvzf <filename>` to extract the `.tar.gz` file from command line.
  ```bash
    tar -xvzf apache-maven-${MVN_VER}-bin.tar.gz
   ```
#### Apache Hadoop
Hadoop binaries will be used to run big-data systems.
1. Download the binaries for Hadoop 3.3.6 from [Hadoop download page](https://hadoop.apache.org/releases.html).
```bash
  export HADOOP_VER=3.3.6
 wget -O "hadoop-${HADOOP_VER}.tar.gz"   "https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VER}/hadoop-${HADOOP_VER}.tar.gz"   || wget -O "hadoop-${HADOOP_VER}.tar.gz"   "https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VER}/hadoop-${HADOOP_VER}.tar.gz"
   ```
2. Extract the compressed archive to the course directory.
```bash
    tar -xvzf "hadoop-${HADOOP_VER}.tar.gz"
   ```

---

### 2. Set Environment Variables
In this part, you will configure some environment variables to make sure your programs will run easily and correctly.


1. To test if environment variables are set, run the following commands

    ```bash
    echo $JAVA_HOME
    echo $MAVEN_HOME
    echo $HADOOP_HOME
    ```

    They should print nothing or three empty lines. We will set them shortly.
2. Edit or create the profile, run the following command

    ```bash
    vi ~/.bash_profile
    ```

3. Add the following lines into the profile, and save.
    - Linux

      ```bash
      export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
      export MAVEN_HOME="$HOME/cs167/apache-maven-3.9.6"
      export HADOOP_HOME="$HOME/cs167/hadoop-3.3.6"
      
      export PATH="$JAVA_HOME/bin:$MAVEN_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH"
      ```
 Reload the current environment
    - Run command `source ~/.bash_profile` or `. ~/.bash_profile`.
    - Or, quit the terminal app and restart it.

4. Verify the environment variables again, they should print three non-empty lines with the values you just set.
  ```bash
    echo $JAVA_HOME
    echo $MAVEN_HOME
    echo $HADOOP_HOME
  ```  



### 3. Verify Installed Software

#### JDK

Run command

```bash
javac -version
```

Example output

```text
javac 11.0.28
```

#### Apache Maven

Run command

```bash
mvn -version
```

Example output (contents may differ)

```text
Maven home: /Users/student/cs167/apache-maven-3.9.6
Java version: 11.0.28, vendor: Oracle Corporation, runtime: /Users/student/cs167/jdk-11.0.28.jdk/Contents/Home
Default locale: en_US, platform encoding: UTF-8
OS name: "mac os x", version: "14.2.1", arch: "x86_64", family: "mac"
```

#### Apache Hadoop

Run command

```bash
hadoop version
```

Example output on Linux

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

- Create a new directory "$HOME/cs167/workspace" to place all your projects.

- Open terminal, cd to workspace
  - Linux and macOS: `cd $HOME/cs167/workspace`
  
- Run the following command

  ```bash
  NETID=[UCRNetID e.g. nancy132]
  mvn -B archetype:generate \
  -DgroupId=edu.ucr.cs.cs167.${NETID} \
  -DartifactId=${NETID}_lab1 \
  -Dpackage=edu.ucr.cs.cs167.${NETID} \
  -DarchetypeGroupId=org.apache.maven.archetypes \
  -DarchetypeArtifactId=maven-archetype-quickstart \
  -DarchetypeVersion=1.4 \
  -DinteractiveMode=false
  -DinteractiveMode=false
  ```


- ***(Q1) What is the name of the created directory?***

- Change into the project directory and type

  ```bash
  mvn package
  ```

  This command compiles your project and produces a JAR file with your compiled classes under the target directory.
- To run your newly created program, type

  ```bash
  java -cp "target/${NETID}_lab1-1.0-SNAPSHOT.jar"   edu.ucr.cs.cs167.$NETID.App
  ```


- ***(Q2) What do you see at the console output?***

#### Configure for Hadoop

- Edit your **pom.xml** file and add the following blocks. This adds Hadoop libraries to your dependencies so that you an access Hadoop API.
  1. Find `<properties>` tag, add the following block into it.

      ```xml
      <hadoop.version>3.3.6</hadoop.version>
      ```

  2. If `<properties>` tag is missing, add the following block above `<dependencies>` tag.

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

  4. After editing pom.xml, rebuild:
        
       ```bash
           mvn clean package
       ```
     and run
       ```bash
        java -cp "target/${NETID}_lab1-1.0-SNAPSHOT.jar"   edu.ucr.cs.cs167.$NETID.App
      ```
---

### 5. Create WordCount Example

1. Replace the code in your App.java file with the following code but leave the package line as-is.
   ```bash
     vim ~/cs167/workspace/${NETID}_lab1/src/main/java/edu/ucr/cs/cs167/${NETID}/App.java
   ```

    ```java
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

2. Build and run from the command line..
a) Rebuild the project: 
     ```bash
      mvn clean package 
    ```
b) Try to run with plain `java -cp "target/${NETID}_lab1-1.0-SNAPSHOT.jar"   edu.ucr.cs.cs167.$NETID.App`,

- ***(Q3) What do you see at the output?***
*Hint:* It will fail with an error. Report this error.

- Create a new text file named "input.txt" in the project root folder (same level as "src"), and add the following sample content to it.

    ```text
    cat > input.txt <<'EOF'
    if you cannot fly, then run
    if you cannot run, then walk
    if you cannot walk, then crawl
    but whatever you do you have to keep moving forward
    EOF
    ```

- Now specify "input.txt" and remove potential "output.txt" by `rm -rf output.txt`.


  Note: We will later cover how MapReduce programs are executed in more details. This lab just ensures that you have the development environment setup.

#### Run the WordCount example from Command Line

- At the command line, type:

    ```bash
    mvn package 
    ```

- Try to run your program as we did earlier.

   ```bash
        java -cp "target/${NETID}_lab1-1.0-SNAPSHOT.jar"   edu.ucr.cs.cs167.$NETID.App
    ```


- ***(Q4) Does it run? Why or why not?***

*Hint:* Report the error and explain in a few words what it means.

- Try to run the program using the following command:

    ```bash
    hadoop jar target/${NETID}_lab1-1.0-SNAPSHOT.jar \
    edu.ucr.cs.cs167.${NETID}.App input.txt output.txt
    ```
and see the results using
  ```bash
       ls -l output.txt
       cat output.txt/part-r-00000
  ```


---

- ***(Q5) Does it run now? Why or why not?***

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
log4j:WARN No appenders could be found for logger (org.apache.hadoop.metrics2.lib.MutableMetricsFactory).
log4j:WARN Please initialize the log4j system properly.
log4j:WARN See http://logging.apache.org/log4j/1.2/faq.html#noconfig for more info.
```

**Resolution**: This is just a warning. You can ignore it for now.

