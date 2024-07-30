# Reset graphic parameters to default
# from: https://stackoverflow.com/questions/9292563/reset-the-graphical-parameters-back-to-default-values-without-use-of-dev-off

# Also:
#library(constructive)
#construct(par())

# reset_par <- eval(parse(text = c(
#   "function () {",
#   # indent
#   paste0("  ", constructive::construct(par())$code),
#   "}"
# )))

#' Reset graphics parameters to default values
#' 
#' 
reset_par <- function(){
  list(
    xlog = FALSE,
    ylog = FALSE,
    adj = 0.5,
    ann = TRUE,
    ask = FALSE,
    bg = "transparent",
    bty = "o",
    cex = 1,
    cex.axis = 1,
    cex.lab = 1,
    cex.main = 1.2,
    cex.sub = 1,
    cin = c(0.15000000000000002, 0.19999999999999998),
    col = "black",
    col.axis = "black",
    col.lab = "black",
    col.main = "black",
    col.sub = "black",
    cra = c(14.400000000000002, 19.2),
    crt = 0,
    csi = 0.19999999999999996,
    cxy = c(0.026041671376170316, 0.03883810155313973),
    din = c(6.999998958333333, 6.989582291666666),
    err = 0L,
    family = "",
    fg = "black",
    fig = rep(c(0, 1), 2),
    fin = c(6.999998958333333, 6.989582291666666),
    font = 1L,
    font.axis = 1L,
    font.lab = 1L,
    font.main = 2L,
    font.sub = 1L,
    lab = c(5L, 5L, 7L),
    las = 0L,
    lend = "round",
    lheight = 1,
    ljoin = "round",
    lmitre = 10,
    lty = "solid",
    lwd = 1,
    mai = c(1.0199999999999998, 0.8199999999999998, 0.8199999999999997, 0.42),
    mar = c(5.1, 4.1, 4.1, 2.1),
    mex = 1,
    mfcol = c(1L, 1L),
    mfg = rep(1L, 4L),
    mfrow = c(1L, 1L),
    mgp = c(3, 1, 0),
    mkh = 0.001,
    new = FALSE,
    oma = numeric(4),
    omd = rep(c(0, 1), 2),
    omi = numeric(4),
    page = TRUE,
    pch = 1L,
    pin = c(5.759998958333334, 5.1495822916666665),
    plt = c(0.1171428745748325, 0.9399999910714273, 0.14593146735193252, 0.8826825458543288),
    ps = 12L,
    pty = "m",
    smo = 1,
    srt = 0,
    tck = NA_real_,
    tcl = -0.5,
    usr = rep(c(0, 1), 2),
    xaxp = c(0, 1, 5),
    xaxs = "r",
    xaxt = "s",
    xpd = FALSE,
    yaxp = c(0, 1, 5),
    yaxs = "r",
    yaxt = "s",
    ylbias = 0.2
  )
}

