opendatalink.pdf opendatalink.tex: opendatalink.md preamble.tex
	pandoc -t beamer -H preamble.tex -o $@ $<
