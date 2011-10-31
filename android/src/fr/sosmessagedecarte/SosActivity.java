package fr.sosmessagedecarte;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class SosActivity extends Activity {
	/** Called when the activity is first created. */

	private TextView text;
	private Button myButton;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		text = (TextView) findViewById(R.id.text);
		myButton = (Button) findViewById(R.id.myButton);

		myButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				text.setText("hohoho");
			}
		});

	}
}