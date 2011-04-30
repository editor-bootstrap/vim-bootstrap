<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text"/>

<xsl:template match="/">
	<xsl:text>* Rspec Results&#10;</xsl:text>
	<xsl:text>* Parsed with xsltproc (http://www.xmlsoft.org/XSLT/xsltproc2.html)&#10;</xsl:text>
	<xsl:text> &#10;</xsl:text>
	<xsl:apply-templates select="html/body/div[@class='rspec-report']/div[@class='results']"/>
</xsl:template>	

<xsl:template match="div[@class='rspec-report']">
	<xsl:apply-templates/>
</xsl:template>	

<xsl:template match="div[@class='example_group']">
	<xsl:text>[</xsl:text><xsl:value-of select="dl/dt"/><xsl:text>]</xsl:text>
	<xsl:text>&#10;</xsl:text>
	<xsl:apply-templates select="dl/dd"/>
	<xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="dd[@class='spec passed']">
	<xsl:text>+ </xsl:text>
	<xsl:value-of select="span"/>
	<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="dd[@class='spec failed']">
	<xsl:text>- </xsl:text>
	<xsl:value-of select="span"/>
	<xsl:text>&#10;</xsl:text>
	<xsl:apply-templates select="div"/>
</xsl:template>

<xsl:template match="dd[@class='spec not_implemented']">
	<xsl:text># </xsl:text>
	<xsl:value-of select="span"/>
	<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="dd[@class='spec failed']/div[@class='failure']">
	<xsl:text>  </xsl:text><xsl:value-of select="div[@class='message']/pre"/>
	<xsl:text>&#10;</xsl:text>
	<xsl:text>  </xsl:text><xsl:value-of select="div[@class='backtrace']/pre"/>
	<xsl:text>&#10;</xsl:text>
	<xsl:apply-templates select="pre[@class='ruby']/code"/>
</xsl:template>

<xsl:template match="code">
	<xsl:value-of select="text()"/>
	<xsl:text>&#10;</xsl:text>
</xsl:template>

</xsl:stylesheet>
