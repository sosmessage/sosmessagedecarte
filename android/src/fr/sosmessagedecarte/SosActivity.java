package fr.sosmessagedecarte;

import android.app.Activity;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class SosActivity extends Activity {
	/** Called when the activity is first created. */

	private static String[] tmpMessages = { "Adieu", "Et encore merci pour le poisson.",
			"Salut, et à la revoyure." };

	private TextView text;
	private Button myButton;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		Typeface tf = Typeface.createFromAsset(getAssets(), "fonts/BodoniFLF-Italic.ttf");
		text = (TextView) findViewById(R.id.text);
		text.setTypeface(tf);
		myButton = (Button) findViewById(R.id.myButton);

		myButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				text.setText(tmpMessages[new Double(Math.random() * 3).intValue()]);
			}
		});

	}
}