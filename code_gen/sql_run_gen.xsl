<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:axi="http://www.w3.org/1999/XSL/TransformAlias" xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:output indent="yes" method="xml"/>

    <xsl:namespace-alias stylesheet-prefix="axi" result-prefix="xi"/>

    <xsl:variable name="new_line">
        <xsl:text>&#xa;</xsl:text>
    </xsl:variable>
    <xsl:variable name="set_sql_gen"><![CDATA[set echo off
set heading off
set feedback off
set sqlprompt ""
set linesize 300
set pagesize 50000
set termout off
set trimspool on
]]> </xsl:variable>
    
    <xsl:variable name="cdb_pdb_set_gen"><![CDATA[
. ${HOME}/${CDB}.env
sqlplus / as sysdba << EOF
alter session set container=${PDB};
host hostname
DEFINE _CONNECT_IDENTIFIER
show pdbs
EOC
]]></xsl:variable>
    
    <xsl:variable name="shebang_line">
        <xsl:text>#!/bin/sh </xsl:text>
        <xsl:value-of select="$new_line"/>
    </xsl:variable>

    <xsl:variable name="x_gen_output_dir">
        <xsl:value-of select="/sql_runs/out_dir"/>
    </xsl:variable>

    <xsl:variable name="x_cdb_source">
        <xsl:value-of select="//sql_run[1]/pars/par[@type = 'CDB_source']"/>
    </xsl:variable>

    <xsl:variable name="x_pdb_option">
        <xsl:value-of select="//sql_run[1]/pars/par[@type = 'PDB_optional']"/>
    </xsl:variable>
    
    <xsl:variable name="x_min_par">
        <xsl:value-of select="//sql_run[1]/pars/@min"/>
    </xsl:variable>

    <xsl:variable name="x_pdb_option_par">
        <xsl:value-of select="//sql_run[1]/pars/@pdb_position"/>
    </xsl:variable>
    
    <xsl:variable name="x_spool">
        <xsl:value-of select="//sql_run[1]/sql_run_option/spool/text()"/>
    </xsl:variable>
    
    <xsl:variable name="x_spool_prefix">
        <xsl:value-of select="//sql_run[1]/sql_run_option/spool/@prefix"/>
    </xsl:variable>

    <xsl:variable name="x_spool_suffix">
        <xsl:value-of select="//sql_run[1]/sql_run_option/spool/@suffix"/>
    </xsl:variable>
    
    <xsl:variable name="x_spool_gen_shell_env">
        <xsl:value-of select="//sql_run[1]/sql_run_option/spool/@gen_shell_env"/>
    </xsl:variable>
    
    <xsl:variable name="x_sql_gen_file">
        <xsl:value-of select="//sql_run[1]/drive_code"/>
    </xsl:variable>

    <xsl:variable name="v_sql_gen_full_file">
        <xsl:value-of select="$x_gen_output_dir"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$x_sql_gen_file"/>
        <xsl:text>.tmp</xsl:text>
    </xsl:variable>

    <xsl:variable name="x_par_count">
        <xsl:value-of select="count(//sql_run[1]/pars/par)"/>
    </xsl:variable>
    
    <xsl:variable name="x_sql_code">
        <xsl:value-of select="//sql_run[1]/sql_code"/>
    </xsl:variable>
    
    <xsl:variable name="v_usage_line">
        <xsl:value-of select="$x_sql_gen_file"/>

        <xsl:for-each select="//sql_run[1]/pars/par">
            <xsl:text> </xsl:text>
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="p_assign_cmd_var">
        <xsl:value-of select="$new_line"/>

        <xsl:for-each select="//sql_run[1]/pars/par">
            <xsl:value-of select="."/>
            <xsl:text>=${</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text>}</xsl:text>
            <xsl:value-of select="$new_line"/>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="p_date_stamp">
        <xsl:text>date_stamp=$(date "+%Y_%m_%d_%H_%M_%S")</xsl:text>
        <xsl:value-of select="$new_line"/>
    </xsl:variable>

    <xsl:variable name="p_sqlplus_block">
        <xsl:value-of select="$new_line"/>
        
        <xsl:variable name="l_spool_file">
            <xsl:choose>
                <xsl:when test="$x_spool_prefix eq 'cdb_pdb'">
                    <xsl:text>${CDB}_${PDB}_</xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:value-of select="$x_spool"/>
            <xsl:if test="$x_spool_suffix eq 'date'">
                <xsl:text>${date_stamp}</xsl:text>
            </xsl:if>
        </xsl:variable>
        
        <xsl:text>cat &lt;&lt; EOC &gt; </xsl:text>
        <xsl:value-of select="$l_spool_file"/>
        <xsl:value-of select="$new_line"/>
        <xsl:value-of select="$cdb_pdb_set_gen"/>
        
        <xsl:text>sqlplus / as sysdba @${HOME}/dba_code/pdb_code_gen_driver.sql ${PDB} ${CDB}_${PDB}_off_non_sys_jobs.sh.${date_stamp} </xsl:text>
        <xsl:value-of select="$x_sql_code"/>
        <xsl:value-of select="$new_line"/>

        <xsl:text>echo EOC &gt;&gt; </xsl:text>
        <xsl:value-of select="$l_spool_file"/>
        <xsl:value-of select="$new_line"/>
        
    </xsl:variable>
    
    <xsl:variable name="p_min_par_number_alert">
        <xsl:value-of select="$new_line"/>
        <xsl:text>if [ $# -lt </xsl:text>
        <xsl:value-of select="$x_min_par"/>
        <xsl:text> ]</xsl:text>
        <xsl:value-of select="$new_line"/>
        <xsl:text>then</xsl:text>
        <xsl:value-of select="$new_line"/>
        <xsl:text>  echo " "</xsl:text>
        <xsl:value-of select="$new_line"/>

        <xsl:text>  echo "</xsl:text>
        <xsl:value-of select="$v_usage_line"/>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="$new_line"/>

        <xsl:text>  echo " "</xsl:text>
        <xsl:value-of select="$new_line"/>
        <xsl:text>fi</xsl:text>
        <xsl:value-of select="$new_line"/>
        <xsl:value-of select="$new_line"/>
    </xsl:variable>

    <xsl:variable name="p_pdb_option_block">
        <xsl:value-of select="$new_line"/>
        <xsl:text>if [ $# -lt </xsl:text>
        <xsl:value-of select="$x_pdb_option_par"/>
        <xsl:text> ]</xsl:text>
        <xsl:value-of select="$new_line"/>
        <xsl:text>then</xsl:text>
        <xsl:value-of select="$new_line"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="$x_pdb_option"/>
        <xsl:text>=cdb\$root</xsl:text>
        <xsl:value-of select="$new_line"/>
        <xsl:text>else</xsl:text>
        <xsl:value-of select="$new_line"/>
        
        <xsl:text>  </xsl:text>
        <xsl:value-of select="$x_pdb_option"/>
        <xsl:text>=${</xsl:text>
        <xsl:value-of select="$x_pdb_option_par"/>
        <xsl:text>}</xsl:text>
        <xsl:value-of select="$new_line"/>
        
        <xsl:text>  echo " "</xsl:text>
        <xsl:value-of select="$new_line"/>
        <xsl:text>fi</xsl:text>
        <xsl:value-of select="$new_line"/>
        <xsl:value-of select="$new_line"/>
    </xsl:variable>
    
    <xsl:variable name="p_source_cdb">
        <xsl:text># sourcing CDB environment </xsl:text>
        <xsl:value-of select="$new_line"/>
        <xsl:text>. ${HOME}/${</xsl:text>
        <xsl:value-of select="$x_cdb_source"/>
        <xsl:text>}.env</xsl:text>
        <xsl:value-of select="$new_line"/>
        <xsl:value-of select="$new_line"/>
    </xsl:variable>

    <xsl:template match="/">

        <xsl:result-document href="{$v_sql_gen_full_file}" method="text">

            <xsl:value-of select="$shebang_line"/>

            <xsl:text># </xsl:text>
            <xsl:value-of select="$v_usage_line"/>
            <xsl:value-of select="$new_line"/>

            <xsl:value-of select="$p_min_par_number_alert"/>

            <xsl:value-of select="$p_assign_cmd_var"/>

            <xsl:value-of select="$p_source_cdb"/>
            
            <xsl:value-of select="$p_pdb_option_block"/>
            
            <xsl:value-of select="$p_date_stamp"/>
            
            <xsl:value-of select="$p_sqlplus_block"/>

        </xsl:result-document>

    </xsl:template>
</xsl:stylesheet>
