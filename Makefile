opendatalink.pdf: opendatalink.md
	pandoc -t beamer -o $@ $<
