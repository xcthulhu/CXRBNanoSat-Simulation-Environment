	dimension y(15),b(3),w(3),dw(3),v(3),ww(3),wxb(3)
	double precision t0
	character string*25
c	print *,"     tstart(MM/DD/YY HH:MM:SS)?"
c	read 101,string
c101 	format(A25)
c	call covert_date_to_julian(string,t0,ierr)
	print *,"     tstart (days)?"
	read(*,*) t0
	t1=t0
	print *,"     wheel rate in rpm (enter with + or - according to sign of dipole)"
	read(*,*) rpm
c1   	print *,"     zra,zdec? (if no change type two returns)"
1   	print *,"     zra,zdec? (if no change type 0,0)"
	read(*,*) zra1,zdec1
	if(zra1.eq.0..and.zdec1.eq.0.) go to 4
	zra=zra1
	zdec=zdec1
4	print *,"     duration of torque (seconds)?"
	read(*,*) tt
	dt=.1/1440.
	t2=t1+tt/86400.
	torque=43482.*dt/rpm
	y(1)=0.
	y(2)=0.
	call vector(zdec,zra,w)
	call mvec(0.,ww,ww)
	call avec(ww,w,ww)
	t=t1-dt
2   	t=t+dt
	if(t.gt.t2) go to 3
	if(t.lt.y(1).or.t.gt.y(2)) call orbel(t,y)
	call sasorb(y,t,dec,ra,rad,v,flat,flog,alt)
	tm=1975.24+t/365.25
	call geomag(tm,flat,flong,alt,ra,b,bmag)
	call cross(2,w,b,wxb)
	call mvec(torque,wxb,dw)
	call avec(w,dw,w)
	go to 2
3   	call elaz(w,dec,ra)
	dra=ra-zra
	ddec=dec-zdec
	print 100,t1,t,zra,zdec,ra,dec,dra,ddec
100 	format(" start=",f12.5/" stop=",f12.5/" zra1=",f7.2/" zdec1=",f7.2/" zra2=",f7.2/" zdec2=",f7.2/" dra=",f7.2/" ddec=",f7.2//)
	if(t.gt.t2) go to 1
	go to 2
	end
