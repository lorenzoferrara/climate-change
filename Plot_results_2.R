library(readxl)
xlore <- read_excel("C:/Users/lofer/Downloads/xlore.xlsx")
View(xlore)


{
  x11()
  p = ggplot(xlore) +
    geom_line(aes(x=2015:2050,y=BH85_fresh), color='#F8766D', linewidth=1.5)+ 
    geom_line(aes(x=2015:2050,y=BH85_salt), color='#F8766D', linewidth=1.5)+ 
    geom_line(aes(x=2015:2050,y=NH85_fresh), color='#619CFF', linewidth=1.5)+ 
    geom_line(aes(x=2015:2050,y=NH85_salt), color='#619CFF', linewidth=1.5)+ 
    labs(title = "Emissions [Mton/yr]",subtitle = "Only emissions of CO2", x = "year", y = "Emission [MtonCo2]") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"AnnualEmissions_WithLine.png"), p)
}

################################

xlore2 <- read_excel("C:/Users/lofer/Downloads/xlore2-1.xlsx")
# View(xlore2)

{
  x11()
  p = ggplot(xlore2) +
    geom_line(aes(x=2015:2050,y=diff), color='#F8766D', linewidth=1.5)+ 
    labs(title = "",subtitle = "", x = "Year", y = "Relative difference") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"RelativeDifference.png"), p)
}
################################


prod <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
prod = prod[prod$FUEL=="E1" | prod$FUEL=='E2',]
prod = prod[ prod$TECHNOLOGY  != "EL00TD0",]
prod[prod$FUEL=="E1",]$value = 0.95*prod[prod$FUEL=="E1",]$value

input <- batch_extract("InputActivityRatio",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
output <- batch_extract("OutputActivityRatio",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

input = input[input$FUEL=="HY",]
output = output[output$FUEL=="HY",]

# input = input[input$YEAR=="2015" & input$MODE_OF_OPERATION=="1" & scen=="BH26" & input$FUEL=="HY",]
# output = output[output$YEAR=="2015" & output$MODE_OF_OPERATION=="1" & scen=="BH26" & output$FUEL=="HY",]

input = input |> 
  group_by(TECHNOLOGY) |>
  summarise(value = mean(value))

output = output |> 
  group_by(TECHNOLOGY) |>
  summarise(value = mean(value))

prod$water=prod$value
for(i in unique(prod$TECHNOLOGY)){
  if(i %in% input$TECHNOLOGY){
    ii = input$value[input$TECHNOLOGY==i]
  } else{
    ii = 0
  }
  if(i %in% output$TECHNOLOGY){
    oo = output$value[output$TECHNOLOGY==i]
  } else{
    oo = 0
  }
  prod$water[prod$TECHNOLOGY==i] = prod$value[prod$TECHNOLOGY==i] * (ii-oo)
}

prod$TECH=prod$TECHNOLOGY

for(i in unique(prod$TECHNOLOGY)){
  prod$TECH[prod$TECH==i] = substr(i, start=1, stop=2)
}

prod = prod |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(water))
prod$value = round(as.numeric(prod$value),2)

prod=prod[prod$YEAR<=2050,]
prod=prod[prod$scen!='base',]

{
  x11()
  p = ggplot(prod[prod$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    labs(title = "Production by Technology [PJ/yr]", subtitle = "Energy production by set of technology using the same fuel") +
    scale_fill_brewer(palette="Paired") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() + 
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"ProductionByTechnology.png"), p)
}

freshwater = prod |> 
  group_by(scen,YEAR) |>
  summarise(value = sum(value))

###################################


prod2 <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
prod2 = prod2[prod2$FUEL=="E1" | prod2$FUEL=='E2',]
prod2 = prod2[ prod2$TECHNOLOGY  != "EL00TD0",]
prod2[prod2$FUEL=="E1",]$value = 0.95*prod2[prod2$FUEL=="E1",]$value

input <- batch_extract("InputActivityRatio",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
output <- batch_extract("OutputActivityRatio",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

input = input[input$FUEL=="SE",]
output = output[output$FUEL=="SE",]

# input = input[input$YEAR=="2015" & input$MODE_OF_OPERATION=="1" & scen=="BH26" & input$FUEL=="HY",]
# output = output[output$YEAR=="2015" & output$MODE_OF_OPERATION=="1" & scen=="BH26" & output$FUEL=="HY",]

input = input |> 
  group_by(TECHNOLOGY) |>
  summarise(value = mean(value))

output = output |> 
  group_by(TECHNOLOGY) |>
  summarise(value = mean(value))

prod2$water=prod2$value
for(i in unique(prod2$TECHNOLOGY)){
  if(i %in% input$TECHNOLOGY){
    ii = input$value[input$TECHNOLOGY==i]
  } else{
    ii = 0
  }
  if(i %in% output$TECHNOLOGY){
    oo = output$value[output$TECHNOLOGY==i]
  } else{
    oo = 0
  }
  prod2$water[prod2$TECHNOLOGY==i] = prod2$value[prod2$TECHNOLOGY==i] * (ii-oo)
}

prod2$TECH=prod2$TECHNOLOGY

for(i in unique(prod2$TECHNOLOGY)){
  prod2$TECH[prod2$TECH==i] = substr(i, start=1, stop=2)
}

prod2 = prod2 |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(water))
prod2$value = round(as.numeric(prod2$value),2)

prod2=prod2[prod2$YEAR<=2050,]
prod2=prod2[prod2$scen!='base',]

{
  x11()
  p = ggplot(prod2[prod2$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    labs(title = "Production by Technology [PJ/yr]", subtitle = "Energy production by set of technology using the same fuel") +
    scale_fill_brewer(palette="Paired") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() + 
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"ProductionByTechnology.png"), p)
}

seawater = prod2 |> 
  group_by(scen,YEAR) |>
  summarise(value = sum(value))

#########################

scenari = c('BH85', 'BL26', 'NH85', 'NL26')
{
  x11()
  p = ggplot(freshwater[freshwater$scen%in% scenari,]) +
    geom_line(aes(x=as.numeric(YEAR),y=value), color='lightblue', linewidth=1.5)+ 
    geom_line(data=seawater[seawater$scen%in% scenari,], aes(x=as.numeric(YEAR),y=value), color='blue', linewidth=1.5)+
    facet_wrap(scen~.,) +
    theme_bw() + 
    labs(title = "Water used divided by type", x = "", y = "Water [10^9 m3]", color="WATER TYPE") +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"RivervsSeaUses.png"), p)
}
