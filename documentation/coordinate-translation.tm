<TeXmacs|1.0.7.4>

<style|generic>

<\body>
  <doc-data|<doc-title|Converting Geomagnetic Field Vectors<next-line>to
  Earth Centered Inertial>|<doc-author-data|<author-name|Matthew P.
  Wampler-Doty>>>

  This document details how to convert the geomagnetic field vectors output
  by the NOAA World Magnetic Model (WMM) to an Earth Centered Inertial (ECI)
  frame.

  Vectors in the WMM geomagnetic reference frame have three components:

  <\itemize-minus>
    <math|<wide|<with|mode|text|<strong|x>>|^>><item>the amplitude in the
    northerly direction

    <math|<wide|<with|mode|text|<strong|y>>|^>><item>the amplitude in the
    easterly direction

    <math|<wide|<with|mode|text|<strong|z>>|^>><item>the amplitude in the
    downward direction, towards the earth
  </itemize-minus>

  <\with|par-mode|center>
    <small-figure|<postscript|../../../Development/CXRBNanoSat-Simulation-Environment/documentation/geomag-ref-frame.pdf|*5/8|*5/8||||>|The
    WMM geomagnetic reference frame>
  </with>

  Vectors in the ECI frame also have three components:

  <\itemize-minus>
    <math|<wide|<with|mode|text|<strong|v>>|^>><item>the amplitude in the
    direction of the vernal equinox

    <math|<wide|<with|mode|text|<strong|u>>|^>><item>the amplitude in the
    direction of north of the ecliptic plane

    <math|<wide|<with|mode|text|<strong|w>>|^>><item>the amplitude along the
    ecliptic plane that is orthogonal to the vernal equinox
  </itemize-minus>

  <\with|par-mode|center>
    <small-figure|<postscript|../../../Development/CXRBNanoSat-Simulation-Environment/documentation/eci-ref-frame.pdf|*5/8|*5/8||||>|The
    ECI reference frame>
  </with>

  Both the WMM geomagnetic and ECI reference frames are right handed.

  \;

  Every WMM geomagnetic field vector is associated with a latitude and
  longitude at a particular time, which are in turn associated with a
  <with|font-shape|italic|right ascension> <math|\<rho\>> and
  <with|font-shape|italic|declination> <math|\<delta\>> on the celestial
  sphere.

  \;

  The coordinate transformations between WMM geomagnetic field vectors and
  ECI vectors form two inverse rotations functional on <math|\<rho\>> and
  <math|\<delta\>>, which we represent as rotation matrices. \ It suffices to
  construct only one of these transformations, since the inverse is given by
  the transpose.

  \;

  We will illustrate how to translate an ECI vector into WMM geomagnetic
  vector. \ Our motivation is depicted in Figure
  <reference|spherical-triangle>. \ This depicts a spherical triangle on the
  earth, each corner representing certain values for <math|\<rho\>> and
  <math|\<delta\>>.

  <\with|par-mode|center>
    <small-figure|<postscript|../../../Development/CXRBNanoSat-Simulation-Environment/documentation/spherical_triangle.pdf|*5/8|*5/8||||>|<label|spherical-triangle>Spherical
    Triangle and ECI axes>
  </with>

  Using Figure <reference|spherical-triangle>, we can see how at different
  values of <math|\<rho\>> and <math|\<delta\>> the ECI vector components
  translate into WMM magnetic field vector components.

  Take, for instance, the point where <math|\<delta\>=90<rsup|\<circ\>>> (the
  north pole and the top point in the diagram). \ We can see that
  <math|<wide|<with|mode|text|<strong|z>>|^>=-<with|mode|text|<math|<wide|<with|mode|text|<strong|u>>|^>>>>
  at this point, that is the amplitude towards the earth of the geomagnetic
  field vector is exactly the opposite of its amplitude north of the
  ecliptic. \ Likewise, we can see from the picture that for all points where
  <math|\<delta\>=0<rsup|\<circ\>>>, <with|mode|math|<wide|<with|mode|text|<strong|z>>|^>>
  is orthogonal to <with|mode|math|<with|mode|text|<math|<wide|<with|mode|text|<strong|u>>|^>>>>.
  \ In fact the relationship is

  <\equation>
    \ <wide|<with|mode|text|<strong|z>>|^>\<propto\>-sin \<delta\>
    \ <wide|<with|mode|text|<strong|u>>|^><label|eq1>
  </equation>

  By symmetry conditions, we know that <math|\<pm\>cos \<delta\>> must be
  split among the other two unit vector components
  <with|mode|math|<with|mode|text|<math|<wide|<with|mode|text|<strong|v>>|^>>>>
  and <with|mode|math|<with|mode|text|<math|<wide|<with|mode|text|<strong|w>>|^>>>>.

  At the equator, where <math|\<delta\>=0<rsup|\<circ\>>>, we have drawn two
  other points to consider. \ The first is where
  <math|\<rho\>=0<rsup|\<circ\>>>. \ At this point,
  <math|<wide|<with|mode|text|<strong|z>>|^>=-<with|mode|text|<math|<wide|<with|mode|text|<strong|v>>|^>>>>.
  \ At <math|\<rho\>=-90<rsup|\<circ\>>>, we have
  <math|<wide|<with|mode|text|<strong|z>>|^>=<with|mode|text|<math|<wide|<with|mode|text|<strong|w>>|^>>>>.
  \ Noting that both <with|mode|math|<with|mode|text|<math|<wide|<with|mode|text|<strong|v>>|^>>>>
  and <with|mode|math|<with|mode|text|<math|<wide|<with|mode|text|<strong|w>>|^>>>>
  must split <with|mode|math|cos \<delta\>>, we observe the following other
  relationships:

  <\equation>
    <wide|<with|mode|text|<strong|z>>|^> \<propto\>- cos \<delta\> \ cos
    \<rho\> <with|mode|text|<math|<wide|<with|mode|text|<strong|v>>|^>>><label|eq2>
  </equation>

  <\equation>
    <wide|<with|mode|text|<strong|z>>|^> \<propto\>- cos \<delta\> \ sin
    \<rho\> <with|mode|text|<math|<wide|<with|mode|text|<strong|w>>|^>>><label|eq3>
  </equation>

  Combining (<reference|eq1>), (<reference|eq2>), and (<reference|eq3>), we
  have:

  <\equation>
    <wide|<with|mode|text|<strong|z>>|^> =-sin \<delta\>
    <with|mode|text|<math|<wide|<with|mode|text|<strong|u>>|^>>>- cos
    \<delta\> \ cos \<rho\> <with|mode|text|<math|<wide|<with|mode|text|<strong|v>>|^>>>-
    cos \<delta\> \ sin \<rho\> <with|mode|text|<math|<wide|<with|mode|text|<strong|w>>|^>>><label|eqz>
  </equation>

  One can take a dot product of the right hand side with itself and verify
  that it is indeed 1, which is consistent with the fact that
  <with|mode|math|<wide|<with|mode|text|<strong|z>>|^>> is a unit vector.

  A similar treatment can be given to <math|<wide|<with|mode|text|<strong|y>>|^>>.
  \ Note that regardless of the declination <math|\<delta\>> and right
  ascension <math|\<rho\>>, <math|<wide|<with|mode|text|<strong|y>>|^>> is
  orthogonal to <with|mode|math|<with|mode|text|<math|<wide|<with|mode|text|<strong|u>>|^>>>>.
  \ Indeed:

  <\equation>
    \ <wide|<with|mode|text|<strong|y>>|^>\<propto\>0
    \ <wide|<with|mode|text|<strong|u>>|^><label|eq5>
  </equation>

  Next, note that <with|font-shape|italic|easterliness> for the ECI reference
  frame is completely independent of declination <math|\<delta\>>. \ No
  matter what longitude we are, it's always functional on
  <with|mode|math|<with|mode|text|<math|<wide|<with|mode|text|<strong|w>>|^>>>>
  and <with|mode|math|<with|mode|text|<math|<wide|<with|mode|text|<strong|v>>|^>>>>.

  Moreover, at <math|\<rho\>=0<rsup|\<circ\>>> we have
  <math|<wide|<with|mode|text|<strong|y>>|^>=<with|mode|text|<math|<wide|<with|mode|text|<strong|w>>|^>>>>
  and at <with|mode|math|<math|\<rho\>=-90<rsup|\<circ\>>>>, we have
  <math|<wide|<with|mode|text|<strong|y>>|^>=<with|mode|text|<math|<wide|<with|mode|text|<strong|v>>|^>>>>.
  \ Interpolating between these points, we have:

  <\equation>
    \ <wide|<with|mode|text|<strong|y>>|^>\<propto\>cos \<rho\>
    <with|mode|text|<math|<wide|<with|mode|text|<strong|w>>|^>>><label|eq6>
  </equation>

  <\equation>
    \ <wide|<with|mode|text|<strong|y>>|^>\<propto\>-sin \<rho\>
    <with|mode|text|<math|<wide|<with|mode|text|<strong|v>>|^>>><label|eq7>
  </equation>

  This gives us:

  <\equation>
    <wide|<with|mode|text|<strong|y>>|^> =0
    <with|mode|text|<math|<wide|<with|mode|text|<strong|u>>|^>>>-sin \<rho\>
    <with|mode|text|<math|<wide|<with|mode|text|<strong|v>>|^>>>+ \ cos
    \<rho\> <with|mode|text|<math|<wide|<with|mode|text|<strong|w>>|^>>><label|eqy>
  </equation>

  Since the WMM geomagnetic reference frame is right handed, we know that
  <math|<wide|<with|mode|text|<strong|y>>|^>\<times\><wide|<with|mode|text|<strong|z>>|^>=<wide|<with|mode|text|<strong|x>>|^>>

  Hence:

  <\align*>
    <tformat|<table|<row|<cell|<wide|<with|mode|text|<strong|x>>|^>>|<cell|=<wide|<with|mode|text|<strong|y>>|^>\<times\><wide|<with|mode|text|<strong|z>>|^>>>|<row|<cell|>|<cell|=(-sin
    \<delta\> <with|mode|text|<math|<wide|<with|mode|text|<strong|u>>|^>>>-
    cos \<delta\> \ cos \<rho\> <with|mode|text|<math|<wide|<with|mode|text|<strong|v>>|^>>>-
    cos \<delta\> \ sin \<rho\> <with|mode|text|<math|<wide|<with|mode|text|<strong|w>>|^>>>)\<times\>(0
    <with|mode|text|<math|<wide|<with|mode|text|<strong|u>>|^>>>-sin \<rho\>
    <with|mode|text|<math|<wide|<with|mode|text|<strong|v>>|^>>>+ \ cos
    \<rho\>)>>|<row|<cell|>|<cell|=(-cos \<delta\> \ cos<rsup|2>\<rho\> -cos
    \<delta\> \ sin<rsup|2>\<rho\> )<with|mode|text|<math|<wide|<with|mode|text|<strong|u>>|^>>>+sin
    \<delta\> \ cos \<rho\> <with|mode|text|<math|<wide|<with|mode|text|<strong|v>>|^>>>+sin
    \<delta\> \ sin \<rho\> <with|mode|text|<math|<wide|<with|mode|text|<strong|w>>|^>>>>>>>
  </align*>

  This ultimately means:

  <\equation>
    <wide|<with|mode|text|<strong|x>>|^>=-cos \<delta\>
    \ <with|mode|text|<math|<wide|<with|mode|text|<strong|u>>|^>>>+sin
    \<delta\> \ cos \<rho\> <with|mode|text|<math|<wide|<with|mode|text|<strong|v>>|^>>>+sin
    \<delta\> \ sin \<rho\> <with|mode|text|<math|<wide|<with|mode|text|<strong|w>>|^>>><label|eqx>
  </equation>

  Taking (<reference|eqz>), (<reference|eqy>) and (<reference|eqx>) together,
  we get a rotation matrix, which makes true the following relationship:

  <\equation*>
    <matrix|<tformat|<table|<row|<cell|<wide|<with|mode|text|<strong|x>>|^>>|<cell|<wide|<with|mode|text|<strong|y>>|^>>|<cell|<wide|<with|mode|text|<strong|z>>|^>>>>>>=<matrix|<tformat|<table|<row|<cell|-cos
    \<delta\>>|<cell|sin \<delta\> \ cos \<rho\>>|<cell|sin \<delta\> \ sin
    \<rho\>>>|<row|<cell|0>|<cell|-sin \<rho\>>|<cell|cos
    \<rho\>>>|<row|<cell|-sin \<delta\>>|<cell|- cos \<delta\> \ cos
    \<rho\>>|<cell|- cos \<delta\> \ sin \<rho\>>>>>>\<cdot\><matrix|<tformat|<table|<row|<cell|<with|mode|text|<math|<wide|<with|mode|text|<strong|u>>|^>>>>>|<row|<cell|<with|mode|text|<math|<wide|<with|mode|text|<strong|v>>|^>>>>>|<row|<cell|<with|mode|text|<math|<wide|<with|mode|text|<strong|w>>|^>>>>>>>>
  </equation*>

  Indeed, we can see that its transpose is its inverse:

  <\equation*>
    <matrix|<tformat|<table|<row|<cell|- cos \<delta\>
    \ >|<cell|0>|<cell|-sin \<delta\>>>|<row|<cell|sin \<delta\> \ cos
    \<rho\>>|<cell|-sin \<rho\>>|<cell|- cos \<delta\> \ cos
    \<rho\>>>|<row|<cell|sin \<delta\> \ sin \<rho\>>|<cell|cos
    \<rho\>>|<cell|-cos \<delta\> sin \<rho\>>>>>>\<cdot\><matrix|<tformat|<table|<row|<cell|-cos
    \<delta\>>|<cell|sin \<delta\> \ cos \<rho\>>|<cell|sin \<delta\> \ sin
    \<rho\>>>|<row|<cell|0>|<cell|-sin \<rho\>>|<cell|cos
    \<rho\>>>|<row|<cell|-sin \<delta\>>|<cell|- cos \<delta\> \ cos
    \<rho\>>|<cell|- cos \<delta\> \ sin \<rho\>>>>>>=<matrix|<tformat|<table|<row|<cell|1>|<cell|0>|<cell|0>>|<row|<cell|0>|<cell|1>|<cell|0>>|<row|<cell|0>|<cell|0>|<cell|1>>>>>
  </equation*>

  This means that we may use the transpose to translate the WMM magnetic
  field reference frame to ECI reference frame as follows:

  <\equation*>
    <matrix|<tformat|<table|<row|<cell|<wide|<with|mode|text|<strong|u>>|^>>|<cell|<wide|<with|mode|text|<strong|v>>|^>>|<cell|<wide|<with|mode|text|<strong|w>>|^>>>>>>=<matrix|<tformat|<table|<row|<cell|-
    cos \<delta\> \ >|<cell|0>|<cell|-sin \<delta\>>>|<row|<cell|sin
    \<delta\> \ cos \<rho\>>|<cell|-sin \<rho\>>|<cell|- cos \<delta\> \ cos
    \<rho\>>>|<row|<cell|sin \<delta\> \ sin \<rho\>>|<cell|cos
    \<rho\>>|<cell|-cos \<delta\> sin \<rho\>>>>>>\<cdot\><matrix|<tformat|<table|<row|<cell|<with|mode|text|<math|<wide|<with|mode|text|<strong|x>>|^>>>>>|<row|<cell|<with|mode|text|<math|<wide|<with|mode|text|<strong|y>>|^>>>>>|<row|<cell|<with|mode|text|<math|<wide|<with|mode|text|<strong|z>>|^>>>>>>>>
  </equation*>
</body>

<\initial>
  <\collection>
    <associate|language|american>
    <associate|page-type|letter>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|?>>
    <associate|auto-2|<tuple|2|?>>
    <associate|auto-3|<tuple|3|?>>
    <associate|auto-4|<tuple|4|?>>
    <associate|eq1|<tuple|4|?>>
    <associate|eq2|<tuple|2|?>>
    <associate|eq3|<tuple|3|?>>
    <associate|eq4|<tuple|5|?>>
    <associate|eq5|<tuple|5|?>>
    <associate|eq6|<tuple|6|?>>
    <associate|eq7|<tuple|7|?>>
    <associate|eqx|<tuple|9|?>>
    <associate|eqy|<tuple|8|?>>
    <associate|eqz|<tuple|4|?>>
    <associate|spherical-triangle|<tuple|3|?>>
  </collection>
</references>