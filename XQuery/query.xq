(: 5 :)
(: doc("db/bib/bib.xml")/bib/book/author/last :)

(: 6 :)
(: for $book in doc("db/bib/bib.xml")/bib/book
for $author in $book/author
for $title in $book/title
return <ksiazka>
  {$author}
  {$title}
</ksiazka> :)

(: 7 :)
(: for $book in doc("db/bib/bib.xml")/bib/book
for $author in $book/author
for $title in $book/title
return <ksiazka>
  <autor>
    {$author/last/text()}{$author/first/text()}
  </autor>
  <tytul>
    {$title/text()}
  </tytul>
</ksiazka> :)

(: 8 :)
(: for $book in doc("db/bib/bib.xml")/bib/book
for $author in $book/author
for $title in $book/title
return <ksiazka>
  <autor>
    {$author/last/text() || ' ' || $author/first/text()}
  </autor>
  <tytul>
    {$title/text()}
  </tytul>
</ksiazka> :)

(: 9 :)
(: let $result := (
  for $book in doc("db/bib/bib.xml")/bib/book
  for $author in $book/author
  for $title in $book/title
  return <ksiazka>
    <autor>
      {$author/last/text() || ' ' || $author/first/text()}
    </autor>
    <tytul>
      {$title/text()}
    </tytul>
  </ksiazka>
)
return <wynik>
  {$result}
</wynik> :)

(: 10 :)
(: return <imiona>
  {
    for $author in doc("db/bib/bib.xml")/bib/book[title='Data on the Web']/author
    return <imie>{$author/first/text()}</imie>
  }
</imiona> :)

(: 11 :)
(: let $book := doc("db/bib/bib.xml")/bib/book[title='Data on the Web']
return <DataOnTheWeb>
  {$book}
</DataOnTheWeb> :)

(: 12 :)
(: for $book in doc("db/bib/bib.xml")/bib/book
where contains($book/title, 'Data')
return <Data>
  {
    for $author in $book/author
    return <nazwisko>
      {$author/last/text()}
    </nazwisko>
  }
</Data> :)

(: 13 :)
(: for $book in doc("db/bib/bib.xml")/bib/book
where contains($book/title, 'Data')
return <Data>
  {$book/title}
  {
    for $author in $book/author
    return <nazwisko>
      {$author/last/text()}
    </nazwisko>
  }
</Data> :)

(: 14 :)
(: for $book in doc("db/bib/bib.xml")/bib/book
where count($book/author) < 2
return <Data>
  {$book/title}
</Data> :)

(: 15 :)
(: for $book in doc("db/bib/bib.xml")/bib/book
return <ksiazka>
  {$book/title}
  <autorow>
    {count($book/author)}
  </autorow>
</ksiazka> :)

(: 16 :)
(: <przedział>
  {min(doc("db/bib/bib.xml")/bib/book/@year) || ' - ' || max(doc("db/bib/bib.xml")/bib/book/@year)}
</przedział> :)

(: 17 :)
(: <różnica>
  {max(doc("db/bib/bib.xml")/bib/book/price) - min(doc("db/bib/bib.xml")/bib/book/price)}
</różnica> :)

(: 18 :)
(: <najtańsze>
  {
    for $book in doc("db/bib/bib.xml")/bib/book
    where $book/price = (min(doc("db/bib/bib.xml")/bib/book/price))
    return <najtańsza>
      {$book/title}
      {$book/author}
    </najtańsza>
  }
</najtańsze> :)

(: 19 :)
(: for $author-last in distinct-values(doc("db/bib/bib.xml")/bib/book/author/last)
return <autor>
  {$author-last}
  {doc("db/bib/bib.xml")/bib/book[author/last=$author-last]/title}
</autor> :)

(: 20 :)
(: let $plays := collection('db/shakespeare')/PLAY
return <wynik>
  {
    for $play in $plays
    return $play/TITLE
  }
</wynik> :)

(: 21 :)
(: let $plays := collection('db/shakespeare')/PLAY
for $play in $plays
where some $line in $play//LINE satisfies contains($line, "or not to be")
return $play/TITLE :)

(: 22 :)
let $plays := collection('db/shakespeare')/PLAY
return <wynik>
  {
    for $play in $plays
    return <sztuka tytul="{$play/TITLE/text()}">
      <postaci>
        {count($play//PERSONA)}
      </postaci>
      <aktow>
        {count($play//ACT)}
      </aktow>
      <scen>
        {count($play//SCENE)}
      </scen>
    </sztuka>
  }
</wynik>