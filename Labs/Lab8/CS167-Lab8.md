# Lab 8

## Objectives

* Understand the document database model.
* Manipulate a set of documents in a database.
* Understand how MongoDB deals with the flexibility of the document data model.

---

## Prerequisites

* Download the following sample file [contacts.json](./contacts.json).
* Download [MongoDB Community Edition](https://www.mongodb.com/try/download/community). We will work with version **6.0.4 (current)**.
  * Linux (Ubuntu): Select `Ubuntu 20.04` in **Platform** and `tgz` in **Package**. Don't select other package types.
    * Direct link: <https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2004-6.0.4.tgz>
    ![MongoDB Server Ubuntu](images/mongodb-ubuntu.png)
    * You may use the MongoDB for Ubuntu 18.04 if your system is that version.
  * macOS: Select `macOS` in **Platform**. The **Package** has only one option `tgz`.
    * Direct link: <https://fastdl.mongodb.org/osx/mongodb-macos-x86_64-6.0.4.tgz>
    ![MongoDB Server Mac](images/mongodb-macOS.png)
    * You may use an older version of MongoDB (4.4 or 4.2) if your system is 10.13 or lower.
  * Windows: Select `Windows` in **Platform** and `zip` in **Package**. Don't select the `msi` package.
    * Direct link: <https://fastdl.mongodb.org/windows/mongodb-windows-x86_64-6.0.4.zip>
    ![MongoDB Server Windows](images/mongodb-windows.png)
* Download [MongoDB Database Tools](https://www.mongodb.com/try/download/database-tools). The current version is **100.6.1**.
  * Linux (Ubuntu): Select `Ubuntu 20.04 x86 64` in **Platform** and `tgz` in **Package**. Don't select the `deb` package.
    * Direct link: <https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2004-x86_64-100.6.1.tgz>
    ![MongoDB Tools Ubuntu](images/mongodb-tools-ubuntu.png)
  * macOS: Select `macOS x86_64` in **Platform**. The **Package** has only one option `zip`.
    * Direct link: <https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-x86_64-100.6.1.zip>
    ![MongoDB Tools Mac](images/mongodb-tools-macOS.png)
  * Windows: Select `Windows x86_64` in **Platform** and `zip` in **Package**. Don't select the `msi` package.
    * Direct link: <https://fastdl.mongodb.org/tools/db/mongodb-database-tools-windows-x86_64-100.6.1.zip>
    ![MongoDB Tools Windows](images/mongodb-tools-windows.png)
* Download [MongoDB Shell](https://www.mongodb.com/try/download/shell). We will use version `1.7.1`.
  * Linux (Ubuntu): Select `Linux Tarball 64-bit` in **Platform* and `tgz`  in **Package**. [Direct Link](https://downloads.mongodb.com/compass/mongosh-1.7.1-linux-x64.tgz)
  ![MongoDB Shell Linux](images/mongodb-shell-ubuntu.png)
  * Mac: Select `MacOS 64-bit (10.14+)` or `MacOS M1 (11.0+)` in **Platform** and `zip` in **Package**.  Direct link for [MacOS 64-bit](https://downloads.mongodb.com/compass/mongosh-1.7.1-darwin-x64.zip) and [MacOS M1](https://downloads.mongodb.com/compass/mongosh-1.7.1-darwin-arm64.zip).
  ![MongoDB Shell Mac](images/mongodb-shell-mac.png)
  * Windows: Select `Windows x86_64 (8.1+)` in **Platform** and `zip` in **Package**. Don't select the `msi` package. [Direct link](https://downloads.mongodb.com/compass/mongosh-1.7.1-win32-x64.zip)
  ![MongoDB Shell Windows](images/mongodb-shell-windows.png)
* If you use the provided virtual machine, it comes with MongoDB pre-installed.
* For testing purposes, you can use the [online web-based MongoDB version](https://mws.mongodb.com/?version=5.0)
* The above choices and links are examples for specific operating systems. You should choose the correct version for your specific hardware and operating system.

---

## Lab Work

### I. Setup MongoDB and Database Tools (20 minutes, In-home)

* Note: If you use the provided virtual machine, you will find that MongoDB is pre-installed.

1. Download the corresponding archive files (either *.zip* or *.tgz*) according to your system.
2. Extract the downloaded MongoDB archive file to your course directory `cs167`.
    * Linux (Ubuntu): `~/cs167/mongodb-linux-x86_64-ubuntu2004-6.0.4`
    * macOS: `~/cs167/mongodb-macOS-x86_64-6.0.4`
    * Windows: `C:\cs167\mongodb-win32-x86_64-windows-6.0.4`
3. Extract the downloaded MongoDB database tools archive file, copy or move all the files inside the `bin` directory to the installed MongoDB's `bin` directory. Available files (on Windows, those should have `.exe` extension) are:
    * bsondump
    * mongoexport
    * mongoimport
    * mongostat
    * mongodump
    * mongofiles
    * mongorestore
    * mongotop

4. Configure environment variables.
    * Linux (Ubuntu):
        1. Add `export MONGODB_HOME="/home/$LOGNAME/cs167/mongodb-linux-x86_64-ubuntu2004-6.0.4"`
        2. Add `$MONGODB_HOME/bin` to `PATH`. Separator is `:`
        3. Reload the profile via `source` command or restart the terminal
    * macOS:
        1. Add `export MONGODB_HOME="/Users/$LOGNAME/cs167/mongodb-macOS-x86_64-6.0.4"`
        2. Add `$MONGODB_HOME/bin` to `PATH`. Separator is `:`
        3. Reload the profile via `source` command or restart the terminal
    * Windows:
        1. Add a user variable with name `MONGODB_HOME` and value `C:\cs167\mongodb-win32-x86_64-windows-6.0.4`
        2. Add `%MONGODB_HOME%\bin` to `Path` variable.
        3. Restart the terminal.

5. Create a `$MONGODB_HOME/data` directory where your data will be stored.
    * Linux and macOS: `mkdir $MONGODB_HOME/data`
    * Windows: `mkdir "%MONGODB_HOME%\data"` for CMD or `mkdir "$Env:MONGODB_HOME\data"` for PowerShell and Windows terminal
6. Start the MongoDB server by running the following command (you must keep the tab/window open while doing this lab).
    * Linux and macOS

        ```bash
        mongod --dbpath $MONGODB_HOME/data
        ```

    * Windows CMD

        ```bat
        mongod --dbpath "%MONGODB_HOME%\data"
        ```

    * Windows PowerShell or Windows Terminal

        ```powershell
        mongod --dbpath "$Env:MONGODB_HOME\data"
        ```

    On macOS, if you see the following error, click `Cancel`.
    ![MacOS Warning](images/unverified-developer-macOS.png)

    To bypass this error, run the following command (you must be a system administrator to use `sudo`).

    ```bash
    sudo spctl --master-disable
    ```

    Then rerun the `mongod` command above. Once it starts, you can run the following command to revert the changes.

    ```bash
    sudo spctl --master-enable
    ```

    See more details about macOS [GateKeeper](https://www.makeuseof.com/how-to-disable-gatekeeper-mac/).

---

### II. Data Manipulation (60 minutes)

1. Import the sample file into a new collection named `contacts`. You will need to use [`mongoimport`](https://www.mongodb.com/docs/database-tools/mongoimport/) command from the database tool. You may use [`--collection`](https://www.mongodb.com/docs/database-tools/mongoimport/#std-option-mongoimport.--collection) and [`--jsonArray`](https://www.mongodb.com/docs/database-tools/mongoimport/#std-option-mongoimport.--jsonArray) two options.
    * ***(Q1) What is your command to import the `contact.json` file?***
    * ***(Q2) What is the output of the import command?***

2. Retrieve all the users sorted by `Name` in ascending order.
    * ***(Q3) What is your command to retrieve all users sorted by Name in ascending order?***

    Hint: Use [`db.collection.find()`](https://www.mongodb.com/docs/manual/reference/method/db.collection.find/#mongodb-method-db.collection.find) and [`cursor.sort()`](https://www.mongodb.com/docs/manual/reference/method/cursor.sort/#mongodb-method-cursor.sort).

3. List only the `_id` and `Name` sorted in **reverse order** by `Name`.
    * ***(Q4) What is your command to retrieve only the `_id` and `Name` sorted in reverse order by `Name`?***

    Hint: You will need to use [`projection`](https://www.mongodb.com/docs/manual/reference/method/db.collection.find/#projection) and [Ascending/Descending Sort](https://www.mongodb.com/docs/manual/reference/method/cursor.sort/#ascending-descending-sort).

4. ***(Q5) Is the comparison of the attribute `Name` case-sensitive?***

   ***(Q6) Explain how you answered (Q5). Show the commands that you ran and how would the output tell you if MongoDB applied case-sensitive or case-insensitive.***

    Hint: To check if a comparison is case sensitive, there must be at least one string with upper case letter and one string with lower case letters. For example, given "**A**pple" and "**B**erry", "**A**pple" **&lt;** "**B**erry" in both case sensitive and insensitive comparisons. However, if you have "**a**pple" and "**B**erry", it will be "**a**pple" **&gt;** "**B**erry" in a case sensitive comparison and "**a**pple" **&lt;** "**B**erry" in a case insensitive comparison. Note that you cannot tell "**A**pple" and "**b**erry" because '**A**' **&lt;** '**b**' in both case sensitive and insensitive comparisons.

    You may check [ASCII table](https://theasciicode.com.ar/).

5. Repeat step 3 above but do not show the `_id` field.
    * ***(Q7) What is the command that retrieves the results in sorted order but without the `_id` field?***

6. Insert the following document to the collection.

    ```json
    {Name: {First: "Yuan", Last: "Zhang"}}
    ```

    * ***(Q8) What is the command to insert the sample document? What is the result of running the command?***
    * ***(Q9) Does MongoDB accept this document while the `Name` field has a different type than other records?***

    Hint: Use [`db.collection.insertOne()`](https://www.mongodb.com/docs/manual/reference/method/db.collection.insertOne/#db.collection.insertone--).

7. Insert the following documen to the collection.

    ```json
    {Name: ["Yuan", "Zhang"]}
    ```
    * ***(Q10) What is your command to insert the record `{Name: ["Yuan", "Zhang"]}`?***


8. Rerun step 3, which lists the records sorted by `Name` in descending order.
    * ***(Q11) Where did the two new records appear in the sort order?***

    * ***(Q12) Why did they appear at these specific locations?***

    Check the [documentation of MongoDB](https://www.mongodb.com/docs/v6.2/reference/bson-type-comparison-order/) to help you answering this question.

9. Rerun step 3, but this time sort the `Name` in **ascending** order.
    * ***(Q13) Where did the two records appear in the ascending sort order? Explain your observation.***

    Hint: [Ascending/Descending Sort](https://www.mongodb.com/docs/manual/reference/method/cursor.sort/#ascending-descending-sort).

    Hint: Use the [skip](https://www.mongodb.com/docs/manual/reference/method/cursor.skip/) command to avoid manually going through results until you reach the very end.

11. Build an index on the `Name` field for the `contacts` collection.
    * ***(Q14) Is MongoDB able to build the index on that field with the different value types stored in the `Name` field?***
    * ***(Q15) What is your command for building the index?***
    * ***(Q16) What is the output of the create index command?***

    Hint: Use [`db.collection.createIndex()`](https://www.mongodb.com/docs/manual/reference/method/db.collection.createIndex/#mongodb-method-db.collection.createIndex).

---

### III. Submission (2 minutes)

1. Write your answers using the [template `README.md`](https://raw.githubusercontent.com/aseldawy/CS167/master/Labs/Lab7/CS167-Lab7-README.md) file.
2. Name your file `<UCRNetID>_lab7_README.md`, replace `<UCRNetID>` with your UCR Net ID.
3. Do not forget to include your information as you do in other labs.
4. No separate code is required for this lab.

## Troubeshooting
*Q:* On Windows, the `mongoimport` command gives me the following error:
```
Failed: error reading separator after document #1: bad JSON array format - found no opening bracket '[' in input source
```

*A:* Try to pass the file through stdin instead of the file name, e.g., `type contacts.json | mongoimport ...` or `cat contacts.json | mongoimport ...`.