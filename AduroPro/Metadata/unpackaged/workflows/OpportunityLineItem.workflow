<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Create_Monthly_Rev_Copy</fullName>
        <field>Monthly_Revenue_Reporting__c</field>
        <formula>Monthly_Revenue__c</formula>
        <name>Create Monthly Rev Copy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Product_Wholesale_Unit_Price</fullName>
        <description>Copy the Wholesale Price to the Opp Product</description>
        <field>Wholesale_Unit_Price__c</field>
        <formula>PricebookEntry.Wholesale_Price__c</formula>
        <name>Opportunity Product Wholesale Unit Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Setup_fee_Reporting</fullName>
        <field>Setup_Fee_Reporting__c</field>
        <formula>Setup_Fee__c</formula>
        <name>Update Setup fee Reporting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Monthly Rev Copy</fullName>
        <actions>
            <name>Create_Monthly_Rev_Copy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Monthly_Revenue__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>rule that copies the monthly revenue formula field to allow for roll up summary at the opportunity level.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Setup Fee Copy Reporting</fullName>
        <actions>
            <name>Update_Setup_fee_Reporting</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Setup_Fee__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wholesale Price</fullName>
        <actions>
            <name>Opportunity_Product_Wholesale_Unit_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
