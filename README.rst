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

To view the string translations pretty-printed in the terminal, use
``column(1)`` (requires ``bsdmainutils`` on Debian and derivatives)::

   $ column -t -s $'\t' etc/strings.tsv

----

See Also
========

- `Conreality Development Environment
  <https://github.com/conreality/conreality-devbox>`__
