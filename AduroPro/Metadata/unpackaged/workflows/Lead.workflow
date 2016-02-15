<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Biometric_Vendor_Application</fullName>
        <description>Biometric Vendor Application</description>
        <protected>false</protected>
        <recipients>
            <recipient>mark.thompson@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Biometric_Planning_Emails/New_Biometric_Vendor_Lead_in_SF</template>
    </alerts>
    <alerts>
        <fullName>Limeade_Lead</fullName>
        <ccEmails>emily.chu@adurolife.com,</ccEmails>
        <description>Limeade Lead</description>
        <protected>false</protected>
        <recipients>
            <recipient>brian.kostewicz@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>laney.schorp@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mark.thompson@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Email_Templates/Limeade_Lead</template>
    </alerts>
    <fieldUpdates>
        <fullName>Limeade_Lead_Source</fullName>
        <description>Changes Lead Source to Limeade</description>
        <field>LeadSource</field>
        <literalValue>Limeade</literalValue>
        <name>Limeade Lead Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Biometric Vendor Application</fullName>
        <actions>
            <name>Biometric_Vendor_Application</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Web / Website</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Limeade Lead Notification</fullName>
        <actions>
            <name>Limeade_Lead</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Lead.ConnectionReceivedId</field>
            <operation>equals</operation>
            <value>Limeade</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Limeade Lead Source Automation</fullName>
        <actions>
            <name>Limeade_Lead_Source</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>contains</operation>
            <value>Connection User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Automatically updates Lead Source to Limeade if new lead is externally forwarded from Limeade.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Vendor Application</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Certifications__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
