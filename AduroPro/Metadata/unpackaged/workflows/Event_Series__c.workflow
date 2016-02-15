<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Onsite_Survey_URL_Update</fullName>
        <field>Onsite_Contact_Survey_URL__c</field>
        <formula>&quot;http://survey.clicktools.com/go?iv=3ch7pdq3zataw&amp;q1=&quot;+Id</formula>
        <name>Onsite Survey URL Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Onsite Contact Survey Link</fullName>
        <actions>
            <name>Onsite_Survey_URL_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event_Series__c.Series_Start_Date__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Creates URL for Onsite Contact Survey when Event Series is Created</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
