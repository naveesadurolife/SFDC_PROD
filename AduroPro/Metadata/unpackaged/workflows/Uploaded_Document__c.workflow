<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Online_Physician_Form_Upload</fullName>
        <description>Online Physician Form Upload</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Templates/Online_Physician_Form_Upload</template>
    </alerts>
    <rules>
        <fullName>Online Physician Form Upload</fullName>
        <actions>
            <name>Online_Physician_Form_Upload</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
