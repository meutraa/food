package host.lost.food

import android.os.Build
import android.os.Bundle
import android.os.StrictMode
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        window.setDecorFitsSystemWindows(false)

        super.onCreate(savedInstanceState)
    }
}
