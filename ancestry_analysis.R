library(ggplot2)
library(tidyr)
library(dplyr)

# Read the phenotype data
phenotype_data <- read.table("phenotype_file.txt", header = TRUE)


# Convert wide data to long format
df_long <- phenotype_data %>%
  pivot_longer(cols = c(Ancester_1, Ancester_2, Ancester_3), names_to = "Ancestry", values_to = "Proportion")


ggplot(df_long, aes(x = IID, y = Proportion, fill = Ancestry)) +
  geom_bar(stat = "identity", position = "stack") +
  theme_minimal() +
  labs(title = "Ancestry Proportions for Each Individual",
       x = "Individuals",
       y = "Proportion",
       fill = "Ancestry") +
  theme(axis.text.x = element_blank())


# Read individual IDs from the VCF file
vcf_ids <- read.table("individual_ids.txt", header = FALSE, stringsAsFactors = FALSE)$V1

# Load phenotype data
# Ensure 'IID' column is a character type for accurate matching
phenotype_data$IID <- as.character(phenotype_data$IID)

# Filter the phenotype data to keep only individuals present in VCF
filtered_phenotype_data <- phenotype_data[phenotype_data$IID %in% vcf_ids, ]

######################################
error_data <- read.table("First_vs_Second_VCF_Comparison_Stats.txt", header = TRUE, stringsAsFactors = FALSE)

# Sort filtered_phenotype_data based on the order of IID in error_data
sorted_phenotype_data <- filtered_phenotype_data[match(error_data$Individual, filtered_phenotype_data$IID), ]

# View the sorted data
head(sorted_phenotype_data)

model < - glm(error_data$TotalDiscrepancies ~ sorted_phenotype_data$Ancester_3, sorted_phenotype_data, family = poisson(link = "log"))

# Merge the datasets by IID
merged_data <- merge(error_data, sorted_phenotype_data, by.x = "Individual", by.y = "IID")
write.csv(merged_data, "Code/merged_data.csv", row.names = FALSE)

merged_data$TotalDiscrepancies_shifted <- merged_data$TotalDiscrepancies - min(merged_data$TotalDiscrepancies) + 1

# Fit the Poisson regression model
model <- glm(TotalDiscrepancies_shifted ~ Ancester_3, data = merged_data, family = poisson(link = "log"))

# View the model summary
summary(model)

######################################
ans_1_error_data <- read.table("Ancester_3_ids.txt", header = FALSE, stringsAsFactors = FALSE)

# Filter merged_data to keep only Individuals present in ans_1_error_data$V1
ans_1_filtered_data <- merged_data %>% filter(Individual %in% ans_1_error_data$V1)

model_anr <- glm(TotalDiscrepancies_shifted ~ Ancester_3, data = ans_1_filtered_data, family = poisson(link = "log"))

# View the model summary
summary(model_anr)
######################################




# Get ancestry columns
ancestry_cols <- c("Ancester_1", "Ancester_2", "Ancester_3")

# Identify the dominant ancestry for each individual
filtered_phenotype_data$Dominant_Ancestry <- apply(
  filtered_phenotype_data[, ancestry_cols], 1, 
  function(x) ancestry_cols[which.max(x)]
)

# Keep only relevant columns
filtered_phenotype_data <- filtered_phenotype_data[, c("IID", "Dominant_Ancestry")]

# Filter individuals where Ancester_3 > 50%
filtered_phenotype_data_ancester_1 <- filtered_phenotype_data[filtered_phenotype_data$Ancester_3 > 0.50, ]


# Plot the distribution of dominant ancestry
ggplot(filtered_phenotype_data, aes(x = Dominant_Ancestry, fill = Dominant_Ancestry)) +
  geom_bar() +
  theme_minimal() +
  labs(title = "Distribution of Dominant Ancestry",
       x = "Ancestry",
       y = "Count",
       fill = "Ancestry") +
  theme(legend.position = "none")


# Save IDs for each ancestry separately
unique_ancestries <- unique(filtered_phenotype_data$Dominant_Ancestry)

data_path = "file/path/"
for (ancestry in unique_ancestries) {
  subset_ids <- filtered_phenotype_data$IID[filtered_phenotype_data$Dominant_Ancestry == ancestry]
  write.table(subset_ids, file = paste0(data_path,ancestry, "_IDs.txt"), row.names = FALSE, col.names = FALSE, quote = FALSE)
}


# Save IDs for Ancester 3 only
Ancester_1_ids <- filtered_phenotype_data_ancester_1$IID
write.table(Ancester_1_ids, file = "Ancester_3_Ancester_1_ids.txt", 
            row.names = FALSE, col.names = FALSE, quote = FALSE)

cat("Ancestry IDs saved successfully!\n")





# Load necessary libraries
library(readxl)

# Read the new sample IDs from the text file
sample_ids <- readLines("new_sample_names.txt")

# Load the Excel file into a data frame
df <- read_excel("Population_phenotype_data.xlsx")

# Filter rows where SUBJID matches any entry in sample_ids
filtered_df <- df[df$SUBJID %in% sample_ids, ]

# Extract the WHICAPID column
whicap_ids <- filtered_df$WHICAPID

# Save the extracted WHICAPID values to a text file
writeLines(whicap_ids, "population_IDs.txt")

cat("IDs saved successfully!\n")






# Read the WHICAP_IDs.txt file
whicap_ids <- readLines("population_IDs.txt")

# Remove duplicate entries
unique_whicap_ids <- unique(whicap_ids)

# Save the unique IDs to a new text file
writeLines(unique_whicap_ids, "population_IDs_no_duplicates.txt")

cat("population_IDs_no_duplicates.txt saved successfully!\n")