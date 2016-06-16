# HEADCOUNT

##### Project Overview

We'll build upon a dataset centered around schools in Colorado provided by the Annie E. Casey foundation. What can we learn about education across the state?

Starting with the CSV data we will:

* build a "Data Access Layer" which allows us to query/search the underlying data
* build a "Relationships Layer" which creates connections between related data
* build an "Analysis Layer" which uses the data and relationships to draw conclusions

***

* [HEADCOUNT Original Spec](https://github.com/turingschool/curriculum/blob/master/source/projects/headcount.markdown)

***

##### Pair Project: Matt Campbell & Kris Sparks

Iterations 1-4 and 6 complete. All tests spec harness tests are passing. Iteration 5 spec harness test is not applicable, since we opted to complete 6 rather than 5. The output from rake sanitation:all shows zero complaints. The rake runs in about 30 seconds with zero errors, failures, or skips.

##### Learning Goals

* Use tests to drive both the design and implementation of code
* Decompose a large application into components such as parsers, repositories, and analysis tools
* Use test fixtures instead of actual data when testing
* Connect related objects together through references
* Learn an agile approach to building software
