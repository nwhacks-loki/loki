![Banner](images/loki_banner.png?raw=true "Banner")

Loki presents a news feed to the user much like other popular social networking
apps. However, in the background, it uses iOS' ARKit to gather the user's facial
data. This data is piped through a neural network model we trained to map facial
data to emotions. We use the currently-detected emotion to modify the type of
content that gets loaded into the news feed.

We were inspired to build Loki to illustrate the plausibility of social media
platforms tracking user emotions to manipulate the content that gets shown to them.

## Screenshots

![Screenshots](images/loki-screenshots.png?raw=true "Screenshots")


## Demo

[Watch the video](https://www.youtube.com/embed/yc8onq_Diak)

## Usage

Running the backend server:

```bash
$ export DATABASE_URL=<Postgres URL>
$ cd flask-backend
$ pip install -r requirements.txt
$ python app.py
```

## Tech Stack

![TechStack](images/loki-tech-stack.png?raw=true "TechStack")
