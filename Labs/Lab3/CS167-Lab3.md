# Lab 3 - Development Setup and Functional Programming in Java

## Objectives

* Get more familiar with the Java programming language and development tools.
* Understand the functional programming features in Java.
* Use lambda expressions and understand how they work.
* Write a program that passes a function to a function.
* Write a function that returns a function.

## Overview

In this lab, you will write a program that simply prints numbers in a range that satisfy some conditions, e.g., print even number or numbers divisible by three. You will do that using some basic functional programming features in Java.
As we will soon learn, functional programming is one of the primary programming methods used in big-data systems. It allows the programmer to break down the logic into independent functions that can be passed around and executed. Even though Java is not designed as a functional programming language, we can use it as such as you will practice in this lab.

*Note:* You will be asked to write some snippets of code and then improve them later in the lab. Keep the older code commented for grading and review.


## Lab Work

Follow the instructions below to complete this lab. If you have any questions, please contact the TA in your lab. Make sure to answer any questions marked by the ***(Q)*** sign. You must answer the questions at the right step to get the correct output. Do *not* wait until you finish all the steps and then answer the questions. All answers will go in a README file similar to [this one](CS167-Lab3-README.md). Before starting, it is a good idea to make a copy of that file to answer all questions. Please follow Lab2 Videos for creating maven project.



## Part I: In-lab Part

### 1. Main Program (30 minutes)

1. In the main class, add a function with the following signature:

    ```java
    public static void printEvenNumbers(int from, int to)
    ```

    You must use the following code to print the first line:

    ```java
    System.out.printf("Printing numbers in the range [%d,%d]\n", from, to);
    ```

    `from` and `to` should be replaced by the given parameters.  Make sure there is no space in `[%d,%d]`. After that, it should print all the *even* numbers in the inclusive range `[from, to]`. Each number should be printed on a separate line.

2. Similarly, write another function `printNumbersDivisibleByThree(from, to)`.
3. Write a main function that takes three command-line arguments, `from`, `to`, and `base`. The first two parameters specify the inclusive range of numbers to process. The third parameter is either 2, for even numbers, or 3, for numbers divisble by three. The function should write the following error message and exit if less than three arguments are passed.

    ```text
    Error: At least three parameters expected, from, to, and base.
    ```

4. The function should read these three parameters and call either the function `printEvenNumbers` or `printNumbersDivisibleByThree` depending on the third parameter.
5. To test your program, try the following parameters.
    `10 25 2`
    The output should look like the following:

    ```text
    Printing numbers in the range [10,25]
    10
    12
    14
    16
    18
    20
    22
    24
    ```

    At this stage, your program runs correctly but it does not use any of the functional programming features of Java. In the following part, we will see how to convert this simple program to use some functional programming features.

### 2. Use functional programming to test even and odd numbers (30 minutes)

1. Add two new classes `IsEven` and `IsDivisibleByThree`. One of them is provided below for your reference.

    ```java
    static class IsEven implements Function<Integer, Boolean> {
        @Override
        public Boolean apply(Integer x) {
            return x % 2 == 0;
        }
    }
    ```

    Make sure to write the other class as well. The code above declares a class named `IsEven` that implements the interface `Function`. It defines a function named `apply` which applies the desired test.

    *Note:* By convention, class names in Java start with a capital letter while function names start with a small letter.

2. Let us try to call the `IsEven` function with the parameter 5. The expected result is `false`.
    * ***(Q1) Which of the following is the right way to call the `IsEven` function?***
    * IsEven(5)
    * IsEven.apply(5)
    * new IsEven().apply(5)

    *Note:* Since Java is an object-oriented programming language, everything has to be an object including the function. That's why we define a function by defining a class that we can then instantiate into an object.

