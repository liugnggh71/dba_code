<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:function name="functx:if-absent" as="item()*" xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="item()*"/>
        <xsl:param name="value" as="item()*"/>

        <xsl:sequence
            select="
                if (exists($arg))
                then
                    $arg
                else
                    $value
                "/>

    </xsl:function>

    <xsl:function name="functx:replace-multi" as="xs:string?" xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="changeFrom" as="xs:string*"/>
        <xsl:param name="changeTo" as="xs:string*"/>

        <xsl:sequence
            select="
                if (count($changeFrom) > 0)
                then
                    functx:replace-multi(
                    replace($arg, $changeFrom[1],
                    functx:if-absent($changeTo[1], '')),
                    $changeFrom[position() > 1],
                    $changeTo[position() > 1])
                else
                    $arg
                "/>

    </xsl:function>

    <xsl:function name="functx:repeat-string" as="xs:string" xmlns:functx="http://www.functx.com">
        <xsl:param name="stringToRepeat" as="xs:string?"/>
        <xsl:param name="count" as="xs:integer"/>

        <xsl:sequence
            select="
                string-join((for $i in 1 to $count
                return
                    $stringToRepeat),
                '')
                "/>

    </xsl:function>

    <xsl:function name="functx:pad-string-to-length" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="stringToPad" as="xs:string?"/>
        <xsl:param name="padChar" as="xs:string"/>
        <xsl:param name="length" as="xs:integer"/>

        <xsl:sequence
            select="
                substring(
                string-join(
                ($stringToPad,
                for $i in (1 to $length)
                return
                    $padChar)
                , '')
                , 1, $length)
                "/>

    </xsl:function>

    <xsl:function name="functx:depth-of-node" as="xs:integer"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="node" as="node()?"/>
        
        <xsl:sequence select="
            count($node/ancestor-or-self::node())
            "/>
        
    </xsl:function>
    
    <xsl:function name="functx:capitalize-first" as="xs:string?"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        
        <xsl:sequence select="
            concat(upper-case(substring($arg,1,1)),
            substring($arg,2))
            "/>
        
    </xsl:function>
    
    <xsl:variable name="v_newline">
        <xsl:text>&#xa;</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="output_dir">
        <xsl:text>./output/</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="day_md">
        <xsl:value-of select="$output_dir"/>
        
        <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
        <xsl:text>.md</xsl:text>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:result-document href="{$day_md}" method="text">
            <xsl:text># </xsl:text>
            <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
            <xsl:apply-templates select="//atos"/>
            <xsl:apply-templates select="//math"/>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="atos|math">
        <xsl:value-of select="$v_newline"/>
        <xsl:text># </xsl:text>
        <xsl:value-of select="functx:capitalize-first(name())"/>
        <xsl:value-of select="$v_newline"/>
        <xsl:value-of select="functx:repeat-string( '!', string-length(name()))"/>
        <xsl:value-of select="$v_newline"/>
        <xsl:for-each select="*">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
    </xsl:template>
        
    <xsl:template match="emails|tickets|projects|books|problems">
        <xsl:value-of select="$v_newline"/>
        <xsl:text>## </xsl:text>
        <xsl:value-of select="functx:capitalize-first(name())"/>
        <xsl:value-of select="$v_newline"/>
        <xsl:value-of select="functx:repeat-string( '+', string-length(name()))"/>
        <xsl:value-of select="$v_newline"/>
        <xsl:for-each select="*">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
    </xsl:template>    
    
    <xsl:template match="email">
        <xsl:value-of select="$v_newline"/>
        <xsl:text>### </xsl:text>
        <xsl:value-of select="@type"/>
        <xsl:value-of select="$v_newline"/>
        <xsl:value-of select="functx:repeat-string( '=', string-length(name()))"/>
        <xsl:value-of select="$v_newline"/>
        <xsl:value-of select="$v_newline"/>
        <xsl:value-of select="."/>
    </xsl:template>    
    
    <xsl:template match="ticket">
        <xsl:value-of select="$v_newline"/>
        <xsl:text>### </xsl:text>
        <xsl:value-of select="@vendor"/>
    </xsl:template>    
    
    <xsl:template match="project">
        <xsl:value-of select="$v_newline"/>
        <xsl:text>### 1. </xsl:text>
        <xsl:value-of select="@name"/>
    </xsl:template>    

</xsl:stylesheet>
