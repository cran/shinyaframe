#' A-Frame Custom Elements
#'
#' Functions to output A-Frame's custom HTML elements
#'
#' These functions are just simple wrappers for
#' \code{\link[htmltools]{tag}} to output common A-Frame custom elements.
#'
#' @format The \code{atags} list contains all of these
#'   tag functions for convenient access.
#'
#' @param ... Attributes, components, and/or child elements
#' @param primitive Primitive name (excluding the "a-")
#' @examples
#' # Construct A-Frame HTML syntax for a 3D scene with a red box and blue sky
#' atags$scene(
#'   atags$box(color = "red", position = "0 0.5 -3"),
#'   atags$other("sky", color = "#89b6ff")
#' )
#'
#' @seealso \href{https://aframe.io}{A-Frame Documentation}
#' @name aframetags
NULL

#' @describeIn aframetags Top level scene entity
#' @export
aframeScene <- function(...) {
  htmltools::tag("a-scene", list(...))
}

#' @describeIn aframetags Specify assets for pre-loading
#' @export
aframeAssets <- function(...) {
  htmltools::tag("a-assets", list(...))
}

#' @describeIn aframetags Reusable component specifications
#' @export
aframeMixin <- function(...) {
  htmltools::tag("a-mixin", list(...))
}

#' @describeIn aframetags Generic entity
#' @export
aframeEntity <- function(...) {
  htmltools::tag("a-entity", list(...))
}

#' @describeIn aframetags Sphere primitive
#' @export
aframeSphere <- function(...) {
  htmltools::tag("a-sphere", list(...))
}

#' @describeIn aframetags Box primitive
#' @export
aframeBox <- function(...) {
  htmltools::tag("a-box", list(...))
}

#' @describeIn aframetags All other primitives
#' @export
aframePrimitive <- function(primitive = "entity", ...) {
  htmltools::tag(paste0("a-", primitive), list(...))
}

#' @rdname aframetags
#' @export
atags <- list(
  box = aframeBox,
  sphere = aframeSphere,
  entity = aframeEntity,
  mixin = aframeMixin,
  assets = aframeAssets,
  scene = aframeScene,
  other = aframePrimitive
)
