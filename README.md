# ExTempo
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## About
Imagine you wanted to plan a 45 minute talk with 3 parts that had a 5 minute Q&A between them (10 minutes talking, 5 Q&A). Now let's say that you wanted to ensure that you spent 5 minutes covering 3 core points, then the next 5 minutes demonstrating them. You could do it with a 5 minute timer, resetting it each time and keeping an eye on it while you're talking.

It'd be great if you could have an application that would act not only as your notes, but also as a timer for scenarios like the one described above. ExTempo aims to be an application that can fill both those roles.

## History and Future
This is a prototype talk timer that I was building in early-mid 2018. The goal of this app was to allow someone to plan a talk with a main topic, multiple sections, and sub-points with each having a set time-limit. It is functional, but for me to consider this "complete", I was unable to add certain features after encountering technical difficulties. Specifically, I was using Materialize as the CSS framework, but certain functionality wasn't able to be accessed through Elm's ports while other functionality was. It's also worth mentioning that this was the first time I'm using Elm to build something, so I may be doing something that is obviously wrong and not know it.

I'll probably revisit completing this app because in the intervening months, I've thought of a solution: Using [elm-mdc](https://github.com/aforemny/elm-mdc) instead of Materialize. But this would mean rewriting most of the view layer.
