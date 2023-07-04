# pdf_generator

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:


## Logging practices in DADT

The application has a logging framework which includes appending the logs at log.txt file. Inorder to maintain the framework, try using devlog().
- If log is an informative log and its important to know the status of the user at that instance. 
- To know whether is there any error or exception or a particular path is followed use devlog

## How to use devlog()?
- devlog(text:"The text you need to log",logType:LogType.INFO)
 for more information go through lib/core/logs.dart

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
