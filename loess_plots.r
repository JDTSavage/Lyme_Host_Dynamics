files = list("lifespan_52_Mean_NIP.csv", "lifespan_52_Min_NIP.csv", "lifespan_52_Max_NIP.csv", 
             "lifespan_52_Amp_NIP.csv", "lifespan_52_Mean_DIN.csv", "lifespan_52_Min_DIN.csv", 
             "lifespan_52_Max_DIN.csv", "lifespan_52_Amp_DIN.csv") #, "Mean_DON.csv", "Min_DON.csv", "Max_DON.csv", "Amp_DON.csv",
library(stringr)
library(plot3D)


for (file in files) {

  df = read.csv(paste0("Analysis_Data/Exploratory_Plots/PortlandME_1971-2021/surface_data/", file))
  
  
  measure <- data.frame(mean = df[, 1],
                    sigma = df[, 2],
                    measure = df[, 3])
  
  
  model <- loess(measure ~ sigma + mean, data = measure)
  
  n_facets <- 50
  x_range <-range(measure$sigma)
  x_seq <- seq(from = x_range[1], to = x_range[2], length.out = n_facets)    
  y_range <- range(measure$mean)
  y_seq <- seq(from = y_range[1], to = y_range[2], length.out = n_facets)
  
  z <- outer(X = x_seq, Y = y_seq, FUN = function(sigma, mean) {
    predict(model, data.frame(sigma, mean))	
  })
  
  
  df2 = data.frame(mean = y_seq, sigma = x_seq, measure = z)
  
  write.table(df2, file = paste0("Analysis_Data/Exploratory_Plots/PortlandME_1971-2021/surface_data/", str_replace(file, ".csv", "_surf.csv")), 
             row.names = FALSE, col.names = FALSE)
  
  
  png(filename = paste0("Analysis_Data/Exploratory_Plots/PortlandME_1971-2021/", str_replace(file, ".csv", "_surf.png")), width = 1200, height = 1200,
      units = "px", pointsize = 14, bg = "white", res = 200)

  if (grepl( "DIN", file, fixed = TRUE)) {
    if (grepl("Min", file, fixed = TRUE)) {
      zlab = "Min DIN"
    }
    if (grepl("Max", file, fixed = TRUE)) {
      zlab = "Max DIN"
    }
    if (grepl("Amp", file, fixed = TRUE)) {
      zlab = "Amp DIN"
    }
    if (grepl("Mean", file, fixed = TRUE)) {
      zlab = "Mean DIN"
    }
  } else if (grepl( "DON", file, fixed = TRUE)) {
    if (grepl("Min", file, fixed = TRUE)) {
      zlab = "Min DON"
    }
    if (grepl("Max", file, fixed = TRUE)) {
      zlab = "Max DON"
    }
    if (grepl("Amp", file, fixed = TRUE)) {
      zlab = "Amp DON"
    }
    if (grepl("Mean", file, fixed = TRUE)) {
      zlab = "Mean DON"
    }
  } else if (grepl( "NIP", file, fixed = TRUE)) {
    if (grepl("Min", file, fixed = TRUE)) {
      zlab = "Min NIP"
    }
    if (grepl("Max", file, fixed = TRUE)) {
      zlab = "Max NIP"
    }
    if (grepl("Amp", file, fixed = TRUE)) {
      zlab = "Amp NIP"
    }
    if (grepl("Mean", file, fixed = TRUE)) {
      zlab = "Mean NIP"
    }
  }
  
  # create sequence of z values for axis
  z.axis <- pretty(seq(from = min(z) - 0.01 * (range(z)[2] - range(z)[1]), to = max(z)))
  min.z <- min(z.axis); max.z <- max(z.axis)
  
  # p <- persp(x_seq, y_seq, z, theta=45, phi=30, 
  #            col="#FF000033", shade = 0.1,
  #            xlab="Variance (Mouse)", ylab="Mean (Mouse)", zlab=zlab)
  

  p <- persp3D(x = x_seq, 
             y = y_seq, 
             z = z, 
             phi = 30, theta = 40, 
             contour = list(lwd = 1), # contour is a function, pass arguments using a list.
             # zlim = c(min.z, max.z), 
             col = gg.col(50, 0.35), # jet2 comes with plot 3d, its a color package. 
             colkey = F, border = "#00000018", bty = "f", # box type
             box = TRUE, facets = T,
             xlab = "Host Dynamics", ylab = "Mean (mice ha⁻¹)",
             zlab = zlab, xaxt = 'n')
  dev.off()  
}




# par(mfrow = c(1, 3), mar = c(1.5, 1.5, 0, 0), oma = c(0, 0, 0,0))
# x.axis <- seq(from = -2, to = 2, by = 1)
# min.x <- min(x.axis); max.x <- max(x.axis)
# y.axis <- seq(from = -2, to = 2, by = 1)
# min.y <- min(y.axis); max.y <- max(y.axis)
# z.axis <- pretty(seq(from = -5, to = max(log10(mut.dist.mat), na.rm = T),))
# # pretty() is the underlying function that r uses to choose steps in an axis. 
# # for adding contour lines, use from (lower bound) to make z axis raised a bit.
# min.z <- min(z.axis); max.z <- max(z.axis)
# pmat1 <- persp3D(x = log10(eta.seq), 
#                  y =  log10(beta.seq), 
#                  z = log10(no.mut.dist.mat), 
#                  phi = 7.5, theta = 40, 
#                  contour = list(lwd = 0.5), # contour is a function, pass arguments using a list.
#                  zlim = c(min.z, max.z), 
#                  col = jet2.col(100, 0.35), # jet2 comes with plot 3d, its a color package. 
#                  colkey = F, xlab = "", ylab = "", 
#                  zlab = "", border = "#00000018", 
#                  ticktype = "detailed", bty = "b", # box type
#                  box = TRUE)
