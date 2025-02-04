# **Ancestry Analysis and Discrepancy Modeling in R**  

This repository contains an R script to analyze ancestry proportions, filter phenotype data based on VCF individuals, model discrepancies using Poisson regression, and process population phenotype data. The workflow includes data visualization, regression modeling, and data filtering for further analysis.  

---

## **Table of Contents**  
- [Introduction](#introduction)  
- [Requirements](#requirements)  
- [Usage](#usage)  
- [Features](#features)  
- [File Descriptions](#file-descriptions)  
- [Output Files](#output-files)  

---

## **Introduction**  
This project focuses on:  
✔ Visualizing ancestry proportions for individuals using bar plots.  
✔ Filtering phenotype data to retain only individuals present in a given VCF file.  
✔ Modeling discrepancies between different VCFs using Poisson regression.  
✔ Identifying dominant ancestry and saving IDs based on ancestry proportions.  
✔ Handling population phenotype data from an Excel sheet and saving unique IDs.  

---

## **Requirements**  
Ensure you have the following R libraries installed:  
```r
install.packages(c("ggplot2", "tidyr", "dplyr", "readxl"))
```

Alternatively, load them in R before running the script:

library(ggplot2)
library(tidyr)
library(dplyr)
library(readxl)

## **Usage**  

### **1. Prepare Input Files:**  
- `phenotype_file.txt` → Contains ancestry proportions per individual.  
- `individual_ids.txt` → List of individual IDs from the VCF file.  
- `First_vs_Second_VCF_Comparison_Stats.txt` → Contains discrepancy statistics per individual.  
- `Ancester_3_ids.txt` → IDs for specific ancestry-based filtering.  
- `new_sample_names.txt` → List of new sample IDs.  
- `Population_phenotype_data.xlsx` → Population phenotype dataset with `SUBJID` and `WHICAPID`.

### **2. Running the Script**  
To execute the R script, run:  
```r
source("ancestry_analysis.R")
```

This will:  
- ✔ Generate ancestry proportion plots.  
- ✔ Filter and merge phenotype data with VCF-based IDs.  
- ✔ Fit Poisson regression models for discrepancy analysis.  
- ✔ Extract dominant ancestry labels.  
- ✔ Save processed data to CSV and text files.  


## **Features**  

### **1. Ancestry Proportion Visualization**  
- Converts wide-form ancestry data into long format using `tidyr::pivot_longer()`.  
- Uses `ggplot2` to create stacked bar plots of ancestry proportions per individual.  

### **2. Phenotype Data Filtering**  
- Reads individual IDs from a VCF file (`individual_ids.txt`).  
- Filters phenotype data to retain only individuals present in the VCF.  

### **3. Poisson Regression for Discrepancy Modeling**  
- Reads `First_vs_Second_VCF_Comparison_Stats.txt` for discrepancy counts.  
- Sorts phenotype data based on discrepancy dataset order.  
- Fits a Poisson regression model:  
  ```r
  model <- glm(TotalDiscrepancies ~ Ancester_3, data = merged_data, family = poisson(link = "log"))
  ```

## **Outputs Model Summary**  
The Poisson regression model is fitted, and its summary is generated for analysis.

---

## **4. Identifying Dominant Ancestry**  
- Determines the dominant ancestry for each individual.  
- Saves separate ID files for different ancestry groups.  

---

## **5. Handling Population Phenotype Data**  
- Reads new sample IDs (`new_sample_names.txt`).  
- Extracts matching rows from `Population_phenotype_data.xlsx`.  
- Saves unique population IDs to `population_IDs_no_duplicates.txt`.  

---

## **File Descriptions**  

| File Name | Description |
|-----------|------------|
| `ancestry_analysis.R` | Main script for analysis. |
| `phenotype_file.txt` | Phenotype data with ancestry proportions. |
| `individual_ids.txt` | Individual IDs from VCF file. |
| `First_vs_Second_VCF_Comparison_Stats.txt` | Discrepancy data between VCFs. |
| `Ancester_3_ids.txt` | List of IDs for specific ancestry filtering. |
| `new_sample_names.txt` | Sample IDs for population phenotype extraction. |
| `Population_phenotype_data.xlsx` | Excel sheet with population phenotype data. |
| `Code/merged_data.csv` | Processed merged dataset. |
| `population_IDs_no_duplicates.txt` | Unique population IDs extracted from phenotype data. |

---

## **Output Files**  

| File Name | Description |
|-----------|------------|
| `merged_data.csv` | Merged dataset of discrepancies and ancestry proportions. |
| `Dominant_Ancestry_IDs.txt` | IDs of individuals categorized by dominant ancestry. |
| `Ancester_3_Ancester_1_ids.txt` | IDs for individuals with high `Ancester_3` proportion. |
| `population_IDs.txt` | Extracted population IDs. |
| `population_IDs_no_duplicates.txt` | Unique population IDs after duplicate removal. |

---

