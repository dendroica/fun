library(sf)
plot_locations_HARV <- read.csv("C:/Users/jmgorzo/Documents/Downloads/geology.csv")
co <- st_read(dsn="X:/projects/TNC_analysis/counties_in_minnesota", layer="mn_county_boundaries")
pts <- lapply(1:nrow(plot_locations_HARV),function(x){
  point <- plot_locations_HARV[x,]
  epsg <- ifelse(as.integer(gsub("[^[:digit:]]","",point$utm))==15,2027,2028)
  pt <- st_as_sf(point, coords = c("E", "N"))
  this_crs <- st_crs(paste0("+init=epsg:",epsg))
  st_crs(pt) <- this_crs
  pt_project <- st_transform(pt, st_crs(co))
return(pt_project)})
df <- do.call(rbind, pts)
st_write(df, dsn="C:/Users/jmgorzo/Documents/geology", layer="geology", driver= "ESRI Shapefile")
##adding here
arrowhead <- co[co$CTY_NAME %in% c("St. Louis", "Lake", "Cook"),]
plot(st_geometry(arrowhead))
plot(df[1], col='red',add=T)
