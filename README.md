# Table Contest 2022 Submission - Tidyverse in Numbers

![](./gifs/table_contest_2022.gif)

> The rendered table is available on QuartoPub: https://szymanskir.quarto.pub/tidyverse_in_numbers/

Explore different GitHub stats related to the core Tidyverse packages. See how their download numbers were changing over time, and see who are the top 5 contributors of your favorite package.

The table was created using [reactable](https://github.com/glin/reactable/) and the plots within it are created using [echarts4r](https://echarts4r.john-coene.com/). The icons used in the submission come from [heroicons](https://heroicons.com/).

There were two data sources: GitHub statistics fetched using [gh](https://github.com/r-lib/gh) and monthly download stats gathered using [dlstats](https://github.com/GuangchuangYu/dlstats).

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