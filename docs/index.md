# Get Started

## What is Social Maps?

Social Maps is a free
([as in freedom](https://en.wikipedia.org/wiki/Free_content)) database for
crowd-sourced reviews about points of interest (POI) in
[OpenStreetMap](https://www.openstreetmap.org/).

<!-- ## License
* Our **server-side software** is licensed under [GNU AGPL 3.0](https://www.gnu.org/licenses/agpl-3.0.html).
* Our **database** is licensed under [ODbL 1.0](https://opendatacommons.org/licenses/odbl/).
* Our **database content (i.e. reviews)** are licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/). -->

## Quickstart

Eager to get started? This section gives a good introduction how to get started
with Social Maps.

First, make sure that:

- Python 3 is available
- [requests](https://pypi.org/project/requests/) and
  [requests-oauthlib](https://pypi.org/project/requests-oauthlib/) are installed

Let's get started with some simple examples:

### Lookup a Place

In Social Maps, we use the term "place" for a point of interest (POI), someplace
interesting where users can leave reviews on.

OpenStreetMap, the database Social Maps relies on for its factual data, does not
have permanent IDS for places that we can use to refer to places unambigously.
Therefore, to find a Place in Social Maps, you need to look it up by its name
and location (latitude and longitude):

```python
from pprint import pprint

import requests

place = requests.get(
    "https://api.socialmaps.org/v1/places/lookup",
    params={"name": "Glucksman Gallery", "lon": -8.4905846, "lat": 51.8947505},
).json()

pprint(place)
```

should print:

```python
{'id': 9655,
 'location': {'lat': 51.894725031143174, 'lon': -8.490303789960551},
 'name': 'Glucksman Gallery',
 'object': 'place',
 'osm_id': 92914852,
 'osm_tags': {'addr:city': 'Cork',
              'addr:housename': 'University College Cork',
              'addr:postcode': 'T12 V1WH',
              'addr:street': 'Western Road',
              'alt_name': 'Lewis Glucksman Gallery',
              'building': 'university',
              'building:levels': '3',
              'building:material': 'concrete',
              'contact:facebook': 'TheGlucksman',
              'contact:instagram': 'theglucksman',
              'contact:twitter': 'glucksman',
              'email': 'info@glucksman.org',
              'fee': 'no',
              'internet_access': 'wlan',
              'museum': 'art',
              'name': 'Glucksman Gallery',
              'opening_hours': 'Tu-Su 11:00-17:00',
              'outdoor_seating': 'no',
              'phone': '+353 214901844',
              'tourism': 'museum',
              'website': 'https://www.glucksman.org',
              'wikidata': 'Q6536591',
              'wikimedia_commons': 'Category:Glucksman gallery, Cork',
              'wikipedia': 'en:Lewis Glucksman Gallery'},
 'osm_type': 'W',
 'rating_stats': {'count': 0, 'like_ratio': None, 'score': 0.5}}
```

### Create a Review

Creating a Review in Social Maps requires authentication, so that we can know
who its author is.

Social Maps uses OAuth, so that:

1. Users can log in with their OpenStreetMap account (with which they can also
   contribute to the map),
2. Users can authorize third-party clients (such as mobile apps) securely
   without sharing their password with them.

```python hl_lines="50-62"
import os
import webbrowser
from http.server import BaseHTTPRequestHandler, HTTPServer
from pprint import pprint

import requests
from requests_oauthlib import OAuth2Session


def authenticate():
    os.environ["OAUTHLIB_INSECURE_TRANSPORT"] = "1"  # (1)!

    client_id = "public-test-client"  # (2)!
    auth_url = (
        "https://auth.socialmaps.org/realms/socialmaps/protocol/openid-connect/auth"
    )
    token_url = (
        "https://auth.socialmaps.org/realms/socialmaps/protocol/openid-connect/token"
    )

    session = OAuth2Session(# (3)!
        client_id, redirect_uri="http://127.0.0.1:1234", pkce="S256"
    )

    authorization_url, _state = session.authorization_url(auth_url)# (4)!
    webbrowser.open(authorization_url)

    class OAuthCallbackHandler(BaseHTTPRequestHandler):# (5)!
        def do_GET(self):
            self.server.auth_response_url = (
                f"http://127.0.0.1:{self.server.server_port}{self.path}"
            )

            self.wfile.write(
                b"Authorisation successful!\nClose this page and return to terminal."
            )

        def log_message(self, format, *args):
            pass

    server = HTTPServer(("127.0.0.1", 1234), OAuthCallbackHandler)
    server.handle_request()
    server.server_close()

    session.fetch_token(token_url, authorization_response=server.auth_response_url) # (6)!

    return session# (7)!


session = authenticate()

place = requests.get(
    "https://api.socialmaps.org/v1/places/lookup",
    params={"name": "Glucksman Gallery", "lon": -8.4905846, "lat": 51.8947505},
).json()

review = session.post(
    f"https://api.socialmaps.org/v1/places/{place['id']}/reviews",
    json={"liked": True, "comment": "Great little gallery!"},
).json()

pprint(review)
```

1. We have to enable "insecure transport" as we cannot use HTTPS for our
   redirect URI (`http://127.0.0.1:1234`).
2. You can use `public-test-client` as your client ID whenever you are testing
   Social Maps.
3. An `OAuth2Session` object will help you keep track of the authentication
   state and, once authorised by the user, make authenticated API requests.
4. Before you can get your access token for your app, you need to get
   authorisation from the user (i.e. their consent).
5. After the user authorises your app, they'll be redirected to the URL of your
   choice with an "authorisation code". In this example, we'll start a one-off
   HTTP server to get the authorisation code but you won't need this in
   [mobile apps](https://www.oauth.com/oauth2-servers/redirect-uris/redirect-uris-native-apps/).
6. With the authorisation code you got, you can now retrieve the "access token"
   that you'll use to make authenticated API requests.
7. OAuth is now complete! You can use `session` to make API requests that are
   automatically authenticated.

should print:

```python
{'comment': 'Great little gallery!',
 'created': 1784478582,# (1)!
 'id': 4,
 'liked': True,
 'n_likes': 0,
 'object': 'review',
 'place': {'id': 9655},
 'user': {'id': 2077851}}
```

1. The [Unix timestamp](https://en.wikipedia.org/wiki/Unix_time) of when the
   Review was created.

### Next

You've got the basics of Social Maps! See the [API Reference](/api/) to learn
about other powerful API methods that you can use in your apps.
