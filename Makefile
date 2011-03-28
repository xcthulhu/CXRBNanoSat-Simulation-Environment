all:
	$(MAKE) -C WMM all
	$(MAKE) -C archeology all
	$(MAKE) -C documentation all

clean:
	$(MAKE) -C WMM clean
	$(MAKE) -C archeology clean
	$(MAKE) -C documentation clean
	
