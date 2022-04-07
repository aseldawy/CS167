# CS167: How to make archive for submission

Assume your UCR Net ID is `abcd012` and it is lab `1`.

The archive file name must be either `abcd012_lab1.tar.gz` or `abcd012_lab1.zip`.

Folder(s) and file(s) to include:

* src/
* pom.xml
* run.sh
* README.md

## Linux

To create `.tar.gz` file, run the following command in your project folder (`abcd012_lab1`):

```bash
tar -czf abcd012_lab1.tar.gz src pom.xml run.sh README.md
```

To create `.zip` file, run the following command in your project folder (`abcd012_lab1`):

```bash
zip abcd012_lab1.zip -ur src pom.xml run.sh README.md
```

## MacOS

MacOS may create some hidden systems files which you shall not include in your submission. You should run one more command to remove those files before making the archive.

To create `.tar.gz` file, run the following commands in your project folder (`abcd012_lab1`):

```bash
find src -name ".*" -exec rm -fr {} \;
tar -czf abcd012_lab1.tar.gz src pom.xml run.sh README.md
```

To create `.zip` file, run the following commands in your project folder (`abcd012_lab1`):

```bash
find src -name ".*" -exec rm -fr {} \;
zip abcd012_lab1.zip -ur src pom.xml run.sh README.md
```

## Windows

You may use [7-Zip](https://www.7-zip.org/) to create the archive file.

To create `.tar.gz` file:

1. In Windows Explorer, select the `src` folder, `pom.xml` file, `run.sh` file and `README.md` file.
2. Right click to show the context menu, select **7-Zip**, then select **Add to archive...**.
3. Change **Archive format** to `tar`. Also, change the archive name to `abcd012_lab1.tar`, then click **OK** to create a `.tar` file.
    * Make sure the archive format is `tar`, not the other options.
4. In Windows Explorer, select `abcd012_lab1.tar` you just created, right click it to show the context menu, select select **7-Zip**, then select **Add to archive...**.
5. Change **Archive format** to `gzip`. The archive name should be automatically changed to `abcd012_lab1.tar.gz`. If not, manually change the archive name. Then click **OK** to create a `.tar.gz` file.
    * Make sure the archive format is `gzip`, not the other options.

To create `.zip` file:

1. In Windows Explorer, select the `src` folder, `pom.xml` file, `run.sh` file and `README.md` file.
2. Right click to show the context menu, select **7-Zip**, then select **Add to archive...**.
3. Change **Archive format** to `zip`. Also, change the archive name to `abcd012_lab1.zip`, then click **OK** to create a `.zip` file.
    * Make sure the archive format is `zip`, not the other options.
