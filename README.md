![Banner](images/loki_banner.png?raw=true "Banner")

Loki presents a news feed to the user much like other popular social networking
apps. However, in the background, it uses iOS' ARKit to gather the user's facial
data. This data is piped through a neural network model we trained to map facial
data to emotions. We use the currently-detected emotion to modify the type of
content that gets loaded into the news feed.

We were inspired to build Loki to illustrate the plausibility of social media
platforms tracking user emotions to manipulate the content that gets shown to them.

Loki was a hackathon project created by [Lansi Chu](https://github.com/lansichu),
[Kevin Yap](https://github.com/iKevinY), [Nathan Tannar](https://github.com/nathantannar4),
and [Patrick Huber](https://github.com/huberpa) during
[nwHacks 2018](https://devpost.com/software/loki-fnbl1d).

For more info, please see the [Medium post here](https://medium.com/@iKevinY/loki-spying-on-user-emotion-c12eafbe24bc)

## Demos and Screenshots

[![Loki_Split_Screen_Demo](http://img.youtube.com/vi/GgZp8anVGvg/0.jpg)](http://www.youtube.com/watch?v=GgZp8anVGvg "Loki Split Screen Demo")

[![Loki_Presentation_Demo](http://img.youtube.com/vi/yc8onq_Diak/0.jpg)](http://www.youtube.com/watch?v=yc8onq_Diak "Loki Presentation Demo")

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
