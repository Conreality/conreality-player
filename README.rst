*********************
Conreality Player App
*********************

.. image:: https://img.shields.io/badge/license-Public%20Domain-blue.svg
   :alt: Project license
   :target: https://unlicense.org

.. image:: https://img.shields.io/travis/conreality/conreality-player/master.svg
   :alt: Travis CI build status
   :target: https://travis-ci.org/conreality/conreality-player

|

https://wiki.conreality.org/Apps

----

Prerequisites
=============

Build Prerequisites
-------------------

- `Flutter <https://flutter.io/>`__

- `Android Studio <https://developer.android.com/studio/>`__
  (for Android only)

- `Xcode <https://developer.apple.com/xcode/>`__
  (for iOS only)

- `fastlane <https://fastlane.tools/>`__
  (optional)

Development Prerequisites
-------------------------

Development Environment
^^^^^^^^^^^^^^^^^^^^^^^

We recommend using `Visual Studio Code <https://code.visualstudio.com/>`__
as a comparatively lightweight development environment for developing this
app.

----

Installation
============

Build a debug release and run the app on an emulator or device as follows::

   $ flutter run

----

Development Tips
================

View the Localizations
----------------------

To view the string translations pretty-printed in the terminal, use
``column(1)`` (requires ``bsdmainutils`` on Debian and derivatives)::

   $ column -t -s $'\t' etc/strings.tsv

Dump the Cache
--------------

To dump the app's SQLite cache using the `Android Debug Bridge
<https://developer.android.com/studio/command-line/adb>`__, execute::

   $ adb exec-out run-as org.conreality.player sqlite3 /data/user/0/org.conreality.player/cache/cache.db .dump

To copy the app's SQLite database to your development host, execute::

   $ adb exec-out run-as org.conreality.player cat /data/user/0/org.conreality.player/cache/cache.db > cache.db

Clear the Cache
---------------

To clear the app's SQLite cache, execute::

   $ adb exec-out run-as org.conreality.player rm /data/user/0/org.conreality.player/cache/cache.db

Share a Link From Computer
--------------------------

::

   $ adb shell am start -D -W -a android.intent.action.SEND -t text/plain -e android.intent.extra.TEXT https://example.org

----

Development Notes
=================

- Since our model defines an ``Object`` class, which is usually used without
  explicit namespacing, when upcasting we should prefer Dart's ``dynamic``
  type over its ``Object`` base class to avoid ambiguity and confusion. [#]_

.. [#] https://stackoverflow.com/q/31257735

----

See Also
========

- `Conreality Development Environment
  <https://github.com/conreality/conreality-devbox>`__
