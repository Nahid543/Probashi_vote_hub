import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// android/key.properties
val keystoreProperties = Properties().apply {
    val file = rootProject.file("key.properties")   // <-- no extra "android/"
    if (file.exists()) {
        load(file.inputStream())
    } else {
        println("WARNING: key.properties not found. Release signing will fail.")
    }
}

android {
    namespace = "com.appdev.probashi_vote_hub"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    signingConfigs {
        create("release") {
            val storeFilePath = keystoreProperties.getProperty("storeFile")
            if (storeFilePath != null) {
                storeFile = file(storeFilePath)        // -> android/app/release-key.jks
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            } else {
                println("WARNING: storeFile not set in key.properties")
            }
        }
    }

    defaultConfig {
        applicationId = "com.appdev.probashi_vote_hub"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")  // <-- important
            isMinifyEnabled = false
            isShrinkResources = false
        }
        debug { }
    }
}

flutter {
    source = "../.."
}
