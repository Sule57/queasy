# Queasy - Mobile Quiz App

Queasy is a Mobile Quiz Application developed by a group of 9 students (referenced at the bottom of the README.md) as part of a Software Project class in the Winter Semester 22/23.

University: Technische Hochschule Ulm / University Of Applied Sciences Ulm <br/>
Location: Ulm, Germany <br/>
Professor: Baer, Klaus, Prof.Dr.-Ing. <br/>
Time Frame: WS 22/23 <br/>

## Prerequisites

### Develop an interactive quiz app:
* Possibility to edit questions & answers
* Sign in, choose nickname
* Play quiz via mobile or browser
* Leaderboard
* Technology: Open To Preference

#### Possibility to Edit Questions & Answers

* The user can create a Question
* The user can add Answers to his own Question
* The user can edit a Question that was committed to the Application by himself
* The user can edit an Answer comitted to one of his own Questions

#### Sign in, choose nickname

* The user can register to the application using the traditional way of providing information
* The user can choose a nickname while registering
* The user can sign into his own account by using the information provided at registration

#### Play quiz via mobile or browser

* The user can access the App through a web browser or a mobile device
* If the user is able to access the App, he is supposed to be able to use it

#### Leaderboard

* The App is supposed to have a Leaderboard for the best performing users
* The leaderboard shows the ranking of the top users and their nicknames & points

## Technology Used

### Dart

* Used to develop the backend
* In Combination with Flutter used to develop the frontend
* Chosen because of good implementation with firebase (both by Google)

### Flutter

* Used to develop the frontend in combination with Dart
* Allowed to develop for Web, iOS and Android at the same time

### Firebase

* Used as the database for the application

Chosen because:
* Free
* Good implementation with Dart
* Easy to use
* Extra features like: authentication, security, reset emails, free deployment, etc.

### Android Studio 

* Most commonly used IDE in the development process
* Allowed for easier testing/development due to implemented features (i.e. Emulators)

### xCode

* Less used IDE in the development process
* Used to manage iOS packages
* Used to change iOS specific configuration files

### Figma

* Used to design the UI of the App

### Asana

* Used to manage tasks
* Used for common organization of the project

## Views And Features

### Log In View

<img src="https://user-images.githubusercontent.com/76959652/211169417-df220389-46b8-46fa-bf94-51435b476429.png" height=500>

* The user can log in with their data that was previously registered
* The user can reset their password if forgotten
* The user can log in with a previously registered Google or Facebook account
* The user can go to **Register View**

### Register View

<img src="https://user-images.githubusercontent.com/76959652/211169549-71fc4947-024e-4467-9d2b-58beaa795e3c.png" height=500>


* The user can register by using the traditional way of providing information (Email, Username, Password, cPassword)
* The user can register by using a Google or a Facebook account

### Home View

<img src="https://user-images.githubusercontent.com/76959652/212055962-8e6d6e8f-a950-4b76-908b-66d4e3882177.png" height=500>

* The user can go to the **Public Tournaments View**
* The user can open the Join Quiz View
* The user can go to the **My Quizzes View**
* The user can navigate the app through a navigation bar at the bottom of the screen

### Public Tournaments View (Choose Category)

<img src="https://user-images.githubusercontent.com/76959652/211184969-5d72b431-432b-4ea0-94ac-2416d982be85.png" height=500>

* The user can choose a category to play a public quiz in
* Choosing a category will send the user to the **Quiz View**

### Quiz View

<img src="https://user-images.githubusercontent.com/76959652/211185116-85a69cbe-bfe8-4141-a915-868627af3afd.png" height=500>

* The user can play a selected quiz
* In the top left corner is a counter of 15 seconds - prevents users from cheating & allows more accurate points calculation
* Top center of the screen is a point counter, which tells the user how many points they have at the moment
* For each correct answer the user is awarded 5 points + the time left for that answer 
* For each incorrect answer the user is deducted 2 points
* At the end of the quiz, the user is redirected to **Statistics View**

### Statistics View

<img src="https://user-images.githubusercontent.com/76959652/211185363-702b1196-5950-4685-a38f-b31085877856.png" height=500>

* At the end of every quiz, the user is redirected to this view
* The view shows to the user how they performed in the quiz
* After the user clicks Continue they are redirected back to the **Home View**

### Join Quiz View (Pop Up)

<img src="https://user-images.githubusercontent.com/76959652/211185469-1657714e-789c-47fa-a25e-36b14fd13d63.png" height=500>

* The user is promted with a pop up box and the text "Enter Key"
* The user can input a private key of a quiz and click join or cancel
* If the user clicks join and the key is correct, they will be redirected to the **Quiz View** with the chozen quiz
* If the user clicks join and the key is incorrect, the user is notified with a text "Invalid Quiz Key"
* If the user clicks cancel, the App goes back to **Home View**

### My Categories View

<img src="https://user-images.githubusercontent.com/76959652/212052211-b546429a-5bb9-462f-b71f-ab8a0889e9cd.png" height=500>

* The user can create a category by clicking the plus in the top right corner
* Clicking the pop up will promt the user with a pup up requesting a name
* After giving a name to the new category the user can confirm or cancel the creation of a new category
* The user can enter their category to **Category View** inside where questions can be seen/edited or a quiz created

### Category View

<img src="https://user-images.githubusercontent.com/76959652/212053015-f49db1f5-4c23-4bc5-a4c1-5d14cb6045da.png" height=500>

<img src="https://user-images.githubusercontent.com/76959652/212053674-ae875004-0cab-433e-9c3c-fe94a33b7ce4.png" height=500>

* The user can edit his questions and answers
* The user can create a new quiz with random/chosen questions (with a custom name)
* The user can delete the category

### My Quizzes View

<img src="https://user-images.githubusercontent.com/76959652/212054361-87a1ec85-132a-482e-b57b-3f30698a18be.png" height=500>

* User can see his own quizzes
* User can share or delete a quiz by clicking on the ***"..."*** on the right
* User can enter inside of the ***Quiz Management View*** to play/delete a quiz

### Quiz Management View

<img src="https://user-images.githubusercontent.com/76959652/212055083-17881672-154a-4b86-b08a-90c89bf35c02.png" height=500>

* The user can see their quiz in detail
* The user can delete the quiz
* The user can play the quiz



!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CONTINUE WHEN CONNECTED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


## Authors

### Backend

* **Marin "**[Sule57](https://www.github.com/Sule57)**" Sušić**
* **Savo "**[Rek27](https://www.github.com/Rek57)**" Simeunović**
* **Stanislav "**[stani3](https://www.github.com/stani3)**" Dolapchev**
* **Endia "**[rhit-clarken](https://www.github.com/rhit-clarken)**" Clark**

### Frontend

* **Julia "**[parkoriann](https://www.github.com/parkoriann)**" Agüero**
* **Gullu "**[gullugasimova](https://github.com/gullugasimova)**" Gasimova**
* **Endia "**[rhit-clarken](https://www.github.com/rhit-clarken)**" Clark**
* **Anika "**[anika-kraus](https://github.com/anika-kraus)**" Kraus**
* **Nikol "**[nkreshpaj](https://github.com/nkreshpaj)**" Kreshpaj**
* **Sophia "**[sophiasoares](https://github.com/sophiasoares)**" Soares**







