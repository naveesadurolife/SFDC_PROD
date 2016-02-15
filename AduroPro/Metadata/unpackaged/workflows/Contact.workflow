<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ADURO_Weekly_Pulse_Email</fullName>
        <description>ADURO Weekly Pulse Email</description>
        <protected>false</protected>
        <recipients>
            <field>Limeade_Identifier_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Coaching_Templates/Weekly_Pulse</template>
    </alerts>
    <alerts>
        <fullName>ADURO_Weekly_Pulse_Email_2</fullName>
        <description>ADURO Weekly Pulse Email (2)</description>
        <protected>false</protected>
        <recipients>
            <field>Limeade_Identifier_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Coaching_Templates/Weekly_Pulse</template>
    </alerts>
    <alerts>
        <fullName>ADURO_Weekly_Pulse_Ongoing_Send</fullName>
        <description>ADURO Weekly Pulse Ongoing Send</description>
        <protected>false</protected>
        <recipients>
            <field>Limeade_Identifier_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Coaching_Templates/Weekly_Pulse</template>
    </alerts>
    <alerts>
        <fullName>Consultation_Survey_Email</fullName>
        <description>Consultation Survey Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SURVEY_EAT_a0l70000001EBRYAA4</template>
    </alerts>
    <alerts>
        <fullName>Screener_Completed_Paperwork_Notification</fullName>
        <description>Screener Completed Paperwork Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>staffing@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Biometric_Planning_Emails/Screener_Paperwork_Complete</template>
    </alerts>
    <alerts>
        <fullName>Screener_Email_Opt_Out_Notification</fullName>
        <ccEmails>kate.watkins@adurolife.com</ccEmails>
        <description>Screener Email Opt Out Notification</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Biometric_Planning_Emails/Screener_Email_Opt_Out</template>
    </alerts>
    <fieldUpdates>
        <fullName>ADURO_Pulse_Last_Sent_Date</fullName>
        <description>This date updates when a weekly pulse email is sent.</description>
        <field>ADURO_Weekly_Pulse_Sent__c</field>
        <formula>NOW()</formula>
        <name>ADURO_Pulse Last Sent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADURO_Pulse_Last_Sent_Date2</fullName>
        <description>Updated date upon sending</description>
        <field>ADURO_Weekly_Pulse_Sent__c</field>
        <formula>Now()</formula>
        <name>ADURO_Pulse Last Sent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Contact_Type</fullName>
        <description>This will change the Contact Record Type to &quot;Client Onsite Contact&quot;</description>
        <field>RecordTypeId</field>
        <lookupValue>Client_Onsite_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Contact Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Screener_Email_Opt_Out</fullName>
        <field>HasOptedOutOfEmail</field>
        <literalValue>1</literalValue>
        <name>Screener Email Opt Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>ADURO_WeeklyPulse</fullName>
        <actions>
            <name>ADURO_Weekly_Pulse_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ADURO_Pulse_Last_Sent_Date2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>ADURO_Employee</value>
        </criteriaItems>
        <description>This workflow is set to send the weekly pulse email to ADURO employees.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ADURO_Weeklypulse_OngoingSend</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>ADURO_Employee</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.ADURO_Weekly_Pulse_Sent__c</field>
            <operation>greaterThan</operation>
            <value>8/1/2015</value>
        </criteriaItems>
        <description>This workflow sends out the weekly pulse survey.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ADURO_Weekly_Pulse_Ongoing_Send</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Consultation Survey</fullName>
        <actions>
            <name>Consultation_Survey_Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>*****Coachee*****</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Screener Opt Out</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contact.AccountName</field>
            <operation>equals</operation>
            <value>ADURO Screening Event Staff</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.HasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.CreatedDate</field>
            <operation>notEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>When screeners opt out of receive emails, this rule will run to notify Kate to remove them from Mail Chimp</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Screener 5 Priority Rating</fullName>
        <actions>
            <name>Screener_Email_Opt_Out</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>equals</operation>
            <value>ADURO Screening Event Staff</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Priority_Rating__c</field>
            <operation>equals</operation>
            <value>5</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Screener Email Opt Out</fullName>
        <actions>
            <name>Screener_Email_Opt_Out_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.AccountName</field>
            <operation>equals</operation>
            <value>ADURO Screening Event Staff</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.HasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Screener Paperwork Complete</fullName>
        <actions>
            <name>Screener_Completed_Paperwork_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Contact.AccountName</field>
            <operation>equals</operation>
            <value>ADURO Screening Event Staff</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.W_9_Signed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.CPR_Certification_Expiration__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Medical_License_Exipration__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.BG_Check_Consent_Signed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.IC_Agreement_Signed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Email</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Test</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
