# Lab 9: Build Java App using Gradle

This repository contains a step-by-step guide to build a Java application using Gradle. Follow the instructions below to set up, build, and run the application.

## Prerequisites
- Java Development Kit (JDK) installed
- Gradle installed

## Steps

### 1. Install Gradle
Ensure Gradle is installed on your system. You can download it from the [official Gradle website](https://gradle.org/install/) and follow the installation instructions.

### 2. Clone Source Code
Clone the repository from GitHub using the following command:
```bash
git clone https://github.com/Ibrahim-Adel15/build1.git
```
Navigate to the project directory:
```bash
cd build1
```

### 3. Run Unit Test
Run the unit tests to verify the code integrity:
```bash
gradle test
```

### 4. Build App [generate Artifact (build/libs/ivolve-app.jar)]
Build the application and generate the JAR artifact:
```bash
gradle build
```
The generated artifact will be located at `build/libs/ivolve-app.jar`.

### 5. Run App
Run the application using the following command:
```bash
java -jar build/libs/ivolve-app.jar
```

### 6. Verify App is Working
Check the console output or application interface to ensure the app is running as expected. Follow any specific instructions provided in the app's documentation or output.
