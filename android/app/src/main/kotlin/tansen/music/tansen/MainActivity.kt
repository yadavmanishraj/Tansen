package tansen.music.tansen

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import androidx.core.view.*
import com.ryanheise.audioservice.AudioServiceActivity

class MainActivity : AudioServiceActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }

    override fun onRestart() {
        super.onRestart()
    }
}
