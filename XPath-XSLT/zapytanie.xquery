(:for $k in doc('file:///C:/Users/dawid/projects/INF-2sem-tpd/ztpd/ztpd-lab/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ[NAZWA/starts-with(., ../STOLICA/substring(., 1, 1))]:)
(:for $k in doc('file:///C:/Users/dawid/projects/INF-2sem-tpd/ztpd/ztpd-lab/XPath-XSLT/swiat.xml')//KRAJ:)
(:return <KRAJ>:)
(:    {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:31:)
(:for $k in doc('file:///C:/Users/dawid/projects/INF-2sem-tpd/ztpd/ztpd-lab/XPath-XSLT/zesp_prac.xml'):)
(:return $k:)

(:32:)
(:for $k in doc('file:///C:/Users/dawid/projects/INF-2sem-tpd/ztpd/ztpd-lab/XPath-XSLT/zesp_prac.xml'):)
(:return $k//NAZWISKO:)

(:33:)
(:for $k in doc('file:///C:/Users/dawid/projects/INF-2sem-tpd/ztpd/ztpd-lab/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW[NAZWA = 'SYSTEMY EKSPERCKIE']/PRACOWNICY/ROW/NAZWISKO/text():)
(:return $k:)

(:34:)
(:for $k in doc('file:///C:/Users/dawid/projects/INF-2sem-tpd/ztpd/ztpd-lab/XPath-XSLT/zesp_prac.xml')/count(/ZESPOLY/ROW[ID_ZESP = 10]/PRACOWNICY/ROW):)
(:return $k:)

(:35:)
(:for $k in doc('file:///C:/Users/dawid/projects/INF-2sem-tpd/ztpd/ztpd-lab/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW/PRACOWNICY/ROW[ID_SZEFA = 100]/NAZWISKO:)
(:return $k:)

(:36:)
let $k := doc('file:///C:/Users/dawid/projects/INF-2sem-tpd/ztpd/ztpd-lab/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW[PRACOWNICY/ROW/NAZWISKO = 'BRZEZINSKI']/PRACOWNICY/ROW
return sum($k/PLACA_POD)