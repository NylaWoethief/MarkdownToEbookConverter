# MarkdownToEbookConverter

This BASH script is designed to quickly create an ebook from a Markdown file. It exports the file to PDF, EPUB, and ODT.

When it runs, it will ask for the following:

1. The path to a markdown file
2. The book's title
3. The author's name
4. Copyright information (eg. Creative Commons Attribution 4.0)
5. A language code (eg. en for English, es for Spanish, fr for French)
6. Whether you want a cover image.
	1. If you answer "no", no cover image is added.
	2. If you answer "yes", you will be prompted for the path to the image.

After all input is gathered, a new folder will be created with your new files inside it. The information entered by the user is used to add metadata and names to the files.

The folder and ebook files will follow the naming scheme of AuthorName-BookTitle with all the spaces stripped away.

# Required Software

* [MAT (Metadata Anonymisation Toolkit)](https://n0where.net/mat-metadata-anonymisation-toolkit)
* [pandoc](https://pandoc.org/)
* pdflatex

## Running

Before running the script for the first time, give `BookConverter.sh` or `TUIBookCOnverter.sh` executable privileges by typing `chmod +x BookConverter.sh` or `chmod +x TUIBookConverter.sh` in your terminal.

Type `./BookConverter.sh` to run the script and answer all of the prompts.

## Privacy Caution

PDFs created with this script contain metadata that includes your time-zone. If you need to keep your geographic region a secret, find a way to strip off the metadata or set your computer's time to UTC (Coordinated Universal Time).

MAT automatically strips metadata from ODT files created using this script.
