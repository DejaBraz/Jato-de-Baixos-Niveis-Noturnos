setwd('C:/Users/Deja/Documents/Python Scripts/perfil/Arg')

#dev.off()


climatologia_N <- read.table('Vene.DJF.comjato.00-06.txt', sep='\t', head=TRUE)

climatologia_D <- read.table('Vene.MAM.comjato.12-18.txt', sep='\t', head=TRUE)

jet_days_N <- read.table('Vene.JJA.comjato.12-18.txt', sep='\t', head=TRUE)

not_jet_days_N <- read.table('Vene.SON.comjato.00-06.txt', sep='\t', head=TRUE)

n_clim_N <- climatologia_N$Level
v_clim_N <- climatologia_N$Velocity

n_clim_D <- climatologia_D$Level
v_clim_D <- climatologia_D$Velocity

n_jet_N <- jet_days_N$Level
v_jet_N <- jet_days_N$Velocity

n_not_jet_N <- not_jet_days_N$Level
v_not_jet_N <- not_jet_days_N$Velocity

plot(v_clim_N , n_clim_N , type='l', ylim=c(1000,500), xlim=c(1,12), xaxs = "i", yaxs = "i", 
     xlab='Wind Velocity (m/s)', ylab='Height (levels)', yaxp=c(1000,500,20), las=1, xaxp=c(2, 12,10), col="black", lwd = 3.5,font=4)

#points(6.103826, 53, col = "red", pch = 19, lwd=3)

# draw an axis on the left 

mtext("Height (m)", side=4, line=3, cex=0.75)

abline(h=975, col = "lightgray", lty = 5)
abline(h=950, col = "lightgray", lty = 5)
abline(h=925, col = "lightgray", lty = 5)
abline(h=900, col = "lightgray", lty = 5)
abline(h=875, col = "lightgray", lty = 5)
abline(h=850, col = "lightgray", lty = 5)
abline(h=825, col = "lightgray", lty = 5)
abline(h=800, col = "lightgray", lty = 5)
abline(h=775, col = "lightgray", lty = 5)
abline(h=750, col = "lightgray", lty = 5)
abline(h=725, col = "lightgray", lty = 5)
abline(h=700, col = "lightgray", lty = 5)
abline(h=675, col = "lightgray", lty = 5)
abline(h=650, col = "lightgray", lty = 5)
abline(h=625, col = "lightgray", lty = 5)
abline(h=600, col = "lightgray", lty = 5)
abline(h=575, col = "lightgray", lty = 5)
abline(h=550, col = "lightgray", lty = 5)
abline(h=525, col = "lightgray", lty = 5)


abline(v=3, col = "lightgray", lty = 5)
#abline(v=3.5, col = "lightgray", lty = 5)
abline(v=5, col = "lightgray", lty = 5)
#abline(v=4.5, col = "lightgray", lty = 5)
abline(v=7, col = "lightgray", lty = 5)
#abline(v=5.5, col = "lightgray", lty = 5)
abline(v=9, col = "lightgray", lty = 5)
#abline(v=6.5, col = "lightgray", lty = 5)
abline(v=11, col = "lightgray", lty = 5)
#abline(v=7.5, col = "lightgray", lty = 5)
abline(v=13, col = "lightgray", lty = 5)
#abline(v=8.5, col = "lightgray", lty = 5)
abline(v=15, col = "lightgray", lty = 5)
#abline(v=9.5, col = "lightgray", lty = 5)
abline(v=17, col = "lightgray", lty = 5)
#abline(v=10.5, col = "lightgray", lty = 5)
abline(v=19, col = "lightgray", lty = 5)
#abline(v=11.5, col = "lightgray", lty = 5)
abline(v=21, col = "lightgray", lty = 5)
#abline(v=12.5, col = "lightgray", lty = 5)

box(lwd=2)

#rug(x=3.0:12 + 0.1, ticksize = -0.01, side = 1)
#rug(x=3.1:12 + 0.1, ticksize = -0.01, side = 1)
#rug(x=3.2:12 + 0.1, ticksize = -0.01, side = 1)
#rug(x=3.3:12 + 0.1, ticksize = -0.01, side = 1)
#rug(x=1.5:19 + 0.1, ticksize = -0.01, side = 1)
#rug(x=3.5:12 + 0.1, ticksize = -0.01, side = 1)
#rug(x=3.6:12 + 0.1, ticksize = -0.01, side = 1)
#rug(x=3.7:12 + 0.1, ticksize = -0.01, side = 1)
#rug(x=3.8:12 + 0.1, ticksize = -0.01, side = 1)
#rug(x=1.9:14 + 0.1, ticksize = -0.01, side = 1)


lines(v_clim_N, n_clim_N , type="l",col="firebrick2",lwd = 3.5)
lines(v_clim_D, n_clim_D , type="l",col="firebrick2",lwd = 3.5)

lines(v_not_jet_N, n_not_jet_N , type="l",col="black",lwd = 3.5)
lines(v_jet_N, n_jet_N , type="l",col="black",lwd = 3.5)

mtext("DJF", col = 'red',cex =1.8, line=-2.0, side=3, adj = 0.02)




#legend('bottomright',
#       legend = c('LLJs day 00','LLJs day 12','Not LLJs day 06','Not LLJs day 12'),
#       col=c('black','black', 'firebrick2', 'firebrick2'),cex=0.85, seg.len=2, lty=1:2, lwd=3.5)
#box(lwd=2)

#bottomright
#topright

