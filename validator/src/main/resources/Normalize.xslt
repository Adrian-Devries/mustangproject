<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0">
	<xsl:output method="xml"
	            indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:template match="xsl:stylesheet">
		<xsl:element name="{name()}">
			<xsl:copy-of select="//namespace::*"/>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="xsl:function[@as='xs:boolean' or @as='xs:decimal' or @as='xs:integer' or @as='xs:string']/xsl:value-of">
		<xsl:element name="xsl:sequence">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="xsl:value-of[matches(@select,'if\s?\([^()]+ eq fn:true\(\)\)')]/@select">
		<xsl:attribute name="select">
			<xsl:value-of select="replace(.,'(if\s?\()([^()]+)( eq fn:true\(\)\))','$1xs:boolean($2)$3')"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsl:for-each[xsl:for-each[not(child::node())] and count(child::node()) eq 1]"/>
	<xsl:template match="svrl:text|xsl:text">
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@*"/>
			<xsl:value-of select="normalize-space(.)"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="//comment()">
		<xsl:choose>
			<xsl:when test="matches(.,'^[ \t]*\S.*$','s')">
				<xsl:comment>
					<xsl:value-of select="concat(' ',normalize-space(.),' ')"/>
				</xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="@*">
		<xsl:attribute name="{name()}">
			<xsl:value-of select="normalize-space(.)"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="/|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
