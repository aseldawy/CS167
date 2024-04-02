#!/usr/bin/env sh
mvn clean package
hadoop jar target/testproject-1.0-SNAPSHOT.jar input.txt output.txt