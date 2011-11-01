package fr.sosmessagedecarte;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;

public abstract class SosActivity extends Activity {

	private static final String SERVER_URL = "http://127.0.0.1:9393";

	private static final String ERROR_MESSAGE = "Ooops ! Il semblerait qu'il soit impossible de récuper de message.\nPeut-être pourriez-vous réessayer plus tard.";

	private static String[] tmpMessages = {
			"Tu perds un ami un fois, c'est de sa faute; Tu perds un ami deux fois, c'est de la tienne.",
			"Et encore merci pour le poisson.",
			"Salut, et à la revoyure.",
			"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged." };

	protected void alert(String message) {
		AlertDialog alertDialog = new AlertDialog.Builder(this).create();
		alertDialog.setMessage(message);
		alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {
				return;
			}
		});
		alertDialog.show();
	}

	protected String getRandomMessage(String category) {
		try {
			HttpClient httpclient = new DefaultHttpClient();
			String url = String.format("%s/v1/categories/%s/random", SERVER_URL, category);
			HttpResponse response = httpclient.execute(new HttpGet(url));
			StatusLine statusLine = response.getStatusLine();
			if (statusLine.getStatusCode() == HttpStatus.SC_OK) {
				ByteArrayOutputStream out = new ByteArrayOutputStream();
				response.getEntity().writeTo(out);
				out.close();
				String responseString = out.toString();
				return responseString;
			} else {
				alert(ERROR_MESSAGE);
				return "HTTP status code " + statusLine.getStatusCode();
			}
		} catch (ClientProtocolException e) {
			alert(ERROR_MESSAGE);
			return e.getMessage();
		} catch (IOException e) {
			alert(ERROR_MESSAGE);
			return e.getMessage();
		}
	}
}