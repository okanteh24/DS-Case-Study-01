# How many breweries are present in each state 
BrewerPerState <-table(Breweries$State)
BrewerPerState


#Merge beer data with the breweries data

# Renamed Brewery_id to Brew_ID 
Beers <- rename(Beers, Brew_ID = Brewery_id)

Brews <- full_join(Beers, Breweries, by="Brew_ID")

# Change variable names to more meaningful title
Brews <- rename(Brews, Beer = Name.x, Brewery = Name.y,
                  OZ = Ounces)

#first and last six observations from the combined data
head(Brews)
tail(Brews)

#Address the missing values in each column
MissingValues <- sapply(Brews, function(x)sum(is.na(x)))
MissingValues 

#Compute the median alcohol content unit for each state.
alcohol_content <- Brews %>%
  na.omit() %>%
  group_by(State) %>%
  summarise(Median = median(ABV)) %>%
  arrange(Median)

#Compute the median international bitterness unit for each state.
Bitterness <- Brews %>%
  na.omit() %>%
  group_by(State) %>%
  summarise(Median = median(IBU)) %>%
  arrange(Median)

# Plot a bar chart to compare ABV by state

ggplot(data=alcohol_content, aes(x=State, y=Median)) +
  geom_bar(stat="identity", fill="steelblue")+
  theme_economist() + 
  scale_color_economist()+
  theme(axis.text.x=element_text(size=rel(0.8), angle=90)) +
  ggtitle("Median ABV by State") +
  labs(x="State",y="ABV")

#Plot a bar chart to compare IBU by state

ggplot(data=Bitterness, aes(x=State, y=Median)) +
  geom_bar(stat="identity", fill="steelblue")+
  theme_economist() + 
  scale_color_economist()+
  theme(axis.text.x=element_text(size=rel(0.8), angle=90))+
  ggtitle("Median IBU by State") +
  labs(x="State",y="IBU")

#state has the maximum alcoholic (ABV) beer
Brews[which.max(Brews$ABV),]

#state has the most bitter (IBU) beer
Brews[which.max(Brews$IBU),]

#summary statistics and distribution of the ABV variable
ABVSummary <- (summary(Brews$ABV))
print(ABVSummary)

# 7. Draw a scatter plot to compare relationship between beer 
# bitterness and alcohol content
ggplot(Brews, aes(x=IBU, y= ABV)) +
  geom_point(shape=1) +
  geom_smooth(method=lm) + # add linear regression line
  theme_economist() + 
  scale_color_economist()+
  theme(axis.text.x=element_text(size=rel(1.0)))+
  ggtitle("Correlation between IBU and ABV ") +
  labs(x="IBU",y="ABV")
