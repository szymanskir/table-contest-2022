library(magrittr)


create_history_download_chart <- function(downloads_data) {
  echarts4r::e_chart(downloads_data, x = start, height = "80px", width = "256px") %>% 
    echarts4r::e_line(downloads, symbol = "none") %>% 
    echarts4r::e_legend(show = FALSE) %>% 
    echarts4r::e_axis(axis = "y", show = FALSE) %>% 
    echarts4r::e_tooltip(
      trigger = "axis",
      formatter = htmlwidgets::JS("
        function(params) {
          const downloadsDate = params[0].value[0];
          const downloadsDateLabel = new Date(downloadsDate).
            toLocaleString('en-Us', { month: 'short', year: 'numeric' });
          
          const downloadsCount = params[0].value[1];
          const downloadsCountLabel = echarts.format.addCommas(params[0].value[1]);
          return `
            ${downloadsDateLabel}
            <br/>
            ${downloadsCountLabel}
          `;
        }
      ")
    ) %>% 
    htmlwidgets::onRender(
      htmlwidgets::JS("
        function(el, x) {
          el.parentElement.style.overflow = 'visible';
        }
      ")
    )
}

number_value_icon_cell <- function(value, icon) {
  htmltools::div(
    style = "
      display: flex;
      justify-content: flex-end
    ",
    value,
    htmltools::img(
      src = knitr::image_uri(icon),
      height = "24px",
      width = "24px",
      style = "
        vertical-align: bottom;
        margin-left: 6px;
      "
    )
  )
}

create_table <- function(all_data) {
  table <- reactable::reactable(
    all_data,
    defaultColDef = reactable::colDef(
      headerStyle = "text-align: center"
    ),
    columns = list(
      hex_sticker = reactable::colDef(
        name = "",
        cell = function(value, row_index) {
          row_data <- all_data[row_index, ]
          htmltools::div(
            style = "
              display: flex; 
              align-items: center; 
            ",
            htmltools::div(
              htmltools::img(
                src = value,
                height = "80px"
              )
            ),
            htmltools::div(
              style = "
                margin-left: 24px
              ",
              htmltools::div(
                style = "
                  font-weight: 700;
                ",
                htmltools::a(
                  style = "
                    color: #38577f;
                  ",
                  class = "package_repo_url",
                  href = row_data$repo_url,
                  target = "_blank",
                  row_data$package_name
                ),
              ),
              htmltools::div(
                style = "
                  font-size: 14px;
                  font-style: italic;
                  color: hsl(201, 23%, 34%);
                  line-height: 20px
                ",
                row_data$description
              )
            )
          )
        },
        width = 384
      ),
      repo_url = reactable::colDef(show = FALSE),
      package_name = reactable::colDef(show = FALSE),
      description = reactable::colDef(show = FALSE),
      stargazers = reactable::colDef(
        name = "Stargazers",
        cell = function(value) {
          number_value_icon_cell(value, "icons/star.svg")
        },
        width = 112
      ),
      watchers = reactable::colDef(
        name = "Watchers",
        cell = function(value) {
          number_value_icon_cell(value, "icons/eye.svg")
        },
        width = 112
      ),
      tags = reactable::colDef(
        name = "Tags",
        cell = function(value) {
          number_value_icon_cell(value, "icons/tag.svg")
        },
        width = 80
      ),
      download_stats = reactable::colDef(
        name = "Monthly Downloads",
        cell = function(value) {
          create_history_download_chart(value)
        },
        width = 256,
        style = "overflow: visible;"
      ),
      top_5_contributors = reactable::colDef(
        name = "Top Five Contributors",
        cell = function(value) {
          htmltools::div(
            purrr::map(
              value,
              ~htmltools::span(
                htmltools::img(
                  src = .x$avatar_url,
                  class = "contributor",
                  height = "44px", 
                  style = "
                    border-radius: 100%;
                    box-shadow: rgba(27, 31, 36, 0.15) 0px 0px 0px 1px
                  "
                ) %>% htmltools::a(href = .x$html_url, target="_blank")
              )
            )
          )
        },
        width = 256
      )
    ),
    theme = reactable::reactableTheme(
      cellStyle = list(
        display = "flex",
        flexDirection = "column",
        justifyContent = "center"
      ),
      style = list(
        fontFamily = "Lato, sans-serif"
      )
    ),
    fullWidth = FALSE,
    sortable = FALSE
  ) %>% 
    htmlwidgets::prependContent(
      htmltools::div(
        style = "
          width: 1200px;
        ",
        htmltools::div("Tidyverse in Numbers", style = "padding: 0px 4px; font-size: 28px; font-weight: 700; font-family: Lato, sans-serif;")
      )
    )
  
  
  htmltools::browsable(htmltools::tagList(
    htmltools::tags$head(
      htmltools::tags$style("
        .contributor {
          margin: 0px 2px;
          transition: all 0.2s ease-in-out;
        }
        
        .contributor:hover {
          transform: translateY(-6px);
          transition: all 0.2s ease-in-out;
        }
        
        .package_repo_url {
          text-decoration: none;
        }
        
        .package_repo_url:hover {
          text-decoration: underline;
        }
      ")
    ),
    table
  ))
}

