#' A-Frame Scene with R data
#'
#' Create an HTML widget to sync R data with an A-Frame
#' scene via the data-binding A-Frame component.
#'
#' @param data A data frame or a list of vectors, matrices, and/or data frames
#' @param elementId Optionally define the output HTML element \code{id}
#'
#' @details
#' Data will be synced to the \code{data-binding} system from the
#' \href{https://www.npmjs.com/package/gg-aframe}{gg-aframe} JavaScript
#' library for A-Frame. Data can be bound to automatically update components
#' in the scene with the \code{data-binding} A-Frame component. Repeat
#' calls (e.g. within a Shiny reactive expression) will update the
#' \code{data-binding} store and refresh bound components with the new data.
#'
#' If \code{data} is a data frame, each variable will be available, by name,
#' as a JavaScript Array in the scene data store (i.e. long form).
#' If it is a list, each list item will be available, by name, as a
#' JavaScript Array in the scene data store. Data frames within the list
#' will be available as an array of Objects, with each object
#' representing a row from the data frame (i.e. wide form).
#'
#' To send multiple data frames in long form, combine them with
#' \code{c}, and each column will be available by name
#' in the A-Frame \code{data-binding} system. To send multiple
#' data frames in wide form, combine them as named items in
#' a \code{list}, and each data frame will be available as an array of
#' objects (rows) under the name used.
#'
#' Note: \code{aDataScene} is only compatible for use in Shiny
#' apps viewed with a modern Web browser and internet connection.
#' WebVR data visualizations are not available in Rmd documents, R Notebooks,
#' or the RStudio Viewer at this time.
#'
#' @examples
#' library(dplyr)
#' library(scales)
#'
#' # Execute within a renderADataScene call in a Shiny server
#' iris %>%
#'   # scale positional data to (0,1)
#'   mutate_if(is.numeric, rescale) %>%
#'   # make data available in JavaScript
#'   aDataScene()
#'
#' @seealso \code{\link{renderADataScene}}
#'
#' @export
aDataScene <- function(data, elementId = NULL) {
  # keep length 1 vectors as arrays in JS
  attr(data, "TOJSON_ARGS") <- list(auto_unbox = FALSE, keep_vec_names = FALSE)
  htmlwidgets::createWidget(
    name = 'aDataScene',
    data,
    width = NULL,
    height = NULL,
    package = 'shinyaframe',
    elementId = elementId
  )
}


#' Shiny bindings for aDataScene
#'
#' Output and render functions for using aDataScene within Shiny
#' applications.
#'
#' A-Frame v0.7.1, gg-aframe v0.2.3, and
#' aframe-environment-component v1.0.0 come packaged with
#' shinyaframe. To use different versions, set \code{skipDependencies}
#' to \code{TRUE} and source the libraries directly (for
#' example with \code{\link[htmltools]{includeScript}} or
#' \code{\link[htmltools]{tag}}).
#'
#' @param outputId output variable to read from
#' @param ... Attributes, A-Frame components, and/or child elements for
#'   output in HTML.
#' @param skipDependencies Option to omit packaged A-Frame JavaScript
#'   libraries. See details.
#' @param expr An expression that returns a call to \code{aDataScene}
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name aDataScene-shiny
#'
#' @seealso \href{https://github.com/wmurphyrd/gg-aframe#readme}{'gg-aframe' syntax documentation}
#'
#' @examples
#' # Simple 3D scatterplot.
#' # See package vignette for additional asethetics, guides, and legends
#' if (interactive()) {
#'   library(dplyr)
#'   library(shiny)
#'   library(scales)
#'   shinyApp(
#'     ui = fluidPage(
#'       aDataSceneOutput(
#'         outputId = "mydatascene",
#'         # gg-aframe plot syntax
#'         atags$entity(
#'           plot = "", position = "0 1.6 -1.38", rotation = "0 45 0",
#'           atags$entity(
#'             `layer-point` = "", `mod-oscillate` = "",
#'             `data-binding__sepal.length`="target: layer-point.x",
#'             `data-binding__sepal.width`="target: layer-point.y",
#'             `data-binding__petal.length`="target: layer-point.z",
#'             # add 4th positional by animating y position between two mappings
#'             `data-binding__petal.width`="target: mod-oscillate.y",
#'             `data-binding__species`="target: layer-point.shape"
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output, session) {
#'       output$mydatascene <- renderADataScene({
#'         names(iris) <- tolower(names(iris))
#'         iris %>%
#'           # scale positional data
#'           mutate_if(is.numeric, rescale) %>%
#'           aDataScene()
#'       })
#'     }
#'   )
#' }
#'
#' @export
aDataSceneOutput <- function(outputId, ..., skipDependencies = FALSE){
  html <- htmltools::tagList(atags$scene(
    id = outputId,
    class = "aDataScene html-widget html-widget-output",
    `data-binding` = "",
    ...
  ))
  dependencies <- htmlwidgets::getDependency('aDataScene', 'shinyaframe')
  if (skipDependencies) {
    dependencies <- Filter(
      function (x) { x$name %in% c("htmlwidgets", "aDataScene-binding") },
      dependencies
    )
  }
  htmltools::attachDependencies(html, dependencies)
}

#' @rdname aDataScene-shiny
#' @export
renderADataScene <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, aDataSceneOutput, env, quoted = TRUE)
}
