# myMovieList
A Movie List iOS app. After users create an account and upload their profile information and photo, or after they log in, users enter the app's home screen. The home screen shows a list of "Popular" movies fetched from TMDB API. Users also can switch screens among "Now Playing", "Top Rated" and "Favorite" via a tar bar at the bottom of screens. "Now Playing" and "Top Rated" movie data is also fetched from TMDB. Users can click on a movie in the list on the above screens, which brings them to a movie detail screen, which shows detailed information about the movie. On the movie detail screen, there is a "Review" button that brings users to the movie's "Review" screen, where users can add, edit and delete a review for the movie or like and dislike other users' reviews. On "Popular", "Now Playing" and "Top Rated" screens, there is a favorite button on each line of the movie list. When the user clicks the favorite button, it adds the movie to the user's favorite list and shows on the "Favorite" screen. When the user unselected the favorite button, the movie disappears from the user's favorite list.

Functionalities need to be implemented:
1. When the user goes back to the profile screen from the Popular or movie detail screen. The name, username… blanks need to have the user’s data in them because the user has filled those when they are creating a profile.
2. After the user makes changes on Profile, it’s more effective to only update changes to Google Firebase (where the user data is stored).
3. When restarting the app, the user’s favorites should be reflected on Popular, Now Playing and Top Rated screens – corresponding buttons need to the filled heart image.

Demo video:
https://drive.google.com/file/d/1yXR8VPkRo3Iv1aNSSDGDjhfIyIHa4ULc/view?usp=sharing