3. In the next step, we will use the third parameter to choose one of the two functions in a variable called `filter`.

    ```java
    Function<Integer, Boolean> filter = ...
    ````

4. In this step, write a function that takes a range and a filter function. It should print all numbers in the range that satisfy the given filter. The function header is as follows.

    ```java
    public static void printNumbers(int from, int to, Function<Integer, Boolean> filter)
    ```

    The function should first print the following line followed by each matching number in a separate line.

    ```java
    System.out.printf("Printing numbers in the range [%d,%d]\n", from, to);
    ```

5. Change your program to use the function `printNumbers` instead of calling `printEvenNumbers` and `printNumbersDivisibleByThree`.

    *Note:* Do not remove the two functions that you wrote in Part I. These will be part of your grade. Also, do not delete the part of your code that calls them, instead, comment that part out and add a line before that to mention that this your answer to Part I.


## 3. More Ways of Creating Functions (10 minutes)

Java provides two additional methods for creating functions easily, *anonymous classes* and *lambda expressions*.

1. Let us create a function that matches all numbers that are divisble by *five*. The following code snippet accomplishes that using anonymous classes.

    ```java
    Function<Integer, Boolean> divisibleByFive = new Function<Integer, Boolean>() {
        @Override
        public Boolean apply(Integer x) {
            return x % 5 == 0;
        }
    };
    ```

    It runs in the same way as the previous examples. However, instead of creating a *named* class and then instantiating it, this syntax creates an implicit *anonymous* class and instantiates it in one statement.

2. Java 8 introducted *lambda expressions* which make the creation of functions even easier. The following code snippet creates a function that tests if a number is divisible by 10.

    ```java
    Function<Integer, Boolean> divisibleByTen = x -> x % 10 == 0;
    ```

    Notice that this syntax is just a shorthand to anonymous classes. Both run in the same exact way and they yield the same performance. The Java compiler infers the name of the interface to extend and the types from the declaration and creates the anonymous class and instance accordingly.

3. Test the function `printNumbers` with these two new functions and observe the resutls. You will need to check the third parameter, `base`, against 5 and 10 as well.

## 4. Creating Parametrized Functions (15 minutes)

In this part, we will add more logic to the functions using *parametrized functions*. We would like to change the logic of our program to work as follows. It will still take three parameters, from, to, and base. It will print all numbers in the range `[from,to]` that are divisible by `base`. For example, if `base=3`, it will print all numbers that are multiples of 3 in the inclusive range `[from,to]`.

**Note**: We will no longer need some of the functions that we created earlier, e.g., `IsEven` and `IsOdd`. However, do not remove them from your code and include them in your final submission.

1. Change your main function to parse the third parameter as an integer in a variable called `base`.

    ```java
    int base = Integer.parseInt(args[2]);
    ```

2. Create a function that tests if a number is divisible by `base`. Complete the following code snippet.

    ```java
    Function<Integer, Boolean> divisibleByBase = ...;
    ```

3. Call the function `printNumbers` with the correct parameters.
4. Test your program with the parameters `3` `20` `5`. The output should be as follows.

    ```
    Printing numbers in the range [3,20]
    5
    10
    15
    20
    ```

    *Note*: This function works by keeping a reference to the final variable `base` and referring to it whenever it is executed. Effectively, the variable *base* becomes an additional parameter to the function.

5. Try this: add the statement `base=0;` at the very end of your main function; even after the `printNumbers` call.
    * ***(Q2) Did the program compile after you added the `base=0` line?***
    * ***(Q3) If your answer to (Q2) is No, what is the error message you get?***

6. Remove the statement `base=0;` after answering the above two questions.

## 5. Function Composition (30 minutes)

In this part, we will extend the logic of our program to use *function composition*, i.e., combine multiple functions into one function. In this part, the third parameter can include multiple bases separated with either `,` or `v`. If they are separated by `,`, the program should print numbers that are multiples of *all* the numbers. If they are separated by `v`, it will print the numbers that are multiple of *any* of the numbers. In other words, `,` means `and` and `v` means `or`. For simplicity, mixing `,` and `v` is not allowed.

1. Parse the third parameter into an array of bases. *Hint*: Using the [String#split](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html#split-java.lang.String-) function. Use the correct separator, either `,` or `v`.
2. Create an array of filters as follows.

    ```java
    Function<Integer, Boolean>[] filters = new Function[bases.length];
    ```

3. Initialize all the filters based on the corresponding bases.
4. Now, we need to combine all filters into one. For that, we will create two functions, one that combines with `and` and the other to combine them with `or`. The function delcaration will look as follows.

    ```java
    public static Function<Integer, Boolean> combineWithAnd(Function<Integer, Boolean> ... filters) { ... }
    public static Function<Integer, Boolean> combineWithOr(Function<Integer, Boolean> ... filters) { ... }
    ```

    *Note*: The `...` symbol creates a function with a variable number of arguments. You can treat that parameter as an array.

5. Use one of these two functions to combine all filters into one based on the user-provided separator (comma or `v`). For example, if you want to combine with with `and`, you can do the following.

    ```java
    Function<Integer, Boolean> filter = combineWithAnd(filters);
    ```

6. Use the filter function to print all matching numbers in the given range. For example, if you run your program with arguments "`3 20 3v5`", the output will be as below.

    ```text
    Printing numbers in the range [3,20]
    3
    5
    6
    9
    10
    12
    15
    18
    20
    ```

    If you call it with the arguments "`3 20 3,5`" , the output will be as below.

    ```text
    Printing numbers in the range [3,20]
    15
    ```

    *Note*: In this version of the code, you created a function that takes an array of other functions as an input. Notice that none of these functions gets called until you call the top function that combines all of them.

### 6. Package your submission (15 minutes)

- To run your program from the terminal, configure the main class in the `pom.xml` file as follows.
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

- Then, rebuild the project/jar file by runn the following command in the terminal.

  ```bash
  mvn package
  ```

- Now, you can run your program using the following command at the terminal.
   ```bash
   java -jar target/[UCRNetID]_lab1-1.0-SNAPSHOT.jar ...
   ```
- Answer all the questions above in the README file. For each question, copy/paste the question first and then enter your answer in a new line.

- Add your name, email, UCR Net ID, and Student ID in the README file that contains all your answers.

- Add any additional information that you think are important.
- Feel free to style your README file using Markdown
<https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet>
You can also refer to our template at [HERE](CS167-Lab1-README.md) (Click on the `<>` icon to Display the source blob, or click Raw to see the original content).
- Add a script file `run.sh` that will compile and run your program. Find a sample below (Replace `[UCRNetID]` with your UCR Net ID, not student ID).

  ```shell script
  #!/usr/bin/env sh
  mvn clean package
  java -jar target/[UCRNetID]_lab1-1.0-SNAPSHOT.jar 3 20 5
  java -jar target/[UCRNetID]_lab1-1.0-SNAPSHOT.jar 3 20 3,5
  java -jar target/[UCRNetID]_lab1-1.0-SNAPSHOT.jar 3 20 3v5
  ```

- Package the source files into a compressed file. Only the following files and directories should be included in your submission.

  ```text
  src/
  pom.xml
  README.md
  run.sh
  ```

  Check [here](../MakeArchive.md) for how to make the archive file in `.tar.gz` or `.zip` format with only required files.


### 6. Submission Instructions

1. **Include Required Files**:  
   Your submission must include:
   - `README.md` with answers to all lab questions.
   - A runnable script `run.sh` that compiles your code and runs the following cases:
     ```text
     3 20 5
     3 20 3,5
     3 20 3v5
     ```
   - The folder structure and file names must match the format below:
     ```
     [UCRNetID]_lab1.{tar.gz | zip}
       ├── src/
       ├── pom.xml
       ├── README.md
       └── run.sh
     ```
   - Files must be directly in the root of the archive (no additional folders).

2. **Validation**:  
   - Ensure your `run.sh` works by testing with the following steps:
     1. Download your submission from Canvas.
     2. Extract it into a temporary folder.
     3. Run `run.sh` and confirm there are no unexpected errors.

3. **Archive Guidelines**:
   - Use `.tar.gz` or `.zip` format.
   - Name the archive in all lowercase with underscores (e.g., `ucrnetid_lab1.tar.gz`).

4. **Important Notes**:
   - Remove unnecessary files (e.g., test or binary files).
   - Follow naming conventions strictly.
   - Failure to follow these guidelines may result in point deductions. 


---

## Frequent Problems

**Problem**

Environment variables do not preserve. All `*_HOME` variables become empty when the terminal restarts.

**Resolution**

- If you see `(base)` in the begining of every line in the terminal, it's likely you have **Conda** (Anaconda, miniforge, etc) installed. Run the following command to disable its auto-start.

  ```bash
  conda config --set auto_activate_base false
  ```

- It is possible some profile file of higher priority overrides the file you edited. For example, `.bash_profile` may override `.bashrc`, and `.zprofile` may override `.zshrc`. Try to move your settings to a file with higher priority.

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
