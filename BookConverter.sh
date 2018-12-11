#!/bin/bash

# This script converts a Markdown file into ODT, PDF, RTF, and EPUB

# Get information about book

Yes='[Yy][Ee]*[Ss]*'
No='[Nn][Oo]*'

read -p "Please enter path to Markdown file: " MarkdownFile
read -p "Please enter the book's title: " Title
read -p "Please enter author name: " Penname
read -p "Please type copyright information (eg. Creative Commons Attribution 4.0): " Copyright
read -p "Please type language code (eg. en for English, es for Spanish, fr for French): " LanguageCode
read -p "Do you have a cover image? (YES/NO): " CheckForCover

echo "You entered:
Markdown file: $MarkdownFile
Title: $Title
Name: $Penname
Copyright: $Copyright
Language: $LanguageCode
Cover Image: $CheckForCover
"

TitlePlusName=$Penname-$Title
TitlePlusNameNoSpaces="$(echo $TitlePlusName | tr -d ' ')"
mkdir $TitlePlusNameNoSpaces

# Create metadata file
# Do not remove the whitespace in echo

TitleMetadata="$Title-metadata.txt"
touch "$TitlePlusNameNoSpaces/$TitleMetadata"
echo "---






..." > "$TitlePlusNameNoSpaces/$TitleMetadata"


CoverAnswered="False"

while [[ $CoverAnswered == "False" ]]; do
  if [[ $CheckForCover == $Yes ]]; then
    read -p "Please type file path for cover image: " BookCoverPath
    CoverAnswered="True"

    # Add cover image to $TitleMetadata

    sed -i "7s/.*/cover-image: $BookCoverPath/" "$TitlePlusNameNoSpaces/$TitleMetadata"

    # Strip cover image metadata

    mat $BookCoverPath

  elif [[ $CheckForCover == $No ]]; then
    CoverAnswered="True"
  else read -p "I did not understand your answer. Do you have a cover image? (YES/NO): " CheckForCover
  fi
done

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

pandoc $MarkdownFile --pdf-engine=pdflatex -o "$TitlePlusNameNoSpaces/$TitlePlusNameNoSpaces.pdf" --table-of-contents
pandoc -s -f markdown -t odt -o "$TitlePlusNameNoSpaces/$TitlePlusNameNoSpaces.odt" $MarkdownFile
pandoc -s -f markdown -t epub -o "$TitlePlusNameNoSpaces/$TitlePlusNameNoSpaces.epub" "$TitlePlusNameNoSpaces/$TitleMetadata" $MarkdownFile --table-of-contents
pandoc -s -f markdown -t rtf -o "$TitlePlusNameNoSpaces/$TitlePlusNameNoSpaces.rtf" $MarkdownFile

# Strip metadata from odt

mat "$TitlePlusNameNoSpaces/$TitlePlusNameNoSpaces.odt"

# Remove metadata file because it is no longer needed

rm "$TitlePlusNameNoSpaces/$TitleMetadata"
