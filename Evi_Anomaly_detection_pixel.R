## Importing the libraries

library(npphen)
library(terra)
library(readr)
library(magrittr)
library(raster)
library(ggplot2)

## Reading the data

evi<-rast('D:/PhD/GIS/DP/NDVI/evi_desert_only.tif')

date_table<-read_csv('D:/PhD/GIS/DP/NDVI/MYD13Q1_id_dates.csv')
## Point of interest 

xy<-cbind(16.2456,-28.0674)

## Extract values at that point and forming a DF

serie_evi<-terra::extract(evi,xy)%>%as.numeric()

df<-data.frame(date=date_table$date,evi=serie_evi)

df$doy<-as.numeric(format(df$date,'%j'))

print(df)

## Exporting the DF

write.csv(df,'D:/PhD/GIS/DP/NDVI/EVI_TimeSerie_Csv.csv',row.names=FALSE)

## Ploting the EVI Timeserie

ggplot(df, aes(x = date, y = evi)) +
  geom_line(color = "darkgreen") +
  geom_point(color = "forestgreen", size = 1.5) +
  geom_hline(yintercept = 0.10, linetype = "dashed", color = "blue") +
  annotate("text", x = min(df$date), y = 0.15, hjust = 0, color = "blue",
           label = "Desert line (evi < 0.10)", size = 3) +
  theme_minimal() +
  labs(
    title = "EVI Time Series at Desert Pixel (2020–2025)",
    x = "Date",
    y = "EVI"
  ) +
  scale_y_continuous(limits = c(0, 0.5))+annotate("rect",
                                                  xmin = as.Date("2023-06-01"), xmax = as.Date("2024-02-01"),
                                                  ymin = -Inf, ymax = Inf,
                                                  fill = "red", alpha = 0.1)

# Changing the format of the year

df$year <- as.numeric(format(df$date, "%Y"))

# Focusing on other years

df$focus <- ifelse(df$year == 2023, "2023", "other")

ggplot(df, aes(x = doy, y = evi)) +
  # Plot all years except 2023 as gray crosses
  geom_point(data = subset(df, focus == "other"),
             shape = 4, color = "gray70", alpha = 0.6, size = 2) +
  
  # Highlight 2023 in black points
  geom_point(data = subset(df, focus == "2023"),
             shape = 16, color = "red", size = 2.5) +
  
  # Add desert threshold line
  geom_hline(yintercept = 0.15, linetype = "dashed", color = "blue") +
  annotate("text", x = 5, y = 0.17, label = "Desert line (evi < 0.1)",
           hjust = 0, color = "blue", size = 3.5) +
  
  # Axes and layout
  scale_x_continuous(name = "Day of Year (DOY)", breaks = seq(0, 360, 30), limits = c(0, 365)) +
  scale_y_continuous(name = "evi", limits = c(0, 0.5)) +
  theme_classic(base_size = 13)

## Filter the years and eliminate 2023

mask_no_2023<-df$year!='2023'
evi_filtered<-serie_evi[mask_no_2023]
dates_filtered<-date_table$date[mask_no_2023]

#Vizualisation of the reference frequency distribution RFD using the PhenKplot function

PhenKplot(
  x = evi_filtered,
  dates = dates_filtered,
  h = 2,
  xlab = 'DOY',
  ylab = 'evi',
  rge = c(0, 0.4)
)

# Adding the year of 2023 to assess the difference (Anomalies)

df_2023<-df[format(df$date, "%Y") == "2023", ]
points(df_2023$doy,df_2023$evi,col='black',pch=16,cex=1.2)

# Time for anomaly detection using the ExtremeAnom Function

anom_ndvi<-ExtremeAnom(x=serie_evi,dates=date_table$date,h=2,refp=dates_filtered,anop=df_2023$date,rge = c(0,0.5),output='anomalies')




print(dates_filtered)
dates_filtered[0]
print(dates_filtered[0])

dates_without_2023<-dates_filtered
df_dates_without_2023 <- data.frame(date = as.Date(dates_without_2023))
print(df_dates_without_2023$date[1])

Anomalie<-ExtremeAnom(x=serie_evi,dates=date_table$date,refp = c(1,69),anop=c(70,99),rge=c(0,0.5),h=2,output='anomalies')
print(Anomalie)

anomaly_df <- data.frame(
  date = as.Date(gsub("anom_", "", names(Anomalie))),
  anomaly = round(as.numeric(Anomalie),2)
)

print(anomaly_df)
anomaly_df$greening<-anomaly_df$anomaly>=0.05
print(anomaly_df)

subset(anomaly_df, greening == TRUE)
ggplot(anomaly_df, aes(x = date, y = anomaly)) +
  geom_line(color = "darkgreen") +
  geom_point(aes(color = greening), size = 2) +
  scale_color_manual(values = c("FALSE" = "gray70", "TRUE" = "red")) +
  geom_hline(yintercept = 0.05, linetype = "dashed", color = "blue") +
  labs(title = "evi Anomalies in 2023–2024",
       y = "evi Anomaly", x = "Date") +
  theme_minimal()

extreme_anom<-ExtremeAnom(x=serie_evi,dates=date_table$date,h=2,refp = c(1,69),anop=c(70,99),rge=c(0,0.5),output='clean',rfd=0.95)

print(extreme_anom)
plot(extreme_anom)
