# Fuzzy Analysis of Delivery Outcome 📋

Welcome to the **Fuzzy Data Analysis Project**! This GitHub repository highlights how **Fuzzy Logic** is used for analyzing and evaluating delivery outcomes. The whole project is developed in MATLAB, where the rules and analytical methods are applied for interpreting data and measuring performance.

---

## Project Overview

Delivery outcomes aren't always straightforward, sometimes they can be fuzzy! This project takes a dataset of delivery scenarios and applies a fuzzy logic system to effectively analyze success, delays, and other outcome variables. By combining rules, binarization, and G-measure metrics, the scripts evaluates the most probable result.

---

## Repository Structure

The project code is neatly divided into specific tasks, functions, and fuzzy rules definitions. 

| File Name | Description |
| :--- | :--- |
| **`FDA-data-e.xls`** | The raw dataset containing delivery parameters and outcomes. |
| **`FDA_Project.m`** | The main entry script to execute the full fuzzy analysis workflow. |
| **`Task1.m`, `Task2.m`, `Task3.m`** | Modularized project tasks addressing different stages of the assignment. |
| **`Rules.m` & `RulesCombinations.m`**| Definitions of the fuzzy rule-base and how different fuzzy sets interact. |
| **`binarization.m`** | Data preprocessing script for handling thresholds. |
| **`best_result.m`** | Script designed to identify the optimum output based on the evaluated rules. |
| **`g_measure.m` & `g_measure_test.m`** | Calculates the G-measure to validate model accuracy. |
| **`project_task.pdf`** | The original project description and requirements. |

---

## Built With

* **MATLAB** - The core language used for mathematical modeling and fuzzy logic processing.

---

## How It Works
1. Data Ingestion: Reads the FDA-data-e.xls spreadsheet.
2. Preprocessing: Uses binarization.m to handle raw data inputs.
3. Fuzzy Inference: Applies Rules.m and RulesCombinations.m to map inputs to fuzzy sets and generate outcomes.
4. Evaluation: Uses g_measure.m to grade the outputs and best_result.m to identify the most successful configuration.

---

## Acknowledgments
Thank you for checking out this project! Happy coding and may your data always be delightfully fuzzy! ☁️
