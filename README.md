# BandMate

# TUNIN

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
- **Scope:** 

## Product Spec
### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can see a stylized launch screen and icon.
* User can login.
* User can create a profile.
* User can connect Spotify account.
* User can match.
* User can see matches.
* User can accept or decline matches.
* User can see bands they are currently on.
* User can change their band's name
* User can change profile picture.
* User can update settings (Email, password, Spotify Account)

**Optional Nice-to-have Stories**

* User can chat with matched bandmates.
* User can see previous chats.
* User can post photos in profile.
* User can create events (Jam Sessions).
* Notifications sent when event is coming up.
* User can add pictures of event.

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
    * User can change their band's name.
    * User can see their bandmates contact information.
* Profile Screen
    * User can change profile picture.
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
   * If cell tapped, jumps to band details view.
* If button clicked
   * Toggles pop out to update something (Email, Password, Spotify Account)

## Wireframes
<img src="https://i.imgur.com/QAgK5gV.jpeg" width=600>
