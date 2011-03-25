all:
	$(MAKE) -C WMM all
	$(MAKE) -C archeology all

clean:
	$(MAKE) -C WMM clean
	$(MAKE) -C archeology clean
	
