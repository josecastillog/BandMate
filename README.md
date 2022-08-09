# BandMate

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
1. [Schema](#Schema)

## Overview
### Description
Bandmate is an iOS app intended to connect musicians from all expertise levels. Its intention is to match people with simmilar music interests so they can jam together.

### App Evaluation
- **Category:** Social Networking / Music
- **Mobile:** It is more straight forward using a mobile app than using a website for this case.
- **Story:** Musicians are able to connect with eachother and potentially jam together after they match.
- **Market:** Musicians from all expertice levels. This includes beginners, intermediates and advanced musicians.
- **Habit:** This app is used to connect with other musicians. Could be used often if chatting with eachother.
- **Scope:** It has a very specific musician niche.

## Product Spec
### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User can see a stylized launch screen and icon.
- [x] User can login.
- [x] User can create a profile.
- [x] User can connect Spotify account.
- [x] User can match.
- [x] User can see matches.
- [x] User can accept or decline matches.
- [x] User can see bands they are currently on.
- [x] User can change their band's name
- [x] User can change profile picture.
- [x] User can chat with matched bandmates.
- [x] User can see previous chats.

**Optional Nice-to-have Stories**

- [x] User can like a message.
- [ ] User can see unread messages number.
- [x] User can see BandMates' profiles.
- [x] A user can see alerts for network error, database error, API error, etc.
- [ ] User can update settings (Email, password, etc)

### 2. Screen Archetypes

* Login Screen
   * User can login.
* Register Screen
    * User can create a profile.
* Matches Screen
    * User can match.
    * User can see matches.
    * User can accept or decline matches.
* Your Bands Screen
    * User can see bands they are currently on.
    * User can chat with band members.
    * User can see band members.
    * User can see band members profiles.
* Profile Screen
    * User can change profile picture.
    * User can see name and username.
    * User can see top artists.
    * User can update settings (Email, password, Spotify Account)

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Match
* Your Bands
* Profile

**Flow Navigation** (Screen to Screen)
* Login
   * If login tapped, jumps to home screen in match tab.
   * If register tapped, jumps to register view.
* Match
   * If no Spotify account linked jumps to Spotify's OAuth
   * If match button tapped, and spotify account linked, displays matches.
   * If match clicked, jumps to match details view.
* Your Band
   * If cell tapped, goes to chat.
   * If people icon tapped goes to band details.
   * If user cell tapped, goes to a that user profile.
* If button clicked
   * Toggles pop out to update something (Email, Password, Spotify Account)

## Wireframes
<img src="https://i.imgur.com/QAgK5gV.jpeg" width=600>

## Screenshots
<img src="https://user-images.githubusercontent.com/69658875/183717417-852827e5-3010-44e2-8442-3667ecfd01e2.png" width="200" height="400" /> <img src="https://user-images.githubusercontent.com/69658875/183717432-e8e11845-8643-4f00-ada1-d50601d5d515.png" width="200" height="400" /> <img src="https://user-images.githubusercontent.com/69658875/183717443-3899c4ea-0751-45e8-a675-ac2b7807ac22.png" width="200" height="400" /> <img src="https://user-images.githubusercontent.com/69658875/183717451-875a0292-ec71-4879-8de3-8bcabeb640ea.png" width="200" height="400" />

<img src="https://user-images.githubusercontent.com/69658875/183721209-b9c33467-af54-4e08-886b-9b5663b44930.png" width="200" height="400" /> <img src="https://user-images.githubusercontent.com/69658875/183717594-fc190000-2738-4b99-9a64-d219c7e58f6d.png" width="200" height="400" /> <img src="https://user-images.githubusercontent.com/69658875/183721470-7b8d08a9-6da8-412d-8032-042b238ad9f4.png" width="200" height="400" /> <img src="https://user-images.githubusercontent.com/69658875/183717614-a9d10213-906c-47a4-aff9-8d25af442566.png" width="200" height="400" /> <img src="https://user-images.githubusercontent.com/69658875/183717616-88b45b9c-caac-446d-bbce-273e2b25675e.png" width="200" height="400" /> <img src="https://user-images.githubusercontent.com/69658875/183717624-34dfa394-5570-4c35-8d8a-6ac0ad41fae0.png" width="200" height="400" />

## Data Models
**User**
| Property      | Type           |Description |
| ----------- | ----------- | ----------- |
| objectId      | String       | Unique id for the user (default field)
| username   | String        | Unique username
| email      | String       | Unique email
| password   | String        | Password for authentication
| expertiseLevel      | String       | Beginner, intermidiate or advanced
| instrumentType      | String       | Instrument which user plays
| matches      | Relation       | Relation of matches a user has
| bands   | Relation        | Relation of bands a user is member of
| fav_artists      | Array       | Array of user's favorite artists
| profileImage      | File       | Contains user's profile image
| conversations      | Relation       | Conversations user is part of

**Match**
| Property      | Type           |Description |
| ----------- | ----------- | ----------- |
| objectId      | String       | Unique id for the user (default field)
| artistID      | String       | Artist which the match is based on
| users      | Relation       | Relation of users in which form the match
| hasSinger      | BOOL       | For knowing if a match has a singer
| hasDrummer      | BOOL       | For knowing if a match has a drummer
| hasGuitarist      | BOOL       | For knowing if a match has a guitarist
| hasBassist      | BOOL       | For knowing if a match has a bassist
| numberOfMembers      | Number       | Number of users in the match
| expertiseLevel | String | Level of experience the match has

**Artist**
| Property      | Type           | Description |
| ----------- | ----------- | ----------- |
| objectId      | String       |  Unique id for conversation |
| createdAt | Date | Timestamp of creation |
| genres | Array | Array of genres |
| followers | Number | Followers in spotify |
| images | Array | Array of image urls |

**Conversation**
| Property      | Type           | Description |
| ----------- | ----------- | ----------- |
| objectId      | String       |  Unique id for conversation |
| createdAt | Date | Timestamp of creation |
| match     | Pointer to match | Match of conversation |
| participants | Relation to User | Users part of conversation |

**Message**
| Property      | Type           | Description |
| ----------- | ----------- | ----------- |
| objectId      | String       |  Unique id for message |
| createdAt     | DateTime | Timestamp for message |
| sender  | Pointer to User | User who sent message |
| conversation | Pointer to Conversation | Conversation which is part of|
|content | String | Text message |
|likeCount | Number | Likes a message has |
| usersThatLiked | Array | Array of users' objectId that liked message|
