import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "br.agenda.app_agenda"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Exigido pelo flutter_local_notifications para agendar notificações.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "br.agenda.app_agenda"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // A chave fixa vem do segredo ASSINATURA_APK do GitHub (ver .github/workflows/apk.yml).
    // Com ela todo APK tem a mesma assinatura e atualiza por cima sem perder dados.
    val chave = rootProject.file("key.properties")
    signingConfigs {
        if (chave.exists()) {
            val props = Properties().apply { chave.inputStream().use { load(it) } }
            create("fixa") {
                storeFile = rootProject.file(props.getProperty("storeFile"))
                storePassword = props.getProperty("password")
                keyAlias = props.getProperty("keyAlias")
                keyPassword = props.getProperty("password")
            }
        }
    }

    buildTypes {
        release {
            // Sem a chave fixa (ex.: no computador) usa a chave de depuração.
            signingConfig = signingConfigs.findByName("fixa") ?: signingConfigs.getByName("debug")
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
}
