# Table Contest 2022 Submission - Tidyverse in Numbers

The rendered table is available on QuartoPub: https://szymanskir.quarto.pub/tidyverse_in_numbers/

## Development Instructions

The project uses `renv` for managing dependencies. To install all required packages run:
```r
renv::restore()
```

The data used in the project is collected using the GitHub API which requires a token to be configured. For that purpose, create a `.Renviron` file with the following content:

```
GITHUB_TOKEN=<YOUR_GITHUB_TOKEN>
```

Follow [this guide](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) to learn how to create a github token.
  
Next, to prepare the data for the table run the `data_ingestion.R` script:

```r
source("data_ingestion.R")
```

This will create an `all_data.RDS` file in the repository. Now to generate the report with the table run:

```r
quarto::quarto_render(input = "table.qmd")
```