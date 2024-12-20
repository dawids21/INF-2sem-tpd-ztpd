<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/">
        <html>
            <head>
                <link href="zesp_prac.css" rel="stylesheet" type="text/css"/>
            </head>
            <body>
                <h1>ZESPOŁY:</h1>
                <ol>
                    <!--                    <xsl:for-each select="ZESPOLY/ROW">-->
                    <!--                        <li>-->
                    <!--                            <xsl:value-of select="NAZWA"/>-->
                    <!--                        </li>-->
                    <!--                    </xsl:for-each>-->
                    <xsl:apply-templates select="ZESPOLY/ROW" mode="list"/>
                </ol>
                <xsl:apply-templates select="ZESPOLY/ROW" mode="details"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="/ZESPOLY/ROW" mode="list">
        <li>
            <a href="#{ID_ZESP}">
                <xsl:value-of select="NAZWA"/>
            </a>
        </li>
    </xsl:template>
    <xsl:template match="/ZESPOLY/ROW" mode="details">
        <h2 id="{ID_ZESP}">
            NAZWA:
            <xsl:value-of select="NAZWA"/>
            <br/>
            ADRES:
            <xsl:value-of select="ADRES"/>
        </h2>
        <xsl:choose>
            <xsl:when test="count(PRACOWNICY/ROW) > 0">
                <table>
                    <tr>
                        <th>Nazwisko</th>
                        <th>Etat</th>
                        <th>Zatrudniony</th>
                        <th>Placa pod.</th>
                        <th>Id szefa</th>
                    </tr>
                    <xsl:apply-templates select="PRACOWNICY/ROW">
                        <xsl:sort select="NAZWISKO"/>
                    </xsl:apply-templates>
                </table>
            </xsl:when>
        </xsl:choose>
        Liczba pracowników: <xsl:value-of select="count(PRACOWNICY/ROW)"/>
    </xsl:template>
    <xsl:template match="/ZESPOLY/ROW/PRACOWNICY/ROW">
        <tr>
            <td>
                <xsl:value-of select="NAZWISKO"/>
            </td>
            <td>
                <xsl:value-of select="ETAT"/>
            </td>
            <td>
                <xsl:value-of select="ZATRUDNIONY"/>
            </td>
            <td>
                <xsl:value-of select="PLACA_POD"/>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="ID_SZEFA">
                        <xsl:value-of select="//ROW/PRACOWNICY/ROW[ID_PRAC = current()/ID_SZEFA]/NAZWISKO"/>
                    </xsl:when>
                    <xsl:otherwise>brak</xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>