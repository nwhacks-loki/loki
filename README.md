![Banner](images/loki_banner.png?raw=true "Banner")

Loki presents a news feed to the user much like other popular social networking
apps. However, in the background, it uses iOS' ARKit to gather the user's facial
data. This data is piped through a neural network model we trained to map facial
data to emotions. We use the currently-detected emotion to modify the type of
content that gets loaded into the news feed.

We were inspired to build Loki to illustrate the plausibility of social media
platforms tracking user emotions to manipulate the content that gets shown to them.

Loki was a 24-hour hackathon project created during [nwHacks 2018](https://devpost.com/software/loki-fnbl1d).

## Demo and Screenshots

[Watch the demo here](https://www.youtube.com/watch?v=yc8onq_Diak)!

![Screenshots](images/loki-screenshots.png?raw=true "Screenshots")


## Usage

Running the backend server requires Python 2 and Postgres 9.4+. The backend
expects a local Postgres database called `loki`; otherwise, the URL to a
remote database instance must be provided via an environment variable.

```bash
$ export DATABASE_URL="postgresql://user:pass@host:port/dbname"
$ cd flask-backend
$ pip install -r requirements.txt
$ python app.py
```

## Tech Stack

![TechStack](images/loki-tech-stack.png?raw=true "TechStack")


## Credits

Logo courtesy of [Casmic Lab](https://tictail.com/casmiclab).
