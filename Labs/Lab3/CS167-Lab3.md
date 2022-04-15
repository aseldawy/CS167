# Lab 3

## Objectives

* Understand the functional programmin features in Java.
* Use lambda expressions and understand how they work.
* Write a program that passes a function to a function.
* Write a function that returns a function.

## Prerequisites

* Follow the instructions in [Lab #1](../Lab1/CS167-Lab1.md) to setup the development environment.
* If you prefer to use a virtual machine, you can follow the instructions on [this page](../../VirtualMachineSetup.md)

## Overview

In this lab, you will write a program that simply prints numbers in a range that satisfy some conditions, e.g., print even number or odd numbers. You will do that using some basic function programming features in Java.

## Lab Work

Follow the instructions below to complete this lab. If you have any questions, please contact the TA in your lab. Make sure to answer any questions marked by the **(Q)** sign and submit the deliverables marked by the **(S)** sign.

### I. Setup (10 minutes) - In-home part

1. Create a new Java project using Maven for lab 3 either from command line or from IntelliJ. The project name should be `<UCRNetID>_lab3` (Replace `<UCRNetID>` with your UCR Net ID).

### II. Main Program (30 minutes) - In-home part

1. Write a function with the following signature:
```java
public static void printEvenNumbers(int from, int to)
```
This function should first print the following line:
```
Printing numbers in the range [from,to]
```
`from` and `to` should be replaced by the given parameters. After that, it should print all the *even* numbers in the inclusive range `[from, to]`. Each number should be printed on a separate line.

2. Similarly, write another function `printOddNumbers(from, to)`.
3. Write a main function that takes three command-line arguments, `from`, `to`, and `odd`. The first two parameters specify the range of numbers to process. The third parameter is either 1, for odd numbers, or 2, for even numbers. The function should write the following error message and exit if less than three arguments are passed.
```
Error: At least three parameters expected, from, to, and odd.
```
4. The function should read these three parameters and call either the function `printEvenNumbers` or `printOddNumbers` depending on the third parameter.
5. To test your program, try the following parameters.
`10 25 1`
The output should look like the following:
```
Printing numbers in the range [10,25]
11
13
15
17
19
21
23
25
```

At this stage, your program runs correctly but it does not use any of the functional programming features of Java. In the following part, we will see how to convert this simple program to use some functional programming features.
### III. Use functional programming to test even and odd numbers (30 minutes)

1. Add two new classes `IsEven` and `IsOdd`. One of them is provided below for your reference.
```java
static class IsEven implements Function<Integer, Boolean> {
    @Override
    public Boolean apply(Integer x) {
        return x % 2 == 0;
    }
}
```
Make sure to write the other class as well. The code above declares a class named `IsEven` that implements the interface `Function`. It defines a function named `apply` which applies the desired test.

2. Let us try to call the `IsEven` function with the parameter 5. The expected result is `false`. ***(Q1) Which of the following is the right way to call the `IsEven` function? ***

- IsEven(5)
- IsEven.apply(5)
- new IsEven().apply(5)

3. In the next step, we will use the third parameter to choose one of the two functions in a variable called `filter`.
```java
Function<Integer, Boolean> filter = ...
```
4. In this step, write a function that takes a range and a filter function. It should print all numbers in the range that satisfy the given filter. The function header is as follows.
```java
public static void printNumbers(int from, int to, Function<Integer, Boolean> filter)
```
The function should first print the following line followed by each matching number in a separate line.
```
Printing numbers in the range [from,to]
```
5. Change your program to use the function `printNumbers` instead of calling `printEvenNumbers` and `printOddNumbers`.

## IV. More Ways of Creating Functions (10 minutes)
Java provides two additional methods for creating functions easily, *anonymous classes* and *lambda expressions*.

1. Let us create a function that matches all numbers that are divisble by 5. The following code snippet accomplishes that using anonymous classes.
```java
Function<Integer, Boolean> divisibleByFive = new Function<Integer, Boolean>() {
    @Override
    public Boolean apply(Integer x) {
        return x % 5 == 0;
    }
};
```
It runs in the same way as the previous examples. However, instead of creating a *named* class and then instantiating it, this syntax creates an implicit *anonymous* class and instantiates it in one statement.

2. Java 8 introducted *lambda expressions* which makes the creation of functions even easier. The following code snippet creates a function that tests if a number is divisible by 10.
```java
Function<Integer, Boolean> divisibleByTen = x -> x % 10 == 0;
```
Notice that this syntax is just a shorthand to anonymous classes. Both run in the same exact way and they yield the same performance. The Java compiler infers the name of the interface to extend and the types from the declaration and creates the anonymous class and instance accordingly.
3. Test the function `printNumbers` with these two new functions and observe the resutls.

## V. Creating Parametrized Functions (15 minutes)
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

**Note**: This function works by keeping a reference to the final variable `base` and referring to it whenever it is executed. Effectively, the variable *base* becomes an additional parameter to the function.

5. Try this: add the statement `base=0` at the very end of your main function; even after the `printNumbers` call. ***(Q2) Did the program compile?*** 
***(Q3) If it does not work, what is the error message you get?***

## VI. Function Composition (30 minutes)
In this part, we will extend the logic of our program to use *function composition*, i.e., combine multiple functions into one function. In this part, the third parameter can include multiple bases separated with either `^` or `v`. If they are separated by `^`, the program should print numbers that are multiples of *all* the numbers. If they are separated by `v`, it will print the numbers that are multiple of *any* of the numbers. In other words, `^` means `and` and `v` means `or`. Mixing `^` and `v` is not allowed.

1. Parse the third parameter into an array of bases. *Hint*: Using the [String#split](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html#split-java.lang.String-) function. Use the correct separator, either `^` or `v`.
2. Create an array of filters as follows.
```java
Function<Integer, Boolean>[] filters = new Function[bases.length];
```
3. Initialize all the filters based on the corresponding bases.
4. Now, we need to combine all filters into one. For that, we will create two functions, one that combines with with `and` and the other to combine them with `or`. The function delcaration will look as follows.
```java
public static Function<Integer, Boolean> combineWithAnd(Function<Integer, Boolean> ... filters) { ... }
public static Function<Integer, Boolean> combineWithOr(Function<Integer, Boolean> ... filters) { ... }
```

*Note*: The `...` symbol creates a function with a variable number of arguments.

5. Use one of these two functions to combine all filters into one. For example, if you want to combine with with `and`, you can do the following.
```java
Function<Integer, Boolean> filter = combineWithAnd(filters);
```
6. Use the filter function to print all matching numbers in the given range. For example, if you run your program with arguments `3` `20` `3v5`, the output will be as below.
```
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
If you call it with the arguments `3` `20` `3^5` , the output will be as below.
```
Printing numbers in the range [3,20]
15
```

*Note*: In this version of the code, you created a function that takes an array of other functions as an implicit argument. Notice that none of these functions get called until you call the top function that combines all of them.

### VIII. Submission (15 minutes)

1. Add a `README.md` file ([template](https://raw.githubusercontent.com/aseldawy/CS167/master/Labs/Lab3/CS167-Lab3-README.md)) and include all the answers to the questions above in the `README` file.
3. Add a script `run.sh` that will compile your code and run the following cases.
```
3 20 5
3 20 3^5
3 20 3v5
```

4. ***(S) Submit your compressed file as the lab deliverable.***

* Note 1: Don't forget to include your information in the README file.
* Note 2: Don't forget to remove any unnecessary test or binary files.
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

## Notes

* Make sure to follow the naming conventions that are mentioned in Lab #1.
* Do *not* include the target directory or the test input files in your submission.
* Failure to follow these instructions and conventions might result in losing some points. This includes, for example, adding unnecessary files in your compressed file, using different package names, using a different name for the compressed file, not including a runnable script, and not including a `README.md` file.
