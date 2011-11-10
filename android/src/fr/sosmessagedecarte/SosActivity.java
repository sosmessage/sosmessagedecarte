package fr.sosmessagedecarte;

import java.util.regex.Pattern;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;

public abstract class SosActivity extends Activity {

	private static final String SERVER_URL = "http://10.0.2.2:9393";
	private static final Pattern MESSAGE_EXTRACTOR = Pattern.compile(".*\"content\":\"(.*)\".*");

	private static final String ERROR_MESSAGE = "Ooops ! Il semblerait qu'il soit impossible de récuper de message.\nPeut-être pourriez-vous réessayer plus tard.";

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
		/*
		 * String url = String.format("%s/v1/categories/%s/random", SERVER_URL,
		 * category); try { HttpResponse response = new
		 * DefaultHttpClient().execute(new HttpGet(url)); StatusLine statusLine =
		 * response.getStatusLine(); if (statusLine.getStatusCode() ==
		 * HttpStatus.SC_OK) { ByteArrayOutputStream out = new
		 * ByteArrayOutputStream(); response.getEntity().writeTo(out); out.close();
		 * Matcher matcher = MESSAGE_EXTRACTOR.matcher(out.toString());
		 * matcher.matches(); return matcher.group(1); } else {
		 * alert(ERROR_MESSAGE); return "HTTP status code " +
		 * statusLine.getStatusCode(); } } catch (ClientProtocolException e) {
		 * alert(ERROR_MESSAGE); return e.getMessage(); } catch (IOException e) {
		 * alert(ERROR_MESSAGE); return e.getMessage();}
		 */
		return "It is a long established fact that a reader will be distracted by the readable content of a page"
				+ " when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as"
				+ " opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page"
				+ " editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their"
				+ " infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose "
				+ "(injected humour and the like).";
	}
}