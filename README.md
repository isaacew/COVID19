# COVID 19
## About
With so much media coverage of the Covid-19 outbreak, I decided that I wanted to see the data for myself. So I wrote a 
little script that takes the files from Johns Hopkins and allows me to develop plots and even fit the data. My intention of 
this collection is not to induce a panic, rather, provide information that anyone can understand. I want people to be 
informed rather than be influenced.
## Code
The code is organized into the following sections
1. Population Data
2. Get Latests Update from Johns Hopkins
3. Import the Data, .csv, into Matlab Data
4. Parse the Data
5. Plot the Data
## Automator
I generated an automator that generates a plot for every country in the dataset. This is accompished by parsing the data 
from the Johns Hopkins' github account, which contains all the outbreak information. Next, I pulled down the population 
data from the world bank. The Johns Hopkins' data contains the current number of confirmed cases, deaths, and recoveries. 
Using this data and dividing by the total number of people in each country, plots for the percentage of population effected 
are generated. It is important to generate a folder before the automator is run. A missing directory error can occur if you don't create a figure directory. I plan to fix this bug if time permits. In the meantime I hope you have all the data you need.

## To Install
```git clone http://www.github.com/isaacew/COVID19 --recurse-submodules```

-Isaac

