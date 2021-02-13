# bd_l10n

Generate localizations for a Flutter project.

The tool is built on top of flutter new localization tool gen-l10n.

Without some current limitations of the tool [73870](https://github.com/flutter/flutter/issues/73870),
[70840](https://github.com/flutter/flutter/issues/70840), [58183](https://github.com/flutter/flutter/issues/58183) and
of course separating localization files by features for example.

The tool benefits from all bug fixes and improvements of made on gen-l10n.

## Overview

Let's say your app has the following features:

- Common
- Authentication
- Home

You want to separate localized messages by features, meaning Authentication and Home have they own localized messages.
Common feature have localized messages related to the whole app.

So you can use it like that:

```dart

final commonLocalization = Common.of(context);
```

Or

```dart

final commonAuthentication = Authentication.of(context);
```

Or

```dart

final homeLocalization = Home.of(context);
```

You create your bd_l10n configuration file somewhere in your project directory, the configuration file need to be named
bd_l10n.yaml and will look like this:

```yaml
project-type: flutter
features:
  - name: 'Common' # name of the feature is also used as name of the generated file and class.
    translation-dir: translation/common # where your localized messages are stored.
    translation-template: common_en.arb # which file to use as template.
    output-dir: lib/localizations/ # directory were the generated code will be generated.

  - name: 'Home'
    translation-dir: translation/home
    translation-template: home_en.arb
    output-dir: lib/localizations/

  - name: 'Authentication'
    translation-dir: translation/authentication
    translation-template: authentication_en.arb
    output-dir: lib/localizations/
```

Now, you need to install bd_l10n tool and the required dependencies. in your pubspec.yaml

```yaml
#### other configurations
dependencies:
  # other dependencies.
  flutter_localizations: # because the generated code use locale and LocalizationDelegate.
    sdk: flutter
  intl: ^0.16.1 # or any version you use.

dev_dependencies:
  # other dependencies.
  bd_l10n: ^1.0.0 # or the current stable version
```

## Usage

bd_l10n can be used as a command line tool or with [build_runner](https://pub.dev/packages/build_runner).

If you're already using build_runner in your project, that's all you have to do because bd_l10n also provide a builder,
that will trigger the localization generation automatically when you will run build_runner build.

If you're not using build_runner, I recommend using the command line utility, but don't worry you will have to run it
once (unless you reboot your computer).

```shell
flutter pub run bd_l10n --config-file [path to your config file] [path to your project]
```

example:

```shell
flutter pub run bd_l10n --config-file bd_l10n.yaml .
```

bd_l10n has a file watcher feature meaning that even if you're using command line tool, you will only have to run it
once, and then bd_l10n will watch for file changes in the feature translation directories also when the configuration
file changes and automatically generate localizations classes.

So your localizations classes will be generated automatically without you doing anything, this allows you with hot
reload to see your translations as the app is running, without you needing to restart the application
(at least on android) or to automate generation when you add new localization files.

To stop the file watcher if the tool has been run with it previously, just delete any files starting with bd_l10n and
ending with lock.

This file is located in the same directory as your configuration file.

This file also contains logs on events received by the file watcher.

If an error happened during the execution of bd_l10n, you will see a bd_l10n_error.txt in the directory where the tool
was executed.

## Full Configuration file description.

```yaml
project-type: flutter # type of the project, only flutter is supported at the moment.

features: # list of features used in the project, a project must have at least one feature.
  - name: 'Application' # name of the feature is also used as name of the generated file and classes.
    translation-dir: translation/common # where your localized messages are stored.
    translation-template: common_en.arb # which file to use as template, this file should be in the translation-dir
    output-dir: lib/localizations/ # Were the generated localization classes written.
    use-deferred-loading: true # enabled deferred loading of localizations, this is mainly for web at the moment.
```


You can find native binaries of the tool [here](https://github.com/bitsydarel/bd_l10n/releases).

[license](https://github.com/bitsydarel/bd_l10n/blob/master/LICENSE).
