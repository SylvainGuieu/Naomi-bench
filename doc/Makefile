
# Makefile
# 
# Converts Markdown to other formats (HTML, PDF, DOCX, RTF, ODT, EPUB) using Pandoc
# And convert Markdown -Pweave *.pmd file using pwave than Pandoc
#
# Run "make" (or "make all") to convert to pdf and html
#
# Run "make clean" to delete converted files
# Or run for individual formats
# make pdf
# make html
# make epub
# make md # if the source are *.pmd file 
# make rtf
# make docx

# Convert all files in this directory that have a .md or a .pmd suffix
# The converted files will be in the $(OUTPUT) directory. 

SOURCE= .
OUTPUT= output

RM=/bin/rm

PANDOC=/Users/guieus/anaconda3/bin/pandoc
PWEAVE=/Users/guieus/anaconda3/bin/pweave

PANDOC_OPTIONS=--smart --standalone
PWEAVE_OPTIONS=-f pandoc

PANDOC_HTML_OPTIONS=--to html5 --css /Users/guieus/src/pandoc.css
PANDOC_PDF_OPTIONS=
PANDOC_DOCX_OPTIONS=
PANDOC_RTF_OPTIONS=
PANDOC_ODT_OPTIONS=
PANDOC_EPUB_OPTIONS=--to epub3

SOURCE_PMD := $(wildcard $(SOURCE)/*.pmd)

SOURCE_MD := $(wildcard $(SOURCE)/*.md)

ALL_TARGET_PMD= $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_PMD:.pmd=.md))  $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_PMD:.pmd=.html))  $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_PMD:.pmd=.pdf))

ALL_TARGET_MD= $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_MD:.md=.html))  $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_MD:.md=.pdf))

MD_TARGET_PMD=  $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_PMD:.pmd=.md))

PDF_TARGET_PMD=	 $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_PMD:.pmd=.md)) 	 $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_PMD:.pmd=.pdf)) 
	 
PDF_TARGET_MD=	 $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_MD:.md=.pdf))

HTML_TARGET_PMD=	 $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_PMD:.pmd=.md)) 	 $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_PMD:.pmd=.html)) 
	 
HTML_TARGET_MD=	 $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_MD:.md=.html))

RTF_TARGET_PMD=	 $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_PMD:.pmd=.md)) 	 $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_PMD:.pmd=.rtf)) 
	 
RTF_TARGET_MD=	 $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_MD:.md=.rtf))

DOCX_TARGET_PMD=	 $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_PMD:.pmd=.md)) 	 $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_PMD:.pmd=.docx)) 
	 
DOCX_TARGET_MD=	 $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_MD:.md=.docx))

EPUB_TARGET_PMD=	 $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_PMD:.pmd=.md)) 	 $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_PMD:.pmd=.epub)) 
	 
EPUB_TARGET_MD=	 $(subst $(SOURCE)/, $(OUTPUT)/, $(SOURCE_MD:.md=.epub))

# 
# Pattern-matching Rules
$(OUTPUT)/%.md : $(SOURCE)/%.pmd
	$(PWEAVE) $(PWEAVE_OPTIONS)  $< -o $@

$(OUTPUT)/%.html : $(SOURCE)/%.md
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_HTML_OPTIONS) -o $@ $<

$(OUTPUT)/%.pdf : $(SOURCE)/%.md
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_PDF_OPTIONS) -o $@ $<

$(OUTPUT)/%.docx : $(SOURCE)/%.md
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_DOCX_OPTIONS) -o $@ $<

$(OUTPUT)/%.rtf : $(SOURCE)/%.md
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_RTF_OPTIONS) -o $@ $<

$(OUTPUT)/%.odt : $(SOURCE)/%.md
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_ODT_OPTIONS) -o $@ $<

$(OUTPUT)/%.epub : $(SOURCE)/%.md
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_EPUB_OPTIONS) -o $@ $<

$(OUTPUT)/%.pdf : $(OUTPUT)/%.md
	cd $(OUTPUT); 	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_PDF_OPTIONS) -o $(@:$(OUTPUT)/%=%) $(<:$(OUTPUT)/%=%)

$(OUTPUT)/%.html : $(OUTPUT)/%.md
	cd $(OUTPUT); 	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_HTML_OPTIONS) -o $(@:$(OUTPUT)/%=%) $(<:$(OUTPUT)/%=%)

$(OUTPUT)/%.docx : $(OUTPUT)/%.md
	cd $(OUTPUT); 	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_DOCX_OPTIONS) -o $(@:$(OUTPUT)/%=%) $(<:$(OUTPUT)/%=%)

$(OUTPUT)/%.rtf : $(OUTPUT)/%.md
	cd $(OUTPUT); 	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_RTF_OPTIONS) -o $(@:$(OUTPUT)/%=%) $(<:$(OUTPUT)/%=%)

$(OUTPUT)/%.odt : $(OUTPUT)/%.md
	cd $(OUTPUT); 	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_ODT_OPTIONS) -o $(@:$(OUTPUT)/%=%) $(<:$(OUTPUT)/%=%)

$(OUTPUT)/%.epub : $(OUTPUT)/%.md
	cd $(OUTPUT); 	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_EPUB_OPTIONS) -o $(@:$(OUTPUT)/%=%) $(<:$(OUTPUT)/%=%)

# Targets and dependencies

.PHONY: all clean

all : $(ALL_TARGET_PMD) $(ALL_TARGET_MD)

md : $(MD_TARGET_PMD)

pdf : $(PDF_TARGET_PMD) $(PDF_TARGET_MD)

html : $(HTML_TARGET_PMD) $(HTML_TARGET_MD)

rtf : $(RTF_TARGET_PMD) $(RTF_TARGET_MD)

epub : $(EPUB_TARGET_PMD) $(EPUB_TARGET_MD)

docx : $(DOCX_TARGET_PMD) $(DOCX_TARGET_MD)

clean:
	- $(RM) -f $(OUTPUT)/*.html $(OUTPUT)/*.pdf $(OUTPUT)/*.docx $(OUTPUT)/*.rtf $(OUTPUT)/*.epub
	- $(RM) -rf $(OUTPUT)/figures 
	cmp -s $(SOURCE) $(OUTPUT); 	RETVAL=$$?; 	if [ $$RETVAL -eq 0 ]; then 				echo "Output is source"; 	else 			  $(RM) -f $(OUTPUT)/*.md; 	fi
