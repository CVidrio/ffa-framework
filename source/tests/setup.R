# Get the data path from the environment options
data_path <- getOption("data_dir", default = "../../data")

# Load CSV files in the data path
source("../load-data.R")
data1 <- load(data_path, "Application_1.csv")
data2 <- load(data_path, "Application_2.csv")
data3_1 <- load(data_path, "Application_3.1.csv")
data3_2 <- load(data_path, "Application_3.2.csv")
data3_3 <- load(data_path, "Application_3.3.csv")

