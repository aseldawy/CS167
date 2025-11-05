# CS167: How to make archive for submission

Assume your UCR Net ID is `abcd012` and it is lab `1`. Change `abcd012` to your own UCR Net ID, and change the lab number accordingly in all places.

The archive file name must be either `abcd012_lab1.tar.gz` or `abcd012_lab1.zip`.

Folder(s) and file(s) to include (just for example, you should use the actual file list for the corresponding lab):

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
### Graphical Interface
1. In Windows Explorer, select the `src` folder, `pom.xml` file, `run.sh` file and `README.md` file.
2. Right-click, and choose "Send-To" -> "Compressed (Zipped) folder".
3. Rename the compressed file name after it is created to `abcd012_lab1.zip`.

### From command line or PowerShell
1. Run the following command
```shell
tar -a -c -f abcd012_lab1.zip src pom.xml run.sh README.md
```
