= FuckDiabetes =
The purpose of this codebase (and related website) isn't to degrade the metabolic disease of Diabetes, but instead is intended to provide a way of allowing diabtics a way of complaining, bragging, and networking with other people who are going through the same struggles as they are.

= TODO =
== CLEANUP ==
So, the cleanup so far is pretty extensive. There are two reasons for that:

1. I was learning Moose and Mongoose when I started the project, and I had some misapprehensions about those technologies when I started.
2. I started out using Facebook authentication, but have since decided to switch to a more generic form of authentication which I still haven't determined.

Things to clean up:

- Facebook stuff
- FuckDiabetes::Data::Brag namespace is probably going to go away
- The FuckDiabetes::Data directory should probably be re-considered
- The application code should be moved into a Controller namespace