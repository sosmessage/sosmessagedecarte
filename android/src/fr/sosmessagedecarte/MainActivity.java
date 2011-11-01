package fr.sosmessagedecarte;

import android.app.TabActivity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.TabHost;
import android.widget.TabHost.TabSpec;

public class MainActivity extends TabActivity {

	private TabHost tabHost;
	private TabSpec tabSpec;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		Intent intent = new Intent(this, SosActivity.class);
		tabHost = getTabHost();
		tabSpec = tabHost.newTabSpec("pot").setIndicator("Pot").setContent(intent);
		tabHost.addTab(tabSpec);

		tabSpec = tabHost.newTabSpec("anniv").setIndicator("Anniversaire").setContent(intent);
		tabHost.addTab(tabSpec);

		tabSpec = tabHost.newTabSpec("mariage").setIndicator("Mariage").setContent(intent);
		tabHost.addTab(tabSpec);
	}
}
