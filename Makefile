OCAMLC=ocamlc -g -bin-annot
OCAMLOPT=ocamlopt -bin-annot
OCAMLMKLIB=ocamlmklib
OCAMLDEP=ocamldep
CFLAGS=-O -D_XOPEN_SOURCE=500 -DCAML_NAME_SPACE

C_OBJS=engine.o
CAML_OBJS=agrep.cmo

all: libagrep.a agrep.cma agrep.cmxa

agrep.cma: $(CAML_OBJS)
	$(OCAMLMKLIB) -o agrep $(CAML_OBJS)

agrep.cmxa: $(CAML_OBJS:.cmo=.cmx)
	$(OCAMLMKLIB) -o agrep $(CAML_OBJS:.cmo=.cmx)

libagrep.a: $(C_OBJS)
	$(OCAMLMKLIB) -o agrep $(C_OBJS)

install:
	ocamlfind install agrep META \
	  agrep.mli agrep.cmi agrep.cmti agrep.cma agrep.cmxa agrep.a \
          $(wildcard dllagrep.*)

uninstall:
	ocamlfind remove agrep

testagrep: testagrep.ml agrep.cma libagrep.a
	$(OCAMLC) -I . -custom -o $@ agrep.cma testagrep.ml

clean::
	rm -f testagrep

.SUFFIXES: .ml .mli .cmo .cmi .cmx

.mli.cmi:
	$(OCAMLC) -c $<

.ml.cmo:
	$(OCAMLC) -c $<

.ml.cmx:
	$(OCAMLOPT) -c $<

.c.o:
	$(OCAMLC) -ccopt "$(CFLAGS)" -c $<

clean::
	rm -f *.cm* *.o *.a *.so

depend:
	$(OCAMLDEP) *.ml *.mli > .depend

engine.o: skeleton.h

include .depend
