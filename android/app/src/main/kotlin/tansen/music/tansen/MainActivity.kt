package tansen.music.tansen

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import androidx.core.view.*

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
  super.onCreate(savedInstanceState)
  WindowCompat.setDecorFitsSystemWindows(window, false)
 
}
}
