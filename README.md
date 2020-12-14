# WordGame

Excercise developed as a technical test for Babel

**how much time was invested** 
Around 2 days in total.

**how was the time distributed (concept, model layer, view(s), game mechanics)**
I decided to build the game trying the latest things I am studing (Composable Arquiterture and SwiftUI). 
I spent the first 1/3 of the time building the logic of the game: read and parse the json, deciding about Model. Initial I create only the AppState, lately I decided to separate the logic that affected the gamen globably from the one related to the word to translate. 
Create the basics of the UI was fast with SwiftUI, but it was also what ended occupaying most of my time. I found myself quite stuck in fullfiling the requiremnt about the tranlation falling down in the screen. I was not able to create this animation at all. Either to animate the text in any other way. 
My current idea is to set a timer of 4 seconds, but this is yet not implemented. 

**decisions made to solve certain aspects of the game**


**decisions made because of restricted time**
Initially my idea was to use the json file provided as mock for testing, and the url as life. The current implementation is made que the provided file. 
The logic of the game changed a bit since i dont have the time to properly lear more about SwiftUI animation and its limitations. 

**what would be the first thing to improve or add if there had been more time**
Implement test, creating live and test environments.  and finish some kind of timer or funy countdown 
