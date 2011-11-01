# sosmessagedecarte
En manque d'inspiration pour rédiger un message personnel sur la carte d'anniverssaire d'un ami, le pôt de départ d'un collègue... sosmessagedecarte est une application mobile pour générer le message qui va bien et qui fera plaisir.

Elle est disponible sur les deux principales plateformes mobiles que sont iPhone et Android.

## Screenshots
![screen android](https://github.com/ccouturi/sosmessagedecarte/raw/master/android/screenshots/pot.png)
![screen android](https://github.com/ccouturi/sosmessagedecarte/raw/master/android/screenshots/anniv.png)
![screen android](https://github.com/ccouturi/sosmessagedecarte/raw/master/android/screenshots/mariage.png)
![screen android](https://github.com/ccouturi/sosmessagedecarte/raw/master/android/screenshots/merci.png)

## Server
	$ gem install sinatra shotgun
	$ cd server && rake 

Now, you have WEBrick running through port 9393. 
Browse to http://127.0.0.1:9393/v1/messages 
