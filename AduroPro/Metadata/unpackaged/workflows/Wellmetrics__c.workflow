<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Client_Launch</fullName>
        <ccEmails>mark@dynamicchiros.com</ccEmails>
        <description>New Client Launch</description>
        <protected>false</protected>
        <recipients>
            <recipient>darren.white@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Client_Launch</template>
    </alerts>
    <alerts>
        <fullName>New_Client_Launch_Email</fullName>
        <description>New Client Launch Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>darren.white@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Client_Launch</template>
    </alerts>
    <rules>
        <fullName>Build Site</fullName>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Wellmetrics__c.Development_Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Client Launch Email</fullName>
        <actions>
            <name>New_Client_Launch_Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Wellmetrics__c.Preferred_Launch_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This goes to Limeade and WW Ceo to notify them of a new client being launched on the platform.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WellCall Implementation</fullName>
        <actions>
            <name>WellCall_Notification</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Wellmetrics__c.Development_Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Wellmetrics__c.Preferred_Launch_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>WellCall_Notification</fullName>
        <assignedTo>carolyn.thayer@adurolife.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please send a notification to WellCall for new group</description>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>WellCall Notification</subject>
    </tasks>
</Workflow>
