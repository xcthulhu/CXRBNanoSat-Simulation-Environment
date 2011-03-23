c rump orbel for CXBN 3/23/2011 jpd
c
	subroutine orbel( t, y )
	real y(15)
c y(1)=epoch
	y(1) = 0.0
c y(2)=expiration date
	y(2) = 1e20
c y(3)=mean anomaly at epoch in degrees from perigee
	y(3) = 0.0
c y(4)=inertial period at epoch in seconds
	y(4) = 5668.
c y(5)=change of inertial period in sec/(orbit)^2
	y(5) = 0.0
c y(6)=eccentricity at epoch
	y(6) = 0.001
c y(7)=change of eccentricity per day
	y(7) = 0.0
c y(8)=argument of perigee at epoch in degrees
	y(8) = 0.0
c y(9)=change of the argument of perigee in degrees per day
	y(9) = 0.0
	y(10) = 0.0
c y(11)=right ascension of the ascending node in degrees per day
	y(11) = 0.0
c y(12)=change of the ascending node in degrees per day
	y(12) = 0.0
	y(13) = 0.0
c y(14)=inclination in degrees
	y(14) = 50.
c y(15)=semimajor axis in kilometers
	y(15) = 6878.
	return
	end

	
