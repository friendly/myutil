#' Find Named Color Closest to Given Hex RGB Colors

#' This function calculates the distance (in CIE Lab color space) between
#' the input colors (in RGB hex notation) and all named \code{colors()}
#' It returns the closest named color within a given threshold distance.

#' @param cols A vector of colors, in RGB hex notation, e.g., \code{"\#00AE30"}
#' @param near Threshold for nearest color from \code{colors()}.  The default corresponds to 1 JND in Lab space.
#' @return     A vector of color names, or the hex value if no color is close enough
#' @export
#' @importFrom grDevices colors col2rgb convertColor

#' @examples
#' cols <- c("#010101", "#EEEEEE", "#AA0000", "#00AA00", "#0000AA", "#AAAA00", "#AA00AA", "#00AAAA")
#' (nms <- rgb2col(cols))
#' pie(rep(1, 2*length(cols)), labels=c(rbind(cols, nms)), col=c(rbind(cols, nms)))


#' @source From J. Fox, R-help, 5-30-2013

rgb2col <- function(cols, near=2.3) {
    all.names <- colors()
    all.lab <- t(convertColor(t(col2rgb(all.names)), from="sRGB", to="Lab", scale.in=255))
    find.near <- function(x.lab) {
        sq.dist <- colSums((all.lab - x.lab)^2)
        rbind(all.names[which.min(sq.dist)], min(sq.dist))
    }
    cols.lab <- t(convertColor(t(col2rgb(cols)), from="sRGB", to="Lab", scale.in=255))
    cols.near <- apply(cols.lab, 2, find.near)
    ifelse(cols.near[2, ] < near^2, cols.near[1, ], cols)
}


