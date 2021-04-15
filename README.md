Cattle Market Digital Trading Platform Using Flutter

SUMMARY

Our project addresses a large deficit in the livestock sector. When we listened to the comments of people interested in animal husbandry, we realized that there was a trade deficit in this sector. Before solving this problem, we examined the existing systems, these systems were second-hand trading sites, social media platforms, and sites selling agricultural products. First, we identified the gaps in these systems, i.e., the points that do not overlap with the user's expectation in existing systems. Then, we aimed to improve the system that we will create by combining these points with the features that users may need and to create a seamless system for the audience we address.
We thought of using a mobile environment to deliver the system we planned to the users and we developed our application with Flutter, an open-source UI software development kit created by Google. We designed our application with a plain and simple interface that users from all walks of life can easily use. Users must be a member before logging in to the system, users can register to the system with minimum time and the most basic information, the user can add and change the profile photo later, if desired, from the profile section. Users registered in the system can log in to the system using their mail and password information. Users who have forgotten their password can update their passwords using the password change email sent to them. The user who logs into the system can see all the postings registered in the system, the details of these advertisements, the person who posted the ad, and the comments about the advertiser, and can evaluate the user. The user can add the postings he likes as favorites and review these postings again later. When the user wants to advertise, he/she can upload an ad to the system by filling in all the necessary information (Animal pictures 4 sides, title, age, kind, location, price, weight, height, earring number, and description). If the user has an ad that he has added himself, the user can view his own postings, update them, delete them, and change the post status of the ad (hide/show). The user can update his profile information and profile photo and strengthen his profile. Firebase is used for the storage needs of our system. Authentication for membership transactions in Firebase Cloud Firestore operations for database operations and Storage operations for file storage operations. Our system aims to bring the cattle trade to a digital platform.

INTRODUCTION

1.Purpose of the system
The purpose of this application is to close the gaps in the bovine trade and to determine the problems experienced by the users in different systems and to minimize these problems and to provide a reliable trading environment by presenting correct and consistent advertisements to the users.

2.Scope of the system
This project can be used by anyone dealing with agriculture and animal husbandry, new entrants to the sector, or related to the sector. The project will be packaged to be used by Android-based systems. The user interface is designed to be clear and simple to be used by every age group except children. The application will consist of pages such as user login, user register, forgot password, postings, my posts, add post, favorite, and profile. When users search for ads, they will be able to filter according to their location or cattle age. Users can update, delete, or change the visibility of the posts they have uploaded. At the same time, users can also add any posts as favorites and have the right to evaluate other users.

3.Definitions, acronyms, and abbreviations
CattleMarket: It is a program you can use to control the market of livestock for sale in the livestock sector. users can place advertisements for the cow they want to sell. You can examine the different types of cow advertisements put up for sale by other animal owners and reach the information of the advertisers.
Cattle: Large ruminant animals with horns and cloven hoofs, domesticated for meat or milk, or as beasts of burden; cows and steers.

4.References
While making this application, as references, we examined livestock groups on Facebook, sahibinden.com and some mobile applications related to the issue as a reference to identify deficiencies and faulty situations in the industry and talked to people dealing with animal husbandry.

5.Overview
This system provides an application for those who want to see the market in the cattle trade regularly, safely, and quickly on a digital platform.

PROPOSED SYSTEM

1.Overview
The system we have developed will focus on a single sector. it will complement all the shortcomings in existing systems. Our system will ask the most basic users to register with minimum information. Each user will have their own profile. Users will be able to use all the features of the application after logging into their accounts. When the user wants to add an advertisement, they will have to enter the advertisement information specified by the system, and this will minimize the question marks that will occur in other users. Users will be able to see all posted postings on the ads page, filter them according to the type and location information, see the details of the ad they want, if they want, they will be able to see the information of the person who posted the ad and evaluate or contact this person. Users have the authority to like the postings posted by other users, if they want, they can add the post to the favorites tab to review them later. The user can manage his / her postings with the authority to delete, update and change the appearance.

2.Functional requirements
Registration - The user should be able to register to the system with their own name, surname, phone number, e-mail, and address information.
Password Changing - User registered in the system should be able to update his / her password by e-mail.
Add Posting - Users should be able to create their post by entering the photos of the animal they want to add, the information requested from the system such as the photo of cattle, title, age, kind, location, price, weight, height, earring number and description.
Shown Postings - Users should be able to list all the postings created by other users and view the posting details. User can filter and search according to the category whatever he/she wants. Users should be able to add in Favorites.
Manage Favorites - All postings added to favorites must be listed. The postings must be removed from favorites.
Manage Own Post - The user's posts, if any, should be updated, deleted, and be able to change their visibility.
Edit Profiles - Allows the user to edit their personal information. The user must log out.

3.Nonfunctional requirements

3.1.Usability
Thanks to the practical interface, everyone will be able to use the application easily. We offer users the opportunity to create an account in a minimum time during user registration. We minimize communication with other users by requesting all the necessary information on the posting page. The user can easily manage his own postings under a single tab. Likewise, he will be able to add the posts he likes as favorites and review them later.

3.2.Reliability
The published advertisements will be checked periodically. If any inconsistencies are detected, the postings will be removed from the publication. There is also a system for users to vote each other. The user will be evaluated based on a user's behavior and postings. The other user will have information about the user according to the score of the user opposite.

3.3.Performance
Our application is as fast as possible in terms of performance. You will be able to access the homepage in 3 seconds at most. The system is also suitable for use by 120 people simultaneously. Performance-oriented structures are used in the application and it is designed to use minimum RAM.

3.4.Supportability
The application will be available to download for each device after having a high-level API level. So, it will approximately be supported for 100% of Android and we aim to be compatible with IOS as well.

3.5.Implementation
During the implementation Dart is used for coding and Firebase is used for database. The environment used is AS.

3.6.Interface
The GUI will be user-friendly. Even a user knows anything about the application will simply be able to find whatever he/she wants.

3.7.Packaging
The application will be packaged to an APK file by AS to be able to be installed.

3.8.Legal
CattleMarket application does not violate any laws and copyrights legally. It does not contain anything that would require any age restrictions.


