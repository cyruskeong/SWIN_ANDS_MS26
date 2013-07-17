<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:rif="http://ands.org.au/standards/rif-cs/registryObjects"
    xmlns:my="http://schemas.microsoft.com/office/infopath/2003/myXSD/2011-09-26T07:17:47"
    exclude-result-prefixes="xsl">
    
    <xsl:variable name="originating_mytardis" select="'caousMyTardis'"/>
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        
        <xsl:variable name="allRecords" select="."/>
        <xsl:for-each select="harvest/oai:OAI-PMH/oai:ListRecords/oai:record">
            <xsl:if test="oai:metadata/rif:registryObjects/rif:registryObject/rif:collection">
                
                <xsl:variable name="filename" select="replace(oai:header/oai:identifier/text(),'/','_')"/>
                  
                <xsl:result-document method="xml" href="{$originating_mytardis}_{$filename}.xml">
                    <my:RedboxCollection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                        xmlns:xd="http://schemas.microsoft.com/office/infopath/2003" xml:lang="en-au">
                        
                        <!-- experiment template -->
                        <xsl:call-template name="mytardisExperimentTemplate">
                            <xsl:with-param name="rifcs_collection_record">
                                <xsl:copy-of select="."/>
                            </xsl:with-param>
                        </xsl:call-template>
                        
                        <my:Creators>
                            <xsl:for-each
                                select="distinct-values(.//oai:metadata/rif:registryObjects/rif:registryObject/rif:collection/rif:relatedObject/rif:key/text())">
                                <!-- user template-->
                                <xsl:call-template name="mytardisUserTemplate">
                                    <xsl:with-param name="userKey">
                                        <xsl:copy-of select="."/>
                                    </xsl:with-param>
                                    <xsl:with-param name="allRecords">
                                        <xsl:copy-of select="$allRecords"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                                
                            </xsl:for-each>
                        </my:Creators>
                        
                    </my:RedboxCollection>
                </xsl:result-document>
            </xsl:if>
            
        </xsl:for-each>
        
    </xsl:template>
    
    <xsl:template name="mytardisUserTemplate">
        <xsl:param name="userKey"/>
        <xsl:param name="allRecords"/>
        <my:Creator>
            <my:CreatorGiven>
                <xsl:value-of
                    select="$allRecords//oai:record/oai:metadata/rif:registryObjects/rif:registryObject[rif:key=$userKey]/rif:party[@type='person']/rif:name[@type='primary']/rif:namePart[@type='given']"
                />
            </my:CreatorGiven>
            
            <my:CreatorFamily>
                <xsl:value-of
                    select="$allRecords//oai:record/oai:metadata/rif:registryObjects/rif:registryObject[rif:key=$userKey]/rif:party[@type='person']/rif:name[@type='primary']/rif:namePart[@type='family']"
                />
            </my:CreatorFamily>
            
        </my:Creator>
        
    </xsl:template>
    
    <xsl:template name="mytardisExperimentTemplate">
        <xsl:param name="rifcs_collection_record"/>
        
        <my:Title>
            <xsl:value-of
                select="$rifcs_collection_record//oai:metadata/rif:registryObjects/rif:registryObject/rif:collection/rif:name[@type='primary']/rif:namePart"
            />
        </my:Title>
        
        <my:Type>
            <xsl:value-of
                select="$rifcs_collection_record//oai:metadata/rif:registryObjects/rif:registryObject/rif:collection/@type"
            />
        </my:Type> 
        
        <my:DateCreated>
            <xsl:value-of select="$rifcs_collection_record//oai:header/oai:datestamp"/>
        </my:DateCreated>
        
        <!--dont think mytardis will export date modified! -->
        <my:DateModified> </my:DateModified>
        
        <my:Description>
            <xsl:value-of
                select="$rifcs_collection_record//oai:metadata/rif:registryObjects/rif:registryObject/rif:collection/rif:description"
            />
        </my:Description>
        
    </xsl:template>
    
    
    
</xsl:stylesheet>