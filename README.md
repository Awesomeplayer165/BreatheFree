# BreatheFree

<img src="https://github.com/Awesomeplayer165/BreatheFree/assets/70717139/9b45a700-059f-4c3b-b561-000780ac6dd2" alt="iphone default screen" width="300"/>
<img src="https://github.com/Awesomeplayer165/BreatheFree/assets/70717139/53aae384-c9bc-490c-ab7c-b86f9b1d4477" alt="iphone default screen" width="300"/>

---

Welcome to BreatheFree, an AI-enabled solution empowering people with real time data they need to protect their health and avoid air pollution risks. Available on all Apple platforms, my app is the first app to visualize air pollution from active wildfires as well as pollen levels in one easy to use app.

It gives people a tool to manage their health wherever they are in the world. One use case would be if there’s a big wildfire - data from the app can be used to locate an area with safe air quality levels to escape to. Another use case would be for people who suffer from seasonal allergies, asthma or any lung disease, data can be used to figure out critical trigger points and act accordingly to avoid heart attack or other severe life-threatening consequences. A third use case would be when making travel plans - people would want to know what the current air quality levels are in their desired destinations as part of their decision making process. In conclusion, the app is a critical tool in a world where air quality is expected to only worsen with climate change and devastating wildfires.


## Background

In California, wildfire seasons have become more frequent, catastrophic covering historic swathes of land in recent years. People already suffering from crippling pollen allergies, asthma, lung and heart diseases now also have to contend with dangerously unhealthy air. An app to monitor both dangerously high wildfire smoke and unhealthy pollen levels is a critical tool in protecting one’s health and aids in making decisions to avoid impacted areas. 

## Software Stack

To build BreatheFree, I used Xcode and SwiftUI to code the iPhone, iPad, Apple Watch, and Mac app. A lot of the magic, however, happens on the backend, where I have built a server in Swift and Vapor for the calculations. Using Machine Learning and Deep Neural Networks, I intelligently categorize hundreds of thousands of data points around the world into cities and remove outlier information based on wildfires and other current events.

Additionally, since there was code shared between the server and my app, like how to convert particulate matter to the US EPA standard, I separated the code into a package, so the server and app both use the same calculation method. So now if I want to change how air quality is calculated, I can change it once and my phone and server will both stay consistent in calculating air quality.

**NOTE**: If you are wondering where most of the code for this app is? As stated above, it is abstracted into packages for code-reusability. Find those here:
- [BreatheShared](https://github.com/Awesomeplayer165/BreatheShared)
- [BreatheLogic](https://github.com/Awesomeplayer165/BreatheLogic)
- [BreatheServer](https://github.com/Awesomeplayer165/BreatheServer)

# Authors
Created by [Jacob Trentini](https://github.com/Awesomeplayer165)
