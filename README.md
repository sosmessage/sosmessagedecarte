# sosmessagedecarte
En manque d'inspiration pour rédiger un message personnel sur la carte d'anniverssaire d'un ami, le pôt de départ d'un collègue... sosmessagedecarte est une application mobile pour générer le message qui va bien et qui fera plaisir.

Elle est disponible sur les deux principales plateformes mobiles que sont iPhone et Android.

## Screenshots
![screen android](https://github.com/sosmessage/sosmessagedecarte/raw/master/android/screenshots/pot.png)
![screen android](https://github.com/sosmessage/sosmessagedecarte/raw/master/android/screenshots/anniv.png)
![screen android](https://github.com/sosmessage/sosmessagedecarte/raw/master/android/screenshots/mariage.png)
![screen android](https://github.com/sosmessage/sosmessagedecarte/raw/master/android/screenshots/merci.png)

TODO 

## iOS

_Warning_: How to use my sosmessage in iOS 

    Open iOS/sosmessage/sosmessage/SMUrlBase.h.sample file
    Set you server url
    Save it as SMUrlBase.h

## Backend

The messages are stored in a mongoDB database.

The administration interface is done using [Play 2.0](http://www.playframework.org/2.0).

The Web services used by the mobile applications are exposed through [Unfiltered](https://github.com/unfiltered/unfiltered).

### MongoDB

To install it on your system, see [here](http://www.mongodb.org/display/DOCS/Quickstart).

#### Casbah

We are using the non released version 3.0.0-SNAPSHOT due to some bugs fixed in this version.

Before running the Administration or API app, you need to install on you local repository the 3.0.0-SNAPSHOT version of Casbah.

	$ git clone git://github.com/mongodb/casbah.git
	$ cd casbah
	$ sbt publish-local

### Administration

#### Install Play 2.0

See the **Building from sources** section [here](https://github.com/playframework/Play20/wiki/Installing).

#### Launch the server

	$ cd backend/sosmessage-admin
	$ play run

The application will be accessible at `http://localhost:9000/`.

### API

#### Install SBT

See the [install instructions](https://github.com/harrah/xsbt/wiki/Getting-Started-Setup).

#### Launch the server

	$ cd backend/sosmessage-api
	$ sbt run
	
The SosMessage API will be accessible at `http://localhost:3000/api/v1/...`.

* `http://localhost:3000/api/v1/categories`: all categories;
* `http://localhost:3000/api/v1/category/{categoryId}/messages`: all the messages of the given category;
* `http://localhost:3000/api/v1/category/{categoryId}/message`: one random message of the given category.

#### Build a single executable JAR

	$ cd backend/sosmessage-api
	$ sbt one-jar

You can then launch the server with:

	$ java -jar sosmessage-api_2.9.1-1.0-SNAPSHOT-one-jar.jar

#### Configuration

To change the default configuration, you can define your own configuration file through a system property:

    $ java -Dsosmessage.configurationFile=conf/sosmessage.conf -jar sosmessage-api_2.9.1-1.0-SNAPSHOT-one-jar.jar

A configuration file looks like (those are the default values):

    database {
      host = 127.0.0.1
      port = 27017
      name = sosmessage
    }
    server {
      port = 3000
    }

#### Logging

Logging is done through [Logback](http://logback.qos.ch/).

To override the default configuration, you can use the one in `conf/` by specifying it as a system property:

	$ java -Dlogback.configurationFile=conf/logback.xml -jar sosmessage-api_2.9.1-1.0-SNAPSHOT-one-jar.jar

See how to configure Logback [here](http://logback.qos.ch/manual/configuration.html).
