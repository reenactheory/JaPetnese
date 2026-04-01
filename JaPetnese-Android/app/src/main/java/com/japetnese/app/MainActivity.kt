package com.japetnese.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import com.japetnese.app.model.PetManager
import com.japetnese.app.ui.screens.*
import com.japetnese.app.ui.theme.JaPetneseTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            JaPetneseTheme {
                val context = LocalContext.current
                val petManager = remember { PetManager.getInstance(context) }

                if (petManager.hasCompletedOnboarding) {
                    MainScreen(petManager)
                } else {
                    OnboardingScreen(petManager) {
                        petManager.hasCompletedOnboarding = true
                    }
                }
            }
        }
    }
}

@Composable
fun MainScreen(petManager: PetManager) {
    var selectedTab by remember { mutableIntStateOf(0) }

    Scaffold(
        bottomBar = {
            NavigationBar(containerColor = MaterialTheme.colorScheme.surface) {
                NavigationBarItem(
                    selected = selectedTab == 0,
                    onClick = { selectedTab = 0 },
                    icon = { Icon(Icons.Default.Schedule, "시계") },
                    label = { Text("시계") }
                )
                NavigationBarItem(
                    selected = selectedTab == 1,
                    onClick = { selectedTab = 1 },
                    icon = { Icon(Icons.Default.AutoAwesome, "뽑기") },
                    label = { Text("뽑기") }
                )
                NavigationBarItem(
                    selected = selectedTab == 2,
                    onClick = { selectedTab = 2 },
                    icon = { Icon(Icons.Default.Pets, "도감") },
                    label = { Text("도감") }
                )
            }
        }
    ) { padding ->
        Box(modifier = Modifier.padding(padding)) {
            when (selectedTab) {
                0 -> ClockScreen(petManager)
                1 -> GachaScreen(petManager)
                2 -> CollectionScreen(petManager)
            }
        }
    }
}
