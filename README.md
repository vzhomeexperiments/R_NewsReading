# R_NewsReading

Repository for the Udemy course. Please support this project by joining this on-line course:

https://www.udemy.com/course/forex-news-and-sentiment-analysis/?referralCode=2B76F54F1D33CF06B79C

Note: this course is the part of the series of step-by-step tutorials allowing to build more comprehensive Automated Trading System based on Decision Support System approach. Check out other courses of the series.

# Purpose:

## Disable algorithmic trading robots during macro-economic events

R script will scrap news from the table in Forex Factory. It will match collected news versus pre-defined user list.
In case there is a match csv file will be written into MQL4 Sandbox and trading will be disabled
Job is automated to take place every 24h at 00:10

## Setup Twitter connection

R scripts allowing to:

- encrypt API keys provided by Twitter App
- decrypt credentials and establish connection with twitter
- download twitter data
- perform data cleaning and visualisation
- sentiment analysis of twitter data

# Build

Everything what is needed to arrange the 'news' reading:

- Setup Environmental Variables
- R script
- List of Restricted Events
- Bat file
- Windows Task Scheduler Job

## Clone this repository

Please clone this repository to the folder 

"%USERPROFILE%\Documents\GitHub"

## Environmental Variables

Environmental variables could be edited by using template:

`/_PROD/Set_Environment_Variables.bat`

Edit this file and execute it

(Note: you must restart R-Studio for the settings to take effect from R Studio)


## Disclaimer

Use on your own risk
