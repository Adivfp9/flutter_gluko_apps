plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.adipurwanto.glukotrack"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.adipurwanto.glukotrack"
        // NFR-01: Android 8.0+ (API 26). Jangan turunkan — di bawah API 26
        // penjadwalan notifikasi exact dan BiometricPrompt berperilaku berbeda.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO(sprint-5.7): ganti dengan keystore rilis sebelum publikasi.
            // Saat ini masih memakai kunci debug agar `flutter run --release` jalan.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // NFR-08: aplikasi hanya portrait (lihat juga android:screenOrientation di manifest).
    // NFR-10: pantau ukuran artefak — varian SQLCipher menautkan OpenSSL.
    packaging {
        resources {
            excludes += setOf("META-INF/*.kotlin_module")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    // Tema Theme.AppCompat di styles.xml (syarat BiometricPrompt local_auth).
    implementation("androidx.appcompat:appcompat:1.7.1")
}
