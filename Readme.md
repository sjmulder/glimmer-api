Glimmer API
===========

Glimmer is a self-hosted iOS ad-hoc distribution and update solution, consisting of the following components:

 * A server that serves RSS update feeds, iOS manifests, and release notes
 * An iOS SDK that polls the server and implements a notification UI

Either component can be replaced, as long as the server adheres to the Glimmer appcast format.

This repository contains a basic server implementation with a publishing/unpublishing API.

Setup
-----

Glimmer API requries ruby 2.0 and Bundler. Once they are installed, this will launch a local server:

    bundle
    rake db:migrate
    rackup

In development mode, an SQLite3 database is created in `db/glimmer.db`.

For production, the `DATABASE_URL` (Postgres) and `API_KEY` should be set.

API
---

The available requests are:

    PUT /apps/<app-slug>/<version>

    GET /apps/<app-slug>.rss
    GET /apps/<app-slug>/<version>/manifest.xml
    GET /apps/<app-slug>/<version>/release-notes.html

Examples
--------

To publish a release:

    curl -v \
         -X PUT \
         -d api_key=\*\*DEV\*\* \
         -d app_title=Sample\ App \
         -d version_string=1.0 \
         -d bundle_identifier=com.example.Sample \
         -d package_url=http://example.com/foo \
         -d icon_url=http://example.com/foo-icon.png \
         -d icon_needs_shine=1 \
         -d artwork_url=http://example.com/foo-artwork.png \
         -d artwork_needs_shine=1 \
         -d release_notes_html=Hello,\ World\! \
         http://localhost:9292/apps/sample-app/12    

Of these, `api_key`, `app_title` and `bundle_identifier` are required. Also notice the app slug and version code in the URL.

Now the RSS feed can be loaded based on the app‘s slug:

    curl http://glimmer-api.dev/apps/sample-app.rss

    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
      <channel>
        <title>Sample App</title>
        <link>http://glimmer-api.dev/apps/sample-app.rss</link>
        <item>
          <title>Sample App 1.0</title>
          <link>http://example.com/foo</link>
          <pubDate>Fri, 03 Jan 2014 21:10:26 -0000</pubDate>
          <guild>http://localhost:9292/apps/sample-app/12</guild>
          <glimmer:manifestLink>http://localhost:9292/apps/sample-app/12/manifest.xml</glimmer:manifestLink>
          <sparkle:releaseNotesLink>http://localhost:9292/apps/sample-app/12/release-notes.html</sparkle:releaseNotesLink>
        </item>
      </channel>
    </rss>

Deleting a release:

    curl -v \
         -X DELETE \
         -d api_key=\*\*DEV\*\* \
         http://localhost:9292/apps/sample-app/12

Author
------

By Sijmen Mulder (ik@sjmulder.nl)
