c	elaz returns the elevation and azimuth of a given vector
	subroutine elaz(v,el,az)
	dimension v(3)
	rd=180./3.14159265
	u=v(3)/sqrt(v(1)**2+v(2)**2+v(3)**2)
	if(abs(u).gt.1.) u=sign(.999999,u)
	el=asin(u)*rd
	az=0.
	if(v(1).eq.0..and.v(2).eq.0.) go to 3
	u=v(1)/sqrt(v(1)**2+v(2)**2)
	if(abs(u).gt.1.) u=sign(.999999,u)
	az=amod(sign(acos(u)*rd,v(2))+720.,360.)
3	return
	end
