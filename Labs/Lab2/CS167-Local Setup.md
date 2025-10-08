# Lab 2

## Part I: In-home

### 1. Install Required Software (20 minutes)

1. Make sure your user name does not have any space. Otherwise, create a user without space.
2. Create a writable folder with no space in the path, for example:
    - Linux and macOS: "`$HOME/cs167`", where `$HOME` is your home directory
    - Windows: "`%HomeDrive%%HomePath%\cs167`", where `%HomeDrive%%HomePath%` is typically `C:\Users\<username>\`
3. From this point on, we will call this directory *the course directory*.

#### JDK 
We will use JDK as our SDK to compile Java and Scala code in this course.

 1. Download the compressed archive that is right for your operating system. JDK 17 is a stable one.

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
  6. For MacOS, download the `.dmg` installer that is right for your hardware, i.e., Intel or Apple Chip processor.
  7. For Windows and Linux, extract the binaries to the course page. For MacOS, mount the `.dmg` installer and follow the instructions to install the software.

### 2. Set Environment Variables (10 minutes)
In this part, you will configure some environment variables to make sure your programs will run easily and correctly.

#### Linux and MacOS

1. To test if environment variables are set, run the following commands

    ```bash
    echo $JAVA_HOME
    echo $MAVEN_HOME
    ```

    They should output nothing or two empty lines. We will set them shortly.
2. Find which shell you are using, run the following command

    ```bash
    echo $SHELL
    ```

    - If it prints `/usr/bash`, you are using *bash*, the profile file name should be `.bashrc` or `.bash_profile` (note the leading dot).
    - If it prints `/usr/zsh`, you are using *zsh*, the profile file name should be `.zshrc` or `.zprofile` (note the leading dot).
3. Below, we assume that you are using *bash*, and profile file `.bashrc`
4. Edit or create the profile, run the following command

    ```bash
    vi ~/.bashrc # Change the file name accodingly
    ```

5. Add the following lines into the profile, and save.
    - Linux

      ```bash
      export JAVA_HOME="$HOME/cs167/jdk-17.0.9"
      export MAVEN_HOME="$HOME/cs167/apache-maven-3.9.6"
      
      export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH
      ```

    - macOS

      ```bash
      export JAVA_HOME="$HOME/cs167/jdk-17.0.9.jdk/Contents/Home"
      export MAVEN_HOME="$HOME/cs167/apache-maven-3.9.6"
      
      export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH
      ```

6. Reload the current environment
    - Run command `source ~/.bashrc` or `. ~/.bashrc` (Change the file name accodingly).
    - Or, quit the terminal app and restart it.
7. Verify the environment variables again

    ```bash
    echo $JAVA_HOME
    echo $MAVEN_HOME
    ```

    They should print two non-empty lines with the values you just set.

#### Windows

1. To test if environment variables are set, run the following commands
    - Command line promot

      ```console
      echo %JAVA_HOME%
      echo %MAVEN_HOME%
      ```

    - PowerShell or Windows Terminal

      ```console
      echo $Env:JAVA_HOME
      echo $Env:MAVEN_HOME
      ```

    They should output nothing or three empty lines.
2. Press `Win + R` to open the *Run* window.
3. Type `rundll32.exe sysdm.cpl,EditEnvironmentVariables` and press Enter.
4. In *User variables for xxx*, click *New* to add a new environment variable for each of the following 3 pairs:
    - Variable name: `JAVA_HOME`, Variable value: `C:\Users\[username]\cs167\jdk-17.0.9`
    - Variable name: `MAVEN_HOME`, Variable value: `C:\Users\[username]\cs167\apache-maven-3.9.6`
5. Double click variable **Path**, add the following 3 values via "New" button:
    - `%JAVA_HOME%\bin`
    - `%MAVEN_HOME%\bin`
6. Don't forget to click "Ok" to close and save the changes in environment variables.
7. Close and restart the current terminal, and rerun the commands in step 1, they should print 3 non-empty lines with the values you just set.


### 3. Verify Installed Software (10 minutes)

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

### 3. Create an Empty Maven Project (10 minutes)

- Create a new directory "$HOME/cs167/workspace" or "C:\cs167\workspace" to place all your projects for this course.

- Open terminal, change to the workspace directory
  - Linux and macOS: `cd $HOME/cs167/workspace`
  - Windows: `cd C:\cs167\workspace`
  
- Run the following command

  ```bash
  # Replace [UCRNetID] with your UCR Net ID, not student ID.
  mvn archetype:generate "-DgroupId=edu.ucr.cs.cs167.[UCRNetID]" "-DartifactId=[UCRNetID]_lab1" "-DarchetypeArtifactId=maven-archetype-quickstart" "-DinteractiveMode=false"
  ```

  If the above command fails on Windows, you can try Windows Command Prompt (cmd). This command may have some issues with PowerShell and Windows Terminal.
  Alternatively, you can use the [alternative method](#alternative-method) later in this section to create a project via IntelliJ.

- Change into the project directory and type

  ```bash
  mvn package
  ```

  This command compiles your project and produces a JAR file with your compiled classes under the target directory.
- To run your newly created program from the terminal, type

  ```bash
  java -cp target/[UCRNetID]_lab1-1.0-SNAPSHOT.jar edu.ucr.cs.cs167.[UCRNetID].App
  ```

  Replace `[UCRNetID]` with your UCR Net ID, not student ID.

#### Import Your Project into InelliJ IDEA

- Open IntelliJ IDEA and choose "Open".
- Choose the directory of your new Maven project, select the `pom.xml` file.
- In the prompt, choose "Open as Project".
- The project will open. It may take some time to import the project and download neessary dependencies.
- Open the file `App.java` and click the small green arrow to run the main class.

#### An alternative method for creating an empty project

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