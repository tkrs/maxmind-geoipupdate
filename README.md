# geoipupdate

Run [geoipupdate](https://github.com/maxmind/geoipupdate) periodically by using crond.

[![Docker Image Pulls](https://img.shields.io/docker/pulls/tkrs/maxmind-geoipupdate "Docker Image Pulls")](https://img.shields.io/docker/pulls/tkrs/maxmind-geoipupdate)
[![Docker Image Build](https://img.shields.io/docker/build/tkrs/maxmind-geoipupdate "Docker Image Build")](https://img.shields.io/docker/build/tkrs/maxmind-geoipupdate)

## Usage

*Note: Need an account to get the GeoLite2 Databases. See the blog post: https://blog.maxmind.com/2019/12/18/significant-changes-to-accessing-and-using-geolite2-databases/*

### Pull an image

```
docker pull tkrs/maxmind-geoipupdate
```

### Run the image

Simply run `docker run`. You can also customize the behaviour by passing environment variables. Available variables are [here](#variables).

```
docker run -d -e ACCOUNT_ID=${YOUR_ACCOUNT_ID} -e LICENSE_KEY=${YOUR_LICENSE_KEY} -e GEOIP_DB_DIR=/data/GeoIP tkrs/maxmind-geoipupdate
```

Be able to run `/usr/local/bin/run-geoipupdate` directly if you want to one-shot.

```
docker run -it \
        -e ACCOUNT_ID=${YOUR_ACCOUNT_ID} \
        -e LICENSE_KEY=${YOUR_LICENSE_KEY} \
        -e GEOIP_DB_DIR=/data/GeoIP \
        -v "${PWD}":/data/GeoIP \
        tkrs/maxmind-geoipupdate \
        /usr/local/bin/run-geoipupdate
```

### Variables

- *GEOIP_DB_DIR*: The directory to store the database files. Defaults to "/usr/share/GeoIP".
- *MAXMIND_HOST*: The server to use. Defaults to "updates.maxmind.com".
- *PROTOCOL*: The desired protocol either "https" (default) or "http".
- *ACCOUNT_ID*: Your MaxMind account ID. Defaults to "0".
- *LICENSE_KEY*: Your case-sensitive MaxMind license key. Defaults to "000000000000".
- *EDITION_IDS*: List of database edition IDs. Defaults to "GeoLite2-City GeoLite2-Country".
- *SCHEDULE*: The schedule to run geoipupdate. Defaults to "55 20 * * *".
