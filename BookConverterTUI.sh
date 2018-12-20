#!/bin/bash

# This script converts a Markdown file into ODT, PDF, and EPUB

# Get information about book

whiptail --title "Welcome" --msgbox "This script will convert a Markdown file into ODT, PDF, and EPUB documents. Hit OK to proceed." 8 78

MarkdownFile=$(whiptail --inputbox "Please enter the path to a Markdown file:" 8 78 example.md --title "Markdown File" 3>&1 1>&2 2>&3)

Title=$(whiptail --inputbox "Please enter the book's title:" 8 78 "Oliver Twist" --title "Book Title" 3>&1 1>&2 2>&3)

Penname=$(whiptail --inputbox "Please enter the author's name:" 8 78 "Charles Dickens" --title "Book Author" 3>&1 1>&2 2>&3)

Copyright=$(whiptail --inputbox "Please enter licence information:" 8 78 "Public Domain" --title "Book Licence" 3>&1 1>&2 2>&3)

LanguageCode=$(whiptail --inputbox "Please enter language code:" 8 78 en --title "Book Language" 3>&1 1>&2 2>&3)

TitlePlusName=$Penname-$Title
TitlePlusNameNoSpaces="$(echo "$TitlePlusName" | tr -d ' ')"
mkdir "$TitlePlusNameNoSpaces"

# Create metadata file
# Do not remove the whitespace in echo

TitleMetadata="$Title-metadata.txt"
touch "$TitlePlusNameNoSpaces/$TitleMetadata"
echo "---






..." > "$TitlePlusNameNoSpaces/$TitleMetadata"

whiptail --title "DOCX?" --yesno "By default, this script exports to the free OpenDocument standard. Do you want to export your book as DOCX (not recommended)?" 8 78

DOCXCheck=$?

whiptail --title "Cover Image" --yesno "Do you have a cover image for your book?" 8 78

CheckForCover=$?

if [[ $CheckForCover == 0 ]]; then
  BookCoverPath=$(whiptail --inputbox "Please enter the file path for the cover image:" 8 78 image.jpg --title "Cover Image Path" 3>&1 1>&2 2>&3)

  # Add cover image to $TitleMetadata

  sed -i "7s/.*/cover-image: $BookCoverPath/" "$TitlePlusNameNoSpaces/$TitleMetadata"
fi

# if (whiptail --title "Cover Image" --yesno "Do you have a cover image for your book?" 8 78); then
#    BookCoverPath=$(whiptail --inputbox "Please enter the file path for the cover image:" 8 78 en --title "Cover Image Path" 3>&1 1>&2 2>&3)

    # Add cover image to $TitleMetadata

#    sed -i "7s/.*/cover-image: $BookCoverPath/" "$TitlePlusNameNoSpaces/$TitleMetadata"
#else
#fi

# Add date to $TitleMetadata
# Uses British date format

CurrentDate="$(date +%d" "%B" "%Y)"

sed -i "5s/.*/date: $CurrentDate/" "$TitlePlusNameNoSpaces/$TitleMetadata"

# Add user-input to $TitleMetadata

sed -i "2s/.*/title: $Title/" "$TitlePlusNameNoSpaces/$TitleMetadata"
sed -i "3s/.*/author: $Penname/" "$TitlePlusNameNoSpaces/$TitleMetadata"
sed -i "4s/.*/rights: $Copyright/" "$TitlePlusNameNoSpaces/$TitleMetadata"
sed -i "6s/.*/lang: $LanguageCode/" "$TitlePlusNameNoSpaces/$TitleMetadata"

# Convert MarkdownFile to other formats

pandoc "$MarkdownFile" --pdf-engine=pdflatex -o "$TitlePlusNameNoSpaces/$TitlePlusNameNoSpaces.pdf" --table-of-contents
pandoc -s -f markdown -t odt -o "$TitlePlusNameNoSpaces/$TitlePlusNameNoSpaces.odt" "$MarkdownFile"
pandoc -s -f markdown -t epub -o "$TitlePlusNameNoSpaces/$TitlePlusNameNoSpaces.epub" "$TitlePlusNameNoSpaces/$TitleMetadata" "$MarkdownFile" --table-of-contents

if [[ $DOCXCheck == 0 ]]; then
  pandoc -s -f markdown -t docx -o "$TitlePlusNameNoSpaces/$TitlePlusNameNoSpaces.docx" "$MarkdownFile"
  mat "$TitlePlusNameNoSpaces/$TitlePlusNameNoSpaces.odt"
fi

# Strip metadata from odt

mat "$TitlePlusNameNoSpaces/$TitlePlusNameNoSpaces.odt"

# Remove metadata file because it is no longer needed

rm "$TitlePlusNameNoSpaces/$TitleMetadata"
