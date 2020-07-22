A curriculum vitae LuaLaTeX document class

The ``vita`` class
==================

This document class is based on `twentysecondcv`_ and is heavily inspired by `Bootstrap 4`_.

Alternative style
=================

This style resembles the look `twentysecondcv`_:

.. code-block:: latex

    \NewDocumentCommand\vitasection{ m o }
      {\@vitabox[3.4pt]{\vitabadge{\usekomafont{section}{#1}}}}

.. code-block:: latex

    \NewDocumentCommand{\vitaitem}{ m m o g}{%
      \textbf{\small #1} & \parbox[t]{\@vitaitemwidth}{#2%
        \IfValueT{#3}{\hfill\textcolor{black!80}{\small\mbox{#3}}}%
        \IfValueT{#4}{\\\textcolor{black!80}{\small #4}}}%
      \\}

License
=======

This work is licensed under the MIT license.

.. _twentysecondcv: https://github.com/spagnuolocarmine/TwentySecondsCurriculumVitae-LaTex
.. _Bootstrap 4: https://getbootstrap.com/docs/4.0/getting-started/introduction/
