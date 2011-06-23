<TeXmacs|1.0.7.7>

<style|generic>

<\body>
  <section|State Variables>

  The dynamic variables we need to keep track of are:

  <\with|par-mode|center>
    <math|t\<colons\>\<bbb-R\><rsub|seconds>><space|6spc><math|L<rsub|t>\<colons\>\<bbb-S\><rsub|Newton-meter-seconds>><space|6spc><math|R<rsub|t>\<colons\>\<bbb-E\>\<rightarrow\>\<bbb-S\>>
  </with>

  <\itemize-dot>
    <item><math|t> is the time (a floating point value)

    <item><math|L<rsub|t>> is the <em|instantaneous angular momentum> at time
    <math|t> (represented as a 3-vector of the components in spacecraft
    coordinates)

    <item><math|R<rsub|t>> is the <em|rotation> from <with|color|red|earth
    centered coordinates (<math|\<bbb-E\>>)> to
    <with|color|red|<with|color|blue|spacecraft coordinates
    (<math|\<bbb-S\>>)>> at time <math|t> (represented as a
    <math|3\<times\>3> matrix of floating points)
  </itemize-dot>

  <section|Constants>

  The constants are

  <\with|par-mode|center>
    <math|\<Delta\>t\<colons\>\<bbb-R\><rsub|seconds><space|5spc>I\<colons\>\<bbb-M\>(3\<times\>3)<rsub|kilogram-meter<rsup|2>><space|5spc>\<b-m\>\<colons\>\<bbb-S\><rsub|Joules-per-Tesla>>
  </with>

  <\itemize-dot>
    <item><math|\<Delta\>t> is the timestep (a floating point)

    <item><math|I> is the moment of inertia tensor (a <math|3\<times\>3>
    matrix in spacecraft coordinates)

    <item><math|<with|math-font-series|bold|m>> is the dipole moment (a
    3-vector in spacecraft coordinates)
  </itemize-dot>

  <section|Other Functions>

  The functions are:

  <\with|par-mode|center>
    <\equation*>
      p\<colons\>\<bbb-R\><rsub|seconds>\<rightarrow\>\<bbb-E\>\<times\>\<bbb-R\><rsub|meters><space|5spc>B<rsub|WMM>:\<bbb-E\>\<times\>\<bbb-R\><rsub|meters>\<rightarrow\>\<bbb-R\><rsub|seconds>\<rightarrow\>\<bbb-E\><rsub|Tesla>
    </equation*>
  </with>

  <\with|par-mode|center>
    <math|d\<colons\>\<bbb-E\>\<times\>\<bbb-R\><rsub|meters>\<rightarrow\>(\<bbb-E\>\<rightarrow\>\<bbb-S\>)\<rightarrow\>\<bbb-E\><rsub|Joules>>
  </with>

  <\itemize-dot>
    <item><math|p(t)> is the position of the satellite at time <math|t>, in
    terms of earth centered inertial coordinates and altitude

    <item><math|B<rsub|WMM>(\<langle\>\<alpha\>,\<delta\>,h\<rangle\>,t)> is,
    given earth centered inertial coordinates and altitude, the earth's
    magnetic field in at time <math|t>

    <item><math|d(\<langle\>\<alpha\>,\<delta\>,h\<rangle\>,R)> is the
    atmospheric drag given earth centered inertial coordinates and altitude,
    along with the orientation of the satellite
  </itemize-dot>

  <section|Updating <math|L<rsub|t>> to <math|L<rsub|t+\<Delta\>t>>>

  To update <math|L<rsub|t>>, we calculate two torques. \ The first is the
  magnetic torque:

  <\equation*>
    \<tau\><rsub|magnetic>\<assign\>\<b-m\>\<times\>(R<rsub|t>\<cdot\>B<rsub|WMM>(p(t),t))
  </equation*>

  We calculate the Earth's magnetic field at the current place and time, and
  then translate it into spacecraft coordinates before applying crossing with
  the dipole moment to obtain the torque

  <\equation*>
    \<tau\><rsub|drag>\<assign\>R<rsub|t>\<cdot\>d(p(t),R<rsub|t>)
  </equation*>

  Using our position and our orientation (given by <math|R<rsub|t>>) we
  calculate the atmospheric drag.

  We then obtain the instaneous change in angular momentum as the total of
  the torques:

  <\equation*>
    <frac|\<partial\>L|\<partial\>t>\<assign\>\<tau\><rsub|magnetic>+\<tau\><rsub|drag>
  </equation*>

  We then ``integrate'' by assuming this to be linear over our time-step:

  <\equation*>
    L<rsub|t+\<Delta\>t>\<assign\>(\<Delta\>t)<left|(><frac|\<partial\>L|\<partial\>t><right|)>+L<rsub|t>
  </equation*>

  <section|Updating <math|R<rsub|t>> to <math|R<rsub|t+\<Delta\>t>>>

  We first obtain the instantaneous angular velocity:

  <\equation*>
    \<omega\>\<assign\>I<rsup|-1>\<cdot\>L
  </equation*>

  We are not really interested in <math|\<omega\>>, but rather
  <math|W(\<omega\>)>, the angular velocity tensor. \ This is given by:

  <\equation*>
    W(\<langle\>x,y,z\<rangle\>)\<assign\><matrix|<tformat|<table|<row|<cell|0>|<cell|-z>|<cell|y>>|<row|<cell|z>|<cell|0>|<cell|-x>>|<row|<cell|-y>|<cell|x>|<cell|0>>>>>
  </equation*>

  There are two ways to proceed, and I am not entirely sure which is best:

  <\enumerate-Roman>
    <item>The first approach is to approximate the change in angle as
    <math|(\<Delta\>t)(W(\<omega\>))>, add to the old angle, and then apply
    the <with|font-shape|italic|Grahm-Schmidt> algorithm (denoted
    <math|GS(\<cdot\>)>) to orthonormalize the result thus obtaining a new
    rotation matrix

    <\equation*>
      R<rsub|t+\<Delta\>t>\<approx\>GS(R<rsub|t>+(\<Delta\>t)(W(\<omega\>)))
    </equation*>

    <item>The second approach is to <em|exponentiate>. \ Approximate the
    angular velocity (rank 2) tensor <math|W> as constant for the duration of
    <math|\<Delta\>t>. In this case we have
    <math|<wide|A|\<dot\>>(t)=W\<cdot\>A(t)> where <math|A(t)> is the
    orientation resulting from the angular velocity. \ Assuming the initial
    condition that <math|A(0)=\<b-I\>> (the <math|3\<times\>3> identity
    matrix), this yields as a solution:

    <\equation*>
      A(\<Delta\>t)\<assign\>EXP(\<Delta\>t\<cdot\>W)
    </equation*>

    Where <math|EXP(\<cdot\>)> is matrix exponentiation. \ Skew symmetric
    matrices like rank 2 tensors have a closed form for their matrix
    exponential, which I have lifted off of wikipedia's page on rotation
    matrices. \ Let <math|\<Delta\>t\<cdot\>\<theta\>=\|\<Delta\>t\<cdot\>\<omega\>\|>
    and <math|<wide|\<omega\>|^>=<frac|\<Delta\>t\<cdot\>\<omega\>|\|\<Delta\>t\<cdot\>\<omega\>\|>=\<langle\>x,y,z\<rangle\>>
    in

    <\equation*>
      EXP(\<Delta\>t\<cdot\>W(\<omega\>))\<assign\><matrix|<tformat|<table|<row|<cell|<tformat|<table|<row|<cell|2
      (x<rsup|2> - 1) s<rsup|2> + 1>|<cell|2 x y s<rsup|2> - 2 z c s>|<cell|2
      x z s<rsup|2> + 2 y c s>>|<row|<cell|2 x y s<rsup|2> + 2 z c s>|<cell|2
      (y<rsup|2> - 1) s<rsup|2> + 1>|<cell|2 y z s<rsup|2> - 2 x c
      s>>|<row|<cell|2 x z s<rsup|2> - 2 y c s>|<cell|2 y z s<rsup|2> + 2 x c
      s>|<cell|2 (z<rsup|2> - 1) s<rsup|2> + 1>>>>>>>>>
    </equation*>

    \ where <math|c=cos(\<Delta\>t\<cdot\>\<theta\>/2)> and
    <math|s=sin(\<Delta\>t\<cdot\>\<theta\>/2)>

    This gives us:

    <\equation*>
      R<rsub|t+\<Delta\>t>\<assign\>EXP(\<Delta\>t\<cdot\>
      W(\<omega\>))\<cdot\>R<rsub|t>
    </equation*>

    The first approach is sort of a first order approximation of this
    approach.
  </enumerate-Roman>
</body>

<\initial>
  <\collection>
    <associate|language|american>
    <associate|page-type|letter>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|1>>
    <associate|auto-2|<tuple|2|1>>
    <associate|auto-3|<tuple|3|1>>
    <associate|auto-4|<tuple|4|1>>
    <associate|auto-5|<tuple|5|2>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|State
      Variables> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Constants>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Other
      Functions> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Updating
      <with|mode|<quote|math>|L<rsub|t>> to
      <with|mode|<quote|math>|L<rsub|t+\<Delta\>t>>>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Updating
      <with|mode|<quote|math>|R<rsub|t>> to
      <with|mode|<quote|math>|R<rsub|t+\<Delta\>t>>>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>