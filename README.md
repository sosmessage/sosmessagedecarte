# sosmessagedecarte
En manque d'inspiration pour rédiger un message personnel sur la carte d'anniverssaire d'un ami, le pôt de départ d'un collègue... sosmessagedecarte est une application mobile pour générer le message qui va bien et qui fera plaisir.

Elle est disponible sur les deux principales plateformes mobiles que sont iPhone et Android.

## Screenshots
![screen android](https://github.com/ccouturi/sosmessagedecarte/raw/master/android/screenshots/pot.png)
![screen android](https://github.com/ccouturi/sosmessagedecarte/raw/master/android/screenshots/anniv.png)
![screen android](https://github.com/ccouturi/sosmessagedecarte/raw/master/android/screenshots/mariage.png)
![screen android](https://github.com/ccouturi/sosmessagedecarte/raw/master/android/screenshots/merci.png)

## Running the server
	$ gem install sinatra shotgun
	$ cd server && rake 

  Now, you have WEBrick running through port 9393. 
  Browse to http://127.0.0.1:9393/v1/messages
  
	
## Testing
	$ gem install rspec rack rack-test data_mapper dm-sqlite-adapter
	$ cd server && rake test
	

## Backend

The messages are stored in a mongoDB database.

The administration interface is done using [Play 2.0](http://www.playframework.org/2.0).

The Web services used by the mobile applications are exposed through [BlueEyes](https://github.com/jdegoes/blueeyes).

### Install mongoDB

To install it on your system, see [here](http://www.mongodb.org/display/DOCS/Quickstart).

### Install Play 2.0

See the **Building from sources** section [here](https://github.com/playframework/Play20/wiki/Installing).

### Install BlueEyes

### Launch the administration application

	$ cd backend/sosmessage-admin
	$ play run

The application will be accessible at `http://localhost:9000/`.