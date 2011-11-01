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
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class MariageActivity extends Activity {

	private static String[] tmpMessages = {
			"Tu perds un ami un fois, c'est de sa faute; Tu perds un ami deux fois, c'est de la tienne.",
			"Et encore merci pour le poisson.",
			"Salut, et à la revoyure.",
			"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged." };

	private static final String MESSAGE_URL = "http://www.google.com";
	private TextView text;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.mariage);

		Typeface tf = Typeface.createFromAsset(getAssets(), "fonts/Bodoni SvtyTwo OS ITC TT.dfont");
		text = (TextView) findViewById(R.id.text);
		text.setTypeface(tf);

		Button myButton = (Button) findViewById(R.id.myButton);
		myButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				text.setText(getRandomMessage());
			}
		});
	}

	private String getRandomMessage() {
		try {
			HttpClient httpclient = new DefaultHttpClient();
			HttpResponse response;
			response = httpclient.execute(new HttpGet(MESSAGE_URL));
			StatusLine statusLine = response.getStatusLine();
			if (statusLine.getStatusCode() == HttpStatus.SC_OK) {
				ByteArrayOutputStream out = new ByteArrayOutputStream();
				response.getEntity().writeTo(out);
				out.close();
				String responseString = out.toString();
				return responseString;
				// ..more logic
			} else {
				// Closes the connection.
				response.getEntity().getContent().close();
				return "ERREUR1";
			}
		} catch (ClientProtocolException e) {
			return "ERREUR2";
		} catch (IOException e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
			return e.getMessage();
		}
	}
}