package com.bamidele.ajewole.conta

import com.google.android.gms.common.GoogleApiAvailability
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    override fun onResume() {
        super.onResume()
        checkGooglePlayServices()
    }

    override fun onStart() {
        super.onStart()
        checkGooglePlayServices()
    }


    private fun checkGooglePlayServices() {
        val apiAvailability = GoogleApiAvailability.getInstance()
        val resultCode = apiAvailability.isGooglePlayServicesAvailable(this)

        if (resultCode != com.google.android.gms.common.ConnectionResult.SUCCESS) {
            apiAvailability.makeGooglePlayServicesAvailable(this)
        }
    }
}
