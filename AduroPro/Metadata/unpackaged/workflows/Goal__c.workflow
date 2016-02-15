<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Health_Recovery_Exit_Survey</fullName>
        <description>Health Recovery: Exit Survey</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Coaching_Templates/Health_Recovery_Send_Exit_Survey</template>
    </alerts>
    <alerts>
        <fullName>Health_Transformation_Follow_Up_Steps</fullName>
        <description>Health Transformation Follow Up Steps</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Coaching_Templates/Kindred_Health_Transformation_follow_up</template>
    </alerts>
    <alerts>
        <fullName>Ignite_Coaching_Health_Recovery_Approval</fullName>
        <description>Ignite Coaching Health Recovery Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Coaching_Templates/Ignite_Coaching_Health_Recovery_Program</template>
    </alerts>
    <alerts>
        <fullName>Kindred_Health_Transformation_Acceptance_Letter</fullName>
        <description>Kindred Health Transformation Acceptance Letter</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Coaching_Templates/Kindred2_Health_Transformation_Acceptance_Letter</template>
    </alerts>
    <alerts>
        <fullName>Kindred_Health_Transformation_Denial_Letter</fullName>
        <description>Kindred Health Transformation Denial Letter</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Coaching_Templates/Kindred_Health_Transformation_Your_application_has_not_been_approved</template>
    </alerts>
    <alerts>
        <fullName>Kindred_Health_Transformation_Participation_Dismissed_Letter</fullName>
        <description>Kindred Health Transformation Participation Dismissed Letter</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Coaching_Templates/Kindred_Health_Transformation_Dismissal</template>
    </alerts>
    <rules>
        <fullName>3 Month Goal Check-In</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Goal__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Health Recovery%3A Send Exit Survey</fullName>
        <actions>
            <name>Health_Recovery_Exit_Survey</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Goal__c.Overall_Goal_Status__c</field>
            <operation>equals</operation>
            <value>Pending Exit Survey</value>
        </criteriaItems>
        <criteriaItems>
            <field>Goal__c.Goal_Name__c</field>
            <operation>equals</operation>
            <value>Health Recovery Program- PDMS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Goal__c.X6_Week_Engagement_Goal_Type__c</field>
            <operation>equals</operation>
            <value>Medical</value>
        </criteriaItems>
        <description>This workflow occurs when a Health Recovery goal status is changed to &quot;Pending Exit Survey&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Kindred Health Transformation%3A Acceptance Letter</fullName>
        <actions>
            <name>Kindred_Health_Transformation_Acceptance_Letter</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.AccountName</field>
            <operation>equals</operation>
            <value>Kindred Healthcare-Standard Population</value>
        </criteriaItems>
        <criteriaItems>
            <field>Goal__c.Overall_Goal_Status__c</field>
            <operation>equals</operation>
            <value>Application Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Goal__c.Goal_Name__c</field>
            <operation>equals</operation>
            <value>Health Recovery Program- PDMS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Limeade_Identifier_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow triggers an email to the participant when their Health Recovery Program application has been received and approved. This workflow sends an email requesting the participants signature on legal documents.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Kindred Health Transformation%3A Denial Letter</fullName>
        <actions>
            <name>Kindred_Health_Transformation_Denial_Letter</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.AccountName</field>
            <operation>equals</operation>
            <value>Kindred Healthcare-Standard Population</value>
        </criteriaItems>
        <criteriaItems>
            <field>Goal__c.Overall_Goal_Status__c</field>
            <operation>equals</operation>
            <value>Application Denied</value>
        </criteriaItems>
        <criteriaItems>
            <field>Goal__c.Goal_Name__c</field>
            <operation>equals</operation>
            <value>Health Recovery Program- PDMS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Limeade_Identifier_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow triggers an email to the participant when their Health Recovery Program application has been received and approved. This workflow sends an email requesting the participants signature on legal documents.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Kindred Health Transformation%3A Dismissed Letter</fullName>
        <actions>
            <name>Kindred_Health_Transformation_Participation_Dismissed_Letter</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.AccountName</field>
            <operation>equals</operation>
            <value>Kindred Healthcare-Standard Population</value>
        </criteriaItems>
        <criteriaItems>
            <field>Goal__c.Overall_Goal_Status__c</field>
            <operation>equals</operation>
            <value>Dismissed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Goal__c.Goal_Name__c</field>
            <operation>equals</operation>
            <value>Health Recovery Program- PDMS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Limeade_Identifier_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow triggers an email to the participant when their Health Recovery Program goal status has been changed to dismissed. This workflow sends an email letting the participant know they have been released from the program due to non-compliance.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Kindred Health Transformation%3A Follow Up Steps</fullName>
        <actions>
            <name>Health_Transformation_Follow_Up_Steps</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.AccountName</field>
            <operation>equals</operation>
            <value>Kindred Healthcare-Standard Population</value>
        </criteriaItems>
        <criteriaItems>
            <field>Goal__c.Overall_Goal_Status__c</field>
            <operation>equals</operation>
            <value>Application Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Goal__c.Goal_Name__c</field>
            <operation>equals</operation>
            <value>Health Recovery Program- PDMS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Limeade_Identifier_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow triggers an email to the participant when their Health Recovery Program application has been received and approved. This workflow sends an email requesting the participants confirm their shipping address.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Legal Document Request_ Health Recovery Program</fullName>
        <actions>
            <name>Ignite_Coaching_Health_Recovery_Approval</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Goal__c.X6_Week_Engagement_Goal_Type__c</field>
            <operation>equals</operation>
            <value>Medical</value>
        </criteriaItems>
        <criteriaItems>
            <field>Goal__c.Overall_Goal_Status__c</field>
            <operation>equals</operation>
            <value>Application Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Goal__c.Goal_Name__c</field>
            <operation>equals</operation>
            <value>Health Recovery Program- PDMS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Limeade_Identifier_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.AccountName</field>
            <operation>notEqual</operation>
            <value>Health Recovery Program</value>
        </criteriaItems>
        <description>This workflow triggers an email to the participant when their Health Recovery Program application has been received and approved. This workflow sends an email requesting the participants signature on legal documents.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
