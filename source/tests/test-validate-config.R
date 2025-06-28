# Helper: Create a temporary YAML file from a list
write_temp_yaml <- function(config_list) {
    path <- tempfile(fileext = ".yml")
    yaml::write_yaml(config_list, path)
    path
}

# Example of a valid configuration
valid_config <- list(
    data_source = "local",
    csv_files = c("Application_1.csv", "Application_2.csv"),
    station_ids = NULL,
    run_eda = TRUE,
    split_selection = "automatic",
    split_points = NULL,
    significance_level = 0.05,
    bbmk_samples = 10000L,
    run_ffa = TRUE,
    ns_selection = "preset",
    ns_signature = NULL,
    z_samples = 10000L,
    distribution_selection = "preset",
    distribution_name = "gev",
    gev_prior = c(6, 9),
    s_estimation = "l-moments",
    ns_estimation = "mle",
    return_periods = c(2, 5, 10, 20, 50, 100),
    sb_samples = 10000L,
    rfpl_tolerance = 1e-2,
    s_uncertainty = "s-bootstrap",
    ns_uncertainty = "rfpl",
    pp_formula = "weibull",
    show_trend = TRUE,
    anchor_year = NULL,
    generate_report = TRUE,
    report_formats = c("markdown", "pdf")
)

test_that("Valid configuration passes", {
    path <- write_temp_yaml(valid_config)
    config <- validate.config(path)
    expect_type(config, "list")
})

test_that("Missing file throws error", {
    expect_error(validate.config("nonexistent_file.yml"), "does not exist")
})

test_that("Missing required field throws error", {
    config_missing <- valid_config
    config_missing$run_ffa <- NULL
    path <- write_temp_yaml(config_missing)
    expect_error(validate.config(path), "Missing options: 'run_ffa'")
})

test_that("Unexpected field throws error", {
    config_extra <- valid_config
    config_extra$extra_field <- "invalid"
    path <- write_temp_yaml(config_extra)
    expect_error(validate.config(path), "Unknown options: 'extra_field'")
})

test_that("Type mismatch throws error", {
    config_wrong_type <- valid_config
    config_wrong_type$run_eda <- "yes"
    path <- write_temp_yaml(config_wrong_type)
    expect_error(validate.config(path), "Invalid type for 'run_eda'")
})

test_that("Invalid enumeration value throws error", {
    config_invalid_value <- valid_config
    config_invalid_value$split_selection <- "random"
    path <- write_temp_yaml(config_invalid_value)
    expect_error(validate.config(path), "must be one of")
})

test_that("Invalid numeric value throws error", {
    config_invalid_value <- valid_config
    config_invalid_value$significance_level <- 0.001
    path <- write_temp_yaml(config_invalid_value)
    expect_error(validate.config(path), "'significance_level' must be within")
})

test_that("Cross-field constraint: GMLE requires GEV", {
    config_bad_cross <- valid_config
    config_bad_cross$s_estimation <- "gmle"
    config_bad_cross$distribution_name <- "glo"
    path <- write_temp_yaml(config_bad_cross)
    expect_error(validate.config(path), "s_estimation: 'gmle' requires.*distribution_name: 'gev'")
})

test_that("Cross-field constraint: RFPL requires MLE", {
    config_rfpl <- valid_config
    config_rfpl$s_uncertainty <- "rfpl"
    config_rfpl$s_estimation <- "gmle"
    path <- write_temp_yaml(config_rfpl)
    expect_error(validate.config(path), "s_uncertainty: 'rfpl' requires s_estimation: 'mle'")
})

test_that("CSV files must exist", {
    config_csv <- valid_config
    config_csv$data_source <- "local"
    config_csv$csv_files <- c("not_found.csv")
    path <- write_temp_yaml(config_csv)
    expect_error(validate.config(path), "csv_file.*does not exist")
})

